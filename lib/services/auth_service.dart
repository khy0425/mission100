import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_subscription.dart';
import 'cloud_sync_service.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;

  const AuthResult({
    required this.success,
    this.errorMessage,
    this.user,
  });

  factory AuthResult.success(User user) {
    return AuthResult(success: true, user: user);
  }

  factory AuthResult.failure(String error) {
    return AuthResult(success: false, errorMessage: error);
  }
}

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _currentUser;
  UserSubscription? _currentSubscription;
  bool _isLoading = false;

  // Getters
  User? get currentUser => _currentUser;
  UserSubscription? get currentSubscription => _currentSubscription;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isGuest => _currentUser == null;

  // 초기화
  Future<void> initialize() async {
    debugPrint('🔐 AuthService 초기화 시작');

    try {
      // Firebase Auth 상태 변경 리스너
      _auth.authStateChanges().listen((User? user) {
        _currentUser = user;
        debugPrint('🔐 Auth 상태 변경: ${user?.uid ?? "로그아웃"}');

        if (user != null) {
          _loadUserSubscription(user.uid);
        } else {
          _currentSubscription = null;
        }

        notifyListeners();
      });

      // 현재 사용자 확인
      _currentUser = _auth.currentUser;
      if (_currentUser != null) {
        await _loadUserSubscription(_currentUser!.uid);
      }

      debugPrint('✅ AuthService 초기화 완료');
    } catch (e) {
      debugPrint('❌ AuthService 초기화 오류: $e');
    }
  }

  // 이메일 회원가입
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);

    try {
      debugPrint('📧 이메일 회원가입 시도: $email');

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // 사용자 프로필 업데이트
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
        _currentUser = _auth.currentUser;

        // 런칭 이벤트 구독 생성
        await _createLaunchPromoSubscription(credential.user!.uid);

        // Firestore에 사용자 프로필 생성
        await _createUserProfile(credential.user!, displayName);

        debugPrint('✅ 이메일 회원가입 성공');
        return AuthResult.success(credential.user!);
      } else {
        return AuthResult.failure('회원가입에 실패했습니다.');
      }
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      debugPrint('❌ 이메일 회원가입 오류: ${e.code} - $message');
      return AuthResult.failure(message);
    } catch (e) {
      debugPrint('❌ 이메일 회원가입 오류: $e');
      return AuthResult.failure('회원가입 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }

  // 이메일 로그인
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      debugPrint('📧 이메일 로그인 시도: $email');

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        debugPrint('✅ 이메일 로그인 성공');
        return AuthResult.success(credential.user!);
      } else {
        return AuthResult.failure('로그인에 실패했습니다.');
      }
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      debugPrint('❌ 이메일 로그인 오류: ${e.code} - $message');
      return AuthResult.failure(message);
    } catch (e) {
      debugPrint('❌ 이메일 로그인 오류: $e');
      return AuthResult.failure('로그인 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }

  // Google 로그인
  Future<AuthResult> signInWithGoogle() async {
    _setLoading(true);

    try {
      debugPrint('🔍 Google 로그인 시도');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('Google 로그인 취소됨');
        return AuthResult.failure('로그인이 취소되었습니다.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // 신규 사용자인 경우 런칭 이벤트 구독 생성 및 프로필 생성
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          await _createLaunchPromoSubscription(userCredential.user!.uid);
          await _createUserProfile(userCredential.user!, userCredential.user!.displayName ?? 'Google User');
        }

        debugPrint('✅ Google 로그인 성공');
        return AuthResult.success(userCredential.user!);
      } else {
        return AuthResult.failure('Google 로그인에 실패했습니다.');
      }
    } catch (e) {
      debugPrint('❌ Google 로그인 오류: $e');
      return AuthResult.failure('Google 로그인 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      debugPrint('🚪 로그아웃 시작');

      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      _currentUser = null;
      _currentSubscription = null;
      notifyListeners();

      debugPrint('✅ 로그아웃 완료');
    } catch (e) {
      debugPrint('❌ 로그아웃 오류: $e');
    }
  }

  // 비밀번호 재설정
  Future<AuthResult> resetPassword(String email) async {
    try {
      debugPrint('🔑 비밀번호 재설정 이메일 전송: $email');

      await _auth.sendPasswordResetEmail(email: email);

      debugPrint('✅ 비밀번호 재설정 이메일 전송 완료');
      return AuthResult.success(_auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      debugPrint('❌ 비밀번호 재설정 오류: ${e.code} - $message');
      return AuthResult.failure(message);
    } catch (e) {
      debugPrint('❌ 비밀번호 재설정 오류: $e');
      return AuthResult.failure('비밀번호 재설정 중 오류가 발생했습니다.');
    }
  }

  // 게스트로 계속하기 (임시 계정)
  Future<void> continueAsGuest() async {
    debugPrint('👤 게스트 모드로 계속');

    // 무료 구독 생성 (게스트용)
    _currentSubscription = UserSubscription.createFreeSubscription('guest');
    notifyListeners();
  }

  // 사용자 구독 정보 로드
  Future<void> _loadUserSubscription(String userId) async {
    try {
      debugPrint('📊 사용자 구독 정보 로드: $userId');

      // TODO: Firestore에서 구독 정보 로드
      // 현재는 임시로 런칭 이벤트 구독 생성
      _currentSubscription = UserSubscription.createLaunchPromoSubscription(userId);

      debugPrint('✅ 구독 정보 로드 완료: ${_currentSubscription?.type}');
    } catch (e) {
      debugPrint('❌ 구독 정보 로드 오류: $e');
      // 오류 시 무료 구독으로 대체
      _currentSubscription = UserSubscription.createFreeSubscription(userId);
    }
  }

  // 런칭 이벤트 구독 생성
  Future<void> _createLaunchPromoSubscription(String userId) async {
    try {
      debugPrint('🎉 런칭 이벤트 구독 생성: $userId');

      final subscription = UserSubscription.createLaunchPromoSubscription(userId);
      _currentSubscription = subscription;

      // TODO: Firestore에 구독 정보 저장

      debugPrint('✅ 런칭 이벤트 구독 생성 완료');
    } catch (e) {
      debugPrint('❌ 런칭 이벤트 구독 생성 오류: $e');
    }
  }

  // Firestore에 사용자 프로필 생성
  Future<void> _createUserProfile(User user, String displayName) async {
    try {
      debugPrint('👤 Firestore 사용자 프로필 생성: ${user.uid}');

      final cloudSyncService = CloudSyncService();
      await cloudSyncService.createUserProfile(
        userId: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        provider: user.providerData.isNotEmpty ? user.providerData.first.providerId : 'email',
        photoURL: user.photoURL,
      );

      debugPrint('✅ Firestore 사용자 프로필 생성 완료');
    } catch (e) {
      debugPrint('❌ Firestore 사용자 프로필 생성 오류: $e');
      // 프로필 생성 실패가 회원가입을 방해하지 않도록 예외를 던지지 않음
    }
  }

  // 구독 업그레이드
  Future<bool> upgradeToPremium() async {
    if (_currentUser == null) return false;

    try {
      debugPrint('💎 프리미엄 구독 업그레이드');

      final premiumSubscription = UserSubscription.createPremiumSubscription(
        _currentUser!.uid,
      );
      _currentSubscription = premiumSubscription;

      // TODO: Firestore에 구독 정보 업데이트
      // TODO: 결제 처리

      notifyListeners();

      debugPrint('✅ 프리미엄 구독 업그레이드 완료');
      return true;
    } catch (e) {
      debugPrint('❌ 프리미엄 구독 업그레이드 오류: $e');
      return false;
    }
  }


  // 편의 메서드들
  bool canAccessWeek(int week) {
    return _currentSubscription?.canAccessWeek(week) ?? false;
  }

  bool hasFeature(String feature) {
    return _currentSubscription?.hasFeature(feature) ?? false;
  }

  bool get hasAds {
    return _currentSubscription?.hasAds ?? true;
  }

  int? get remainingDays {
    return _currentSubscription?.remainingDays;
  }

  // 내부 헬퍼 메서드들
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return '비밀번호가 너무 약합니다.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'invalid-email':
        return '잘못된 이메일 형식입니다.';
      case 'user-not-found':
        return '사용자를 찾을 수 없습니다.';
      case 'wrong-password':
        return '잘못된 비밀번호입니다.';
      case 'user-disabled':
        return '비활성화된 계정입니다.';
      case 'too-many-requests':
        return '너무 많은 시도입니다. 잠시 후 다시 시도해주세요.';
      case 'operation-not-allowed':
        return '허용되지 않은 작업입니다.';
      default:
        return '인증 오류가 발생했습니다. ($errorCode)';
    }
  }
}