import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../models/user_subscription.dart';
import '../widgets/dialogs/vip_welcome_dialog.dart';
import 'cloud_sync_service.dart';
import 'deep_link_handler.dart';

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
      final String message = _getErrorMessage(e.code);
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

        // VIP 경험 제공
        await _onLoginSuccess(credential.user!);

        return AuthResult.success(credential.user!);
      } else {
        return AuthResult.failure('로그인에 실패했습니다.');
      }
    } on FirebaseAuthException catch (e) {
      final String message = _getErrorMessage(e.code);
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
          await _createUserProfile(userCredential.user!,
              userCredential.user!.displayName ?? 'Google User');
        }

        debugPrint('✅ Google 로그인 성공');

        // VIP 경험 제공
        await _onLoginSuccess(userCredential.user!);

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
      final String message = _getErrorMessage(e.code);
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

      final cloudSyncService = CloudSyncService();

      // Firestore에서 구독 정보 로드
      var subscription = await cloudSyncService.loadSubscription(userId);

      // Firestore에 구독 정보가 없으면 로컬에서 시도
      if (subscription == null) {
        subscription = await cloudSyncService.loadSubscriptionLocally();
      }

      // 둘 다 없으면 런칭 이벤트 구독 생성
      if (subscription == null) {
        debugPrint('ℹ️ 구독 정보 없음 - 런칭 이벤트 구독 생성');
        subscription = UserSubscription.createLaunchPromoSubscription(userId);

        // 새로 생성한 구독 정보를 저장
        await cloudSyncService.saveSubscription(subscription);
        await cloudSyncService.saveSubscriptionLocally(subscription);
      }

      // 구독 만료 확인 및 자동 갱신/다운그레이드
      if (subscription.isExpired && subscription.type == SubscriptionType.launchPromo) {
        debugPrint('⚠️ 런칭 프로모션 만료 - 무료 구독으로 다운그레이드');

        // 무료 구독으로 전환
        subscription = UserSubscription.createFreeSubscription(userId);

        // 다운그레이드된 구독 정보 저장
        await cloudSyncService.saveSubscription(subscription);
        await cloudSyncService.saveSubscriptionLocally(subscription);

        debugPrint('✅ 무료 구독으로 자동 전환 완료 (Week 1-2, 광고 있음)');
      } else if (subscription.isExpired && subscription.type == SubscriptionType.premium) {
        debugPrint('⚠️ 프리미엄 구독 만료 - 자동 갱신 확인 중...');

        // Google Play 구독 상태 확인 (자동 갱신 여부)
        final isRenewed = await _checkAndRenewSubscription(userId);

        if (isRenewed) {
          // 자동 갱신 성공 - 새로운 구독 생성
          subscription = UserSubscription.createPremiumSubscription(userId);

          await cloudSyncService.saveSubscription(subscription);
          await cloudSyncService.saveSubscriptionLocally(subscription);

          debugPrint('✅ 프리미엄 구독 자동 갱신 완료 (30일 연장)');
        } else {
          // 자동 갱신 실패 또는 취소 - 무료로 다운그레이드
          subscription = UserSubscription.createFreeSubscription(userId);

          await cloudSyncService.saveSubscription(subscription);
          await cloudSyncService.saveSubscriptionLocally(subscription);

          debugPrint('✅ 무료 구독으로 자동 전환 완료 (갱신 실패)');
        }
      }

      _currentSubscription = subscription;
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

      final subscription =
          UserSubscription.createLaunchPromoSubscription(userId);
      _currentSubscription = subscription;

      // Firestore와 로컬에 구독 정보 저장
      final cloudSyncService = CloudSyncService();
      await cloudSyncService.saveSubscription(subscription);
      await cloudSyncService.saveSubscriptionLocally(subscription);

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
        provider: user.providerData.isNotEmpty
            ? user.providerData.first.providerId
            : 'email',
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

      // Firestore와 로컬에 구독 정보 업데이트
      final cloudSyncService = CloudSyncService();
      await cloudSyncService.saveSubscription(premiumSubscription);
      await cloudSyncService.saveSubscriptionLocally(premiumSubscription);

      // 결제 처리는 BillingService.purchaseSubscription()을 통해 수행됨

      notifyListeners();

      debugPrint('✅ 프리미엄 구독 업그레이드 완료');
      return true;
    } catch (e) {
      debugPrint('❌ 프리미엄 구독 업그레이드 오류: $e');
      return false;
    }
  }

  // VIP 로그인 경험 - 회원에게 프리미엄 경험 제공
  Future<void> _onLoginSuccess(User user) async {
    try {
      debugPrint('🎉 VIP 로그인 경험 시작 - ${user.displayName ?? user.email}');

      final cloudSyncService = CloudSyncService();

      // 1. 환영 메시지 (구독 타입 기반)
      await _showWelcomeMessage(user);

      // 2. 자동 복원 - 구독 정보
      debugPrint('💎 구독 정보 자동 복원 중...');
      await _loadUserSubscription(user.uid);

      // 3. 자동 동기화 - 클라우드 데이터
      debugPrint('☁️ 클라우드 데이터 자동 동기화 중...');
      await cloudSyncService.syncUserData();

      // 4. 보류 중인 구매 완료
      debugPrint('💳 보류 중인 구매 확인 중...');
      await _completePendingPurchases();

      // 5. 데이터 프리로드 (백그라운드)
      debugPrint('⚡ 사용자 데이터 프리로드 중...');
      _preloadUserData(user.uid); // 백그라운드에서 실행

      debugPrint('✅ VIP 로그인 경험 완료 - 빠른 로딩 준비 완료!');
    } catch (e) {
      debugPrint('⚠️ VIP 로그인 경험 오류: $e');
      // 오류가 로그인 자체를 방해하지 않도록 예외를 던지지 않음
    }
  }

  // 환영 메시지 표시 (구독 타입 기반 VIP 대우)
  Future<void> _showWelcomeMessage(User user) async {
    final userName = user.displayName ?? '회원님';

    if (_currentSubscription == null) {
      debugPrint('👋 안녕하세요, $userName!');
      return;
    }

    // 콘솔 로그
    switch (_currentSubscription!.type) {
      case SubscriptionType.premium:
        final days = _currentSubscription!.remainingDays;
        if (days != null) {
          debugPrint('✨ 프리미엄 $userName님, 환영합니다! ($days일 남음)');
        } else {
          debugPrint('💎 프리미엄 $userName님, 환영합니다! (VIP)');
        }
        break;
      case SubscriptionType.launchPromo:
        final days = _currentSubscription!.remainingDays ?? 0;
        debugPrint('🎉 런칭 프로모션 $userName님, 환영합니다! ($days일 남음)');
        break;
      case SubscriptionType.free:
        debugPrint('👋 $userName님, 환영합니다!');
        break;
    }

    // VIP 환영 다이얼로그 표시 (프리미엄/프로모션만)
    if (_currentSubscription!.type == SubscriptionType.premium ||
        _currentSubscription!.type == SubscriptionType.launchPromo) {
      // 약간의 딜레이 후 표시 (UX 개선)
      await Future.delayed(const Duration(milliseconds: 800));

      final context = DeepLinkHandler.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => VIPWelcomeDialog(
            userName: userName,
            subscription: _currentSubscription!,
          ),
        );
      }
    }
  }

  // 보류 중인 구매 완료
  Future<void> _completePendingPurchases() async {
    try {
      // BillingService의 completePendingPurchase() 호출은
      // 순환 참조를 피하기 위해 BillingService에서 직접 호출하도록 설계됨
      debugPrint('ℹ️ 보류 중인 구매는 BillingService에서 처리됩니다');
    } catch (e) {
      debugPrint('⚠️ 보류 중인 구매 확인 오류: $e');
    }
  }

  // 구독 자동 갱신 확인
  Future<bool> _checkAndRenewSubscription(String userId) async {
    try {
      debugPrint('🔄 구독 자동 갱신 확인 중...');

      // TODO: Google Play Billing을 통한 실제 구독 상태 확인
      // 현재는 임시로 false 반환 (구현 필요)
      // 실제 구현 시:
      // 1. BillingService를 통해 Google Play에 구독 상태 조회
      // 2. autoRenewing 플래그 확인
      // 3. 갱신 성공 시 true, 실패/취소 시 false 반환

      debugPrint('⚠️ 자동 갱신 확인은 Google Play Billing 연동 후 구현 예정');
      return false; // 임시로 false 반환

      // 실제 구현 예시:
      // final billingService = BillingService();
      // final isActive = await billingService.isSubscriptionActive('premium_monthly');
      // return isActive;

    } catch (e) {
      debugPrint('❌ 구독 자동 갱신 확인 오류: $e');
      return false;
    }
  }

  // 사용자 데이터 프리로드 (백그라운드)
  void _preloadUserData(String userId) {
    // 백그라운드에서 비동기 실행 (await 없이)
    Future.microtask(() async {
      try {
        final cloudSyncService = CloudSyncService();

        // 모든 데이터를 한 번에 프리로드 (병렬 실행으로 성능 최적화)
        await cloudSyncService.preloadAllUserData(userId);

        debugPrint('✅ VIP 데이터 프리로드 완료 - 앱 사용 준비 완료!');
      } catch (e) {
        debugPrint('⚠️ 데이터 프리로드 오류: $e');
      }
    });
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
