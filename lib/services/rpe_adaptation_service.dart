import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rpe_data.dart';
import '../models/user_profile.dart';

/// RPE 기반 운동 적응 서비스
class RPEAdaptationService extends ChangeNotifier {
  static const String _rpeHistoryKey = 'rpe_history';
  static const String _adjustmentHistoryKey = 'adjustment_history';

  List<RPEData> _rpeHistory = [];
  List<WorkoutAdjustment> _adjustmentHistory = [];
  bool _isInitialized = false;

  /// RPE 기록 목록
  List<RPEData> get rpeHistory => List.unmodifiable(_rpeHistory);

  /// 운동 조정 기록 목록
  List<WorkoutAdjustment> get adjustmentHistory =>
      List.unmodifiable(_adjustmentHistory);

  /// 최근 RPE 데이터 (7개)
  List<RPEData> get recentRPE => _rpeHistory.length > 7
      ? _rpeHistory.sublist(_rpeHistory.length - 7)
      : _rpeHistory;

  /// 평균 RPE (최근 7일)
  double get averageRPE {
    if (recentRPE.isEmpty) return 5.0;
    return recentRPE.map((r) => r.value).reduce((a, b) => a + b) /
        recentRPE.length;
  }

  /// 서비스 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _loadData();
    _isInitialized = true;
  }

  /// 저장된 데이터 로드
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // RPE 기록 로드
      final rpeJson = prefs.getString(_rpeHistoryKey);
      if (rpeJson != null) {
        final rpeList = jsonDecode(rpeJson) as List;
        _rpeHistory = rpeList
            .map((json) => RPEData.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // 조정 기록 로드
      final adjustmentJson = prefs.getString(_adjustmentHistoryKey);
      if (adjustmentJson != null) {
        final adjustmentList = jsonDecode(adjustmentJson) as List;
        _adjustmentHistory = adjustmentList
            .map((json) =>
                WorkoutAdjustment.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('RPE 데이터 로드 오류: $e');
    }
  }

  /// 데이터 저장
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // RPE 기록 저장 (최근 30개만)
      final recentRPEHistory = _rpeHistory.length > 30
          ? _rpeHistory.sublist(_rpeHistory.length - 30)
          : _rpeHistory;

      await prefs.setString(
        _rpeHistoryKey,
        jsonEncode(recentRPEHistory.map((r) => r.toJson()).toList()),
      );

      // 조정 기록 저장 (최근 20개만)
      final recentAdjustments = _adjustmentHistory.length > 20
          ? _adjustmentHistory.sublist(_adjustmentHistory.length - 20)
          : _adjustmentHistory;

      await prefs.setString(
        _adjustmentHistoryKey,
        jsonEncode(recentAdjustments.map((a) => a.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('RPE 데이터 저장 오류: $e');
    }
  }

  /// RPE 기록 추가
  Future<void> addRPE(RPEData rpe) async {
    await initialize();

    _rpeHistory.add(rpe);
    await _saveData();
    notifyListeners();

    debugPrint('RPE 기록 추가: ${rpe.value} (${rpe.description})');
  }

  /// 목표별 최적 RPE 가져오기
  double getTargetRPE(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return 7.5; // 체중감량: 높은 강도
      case FitnessGoal.muscleGain:
        return 6.5; // 근육증가: 중간 강도
      case FitnessGoal.endurance:
        return 7.0; // 체력향상: 중상 강도
      case FitnessGoal.general:
        return 6.0; // 전반적 건강: 중간 강도
    }
  }

  /// 다음 운동 조정 계산
  WorkoutAdjustment calculateNextAdjustment({
    required double currentRPE,
    required FitnessGoal goal,
    FitnessLevel level = FitnessLevel.intermediate,
  }) {
    final targetRPE = getTargetRPE(goal);
    final rpeDifference = currentRPE - targetRPE;

    // 레벨별 허용 오차 조정
    final tolerance = level == FitnessLevel.beginner ? 2.0 : 1.5;

    WorkoutAdjustment adjustment;

    if (rpeDifference > tolerance) {
      // 너무 힘들었음 → 감소
      final intensityReduction = min(0.15, rpeDifference * 0.05);
      adjustment = WorkoutAdjustment.decrease(
        intensity: 1.0 - intensityReduction,
        reason:
            'RPE ${currentRPE.toInt()}로 목표(${targetRPE.toInt()})보다 높아 강도를 조정했습니다',
      );
    } else if (rpeDifference < -tolerance) {
      // 너무 쉬웠음 → 증가
      final intensityIncrease = min(0.15, rpeDifference.abs() * 0.05);
      adjustment = WorkoutAdjustment.increase(
        intensity: 1.0 + intensityIncrease,
        reason:
            'RPE ${currentRPE.toInt()}로 목표(${targetRPE.toInt()})보다 낮아 강도를 높였습니다',
      );
    } else {
      // 적절한 범위 → 유지
      adjustment = WorkoutAdjustment.maintain(
        reason: 'RPE ${currentRPE.toInt()}로 적절한 강도를 유지합니다',
      );
    }

    _adjustmentHistory.add(adjustment);
    _saveData();
    notifyListeners();

    debugPrint('운동 조정: ${adjustment.reasoning}');
    return adjustment;
  }

  /// 회복 상태 평가
  RecoveryStatus assessRecovery() {
    if (recentRPE.isEmpty) {
      return RecoveryStatus(
        score: 70,
        level: RecoveryLevel.good,
        recommendation: '아직 운동 기록이 부족합니다',
        shouldReduceIntensity: false,
        suggestedRestDays: 0,
        assessedAt: DateTime.now(),
      );
    }

    int recoveryScore = 70; // 기본 점수

    // 1. 운동 빈도 분석 (최근 7일)
    final workoutFrequency = recentRPE.length;
    if (workoutFrequency > 5) recoveryScore -= 15; // 과도한 운동
    if (workoutFrequency < 2) recoveryScore += 10; // 충분한 휴식

    // 2. 평균 RPE 분석
    if (averageRPE > 8) recoveryScore -= 15; // 지속적 고강도
    if (averageRPE < 5) recoveryScore += 5; // 적절한 강도

    // 3. RPE 트렌드 분석 (상승 추세인지)
    if (recentRPE.length >= 3) {
      final lastThree = recentRPE.sublist(recentRPE.length - 3);
      final isIncreasingTrend = lastThree[0].value < lastThree[1].value &&
          lastThree[1].value < lastThree[2].value;
      if (isIncreasingTrend) recoveryScore -= 10; // 피로 누적
    }

    // 4. 최근 고강도 운동 확인
    final highIntensityCount = recentRPE.where((r) => r.value >= 8).length;
    if (highIntensityCount >= 3) recoveryScore -= 10;

    // 점수 범위 제한
    recoveryScore = recoveryScore.clamp(0, 100);

    final level = RecoveryLevel.fromScore(recoveryScore);
    final shouldReduceIntensity = recoveryScore < 50;
    final suggestedRestDays = recoveryScore < 40 ? 1 : 0;

    String recommendation;
    switch (level) {
      case RecoveryLevel.excellent:
        recommendation = '컨디션이 최고예요! 💪 오늘도 열심히 운동해보세요!';
        break;
      case RecoveryLevel.good:
        recommendation = '좋은 컨디션이에요! ⚡ 계획대로 운동하시면 됩니다.';
        break;
      case RecoveryLevel.fair:
        recommendation = '적당한 컨디션이에요. 😐 오버트레이닝에 주의하세요.';
        break;
      case RecoveryLevel.poor:
        recommendation = '휴식이 필요해 보여요. 😴 오늘은 가벼운 스트레칭을 권합니다.';
        break;
    }

    return RecoveryStatus(
      score: recoveryScore,
      level: level,
      recommendation: recommendation,
      shouldReduceIntensity: shouldReduceIntensity,
      suggestedRestDays: suggestedRestDays,
      assessedAt: DateTime.now(),
    );
  }

  /// RPE 기반 동기부여 메시지 생성
  String generateMotivationalMessage(
    RPEData rpe,
    RecoveryStatus recovery,
    FitnessGoal goal,
  ) {
    // 목표별 + RPE별 맞춤 메시지
    if (goal == FitnessGoal.weightLoss && rpe.value >= 7) {
      return '🔥 고강도 칼로리 버닝! 지방이 녹고 있어요!';
    }

    if (goal == FitnessGoal.muscleGain && recovery.score > 80) {
      return '💪 완벽한 회복상태! 근육 성장의 골든타임이에요!';
    }

    if (goal == FitnessGoal.endurance && rpe.value >= 6 && rpe.value <= 7) {
      return '⚡ 완벽한 지구력 훈련 강도예요! 심폐지구력이 늘고 있어요!';
    }

    if (rpe.value <= 4) {
      return '😊 오늘은 가볍게! 컨디션 조절도 실력입니다!';
    }

    if (rpe.value >= 9) {
      return '🏆 한계에 도전하는 당신, 정말 대단해요!';
    }

    return '💫 꾸준함이 최고의 전략입니다! 계속 화이팅!';
  }

  /// 초기화 여부 확인
  bool get isInitialized => _isInitialized;

  /// 통계 데이터 가져오기 (투자자 데모용)
  Map<String, dynamic> getStatistics() {
    return {
      'totalSessions': _rpeHistory.length,
      'averageRPE': averageRPE.toStringAsFixed(1),
      'adjustmentCount': _adjustmentHistory.length,
      'recoveryScore': assessRecovery().score,
      'lastWeekRPE': recentRPE.map((r) => r.value).toList(),
    };
  }
}
