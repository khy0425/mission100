import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 쿼리 성능 메트릭
class QueryMetrics {
  final Duration executionTime;
  final int documentsRead;
  final int documentsWritten;
  final String queryPath;
  final DateTime timestamp;
  final bool useCache;

  const QueryMetrics({
    required this.executionTime,
    required this.documentsRead,
    required this.documentsWritten,
    required this.queryPath,
    required this.timestamp,
    required this.useCache,
  });

  Map<String, dynamic> toJson() {
    return {
      'execution_time_ms': executionTime.inMilliseconds,
      'documents_read': documentsRead,
      'documents_written': documentsWritten,
      'query_path': queryPath,
      'timestamp': timestamp.toIso8601String(),
      'use_cache': useCache,
    };
  }
}

/// 쿼리 최적화 전략
enum QueryOptimizationStrategy {
  indexing, // 인덱싱 최적화
  pagination, // 페이지네이션
  fieldFiltering, // 필드 필터링
  caching, // 캐싱
  batchOperation, // 배치 작업
}

/// Firestore 쿼리 최적화 서비스
class FirestoreQueryOptimizer {
  static final FirestoreQueryOptimizer _instance =
      FirestoreQueryOptimizer._internal();
  factory FirestoreQueryOptimizer() => _instance;
  FirestoreQueryOptimizer._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<QueryMetrics> _queryMetrics = [];
  final Map<String, dynamic> _queryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  static const Duration _cacheExpiration = Duration(minutes: 5);
  static const int _maxCacheSize = 100;
  static const int _defaultPageSize = 20;

  /// 최적화된 사용자 운동 기록 조회
  Future<List<QueryDocumentSnapshot>> getOptimizedWorkoutRecords(
    String userId, {
    int limit = _defaultPageSize,
    DocumentSnapshot? startAfter,
    DateTime? startDate,
    DateTime? endDate,
    String? exerciseType,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      // 캐시 키 생성
      final cacheKey =
          'workout_records_${userId}_${limit}_${startDate?.toString()}_${endDate?.toString()}_$exerciseType';

      // 캐시된 결과 확인
      final cachedResult = _getFromCache(cacheKey);
      if (cachedResult != null) {
        debugPrint('캐시에서 운동 기록 조회: $cacheKey');
        return cachedResult as List<QueryDocumentSnapshot>;
      }

      // 최적화된 쿼리 구성
      Query query = _firestore
          .collection('workoutRecords')
          .where('userId', isEqualTo: userId);

      // 날짜 범위 필터 (복합 인덱스 필요)
      if (startDate != null) {
        query = query.where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      if (endDate != null) {
        query = query.where('date',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      // 운동 타입 필터
      if (exerciseType != null) {
        query = query.where('exerciseType', isEqualTo: exerciseType);
      }

      // 정렬 및 제한 (인덱스 최적화)
      query = query.orderBy('date', descending: true).limit(limit);

      // 페이지네이션
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot =
          await query.get(const GetOptions(source: Source.serverAndCache));
      final docs = querySnapshot.docs;

      // 캐시에 저장
      _saveToCache(cacheKey, docs);

      // 메트릭 기록
      _recordQueryMetrics(QueryMetrics(
        executionTime: stopwatch.elapsed,
        documentsRead: docs.length,
        documentsWritten: 0,
        queryPath: 'workoutRecords',
        timestamp: DateTime.now(),
        useCache: false,
      ));

      return docs;
    } catch (e) {
      debugPrint('최적화된 운동 기록 조회 실패: $e');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  /// 최적화된 업적 조회
  Future<List<QueryDocumentSnapshot>> getOptimizedAchievements(
    String userId, {
    bool? completed,
    String? category,
    int limit = _defaultPageSize,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final cacheKey = 'achievements_${userId}_${completed}_${category}_$limit';
      final cachedResult = _getFromCache(cacheKey);

      if (cachedResult != null) {
        return cachedResult as List<QueryDocumentSnapshot>;
      }

      Query query = _firestore
          .collection('achievements')
          .where('userId', isEqualTo: userId);

      // 완료 상태 필터
      if (completed != null) {
        query = query.where('completed', isEqualTo: completed);
      }

      // 카테고리 필터
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      // 진행도 순으로 정렬 (미완료 업적 우선)
      query = query.orderBy('progress', descending: true).limit(limit);

      final querySnapshot = await query.get();
      final docs = querySnapshot.docs;

      _saveToCache(cacheKey, docs);

      _recordQueryMetrics(QueryMetrics(
        executionTime: stopwatch.elapsed,
        documentsRead: docs.length,
        documentsWritten: 0,
        queryPath: 'achievements',
        timestamp: DateTime.now(),
        useCache: false,
      ));

      return docs;
    } catch (e) {
      debugPrint('최적화된 업적 조회 실패: $e');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  /// 배치 운동 기록 저장 (성능 최적화)
  Future<void> batchSaveWorkoutRecords(
      List<Map<String, dynamic>> records) async {
    if (records.isEmpty) return;

    final stopwatch = Stopwatch()..start();

    try {
      final batch = _firestore.batch();
      int operationCount = 0;

      for (final record in records) {
        final docRef = _firestore.collection('workoutRecords').doc();
        batch.set(docRef, {
          ...record,
          'id': docRef.id,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        operationCount++;

        // Firestore 배치 제한 (500개)에 도달하면 커밋
        if (operationCount >= 500) {
          await batch.commit();
          operationCount = 0;
        }
      }

      // 남은 작업 커밋
      if (operationCount > 0) {
        await batch.commit();
      }

      // 캐시 무효화
      _invalidateCache('workout_records');

      _recordQueryMetrics(QueryMetrics(
        executionTime: stopwatch.elapsed,
        documentsRead: 0,
        documentsWritten: records.length,
        queryPath: 'workoutRecords_batch',
        timestamp: DateTime.now(),
        useCache: false,
      ));

      debugPrint('배치 운동 기록 저장 완료: ${records.length}개');
    } catch (e) {
      debugPrint('배치 운동 기록 저장 실패: $e');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  /// 통계 데이터 집계 쿼리 최적화
  Future<Map<String, dynamic>> getOptimizedUserStats(String userId) async {
    final stopwatch = Stopwatch()..start();

    try {
      final cacheKey = 'user_stats_$userId';
      final cachedResult = _getFromCache(cacheKey);

      if (cachedResult != null) {
        return cachedResult as Map<String, dynamic>;
      }

      // 병렬 쿼리 실행으로 성능 향상
      final futures = await Future.wait([
        _getTotalWorkouts(userId),
        _getCurrentStreak(userId),
        _getWeeklyProgress(userId),
        _getMonthlyProgress(userId),
      ]);

      final stats = {
        'totalWorkouts': futures[0],
        'currentStreak': futures[1],
        'weeklyProgress': futures[2],
        'monthlyProgress': futures[3],
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      _saveToCache(cacheKey, stats);

      _recordQueryMetrics(QueryMetrics(
        executionTime: stopwatch.elapsed,
        documentsRead: 50, // 추정값
        documentsWritten: 0,
        queryPath: 'user_stats_aggregated',
        timestamp: DateTime.now(),
        useCache: false,
      ));

      return stats;
    } catch (e) {
      debugPrint('최적화된 사용자 통계 조회 실패: $e');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  /// 총 운동 횟수 조회
  Future<int> _getTotalWorkouts(String userId) async {
    final query = await _firestore
        .collection('workoutRecords')
        .where('userId', isEqualTo: userId)
        .count()
        .get();

    return query.count ?? 0;
  }

  /// 현재 연속 기록 조회
  Future<int> _getCurrentStreak(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int streak = 0;

    for (int i = 0; i < 100; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final startOfDay = Timestamp.fromDate(checkDate);
      final endOfDay =
          Timestamp.fromDate(checkDate.add(const Duration(hours: 24)));

      final query = await _firestore
          .collection('workoutRecords')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        streak++;
      } else if (i > 0) {
        // 첫 날이 아닌데 기록이 없으면 연속 기록 종료
        break;
      }
    }

    return streak;
  }

  /// 주간 진행도 조회
  Future<List<int>> _getWeeklyProgress(String userId) async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final progress = <int>[];

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final startOfDay =
          Timestamp.fromDate(DateTime(day.year, day.month, day.day));
      final endOfDay =
          Timestamp.fromDate(DateTime(day.year, day.month, day.day + 1));

      final query = await _firestore
          .collection('workoutRecords')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .count()
          .get();

      progress.add(query.count ?? 0);
    }

    return progress;
  }

  /// 월간 진행도 조회
  Future<List<int>> _getMonthlyProgress(String userId) async {
    final now = DateTime.now();
    final progress = <int>[];

    for (int i = 0; i < 30; i++) {
      final day = now.subtract(Duration(days: i));
      final startOfDay =
          Timestamp.fromDate(DateTime(day.year, day.month, day.day));
      final endOfDay =
          Timestamp.fromDate(DateTime(day.year, day.month, day.day + 1));

      final query = await _firestore
          .collection('workoutRecords')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .count()
          .get();

      progress.add(query.count ?? 0);
    }

    return progress;
  }

  /// 캐시에서 데이터 가져오기
  dynamic _getFromCache(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return null;

    final isExpired = DateTime.now().difference(timestamp) > _cacheExpiration;
    if (isExpired) {
      _queryCache.remove(key);
      _cacheTimestamps.remove(key);
      return null;
    }

    return _queryCache[key];
  }

  /// 캐시에 데이터 저장
  void _saveToCache(String key, dynamic data) {
    // 캐시 크기 제한
    if (_queryCache.length >= _maxCacheSize) {
      _clearOldestCacheEntry();
    }

    _queryCache[key] = data;
    _cacheTimestamps[key] = DateTime.now();
  }

  /// 가장 오래된 캐시 항목 제거
  void _clearOldestCacheEntry() {
    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _cacheTimestamps.entries) {
      if (oldestTime == null || entry.value.isBefore(oldestTime)) {
        oldestTime = entry.value;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _queryCache.remove(oldestKey);
      _cacheTimestamps.remove(oldestKey);
    }
  }

  /// 특정 패턴의 캐시 무효화
  void _invalidateCache(String pattern) {
    final keysToRemove = <String>[];

    for (final key in _queryCache.keys) {
      if (key.contains(pattern)) {
        keysToRemove.add(key);
      }
    }

    for (final key in keysToRemove) {
      _queryCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  /// 쿼리 메트릭 기록
  void _recordQueryMetrics(QueryMetrics metrics) {
    _queryMetrics.add(metrics);

    // 메트릭 제한 (최근 1000개만 유지)
    if (_queryMetrics.length > 1000) {
      _queryMetrics.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint(
          '쿼리 성능: ${metrics.queryPath} - ${metrics.executionTime.inMilliseconds}ms');
    }
  }

  /// 성능 분석 리포트
  Map<String, dynamic> getPerformanceReport() {
    if (_queryMetrics.isEmpty) {
      return {'message': '수집된 메트릭이 없습니다'};
    }

    final totalQueries = _queryMetrics.length;
    final totalTime = _queryMetrics.fold<int>(
      0,
      (sum, metric) => sum + metric.executionTime.inMilliseconds,
    );
    final averageTime = totalTime / totalQueries;

    final slowQueries = _queryMetrics
        .where((metric) => metric.executionTime.inMilliseconds > 1000)
        .length;

    final cacheHitRate =
        _queryMetrics.where((metric) => metric.useCache).length /
            totalQueries *
            100;

    return {
      'total_queries': totalQueries,
      'average_execution_time_ms': averageTime.round(),
      'slow_queries_count': slowQueries,
      'cache_hit_rate_percent': cacheHitRate.round(),
      'total_documents_read': _queryMetrics.fold<int>(
        0,
        (sum, metric) => sum + metric.documentsRead,
      ),
      'total_documents_written': _queryMetrics.fold<int>(
        0,
        (sum, metric) => sum + metric.documentsWritten,
      ),
    };
  }

  /// 캐시 전체 삭제
  void clearCache() {
    _queryCache.clear();
    _cacheTimestamps.clear();
    debugPrint('쿼리 캐시 전체 삭제');
  }

  /// 쿼리 최적화 제안
  List<String> getOptimizationSuggestions() {
    final suggestions = <String>[];
    final report = getPerformanceReport();

    if (report['slow_queries_count'] as int > 0) {
      suggestions.add('느린 쿼리 ${report['slow_queries_count']}개 발견 - 인덱스 최적화 권장');
    }

    if ((report['cache_hit_rate_percent'] as int) < 50) {
      suggestions.add(
          '캐시 적중률이 낮음 (${report['cache_hit_rate_percent']}%) - 캐싱 전략 개선 권장');
    }

    if ((report['total_documents_read'] as int) > 10000) {
      suggestions.add('과도한 문서 읽기 감지 - 쿼리 범위 축소 또는 페이지네이션 권장');
    }

    if (suggestions.isEmpty) {
      suggestions.add('현재 쿼리 성능이 양호합니다');
    }

    return suggestions;
  }
}
