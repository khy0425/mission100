import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  group('CloudSync Logic Tests', () {

    setUp(() {
      // SharedPreferences Mock 설정
      SharedPreferences.setMockInitialValues({});
    });

    group('Network State Detection Logic', () {
      test('should correctly identify online state', () {
        // Given: 다양한 연결 상태
        final wifiState = ['wifi'];
        final mobileState = ['mobile'];
        final noneState = ['none'];
        final emptyState = <String>[];

        // When & Then: 네트워크 상태 확인
        expect(_isOnlineFromConnectivity(wifiState), true);
        expect(_isOnlineFromConnectivity(mobileState), true);
        expect(_isOnlineFromConnectivity(noneState), false);
        expect(_isOnlineFromConnectivity(emptyState), false);
      });
    });

    group('Conflict Resolution Logic', () {
      test('should resolve workout record conflict by completion rate', () {
        // Given: 충돌하는 운동 기록
        final localData = {
          'id': 'workout_123',
          'completionRate': 0.8,
          'updatedAt': '2024-01-01T10:00:00Z',
          'totalReps': 80,
        };
        final cloudData = {
          'id': 'workout_123',
          'completionRate': 0.9,
          'updatedAt': '2024-01-01T09:00:00Z',
          'totalReps': 90,
        };

        // When: 충돌 해결
        final resolved = _resolveWorkoutRecordConflict(localData, cloudData);

        // Then: 완료율이 높은 클라우드 데이터가 선택되어야 함
        expect(resolved['completionRate'], 0.9);
        expect(resolved['id'], 'workout_123');
      });

      test('should resolve workout conflict by timestamp when completion rates are equal', () {
        // Given: 완료율이 같은 운동 기록
        final localData = {
          'id': 'workout_123',
          'completionRate': 0.8,
          'updatedAt': '2024-01-01T12:00:00Z', // 더 최신
        };
        final cloudData = {
          'id': 'workout_123',
          'completionRate': 0.8,
          'updatedAt': '2024-01-01T10:00:00Z', // 더 오래됨
        };

        // When: 충돌 해결
        final resolved = _resolveWorkoutRecordConflict(localData, cloudData);

        // Then: 최신 타임스탬프의 로컬 데이터가 선택되어야 함
        expect(resolved['updatedAt'], '2024-01-01T12:00:00Z');
      });

      test('should resolve user profile conflict by progress values', () {
        // Given: 충돌하는 프로필 데이터
        final localData = {
          'currentLevel': 5,
          'totalReps': 1000,
          'currentStreak': 10,
          'displayName': 'Local User',
          'updatedAt': '2024-01-01T10:00:00Z',
        };
        final cloudData = {
          'currentLevel': 3,
          'totalReps': 800,
          'currentStreak': 15, // 이것만 더 높음
          'displayName': 'Cloud User',
          'updatedAt': '2024-01-01T11:00:00Z', // 더 최신
        };

        // When: 충돌 해결
        final resolved = _resolveUserProfileConflict(localData, cloudData);

        // Then: 각 필드에서 더 높은 값이 선택되어야 함
        expect(resolved['currentLevel'], 5); // 로컬이 더 높음
        expect(resolved['totalReps'], 1000); // 로컬이 더 높음
        expect(resolved['currentStreak'], 15); // 클라우드가 더 높음
        expect(resolved['displayName'], 'Cloud User'); // 최신 타임스탬프
      });

      test('should resolve achievement conflict by completion status', () {
        // Given: 성취 완료 상태 충돌
        final localCompleted = {
          'progress': 80,
          'completed': true,
          'completedAt': '2024-01-01T10:00:00Z',
        };
        final cloudIncomplete = {
          'progress': 90,
          'completed': false,
          'updatedAt': '2024-01-01T11:00:00Z',
        };

        // When: 충돌 해결
        final resolved = _resolveAchievementConflict(localCompleted, cloudIncomplete);

        // Then: 완료된 성취가 우선되어야 함
        expect(resolved['completed'], true);
        expect(resolved['progress'], 80);
      });

      test('should resolve achievement conflict by progress when both incomplete', () {
        // Given: 둘 다 미완료인 성취
        final localData = {
          'progress': 70,
          'completed': false,
        };
        final cloudData = {
          'progress': 85,
          'completed': false,
        };

        // When: 충돌 해결
        final resolved = _resolveAchievementConflict(localData, cloudData);

        // Then: 진행도가 높은 것이 선택되어야 함
        expect(resolved['progress'], 85);
        expect(resolved['completed'], false);
      });
    });

    group('Data Merging Logic', () {
      test('should merge workout records without duplicates', () {
        // Given: 로컬과 클라우드 운동 기록
        final localWorkouts = [
          {'id': 'workout_1', 'date': '2024-01-01', 'totalReps': 50},
          {'id': 'workout_2', 'date': '2024-01-02', 'totalReps': 60},
        ];
        final cloudWorkouts = [
          {'id': 'workout_2', 'date': '2024-01-02', 'totalReps': 65}, // 중복
          {'id': 'workout_3', 'date': '2024-01-03', 'totalReps': 70},
        ];

        // When: 운동 기록 병합
        final merged = _mergeWorkoutRecords(localWorkouts, cloudWorkouts);

        // Then: 중복 제거되고 모든 고유 기록이 포함되어야 함
        expect(merged.length, 3);
        expect(merged.any((w) => w['id'] == 'workout_1'), true);
        expect(merged.any((w) => w['id'] == 'workout_2'), true);
        expect(merged.any((w) => w['id'] == 'workout_3'), true);

        // 중복된 workout_2는 클라우드 우선
        final workout2 = merged.firstWhere((w) => w['id'] == 'workout_2');
        expect(workout2['totalReps'], 65);
      });

      test('should sort merged records by date (newest first)', () {
        // Given: 날짜가 섞인 운동 기록들
        final workouts = [
          {'id': 'workout_1', 'date': '2024-01-03T10:00:00Z'},
          {'id': 'workout_2', 'date': '2024-01-01T10:00:00Z'},
          {'id': 'workout_3', 'date': '2024-01-02T10:00:00Z'},
        ];

        // When: 날짜순 정렬
        final sorted = _sortWorkoutsByDate(workouts);

        // Then: 최신 날짜부터 정렬되어야 함
        expect(sorted[0]['date'], '2024-01-03T10:00:00Z');
        expect(sorted[1]['date'], '2024-01-02T10:00:00Z');
        expect(sorted[2]['date'], '2024-01-01T10:00:00Z');
      });
    });

    group('Offline Queue Management', () {
      test('should serialize and deserialize pending changes correctly', () async {
        // Given: SharedPreferences 초기화
        final prefs = await SharedPreferences.getInstance();
        final changes = [
          {
            'type': 'user_profile',
            'data': {'level': 5, 'totalReps': 100},
            'timestamp': '2024-01-01T10:00:00Z',
          },
          {
            'type': 'workout_record',
            'data': {'id': 'workout_123', 'totalReps': 50},
            'timestamp': '2024-01-01T10:05:00Z',
          },
        ];

        // When: 큐에 변경사항 저장 및 로드
        await _savePendingChanges(prefs, changes);
        final loaded = await _loadPendingChanges(prefs);

        // Then: 저장된 데이터와 로드된 데이터가 일치해야 함
        expect(loaded.length, 2);
        expect(loaded[0]['type'], 'user_profile');
        expect(loaded[1]['type'], 'workout_record');
        expect(loaded[0]['data']['level'], 5);
        expect(loaded[1]['data']['totalReps'], 50);
      });

      test('should handle empty pending changes queue', () async {
        // Given: 빈 SharedPreferences
        final prefs = await SharedPreferences.getInstance();

        // When: 빈 큐에서 변경사항 로드
        final loaded = await _loadPendingChanges(prefs);

        // Then: 빈 리스트가 반환되어야 함
        expect(loaded, isEmpty);
      });

      test('should process pending changes in correct order', () {
        // Given: 타임스탬프가 다른 변경사항들
        final changes = [
          {
            'type': 'profile',
            'timestamp': '2024-01-01T10:05:00Z',
            'data': {'action': 'third'}
          },
          {
            'type': 'workout',
            'timestamp': '2024-01-01T10:01:00Z',
            'data': {'action': 'first'}
          },
          {
            'type': 'achievement',
            'timestamp': '2024-01-01T10:03:00Z',
            'data': {'action': 'second'}
          },
        ];

        // When: 타임스탬프순으로 정렬
        final sorted = _sortPendingChangesByTimestamp(changes);

        // Then: 시간순으로 정렬되어야 함
        expect(sorted[0]['data']['action'], 'first');
        expect(sorted[1]['data']['action'], 'second');
        expect(sorted[2]['data']['action'], 'third');
      });
    });

    group('Timestamp Parsing', () {
      test('should parse various timestamp formats correctly', () {
        // Given: 다양한 형태의 타임스탬프
        final isoString = '2024-01-01T10:00:00Z';
        final timestamp = 1704110400000; // 2024-01-01 10:00:00 UTC in milliseconds

        // When: 타임스탬프 파싱
        final parsedString = _parseTimestamp(isoString);
        final parsedInt = _parseTimestamp(timestamp);
        final parsedNull = _parseTimestamp(null);

        // Then: 올바르게 파싱되어야 함
        expect(parsedString.year, 2024);
        expect(parsedString.month, 1);
        expect(parsedString.day, 1);

        expect(parsedInt.year, 2024);
        expect(parsedInt.month, 1);
        expect(parsedInt.day, 1);

        expect(parsedNull.year, 1970); // 기본값
      });

      test('should handle invalid timestamp gracefully', () {
        // Given: 잘못된 타임스탬프
        final invalidString = 'invalid-date';
        final invalidNumber = -1;

        // When: 잘못된 타임스탬프 파싱
        final parsedInvalidString = _parseTimestamp(invalidString);
        final parsedInvalidNumber = _parseTimestamp(invalidNumber);

        // Then: 기본값(1970)이 반환되어야 함
        expect(parsedInvalidString.year, 1970);
        expect(parsedInvalidNumber.year, 1970);
      });
    });
  });
}

// 테스트 헬퍼 함수들 - CloudSyncService 로직을 시뮬레이션
bool _isOnlineFromConnectivity(List<String> connectivityResults) {
  return connectivityResults.isNotEmpty && !connectivityResults.contains('none');
}

Map<String, dynamic> _resolveWorkoutRecordConflict(
  Map<String, dynamic> localData,
  Map<String, dynamic> cloudData,
) {
  final localRate = (localData['completionRate'] as double?) ?? 0.0;
  final cloudRate = (cloudData['completionRate'] as double?) ?? 0.0;

  if (localRate > cloudRate) return localData;
  if (cloudRate > localRate) return cloudData;

  // 완료율이 같으면 타임스탬프 비교
  final localTime = _parseTimestamp(localData['updatedAt']);
  final cloudTime = _parseTimestamp(cloudData['updatedAt']);

  return cloudTime.isAfter(localTime) ? cloudData : localData;
}

Map<String, dynamic> _resolveUserProfileConflict(
  Map<String, dynamic> localData,
  Map<String, dynamic> cloudData,
) {
  final resolved = Map<String, dynamic>.from(localData);

  // 기본 정보는 최신 타임스탬프 우선
  final localTime = _parseTimestamp(localData['updatedAt']);
  final cloudTime = _parseTimestamp(cloudData['updatedAt']);

  if (cloudTime.isAfter(localTime)) {
    resolved['displayName'] = cloudData['displayName'] ?? resolved['displayName'];
    resolved['updatedAt'] = cloudData['updatedAt'];
  }

  // 진행도 관련은 더 높은 값 선택
  final localLevel = (localData['currentLevel'] as int?) ?? 0;
  final cloudLevel = (cloudData['currentLevel'] as int?) ?? 0;
  resolved['currentLevel'] = localLevel > cloudLevel ? localLevel : cloudLevel;

  final localReps = (localData['totalReps'] as int?) ?? 0;
  final cloudReps = (cloudData['totalReps'] as int?) ?? 0;
  resolved['totalReps'] = localReps > cloudReps ? localReps : cloudReps;

  final localStreak = (localData['currentStreak'] as int?) ?? 0;
  final cloudStreak = (cloudData['currentStreak'] as int?) ?? 0;
  resolved['currentStreak'] = localStreak > cloudStreak ? localStreak : cloudStreak;

  return resolved;
}

Map<String, dynamic> _resolveAchievementConflict(
  Map<String, dynamic> localData,
  Map<String, dynamic> cloudData,
) {
  final localCompleted = localData['completed'] as bool? ?? false;
  final cloudCompleted = cloudData['completed'] as bool? ?? false;

  // 완료 상태 우선
  if (localCompleted && !cloudCompleted) return localData;
  if (cloudCompleted && !localCompleted) return cloudData;

  // 둘 다 같은 완료 상태면 진행도 비교
  final localProgress = (localData['progress'] as int?) ?? 0;
  final cloudProgress = (cloudData['progress'] as int?) ?? 0;

  return localProgress > cloudProgress ? localData : cloudData;
}

List<Map<String, dynamic>> _mergeWorkoutRecords(
  List<Map<String, dynamic>> localWorkouts,
  List<Map<String, dynamic>> cloudWorkouts,
) {
  final Map<String, Map<String, dynamic>> mergedMap = {};

  // 클라우드 기록을 먼저 추가 (우선순위)
  for (final workout in cloudWorkouts) {
    final id = workout['id'] as String;
    mergedMap[id] = workout;
  }

  // 로컬 기록 중 클라우드에 없는 것만 추가
  for (final workout in localWorkouts) {
    final id = workout['id'] as String;
    if (!mergedMap.containsKey(id)) {
      mergedMap[id] = workout;
    }
  }

  return mergedMap.values.toList();
}

List<Map<String, dynamic>> _sortWorkoutsByDate(List<Map<String, dynamic>> workouts) {
  final sorted = List<Map<String, dynamic>>.from(workouts);
  sorted.sort((a, b) {
    final dateA = DateTime.parse(a['date'] as String);
    final dateB = DateTime.parse(b['date'] as String);
    return dateB.compareTo(dateA); // 최신 순
  });
  return sorted;
}

Future<void> _savePendingChanges(
  SharedPreferences prefs,
  List<Map<String, dynamic>> changes,
) async {
  await prefs.setString('pending_sync_changes', json.encode(changes));
}

Future<List<Map<String, dynamic>>> _loadPendingChanges(
  SharedPreferences prefs,
) async {
  final changesJson = prefs.getString('pending_sync_changes');
  if (changesJson == null) return [];

  final decoded = json.decode(changesJson) as List<dynamic>;
  return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
}

List<Map<String, dynamic>> _sortPendingChangesByTimestamp(
  List<Map<String, dynamic>> changes,
) {
  final sorted = List<Map<String, dynamic>>.from(changes);
  sorted.sort((a, b) {
    final timeA = DateTime.parse(a['timestamp'] as String);
    final timeB = DateTime.parse(b['timestamp'] as String);
    return timeA.compareTo(timeB); // 오래된 순
  });
  return sorted;
}

DateTime _parseTimestamp(dynamic timestamp) {
  if (timestamp == null) return DateTime(1970);
  if (timestamp is DateTime) return timestamp;
  if (timestamp is String) {
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return DateTime(1970);
    }
  }
  if (timestamp is int) {
    if (timestamp < 0) return DateTime(1970);
    try {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return DateTime(1970);
    }
  }
  return DateTime(1970);
}