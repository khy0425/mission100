import 'package:flutter/material.dart';

/// 운동 리마인더 설정 모델
class WorkoutReminderSettings {
  final bool isEnabled;
  final TimeOfDay time;
  final Set<int> activeDays; // 1=월요일, 2=화요일, ..., 7=일요일
  final bool requiresRestDay; // 무조건 하루는 쉬도록 강제

  const WorkoutReminderSettings({
    this.isEnabled = true,
    this.time = const TimeOfDay(hour: 18, minute: 0),
    this.activeDays = const {1, 2, 3, 4, 5}, // 기본: 월-금
    this.requiresRestDay = true,
  });

  /// 연속 운동일 체크 (최대 6일 연속 허용)
  bool get hasValidRestDay {
    if (!requiresRestDay) return true;
    if (activeDays.length >= 7) return false; // 매일은 불가능

    // 연속 6일 이상 운동하는지 체크
    final sortedDays = activeDays.toList()..sort();
    int consecutiveDays = 1;
    int maxConsecutive = 1;

    for (int i = 1; i < sortedDays.length; i++) {
      if (sortedDays[i] == sortedDays[i - 1] + 1) {
        consecutiveDays++;
        maxConsecutive = maxConsecutive > consecutiveDays
            ? maxConsecutive
            : consecutiveDays;
      } else {
        consecutiveDays = 1;
      }
    }

    // 일요일-월요일 연결 체크
    if (sortedDays.contains(7) && sortedDays.contains(1)) {
      consecutiveDays = 1;
      for (int day in [7, 1, 2, 3, 4, 5, 6]) {
        if (sortedDays.contains(day)) {
          consecutiveDays++;
          maxConsecutive = maxConsecutive > consecutiveDays
              ? maxConsecutive
              : consecutiveDays;
        } else {
          break;
        }
      }
    }

    return maxConsecutive <= 6; // 최대 6일 연속 허용
  }

  /// 특정 날짜에 알림이 활성화되어 있는지 확인
  bool isActiveOnDate(DateTime date) {
    if (!isEnabled) return false;
    return activeDays.contains(date.weekday);
  }

  /// 요일 이름 반환
  static String getWeekdayName(int weekday, {bool short = false}) {
    const fullNames = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    const shortNames = ['월', '화', '수', '목', '금', '토', '일'];

    if (weekday < 1 || weekday > 7) return '';
    return short ? shortNames[weekday - 1] : fullNames[weekday - 1];
  }

  /// 활성 요일들의 문자열 표현
  String get activeDaysString {
    if (activeDays.isEmpty) return '없음';
    if (activeDays.length == 7) return '매일';

    final sortedDays = activeDays.toList()..sort();
    return sortedDays.map((day) => getWeekdayName(day, short: true)).join(', ');
  }

  /// 기본 설정들
  static const WorkoutReminderSettings defaultWeekdays =
      WorkoutReminderSettings(
        activeDays: {1, 2, 3, 4, 5}, // 월-금
      );

  static const WorkoutReminderSettings defaultMWF = WorkoutReminderSettings(
    activeDays: {1, 3, 5}, // 월, 수, 금
  );

  static const WorkoutReminderSettings defaultTTS = WorkoutReminderSettings(
    activeDays: {2, 4, 6}, // 화, 목, 토
  );

  WorkoutReminderSettings copyWith({
    bool? isEnabled,
    TimeOfDay? time,
    Set<int>? activeDays,
    bool? requiresRestDay,
  }) {
    return WorkoutReminderSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      time: time ?? this.time,
      activeDays: activeDays ?? this.activeDays,
      requiresRestDay: requiresRestDay ?? this.requiresRestDay,
    );
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'hour': time.hour,
      'minute': time.minute,
      'activeDays': activeDays.toList(),
      'requiresRestDay': requiresRestDay,
    };
  }

  /// JSON 역직렬화
  factory WorkoutReminderSettings.fromJson(Map<String, dynamic> json) {
    return WorkoutReminderSettings(
      isEnabled: json['isEnabled'] ?? true,
      time: TimeOfDay(hour: json['hour'] ?? 18, minute: json['minute'] ?? 0),
      activeDays: Set<int>.from(json['activeDays'] ?? [1, 2, 3, 4, 5]),
      requiresRestDay: json['requiresRestDay'] ?? true,
    );
  }
}
