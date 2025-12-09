import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 오프라인 작업 큐 서비스
///
/// 오프라인 상태에서 완료한 체크리스트를 저장하고,
/// 온라인으로 전환될 때 자동으로 서버에 동기화합니다.
class OfflineQueueService {
  static final OfflineQueueService _instance = OfflineQueueService._internal();
  factory OfflineQueueService() => _instance;
  OfflineQueueService._internal();

  static const String _queueKey = 'offline_sync_queue';
  static const String _lastSyncKey = 'last_sync_timestamp';

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isInitialized = false;
  bool _isSyncing = false;

  /// 동기화 콜백 (외부에서 설정)
  Future<bool> Function(Map<String, dynamic> action)? onSyncAction;

  /// 동기화 완료 콜백
  VoidCallback? onSyncCompleted;

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 네트워크 연결 상태 모니터링
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _onConnectivityChanged,
    );

    _isInitialized = true;
    debugPrint('📶 OfflineQueueService 초기화 완료');

    // 앱 시작 시 대기 중인 작업 동기화 시도
    await syncPendingActions();
  }

  /// 네트워크 상태 변경 처리
  void _onConnectivityChanged(List<ConnectivityResult> result) {
    final isOnline = result.any((r) => r != ConnectivityResult.none);

    if (isOnline) {
      debugPrint('🌐 네트워크 연결됨 - 대기 작업 동기화 시도');
      syncPendingActions();
    } else {
      debugPrint('📴 오프라인 모드');
    }
  }

  /// 오프라인 작업 추가
  Future<void> addToQueue({
    required String actionType,
    required Map<String, dynamic> data,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getStringList(_queueKey) ?? [];

      final action = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'actionType': actionType,
        'data': data,
        'createdAt': DateTime.now().toIso8601String(),
        'retryCount': 0,
      };

      queueJson.add(jsonEncode(action));
      await prefs.setStringList(_queueKey, queueJson);

      debugPrint('📝 오프라인 큐에 추가: $actionType');
    } catch (e) {
      debugPrint('❌ 오프라인 큐 추가 실패: $e');
    }
  }

  /// 체크리스트 완료 작업 추가
  Future<void> queueChecklistCompletion({
    required int weekNumber,
    required int dayNumber,
    required int completedTaskCount,
    required int totalTaskCount,
    required DateTime completedAt,
  }) async {
    await addToQueue(
      actionType: 'checklist_completion',
      data: {
        'weekNumber': weekNumber,
        'dayNumber': dayNumber,
        'completedTaskCount': completedTaskCount,
        'totalTaskCount': totalTaskCount,
        'completedAt': completedAt.toIso8601String(),
      },
    );
  }

  /// XP 획득 작업 추가
  Future<void> queueXPEarned({
    required int xpAmount,
    required String source,
    required DateTime earnedAt,
  }) async {
    await addToQueue(
      actionType: 'xp_earned',
      data: {
        'xpAmount': xpAmount,
        'source': source,
        'earnedAt': earnedAt.toIso8601String(),
      },
    );
  }

  /// 대기 중인 작업 동기화
  Future<void> syncPendingActions() async {
    if (_isSyncing) {
      debugPrint('⏳ 이미 동기화 중...');
      return;
    }

    // 네트워크 연결 확인
    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity.any((r) => r != ConnectivityResult.none);

    if (!isOnline) {
      debugPrint('📴 오프라인 상태 - 동기화 건너뜀');
      return;
    }

    _isSyncing = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getStringList(_queueKey) ?? [];

      if (queueJson.isEmpty) {
        debugPrint('✅ 대기 중인 작업 없음');
        _isSyncing = false;
        return;
      }

      debugPrint('🔄 ${queueJson.length}개 작업 동기화 시작...');

      final failedActions = <String>[];
      int successCount = 0;

      for (final actionJson in queueJson) {
        try {
          final action = jsonDecode(actionJson) as Map<String, dynamic>;
          final actionType = action['actionType'] as String;
          final data = action['data'] as Map<String, dynamic>;
          final retryCount = action['retryCount'] as int? ?? 0;

          // 동기화 콜백 호출
          bool success = false;
          if (onSyncAction != null) {
            success = await onSyncAction!(action);
          } else {
            // 기본 동기화 처리 (콜백이 없으면 성공으로 처리)
            success = true;
            debugPrint('📤 동기화: $actionType - ${jsonEncode(data)}');
          }

          if (success) {
            successCount++;
            debugPrint('✅ 동기화 성공: $actionType');
          } else {
            // 재시도 횟수 증가
            if (retryCount < 3) {
              action['retryCount'] = retryCount + 1;
              failedActions.add(jsonEncode(action));
              debugPrint('⚠️ 동기화 실패 (재시도 ${retryCount + 1}/3): $actionType');
            } else {
              debugPrint('❌ 동기화 최종 실패 (폐기): $actionType');
            }
          }
        } catch (e) {
          debugPrint('❌ 작업 처리 오류: $e');
        }
      }

      // 실패한 작업만 큐에 남김
      await prefs.setStringList(_queueKey, failedActions);

      // 마지막 동기화 시간 저장
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

      debugPrint('🎉 동기화 완료: $successCount/${queueJson.length} 성공');

      // 동기화 완료 콜백
      onSyncCompleted?.call();
    } catch (e) {
      debugPrint('❌ 동기화 오류: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// 대기 중인 작업 수
  Future<int> getPendingCount() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getStringList(_queueKey) ?? [];
    return queueJson.length;
  }

  /// 마지막 동기화 시간
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString(_lastSyncKey);
    if (lastSyncStr != null) {
      return DateTime.parse(lastSyncStr);
    }
    return null;
  }

  /// 현재 온라인 상태인지 확인
  Future<bool> isOnline() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity.any((r) => r != ConnectivityResult.none);
  }

  /// 큐 초기화 (테스트용)
  Future<void> clearQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
    debugPrint('🗑️ 오프라인 큐 초기화됨');
  }

  /// 리소스 정리
  void dispose() {
    _connectivitySubscription?.cancel();
    _isInitialized = false;
    debugPrint('📶 OfflineQueueService 정리됨');
  }
}

/// 오프라인 상태 표시 위젯
class OfflineIndicator extends StatefulWidget {
  final Widget child;

  const OfflineIndicator({
    super.key,
    required this.child,
  });

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOnline = result.any((r) => r != ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = result.any((r) => r != ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_isOnline)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.orange.shade100,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 16, color: Colors.orange),
                SizedBox(width: 6),
                Text(
                  '오프라인 모드 - 변경사항은 자동으로 저장됩니다',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}
