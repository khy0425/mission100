import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import '../../models/chad_evolution.dart';

/// Chad 진화 단계별 이름과 설명을 언어별로 제공하는 헬퍼 클래스
class ChadTranslationHelper {
  /// Chad 이름을 현재 언어로 번역
  static String getChadName(BuildContext context, ChadEvolution chad) {
    final l10n = AppLocalizations.of(context);

    switch (chad.stage) {
      case ChadEvolutionStage.sleepCapChad:
        return l10n.chadSleepyCap;
      case ChadEvolutionStage.basicChad:
        return l10n.chadBasic;
      case ChadEvolutionStage.coffeeChad:
        return l10n.chadCoffee;
      case ChadEvolutionStage.confidentChad:
        return l10n.chadConfident;
      case ChadEvolutionStage.sunglassesChad:
        return l10n.chadSunglasses;
      case ChadEvolutionStage.laserEyesChad:
        return l10n.chadLaserEyes;
      case ChadEvolutionStage.laserEyesHudChad:
        return l10n.chadLaserEyesHud;
      case ChadEvolutionStage.doubleChad:
        return l10n.chadDouble;
      case ChadEvolutionStage.tripleChad:
        return l10n.chadTriple;
      case ChadEvolutionStage.godChad:
        return l10n.chadGod;
    }
  }

  /// Chad 설명을 현재 언어로 번역
  static String getChadDescription(BuildContext context, ChadEvolution chad) {
    final l10n = AppLocalizations.of(context);

    switch (chad.stage) {
      case ChadEvolutionStage.sleepCapChad:
        return l10n.chadSleepyCapDesc;
      case ChadEvolutionStage.basicChad:
        return l10n.chadBasicDesc;
      case ChadEvolutionStage.coffeeChad:
        return l10n.chadCoffeeDesc;
      case ChadEvolutionStage.confidentChad:
        return l10n.chadConfidentDesc;
      case ChadEvolutionStage.sunglassesChad:
        return l10n.chadSunglassesDesc;
      case ChadEvolutionStage.laserEyesChad:
        return l10n.chadLaserEyesDesc;
      case ChadEvolutionStage.laserEyesHudChad:
        return l10n.chadLaserEyesHudDesc;
      case ChadEvolutionStage.doubleChad:
        return l10n.chadDoubleDesc;
      case ChadEvolutionStage.tripleChad:
        return l10n.chadTripleDesc;
      case ChadEvolutionStage.godChad:
        return l10n.chadGodDesc;
    }
  }

  /// 오늘의 미션 텍스트 번역
  static String getTodayMission(BuildContext context) {
    return AppLocalizations.of(context).todayMission;
  }

  /// 오늘의 목표 텍스트 번역
  static String getTodayTarget(BuildContext context) {
    return AppLocalizations.of(context).todayTarget;
  }

  /// 세트 형식 번역
  static String getSetFormat(BuildContext context, int setNumber, int reps) {
    return AppLocalizations.of(context).setFormat(setNumber, reps);
  }

  /// 주차/일차 형식 번역
  static String getWeekDayFormat(BuildContext context, int week, int day) {
    return AppLocalizations.of(context).weekDayFormat(week, day);
  }

  /// 완료된 운동 형식 번역
  static String getCompletedFormat(BuildContext context, int reps, int sets) {
    return AppLocalizations.of(context).completedFormat(reps, sets);
  }

  /// 총 운동 형식 번역
  static String getTotalFormat(BuildContext context, int reps, int sets) {
    return AppLocalizations.of(context).totalFormat(reps, sets);
  }

  /// 오늘 운동 완료 메시지 번역
  static String getTodayWorkoutCompleted(BuildContext context) {
    return AppLocalizations.of(context).todayWorkoutCompleted;
  }

  /// 휴식 방지 메시지 번역
  static String getJustWait(BuildContext context) {
    return AppLocalizations.of(context).justWait;
  }

  /// 완벽한 푸시업 자세 번역
  static String getPerfectPushupForm(BuildContext context) {
    return AppLocalizations.of(context).perfectPushupForm;
  }

  /// 진행률 추적 번역
  static String getProgressTracking(BuildContext context) {
    return AppLocalizations.of(context).progressTracking;
  }
}

/// Locale 확장
extension LocaleExtension on BuildContext {
  Locale get locale => Localizations.localeOf(this);
}
