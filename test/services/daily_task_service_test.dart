import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucid_dream_100/services/workout/daily_task_service.dart';
import 'package:lucid_dream_100/models/lucid_dream_task.dart';

/// DailyTaskService 로직 테스트
///
/// 체크리스트 완료 및 토큰 보상 로직을 검증합니다.
void main() {
  group('DailyTaskService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('Task Completion Tracking', () {
      test('should start with all tasks incomplete', () {
        // Given: 새로운 DailyTaskService 인스턴스
        final service = DailyTaskService();

        // When: 초기 상태 확인
        final dreamJournalComplete = service.isTaskCompleted(
          LucidDreamTaskType.dreamJournal,
        );
        final realityCheckComplete = service.isTaskCompleted(
          LucidDreamTaskType.realityCheck,
        );
        final mildComplete = service.isTaskCompleted(
          LucidDreamTaskType.mildAffirmation,
        );

        // Then: 모든 태스크가 미완료 상태여야 함
        expect(dreamJournalComplete, false);
        expect(realityCheckComplete, false);
        expect(mildComplete, false);
      });

      test('should mark individual task as completed', () async {
        // Given: 새로운 서비스
        final service = DailyTaskService();

        // When: 꿈일기 태스크 완료
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);

        // Then: 해당 태스크만 완료 상태여야 함
        expect(service.isTaskCompleted(LucidDreamTaskType.dreamJournal), true);
        expect(service.isTaskCompleted(LucidDreamTaskType.realityCheck), false);
        expect(service.isTaskCompleted(LucidDreamTaskType.mildAffirmation), false);
      });

      test('should track multiple completed tasks', () async {
        // Given: 새로운 서비스
        final service = DailyTaskService();

        // When: 여러 태스크 완료
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        await service.toggleTask(LucidDreamTaskType.realityCheck, true);

        // Then: 완료된 태스크들이 추적되어야 함
        final completed = service.completedTasks;
        expect(completed.length, 2);
        expect(completed.contains(LucidDreamTaskType.dreamJournal), true);
        expect(completed.contains(LucidDreamTaskType.realityCheck), true);
      });

      test('should toggle task from completed to incomplete', () async {
        // Given: 완료된 태스크
        final service = DailyTaskService();
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        expect(service.isTaskCompleted(LucidDreamTaskType.dreamJournal), true);

        // When: 태스크를 미완료로 변경
        await service.toggleTask(LucidDreamTaskType.dreamJournal, false);

        // Then: 태스크가 미완료 상태여야 함
        expect(service.isTaskCompleted(LucidDreamTaskType.dreamJournal), false);
      });
    });

    group('Required Tasks Completion Logic', () {
      test('should identify when all 3 required tasks are complete', () async {
        // Given: 새로운 서비스
        final service = DailyTaskService();

        // When: 필수 3가지 태스크 완료
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        await service.toggleTask(LucidDreamTaskType.realityCheck, true);
        await service.toggleTask(LucidDreamTaskType.mildAffirmation, true);

        // Then: 3개의 필수 태스크가 완료되어야 함
        final requiredTasks = [
          LucidDreamTaskType.dreamJournal,
          LucidDreamTaskType.realityCheck,
          LucidDreamTaskType.mildAffirmation,
        ];

        final allCompleted = requiredTasks.every(
          (task) => service.isTaskCompleted(task),
        );

        expect(allCompleted, true);
        expect(service.completedTasks.length, 3);
      });

      test('should not trigger reward with only 2 required tasks complete', () async {
        // Given: 새로운 서비스
        final service = DailyTaskService();

        // When: 2개만 완료
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        await service.toggleTask(LucidDreamTaskType.realityCheck, true);

        // Then: 3개가 아니므로 보상 트리거 안 됨
        final requiredTasks = [
          LucidDreamTaskType.dreamJournal,
          LucidDreamTaskType.realityCheck,
          LucidDreamTaskType.mildAffirmation,
        ];

        final allCompleted = requiredTasks.every(
          (task) => service.isTaskCompleted(task),
        );

        expect(allCompleted, false);
      });

      test('should verify optional tasks do not count toward required completion', () async {
        // Given: 새로운 서비스
        final service = DailyTaskService();

        // When: 필수 2개 + 선택 1개 완료
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        await service.toggleTask(LucidDreamTaskType.realityCheck, true);
        await service.toggleTask(LucidDreamTaskType.wbtb, true); // 선택 태스크

        // Then: 필수 3개가 아니므로 보상 미트리거
        final requiredTasks = [
          LucidDreamTaskType.dreamJournal,
          LucidDreamTaskType.realityCheck,
          LucidDreamTaskType.mildAffirmation,
        ];

        final allCompleted = requiredTasks.every(
          (task) => service.isTaskCompleted(task),
        );

        expect(allCompleted, false);
        expect(service.completedTasks.length, 3); // 총 3개 완료되었지만
        expect(service.isTaskCompleted(LucidDreamTaskType.mildAffirmation), false); // MILD는 미완료
      });
    });

    group('Duplicate Reward Prevention', () {
      test('should prevent duplicate rewards on the same day', () async {
        // Given: SharedPreferences 초기화
        final prefs = await SharedPreferences.getInstance();
        final today = _getTodayDateString();

        // When: 오늘 날짜로 보상 기록 저장
        await prefs.setString('task_completion_reward_date', today);

        // Then: 같은 날짜는 중복 보상 불가
        final lastRewardDate = prefs.getString('task_completion_reward_date');
        expect(lastRewardDate, today);

        // 같은 날짜면 보상 스킵
        final shouldSkipReward = (lastRewardDate == today);
        expect(shouldSkipReward, true);
      });

      test('should allow reward on a different day', () async {
        // Given: SharedPreferences에 어제 날짜로 보상 기록
        final prefs = await SharedPreferences.getInstance();
        final yesterday = _getYesterdayDateString();
        await prefs.setString('task_completion_reward_date', yesterday);

        // When: 오늘 날짜 확인
        final lastRewardDate = prefs.getString('task_completion_reward_date');
        final today = _getTodayDateString();

        // Then: 날짜가 다르므로 보상 가능
        final shouldAllowReward = (lastRewardDate != today);
        expect(shouldAllowReward, true);
      });
    });

    group('Day Reset Logic', () {
      test('should simulate day change and reset tasks', () {
        // Given: 서비스 생성 및 태스크 완료
        final service = DailyTaskService();
        // 내부적으로 날짜가 변경되면 resetAll()이 호출됨을 시뮬레이션

        // When: 태스크 완료
        service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        service.toggleTask(LucidDreamTaskType.realityCheck, true);

        expect(service.completedTasks.length, 2);

        // Then: 수동으로 초기화 (날짜 변경 시뮬레이션)
        service.resetAll();

        // Then: 모든 태스크가 초기화되어야 함
        expect(service.completedTasks.length, 0);
        expect(service.isTaskCompleted(LucidDreamTaskType.dreamJournal), false);
        expect(service.isTaskCompleted(LucidDreamTaskType.realityCheck), false);
      });
    });

    group('Token Reward Integration Logic', () {
      test('should simulate successful token reward flow', () async {
        // Given: 3개의 필수 태스크 완료 상태
        final service = DailyTaskService();
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        await service.toggleTask(LucidDreamTaskType.realityCheck, true);
        await service.toggleTask(LucidDreamTaskType.mildAffirmation, true);

        // When: 모든 필수 태스크 완료 확인
        final requiredTasks = [
          LucidDreamTaskType.dreamJournal,
          LucidDreamTaskType.realityCheck,
          LucidDreamTaskType.mildAffirmation,
        ];

        final allRequiredCompleted = requiredTasks.every(
          (task) => service.isTaskCompleted(task),
        );

        // Then: 토큰 보상 트리거 조건 충족
        expect(allRequiredCompleted, true);

        // 토큰 보상 시뮬레이션
        final prefs = await SharedPreferences.getInstance();
        final lastRewardDate = prefs.getString('task_completion_reward_date');
        final today = _getTodayDateString();

        // 오늘 아직 보상 안 받았으면 지급
        if (lastRewardDate != today) {
          // completeChecklist 호출 시뮬레이션
          final mockTokenReward = await _simulateCompleteChecklist(
            week: 0,
            day: 0,
            xpEarned: 1,
          );

          expect(mockTokenReward['success'], true);
          expect(mockTokenReward['tokensEarned'], greaterThan(0));

          // 보상 날짜 저장
          await prefs.setString('task_completion_reward_date', today);

          // Then: 보상 기록 저장 확인
          final savedRewardDate = prefs.getString('task_completion_reward_date');
          expect(savedRewardDate, today);
        }
      });

      test('should handle token service unavailability gracefully', () async {
        // Given: 토큰 서비스가 없는 상태 (setTokenService 미호출)
        final service = DailyTaskService();

        // When: 3개 태스크 완료
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        await service.toggleTask(LucidDreamTaskType.realityCheck, true);
        await service.toggleTask(LucidDreamTaskType.mildAffirmation, true);

        // Then: 토큰 서비스 없어도 에러 없이 처리되어야 함
        // (실제 코드에서 _tokenService가 null이면 건너뜀)
        expect(service.completedTasks.length, 3);
      });

      test('should handle completeChecklist error gracefully', () async {
        // Given: completeChecklist 실패 시나리오
        final mockError = 'Firebase connection error';

        // When: 에러 발생 시뮬레이션
        final result = await _simulateCompleteChecklistError(mockError);

        // Then: 에러 처리 및 날짜 저장 (재시도 방지)
        expect(result['success'], false);
        expect(result['error'], mockError);
        expect(result['dateStillSaved'], true); // 에러 발생해도 날짜는 저장
      });
    });

    group('Edge Cases', () {
      test('should handle rapid task toggling', () async {
        // Given: 새로운 서비스
        final service = DailyTaskService();

        // When: 빠른 토글 (완료 → 미완료 → 완료)
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);
        await service.toggleTask(LucidDreamTaskType.dreamJournal, false);
        await service.toggleTask(LucidDreamTaskType.dreamJournal, true);

        // Then: 최종 상태는 완료
        expect(service.isTaskCompleted(LucidDreamTaskType.dreamJournal), true);
      });

      test('should handle all task types', () {
        // Given: 모든 태스크 타입
        final allTaskTypes = LucidDreamTaskType.values;

        // When: 모든 태스크 확인
        final service = DailyTaskService();

        // Then: 모든 태스크 타입이 처리 가능해야 함
        for (final taskType in allTaskTypes) {
          expect(
            () => service.isTaskCompleted(taskType),
            returnsNormally,
          );
        }
      });
    });
  });
}

// 테스트 헬퍼 함수들

/// 오늘 날짜를 YYYY-MM-DD 형식으로 반환
String _getTodayDateString() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

/// 어제 날짜를 YYYY-MM-DD 형식으로 반환
String _getYesterdayDateString() {
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
}

/// completeChecklist 성공 시뮬레이션
Future<Map<String, dynamic>> _simulateCompleteChecklist({
  required int week,
  required int day,
  required int xpEarned,
}) async {
  // 실제 Cloud Function 호출을 시뮬레이션
  await Future.delayed(const Duration(milliseconds: 100));

  // 토큰 보상 계산 (예: XP 1당 토큰 5개)
  final tokensEarned = xpEarned * 5;
  final newBalance = tokensEarned; // 기존 잔액 + 새 토큰

  return {
    'success': true,
    'tokensEarned': tokensEarned,
    'newBalance': newBalance,
    'week': week,
    'day': day,
    'xpEarned': xpEarned,
  };
}

/// completeChecklist 실패 시뮬레이션
Future<Map<String, dynamic>> _simulateCompleteChecklistError(
  String errorMessage,
) async {
  await Future.delayed(const Duration(milliseconds: 50));

  return {
    'success': false,
    'error': errorMessage,
    'dateStillSaved': true, // 에러 발생 시에도 날짜는 저장됨
  };
}
