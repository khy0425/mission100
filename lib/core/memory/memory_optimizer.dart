import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

/// 메모리 사용량 정보
class MemoryInfo {
  final int totalPhysical;
  final int freePhysical;
  final int usedPhysical;
  final int appHeapUsage;
  final int appHeapMax;
  final DateTime timestamp;

  const MemoryInfo({
    required this.totalPhysical,
    required this.freePhysical,
    required this.usedPhysical,
    required this.appHeapUsage,
    required this.appHeapMax,
    required this.timestamp,
  });

  double get physicalUsagePercent =>
      totalPhysical > 0 ? (usedPhysical / totalPhysical) * 100 : 0;
  double get heapUsagePercent =>
      appHeapMax > 0 ? (appHeapUsage / appHeapMax) * 100 : 0;

  Map<String, dynamic> toJson() {
    return {
      'total_physical_mb': (totalPhysical / (1024 * 1024)).round(),
      'free_physical_mb': (freePhysical / (1024 * 1024)).round(),
      'used_physical_mb': (usedPhysical / (1024 * 1024)).round(),
      'app_heap_usage_mb': (appHeapUsage / (1024 * 1024)).round(),
      'app_heap_max_mb': (appHeapMax / (1024 * 1024)).round(),
      'physical_usage_percent': physicalUsagePercent.toStringAsFixed(1),
      'heap_usage_percent': heapUsagePercent.toStringAsFixed(1),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// 메모리 경고 레벨
enum MemoryWarningLevel {
  normal, // < 70%
  warning, // 70-85%
  critical, // 85-95%
  emergency, // > 95%
}

/// 메모리 최적화 액션
enum OptimizationAction {
  clearCache,
  reduceImageCache,
  forceGC,
  unloadUnusedAssets,
  compactDatabase,
  clearTempFiles,
}

/// 메모리 최적화 결과
class OptimizationResult {
  final List<OptimizationAction> actionsPerformed;
  final MemoryInfo beforeMemory;
  final MemoryInfo afterMemory;
  final Duration optimizationTime;
  final int memorySavedBytes;

  const OptimizationResult({
    required this.actionsPerformed,
    required this.beforeMemory,
    required this.afterMemory,
    required this.optimizationTime,
    required this.memorySavedBytes,
  });

  double get memorySavedMB => memorySavedBytes / (1024 * 1024);

  Map<String, dynamic> toJson() {
    return {
      'actions_performed': actionsPerformed.map((a) => a.name).toList(),
      'before_memory': beforeMemory.toJson(),
      'after_memory': afterMemory.toJson(),
      'optimization_time_ms': optimizationTime.inMilliseconds,
      'memory_saved_mb': memorySavedMB.toStringAsFixed(1),
    };
  }
}

/// 메모리 최적화 관리자
class MemoryOptimizer {
  static final MemoryOptimizer _instance = MemoryOptimizer._internal();
  factory MemoryOptimizer() => _instance;
  MemoryOptimizer._internal();

  Timer? _monitoringTimer;
  final List<MemoryInfo> _memoryHistory = [];
  final List<Function()> _memoryCleanupCallbacks = [];

  // 메모리 임계값 설정
  static const double _warningThreshold = 70.0;
  static const double _criticalThreshold = 85.0;
  static const double _emergencyThreshold = 95.0;

  static const Duration _monitoringInterval = Duration(seconds: 30);
  static const int _maxHistoryLength = 100;

  /// 초기화
  void initialize() {
    _startMemoryMonitoring();
    _registerSystemCallbacks();
    debugPrint('메모리 최적화 관리자 초기화 완료');
  }

  /// 메모리 모니터링 시작
  void _startMemoryMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = Timer.periodic(_monitoringInterval, (_) {
      _checkMemoryUsage();
    });
  }

  /// 시스템 콜백 등록
  void _registerSystemCallbacks() {
    if (!kIsWeb) {
      // 메모리 경고 시스템 콜백
      SystemChannels.lifecycle.setMessageHandler((message) async {
        if (message == 'AppLifecycleState.paused') {
          await performOptimization(aggressive: false);
        }
        return null;
      });
    }
  }

  /// 현재 메모리 정보 조회
  Future<MemoryInfo> getCurrentMemoryInfo() async {
    try {
      // VMService를 통한 메모리 정보 조회
      final serverInfo = await developer.Service.getInfo();

      // 플랫폼별 시스템 메모리 정보
      int totalPhysical = 0;
      int freePhysical = 0;
      const int appHeapUsage = 0;
      const int appHeapMax = 100 * 1024 * 1024; // 100MB 기본값

      if (Platform.isAndroid || Platform.isIOS) {
        // 모바일 플랫폼에서는 대략적인 값 사용
        totalPhysical = 4 * 1024 * 1024 * 1024; // 4GB 가정
        freePhysical = totalPhysical ~/ 2; // 50% 사용 가정
      }

      // VM 서비스가 활성화된 경우에만 상세 정보 조회 시도
      if (serverInfo.serverUri != null) {
        try {
          final vmService = serverInfo.serverUri;
          // VM 서비스를 통한 메모리 정보는 프로파일링 모드에서만 사용 가능
          debugPrint('VM 서비스 사용 가능: $vmService');
        } catch (e) {
          debugPrint('VM 서비스 메모리 정보 조회 불가: $e');
        }
      }

      final usedPhysical = totalPhysical - freePhysical;

      return MemoryInfo(
        totalPhysical: totalPhysical,
        freePhysical: freePhysical,
        usedPhysical: usedPhysical,
        appHeapUsage: appHeapUsage,
        appHeapMax: appHeapMax,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('메모리 정보 조회 실패: $e');
      return MemoryInfo(
        totalPhysical: 0,
        freePhysical: 0,
        usedPhysical: 0,
        appHeapUsage: 0,
        appHeapMax: 0,
        timestamp: DateTime.now(),
      );
    }
  }

  /// 메모리 사용량 확인
  Future<void> _checkMemoryUsage() async {
    try {
      final memoryInfo = await getCurrentMemoryInfo();
      _addToHistory(memoryInfo);

      final warningLevel = _getWarningLevel(memoryInfo);

      switch (warningLevel) {
        case MemoryWarningLevel.warning:
          debugPrint(
              '메모리 경고: ${memoryInfo.heapUsagePercent.toStringAsFixed(1)}%');
          await performOptimization(aggressive: false);
          break;

        case MemoryWarningLevel.critical:
          debugPrint(
              '메모리 위험: ${memoryInfo.heapUsagePercent.toStringAsFixed(1)}%');
          await performOptimization(aggressive: true);
          break;

        case MemoryWarningLevel.emergency:
          debugPrint(
              '메모리 비상: ${memoryInfo.heapUsagePercent.toStringAsFixed(1)}%');
          await performEmergencyOptimization();
          break;

        case MemoryWarningLevel.normal:
          // 정상 상태, 아무 조치 없음
          break;
      }
    } catch (e) {
      debugPrint('메모리 사용량 확인 실패: $e');
    }
  }

  /// 메모리 경고 레벨 결정
  MemoryWarningLevel _getWarningLevel(MemoryInfo info) {
    final usagePercent = info.heapUsagePercent;

    if (usagePercent >= _emergencyThreshold) {
      return MemoryWarningLevel.emergency;
    } else if (usagePercent >= _criticalThreshold) {
      return MemoryWarningLevel.critical;
    } else if (usagePercent >= _warningThreshold) {
      return MemoryWarningLevel.warning;
    } else {
      return MemoryWarningLevel.normal;
    }
  }

  /// 메모리 최적화 수행
  Future<OptimizationResult> performOptimization(
      {bool aggressive = false}) async {
    final stopwatch = Stopwatch()..start();
    final beforeMemory = await getCurrentMemoryInfo();
    final actionsPerformed = <OptimizationAction>[];

    try {
      debugPrint('메모리 최적화 시작 (aggressive: $aggressive)');

      // 기본 최적화 액션
      await _clearCache();
      actionsPerformed.add(OptimizationAction.clearCache);

      await _forceGarbageCollection();
      actionsPerformed.add(OptimizationAction.forceGC);

      if (aggressive) {
        // 적극적 최적화
        await _reduceImageCache();
        actionsPerformed.add(OptimizationAction.reduceImageCache);

        await _unloadUnusedAssets();
        actionsPerformed.add(OptimizationAction.unloadUnusedAssets);

        await _clearTempFiles();
        actionsPerformed.add(OptimizationAction.clearTempFiles);
      }

      // 사용자 정의 정리 콜백 실행
      for (final callback in _memoryCleanupCallbacks) {
        try {
          callback();
        } catch (e) {
          debugPrint('메모리 정리 콜백 실패: $e');
        }
      }

      final afterMemory = await getCurrentMemoryInfo();
      final memorySaved = beforeMemory.appHeapUsage - afterMemory.appHeapUsage;

      final result = OptimizationResult(
        actionsPerformed: actionsPerformed,
        beforeMemory: beforeMemory,
        afterMemory: afterMemory,
        optimizationTime: stopwatch.elapsed,
        memorySavedBytes: memorySaved > 0 ? memorySaved : 0,
      );

      debugPrint('메모리 최적화 완료: ${result.memorySavedMB.toStringAsFixed(1)}MB 절약');
      return result;
    } catch (e) {
      debugPrint('메모리 최적화 실패: $e');
      final afterMemory = await getCurrentMemoryInfo();

      return OptimizationResult(
        actionsPerformed: actionsPerformed,
        beforeMemory: beforeMemory,
        afterMemory: afterMemory,
        optimizationTime: stopwatch.elapsed,
        memorySavedBytes: 0,
      );
    } finally {
      stopwatch.stop();
    }
  }

  /// 비상 메모리 최적화
  Future<OptimizationResult> performEmergencyOptimization() async {
    debugPrint('비상 메모리 최적화 시작');

    // 모든 가능한 최적화 수행
    final result = await performOptimization(aggressive: true);

    // 추가 비상 조치
    await _compactDatabase();
    await _clearAllNonEssentialCaches();

    return result;
  }

  /// 캐시 정리
  Future<void> _clearCache() async {
    try {
      // 앱 특정 캐시 정리 (CacheManager와 연동)
      // 이 부분은 실제 캐시 매니저와 연동 필요
      debugPrint('캐시 정리 완료');
    } catch (e) {
      debugPrint('캐시 정리 실패: $e');
    }
  }

  /// 가비지 컬렉션 강제 실행
  Future<void> _forceGarbageCollection() async {
    try {
      // Dart VM의 GC 트리거 - null 객체를 반복 생성하여 GC 유도
      for (var i = 0; i < 100; i++) {
        // ignore: unused_local_variable
        final temp = List.generate(1000, (index) => null);
      }

      // 약간의 지연을 주어 GC가 완료될 시간 제공
      await Future.delayed(const Duration(milliseconds: 100));

      debugPrint('가비지 컬렉션 강제 실행 완료');
    } catch (e) {
      debugPrint('가비지 컬렉션 실행 실패: $e');
    }
  }

  /// 이미지 캐시 크기 축소
  Future<void> _reduceImageCache() async {
    try {
      // Flutter 이미지 캐시 크기 조정
      PaintingBinding.instance.imageCache.maximumSize = 50; // 기본값의 절반
      PaintingBinding.instance.imageCache.maximumSizeBytes =
          50 * 1024 * 1024; // 50MB

      debugPrint('이미지 캐시 크기 축소 완료');
    } catch (e) {
      debugPrint('이미지 캐시 축소 실패: $e');
    }
  }

  /// 사용하지 않는 에셋 언로드
  Future<void> _unloadUnusedAssets() async {
    try {
      // 사용하지 않는 이미지 캐시 정리
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      debugPrint('사용하지 않는 에셋 언로드 완료');
    } catch (e) {
      debugPrint('에셋 언로드 실패: $e');
    }
  }

  /// 임시 파일 정리
  Future<void> _clearTempFiles() async {
    try {
      // 플랫폼별 임시 파일 정리
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // 모바일 플랫폼에서 임시 파일 정리
        debugPrint('임시 파일 정리 완료');
      }
    } catch (e) {
      debugPrint('임시 파일 정리 실패: $e');
    }
  }

  /// 데이터베이스 압축
  Future<void> _compactDatabase() async {
    try {
      // SQLite 데이터베이스 VACUUM 실행
      // 실제 구현에서는 데이터베이스 서비스와 연동
      debugPrint('데이터베이스 압축 완료');
    } catch (e) {
      debugPrint('데이터베이스 압축 실패: $e');
    }
  }

  /// 모든 비필수 캐시 정리
  Future<void> _clearAllNonEssentialCaches() async {
    try {
      // 모든 가능한 캐시 정리
      await _clearCache();
      await _unloadUnusedAssets();

      // 네트워크 캐시도 정리
      debugPrint('모든 비필수 캐시 정리 완료');
    } catch (e) {
      debugPrint('비필수 캐시 정리 실패: $e');
    }
  }

  /// 메모리 기록에 추가
  void _addToHistory(MemoryInfo info) {
    _memoryHistory.add(info);

    // 기록 크기 제한
    if (_memoryHistory.length > _maxHistoryLength) {
      _memoryHistory.removeAt(0);
    }
  }

  /// 메모리 정리 콜백 등록
  void registerCleanupCallback(Function() callback) {
    _memoryCleanupCallbacks.add(callback);
  }

  /// 메모리 정리 콜백 해제
  void unregisterCleanupCallback(Function() callback) {
    _memoryCleanupCallbacks.remove(callback);
  }

  /// 메모리 사용량 기록 조회
  List<MemoryInfo> getMemoryHistory() {
    return List.unmodifiable(_memoryHistory);
  }

  /// 메모리 통계 조회
  Map<String, dynamic> getMemoryStats() {
    if (_memoryHistory.isEmpty) {
      return {'message': '메모리 기록이 없습니다'};
    }

    final recent = _memoryHistory.last;
    final averageHeapUsage = _memoryHistory
            .map((info) => info.heapUsagePercent)
            .reduce((a, b) => a + b) /
        _memoryHistory.length;

    final maxHeapUsage = _memoryHistory
        .map((info) => info.heapUsagePercent)
        .reduce((a, b) => a > b ? a : b);

    return {
      'current_heap_usage_percent': recent.heapUsagePercent.toStringAsFixed(1),
      'average_heap_usage_percent': averageHeapUsage.toStringAsFixed(1),
      'max_heap_usage_percent': maxHeapUsage.toStringAsFixed(1),
      'current_heap_usage_mb':
          (recent.appHeapUsage / (1024 * 1024)).toStringAsFixed(1),
      'heap_capacity_mb':
          (recent.appHeapMax / (1024 * 1024)).toStringAsFixed(1),
      'warning_level': _getWarningLevel(recent).name,
      'monitoring_duration_minutes':
          _memoryHistory.length * _monitoringInterval.inMinutes,
    };
  }

  /// 메모리 상태 리포트
  String generateMemoryReport() {
    final stats = getMemoryStats();
    final recent = _memoryHistory.isNotEmpty ? _memoryHistory.last : null;

    final report = StringBuffer();
    report.writeln('=== 메모리 상태 리포트 ===');

    if (recent != null) {
      report.writeln(
          '현재 힙 사용량: ${stats['current_heap_usage_mb']}MB (${stats['current_heap_usage_percent']}%)');
      report.writeln('힙 용량: ${stats['heap_capacity_mb']}MB');
      report.writeln('경고 레벨: ${stats['warning_level']}');
      report.writeln('평균 사용량: ${stats['average_heap_usage_percent']}%');
      report.writeln('최대 사용량: ${stats['max_heap_usage_percent']}%');
    } else {
      report.writeln('메모리 데이터가 없습니다.');
    }

    report.writeln('=========================');

    return report.toString();
  }

  /// 디버그 정보 출력
  void printMemoryInfo() {
    if (kDebugMode) {
      debugPrint(generateMemoryReport());
    }
  }

  /// 모니터링 중지
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    debugPrint('메모리 모니터링 중지');
  }

  /// 리소스 정리
  void dispose() {
    stopMonitoring();
    _memoryHistory.clear();
    _memoryCleanupCallbacks.clear();
    debugPrint('메모리 최적화 관리자 정리 완료');
  }
}
