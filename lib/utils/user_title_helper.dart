import 'package:flutter/widgets.dart';

/// 사용자 호칭 시스템
///
/// 루시드 드리밍 앱에서 사용자를 부르는 호칭
/// Week/레벨에 따라 다른 호칭 사용
class UserTitleHelper {
  /// Week 기반 호칭 반환
  ///
  /// - Week 0-1: 드리머님 / Dreamer
  /// - Week 2-3: 몽탐자님 / Dream Explorer
  /// - Week 4-6: 각성자님 / Awakening One
  /// - Week 7-9: 루시드 워커님 / Lucid Walker
  /// - Week 10+: 드림 마스터님 / Dream Master
  static String getLocalizedTitleForWeek(BuildContext context, int week) {
    // l10n 키가 없으므로 하드코딩 사용
    // ignore: deprecated_member_use_from_same_package
    return getTitleForWeek(week);
  }

  /// XP 기반 호칭 반환
  static String getLocalizedTitleForXP(BuildContext context, int totalXP) {
    // 700 XP = 1 Week
    final week = totalXP ~/ 700;
    return getLocalizedTitleForWeek(context, week);
  }

  /// 기본 호칭
  static String getDefaultTitle(BuildContext context) {
    // ignore: deprecated_member_use_from_same_package
    return defaultTitle;
  }

  /// Week 기반 호칭 반환 (한국어 하드코딩 - 레거시용)
  @Deprecated('Use getLocalizedTitleForWeek instead')
  static String getTitleForWeek(int week) {
    if (week <= 1) {
      return '드리머님';
    } else if (week <= 3) {
      return '몽탐자님';
    } else if (week <= 6) {
      return '각성자님';
    } else if (week <= 9) {
      return '루시드 워커님';
    } else {
      return '드림 마스터님';
    }
  }

  /// XP 기반 호칭 반환 (한국어 하드코딩 - 레거시용)
  @Deprecated('Use getLocalizedTitleForXP instead')
  static String getTitleForXP(int totalXP) {
    // 700 XP = 1 Week
    final week = totalXP ~/ 700;
    return getTitleForWeek(week);
  }

  /// 기본 호칭 (처음 시작하는 사용자용)
  @Deprecated('Use getDefaultTitle instead')
  static String get defaultTitle => '드리머님';

  /// 호칭별 설명
  static String getDescriptionForWeek(int week) {
    if (week <= 1) {
      return '꿈의 세계로 첫 발을 내딛은 당신';
    } else if (week <= 3) {
      return '꿈의 비밀을 탐험하는 여행자';
    } else if (week <= 6) {
      return '꿈 속에서 깨어나기 시작한 자';
    } else if (week <= 9) {
      return '자각몽의 길을 걷는 숙련자';
    } else {
      return '꿈의 세계를 자유롭게 다스리는 마스터';
    }
  }

  /// 영어 호칭 (나중에 다국어 지원용)
  @Deprecated('Use getLocalizedTitleForWeek instead')
  static String getTitleForWeekEn(int week) {
    if (week <= 1) {
      return 'Dreamer';
    } else if (week <= 3) {
      return 'Dream Explorer';
    } else if (week <= 6) {
      return 'Awakening One';
    } else if (week <= 9) {
      return 'Lucid Walker';
    } else {
      return 'Dream Master';
    }
  }
}
