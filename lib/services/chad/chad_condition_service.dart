import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n/app_localizations.dart';

/// Chad 컨디션 상태 열거형
enum ChadCondition {
  veryTired(0, '😴'),
  good(1, '😊'),
  strong(2, '💪'),
  sweaty(3, '😅'),
  onFire(4, '🥵');

  const ChadCondition(this.score, this.emoji);

  final int score;
  final String emoji;

  /// 로컬라이즈된 이름 가져오기
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case ChadCondition.veryTired:
        return l10n.conditionVeryTired;
      case ChadCondition.good:
        return l10n.conditionGood;
      case ChadCondition.strong:
        return l10n.conditionStrong;
      case ChadCondition.sweaty:
        return l10n.conditionSweaty;
      case ChadCondition.onFire:
        return l10n.conditionOnFire;
    }
  }
}

/// Chad 컨디션 관리 서비스
class ChadConditionService extends ChangeNotifier {
  ChadCondition? _currentCondition;
  DateTime? _lastConditionCheck;
  Map<String, dynamic> _personalizedData = {};

  ChadCondition? get currentCondition => _currentCondition;
  DateTime? get lastConditionCheck => _lastConditionCheck;
  Map<String, dynamic> get personalizedData => _personalizedData;

  /// 오늘 컨디션을 체크했는지 확인
  bool get hasCheckedToday {
    if (_lastConditionCheck == null) return false;
    final now = DateTime.now();
    final lastCheck = _lastConditionCheck!;
    return now.year == lastCheck.year &&
        now.month == lastCheck.month &&
        now.day == lastCheck.day;
  }

  /// 서비스 초기화
  Future<void> initialize() async {
    await _loadPersonalizedData();
    await _loadLastCondition();
  }

  /// 개인화 데이터 로드 (온보딩에서 수집한 데이터)
  Future<void> _loadPersonalizedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _personalizedData = {
        'fitness_goal': prefs.getString('fitness_goal'),
        'fitness_level': prefs.getString('fitness_level'),
        'current_weight': prefs.getDouble('current_weight'),
        'target_weight': prefs.getDouble('target_weight'),
        'workout_times': prefs.getStringList('workout_times'),
        'likes_competition': prefs.getBool('likes_competition'),
      };

      debugPrint('Chad 개인화 데이터 로드 완료: $_personalizedData');
    } catch (e) {
      debugPrint('Chad 개인화 데이터 로드 실패: $e');
    }
  }

  /// 마지막 컨디션 상태 로드
  Future<void> _loadLastCondition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conditionScore = prefs.getInt('last_chad_condition');
      final lastCheckTimestamp = prefs.getInt('last_condition_check');

      if (conditionScore != null) {
        _currentCondition = ChadCondition.values.firstWhere(
          (condition) => condition.score == conditionScore,
          orElse: () => ChadCondition.good,
        );
      }

      if (lastCheckTimestamp != null) {
        _lastConditionCheck =
            DateTime.fromMillisecondsSinceEpoch(lastCheckTimestamp);
      }
    } catch (e) {
      debugPrint('Chad 컨디션 로드 실패: $e');
    }
  }

  /// 컨디션 업데이트
  Future<void> updateCondition(ChadCondition condition) async {
    _currentCondition = condition;
    _lastConditionCheck = DateTime.now();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_chad_condition', condition.score);
      await prefs.setInt(
          'last_condition_check', _lastConditionCheck!.millisecondsSinceEpoch);

      debugPrint('Chad 컨디션 업데이트: ${condition.name} (score: ${condition.score})');
      notifyListeners();
    } catch (e) {
      debugPrint('Chad 컨디션 저장 실패: $e');
    }
  }

  /// Chad의 개인화된 컨디션 체크 메시지
  String getChadConditionMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final goal = _personalizedData['fitness_goal'] as String?;

    String baseMessage = '${l10n.chadGreeting}\n';

    if (!hasCheckedToday) {
      baseMessage += '${l10n.howIsYourConditionToday}\n';

      // 목표별 개인화 메시지
      switch (goal) {
        case 'weightLoss':
          baseMessage += l10n.chadWillMatchWorkoutIntensityForWeightLoss;
          break;
        case 'muscleGain':
          baseMessage += l10n.chadWillCreatePerfectRoutineForMuscleGain;
          break;
        case 'endurance':
          baseMessage += l10n.chadWillMakeCustomPlanForEndurance;
          break;
        default:
          baseMessage += l10n.chadWillRecommendWorkoutForYou;
      }
    } else {
      baseMessage += _getConditionBasedMessage(context);
    }

    return baseMessage;
  }

  /// 현재 컨디션에 따른 Chad 메시지
  String _getConditionBasedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_currentCondition == null) return l10n.pleaseCheckYourCondition;

    final goal = _personalizedData['fitness_goal'] as String?;

    switch (_currentCondition!) {
      case ChadCondition.veryTired:
        return l10n.needRestChadRecommendsStretching;

      case ChadCondition.good:
        switch (goal) {
          case 'weightLoss':
            return l10n.goodConditionLetsBurnCalories;
          case 'muscleGain':
            return l10n.perfectConditionLetsBuildMuscle;
          default:
            return l10n.goodConditionLetsWorkout;
        }

      case ChadCondition.strong:
        return l10n.lookingVeryStrongChadPreparedStrongerWorkout;

      case ChadCondition.sweaty:
        return l10n.alreadySweatyChadWillShortWarmup;

      case ChadCondition.onFire:
        return l10n.totallyOnFireChadBeastMode;
    }
  }

  /// Chad 이미지 경로 (컨디션에 따라)
  String getChadImageForCondition() {
    if (_currentCondition == null) return 'assets/images/chad/basic/basicChad.png';

    switch (_currentCondition!) {
      case ChadCondition.veryTired:
        return 'assets/images/chad/basic/basicChad.png';
      case ChadCondition.good:
        return 'assets/images/chad/basic/basicChad.png';
      case ChadCondition.strong:
        return 'assets/images/chad/basic/basicChad.png';
      case ChadCondition.sweaty:
        return 'assets/images/chad/basic/basicChad.png';
      case ChadCondition.onFire:
        return 'assets/images/chad/basic/basicChad.png';
    }
  }

  /// 컨디션에 따른 오늘의 운동 추천
  String getTodayWorkoutRecommendation(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_currentCondition == null) return l10n.pleaseCheckConditionFirst;

    final level = _personalizedData['fitness_level'] as String?;

    switch (_currentCondition!) {
      case ChadCondition.veryTired:
        return l10n.chadActiveRecovery;

      case ChadCondition.good:
        switch (level) {
          case 'beginner':
            return l10n.chadBasicRoutine;
          case 'intermediate':
            return l10n.chadIntermediateRoutine;
          default:
            return l10n.chadAdvancedRoutine;
        }

      case ChadCondition.strong:
        return l10n.chadPowerRoutine;

      case ChadCondition.sweaty:
        return l10n.chadQuickStart;

      case ChadCondition.onFire:
        return l10n.chadBeastMode;
    }
  }

  /// 컨디션 기록 초기화 (테스트/디버그용)
  Future<void> resetCondition() async {
    _currentCondition = null;
    _lastConditionCheck = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_chad_condition');
      await prefs.remove('last_condition_check');
      notifyListeners();
    } catch (e) {
      debugPrint('Chad 컨디션 초기화 실패: $e');
    }
  }
}
