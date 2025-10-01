import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:convert';

import '../models/user_profile.dart';
import '../models/firestore_achievement.dart';
import '../models/achievement.dart' as LocalAchievement;
import 'chad_evolution_service.dart';
import 'chad_level_manager.dart';
import 'achievement_service.dart';

/// 클라우드 동기화 서비스
/// 로컬 데이터와 Firestore 간의 동기화를 담당
class CloudSyncService {
  static final CloudSyncService _instance = CloudSyncService._internal();
  factory CloudSyncService() => _instance;
  CloudSyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<User?>? _authSubscription;

  bool _isOnline = true;
  bool _isSyncing = false;
  final List<Map<String, dynamic>> _pendingChanges = [];

  // 동기화 상태 스트림
  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;

  /// 서비스 초기화
  Future<void> initialize() async {
    // 인증 상태 모니터링
    _authSubscription = _auth.authStateChanges().listen(_onAuthStateChanged);

    // 네트워크 상태 모니터링
    _startConnectivityMonitoring();

    // 앱 시작 시 동기화 실행
    if (_auth.currentUser != null) {
      await syncUserData();
    }
  }

  /// 인증 상태 변경 처리
  void _onAuthStateChanged(User? user) {
    if (user != null) {
      // 로그인 시 동기화 실행
      syncUserData();
    } else {
      // 로그아웃 시 로컬 데이터 정리
      _clearLocalData();
    }
  }

  /// 네트워크 연결 상태 모니터링
  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final wasOnline = _isOnline;
      _isOnline =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);

      print('🌐 네트워크 상태 변경: ${_isOnline ? "온라인" : "오프라인"}');

      // 오프라인에서 온라인으로 복귀 시 자동 동기화
      if (!wasOnline && _isOnline && _auth.currentUser != null) {
        print('🔄 네트워크 복귀 - 자동 동기화 시작');
        Future.delayed(const Duration(seconds: 2), () {
          syncUserData();
        });
      }

      _syncStatusController
          .add(_isOnline ? SyncStatus.connected : SyncStatus.offline);
    });

    // 초기 네트워크 상태 확인
    _checkInitialConnectivity();
  }

  /// 초기 네트워크 상태 확인
  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOnline =
          result.isNotEmpty && !result.contains(ConnectivityResult.none);
      print('🌐 초기 네트워크 상태: ${_isOnline ? "온라인" : "오프라인"}');
    } catch (e) {
      print('❌ 네트워크 상태 확인 오류: $e');
      _isOnline = true; // 기본값으로 설정
    }
  }

  /// 사용자 데이터 전체 동기화
  Future<void> syncUserData() async {
    if (!_canSync()) return;

    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);

    try {
      final user = _auth.currentUser!;

      // 1. 사용자 프로필 동기화
      await _syncUserProfile(user.uid);

      // 2. Chad XP 및 레벨 동기화
      await _syncChadProgress(user.uid);

      // 3. 업적 동기화
      await _syncAchievements(user.uid);

      // 4. 운동 기록 동기화
      await _syncWorkoutRecords(user.uid);

      // 5. 설정 동기화
      await _syncUserSettings(user.uid);

      // 6. 대기 중인 변경사항 처리
      await _processPendingChanges();

      _syncStatusController.add(SyncStatus.synced);
      print('✅ 동기화 완료: ${user.email}');
    } catch (e) {
      _syncStatusController.add(SyncStatus.error);
      print('❌ 동기화 오류: $e');
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  /// 사용자 프로필 동기화
  Future<void> _syncUserProfile(String userId) async {
    try {
      // 로컬 프로필 데이터 가져오기
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('user_profile');

      if (profileJson != null) {
        final localProfile = UserProfile.fromMap(
            json.decode(profileJson) as Map<String, dynamic>);

        // Chad XP 및 레벨 데이터 통합
        final chadExperience =
            await ChadEvolutionService.getCurrentExperience();
        final chadLevel = await ChadEvolutionService.getCurrentLevel();
        final chadLevelManager = ChadLevelManager();
        await chadLevelManager.initialize();
        final chadLevelData = chadLevelManager.levelData;

        final updatedProfile = localProfile.copyWith(
          chadExperience: chadExperience,
          chadCurrentLevel: chadLevel,
          chadCurrentStage: chadLevelData.currentStageIndex,
          chadTotalLevelUps: chadLevelData.totalLevelUps,
          chadLastLevelUpAt: chadLevelData.lastLevelUpAt,
        );

        // Firestore에 저장
        await _firestore
            .collection('userProfiles')
            .doc(userId)
            .set(updatedProfile.toMap(), SetOptions(merge: true));

        print('✅ 사용자 프로필 동기화 완료');
      }
    } catch (e) {
      print('❌ 사용자 프로필 동기화 오류: $e');
      throw SyncException('사용자 프로필 동기화 실패', e);
    }
  }

  /// Chad 경험치 및 레벨 동기화
  Future<void> _syncChadProgress(String userId) async {
    try {
      // 로컬 Chad 데이터 수집
      final chadExperience = await ChadEvolutionService.getCurrentExperience();
      final chadLevel = await ChadEvolutionService.getCurrentLevel();
      final chadLevelManager = ChadLevelManager();
      await chadLevelManager.initialize();
      final chadLevelData = chadLevelManager.levelData;
      final xpProgress = await ChadEvolutionService.getXPProgress();

      // Chad 진행 상황 문서 생성/업데이트
      final chadProgressData = {
        'userId': userId,
        'experience': chadExperience,
        'currentLevel': chadLevel,
        'currentStage': chadLevelData.currentStageIndex,
        'totalLevelUps': chadLevelData.totalLevelUps,
        'xpProgress': xpProgress,
        'lastLevelUpAt': chadLevelData.lastLevelUpAt?.toIso8601String(),
        'lastUpdatedAt': chadLevelData.lastUpdatedAt?.toIso8601String(),
        'syncedAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firestore
          .collection('chadProgress')
          .doc(userId)
          .set(chadProgressData, SetOptions(merge: true));

      print('✅ Chad 진행 상황 동기화 완료 (XP: $chadExperience, Level: $chadLevel)');
    } catch (e) {
      print('❌ Chad 진행 상황 동기화 오류: $e');
      throw SyncException('Chad 진행 상황 동기화 실패', e);
    }
  }

  /// 업적 동기화 (로컬 Achievement → Firestore Achievement)
  Future<void> _syncAchievements(String userId) async {
    try {
      // 로컬 업적 데이터 가져오기
      final localAchievements =
          await AchievementService.getUnlockedAchievements();

      // Firestore 업적 컬렉션 참조
      final achievementsRef = _firestore.collection('achievements');

      // 배치 작업으로 업적 동기화
      final batch = _firestore.batch();
      int syncCount = 0;

      for (final localAchievement in localAchievements) {
        // 로컬 Achievement를 Firestore Achievement로 변환
        final firestoreAchievement =
            _convertToFirestoreAchievement(localAchievement, userId);

        final docRef = achievementsRef.doc(firestoreAchievement.id);
        batch.set(
            docRef, firestoreAchievement.toJson(), SetOptions(merge: true));
        syncCount++;
      }

      if (syncCount > 0) {
        await batch.commit();
        print('✅ 업적 동기화 완료 ($syncCount개)');
      }
    } catch (e) {
      print('❌ 업적 동기화 오류: $e');
      throw SyncException('업적 동기화 실패', e);
    }
  }

  /// 로컬 Achievement를 FirestoreAchievement로 변환
  FirestoreAchievement _convertToFirestoreAchievement(
      LocalAchievement.Achievement localAchievement, String userId) {
    // 업적 타입 매핑
    AchievementType achievementType;
    switch (localAchievement.type) {
      case 'workout':
        achievementType = AchievementType.totalWorkouts;
        break;
      case 'streak':
        achievementType = AchievementType.streakMilestone;
        break;
      case 'milestone':
        achievementType = AchievementType.pushupMilestone;
        break;
      case 'special':
        achievementType = AchievementType.specialEvent;
        break;
      default:
        achievementType = AchievementType.totalWorkouts;
    }

    // 희귀도 매핑
    AchievementRarity rarity;
    if (localAchievement.xpReward >= 500) {
      rarity = AchievementRarity.legendary;
    } else if (localAchievement.xpReward >= 200) {
      rarity = AchievementRarity.epic;
    } else if (localAchievement.xpReward >= 100) {
      rarity = AchievementRarity.rare;
    } else {
      rarity = AchievementRarity.common;
    }

    return FirestoreAchievement(
      id: '${userId}_${localAchievement.id}',
      userId: userId,
      achievementType: achievementType,
      title: localAchievement.title,
      description: localAchievement.description,
      requirement: AchievementRequirement(
        type: RequirementType.count,
        target: localAchievement.targetValue,
        unit: 'count',
      ),
      progress: localAchievement.currentValue,
      completed: localAchievement.isUnlocked,
      completedAt: localAchievement.unlockedAt,
      rarity: rarity,
      xpReward: localAchievement.xpReward,
      createdAt: DateTime.now(),
    );
  }

  /// 운동 기록 동기화
  Future<void> _syncWorkoutRecords(String userId) async {
    try {
      // 로컬 운동 기록이 있다면 Firestore와 동기화
      // 현재는 기본 구조만 구현
      print('✅ 운동 기록 동기화 완료 (구현 예정)');
    } catch (e) {
      print('❌ 운동 기록 동기화 오류: $e');
    }
  }

  /// 사용자 설정 동기화
  Future<void> _syncUserSettings(String userId) async {
    try {
      // 로컬 설정 데이터가 있다면 Firestore와 동기화
      // 현재는 기본 구조만 구현
      print('✅ 사용자 설정 동기화 완료 (구현 예정)');
    } catch (e) {
      print('❌ 사용자 설정 동기화 오류: $e');
    }
  }

  /// 대기 중인 변경사항 처리 (오프라인 모드용)
  Future<void> _processPendingChanges() async {
    if (_pendingChanges.isEmpty) return;

    try {
      print('📤 대기 중인 변경사항 처리 (${_pendingChanges.length}개)');

      // 각 변경사항을 순차적으로 처리
      for (final change in List<Map<String, dynamic>>.from(_pendingChanges)) {
        await _processChange(change);
        _pendingChanges.remove(change);
      }

      // 로컬 저장소에서 대기 목록 업데이트
      await _savePendingChanges();

      print('✅ 대기 중인 변경사항 처리 완료');
    } catch (e) {
      print('❌ 대기 중인 변경사항 처리 오류: $e');
    }
  }

  /// 개별 변경사항 처리
  Future<void> _processChange(Map<String, dynamic> change) async {
    final type = change['type'] as String;
    final data = change['data'] as Map<String, dynamic>;

    switch (type) {
      case 'chad_xp_update':
        await _syncChadProgress(data['userId'] as String);
        break;
      case 'achievement_update':
        await _syncAchievements(data['userId'] as String);
        break;
      case 'profile_update':
        await _syncUserProfile(data['userId'] as String);
        break;
      default:
        print('⚠️ 알 수 없는 변경사항 타입: $type');
    }
  }

  /// 동기화 가능 여부 확인
  bool _canSync() {
    return _auth.currentUser != null && _isOnline && !_isSyncing;
  }

  /// Chad XP 변경 알림 (로컬에서 호출)
  Future<void> onChadXPChanged() async {
    if (!_canSync()) {
      // 오프라인이면 대기 목록에 추가
      _addPendingChange('chad_xp_update', {
        'userId': _auth.currentUser!.uid,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return;
    }

    await _syncChadProgress(_auth.currentUser!.uid);
  }

  /// 업적 변경 알림 (로컬에서 호출)
  Future<void> onAchievementChanged() async {
    if (!_canSync()) {
      _addPendingChange('achievement_update', {
        'userId': _auth.currentUser!.uid,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return;
    }

    await _syncAchievements(_auth.currentUser!.uid);
  }

  /// 대기 목록에 변경사항 추가
  void _addPendingChange(String type, Map<String, dynamic> data) {
    _pendingChanges.add({
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _savePendingChanges();
  }

  /// 외부에서 대기 목록에 변경사항 추가 (public method)
  void queueChange(String type, Map<String, dynamic> data) {
    _addPendingChange(type, data);
  }

  /// 로컬 운동 기록과 클라우드 기록 병합
  Future<void> mergeWorkoutRecords() async {
    if (_auth.currentUser == null) return;

    try {
      print('🔄 운동 기록 병합 시작');
      final userId = _auth.currentUser!.uid;

      // 1. 로컬 운동 기록 가져오기
      final localWorkouts = await _getLocalWorkoutRecords();

      // 2. 클라우드 운동 기록 가져오기
      final cloudWorkouts = await _getCloudWorkoutRecords(userId);

      // 3. 병합 로직 실행
      final mergedWorkouts =
          await _mergeWorkoutData(localWorkouts, cloudWorkouts);

      // 4. 병합된 데이터를 클라우드에 저장
      await _saveMergedWorkouts(userId, mergedWorkouts);

      print('✅ 운동 기록 병합 완료: ${mergedWorkouts.length}개 기록');
    } catch (e) {
      print('❌ 운동 기록 병합 오류: $e');
    }
  }

  /// 로컬 운동 기록 가져오기
  Future<List<Map<String, dynamic>>> _getLocalWorkoutRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutHistoryJson = prefs.getStringList('workout_history') ?? [];

      return workoutHistoryJson.map((json) {
        final decoded = jsonDecode(json);
        return Map<String, dynamic>.from(decoded as Map);
      }).toList();
    } catch (e) {
      print('❌ 로컬 운동 기록 로드 오류: $e');
      return [];
    }
  }

  /// 클라우드 운동 기록 가져오기
  Future<List<Map<String, dynamic>>> _getCloudWorkoutRecords(
      String userId) async {
    try {
      final snapshot = await _firestore
          .collection('workoutRecords')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(100) // 최근 100개만
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('❌ 클라우드 운동 기록 로드 오류: $e');
      return [];
    }
  }

  /// 운동 기록 데이터 병합
  Future<List<Map<String, dynamic>>> _mergeWorkoutData(
    List<Map<String, dynamic>> localWorkouts,
    List<Map<String, dynamic>> cloudWorkouts,
  ) async {
    final Map<String, Map<String, dynamic>> mergedMap = {};

    // 클라우드 기록을 먼저 추가 (우선순위)
    for (final workout in cloudWorkouts) {
      final id = workout['id'] as String;
      mergedMap[id] = workout;
    }

    // 로컬 기록 처리 - 충돌 시 해결 로직 적용
    for (final workout in localWorkouts) {
      final id = workout['id'] as String;
      if (!mergedMap.containsKey(id)) {
        mergedMap[id] = workout;
      } else {
        // 충돌 발생 - 해결 로직 적용
        final resolved =
            await _resolveConflict(workout, mergedMap[id]!, 'workoutRecord');
        mergedMap[id] = resolved;
      }
    }

    // 날짜 순으로 정렬
    final mergedList = mergedMap.values.toList();
    mergedList.sort((a, b) {
      final dateA = DateTime.parse(a['date'] as String);
      final dateB = DateTime.parse(b['date'] as String);
      return dateB.compareTo(dateA); // 최신 순
    });

    return mergedList;
  }

  /// 병합된 운동 기록을 클라우드에 저장
  Future<void> _saveMergedWorkouts(
      String userId, List<Map<String, dynamic>> workouts) async {
    final batch = _firestore.batch();

    for (final workout in workouts) {
      final docRef =
          _firestore.collection('workoutRecords').doc(workout['id'] as String);
      batch.set(docRef, {
        ...workout,
        'userId': userId,
        'mergedAt': Timestamp.now(),
      });
    }

    await batch.commit();
    print('✅ ${workouts.length}개 운동 기록을 클라우드에 저장 완료');
  }

  /// 사용자 프로필 업데이트 및 동기화
  Future<void> updateUserProfile(Map<String, dynamic> profileData) async {
    if (_auth.currentUser == null) return;

    try {
      final userId = _auth.currentUser!.uid;
      print('👤 사용자 프로필 업데이트 시작: $userId');

      // 1. 로컬에 저장
      await _saveProfileLocally(profileData);

      // 2. 온라인 상태일 때만 클라우드 동기화
      if (_isOnline) {
        await _updateProfileInFirestore(userId, profileData);
        print('✅ 프로필 클라우드 동기화 완료');
      } else {
        // 오프라인일 때는 대기 큐에 추가
        queueChange('user_profile', {
          'action': 'update',
          'userId': userId,
          'data': profileData,
        });
        print('📝 오프라인 - 프로필 변경을 동기화 큐에 추가');
      }
    } catch (e) {
      print('❌ 프로필 업데이트 오류: $e');
    }
  }

  /// 로컬에 프로필 저장
  Future<void> _saveProfileLocally(Map<String, dynamic> profileData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile', json.encode(profileData));
      print('✅ 로컬 프로필 저장 완료');
    } catch (e) {
      print('❌ 로컬 프로필 저장 오류: $e');
    }
  }

  /// Firestore에 프로필 업데이트
  Future<void> _updateProfileInFirestore(
      String userId, Map<String, dynamic> profileData) async {
    try {
      // userProfiles 컬렉션 업데이트
      await _firestore.collection('userProfiles').doc(userId).update({
        ...profileData,
        'updatedAt': Timestamp.now(),
      });

      // users 컬렉션의 기본 정보도 업데이트 (필요한 경우)
      if (profileData.containsKey('displayName') ||
          profileData.containsKey('photoURL')) {
        final basicData = <String, dynamic>{};
        if (profileData.containsKey('displayName')) {
          basicData['displayName'] = profileData['displayName'];
        }
        if (profileData.containsKey('photoURL')) {
          basicData['photoURL'] = profileData['photoURL'];
        }
        basicData['lastLoginAt'] = Timestamp.now();

        await _firestore.collection('users').doc(userId).update(basicData);
      }

      print('✅ Firestore 프로필 업데이트 완료');
    } catch (e) {
      print('❌ Firestore 프로필 업데이트 오류: $e');
      rethrow;
    }
  }

  /// 프로필 설정 자동 감지 및 동기화
  Future<void> watchProfileChanges() async {
    if (_auth.currentUser == null) return;

    try {
      final userId = _auth.currentUser!.uid;

      // SharedPreferences 변경 감지는 Flutter에서 직접 지원하지 않으므로
      // 정기적으로 변경사항을 확인하는 방식 사용
      Timer.periodic(const Duration(minutes: 5), (timer) async {
        if (_auth.currentUser == null) {
          timer.cancel();
          return;
        }

        try {
          await _checkAndSyncProfileChanges(userId);
        } catch (e) {
          print('❌ 프로필 변경 감지 오류: $e');
        }
      });
    } catch (e) {
      print('❌ 프로필 감시 시작 오류: $e');
    }
  }

  /// 프로필 변경사항 확인 및 동기화
  Future<void> _checkAndSyncProfileChanges(String userId) async {
    try {
      // 로컬 프로필 가져오기
      final prefs = await SharedPreferences.getInstance();
      final localProfileJson = prefs.getString('user_profile');
      if (localProfileJson == null) return;

      final localProfile =
          json.decode(localProfileJson) as Map<String, dynamic>;

      // 마지막 동기화 시간 확인
      final lastSyncTime = prefs.getInt('profile_last_sync') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      // 5분 이상 지났고 온라인 상태일 때만 동기화
      if (currentTime - lastSyncTime > 300000 && _isOnline) {
        // 5분 = 300,000ms
        await _updateProfileInFirestore(userId, localProfile);
        await prefs.setInt('profile_last_sync', currentTime);
        print('🔄 자동 프로필 동기화 완료');
      }
    } catch (e) {
      print('❌ 프로필 변경사항 확인 오류: $e');
    }
  }

  /// 대기 중인 변경사항을 로컬 저장소에 저장
  Future<void> _savePendingChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'pending_sync_changes', json.encode(_pendingChanges));
    } catch (e) {
      print('❌ 대기 중인 변경사항 저장 오류: $e');
    }
  }

  /// 로컬 데이터 정리 (로그아웃 시)
  Future<void> _clearLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('pending_sync_changes');
      _pendingChanges.clear();
      print('✅ 로컬 동기화 데이터 정리 완료');
    } catch (e) {
      print('❌ 로컬 데이터 정리 오류: $e');
    }
  }

  /// 수동 동기화 트리거
  Future<void> forcSync() async {
    if (_auth.currentUser == null) {
      throw SyncException('로그인이 필요합니다', null);
    }

    await syncUserData();
  }

  /// 신규 사용자 프로필 생성 (회원가입 시)
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String displayName,
    required String provider,
    String? photoURL,
  }) async {
    try {
      final now = DateTime.now();

      // 1. users 컬렉션에 기본 정보 저장
      await _firestore.collection('users').doc(userId).set({
        'uid': userId,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'provider': provider,
        'isEmailVerified': _auth.currentUser?.emailVerified ?? false,
        'createdAt': Timestamp.fromDate(now),
        'lastLoginAt': Timestamp.fromDate(now),
        'status': 'active',
      });

      // 2. userProfiles 컬렉션에 상세 프로필 생성
      await _firestore.collection('userProfiles').doc(userId).set({
        'userId': userId,
        'nickname': displayName,
        'fitnessLevel': 'beginner',
        'goals': <String>[],
        'timezone': 'Asia/Seoul',
        'language': 'ko',
        'onboardingCompleted': false,
        'chadPersonality': 'motivational',
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      // 3. chadProgress 컬렉션에 Chad 진행 상황 초기화
      await _firestore.collection('chadProgress').doc(userId).set({
        'userId': userId,
        'level': 1,
        'xp': 0,
        'totalWorkouts': 0,
        'currentStage': 'rookie',
        'unlockedStages': <String>['rookie'],
        'evolutionHistory': <String>[],
        'lastWorkoutDate': null,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      // 4. workoutProgress 컬렉션에 운동 진행 상황 초기화
      await _firestore.collection('workoutProgress').doc(userId).set({
        'userId': userId,
        'currentWeek': 1,
        'currentDay': 1,
        'completedWorkouts': 0,
        'totalPushups': 0,
        'averageReps': 0,
        'bestSingleSet': 0,
        'streak': 0,
        'longestStreak': 0,
        'unlockedWeeks': <int>[1],
        'weeklyStats': <String, dynamic>{},
        'lastWorkoutDate': null,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      print('✅ 신규 사용자 프로필 생성 완료: $userId');
    } catch (e) {
      print('❌ 사용자 프로필 생성 오류: $e');
      throw SyncException('사용자 프로필 생성에 실패했습니다', e);
    }
  }

  /// 운동 기록을 Firestore에 동기화
  Future<void> syncWorkoutRecord(dynamic workoutHistory) async {
    if (_auth.currentUser == null) {
      throw SyncException('로그인이 필요합니다', null);
    }

    try {
      final userId = _auth.currentUser!.uid;
      final recordId = (workoutHistory.id as String?) ??
          DateTime.now().millisecondsSinceEpoch.toString();

      // workoutRecords 컬렉션에 개별 운동 기록 저장
      await _firestore.collection('workoutRecords').doc(recordId).set({
        'userId': userId,
        'id': recordId,
        'date': Timestamp.fromDate(workoutHistory.date as DateTime),
        'workoutTitle': workoutHistory.workoutTitle as String,
        'targetReps': (workoutHistory.targetReps as List).cast<int>(),
        'completedReps': (workoutHistory.completedReps as List).cast<int>(),
        'totalReps': workoutHistory.totalReps as int,
        'completionRate': workoutHistory.completionRate as double,
        'level': workoutHistory.level as String,
        'duration': (workoutHistory.duration as Duration).inSeconds,
        'createdAt': Timestamp.now(),
      });

      // workoutProgress 컬렉션 업데이트 (통계)
      await _updateWorkoutProgress(userId, workoutHistory);

      print('✅ 운동 기록 Firestore 동기화 완료: $recordId');
    } catch (e) {
      print('❌ 운동 기록 동기화 오류: $e');
      throw SyncException('운동 기록 동기화에 실패했습니다', e);
    }
  }

  /// 운동 진행 상황 업데이트
  Future<void> _updateWorkoutProgress(
      String userId, dynamic workoutHistory) async {
    try {
      final docRef = _firestore.collection('workoutProgress').doc(userId);
      final doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data()!;
        final completedWorkouts = (data['completedWorkouts'] as int? ?? 0) + 1;
        final totalPushups = (data['totalPushups'] as int? ?? 0) +
            (workoutHistory.totalReps as int);
        final averageReps = totalPushups / completedWorkouts;
        final bestSingleSet = data['bestSingleSet'] as int? ?? 0;
        final currentBest = (workoutHistory.completedReps as List<int>)
            .fold(0, (a, b) => a > b ? a : b);

        // 연속 운동 기록 계산
        final today = DateTime.now();
        final lastWorkoutDate = data['lastWorkoutDate']?.toDate();
        var streak = data['streak'] as int? ?? 0;

        if (lastWorkoutDate == null) {
          streak = 1;
        } else {
          final daysDiff = today.difference(lastWorkoutDate as DateTime).inDays;
          if (daysDiff == 1) {
            streak += 1;
          } else if (daysDiff > 1) {
            streak = 1;
          }
        }

        await docRef.update({
          'completedWorkouts': completedWorkouts,
          'totalPushups': totalPushups,
          'averageReps': averageReps.round(),
          'bestSingleSet':
              currentBest > bestSingleSet ? currentBest : bestSingleSet,
          'streak': streak,
          'longestStreak': streak > (data['longestStreak'] as int? ?? 0)
              ? streak
              : (data['longestStreak'] as int? ?? 0),
          'lastWorkoutDate': Timestamp.fromDate(today),
          'updatedAt': Timestamp.now(),
        });

        print('✅ 운동 진행 상황 업데이트 완료');
      }
    } catch (e) {
      print('❌ 운동 진행 상황 업데이트 오류: $e');
    }
  }

  /// 충돌 해결 로직 구현
  Future<Map<String, dynamic>> _resolveConflict(
    Map<String, dynamic> localData,
    Map<String, dynamic> cloudData,
    String dataType,
  ) async {
    try {
      print('🔄 충돌 해결 시작: $dataType');

      // 1. 타임스탬프 비교
      final localTimestamp = _parseTimestamp(localData['updatedAt']);
      final cloudTimestamp = _parseTimestamp(cloudData['updatedAt']);

      // 2. 데이터 타입별 특별 처리
      switch (dataType) {
        case 'userProfile':
          return _resolveUserProfileConflict(
              localData, cloudData, localTimestamp, cloudTimestamp);
        case 'workoutRecord':
          return _resolveWorkoutRecordConflict(
              localData, cloudData, localTimestamp, cloudTimestamp);
        case 'achievement':
          return _resolveAchievementConflict(
              localData, cloudData, localTimestamp, cloudTimestamp);
        case 'userSettings':
          return _resolveUserSettingsConflict(
              localData, cloudData, localTimestamp, cloudTimestamp);
        default:
          // 기본적으로 최신 타임스탬프 데이터 선택
          return cloudTimestamp.isAfter(localTimestamp) ? cloudData : localData;
      }
    } catch (e) {
      print('❌ 충돌 해결 오류: $e');
      // 오류 발생 시 클라우드 데이터 우선
      return cloudData;
    }
  }

  /// 타임스탬프 파싱 헬퍼
  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime(1970);
    if (timestamp is DateTime) return timestamp;
    if (timestamp is String) {
      return DateTime.tryParse(timestamp) ?? DateTime(1970);
    }
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (timestamp is Timestamp) return timestamp.toDate();
    return DateTime(1970);
  }

  /// 사용자 프로필 충돌 해결
  Map<String, dynamic> _resolveUserProfileConflict(
    Map<String, dynamic> localData,
    Map<String, dynamic> cloudData,
    DateTime localTimestamp,
    DateTime cloudTimestamp,
  ) {
    // 사용자 프로필은 특정 필드별로 병합
    final resolved = Map<String, dynamic>.from(localData);

    // 기본 정보는 최신 데이터 우선
    if (cloudTimestamp.isAfter(localTimestamp)) {
      resolved['displayName'] =
          cloudData['displayName'] ?? resolved['displayName'];
      resolved['email'] = cloudData['email'] ?? resolved['email'];
      resolved['photoURL'] = cloudData['photoURL'] ?? resolved['photoURL'];
    }

    // 운동 관련 데이터는 더 진전된 값 선택
    final localLevel = (localData['currentLevel'] as int?) ?? 0;
    final cloudLevel = (cloudData['currentLevel'] as int?) ?? 0;
    resolved['currentLevel'] =
        localLevel > cloudLevel ? localLevel : cloudLevel;

    final localTotalReps = (localData['totalReps'] as int?) ?? 0;
    final cloudTotalReps = (cloudData['totalReps'] as int?) ?? 0;
    resolved['totalReps'] =
        localTotalReps > cloudTotalReps ? localTotalReps : cloudTotalReps;

    final localStreak = (localData['currentStreak'] as int?) ?? 0;
    final cloudStreak = (cloudData['currentStreak'] as int?) ?? 0;
    resolved['currentStreak'] =
        localStreak > cloudStreak ? localStreak : cloudStreak;

    // 최신 타임스탬프로 업데이트
    resolved['updatedAt'] = cloudTimestamp.isAfter(localTimestamp)
        ? cloudTimestamp.toIso8601String()
        : localTimestamp.toIso8601String();

    print('✅ 사용자 프로필 충돌 해결 완료');
    return resolved;
  }

  /// 운동 기록 충돌 해결
  Map<String, dynamic> _resolveWorkoutRecordConflict(
    Map<String, dynamic> localData,
    Map<String, dynamic> cloudData,
    DateTime localTimestamp,
    DateTime cloudTimestamp,
  ) {
    // 운동 기록은 더 완전한 데이터 선택
    final localCompletionRate = (localData['completionRate'] as double?) ?? 0.0;
    final cloudCompletionRate = (cloudData['completionRate'] as double?) ?? 0.0;

    // 완료율이 더 높은 데이터 선택
    if (localCompletionRate > cloudCompletionRate) {
      print('✅ 운동 기록 충돌 해결: 로컬 데이터 선택 (완료율 우선)');
      return localData;
    } else if (cloudCompletionRate > localCompletionRate) {
      print('✅ 운동 기록 충돌 해결: 클라우드 데이터 선택 (완료율 우선)');
      return cloudData;
    }

    // 완료율이 같으면 최신 데이터 선택
    final result =
        cloudTimestamp.isAfter(localTimestamp) ? cloudData : localData;
    print('✅ 운동 기록 충돌 해결: 타임스탬프 기준 선택');
    return result;
  }

  /// 성취 충돌 해결
  Map<String, dynamic> _resolveAchievementConflict(
    Map<String, dynamic> localData,
    Map<String, dynamic> cloudData,
    DateTime localTimestamp,
    DateTime cloudTimestamp,
  ) {
    // 성취는 더 진전된 데이터 선택
    final localProgress = (localData['progress'] as int?) ?? 0;
    final cloudProgress = (cloudData['progress'] as int?) ?? 0;
    final localCompleted = localData['completed'] as bool? ?? false;
    final cloudCompleted = cloudData['completed'] as bool? ?? false;

    // 이미 완료된 성취가 있다면 완료된 것 선택
    if (localCompleted && !cloudCompleted) {
      print('✅ 성취 충돌 해결: 로컬 완료 데이터 선택');
      return localData;
    } else if (cloudCompleted && !localCompleted) {
      print('✅ 성취 충돌 해결: 클라우드 완료 데이터 선택');
      return cloudData;
    }

    // 둘 다 미완료면 진행도가 높은 것 선택
    if (!localCompleted && !cloudCompleted) {
      final result = localProgress > cloudProgress ? localData : cloudData;
      print('✅ 성취 충돌 해결: 진행도 기준 선택');
      return result;
    }

    // 둘 다 완료면 먼저 완료된 것 선택 (타임스탬프 기준)
    final result =
        cloudTimestamp.isAfter(localTimestamp) ? cloudData : localData;
    print('✅ 성취 충돌 해결: 완료 시점 기준 선택');
    return result;
  }

  /// 사용자 설정 충돌 해결
  Map<String, dynamic> _resolveUserSettingsConflict(
    Map<String, dynamic> localData,
    Map<String, dynamic> cloudData,
    DateTime localTimestamp,
    DateTime cloudTimestamp,
  ) {
    // 설정은 필드별로 개별 병합
    final resolved = Map<String, dynamic>.from(localData);

    // 각 설정 필드를 최신 타임스탬프 기준으로 선택
    if (cloudTimestamp.isAfter(localTimestamp)) {
      // 알림 설정
      if (cloudData.containsKey('notificationEnabled')) {
        resolved['notificationEnabled'] = cloudData['notificationEnabled'];
      }
      if (cloudData.containsKey('reminderTime')) {
        resolved['reminderTime'] = cloudData['reminderTime'];
      }

      // 테마 설정
      if (cloudData.containsKey('themeMode')) {
        resolved['themeMode'] = cloudData['themeMode'];
      }
      if (cloudData.containsKey('locale')) {
        resolved['locale'] = cloudData['locale'];
      }

      // 운동 설정
      if (cloudData.containsKey('defaultRestTime')) {
        resolved['defaultRestTime'] = cloudData['defaultRestTime'];
      }
      if (cloudData.containsKey('soundEnabled')) {
        resolved['soundEnabled'] = cloudData['soundEnabled'];
      }

      resolved['updatedAt'] = cloudTimestamp.toIso8601String();
    }

    print('✅ 사용자 설정 충돌 해결 완료');
    return resolved;
  }

  /// 서비스 정리
  void dispose() {
    _connectivitySubscription?.cancel();
    _authSubscription?.cancel();
    _syncStatusController.close();
  }
}

/// 동기화 상태 열거형
enum SyncStatus {
  idle, // 대기 중
  syncing, // 동기화 중
  synced, // 동기화 완료
  error, // 오류 발생
  offline, // 오프라인
  connected, // 온라인 연결됨
}

/// 동기화 예외 클래스
class SyncException implements Exception {
  final String message;
  final dynamic originalError;

  SyncException(this.message, this.originalError);

  @override
  String toString() => 'SyncException: $message';
}
