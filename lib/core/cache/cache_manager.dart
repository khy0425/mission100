import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 캐시 정책
enum CachePolicy {
  noCache,          // 캐시 사용 안함
  cacheFirst,       // 캐시 우선
  networkFirst,     // 네트워크 우선
  cacheOnly,        // 캐시만 사용
  networkOnly,      // 네트워크만 사용
}

/// 캐시 아이템
class CacheItem<T> {
  final T data;
  final DateTime timestamp;
  final Duration? ttl;
  final String key;

  const CacheItem({
    required this.data,
    required this.timestamp,
    this.ttl,
    required this.key,
  });

  bool get isExpired {
    if (ttl == null) return false;
    return DateTime.now().difference(timestamp) > ttl!;
  }

  Duration get age => DateTime.now().difference(timestamp);

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'ttl_seconds': ttl?.inSeconds,
      'key': key,
    };
  }

  factory CacheItem.fromJson(Map<String, dynamic> json, String key) {
    return CacheItem<T>(
      data: json['data'] as T,
      timestamp: DateTime.parse(json['timestamp'] as String),
      ttl: json['ttl_seconds'] != null
          ? Duration(seconds: json['ttl_seconds'] as int)
          : null,
      key: key,
    );
  }
}

/// 캐시 통계
class CacheStats {
  int hits = 0;
  int misses = 0;
  int evictions = 0;
  int size = 0;

  double get hitRate => hits + misses > 0 ? hits / (hits + misses) : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'hits': hits,
      'misses': misses,
      'evictions': evictions,
      'size': size,
      'hit_rate': hitRate,
    };
  }

  void reset() {
    hits = 0;
    misses = 0;
    evictions = 0;
    size = 0;
  }
}

/// 다층 캐시 관리자
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  // 메모리 캐시 (L1)
  final Map<String, CacheItem> _memoryCache = {};

  // 영구 스토리지 캐시 (L2)
  SharedPreferences? _prefs;

  final CacheStats _stats = CacheStats();
  final Map<String, Timer> _cleanupTimers = {};

  // 캐시 설정
  static const int _maxMemoryCacheSize = 50;
  static const int _maxDiskCacheSize = 200;
  static const Duration _defaultTtl = Duration(minutes: 30);
  static const String _cachePrefix = 'app_cache_';

  /// 초기화
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadDiskCacheToMemory();
      _startPeriodicCleanup();
      debugPrint('캐시 매니저 초기화 완료');
    } catch (e) {
      debugPrint('캐시 매니저 초기화 실패: $e');
    }
  }

  /// 캐시에 데이터 저장
  Future<void> put<T>(
    String key,
    T data, {
    Duration? ttl,
    bool memoryOnly = false,
  }) async {
    try {
      final cacheItem = CacheItem<T>(
        data: data,
        timestamp: DateTime.now(),
        ttl: ttl ?? _defaultTtl,
        key: key,
      );

      // L1 메모리 캐시에 저장
      _memoryCache[key] = cacheItem;
      _manageMemoryCacheSize();

      // L2 디스크 캐시에 저장 (옵션)
      if (!memoryOnly && _prefs != null) {
        await _saveToDisk(key, cacheItem);
      }

      // TTL 기반 자동 정리 설정
      if (ttl != null) {
        _scheduleCleanup(key, ttl);
      }

      _stats.size = _memoryCache.length;
      debugPrint('캐시 저장: $key (TTL: ${ttl?.inMinutes ?? 30}분)');

    } catch (e) {
      debugPrint('캐시 저장 실패: $key - $e');
    }
  }

  /// 캐시에서 데이터 조회
  Future<T?> get<T>(String key, {CachePolicy policy = CachePolicy.cacheFirst}) async {
    try {
      switch (policy) {
        case CachePolicy.cacheFirst:
          return await _getCacheFirst<T>(key);
        case CachePolicy.cacheOnly:
          return await _getCacheOnly<T>(key);
        case CachePolicy.networkFirst:
        case CachePolicy.networkOnly:
        case CachePolicy.noCache:
          return null; // 네트워크 로직은 호출자에서 처리
      }
    } catch (e) {
      debugPrint('캐시 조회 실패: $key - $e');
      return null;
    }
  }

  /// 캐시 우선 조회
  Future<T?> _getCacheFirst<T>(String key) async {
    // L1 메모리 캐시 확인
    final memoryCacheItem = _memoryCache[key];
    if (memoryCacheItem != null && !memoryCacheItem.isExpired) {
      _stats.hits++;
      debugPrint('메모리 캐시 히트: $key');
      return memoryCacheItem.data as T?;
    }

    // L2 디스크 캐시 확인
    if (_prefs != null) {
      final diskCacheItem = await _loadFromDisk<T>(key);
      if (diskCacheItem != null && !diskCacheItem.isExpired) {
        // 디스크에서 메모리로 승격
        _memoryCache[key] = diskCacheItem;
        _stats.hits++;
        debugPrint('디스크 캐시 히트: $key');
        return diskCacheItem.data as T?;
      }
    }

    _stats.misses++;
    debugPrint('캐시 미스: $key');
    return null;
  }

  /// 캐시 전용 조회
  Future<T?> _getCacheOnly<T>(String key) async {
    return await _getCacheFirst<T>(key);
  }

  /// 특정 키 삭제
  Future<void> remove(String key) async {
    try {
      _memoryCache.remove(key);
      _cleanupTimers[key]?.cancel();
      _cleanupTimers.remove(key);

      if (_prefs != null) {
        await _prefs!.remove('$_cachePrefix$key');
      }

      _stats.size = _memoryCache.length;
      debugPrint('캐시 삭제: $key');

    } catch (e) {
      debugPrint('캐시 삭제 실패: $key - $e');
    }
  }

  /// 패턴 기반 캐시 삭제
  Future<void> removeByPattern(String pattern) async {
    try {
      final keysToRemove = <String>[];

      // 메모리 캐시에서 패턴 매칭
      for (final key in _memoryCache.keys) {
        if (key.contains(pattern)) {
          keysToRemove.add(key);
        }
      }

      // 디스크 캐시에서도 패턴 매칭
      if (_prefs != null) {
        final allKeys = _prefs!.getKeys();
        for (final key in allKeys) {
          if (key.startsWith(_cachePrefix) && key.contains(pattern)) {
            final originalKey = key.replaceFirst(_cachePrefix, '');
            keysToRemove.add(originalKey);
          }
        }
      }

      // 매칭된 키들 삭제
      for (final key in keysToRemove.toSet()) {
        await remove(key);
      }

      debugPrint('패턴 기반 캐시 삭제: $pattern (${keysToRemove.length}개)');

    } catch (e) {
      debugPrint('패턴 기반 캐시 삭제 실패: $pattern - $e');
    }
  }

  /// 전체 캐시 삭제
  Future<void> clear() async {
    try {
      // 메모리 캐시 삭제
      _memoryCache.clear();

      // 정리 타이머 취소
      for (final timer in _cleanupTimers.values) {
        timer.cancel();
      }
      _cleanupTimers.clear();

      // 디스크 캐시 삭제
      if (_prefs != null) {
        final allKeys = _prefs!.getKeys();
        for (final key in allKeys) {
          if (key.startsWith(_cachePrefix)) {
            await _prefs!.remove(key);
          }
        }
      }

      _stats.reset();
      debugPrint('전체 캐시 삭제 완료');

    } catch (e) {
      debugPrint('전체 캐시 삭제 실패: $e');
    }
  }

  /// 만료된 캐시 정리
  Future<void> cleanExpired() async {
    try {
      final expiredKeys = <String>[];

      // 메모리 캐시에서 만료된 항목 찾기
      for (final entry in _memoryCache.entries) {
        if (entry.value.isExpired) {
          expiredKeys.add(entry.key);
        }
      }

      // 만료된 항목 삭제
      for (final key in expiredKeys) {
        await remove(key);
        _stats.evictions++;
      }

      // 디스크 캐시도 정리
      await _cleanExpiredFromDisk();

      debugPrint('만료된 캐시 정리 완료: ${expiredKeys.length}개');

    } catch (e) {
      debugPrint('만료된 캐시 정리 실패: $e');
    }
  }

  /// 메모리 캐시 크기 관리 (LRU)
  void _manageMemoryCacheSize() {
    if (_memoryCache.length <= _maxMemoryCacheSize) return;

    // 가장 오래된 항목부터 제거
    final sortedEntries = _memoryCache.entries.toList()
      ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

    final itemsToRemove = _memoryCache.length - _maxMemoryCacheSize;
    for (int i = 0; i < itemsToRemove; i++) {
      final key = sortedEntries[i].key;
      _memoryCache.remove(key);
      _cleanupTimers[key]?.cancel();
      _cleanupTimers.remove(key);
      _stats.evictions++;
    }

    debugPrint('메모리 캐시 크기 조정: ${itemsToRemove}개 제거');
  }

  /// 디스크에 저장
  Future<void> _saveToDisk(String key, CacheItem cacheItem) async {
    try {
      if (_prefs == null) return;

      final jsonString = jsonEncode(cacheItem.toJson());
      await _prefs!.setString('$_cachePrefix$key', jsonString);

    } catch (e) {
      debugPrint('디스크 캐시 저장 실패: $key - $e');
    }
  }

  /// 디스크에서 로드
  Future<CacheItem<T>?> _loadFromDisk<T>(String key) async {
    try {
      if (_prefs == null) return null;

      final jsonString = _prefs!.getString('$_cachePrefix$key');
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return CacheItem<T>.fromJson(json, key);

    } catch (e) {
      debugPrint('디스크 캐시 로드 실패: $key - $e');
      return null;
    }
  }

  /// 디스크 캐시를 메모리로 로드
  Future<void> _loadDiskCacheToMemory() async {
    try {
      if (_prefs == null) return;

      final allKeys = _prefs!.getKeys();
      int loadedCount = 0;

      for (final key in allKeys) {
        if (key.startsWith(_cachePrefix)) {
          final originalKey = key.replaceFirst(_cachePrefix, '');
          final cacheItem = await _loadFromDisk(originalKey);

          if (cacheItem != null && !cacheItem.isExpired) {
            _memoryCache[originalKey] = cacheItem;
            loadedCount++;
          }
        }
      }

      _stats.size = _memoryCache.length;
      debugPrint('디스크 캐시 로드 완료: ${loadedCount}개');

    } catch (e) {
      debugPrint('디스크 캐시 로드 실패: $e');
    }
  }

  /// 디스크에서 만료된 캐시 정리
  Future<void> _cleanExpiredFromDisk() async {
    try {
      if (_prefs == null) return;

      final allKeys = _prefs!.getKeys();
      final expiredKeys = <String>[];

      for (final key in allKeys) {
        if (key.startsWith(_cachePrefix)) {
          final originalKey = key.replaceFirst(_cachePrefix, '');
          final cacheItem = await _loadFromDisk(originalKey);

          if (cacheItem != null && cacheItem.isExpired) {
            expiredKeys.add(key);
          }
        }
      }

      for (final key in expiredKeys) {
        await _prefs!.remove(key);
      }

      debugPrint('디스크 만료 캐시 정리: ${expiredKeys.length}개');

    } catch (e) {
      debugPrint('디스크 만료 캐시 정리 실패: $e');
    }
  }

  /// TTL 기반 자동 정리 스케줄링
  void _scheduleCleanup(String key, Duration ttl) {
    _cleanupTimers[key]?.cancel();
    _cleanupTimers[key] = Timer(ttl, () {
      remove(key);
    });
  }

  /// 주기적 정리 시작
  void _startPeriodicCleanup() {
    Timer.periodic(const Duration(hours: 1), (timer) {
      cleanExpired();
    });
  }

  /// 캐시 통계 조회
  CacheStats getStats() => _stats;

  /// 캐시 키 목록 조회
  List<String> getKeys() => _memoryCache.keys.toList();

  /// 캐시 크기 조회 (바이트)
  Future<int> getCacheSize() async {
    try {
      int totalSize = 0;

      // 메모리 캐시 크기 추정
      for (final item in _memoryCache.values) {
        final jsonString = jsonEncode(item.toJson());
        totalSize += jsonString.length * 2; // UTF-16 추정
      }

      // 디스크 캐시 크기
      if (_prefs != null) {
        final allKeys = _prefs!.getKeys();
        for (final key in allKeys) {
          if (key.startsWith(_cachePrefix)) {
            final value = _prefs!.getString(key);
            if (value != null) {
              totalSize += value.length * 2;
            }
          }
        }
      }

      return totalSize;

    } catch (e) {
      debugPrint('캐시 크기 계산 실패: $e');
      return 0;
    }
  }

  /// 캐시 정보 출력 (디버그용)
  Future<void> printCacheInfo() async {
    if (kDebugMode) {
      final stats = getStats();
      final cacheSize = await getCacheSize();

      debugPrint('=== 캐시 정보 ===');
      debugPrint('메모리 캐시 항목: ${_memoryCache.length}');
      debugPrint('캐시 히트율: ${(stats.hitRate * 100).toStringAsFixed(1)}%');
      debugPrint('총 캐시 크기: ${(cacheSize / 1024).toStringAsFixed(1)} KB');
      debugPrint('히트: ${stats.hits}, 미스: ${stats.misses}, 제거: ${stats.evictions}');
      debugPrint('==================');
    }
  }

  /// 리소스 정리
  void dispose() {
    for (final timer in _cleanupTimers.values) {
      timer.cancel();
    }
    _cleanupTimers.clear();
    _memoryCache.clear();
    debugPrint('캐시 매니저 리소스 정리 완료');
  }
}