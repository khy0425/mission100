/// RPE (Rate of Perceived Exertion) 데이터 모델
class RPEData {
  final int value; // 1-10 스케일
  final String description;
  final String emoji;
  final DateTime timestamp;
  final String? notes;

  const RPEData({
    required this.value,
    required this.description,
    required this.emoji,
    required this.timestamp,
    this.notes,
  });

  factory RPEData.fromJson(Map<String, dynamic> json) {
    return RPEData(
      value: json['value'] as int,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'description': description,
      'emoji': emoji,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RPEData &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          timestamp == other.timestamp;

  @override
  int get hashCode => value.hashCode ^ timestamp.hashCode;
}

/// RPE 옵션 (UI용)
class RPEOption {
  final int value;
  final String emoji;
  final String label;
  final String description;

  const RPEOption({
    required this.value,
    required this.emoji,
    required this.label,
    required this.description,
  });

  static const List<RPEOption> standardOptions = [
    RPEOption(
      value: 2,
      emoji: '😴',
      label: '너무 쉬움',
      description: '전혀 힘들지 않았어요',
    ),
    RPEOption(
      value: 4,
      emoji: '😊',
      label: '쉬움',
      description: '가볍게 할 수 있었어요',
    ),
    RPEOption(
      value: 6,
      emoji: '💪',
      label: '적당함',
      description: '딱 좋은 강도였어요',
    ),
    RPEOption(
      value: 8,
      emoji: '😅',
      label: '힘듦',
      description: '꽤 힘들었어요',
    ),
    RPEOption(
      value: 10,
      emoji: '🥵',
      label: '매우 힘듦',
      description: '한계까지 도전했어요',
    ),
  ];
}

/// 운동 조정 데이터
class WorkoutAdjustment {
  final double repsMultiplier; // 반복횟수 배수 (0.8 = 20% 감소)
  final double restMultiplier; // 휴식시간 배수 (1.2 = 20% 증가)
  final String reasoning; // 조정 이유
  final DateTime appliedAt;

  const WorkoutAdjustment({
    required this.repsMultiplier,
    required this.restMultiplier,
    required this.reasoning,
    required this.appliedAt,
  });

  factory WorkoutAdjustment.fromJson(Map<String, dynamic> json) {
    return WorkoutAdjustment(
      repsMultiplier: json['repsMultiplier'] as double,
      restMultiplier: json['restMultiplier'] as double,
      reasoning: json['reasoning'] as String,
      appliedAt: DateTime.parse(json['appliedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'repsMultiplier': repsMultiplier,
      'restMultiplier': restMultiplier,
      'reasoning': reasoning,
      'appliedAt': appliedAt.toIso8601String(),
    };
  }

  // 팩토리 생성자들
  factory WorkoutAdjustment.decrease({
    double intensity = 0.9,
    String? reason,
  }) =>
      WorkoutAdjustment(
        repsMultiplier: intensity,
        restMultiplier: 1.2,
        reasoning: reason ?? '강도가 높아 운동량을 조정했습니다',
        appliedAt: DateTime.now(),
      );

  factory WorkoutAdjustment.increase({
    double intensity = 1.1,
    String? reason,
  }) =>
      WorkoutAdjustment(
        repsMultiplier: intensity,
        restMultiplier: 0.9,
        reasoning: reason ?? '더 도전적인 목표로 조정했습니다',
        appliedAt: DateTime.now(),
      );

  factory WorkoutAdjustment.maintain({String? reason}) => WorkoutAdjustment(
        repsMultiplier: 1.0,
        restMultiplier: 1.0,
        reasoning: reason ?? '현재 강도를 유지합니다',
        appliedAt: DateTime.now(),
      );

  bool get isDecrease => repsMultiplier < 1.0;
  bool get isIncrease => repsMultiplier > 1.0;
  bool get isMaintain => repsMultiplier == 1.0;
}

/// 회복 상태 데이터
class RecoveryStatus {
  final int score; // 0-100 점수
  final RecoveryLevel level;
  final String recommendation;
  final bool shouldReduceIntensity;
  final int suggestedRestDays;
  final DateTime assessedAt;

  const RecoveryStatus({
    required this.score,
    required this.level,
    required this.recommendation,
    required this.shouldReduceIntensity,
    required this.suggestedRestDays,
    required this.assessedAt,
  });

  factory RecoveryStatus.fromJson(Map<String, dynamic> json) {
    return RecoveryStatus(
      score: json['score'] as int,
      level: RecoveryLevel.values.firstWhere(
        (e) => e.toString() == json['level'] as String,
        orElse: () => RecoveryLevel.good,
      ),
      recommendation: json['recommendation'] as String,
      shouldReduceIntensity: json['shouldReduceIntensity'] as bool,
      suggestedRestDays: json['suggestedRestDays'] as int,
      assessedAt: DateTime.parse(json['assessedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'level': level.toString(),
      'recommendation': recommendation,
      'shouldReduceIntensity': shouldReduceIntensity,
      'suggestedRestDays': suggestedRestDays,
      'assessedAt': assessedAt.toIso8601String(),
    };
  }
}

/// 회복 레벨 열거형
enum RecoveryLevel {
  excellent,
  good,
  fair,
  poor;

  String get emoji {
    switch (this) {
      case RecoveryLevel.excellent:
        return '🚀';
      case RecoveryLevel.good:
        return '⚡';
      case RecoveryLevel.fair:
        return '😐';
      case RecoveryLevel.poor:
        return '😴';
    }
  }

  String get label {
    switch (this) {
      case RecoveryLevel.excellent:
        return '최고';
      case RecoveryLevel.good:
        return '좋음';
      case RecoveryLevel.fair:
        return '보통';
      case RecoveryLevel.poor:
        return '휴식필요';
    }
  }

  static RecoveryLevel fromScore(int score) {
    if (score >= 80) return RecoveryLevel.excellent;
    if (score >= 60) return RecoveryLevel.good;
    if (score >= 40) return RecoveryLevel.fair;
    return RecoveryLevel.poor;
  }
}