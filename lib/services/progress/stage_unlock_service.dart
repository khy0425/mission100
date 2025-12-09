/// 6-Stage 레벨 시스템 및 기능 해금 서비스
///
/// Stage 1-2: 무료 (기본 기능 + AI 1-2토큰/일)
/// Stage 3-6: 프리미엄 (확장 기능 + AI 5-20토큰/일)
library;

import 'package:flutter/foundation.dart';

/// 스테이지 정보
class StageInfo {
  final int stage;
  final String name;
  final String nameKo;
  final String emoji;
  final int minXP;
  final int maxXP;
  final int dailyTokens;
  final bool requiresPremium;
  final List<UnlockableFeature> unlockedFeatures;

  const StageInfo({
    required this.stage,
    required this.name,
    required this.nameKo,
    required this.emoji,
    required this.minXP,
    required this.maxXP,
    required this.dailyTokens,
    required this.requiresPremium,
    required this.unlockedFeatures,
  });

  /// 해당 스테이지까지의 총 일수
  int get daysToReach => minXP ~/ 100;

  /// 해당 스테이지에서 다음 스테이지까지 필요한 일수
  int get daysInStage => (maxXP - minXP + 1) ~/ 100;
}

/// 해금 가능한 기능 enum
enum UnlockableFeature {
  // Stage 1 기능
  basicChecklist,
  basicGuide,
  progressDashboard,
  characterDisplay,

  // Stage 2 기능
  aiCoachingBasic,
  dailyNotification,
  weeklySummaryBasic,

  // Stage 3 기능 (프리미엄)
  aiCoachingExpanded,
  detailedStats,
  weeklyReportDetailed,
  streakBonus,

  // Stage 4 기능
  advancedChecklist,
  customNotification,
  achievementSystem,

  // Stage 5 기능
  advancedProgram,
  trendAnalysis,
  monthlyReport,

  // Stage 6 기능
  masterBadge,
  programCustomization,
  dataExport,
  fullAccess,
}

/// 스테이지 해금 서비스
class StageUnlockService {
  StageUnlockService._();

  /// 6개 스테이지 정의
  static const List<StageInfo> stages = [
    StageInfo(
      stage: 1,
      name: 'Sprout',
      nameKo: '새싹',
      emoji: '🌱',
      minXP: 0,
      maxXP: 1399,
      dailyTokens: 1,
      requiresPremium: false,
      unlockedFeatures: [
        UnlockableFeature.basicChecklist,
        UnlockableFeature.basicGuide,
        UnlockableFeature.progressDashboard,
        UnlockableFeature.characterDisplay,
      ],
    ),
    StageInfo(
      stage: 2,
      name: 'Growing',
      nameKo: '성장',
      emoji: '🌿',
      minXP: 1400,
      maxXP: 2799,
      dailyTokens: 2,
      requiresPremium: false,
      unlockedFeatures: [
        UnlockableFeature.aiCoachingBasic,
        UnlockableFeature.dailyNotification,
        UnlockableFeature.weeklySummaryBasic,
      ],
    ),
    StageInfo(
      stage: 3,
      name: 'Developing',
      nameKo: '발전',
      emoji: '🌳',
      minXP: 2800,
      maxXP: 4199,
      dailyTokens: 5,
      requiresPremium: true,
      unlockedFeatures: [
        UnlockableFeature.aiCoachingExpanded,
        UnlockableFeature.detailedStats,
        UnlockableFeature.weeklyReportDetailed,
        UnlockableFeature.streakBonus,
      ],
    ),
    StageInfo(
      stage: 4,
      name: 'Skilled',
      nameKo: '숙련',
      emoji: '🌲',
      minXP: 4200,
      maxXP: 5599,
      dailyTokens: 10,
      requiresPremium: true,
      unlockedFeatures: [
        UnlockableFeature.advancedChecklist,
        UnlockableFeature.customNotification,
        UnlockableFeature.achievementSystem,
      ],
    ),
    StageInfo(
      stage: 5,
      name: 'Expert',
      nameKo: '전문가',
      emoji: '🏔️',
      minXP: 5600,
      maxXP: 6999,
      dailyTokens: 15,
      requiresPremium: true,
      unlockedFeatures: [
        UnlockableFeature.advancedProgram,
        UnlockableFeature.trendAnalysis,
        UnlockableFeature.monthlyReport,
      ],
    ),
    StageInfo(
      stage: 6,
      name: 'Master',
      nameKo: '마스터',
      emoji: '👑',
      minXP: 7000,
      maxXP: 99999, // 무제한
      dailyTokens: 20,
      requiresPremium: true,
      unlockedFeatures: [
        UnlockableFeature.masterBadge,
        UnlockableFeature.programCustomization,
        UnlockableFeature.dataExport,
        UnlockableFeature.fullAccess,
      ],
    ),
  ];

  /// XP로 스테이지 계산
  static int getStageFromXP(int totalXP) {
    for (int i = stages.length - 1; i >= 0; i--) {
      if (totalXP >= stages[i].minXP) {
        return stages[i].stage;
      }
    }
    return 1;
  }

  /// 스테이지 정보 가져오기
  static StageInfo getStageInfo(int stage) {
    final index = (stage - 1).clamp(0, stages.length - 1);
    return stages[index];
  }

  /// XP로 스테이지 정보 가져오기
  static StageInfo getStageInfoFromXP(int totalXP) {
    final stage = getStageFromXP(totalXP);
    return getStageInfo(stage);
  }

  /// 해당 스테이지의 일일 토큰 수
  static int getDailyTokensForStage(int stage) {
    return getStageInfo(stage).dailyTokens;
  }

  /// XP 기준 일일 토큰 수
  static int getDailyTokensFromXP(int totalXP) {
    return getStageInfoFromXP(totalXP).dailyTokens;
  }

  /// 프리미엄이 필요한 스테이지인지 확인
  static bool requiresPremium(int stage) {
    return getStageInfo(stage).requiresPremium;
  }

  /// 사용자가 해당 스테이지에 접근 가능한지 확인
  static bool canAccessStage(int stage, {required bool isPremium}) {
    final info = getStageInfo(stage);
    if (!info.requiresPremium) return true;
    return isPremium;
  }

  /// 사용자의 실제 스테이지 (프리미엄 제한 적용)
  static int getEffectiveStage(int totalXP, {required bool isPremium}) {
    final rawStage = getStageFromXP(totalXP);

    // 무료 사용자는 Stage 2까지만
    if (!isPremium && rawStage > 2) {
      return 2;
    }

    return rawStage;
  }

  /// 특정 기능이 해금되었는지 확인
  static bool isFeatureUnlocked(
    UnlockableFeature feature, {
    required int totalXP,
    required bool isPremium,
  }) {
    final effectiveStage = getEffectiveStage(totalXP, isPremium: isPremium);

    // 해당 스테이지까지의 모든 해금된 기능 확인
    for (int i = 0; i < effectiveStage; i++) {
      if (stages[i].unlockedFeatures.contains(feature)) {
        return true;
      }
    }

    return false;
  }

  /// 현재 스테이지에서 새로 해금된 기능 목록
  static List<UnlockableFeature> getNewlyUnlockedFeatures(int stage) {
    return getStageInfo(stage).unlockedFeatures;
  }

  /// 다음 스테이지까지 필요한 XP
  static int getXPToNextStage(int totalXP) {
    final currentStage = getStageFromXP(totalXP);
    if (currentStage >= 6) return 0; // 마스터는 다음 스테이지 없음

    final nextStageInfo = getStageInfo(currentStage + 1);
    return nextStageInfo.minXP - totalXP;
  }

  /// 다음 스테이지까지 필요한 일수
  static int getDaysToNextStage(int totalXP) {
    final xpNeeded = getXPToNextStage(totalXP);
    return (xpNeeded / 100).ceil();
  }

  /// 현재 스테이지 내 진행률 (0.0 ~ 1.0)
  static double getStageProgress(int totalXP) {
    final info = getStageInfoFromXP(totalXP);
    final xpInStage = totalXP - info.minXP;
    final stageRange = info.maxXP - info.minXP + 1;
    return (xpInStage / stageRange).clamp(0.0, 1.0);
  }

  /// 스테이지 변경 감지 (이전 XP와 비교)
  static StageChangeResult? checkStageChange(int oldXP, int newXP) {
    final oldStage = getStageFromXP(oldXP);
    final newStage = getStageFromXP(newXP);

    if (newStage > oldStage) {
      return StageChangeResult(
        oldStage: oldStage,
        newStage: newStage,
        newlyUnlockedFeatures: getNewlyUnlockedFeatures(newStage),
        newStageInfo: getStageInfo(newStage),
      );
    }

    return null;
  }

  /// 기능 이름 가져오기 (한국어)
  static String getFeatureNameKo(UnlockableFeature feature) {
    switch (feature) {
      case UnlockableFeature.basicChecklist:
        return '기본 체크리스트';
      case UnlockableFeature.basicGuide:
        return '기초 가이드';
      case UnlockableFeature.progressDashboard:
        return '진행도 대시보드';
      case UnlockableFeature.characterDisplay:
        return '캐릭터 표시';
      case UnlockableFeature.aiCoachingBasic:
        return 'AI 코칭 (기본)';
      case UnlockableFeature.dailyNotification:
        return '일일 알림';
      case UnlockableFeature.weeklySummaryBasic:
        return '주간 요약';
      case UnlockableFeature.aiCoachingExpanded:
        return 'AI 코칭 (확장)';
      case UnlockableFeature.detailedStats:
        return '상세 통계';
      case UnlockableFeature.weeklyReportDetailed:
        return '주간 리포트';
      case UnlockableFeature.streakBonus:
        return '스트릭 보너스';
      case UnlockableFeature.advancedChecklist:
        return '고급 체크리스트';
      case UnlockableFeature.customNotification:
        return '커스텀 알림';
      case UnlockableFeature.achievementSystem:
        return '업적 시스템';
      case UnlockableFeature.advancedProgram:
        return '심화 프로그램';
      case UnlockableFeature.trendAnalysis:
        return '트렌드 분석';
      case UnlockableFeature.monthlyReport:
        return '월간 리포트';
      case UnlockableFeature.masterBadge:
        return '마스터 배지';
      case UnlockableFeature.programCustomization:
        return '프로그램 커스터마이징';
      case UnlockableFeature.dataExport:
        return '데이터 내보내기';
      case UnlockableFeature.fullAccess:
        return '전체 기능 접근';
    }
  }

  /// 디버그 출력
  static void debugPrintStageInfo(int totalXP, {required bool isPremium}) {
    final rawStage = getStageFromXP(totalXP);
    final effectiveStage = getEffectiveStage(totalXP, isPremium: isPremium);
    final info = getStageInfo(effectiveStage);

    debugPrint('=== Stage Info ===');
    debugPrint('Total XP: $totalXP');
    debugPrint('Raw Stage: $rawStage');
    debugPrint('Effective Stage: $effectiveStage (isPremium: $isPremium)');
    debugPrint('Stage Name: ${info.emoji} ${info.nameKo} (${info.name})');
    debugPrint('Daily Tokens: ${info.dailyTokens}');
    debugPrint('Progress: ${(getStageProgress(totalXP) * 100).toStringAsFixed(1)}%');
    debugPrint('Days to next: ${getDaysToNextStage(totalXP)}');
    debugPrint('==================');
  }
}

/// 스테이지 변경 결과
class StageChangeResult {
  final int oldStage;
  final int newStage;
  final List<UnlockableFeature> newlyUnlockedFeatures;
  final StageInfo newStageInfo;

  const StageChangeResult({
    required this.oldStage,
    required this.newStage,
    required this.newlyUnlockedFeatures,
    required this.newStageInfo,
  });

  bool get isStageUp => newStage > oldStage;
}
