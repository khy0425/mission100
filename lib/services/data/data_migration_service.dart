import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import '../data/cloud_sync_service.dart';

/// 로컬 데이터 → Firebase 마이그레이션 서비스
class DataMigrationService {
  static final DataMigrationService _instance = DataMigrationService._internal();
  factory DataMigrationService() => _instance;
  DataMigrationService._internal();

  final CloudSyncService _cloudSync = CloudSyncService();

  /// 비회원 → 회원 전환 시 데이터 마이그레이션
  Future<MigrationResult> migrateLocalDataToFirebase() async {
    try {
      debugPrint('📤 로컬 데이터 마이그레이션 시작...');

      // 1. Firebase 사용자 확인
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다');
      }

      final result = MigrationResult();

      // 2. 로컬 데이터 읽기
      debugPrint('📖 로컬 데이터 읽기...');
      final prefs = await SharedPreferences.getInstance();

      // 2-1. 사용자 프로필
      final profileJson = prefs.getString('user_profile');
      if (profileJson != null) {
        try {
          final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;

          // Firestore에 업로드
          await _cloudSync.createUserProfile(
            userId: user.uid,
            email: user.email ?? '',
            displayName: profileMap['name'] ?? 'User',
            provider: user.providerData.isNotEmpty
                ? user.providerData.first.providerId
                : 'email',
            photoURL: user.photoURL,
          );

          result.profileMigrated = true;
          debugPrint('✅ 프로필 마이그레이션 완료');
        } catch (e) {
          debugPrint('⚠️ 프로필 마이그레이션 실패: $e');
        }
      }

      // 2-2. 운동 기록
      final historyKeys = prefs.getKeys().where((key) => key.startsWith('workout_history_'));
      if (historyKeys.isNotEmpty) {
        try {
          for (final key in historyKeys) {
            final historyJson = prefs.getString(key);
            if (historyJson != null) {
              // JSON 파싱 확인 (향후 개별 저장 시 사용)
              jsonDecode(historyJson);

              // Firestore에 전체 동기화
              await _cloudSync.syncUserData();
              result.workoutHistoryCount++;
            }
          }
          result.workoutHistoryMigrated = true;
          debugPrint('✅ 운동 기록 마이그레이션 완료: ${result.workoutHistoryCount}개');
        } catch (e) {
          debugPrint('⚠️ 운동 기록 마이그레이션 실패: $e');
        }
      }

      // 2-3. 진행 상황
      final progressJson = prefs.getString('progress_data');
      if (progressJson != null) {
        try {
          // JSON 파싱 확인 (향후 개별 저장 시 사용)
          jsonDecode(progressJson);

          // Firestore에 전체 동기화
          await _cloudSync.syncUserData();

          result.progressMigrated = true;
          debugPrint('✅ 진행 상황 마이그레이션 완료');
        } catch (e) {
          debugPrint('⚠️ 진행 상황 마이그레이션 실패: $e');
        }
      }

      // 2-4. 업적
      final achievementKeys = prefs.getKeys().where((key) => key.startsWith('achievement_'));
      if (achievementKeys.isNotEmpty) {
        try {
          for (final key in achievementKeys) {
            final achievementJson = prefs.getString(key);
            if (achievementJson != null) {
              // JSON 파싱 확인 (향후 개별 저장 시 사용)
              jsonDecode(achievementJson);

              // Firestore에 전체 동기화
              await _cloudSync.syncUserData();
              result.achievementsCount++;
            }
          }
          result.achievementsMigrated = true;
          debugPrint('✅ 업적 마이그레이션 완료: ${result.achievementsCount}개');
        } catch (e) {
          debugPrint('⚠️ 업적 마이그레이션 실패: $e');
        }
      }

      // 3. Chad Evolution 상태
      final chadStateJson = prefs.getString('chad_evolution_state');
      if (chadStateJson != null) {
        try {
          // JSON 파싱 확인 (향후 개별 저장 시 사용)
          jsonDecode(chadStateJson);

          // Firestore에 전체 동기화
          await _cloudSync.syncUserData();

          result.chadStateMigrated = true;
          debugPrint('✅ Chad Evolution 마이그레이션 완료');
        } catch (e) {
          debugPrint('⚠️ Chad Evolution 마이그레이션 실패: $e');
        }
      }

      // 4. 마이그레이션 완료 플래그 설정
      await prefs.setBool('data_migrated_to_firebase', true);
      await prefs.setString('migration_date', DateTime.now().toIso8601String());
      await prefs.setString('migrated_user_id', user.uid);

      debugPrint('🎉 전체 마이그레이션 완료!');
      debugPrint('📊 마이그레이션 결과:\n$result');

      return result;

    } catch (e) {
      debugPrint('❌ 마이그레이션 오류: $e');
      rethrow;
    }
  }

  /// 마이그레이션이 필요한지 확인
  Future<bool> needsMigration() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 이미 마이그레이션 완료?
      final migrated = prefs.getBool('data_migrated_to_firebase') ?? false;
      if (migrated) return false;

      // 로컬 데이터가 있는지 확인
      final hasProfile = prefs.containsKey('user_profile');
      final hasHistory = prefs.getKeys().any((key) => key.startsWith('workout_history_'));

      return hasProfile || hasHistory;

    } catch (e) {
      debugPrint('❌ 마이그레이션 필요 여부 확인 오류: $e');
      return false;
    }
  }

  /// 마이그레이션 진행률 계산
  Future<double> getMigrationProgress() async {
    // TODO: 실시간 진행률 추적 구현
    return 0.0;
  }
}

/// 마이그레이션 결과
class MigrationResult {
  bool profileMigrated = false;
  bool workoutHistoryMigrated = false;
  int workoutHistoryCount = 0;
  bool progressMigrated = false;
  bool achievementsMigrated = false;
  int achievementsCount = 0;
  bool chadStateMigrated = false;

  bool get isSuccess =>
      profileMigrated ||
      workoutHistoryMigrated ||
      progressMigrated ||
      achievementsMigrated ||
      chadStateMigrated;

  @override
  String toString() {
    return '''
MigrationResult:
  Profile: ${profileMigrated ? '✅' : '❌'}
  Workout History: ${workoutHistoryMigrated ? '✅ ($workoutHistoryCount개)' : '❌'}
  Progress: ${progressMigrated ? '✅' : '❌'}
  Achievements: ${achievementsMigrated ? '✅ ($achievementsCount개)' : '❌'}
  Chad State: ${chadStateMigrated ? '✅' : '❌'}
    ''';
  }
}
