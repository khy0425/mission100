import 'package:flutter/material.dart';

/// 운동 패턴 열거형
enum WorkoutPattern {
  cycling, // 순환: 월수금일 → 화목토 → 월수금일
  mwfOnly, // 월수금 고정
  ttsOnly, // 화목토 고정
}

/// 운동 리마인더 설정 모델
class WorkoutReminderSettings {
  final bool isEnabled;
  final TimeOfDay time;
  final Set<int> activeDays; // 1=월요일, 2=화요일, ..., 7=일요일
  final bool requiresRestDay; // 무조건 하루는 쉬도록 강제
  final WorkoutPattern pattern; // 운동 패턴

  const WorkoutReminderSettings({
    this.isEnabled = true,
    this.time = const TimeOfDay(hour: 18, minute: 0),
    this.activeDays = const {1, 3, 5}, // 기본: 월수금
    this.requiresRestDay = true,
    this.pattern = WorkoutPattern.mwfOnly,
  });

  /// 유효한 운동 스케줄인지 체크 (3가지 고정 옵션만 허용)
  bool get hasValidRestDay {
    return _isValidOption();
  }

  /// 3가지 고정 옵션 중 하나인지 확인
  bool _isValidOption() {
    return activeDays == optionMWF.activeDays ||
           activeDays == optionTTS.activeDays ||
           activeDays == optionMWFSTS.activeDays;
  }

  /// 현재 설정의 옵션 이름 반환
  String get optionName {
    switch (pattern) {
      case WorkoutPattern.cycling:
        return '순환 패턴 (월수금일 ↔ 화목토)';
      case WorkoutPattern.mwfOnly:
        return '월수금 고정 (주 3회)';
      case WorkoutPattern.ttsOnly:
        return '화목토 고정 (주 3회)';
    }
  }

  /// 특정 날짜에 알림이 활성화되어 있는지 확인 (패턴 고려)
  bool isActiveOnDate(DateTime date) {
    if (!isEnabled) return false;

    switch (pattern) {
      case WorkoutPattern.cycling:
        // 순환: 홀수 주(1,3,5...)는 월수금일, 짝수 주(2,4,6...)는 화목토
        final weekOfYear = _getWeekOfYear(date);
        final isOddWeek = weekOfYear % 2 == 1;
        if (isOddWeek) {
          return {1, 3, 5, 7}.contains(date.weekday); // 월수금일
        } else {
          return {2, 4, 6}.contains(date.weekday); // 화목토
        }
      case WorkoutPattern.mwfOnly:
        return {1, 3, 5}.contains(date.weekday); // 월수금
      case WorkoutPattern.ttsOnly:
        return {2, 4, 6}.contains(date.weekday); // 화목토
    }
  }

  /// 연도 기준 주차 계산
  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
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
  /// 옵션 1: 순환 패턴 (월수금일 ↔ 화목토)
  static const WorkoutReminderSettings optionCycling = WorkoutReminderSettings(
    activeDays: {1, 3, 5, 7, 2, 4, 6}, // UI 표시용 (실제 로직은 패턴으로)
    pattern: WorkoutPattern.cycling,
  );

  /// 옵션 2: 월수금만 고정 (주 3회)
  static const WorkoutReminderSettings optionMWF = WorkoutReminderSettings(
    activeDays: {1, 3, 5}, // 월, 수, 금
    pattern: WorkoutPattern.mwfOnly,
  );

  /// 옵션 3: 화목토만 고정 (주 3회)
  static const WorkoutReminderSettings optionTTS = WorkoutReminderSettings(
    activeDays: {2, 4, 6}, // 화, 목, 토
    pattern: WorkoutPattern.ttsOnly,
  );

  /// 기존 호환성을 위한 기본값 (이제 사용 안함)
  static const WorkoutReminderSettings defaultWeekdays = optionMWF;
  static const WorkoutReminderSettings defaultMWF = optionMWF;
  static const WorkoutReminderSettings defaultTTS = optionTTS;

  /// 새로운 이름
  static const WorkoutReminderSettings optionMWFSTS = optionCycling;

  WorkoutReminderSettings copyWith({
    bool? isEnabled,
    TimeOfDay? time,
    Set<int>? activeDays,
    bool? requiresRestDay,
    WorkoutPattern? pattern,
  }) {
    return WorkoutReminderSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      time: time ?? this.time,
      activeDays: activeDays ?? this.activeDays,
      requiresRestDay: requiresRestDay ?? this.requiresRestDay,
      pattern: pattern ?? this.pattern,
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
      'pattern': pattern.name,
    };
  }

  /// JSON 역직렬화
  factory WorkoutReminderSettings.fromJson(Map<String, dynamic> json) {
    final patternName = json['pattern'] as String?;
    WorkoutPattern pattern = WorkoutPattern.mwfOnly;

    if (patternName != null) {
      try {
        pattern = WorkoutPattern.values.firstWhere((e) => e.name == patternName);
      } catch (e) {
        pattern = WorkoutPattern.mwfOnly; // 기본값
      }
    }

    return WorkoutReminderSettings(
      isEnabled: (json['isEnabled'] as bool?) ?? true,
      time: TimeOfDay(hour: (json['hour'] as int?) ?? 18, minute: (json['minute'] as int?) ?? 0),
      activeDays: Set<int>.from((json['activeDays'] as List?) ?? [1, 3, 5]),
      requiresRestDay: (json['requiresRestDay'] as bool?) ?? true,
      pattern: pattern,
    );
  }
}
