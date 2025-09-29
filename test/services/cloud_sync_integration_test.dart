import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../lib/models/workout_history.dart';
import 'dart:convert';

/// 통합 테스트 - CloudSyncService의 실제 동작을 시뮬레이션
/// Firebase 없이 로컬에서 동기화 로직을 테스트
void main() {
  group('CloudSync Integration Tests', () {

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('User Profile Sync Simulation', () {
      test('should simulate complete user profile creation flow', () async {
        // Given: 신규 사용자 정보
        const userId = 'test_user_12345';
        const email = 'test@example.com';
        const displayName = 'Test User';

        // When: 프로필 생성 시뮬레이션
        final userProfile = await _simulateCreateUserProfile(
          userId: userId,
          email: email,
          displayName: displayName,
        );

        // Then: 올바른 프로필 구조가 생성되어야 함
        final users = userProfile['users'] as Map<String, dynamic>;
        expect(users['uid'], userId);
        expect(users['email'], email);
        expect(users['displayName'], displayName);
        expect(users['status'], 'active');

        final userProfiles = userProfile['userProfiles'] as Map<String, dynamic>;
        expect(userProfiles['userId'], userId);
        expect(userProfiles['fitnessLevel'], 'beginner');
        expect(userProfiles['language'], 'ko');

        final chadProgress = userProfile['chadProgress'] as Map<String, dynamic>;
        expect(chadProgress['userId'], userId);
        expect(chadProgress['level'], 1);
        expect(chadProgress['currentStage'], 'rookie');

        final workoutProgress = userProfile['workoutProgress'] as Map<String, dynamic>;
        expect(workoutProgress['userId'], userId);
        expect(workoutProgress['currentWeek'], 1);
        expect(workoutProgress['currentDay'], 1);
      });

      test('should simulate profile update and merge scenario', () async {
        // Given: 기존 프로필과 업데이트 데이터
        final existingProfile = {
          'currentLevel': 3,
          'totalReps': 500,
          'currentStreak': 5,
          'updatedAt': '2024-01-01T10:00:00Z',
        };

        final newProfileData = {
          'currentLevel': 5,
          'totalReps': 600,
          'currentStreak': 3, // 더 낮음
          'updatedAt': '2024-01-01T12:00:00Z',
        };

        // When: 프로필 병합 시뮬레이션
        final merged = _simulateProfileMerge(existingProfile, newProfileData);

        // Then: 더 높은 진행도 값들과 최신 정보가 보존되어야 함
        expect(merged['currentLevel'], 5); // 새 데이터가 더 높음
        expect(merged['totalReps'], 600); // 새 데이터가 더 높음
        expect(merged['currentStreak'], 5); // 기존 데이터가 더 높음
        expect(merged['updatedAt'], '2024-01-01T12:00:00Z'); // 최신 타임스탬프
      });
    });

    group('Workout Record Sync Simulation', () {
      test('should simulate workout completion and sync flow', () async {
        // Given: 운동 완료 데이터
        final workoutHistory = WorkoutHistory(
          id: 'workout_${DateTime.now().millisecondsSinceEpoch}',
          date: DateTime(2024, 1, 15),
          workoutTitle: '1주차 1일',
          targetReps: [10, 12, 8, 8, 6],
          completedReps: [10, 12, 8, 8, 6],
          totalReps: 44,
          completionRate: 1.0,
          level: 'beginner',
          duration: const Duration(minutes: 15),
          pushupType: 'Standard',
        );

        // When: 운동 기록 동기화 시뮬레이션
        final syncResult = await _simulateWorkoutRecordSync(workoutHistory);

        // Then: 올바른 구조로 동기화되어야 함
        final workoutRecord = syncResult['workoutRecord'] as Map<String, dynamic>;
        expect(workoutRecord['userId'], isNotNull);
        expect(workoutRecord['totalReps'], 44);
        expect(workoutRecord['completionRate'], 1.0);

        final workoutProgress = syncResult['workoutProgress'] as Map<String, dynamic>;
        expect(workoutProgress['completedWorkouts'], 1);
        expect(workoutProgress['totalPushups'], 44);
        expect(workoutProgress['streak'], 1);
      });

      test('should simulate workout record conflict resolution', () async {
        // Given: 충돌하는 운동 기록들
        final localWorkouts = [
          {
            'id': 'workout_123',
            'date': '2024-01-15T10:00:00Z',
            'totalReps': 50,
            'completionRate': 0.9,
            'duration': 900, // 15분
          }
        ];

        final cloudWorkouts = [
          {
            'id': 'workout_123',
            'date': '2024-01-15T10:00:00Z',
            'totalReps': 55,
            'completionRate': 1.0, // 더 높은 완료율
            'duration': 1200, // 20분
          }
        ];

        // When: 운동 기록 병합 시뮬레이션
        final merged = await _simulateWorkoutRecordMerge(localWorkouts, cloudWorkouts);

        // Then: 완료율이 높은 클라우드 기록이 선택되어야 함
        expect(merged.length, 1);
        expect(merged[0]['totalReps'], 55);
        expect(merged[0]['completionRate'], 1.0);
        expect(merged[0]['duration'], 1200);
      });
    });

    group('Offline Queue Simulation', () {
      test('should simulate offline queue operations', () async {
        // Given: 오프라인 상태에서 생성된 변경사항들
        final prefs = await SharedPreferences.getInstance();
        final offlineChanges = [
          {
            'type': 'user_profile',
            'data': {'currentLevel': 4, 'totalReps': 800},
            'timestamp': '2024-01-15T10:00:00Z',
          },
          {
            'type': 'workout_record',
            'data': {
              'id': 'offline_workout_1',
              'totalReps': 50,
              'completionRate': 0.95,
            },
            'timestamp': '2024-01-15T10:30:00Z',
          },
          {
            'type': 'achievement',
            'data': {
              'achievementId': 'first_workout',
              'progress': 100,
              'completed': true,
            },
            'timestamp': '2024-01-15T11:00:00Z',
          },
        ];

        // When: 오프라인 큐 저장 및 처리 시뮬레이션
        await _simulateOfflineQueueSave(prefs, offlineChanges);
        final processedChanges = await _simulateOnlineRecoverySync(prefs);

        // Then: 모든 변경사항이 시간순으로 처리되어야 함
        expect(processedChanges.length, 3);
        expect(processedChanges[0]['type'], 'user_profile');
        expect(processedChanges[1]['type'], 'workout_record');
        expect(processedChanges[2]['type'], 'achievement');

        // 큐가 비워져야 함
        final remainingQueue = await _loadOfflineQueue(prefs);
        expect(remainingQueue, isEmpty);
      });

      test('should simulate network state change handling', () async {
        // Given: 네트워크 상태 변화 시나리오
        var isOnline = true;
        final changes = <Map<String, dynamic>>[];

        // When: 네트워크 상태에 따른 동작 시뮬레이션

        // 1. 온라인 상태 - 즉시 동기화
        final result1 = _simulateNetworkStateAction(
          isOnline: isOnline,
          changeData: {'type': 'profile', 'data': {'level': 1}}
        );
        expect(result1['action'], 'immediate_sync');

        // 2. 오프라인 상태 - 큐에 저장
        isOnline = false;
        final result2 = _simulateNetworkStateAction(
          isOnline: isOnline,
          changeData: {'type': 'workout', 'data': {'reps': 50}}
        );
        expect(result2['action'], 'queue_for_later');

        // 3. 다시 온라인 - 큐 처리
        isOnline = true;
        final result3 = _simulateNetworkRecovery(isOnline);
        expect(result3['action'], 'process_queue');
        expect(result3['triggerDelay'], 2000); // 2초 지연
      });
    });

    group('Achievement Sync Simulation', () {
      test('should simulate achievement unlock and sync', () async {
        // Given: 성취 달성 시나리오
        final achievementData = {
          'achievementId': 'first_100_pushups',
          'userId': 'test_user_123',
          'type': 'progress',
          'targetValue': 100,
          'currentValue': 100,
          'completed': true,
          'completedAt': DateTime.now(),
          'rarity': 'common',
        };

        // When: 성취 동기화 시뮬레이션
        final syncResult = await _simulateAchievementSync(achievementData);

        // Then: 올바른 구조로 동기화되어야 함
        expect(syncResult['firestoreAchievement']['userId'], 'test_user_123');
        expect(syncResult['firestoreAchievement']['completed'], true);
        expect(syncResult['firestoreAchievement']['progress'], 100);
        expect(syncResult['firestoreAchievement']['rarity'], 'common');
      });
    });

    group('Error Handling Simulation', () {
      test('should simulate sync error recovery', () async {
        // Given: 동기화 실패 시나리오
        final changeData = {
          'type': 'workout_record',
          'data': {'id': 'workout_123', 'totalReps': 50},
        };

        // When: 동기화 실패 및 재시도 시뮬레이션
        final result = _simulateSyncWithRetry(
          changeData: changeData,
          maxRetries: 3,
          shouldFail: [true, true, false], // 처음 2번 실패, 3번째 성공
        );

        // Then: 재시도 후 성공해야 함
        expect(result['success'], true);
        expect(result['attempts'], 3);
        expect(result['finalAttemptSucceeded'], true);
      });

      test('should simulate timeout handling', () {
        // Given: 타임아웃 시나리오
        const operationTimeout = 5000; // 5초
        const actualDuration = 7000; // 7초 (타임아웃)

        // When: 타임아웃 감지 시뮬레이션
        final result = _simulateTimeoutDetection(operationTimeout, actualDuration);

        // Then: 타임아웃이 감지되어야 함
        expect(result['timedOut'], true);
        expect(result['shouldRetry'], true);
        expect(result['nextRetryDelay'], 10000); // 10초 후 재시도
      });
    });
  });
}

// 시뮬레이션 헬퍼 함수들

Future<Map<String, Map<String, dynamic>>> _simulateCreateUserProfile({
  required String userId,
  required String email,
  required String displayName,
}) async {
  final now = DateTime.now();

  return {
    'users': {
      'uid': userId,
      'email': email,
      'displayName': displayName,
      'provider': 'google',
      'status': 'active',
      'createdAt': now.toIso8601String(),
    },
    'userProfiles': {
      'userId': userId,
      'nickname': displayName,
      'fitnessLevel': 'beginner',
      'language': 'ko',
      'timezone': 'Asia/Seoul',
      'onboardingCompleted': false,
      'createdAt': now.toIso8601String(),
    },
    'chadProgress': {
      'userId': userId,
      'level': 1,
      'xp': 0,
      'currentStage': 'rookie',
      'unlockedStages': ['rookie'],
      'createdAt': now.toIso8601String(),
    },
    'workoutProgress': {
      'userId': userId,
      'currentWeek': 1,
      'currentDay': 1,
      'completedWorkouts': 0,
      'totalPushups': 0,
      'streak': 0,
      'createdAt': now.toIso8601String(),
    },
  };
}

Map<String, dynamic> _simulateProfileMerge(
  Map<String, dynamic> existing,
  Map<String, dynamic> updated,
) {
  final merged = Map<String, dynamic>.from(existing);

  // 진행도 관련 필드는 더 높은 값 선택
  if ((updated['currentLevel'] as int) > (existing['currentLevel'] as int)) {
    merged['currentLevel'] = updated['currentLevel'];
  }

  if ((updated['totalReps'] as int) > (existing['totalReps'] as int)) {
    merged['totalReps'] = updated['totalReps'];
  }

  if ((updated['currentStreak'] as int) > (existing['currentStreak'] as int)) {
    merged['currentStreak'] = updated['currentStreak'];
  }

  // 타임스탬프는 최신 것으로
  final existingTime = DateTime.parse(existing['updatedAt'] as String);
  final updatedTime = DateTime.parse(updated['updatedAt'] as String);

  if (updatedTime.isAfter(existingTime)) {
    merged['updatedAt'] = updated['updatedAt'];
  }

  return merged;
}

Future<Map<String, Map<String, dynamic>>> _simulateWorkoutRecordSync(
  WorkoutHistory workoutHistory,
) async {
  const userId = 'test_user_123';

  // workoutRecord 저장 시뮬레이션
  final workoutRecord = {
    'userId': userId,
    'id': workoutHistory.id,
    'date': workoutHistory.date.toIso8601String(),
    'workoutTitle': workoutHistory.workoutTitle,
    'targetReps': workoutHistory.targetReps,
    'completedReps': workoutHistory.completedReps,
    'totalReps': workoutHistory.totalReps,
    'completionRate': workoutHistory.completionRate,
    'level': workoutHistory.level,
    'duration': workoutHistory.duration.inSeconds,
    'createdAt': DateTime.now().toIso8601String(),
  };

  // workoutProgress 업데이트 시뮬레이션
  final workoutProgress = {
    'userId': userId,
    'completedWorkouts': 1,
    'totalPushups': workoutHistory.totalReps,
    'averageReps': workoutHistory.totalReps,
    'bestSingleSet': workoutHistory.completedReps.reduce((a, b) => a > b ? a : b),
    'streak': 1,
    'longestStreak': 1,
    'lastWorkoutDate': workoutHistory.date.toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  };

  return {
    'workoutRecord': workoutRecord,
    'workoutProgress': workoutProgress,
  };
}

Future<List<Map<String, dynamic>>> _simulateWorkoutRecordMerge(
  List<Map<String, dynamic>> localWorkouts,
  List<Map<String, dynamic>> cloudWorkouts,
) async {
  final Map<String, Map<String, dynamic>> mergedMap = {};

  // 클라우드 우선
  for (final workout in cloudWorkouts) {
    mergedMap[workout['id'] as String] = workout;
  }

  // 로컬에서 중복되지 않는 것만 추가
  for (final workout in localWorkouts) {
    final id = workout['id'] as String;
    if (!mergedMap.containsKey(id)) {
      mergedMap[id] = workout;
    } else {
      // 충돌 해결: 완료율 기준
      final localRate = workout['completionRate'] as double;
      final cloudRate = mergedMap[id]!['completionRate'] as double;
      if (localRate > cloudRate) {
        mergedMap[id] = workout;
      }
    }
  }

  return mergedMap.values.toList();
}

Future<void> _simulateOfflineQueueSave(
  SharedPreferences prefs,
  List<Map<String, dynamic>> changes,
) async {
  await prefs.setString('pending_sync_changes', json.encode(changes));
}

Future<List<Map<String, dynamic>>> _simulateOnlineRecoverySync(
  SharedPreferences prefs,
) async {
  final changes = await _loadOfflineQueue(prefs);

  // 시간순 정렬
  changes.sort((a, b) {
    final timeA = DateTime.parse(a['timestamp'] as String);
    final timeB = DateTime.parse(b['timestamp'] as String);
    return timeA.compareTo(timeB);
  });

  // 처리 완료 후 큐 비우기
  await prefs.remove('pending_sync_changes');

  return changes;
}

Future<List<Map<String, dynamic>>> _loadOfflineQueue(
  SharedPreferences prefs,
) async {
  final queueJson = prefs.getString('pending_sync_changes');
  if (queueJson == null) return [];

  final decoded = json.decode(queueJson) as List<dynamic>;
  return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
}

Map<String, dynamic> _simulateNetworkStateAction({
  required bool isOnline,
  required Map<String, dynamic> changeData,
}) {
  if (isOnline) {
    return {
      'action': 'immediate_sync',
      'data': changeData,
      'timestamp': DateTime.now().toIso8601String(),
    };
  } else {
    return {
      'action': 'queue_for_later',
      'data': changeData,
      'queuedAt': DateTime.now().toIso8601String(),
    };
  }
}

Map<String, dynamic> _simulateNetworkRecovery(bool isOnline) {
  if (!isOnline) {
    return {'action': 'wait_for_connection'};
  }

  return {
    'action': 'process_queue',
    'triggerDelay': 2000, // 2초 지연
    'processingStarted': true,
  };
}

Future<Map<String, dynamic>> _simulateAchievementSync(
  Map<String, dynamic> achievementData,
) async {
  final firestoreData = {
    'userId': achievementData['userId'],
    'achievementId': achievementData['achievementId'],
    'type': achievementData['type'],
    'title': 'First 100 Push-ups',
    'description': 'Complete your first 100 push-ups total',
    'progress': achievementData['currentValue'],
    'completed': achievementData['completed'],
    'completedAt': achievementData['completedAt']?.toIso8601String(),
    'rarity': achievementData['rarity'],
    'xpReward': 100,
    'createdAt': DateTime.now().toIso8601String(),
  };

  return {
    'firestoreAchievement': firestoreData,
    'syncSuccess': true,
  };
}

Map<String, dynamic> _simulateSyncWithRetry({
  required Map<String, dynamic> changeData,
  required int maxRetries,
  required List<bool> shouldFail,
}) {
  int attempts = 0;
  bool success = false;

  for (int i = 0; i < maxRetries && i < shouldFail.length; i++) {
    attempts++;
    if (!shouldFail[i]) {
      success = true;
      break;
    }
  }

  return {
    'success': success,
    'attempts': attempts,
    'finalAttemptSucceeded': success,
    'data': changeData,
  };
}

Map<String, dynamic> _simulateTimeoutDetection(
  int timeoutMs,
  int actualDurationMs,
) {
  final timedOut = actualDurationMs > timeoutMs;

  return {
    'timedOut': timedOut,
    'shouldRetry': timedOut,
    'nextRetryDelay': timedOut ? timeoutMs * 2 : 0,
    'operation': 'firestore_sync',
  };
}