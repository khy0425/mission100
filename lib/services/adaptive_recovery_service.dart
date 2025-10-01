import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rpe_data.dart';
import '../models/user_profile.dart';

/// 적응형 회복 관리 서비스
class AdaptiveRecoveryService extends ChangeNotifier {
  static const String _recoveryModeKey = 'recovery_mode';
  static const String _workoutFrequencyKey = 'workout_frequency_mode';

  RecoveryMode _recoveryMode = RecoveryMode.balanced;
  WorkoutFrequencyMode _frequencyMode = WorkoutFrequencyMode.habitBuilding;

  RecoveryMode get recoveryMode => _recoveryMode;
  WorkoutFrequencyMode get frequencyMode => _frequencyMode;

  /// 회복 모드 설정
  Future<void> setRecoveryMode(RecoveryMode mode) async {
    _recoveryMode = mode;
    await _savePreferences();
    notifyListeners();
  }

  /// 운동 빈도 모드 설정
  Future<void> setFrequencyMode(WorkoutFrequencyMode mode) async {
    _frequencyMode = mode;
    await _savePreferences();
    notifyListeners();
  }

  /// 고급 회복 상태 계산
  RecoveryStatus calculateAdvancedRecovery({
    required List<RPEData> recentRPE,
    required UserProfile profile,
    int? userReportedEnergy, // 1-10 사용자 직접 입력
    int? sleepQuality, // 1-10 수면 품질
    double? hrvScore, // HRV 점수 (향후 확장용)
  }) {
    int baseScore = 70;

    // 1. RPE 기반 분석 (50% 가중치)
    final rpeScore = _calculateRPEScore(recentRPE);
    baseScore = (baseScore * 0.5 + rpeScore * 0.5).round();

    // 2. 사용자 주관적 컨디션 (30% 가중치)
    if (userReportedEnergy != null) {
      final energyScore = (userReportedEnergy * 10).clamp(0, 100);
      baseScore = (baseScore * 0.7 + energyScore * 0.3).round();
    }

    // 3. 수면 품질 (20% 가중치)
    if (sleepQuality != null) {
      final sleepScore = (sleepQuality * 10).clamp(0, 100);
      baseScore = (baseScore * 0.8 + sleepScore * 0.2).round();
    }

    // 4. HRV 점수 (Premium 기능, 향후 확장)
    if (hrvScore != null) {
      baseScore = (baseScore * 0.7 + hrvScore * 0.3).round();
    }

    // 5. 개인 목표별 조정
    baseScore = _adjustForGoal(baseScore, profile.fitnessGoal);

    final finalScore = baseScore.clamp(0, 100);
    final level = RecoveryLevel.fromScore(finalScore);

    return RecoveryStatus(
      score: finalScore,
      level: level,
      recommendation: _generateAdvancedRecommendation(finalScore, profile),
      shouldReduceIntensity: _shouldReduceIntensity(finalScore, profile),
      suggestedRestDays: _calculateRestDays(finalScore, recentRPE),
      assessedAt: DateTime.now(),
    );
  }

  /// RPE 기반 점수 계산
  int _calculateRPEScore(List<RPEData> recentRPE) {
    if (recentRPE.isEmpty) return 70;

    int score = 70;

    // 평균 RPE 분석
    final avgRPE = recentRPE.map((r) => r.value).reduce((a, b) => a + b) /
        recentRPE.length;
    if (avgRPE > 8) score -= 20;
    if (avgRPE > 7) score -= 10;
    if (avgRPE < 5) score += 10;

    // RPE 트렌드 분석 (상승 추세 = 피로 누적)
    if (recentRPE.length >= 3) {
      final trend = _calculateRPETrend(recentRPE);
      if (trend > 0.5) score -= 15; // 강한 상승 추세
      if (trend < -0.5) score += 10; // 하락 추세 (회복 중)
    }

    // 고강도 운동 빈도
    final highIntensityCount = recentRPE.where((r) => r.value >= 8).length;
    final totalDays = recentRPE.length;
    if (totalDays > 0 && highIntensityCount / totalDays > 0.6) {
      score -= 15; // 60% 이상이 고강도
    }

    // 연속 운동일 수
    final consecutiveDays = _calculateConsecutiveDays(recentRPE);
    if (consecutiveDays > 3) score -= 10;

    return score.clamp(0, 100);
  }

  /// RPE 트렌드 계산 (선형 회귀 기울기)
  double _calculateRPETrend(List<RPEData> rpeData) {
    if (rpeData.length < 2) return 0.0;

    final n = rpeData.length;
    final x = List.generate(n, (i) => i.toDouble());
    final y = rpeData.map((r) => r.value.toDouble()).toList();

    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => x[i] * y[i]).reduce((a, b) => a + b);
    final sumX2 = x.map((xi) => xi * xi).reduce((a, b) => a + b);

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    return slope;
  }

  /// 연속 운동일 수 계산
  int _calculateConsecutiveDays(List<RPEData> rpeData) {
    if (rpeData.isEmpty) return 0;

    int consecutive = 1;
    for (int i = rpeData.length - 2; i >= 0; i--) {
      final dayDiff =
          rpeData[i + 1].timestamp.difference(rpeData[i].timestamp).inDays;
      if (dayDiff <= 1) {
        consecutive++;
      } else {
        break;
      }
    }
    return consecutive;
  }

  /// 목표별 점수 조정
  int _adjustForGoal(int baseScore, FitnessGoal? goal) {
    if (goal == null) return baseScore;

    switch (goal) {
      case FitnessGoal.weightLoss:
        // 체중감량은 높은 빈도 선호 → 회복 기준 관대
        return (baseScore + 5).clamp(0, 100);
      case FitnessGoal.muscleGain:
        // 근육증가는 충분한 회복 필요 → 회복 기준 엄격
        return (baseScore - 5).clamp(0, 100);
      case FitnessGoal.endurance:
        // 체력향상은 점진적 부하 증가
        return baseScore;
      case FitnessGoal.general:
        // 전반적 건강은 균형 중시
        return baseScore;
    }
  }

  /// 고급 추천 메시지 생성
  String _generateAdvancedRecommendation(int score, UserProfile profile) {
    final goal = profile.fitnessGoal;

    if (score >= 80) {
      switch (goal) {
        case FitnessGoal.weightLoss:
          return '🔥 최고 컨디션! 오늘은 고강도 칼로리 버닝이 가능해요!';
        case FitnessGoal.muscleGain:
          return '💪 완벽한 회복상태! 근육 성장을 위한 강화 훈련을 시작하세요!';
        case FitnessGoal.endurance:
          return '⚡ 컨디션 최고! 지구력 향상을 위한 도전적 운동이 좋겠어요!';
        default:
          return '🌟 컨디션이 최고예요! 오늘도 열심히 운동해보세요!';
      }
    } else if (score >= 60) {
      return '👍 좋은 컨디션이에요! 계획된 운동을 진행하시면 됩니다.';
    } else if (score >= 40) {
      return '😐 보통 컨디션이에요. 운동 강도를 조금 낮춰주세요.';
    } else {
      return '😴 휴식이 필요해 보여요. 오늘은 가벼운 스트레칭을 권합니다.';
    }
  }

  /// 강도 감소 필요 여부
  bool _shouldReduceIntensity(int score, UserProfile profile) {
    final threshold = _recoveryMode.intensityThreshold;
    return score < threshold;
  }

  /// 휴식일 수 계산
  int _calculateRestDays(int score, List<RPEData> recentRPE) {
    if (score >= 70) return 0;
    if (score >= 50) return 1;

    // 연속 고강도가 많으면 더 많은 휴식
    final consecutiveHighIntensity =
        recentRPE.takeWhile((r) => r.value >= 8).length;

    return min(3, 1 + (consecutiveHighIntensity ~/ 2));
  }

  /// 액티브 리커버리 계획 생성
  ActiveRecoveryPlan generateActiveRecoveryPlan(
    RecoveryStatus status,
    UserProfile profile,
  ) {
    final exercises = <RecoveryExercise>[];

    if (status.score >= 70) {
      // 좋은 컨디션 → 가벼운 활동
      switch (profile.fitnessGoal) {
        case FitnessGoal.weightLoss:
          exercises.addAll([
            RecoveryExercise.lightBurpee(reps: 10),
            RecoveryExercise.stretching(duration: const Duration(minutes: 5)),
          ]);
          break;
        case FitnessGoal.muscleGain:
          exercises.addAll([
            RecoveryExercise.mobilityWork(
                duration: const Duration(minutes: 10)),
            RecoveryExercise.lightPushup(reps: 5),
          ]);
          break;
        default:
          exercises.add(
              RecoveryExercise.walking(duration: const Duration(minutes: 15)));
      }
    } else if (status.score >= 40) {
      // 보통 컨디션 → 스트레칭 중심
      exercises.addAll([
        RecoveryExercise.deepBreathing(duration: const Duration(minutes: 3)),
        RecoveryExercise.stretching(duration: const Duration(minutes: 8)),
      ]);
    } else {
      // 낮은 컨디션 → 완전 휴식 + 마음챙김
      exercises.add(
        RecoveryExercise.meditation(duration: const Duration(minutes: 5)),
      );
    }

    return ActiveRecoveryPlan(
      exercises: exercises,
      estimatedDuration: exercises.fold(
        Duration.zero,
        (sum, exercise) => sum + exercise.duration,
      ),
      motivationalMessage: _generateRecoveryMotivation(status, profile),
    );
  }

  /// 회복 운동 동기부여 메시지
  String _generateRecoveryMotivation(
      RecoveryStatus status, UserProfile profile) {
    if (status.score >= 70) {
      return '💫 오늘의 액티브 리커버리로 내일을 위한 에너지를 충전하세요!';
    } else if (status.score >= 40) {
      return '🧘‍♂️ 몸과 마음을 이완시키는 시간이에요. 이것도 성장의 일부입니다!';
    } else {
      return '😌 충분한 휴식은 더 강해지기 위한 필수 과정이에요. 내일의 성과를 위해 오늘은 쉬어가요!';
    }
  }

  /// 기본 추천 빈도 가져오기
  int getRecommendedFrequency(FitnessGoal goal, FitnessLevel level) {
    switch (_frequencyMode) {
      case WorkoutFrequencyMode.habitBuilding:
        return 3; // 습관 형성 최적화
      case WorkoutFrequencyMode.muscleGain:
        return level == FitnessLevel.beginner ? 3 : 4;
      case WorkoutFrequencyMode.weightLoss:
        return level == FitnessLevel.beginner ? 4 : 5;
      case WorkoutFrequencyMode.maintenance:
        return 3;
      case WorkoutFrequencyMode.custom:
        return 3; // 기본값, 사용자가 별도 설정
    }
  }

  /// 설정 저장
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_recoveryModeKey, _recoveryMode.toString());
      await prefs.setString(_workoutFrequencyKey, _frequencyMode.toString());
    } catch (e) {
      debugPrint('회복 설정 저장 오류: $e');
    }
  }

  /// 설정 로드
  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final recoveryModeStr = prefs.getString(_recoveryModeKey);
      if (recoveryModeStr != null) {
        _recoveryMode = RecoveryMode.values.firstWhere(
          (mode) => mode.toString() == recoveryModeStr,
          orElse: () => RecoveryMode.balanced,
        );
      }

      final frequencyModeStr = prefs.getString(_workoutFrequencyKey);
      if (frequencyModeStr != null) {
        _frequencyMode = WorkoutFrequencyMode.values.firstWhere(
          (mode) => mode.toString() == frequencyModeStr,
          orElse: () => WorkoutFrequencyMode.habitBuilding,
        );
      }
    } catch (e) {
      debugPrint('회복 설정 로드 오류: $e');
    }
  }
}

/// 회복 모드 열거형
enum RecoveryMode {
  conservative, // 보수적 (휴식 중시)
  balanced, // 균형적 (기본)
  aggressive, // 적극적 (성과 중시)
}

extension RecoveryModeExtension on RecoveryMode {
  String get displayName {
    switch (this) {
      case RecoveryMode.conservative:
        return '안전 우선';
      case RecoveryMode.balanced:
        return '균형 유지';
      case RecoveryMode.aggressive:
        return '성과 집중';
    }
  }

  String get description {
    switch (this) {
      case RecoveryMode.conservative:
        return '충분한 휴식으로 부상 방지를 최우선으로 합니다';
      case RecoveryMode.balanced:
        return '회복과 성과의 균형을 맞춘 안전한 진행';
      case RecoveryMode.aggressive:
        return '빠른 성과를 위해 적극적인 훈련을 진행';
    }
  }

  int get intensityThreshold {
    switch (this) {
      case RecoveryMode.conservative:
        return 60; // 60점 이하면 강도 감소
      case RecoveryMode.balanced:
        return 50; // 50점 이하면 강도 감소
      case RecoveryMode.aggressive:
        return 40; // 40점 이하에서만 강도 감소
    }
  }
}

/// 운동 빈도 모드 열거형
enum WorkoutFrequencyMode {
  habitBuilding, // 습관 형성
  muscleGain, // 근육 증가
  weightLoss, // 체중 감량
  maintenance, // 현재 상태 유지
  custom, // 사용자 정의
}

extension WorkoutFrequencyModeExtension on WorkoutFrequencyMode {
  String get displayName {
    switch (this) {
      case WorkoutFrequencyMode.habitBuilding:
        return '습관 형성';
      case WorkoutFrequencyMode.muscleGain:
        return '근육 증가';
      case WorkoutFrequencyMode.weightLoss:
        return '체중 감량';
      case WorkoutFrequencyMode.maintenance:
        return '현재 유지';
      case WorkoutFrequencyMode.custom:
        return '직접 설정';
    }
  }

  String get description {
    switch (this) {
      case WorkoutFrequencyMode.habitBuilding:
        return '주 3회로 꾸준한 습관을 만들어가요';
      case WorkoutFrequencyMode.muscleGain:
        return '근육 성장을 위한 최적 빈도로 훈련해요';
      case WorkoutFrequencyMode.weightLoss:
        return '칼로리 소모 극대화를 위한 적극적 운동';
      case WorkoutFrequencyMode.maintenance:
        return '현재 체력을 유지하는 적당한 운동량';
      case WorkoutFrequencyMode.custom:
        return '원하는 대로 운동 스케줄을 설정하세요';
    }
  }

  int get defaultFrequency {
    switch (this) {
      case WorkoutFrequencyMode.habitBuilding:
        return 3;
      case WorkoutFrequencyMode.muscleGain:
        return 4;
      case WorkoutFrequencyMode.weightLoss:
        return 5;
      case WorkoutFrequencyMode.maintenance:
        return 3;
      case WorkoutFrequencyMode.custom:
        return 3; // 기본값
    }
  }
}

/// 액티브 리커버리 운동
class RecoveryExercise {
  final String name;
  final Duration duration;
  final int? reps;
  final String instruction;
  final String emoji;

  const RecoveryExercise({
    required this.name,
    required this.duration,
    this.reps,
    required this.instruction,
    required this.emoji,
  });

  factory RecoveryExercise.lightBurpee({required int reps}) => RecoveryExercise(
        name: '가벼운 버피',
        duration: Duration(seconds: reps * 6), // 6초/개
        reps: reps,
        instruction: '천천히 호흡에 집중하며 가볍게 실시하세요',
        emoji: '🏃‍♂️',
      );

  factory RecoveryExercise.stretching({required Duration duration}) =>
      RecoveryExercise(
        name: '전신 스트레칭',
        duration: duration,
        instruction: '목, 어깨, 허리, 다리를 부드럽게 늘여주세요',
        emoji: '🧘‍♀️',
      );

  factory RecoveryExercise.mobilityWork({required Duration duration}) =>
      RecoveryExercise(
        name: '관절 가동성 운동',
        duration: duration,
        instruction: '어깨, 고관절, 발목의 가동범위를 늘려주세요',
        emoji: '🤸‍♂️',
      );

  factory RecoveryExercise.lightPushup({required int reps}) => RecoveryExercise(
        name: '가벼운 푸시업',
        duration: Duration(seconds: reps * 4),
        reps: reps,
        instruction: '무릎을 바닥에 대고 가볍게 실시하세요',
        emoji: '💪',
      );

  factory RecoveryExercise.walking({required Duration duration}) =>
      RecoveryExercise(
        name: '가벼운 산책',
        duration: duration,
        instruction: '신선한 공기를 마시며 천천히 걸어보세요',
        emoji: '🚶‍♂️',
      );

  factory RecoveryExercise.deepBreathing({required Duration duration}) =>
      RecoveryExercise(
        name: '복식 호흡',
        duration: duration,
        instruction: '4초 들이마시고, 4초 참고, 6초에 걸쳐 내쉬어주세요',
        emoji: '🌬️',
      );

  factory RecoveryExercise.meditation({required Duration duration}) =>
      RecoveryExercise(
        name: '마음챙김 명상',
        duration: duration,
        instruction: '편안한 자세로 앉아 호흡에만 집중해보세요',
        emoji: '🧘‍♂️',
      );
}

/// 액티브 리커버리 계획
class ActiveRecoveryPlan {
  final List<RecoveryExercise> exercises;
  final Duration estimatedDuration;
  final String motivationalMessage;

  const ActiveRecoveryPlan({
    required this.exercises,
    required this.estimatedDuration,
    required this.motivationalMessage,
  });
}
