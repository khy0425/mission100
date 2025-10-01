import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 배치 작업 타입
enum BatchOperationType {
  create,
  update,
  delete,
  mixed,
}

/// 배치 작업 항목
class BatchOperation {
  final String collection;
  final String? documentId;
  final Map<String, dynamic>? data;
  final BatchOperationType type;
  final DateTime timestamp;

  const BatchOperation({
    required this.collection,
    this.documentId,
    this.data,
    required this.type,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'BatchOperation(${type.name}: $collection${documentId != null ? '/$documentId' : ''})';
  }
}

/// 배치 처리 결과
class BatchResult {
  final int successCount;
  final int failureCount;
  final List<String> errors;
  final Duration processingTime;
  final DateTime completedAt;

  const BatchResult({
    required this.successCount,
    required this.failureCount,
    required this.errors,
    required this.processingTime,
    required this.completedAt,
  });

  bool get isSuccess => failureCount == 0;
  int get totalOperations => successCount + failureCount;

  Map<String, dynamic> toJson() {
    return {
      'success_count': successCount,
      'failure_count': failureCount,
      'total_operations': totalOperations,
      'errors': errors,
      'processing_time_ms': processingTime.inMilliseconds,
      'completed_at': completedAt.toIso8601String(),
      'is_success': isSuccess,
    };
  }
}

/// 배치 처리 설정
class BatchConfig {
  final int maxBatchSize;
  final Duration flushInterval;
  final int maxRetries;
  final Duration retryDelay;
  final bool autoFlush;

  const BatchConfig({
    this.maxBatchSize = 500, // Firestore 제한
    this.flushInterval = const Duration(seconds: 30),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.autoFlush = true,
  });
}

/// 배치 통계
class BatchStats {
  int totalBatches = 0;
  int totalOperations = 0;
  int totalFailures = 0;
  Duration totalProcessingTime = Duration.zero;
  DateTime? lastFlush;

  double get averageProcessingTime =>
      totalBatches > 0 ? totalProcessingTime.inMilliseconds / totalBatches : 0.0;

  double get successRate =>
      totalOperations > 0 ? (totalOperations - totalFailures) / totalOperations : 1.0;

  Map<String, dynamic> toJson() {
    return {
      'total_batches': totalBatches,
      'total_operations': totalOperations,
      'total_failures': totalFailures,
      'average_processing_time_ms': averageProcessingTime,
      'success_rate': successRate,
      'last_flush': lastFlush?.toIso8601String(),
    };
  }

  void reset() {
    totalBatches = 0;
    totalOperations = 0;
    totalFailures = 0;
    totalProcessingTime = Duration.zero;
    lastFlush = null;
  }
}

/// 배치 처리기
class BatchProcessor {
  static final BatchProcessor _instance = BatchProcessor._internal();
  factory BatchProcessor() => _instance;
  BatchProcessor._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Queue<BatchOperation> _operationQueue = Queue<BatchOperation>();
  final BatchStats _stats = BatchStats();

  BatchConfig _config = const BatchConfig();
  Timer? _flushTimer;
  bool _isProcessing = false;

  /// 초기화
  void initialize({BatchConfig? config}) {
    _config = config ?? const BatchConfig();

    if (_config.autoFlush) {
      _startAutoFlush();
    }

    debugPrint('배치 처리기 초기화 완료 (maxSize: ${_config.maxBatchSize}, interval: ${_config.flushInterval.inSeconds}s)');
  }

  /// 생성 작업 추가
  void addCreate(String collection, Map<String, dynamic> data, {String? documentId}) {
    final operation = BatchOperation(
      collection: collection,
      documentId: documentId,
      data: data,
      type: BatchOperationType.create,
      timestamp: DateTime.now(),
    );

    _addOperation(operation);
  }

  /// 업데이트 작업 추가
  void addUpdate(String collection, String documentId, Map<String, dynamic> data) {
    final operation = BatchOperation(
      collection: collection,
      documentId: documentId,
      data: data,
      type: BatchOperationType.update,
      timestamp: DateTime.now(),
    );

    _addOperation(operation);
  }

  /// 삭제 작업 추가
  void addDelete(String collection, String documentId) {
    final operation = BatchOperation(
      collection: collection,
      documentId: documentId,
      type: BatchOperationType.delete,
      timestamp: DateTime.now(),
    );

    _addOperation(operation);
  }

  /// 작업 큐에 추가
  void _addOperation(BatchOperation operation) {
    _operationQueue.add(operation);

    debugPrint('배치 작업 추가: ${operation.toString()} (큐 크기: ${_operationQueue.length})');

    // 최대 크기에 도달하면 즉시 플러시
    if (_operationQueue.length >= _config.maxBatchSize) {
      flush();
    }
  }

  /// 배치 플러시 (즉시 실행)
  Future<BatchResult> flush() async {
    if (_isProcessing || _operationQueue.isEmpty) {
      return BatchResult(
        successCount: 0,
        failureCount: 0,
        errors: [],
        processingTime: Duration.zero,
        completedAt: DateTime.now(),
      );
    }

    _isProcessing = true;
    final stopwatch = Stopwatch()..start();

    try {
      final operations = <BatchOperation>[];

      // 최대 배치 크기만큼 작업 추출
      final batchSize = _operationQueue.length > _config.maxBatchSize
          ? _config.maxBatchSize
          : _operationQueue.length;

      for (int i = 0; i < batchSize; i++) {
        if (_operationQueue.isNotEmpty) {
          operations.add(_operationQueue.removeFirst());
        }
      }

      if (operations.isEmpty) {
        return BatchResult(
          successCount: 0,
          failureCount: 0,
          errors: [],
          processingTime: stopwatch.elapsed,
          completedAt: DateTime.now(),
        );
      }

      debugPrint('배치 처리 시작: ${operations.length}개 작업');

      final result = await _processBatch(operations);

      // 통계 업데이트
      _stats.totalBatches++;
      _stats.totalOperations += result.totalOperations;
      _stats.totalFailures += result.failureCount;
      _stats.totalProcessingTime += result.processingTime;
      _stats.lastFlush = DateTime.now();

      debugPrint('배치 처리 완료: ${result.successCount}/${result.totalOperations} 성공');

      return result;

    } catch (e) {
      debugPrint('배치 플러시 실패: $e');
      return BatchResult(
        successCount: 0,
        failureCount: _operationQueue.length,
        errors: [e.toString()],
        processingTime: stopwatch.elapsed,
        completedAt: DateTime.now(),
      );
    } finally {
      _isProcessing = false;
      stopwatch.stop();
    }
  }

  /// 배치 작업 실제 처리
  Future<BatchResult> _processBatch(List<BatchOperation> operations) async {
    final errors = <String>[];
    int successCount = 0;
    int retryCount = 0;

    while (retryCount <= _config.maxRetries) {
      try {
        final batch = _firestore.batch();

        for (final operation in operations) {
          final docRef = operation.documentId != null
              ? _firestore.collection(operation.collection).doc(operation.documentId)
              : _firestore.collection(operation.collection).doc();

          switch (operation.type) {
            case BatchOperationType.create:
              batch.set(docRef, {
                ...operation.data!,
                'id': docRef.id,
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              });
              break;

            case BatchOperationType.update:
              batch.update(docRef, {
                ...operation.data!,
                'updatedAt': FieldValue.serverTimestamp(),
              });
              break;

            case BatchOperationType.delete:
              batch.delete(docRef);
              break;

            case BatchOperationType.mixed:
              throw UnimplementedError('Mixed batch operations not supported in single batch');
          }
        }

        await batch.commit();
        successCount = operations.length;
        break; // 성공 시 재시도 루프 탈출

      } catch (e) {
        retryCount++;
        errors.add('Attempt $retryCount: $e');

        if (retryCount <= _config.maxRetries) {
          debugPrint('배치 처리 실패, 재시도 $retryCount/${_config.maxRetries}: $e');
          await Future.delayed(_config.retryDelay);
        } else {
          debugPrint('배치 처리 최종 실패: $e');
        }
      }
    }

    return BatchResult(
      successCount: successCount,
      failureCount: operations.length - successCount,
      errors: errors,
      processingTime: Duration.zero, // 실제 구현에서는 측정 필요
      completedAt: DateTime.now(),
    );
  }

  /// 자동 플러시 시작
  void _startAutoFlush() {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(_config.flushInterval, (_) {
      if (_operationQueue.isNotEmpty) {
        flush();
      }
    });
  }

  /// 자동 플러시 중지
  void stopAutoFlush() {
    _flushTimer?.cancel();
    _flushTimer = null;
  }

  /// 큐 상태 조회
  Map<String, dynamic> getQueueStatus() {
    return {
      'queue_size': _operationQueue.length,
      'is_processing': _isProcessing,
      'auto_flush_enabled': _flushTimer != null,
      'next_flush_in_seconds': _flushTimer != null
          ? _config.flushInterval.inSeconds
          : null,
    };
  }

  /// 통계 조회
  BatchStats getStats() => _stats;

  /// 모든 작업 완료까지 대기
  Future<BatchResult> flushAndWait() async {
    final results = <BatchResult>[];

    while (_operationQueue.isNotEmpty || _isProcessing) {
      final result = await flush();
      if (result.totalOperations > 0) {
        results.add(result);
      }

      // 처리 중이면 잠시 대기
      if (_isProcessing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    // 결과 집계
    final totalSuccess = results.fold<int>(0, (sum, r) => sum + r.successCount);
    final totalFailure = results.fold<int>(0, (sum, r) => sum + r.failureCount);
    final allErrors = results.expand((r) => r.errors).toList();
    final totalTime = results.fold<Duration>(
      Duration.zero,
      (sum, r) => sum + r.processingTime,
    );

    return BatchResult(
      successCount: totalSuccess,
      failureCount: totalFailure,
      errors: allErrors,
      processingTime: totalTime,
      completedAt: DateTime.now(),
    );
  }

  /// 특정 컬렉션의 대량 업데이트
  Future<BatchResult> bulkUpdate(
    String collection,
    List<Map<String, dynamic>> documents,
    String idField,
  ) async {
    final operations = documents.map((doc) {
      return BatchOperation(
        collection: collection,
        documentId: doc[idField]?.toString(),
        data: Map<String, dynamic>.from(doc)..remove(idField),
        type: BatchOperationType.update,
        timestamp: DateTime.now(),
      );
    }).toList();

    return await _processBatchList(operations);
  }

  /// 특정 컬렉션의 대량 생성
  Future<BatchResult> bulkCreate(
    String collection,
    List<Map<String, dynamic>> documents,
  ) async {
    final operations = documents.map((doc) {
      return BatchOperation(
        collection: collection,
        data: doc,
        type: BatchOperationType.create,
        timestamp: DateTime.now(),
      );
    }).toList();

    return await _processBatchList(operations);
  }

  /// 여러 배치로 나누어 처리
  Future<BatchResult> _processBatchList(List<BatchOperation> operations) async {
    final results = <BatchResult>[];

    // 최대 배치 크기로 나누어 처리
    for (int i = 0; i < operations.length; i += _config.maxBatchSize) {
      final end = (i + _config.maxBatchSize < operations.length)
          ? i + _config.maxBatchSize
          : operations.length;

      final batchOperations = operations.sublist(i, end);
      final result = await _processBatch(batchOperations);
      results.add(result);

      // 배치 간 간격 (rate limiting)
      if (end < operations.length) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    // 결과 집계
    final totalSuccess = results.fold<int>(0, (sum, r) => sum + r.successCount);
    final totalFailure = results.fold<int>(0, (sum, r) => sum + r.failureCount);
    final allErrors = results.expand((r) => r.errors).toList();
    final totalTime = results.fold<Duration>(
      Duration.zero,
      (sum, r) => sum + r.processingTime,
    );

    return BatchResult(
      successCount: totalSuccess,
      failureCount: totalFailure,
      errors: allErrors,
      processingTime: totalTime,
      completedAt: DateTime.now(),
    );
  }

  /// 큐 비우기 (취소)
  void clearQueue() {
    _operationQueue.clear();
    debugPrint('배치 큐 비우기 완료');
  }

  /// 설정 업데이트
  void updateConfig(BatchConfig newConfig) {
    _config = newConfig;

    if (_config.autoFlush) {
      _startAutoFlush();
    } else {
      stopAutoFlush();
    }

    debugPrint('배치 설정 업데이트 완료');
  }

  /// 디버그 정보 출력
  void printDebugInfo() {
    if (kDebugMode) {
      final queueStatus = getQueueStatus();
      final stats = getStats();

      debugPrint('=== 배치 처리기 상태 ===');
      debugPrint('큐 크기: ${queueStatus['queue_size']}');
      debugPrint('처리 중: ${queueStatus['is_processing']}');
      debugPrint('총 배치: ${stats.totalBatches}');
      debugPrint('총 작업: ${stats.totalOperations}');
      debugPrint('성공률: ${(stats.successRate * 100).toStringAsFixed(1)}%');
      debugPrint('평균 처리시간: ${stats.averageProcessingTime.toStringAsFixed(1)}ms');
      debugPrint('=========================');
    }
  }

  /// 리소스 정리
  void dispose() {
    stopAutoFlush();
    clearQueue();
    debugPrint('배치 처리기 정리 완료');
  }
}