import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 일일 태스크 완료 상태 추적 서비스
///
/// 체크리스트 화면 외부에서도 태스크 완료를 자동으로 기록할 수 있도록 지원
/// - 꿈 일기 작성 시 'dream_journal' 태스크 자동 완료
/// - 오늘 날짜 기준으로 완료 상태 저장
/// - 자정이 지나면 자동으로 리셋
class DailyTaskCompletionService {
  static final DailyTaskCompletionService _instance =
      DailyTaskCompletionService._internal();

  factory DailyTaskCompletionService() => _instance;

  DailyTaskCompletionService._internal();

  static const String _keyPrefix = 'daily_task_completion_';
  static const String _dateKey = 'daily_task_date';

  /// 오늘 완료된 태스크 ID 목록 가져오기
  Future<Set<String>> getTodayCompletedTasks() async {
    final prefs = await SharedPreferences.getInstance();

    // 저장된 날짜 확인
    final savedDate = prefs.getString(_dateKey);
    final today = _getTodayDateString();

    // 날짜가 다르면 리셋
    if (savedDate != today) {
      await _resetTasks();
      return {};
    }

    // 완료된 태스크 목록 가져오기
    final completedTasks = prefs.getStringList(_keyPrefix + today) ?? [];
    return completedTasks.toSet();
  }

  /// 태스크 완료 표시
  Future<void> markTaskCompleted(String taskId) async {
    debugPrint('✅ 태스크 완료 표시: $taskId');

    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();

    // 오늘 날짜 저장
    await prefs.setString(_dateKey, today);

    // 현재 완료 목록 가져오기
    final completedTasks = await getTodayCompletedTasks();

    // 중복 체크 후 추가
    if (!completedTasks.contains(taskId)) {
      completedTasks.add(taskId);
      await prefs.setStringList(_keyPrefix + today, completedTasks.toList());
      debugPrint('💾 태스크 완료 저장됨: $taskId (총 ${completedTasks.length}개)');
    } else {
      debugPrint('⚠️ 이미 완료된 태스크: $taskId');
    }
  }

  /// 태스크 완료 취소
  Future<void> unmarkTaskCompleted(String taskId) async {
    debugPrint('❌ 태스크 완료 취소: $taskId');

    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();

    final completedTasks = await getTodayCompletedTasks();

    if (completedTasks.contains(taskId)) {
      completedTasks.remove(taskId);
      await prefs.setStringList(_keyPrefix + today, completedTasks.toList());
      debugPrint('💾 태스크 완료 취소 저장됨: $taskId');
    }
  }

  /// 특정 태스크가 오늘 완료되었는지 확인
  Future<bool> isTaskCompletedToday(String taskId) async {
    final completedTasks = await getTodayCompletedTasks();
    return completedTasks.contains(taskId);
  }

  /// 태스크 리셋 (새로운 날)
  Future<void> _resetTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();

    // 오늘 날짜로 초기화
    await prefs.setString(_dateKey, today);
    await prefs.setStringList(_keyPrefix + today, []);

    debugPrint('🔄 일일 태스크 리셋 완료: $today');
  }

  /// 오늘 날짜를 YYYY-MM-DD 형식으로 반환
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// 테스트용: 모든 데이터 삭제
  @visibleForTesting
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_keyPrefix) || key == _dateKey) {
        await prefs.remove(key);
      }
    }
    debugPrint('🗑️ 모든 일일 태스크 데이터 삭제됨');
  }
}
