/// 사용자 목표 설정 모델
class UserGoals {
  final int weeklyGoal;
  final int monthlyGoal;
  final int streakTarget;

  const UserGoals({
    required this.weeklyGoal,
    required this.monthlyGoal,
    required this.streakTarget,
  });

  /// 기본 목표값
  static const UserGoals defaultGoals = UserGoals(
    weeklyGoal: 5,
    monthlyGoal: 20,
    streakTarget: 7,
  );

  /// JSON 변환
  Map<String, dynamic> toJson() => {
        'weeklyGoal': weeklyGoal,
        'monthlyGoal': monthlyGoal,
        'streakTarget': streakTarget,
      };

  /// JSON에서 생성
  factory UserGoals.fromJson(Map<String, dynamic> json) => UserGoals(
        weeklyGoal: json['weeklyGoal'] as int? ?? defaultGoals.weeklyGoal,
        monthlyGoal: json['monthlyGoal'] as int? ?? defaultGoals.monthlyGoal,
        streakTarget: json['streakTarget'] as int? ?? defaultGoals.streakTarget,
      );

  /// 복사 생성자
  UserGoals copyWith({
    int? weeklyGoal,
    int? monthlyGoal,
    int? streakTarget,
  }) =>
      UserGoals(
        weeklyGoal: weeklyGoal ?? this.weeklyGoal,
        monthlyGoal: monthlyGoal ?? this.monthlyGoal,
        streakTarget: streakTarget ?? this.streakTarget,
      );

  /// 목표 유효성 검증
  bool get isValid =>
      weeklyGoal > 0 &&
      weeklyGoal <= 7 &&
      monthlyGoal > 0 &&
      monthlyGoal <= 31 &&
      streakTarget > 0 &&
      streakTarget <= 365;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGoals &&
          runtimeType == other.runtimeType &&
          weeklyGoal == other.weeklyGoal &&
          monthlyGoal == other.monthlyGoal &&
          streakTarget == other.streakTarget;

  @override
  int get hashCode =>
      weeklyGoal.hashCode ^ monthlyGoal.hashCode ^ streakTarget.hashCode;

  @override
  String toString() =>
      'UserGoals(weekly: $weeklyGoal, monthly: $monthlyGoal, streak: $streakTarget)';
}
