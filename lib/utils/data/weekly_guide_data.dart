import 'package:flutter/material.dart';
import '../../widgets/onboarding_pages/onboarding_dream_journal_page.dart';
import '../../widgets/onboarding_pages/onboarding_reality_check_page.dart';
import '../../widgets/onboarding_pages/onboarding_mild_technique_page.dart';

/// 주차별 학습 가이드 데이터
class WeeklyGuideData {
  final int week;
  final String titleKo;
  final String titleEn;
  final String goalKo;
  final String goalEn;
  final Widget guideWidget;

  const WeeklyGuideData({
    required this.week,
    required this.titleKo,
    required this.titleEn,
    required this.goalKo,
    required this.goalEn,
    required this.guideWidget,
  });

  /// 주차별 학습 가이드 매핑
  static const List<WeeklyGuideData> weeklyGuides = [
    // Week 1: 꿈일기 마스터
    WeeklyGuideData(
      week: 1,
      titleKo: '꿈일기 작성법',
      titleEn: 'Dream Journal Guide',
      goalKo: '꿈을 상세하게 기록하는 습관 만들기',
      goalEn: 'Build the habit of detailed dream recording',
      guideWidget: OnboardingDreamJournalPage(),
    ),

    // Week 2: 현실 확인 훈련
    WeeklyGuideData(
      week: 2,
      titleKo: '현실 확인 방법',
      titleEn: 'Reality Check Methods',
      goalKo: '하루 10회 이상 현실 확인 습관화',
      goalEn: 'Practice reality checks 10+ times daily',
      guideWidget: OnboardingRealityCheckPage(),
    ),

    // Week 3: MILD 기법 심화
    WeeklyGuideData(
      week: 3,
      titleKo: 'MILD 테크닉',
      titleEn: 'MILD Technique',
      goalKo: 'WBTB + MILD 조합으로 첫 자각몽 성공하기',
      goalEn: 'Achieve first lucid dream with WBTB+MILD',
      guideWidget: OnboardingMILDTechniquePage(),
    ),

    // Week 4: MILD 기법 반복
    WeeklyGuideData(
      week: 4,
      titleKo: 'MILD 테크닉 심화',
      titleEn: 'Advanced MILD Technique',
      goalKo: 'MILD 기법 완전히 체화하기',
      goalEn: 'Master the MILD technique',
      guideWidget: OnboardingMILDTechniquePage(),
    ),

    // Week 5: MILD 테크닉 마스터
    WeeklyGuideData(
      week: 5,
      titleKo: 'MILD 테크닉 마스터',
      titleEn: 'MILD Mastery',
      goalKo: '자각몽 성공률 높이기',
      goalEn: 'Increase lucid dream success rate',
      guideWidget: OnboardingMILDTechniquePage(),
    ),

    // Week 6-8: MILD 지속 연습
    WeeklyGuideData(
      week: 6,
      titleKo: 'MILD 완전 체화',
      titleEn: 'MILD Perfect Mastery',
      goalKo: 'MILD 기법을 자동화하고 성공률 극대화',
      goalEn: 'Automate MILD technique and maximize success rate',
      guideWidget: OnboardingMILDTechniquePage(),
    ),
    WeeklyGuideData(
      week: 7,
      titleKo: 'MILD 고급 응용',
      titleEn: 'Advanced MILD Applications',
      goalKo: 'MILD를 활용한 자각몽 유도 최적화',
      goalEn: 'Optimize lucid dream induction with MILD',
      guideWidget: OnboardingMILDTechniquePage(),
    ),
    WeeklyGuideData(
      week: 8,
      titleKo: 'MILD 심화 훈련',
      titleEn: 'MILD Deep Practice',
      goalKo: 'MILD 기법 완벽 마스터',
      goalEn: 'Perfect MILD technique mastery',
      guideWidget: OnboardingMILDTechniquePage(),
    ),

    // Week 9-11: Reality Check 고급 훈련
    WeeklyGuideData(
      week: 9,
      titleKo: '현실 확인 고급',
      titleEn: 'Advanced Reality Checks',
      goalKo: '현실 확인을 생활 습관으로 자동화',
      goalEn: 'Automate reality checks as daily habit',
      guideWidget: OnboardingRealityCheckPage(),
    ),
    WeeklyGuideData(
      week: 10,
      titleKo: '현실 확인 마스터',
      titleEn: 'Reality Check Mastery',
      goalKo: '무의식적 현실 확인 습관 완성',
      goalEn: 'Complete unconscious reality check habit',
      guideWidget: OnboardingRealityCheckPage(),
    ),
    WeeklyGuideData(
      week: 11,
      titleKo: '현실 확인 완전 체화',
      titleEn: 'Reality Check Perfection',
      goalKo: '현실 확인 자동 반사 신경 개발',
      goalEn: 'Develop automatic reality check reflexes',
      guideWidget: OnboardingRealityCheckPage(),
    ),

    // Week 12-14: 종합 복습 및 완성
    WeeklyGuideData(
      week: 12,
      titleKo: '꿈일기 최적화',
      titleEn: 'Dream Journal Optimization',
      goalKo: '꿈 기억력 극대화 및 패턴 분석',
      goalEn: 'Maximize dream recall and pattern analysis',
      guideWidget: OnboardingDreamJournalPage(),
    ),
    WeeklyGuideData(
      week: 13,
      titleKo: '통합 훈련',
      titleEn: 'Integrated Practice',
      goalKo: '모든 기법을 통합하여 자각몽 성공률 극대화',
      goalEn: 'Integrate all techniques for maximum success',
      guideWidget: OnboardingDreamJournalPage(),
    ),
    WeeklyGuideData(
      week: 14,
      titleKo: '자각몽 마스터 완성',
      titleEn: 'Lucid Dreaming Master',
      goalKo: '자각몽 마스터로서의 여정 완성',
      goalEn: 'Complete journey as lucid dreaming master',
      guideWidget: OnboardingDreamJournalPage(),
    ),
  ];

  /// 특정 주차의 가이드 가져오기
  static WeeklyGuideData? getGuideForWeek(int week) {
    try {
      return weeklyGuides.firstWhere((guide) => guide.week == week);
    } catch (e) {
      // Week 14 이후는 Week 14 가이드 반복
      if (week > 14) {
        return weeklyGuides.last;
      }
      return null;
    }
  }

  /// 사용자가 이미 본 가이드인지 확인
  static bool hasViewedGuide(int week) {
    // SharedPreferences로 관리 (추후 구현)
    return false;
  }

  /// 가이드 열람 기록
  static Future<void> markGuideAsViewed(int week) async {
    // SharedPreferences에 저장 (추후 구현)
  }
}
