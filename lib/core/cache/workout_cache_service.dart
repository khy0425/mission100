import 'dart:async';
import 'package:flutter/foundation.dart';
import '../database/firestore_query_optimizer.dart';
import 'cache_manager.dart';
import '../../models/workout_history.dart';
import '../../models/achievement.dart';

/// 워크아웃 관련 캐시 서비스
class WorkoutCacheService {
  static final WorkoutCacheService _instance = WorkoutCacheService._internal();
  factory WorkoutCacheService() => _instance;
  WorkoutCacheService._internal();

  final CacheManager _cacheManager = CacheManager();
  final FirestoreQueryOptimizer _queryOptimizer = FirestoreQueryOptimizer();

  static const Duration _workoutCacheTtl = Duration(minutes: 15);
  static const Duration _statsCacheTtl = Duration(minutes: 30);
  static const Duration _achievementCacheTtl = Duration(hours: 1);

  /// 초기화
  Future<void> initialize() async {
    await _cacheManager.initialize();
    debugPrint('워크아웃 캐시 서비스 초기화 완료');
  }

  /// 워크아웃 기록 조회 (캐시 우선)
  Future<List<WorkoutHistory>> getWorkoutHistory(
    String userId, {
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
    String? exerciseType,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = _generateWorkoutCacheKey(
        userId,
        limit,
        startDate,
        endDate,
        exerciseType,
      );

      // 강제 새로고침이 아닌 경우 캐시 확인
      if (!forceRefresh) {
        final cachedData =
            await _cacheManager.get<List<Map<String, dynamic>>>(cacheKey);
        if (cachedData != null) {
          debugPrint('워크아웃 기록 캐시 히트: $cacheKey');
          return cachedData
              .map((data) => WorkoutHistory.fromMap(data))
              .toList();
        }
      }

      // 데이터베이스에서 조회
      final docs = await _queryOptimizer.getOptimizedWorkoutRecords(
        userId,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        exerciseType: exerciseType,
      );

      final workoutHistory = docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return WorkoutHistory.fromMap({...data, 'id': doc.id});
      }).toList();

      // 캐시에 저장
      final cacheData =
          workoutHistory.map((workout) => workout.toMap()).toList();
      await _cacheManager.put(cacheKey, cacheData, ttl: _workoutCacheTtl);

      debugPrint('워크아웃 기록 데이터베이스 조회: ${workoutHistory.length}개');
      return workoutHistory;
    } catch (e) {
      debugPrint('워크아웃 기록 조회 실패: $e');
      return [];
    }
  }

  /// 사용자 통계 조회 (캐시 우선)
  Future<Map<String, dynamic>> getUserStats(
    String userId, {
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = 'user_stats_$userId';

      if (!forceRefresh) {
        final cachedStats =
            await _cacheManager.get<Map<String, dynamic>>(cacheKey);
        if (cachedStats != null) {
          debugPrint('사용자 통계 캐시 히트: $cacheKey');
          return cachedStats;
        }
      }

      // 최적화된 통계 조회
      final stats = await _queryOptimizer.getOptimizedUserStats(userId);

      // 캐시에 저장
      await _cacheManager.put(cacheKey, stats, ttl: _statsCacheTtl);

      debugPrint('사용자 통계 데이터베이스 조회 완료');
      return stats;
    } catch (e) {
      debugPrint('사용자 통계 조회 실패: $e');
      return {};
    }
  }

  /// 업적 목록 조회 (캐시 우선)
  Future<List<Achievement>> getAchievements(
    String userId, {
    bool? completed,
    String? category,
    int limit = 50,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey =
          _generateAchievementCacheKey(userId, completed, category, limit);

      if (!forceRefresh) {
        final cachedData =
            await _cacheManager.get<List<Map<String, dynamic>>>(cacheKey);
        if (cachedData != null) {
          debugPrint('업적 캐시 히트: $cacheKey');
          return cachedData.map((data) => Achievement.fromMap(data)).toList();
        }
      }

      // 데이터베이스에서 조회
      final docs = await _queryOptimizer.getOptimizedAchievements(
        userId,
        completed: completed,
        category: category,
        limit: limit,
      );

      final achievements = docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Achievement.fromMap({...data, 'id': doc.id});
      }).toList();

      // 캐시에 저장
      final cacheData =
          achievements.map((achievement) => achievement.toMap()).toList();
      await _cacheManager.put(cacheKey, cacheData, ttl: _achievementCacheTtl);

      debugPrint('업적 데이터베이스 조회: ${achievements.length}개');
      return achievements;
    } catch (e) {
      debugPrint('업적 조회 실패: $e');
      return [];
    }
  }

  /// 주간 진행도 캐시
  Future<List<int>> getWeeklyProgress(
    String userId, {
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = 'weekly_progress_$userId';

      if (!forceRefresh) {
        final cachedProgress = await _cacheManager.get<List<int>>(cacheKey);
        if (cachedProgress != null) {
          debugPrint('주간 진행도 캐시 히트: $cacheKey');
          return cachedProgress;
        }
      }

      // 사용자 통계에서 주간 진행도 추출
      final stats = await getUserStats(userId, forceRefresh: forceRefresh);
      final weeklyProgressData = stats['weeklyProgress'];
      final weeklyProgress = weeklyProgressData is List
          ? List<int>.from(weeklyProgressData)
          : <int>[];

      // 별도 캐시에 저장 (더 짧은 TTL)
      await _cacheManager.put(
        cacheKey,
        weeklyProgress,
        ttl: const Duration(minutes: 10),
      );

      return weeklyProgress;
    } catch (e) {
      debugPrint('주간 진행도 조회 실패: $e');
      return List.filled(7, 0);
    }
  }

  /// 현재 연속 기록 캐시
  Future<int> getCurrentStreak(
    String userId, {
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = 'current_streak_$userId';

      if (!forceRefresh) {
        final cachedStreak = await _cacheManager.get<int>(cacheKey);
        if (cachedStreak != null) {
          debugPrint('연속 기록 캐시 히트: $cacheKey');
          return cachedStreak;
        }
      }

      final stats = await getUserStats(userId, forceRefresh: forceRefresh);
      final currentStreak = stats['currentStreak'] as int? ?? 0;

      await _cacheManager.put(
        cacheKey,
        currentStreak,
        ttl: const Duration(minutes: 5),
      );

      return currentStreak;
    } catch (e) {
      debugPrint('연속 기록 조회 실패: $e');
      return 0;
    }
  }

  /// 워크아웃 추가 후 캐시 무효화
  Future<void> invalidateWorkoutCaches(String userId) async {
    try {
      await _cacheManager.removeByPattern('workout_records_$userId');
      await _cacheManager.removeByPattern('user_stats_$userId');
      await _cacheManager.removeByPattern('weekly_progress_$userId');
      await _cacheManager.removeByPattern('current_streak_$userId');

      debugPrint('워크아웃 관련 캐시 무효화 완료: $userId');
    } catch (e) {
      debugPrint('워크아웃 캐시 무효화 실패: $e');
    }
  }

  /// 업적 완료 후 캐시 무효화
  Future<void> invalidateAchievementCaches(String userId) async {
    try {
      await _cacheManager.removeByPattern('achievements_$userId');
      await _cacheManager.removeByPattern('user_stats_$userId');

      debugPrint('업적 관련 캐시 무효화 완료: $userId');
    } catch (e) {
      debugPrint('업적 캐시 무효화 실패: $e');
    }
  }

  /// 사용자별 전체 캐시 무효화
  Future<void> invalidateUserCaches(String userId) async {
    try {
      await _cacheManager.removeByPattern(userId);
      debugPrint('사용자 전체 캐시 무효화 완료: $userId');
    } catch (e) {
      debugPrint('사용자 캐시 무효화 실패: $e');
    }
  }

  /// 워크아웃 캐시 키 생성
  String _generateWorkoutCacheKey(
    String userId,
    int limit,
    DateTime? startDate,
    DateTime? endDate,
    String? exerciseType,
  ) {
    final parts = [
      'workout_records',
      userId,
      limit.toString(),
    ];

    if (startDate != null) {
      parts.add('start_${startDate.millisecondsSinceEpoch}');
    }
    if (endDate != null) {
      parts.add('end_${endDate.millisecondsSinceEpoch}');
    }
    if (exerciseType != null) {
      parts.add('type_$exerciseType');
    }

    return parts.join('_');
  }

  /// 업적 캐시 키 생성
  String _generateAchievementCacheKey(
    String userId,
    bool? completed,
    String? category,
    int limit,
  ) {
    final parts = [
      'achievements',
      userId,
      limit.toString(),
    ];

    if (completed != null) {
      parts.add('completed_$completed');
    }
    if (category != null) {
      parts.add('category_$category');
    }

    return parts.join('_');
  }

  /// 프리워밍 (자주 사용되는 데이터 미리 캐싱)
  Future<void> preWarmCache(String userId) async {
    try {
      debugPrint('캐시 프리워밍 시작: $userId');

      // 병렬로 주요 데이터 캐싱
      await Future.wait([
        getWorkoutHistory(userId, limit: 10),
        getUserStats(userId),
        getAchievements(userId, limit: 20),
        getWeeklyProgress(userId),
        getCurrentStreak(userId),
      ]);

      debugPrint('캐시 프리워밍 완료: $userId');
    } catch (e) {
      debugPrint('캐시 프리워밍 실패: $e');
    }
  }

  /// 캐시 성능 모니터링
  Map<String, dynamic> getCachePerformance() {
    final stats = _cacheManager.getStats();
    return {
      'workout_cache_performance': stats.toJson(),
      'recommendations': _generateCacheRecommendations(stats),
    };
  }

  /// 캐시 최적화 권장사항 생성
  List<String> _generateCacheRecommendations(CacheStats stats) {
    final recommendations = <String>[];

    if (stats.hitRate < 0.7) {
      recommendations.add(
          '캐시 히트율이 낮습니다 (${(stats.hitRate * 100).toStringAsFixed(1)}%). TTL 조정을 고려해보세요.');
    }

    if (stats.evictions > stats.hits * 0.3) {
      recommendations.add('캐시 제거율이 높습니다. 메모리 캐시 크기 증가를 고려해보세요.');
    }

    if (stats.size < 10) {
      recommendations.add('캐시 사용량이 적습니다. 더 많은 데이터를 캐싱해보세요.');
    }

    if (recommendations.isEmpty) {
      recommendations.add('캐시 성능이 양호합니다.');
    }

    return recommendations;
  }

  /// 캐시 정보 출력 (디버그용)
  Future<void> printCacheInfo() async {
    if (kDebugMode) {
      await _cacheManager.printCacheInfo();
      final performance = getCachePerformance();
      debugPrint('=== 워크아웃 캐시 성능 ===');
      debugPrint('권장사항: ${performance['recommendations']}');
      debugPrint('========================');
    }
  }

  /// 리소스 정리
  void dispose() {
    _cacheManager.dispose();
    debugPrint('워크아웃 캐시 서비스 정리 완료');
  }
}
