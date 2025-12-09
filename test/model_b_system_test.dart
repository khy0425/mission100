import 'package:flutter_test/flutter_test.dart';
import 'package:lucid_dream_100/services/progress/dream_statistics_service.dart';
import 'package:lucid_dream_100/models/user_subscription.dart';
import 'package:lucid_dream_100/utils/checklist_data.dart';

/// Model B 구독 시스템 통합 테스트
///
/// 테스트 항목:
/// 1. ✅ XP 기반 레벨 시스템
/// 2. ✅ 연속 보너스 (Streak Bonus)
/// 3. ✅ 레벨 천장 (무료: 1, 프리미엄: 9)
/// 4. ✅ Week 해금 시스템 (Week 1 무료, Week 2+ 프리미엄)
/// 5. ✅ 무료 구독 생성
/// 6. ✅ 프리미엄 구독 생성
void main() {
  group('Model B 시스템 테스트', () {
    // ==================== 테스트 1: XP 기반 레벨 계산 ====================
    group('1. XP 기반 레벨 시스템', () {
      test('5일 100% 완료 = 500 XP → Level 1 (무료 사용자 가능)', () {
        final stats = DreamStatistics(
          totalTrainingDays: 5,
          currentStreak: 0,
          dreamJournalCount: 5,
          realityCheckCount: 25,
          averageCompletionRate: 1.0, // 100%
          last7DaysCount: 5,
          last30DaysCount: 5,
          programProgress: 5,
          programTotal: 30,
        );

        final level = DreamStatisticsService.calculateLevel(stats);
        expect(level, equals(1), reason: '500 XP는 Level 1이어야 함');
      });

      test('7일 100% 완료 = 700 XP → Level 2 (프리미엄 필요)', () {
        final stats = DreamStatistics(
          totalTrainingDays: 7,
          currentStreak: 0,
          dreamJournalCount: 7,
          realityCheckCount: 35,
          averageCompletionRate: 1.0, // 100%
          last7DaysCount: 7,
          last30DaysCount: 7,
          programProgress: 7,
          programTotal: 30,
        );

        final level = DreamStatisticsService.calculateLevel(stats);
        expect(level, equals(2), reason: '700 XP는 Level 2여야 함');
      });

      test('14일 100% 완료 = 1400 XP → Level 3 (프리미엄 필요)', () {
        final stats = DreamStatistics(
          totalTrainingDays: 14,
          currentStreak: 0,
          dreamJournalCount: 14,
          realityCheckCount: 70,
          averageCompletionRate: 1.0, // 100%
          last7DaysCount: 7,
          last30DaysCount: 14,
          programProgress: 14,
          programTotal: 30,
        );

        final level = DreamStatisticsService.calculateLevel(stats);
        expect(level, equals(3), reason: '1400 XP는 Level 3이어야 함');
      });
    });

    // ==================== 테스트 2: 연속 보너스 XP ====================
    group('2. 연속 보너스 (Streak Bonus)', () {
      test('3일 연속 = +50 XP 보너스', () {
        final bonus = DreamStatisticsService.getStreakBonusXP(3);
        expect(bonus, equals(50), reason: '3일 연속은 50 XP 보너스');
      });

      test('7일 연속 = +100 XP 보너스', () {
        final bonus = DreamStatisticsService.getStreakBonusXP(7);
        expect(bonus, equals(100), reason: '7일 연속은 100 XP 보너스');
      });

      test('14일 연속 = +200 XP 보너스', () {
        final bonus = DreamStatisticsService.getStreakBonusXP(14);
        expect(bonus, equals(200), reason: '14일 연속은 200 XP 보너스');
      });

      test('30일 연속 = +500 XP 보너스 (레전드!)', () {
        final bonus = DreamStatisticsService.getStreakBonusXP(30);
        expect(bonus, equals(500), reason: '30일 연속은 500 XP 보너스 (레전드!)');
      });

      test('7일 100% + 7일 연속 = 700 + 100 = 800 XP → Level 2', () {
        final stats = DreamStatistics(
          totalTrainingDays: 7,
          currentStreak: 7, // 7일 연속!
          dreamJournalCount: 7,
          realityCheckCount: 35,
          averageCompletionRate: 1.0, // 100%
          last7DaysCount: 7,
          last30DaysCount: 7,
          programProgress: 7,
          programTotal: 30,
        );

        final level = DreamStatisticsService.calculateLevel(stats);
        expect(level, equals(2), reason: '700 + 100 = 800 XP는 Level 2여야 함');
      });
    });

    // ==================== 테스트 3: 레벨 천장 (무료 vs 프리미엄) ====================
    group('3. 레벨 천장 (무료: 1, 프리미엄: 9)', () {
      test('무료 사용자: Level 2 도달 시 → Level 1로 제한', () {
        final stats = DreamStatistics(
          totalTrainingDays: 7,
          currentStreak: 7,
          dreamJournalCount: 7,
          realityCheckCount: 35,
          averageCompletionRate: 1.0,
          last7DaysCount: 7,
          last30DaysCount: 7,
          programProgress: 7,
          programTotal: 30,
        );

        // 무료 사용자 최대 레벨 = 1
        final level = DreamStatisticsService.calculateLevel(
          stats,
          maxAllowedLevel: 1,
        );

        expect(level, equals(1), reason: '무료 사용자는 Level 1로 제한되어야 함');
      });

      test('프리미엄 사용자: Level 2 도달 가능', () {
        final stats = DreamStatistics(
          totalTrainingDays: 7,
          currentStreak: 7,
          dreamJournalCount: 7,
          realityCheckCount: 35,
          averageCompletionRate: 1.0,
          last7DaysCount: 7,
          last30DaysCount: 7,
          programProgress: 7,
          programTotal: 30,
        );

        // 프리미엄 사용자 최대 레벨 = 9
        final level = DreamStatisticsService.calculateLevel(
          stats,
          maxAllowedLevel: 9,
        );

        expect(level, equals(2), reason: '프리미엄 사용자는 Level 2 도달 가능');
      });

      test('프리미엄 사용자: Level 9 최대 제한', () {
        final stats = DreamStatistics(
          totalTrainingDays: 100, // 엄청 많이 훈련
          currentStreak: 30,
          dreamJournalCount: 100,
          realityCheckCount: 500,
          averageCompletionRate: 1.0,
          last7DaysCount: 7,
          last30DaysCount: 30,
          programProgress: 30,
          programTotal: 30,
        );

        final level = DreamStatisticsService.calculateLevel(
          stats,
          maxAllowedLevel: 9,
        );

        expect(level, equals(9), reason: '프리미엄 사용자도 Level 9가 최대');
      });
    });

    // ==================== 테스트 4: 다음 레벨까지 필요한 일수 ====================
    group('4. 다음 레벨까지 필요한 일수', () {
      test('무료 사용자가 Level 1 도달 시 → -1 반환 (프리미엄 필요)', () {
        final stats = DreamStatistics(
          totalTrainingDays: 7,
          currentStreak: 0,
          dreamJournalCount: 7,
          realityCheckCount: 35,
          averageCompletionRate: 1.0,
          last7DaysCount: 7,
          last30DaysCount: 7,
          programProgress: 7,
          programTotal: 30,
        );

        final daysToNext = DreamStatisticsService.daysToNextLevel(
          stats,
          maxAllowedLevel: 1, // 무료 사용자
        );

        expect(daysToNext, equals(-1), reason: '무료 사용자는 Level 1이 최대이므로 -1 반환');
      });

      test('프리미엄 사용자가 Level 1 → Level 2까지 필요한 일수 계산', () {
        final stats = DreamStatistics(
          totalTrainingDays: 5,
          currentStreak: 0,
          dreamJournalCount: 5,
          realityCheckCount: 25,
          averageCompletionRate: 1.0,
          last7DaysCount: 5,
          last30DaysCount: 5,
          programProgress: 5,
          programTotal: 30,
        );

        final daysToNext = DreamStatisticsService.daysToNextLevel(
          stats,
          maxAllowedLevel: 9, // 프리미엄 사용자
        );

        expect(daysToNext, equals(2), reason: '500 XP에서 700 XP까지 200 XP 필요 = 2일');
      });
    });

    // ==================== 테스트 5: Week 해금 시스템 ====================
    group('5. Week 해금 시스템 (Week 1 무료, Week 2+ 프리미엄)', () {
      test('Week 1 아이템은 모두 해금되어 있음', () {
        final week1Items = ChecklistData.getItemsForWeek(1);
        expect(week1Items.isNotEmpty, isTrue, reason: 'Week 1 아이템이 존재해야 함');

        // Week 1 아이템 확인
        final dreamJournal = week1Items.firstWhere((item) => item.id == 'dream_journal');
        expect(dreamJournal.unlockWeek, equals(1));

        final realityCheck = week1Items.firstWhere((item) => item.id == 'reality_check_2hr');
        expect(realityCheck.unlockWeek, equals(1));
      });

      test('Week 2 아이템은 잠겨있음 (프리미엄 필요)', () {
        final lockedItems = ChecklistData.getLockedItems(1);
        expect(lockedItems.isNotEmpty, isTrue, reason: 'Week 2+ 아이템이 잠겨있어야 함');
      });

      test('Week 3 WBTB+MILD 기법은 Week 3에 해금', () {
        final wbtbItem = ChecklistData.dailyChecklist
            .firstWhere((item) => item.id == 'wbtb_alarm');
        expect(wbtbItem.unlockWeek, equals(3), reason: 'WBTB는 Week 3에 해금');

        final mildItem = ChecklistData.dailyChecklist
            .firstWhere((item) => item.id == 'mild_wbtb');
        expect(mildItem.unlockWeek, equals(3), reason: 'MILD는 Week 3에 해금');
      });

      test('Week 5 고급 기법 (SSILD, WILD)은 Week 5에 해금', () {
        final ssildItem = ChecklistData.dailyChecklist
            .firstWhere((item) => item.id == 'ssild_technique');
        expect(ssildItem.unlockWeek, equals(5), reason: 'SSILD는 Week 5에 해금');

        final wildItem = ChecklistData.dailyChecklist
            .firstWhere((item) => item.id == 'wild_technique');
        expect(wildItem.unlockWeek, equals(5), reason: 'WILD는 Week 5에 해금');
      });

      test('isItemUnlocked: Week 1에서 Week 3 아이템은 잠겨있음', () {
        final isUnlocked = ChecklistData.isItemUnlocked('wbtb_alarm', 1);
        expect(isUnlocked, isFalse, reason: 'Week 1에서 Week 3 아이템은 잠겨있어야 함');
      });

      test('isItemUnlocked: Week 3에서 Week 3 아이템은 해금됨', () {
        final isUnlocked = ChecklistData.isItemUnlocked('wbtb_alarm', 3);
        expect(isUnlocked, isTrue, reason: 'Week 3에서 Week 3 아이템은 해금되어야 함');
      });
    });

    // ==================== 테스트 6: 무료 구독 생성 ====================
    group('6. 무료 구독 생성', () {
      test('무료 구독은 Week 1만 허용', () {
        final freeSub = UserSubscription.createFreeSubscription('test_user');

        expect(freeSub.type, equals(SubscriptionType.free));
        expect(freeSub.allowedWeeks, equals(1), reason: '무료 구독은 Week 1만 허용');
        expect(freeSub.hasAds, isTrue, reason: '무료 구독은 광고 있음');
        expect(freeSub.status, equals(SubscriptionStatus.active));
      });

      test('무료 구독으로 Week 2 접근 불가', () {
        final freeSub = UserSubscription.createFreeSubscription('test_user');
        final canAccessWeek2 = freeSub.canAccessWeek(2);

        expect(canAccessWeek2, isFalse, reason: '무료 구독은 Week 2 접근 불가');
      });

      test('무료 구독으로 Week 1 접근 가능', () {
        final freeSub = UserSubscription.createFreeSubscription('test_user');
        final canAccessWeek1 = freeSub.canAccessWeek(1);

        expect(canAccessWeek1, isTrue, reason: '무료 구독은 Week 1 접근 가능');
      });
    });

    // ==================== 테스트 7: 프리미엄 구독 생성 ====================
    group('7. 프리미엄 구독 생성', () {
      test('프리미엄 구독은 Week 1-8 허용 (60일 프로그램)', () {
        final premiumSub = UserSubscription.createPremiumSubscription('test_user');

        expect(premiumSub.type, equals(SubscriptionType.premium));
        expect(premiumSub.allowedWeeks, equals(8), reason: '프리미엄 구독은 Week 1-8 허용 (60일)');
        expect(premiumSub.hasAds, isFalse, reason: '프리미엄 구독은 광고 없음');
        expect(premiumSub.status, equals(SubscriptionStatus.active));
      });

      test('프리미엄 구독으로 Week 8 접근 가능', () {
        final premiumSub = UserSubscription.createPremiumSubscription('test_user');
        final canAccessWeek8 = premiumSub.canAccessWeek(8);

        expect(canAccessWeek8, isTrue, reason: '프리미엄 구독은 Week 8 접근 가능');
      });

      test('프리미엄 구독도 Week 9는 접근 불가 (존재하지 않음)', () {
        final premiumSub = UserSubscription.createPremiumSubscription('test_user');
        final canAccessWeek9 = premiumSub.canAccessWeek(9);

        expect(canAccessWeek9, isFalse, reason: 'Week 9는 존재하지 않음');
      });
    });

    // ==================== 테스트 8: 프리미엄 기능 체크 ====================
    group('8. 프리미엄 기능 체크', () {
      test('무료 사용자는 기본 기능만 사용 가능', () {
        final freeSub = UserSubscription.createFreeSubscription('test_user');
        final hasBasic = freeSub.hasFeature('basic_techniques');

        expect(hasBasic, isTrue, reason: '무료 사용자는 기본 기능 사용 가능');
      });

      test('무료 사용자는 프리미엄 기능 사용 불가', () {
        final freeSub = UserSubscription.createFreeSubscription('test_user');
        final hasPremium = freeSub.hasFeature('premium_features');

        expect(hasPremium, isFalse, reason: '무료 사용자는 프리미엄 기능 사용 불가');
      });

      test('프리미엄 사용자는 무제한 AI 분석 가능', () {
        final premiumSub = UserSubscription.createPremiumSubscription('test_user');
        final hasUnlimitedAI = premiumSub.hasFeature('unlimited_ai_analysis');

        expect(hasUnlimitedAI, isTrue, reason: '프리미엄 사용자는 무제한 AI 분석 가능');
      });

      test('프리미엄 사용자는 60일 확장 프로그램 접근 가능', () {
        final premiumSub = UserSubscription.createPremiumSubscription('test_user');
        final hasExtended = premiumSub.hasFeature('extended_program_60days');

        expect(hasExtended, isTrue, reason: '프리미엄 사용자는 60일 확장 프로그램 접근 가능');
      });

      test('프리미엄 사용자는 Lumi 7단계 진화 가능 (stage0-6, 56일)', () {
        final premiumSub = UserSubscription.createPremiumSubscription('test_user');
        final hasFullEvolution = premiumSub.hasFeature('lumi_full_evolution');

        expect(hasFullEvolution, isTrue, reason: '프리미엄 사용자는 Lumi 7단계 진화 가능 (stage0-6)');
      });
    });
  });
}
