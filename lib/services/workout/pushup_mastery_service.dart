import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 푸시업 마스터 진행률 추적 서비스
class PushupMasteryService {
  static const String _masteryProgressKey = 'pushup_mastery_progress';
  static const String _completedGuidesKey = 'completed_pushup_guides';
  static const String _masteryLevelKey = 'pushup_mastery_level';

  /// 푸시업 마스터 레벨 정의
  static const List<PushupMasteryLevel> masteryLevels = [
    PushupMasteryLevel(
      level: 1,
      title: '초보 CHAD',
      description: '푸시업의 기초를 익히는 단계',
      requiredGuides: ['standard', 'knee', 'incline'],
      requiredReps: 100,
      unlockedTypes: ['standard', 'knee', 'incline'],
    ),
    PushupMasteryLevel(
      level: 2,
      title: '발전하는 CHAD',
      description: '다양한 푸시업 자세를 배우는 단계',
      requiredGuides: ['wide_grip', 'diamond'],
      requiredReps: 300,
      unlockedTypes: ['wide_grip', 'diamond'],
    ),
    PushupMasteryLevel(
      level: 3,
      title: '고급 CHAD',
      description: '도전적인 푸시업을 마스터하는 단계',
      requiredGuides: ['decline', 'archer', 'pike'],
      requiredReps: 600,
      unlockedTypes: ['decline', 'archer', 'pike'],
    ),
    PushupMasteryLevel(
      level: 4,
      title: 'LEGENDARY CHAD',
      description: '푸시업의 신이 되는 단계',
      requiredGuides: ['clap', 'one_arm'],
      requiredReps: 1000,
      unlockedTypes: ['clap', 'one_arm'],
    ),
  ];

  /// 완료된 가이드 추가
  static Future<void> markGuideCompleted(String pushupTypeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedGuides = prefs.getStringList(_completedGuidesKey) ?? [];

      if (!completedGuides.contains(pushupTypeId)) {
        completedGuides.add(pushupTypeId);
        await prefs.setStringList(_completedGuidesKey, completedGuides);

        // 마스터 레벨 업데이트 확인
        await _checkMasteryLevelUp();

        debugPrint('✅ 푸시업 가이드 완료: $pushupTypeId');
      }
    } catch (e) {
      debugPrint('❌ 가이드 완료 표시 실패: $e');
    }
  }

  /// 완료된 가이드 목록 가져오기
  static Future<List<String>> getCompletedGuides() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedGuidesKey) ?? [];
  }

  /// 특정 가이드 완료 여부 확인
  static Future<bool> isGuideCompleted(String pushupTypeId) async {
    final completedGuides = await getCompletedGuides();
    return completedGuides.contains(pushupTypeId);
  }

  /// 현재 마스터 레벨 가져오기
  static Future<int> getCurrentMasteryLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_masteryLevelKey) ?? 1;
  }

  /// 마스터 레벨 업데이트
  static Future<void> _checkMasteryLevelUp() async {
    try {
      final completedGuides = await getCompletedGuides();
      final currentLevel = await getCurrentMasteryLevel();

      // 총 푸시업 횟수 가져오기 (임시로 SharedPreferences에서)
      final prefs = await SharedPreferences.getInstance();
      final totalReps = prefs.getInt('total_pushup_reps') ?? 0;

      // 다음 레벨 확인
      for (final level in masteryLevels) {
        if (level.level > currentLevel) {
          // 필요한 가이드를 모두 완료했는지 확인
          final requiredCompleted = level.requiredGuides.every(
            (guide) => completedGuides.contains(guide),
          );

          // 필요한 횟수를 달성했는지 확인
          final repsCompleted = totalReps >= level.requiredReps;

          if (requiredCompleted && repsCompleted) {
            await prefs.setInt(_masteryLevelKey, level.level);
            debugPrint('🎉 푸시업 마스터 레벨업! ${level.title} 달성!');
            break;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ 마스터 레벨 확인 실패: $e');
    }
  }

  /// 현재 마스터 레벨 정보 가져오기
  static Future<PushupMasteryLevel?> getCurrentMasteryLevelInfo() async {
    final currentLevel = await getCurrentMasteryLevel();
    return masteryLevels
        .where((level) => level.level == currentLevel)
        .firstOrNull;
  }

  /// 다음 마스터 레벨 정보 가져오기
  static Future<PushupMasteryLevel?> getNextMasteryLevelInfo() async {
    final currentLevel = await getCurrentMasteryLevel();
    return masteryLevels
        .where((level) => level.level == currentLevel + 1)
        .firstOrNull;
  }

  /// 마스터 진행률 가져오기 (0.0 ~ 1.0)
  static Future<double> getMasteryProgress() async {
    final nextLevel = await getNextMasteryLevelInfo();

    if (nextLevel == null) {
      return 1.0; // 최고 레벨 달성
    }

    final completedGuides = await getCompletedGuides();
    final prefs = await SharedPreferences.getInstance();
    final totalReps = prefs.getInt('total_pushup_reps') ?? 0;

    // 가이드 진행률
    final guideProgress = completedGuides
            .where((guide) => nextLevel.requiredGuides.contains(guide))
            .length /
        nextLevel.requiredGuides.length;

    // 횟수 진행률
    final repsProgress = totalReps / nextLevel.requiredReps;

    // 둘 중 낮은 것으로 진행률 결정 (둘 다 완료되어야 레벨업)
    return (guideProgress + repsProgress.clamp(0.0, 1.0)) / 2;
  }

  /// 해제된 푸시업 타입 목록 가져오기
  static Future<List<String>> getUnlockedPushupTypes() async {
    final currentLevel = await getCurrentMasteryLevel();
    final unlockedTypes = <String>[];

    for (final level in masteryLevels) {
      if (level.level <= currentLevel) {
        unlockedTypes.addAll(level.unlockedTypes);
      }
    }

    return unlockedTypes;
  }

  /// 푸시업 타입이 해제되었는지 확인
  static Future<bool> isPushupTypeUnlocked(String pushupTypeId) async {
    final unlockedTypes = await getUnlockedPushupTypes();
    return unlockedTypes.contains(pushupTypeId);
  }

  /// 총 푸시업 횟수 업데이트
  static Future<void> updateTotalPushupReps(int reps) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentTotal = prefs.getInt('total_pushup_reps') ?? 0;
      await prefs.setInt('total_pushup_reps', currentTotal + reps);

      // 마스터 레벨 업데이트 확인
      await _checkMasteryLevelUp();

      debugPrint('📈 총 푸시업 횟수 업데이트: +$reps (총: ${currentTotal + reps})');
    } catch (e) {
      debugPrint('❌ 푸시업 횟수 업데이트 실패: $e');
    }
  }

  /// 마스터 정보 요약
  static Future<Map<String, dynamic>> getMasterySummary() async {
    final currentLevel = await getCurrentMasteryLevel();
    final currentLevelInfo = await getCurrentMasteryLevelInfo();
    final nextLevelInfo = await getNextMasteryLevelInfo();
    final progress = await getMasteryProgress();
    final completedGuides = await getCompletedGuides();

    final prefs = await SharedPreferences.getInstance();
    final totalReps = prefs.getInt('total_pushup_reps') ?? 0;

    return {
      'currentLevel': currentLevel,
      'currentLevelTitle': currentLevelInfo?.title ?? '초보 CHAD',
      'nextLevelTitle': nextLevelInfo?.title ?? 'LEGENDARY CHAD',
      'progress': progress,
      'completedGuides': completedGuides.length,
      'totalReps': totalReps,
      'isMaxLevel': nextLevelInfo == null,
    };
  }
}

/// 푸시업 마스터 레벨 정보
class PushupMasteryLevel {
  final int level;
  final String title;
  final String description;
  final List<String> requiredGuides;
  final int requiredReps;
  final List<String> unlockedTypes;

  const PushupMasteryLevel({
    required this.level,
    required this.title,
    required this.description,
    required this.requiredGuides,
    required this.requiredReps,
    required this.unlockedTypes,
  });
}
