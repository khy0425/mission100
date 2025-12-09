import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/level_up_result.dart';
import '../../models/character_evolution.dart';
import '../workout/checklist_history_service.dart';
import 'dream_statistics_service.dart';
import '../monetization/ai_credit_service.dart';

/// 레벨업 감지 및 추적 서비스
///
/// 기능:
/// - 이전 레벨 저장 및 로드
/// - 레벨업 감지 (현재 레벨 vs 이전 레벨)
/// - 캐릭터 진화 감지
/// - 레벨업 히스토리 추적
class LevelUpService {
  // SharedPreferences Keys
  static const String _keyLastKnownLevel = 'last_known_level';
  static const String _keyLastCheckDate = 'last_level_check_date';
  static const String _keyLevelUpCount = 'level_up_count';
  static const String _keyHighestLevel = 'highest_level_reached';
  static const String _keyLastCharacterStage = 'last_character_stage';

  /// 레벨업 체크 (메인 함수)
  ///
  /// 현재 레벨과 이전 레벨을 비교하여 레벨업 발생 여부 확인
  /// 캐릭터 진화도 함께 체크
  ///
  /// [maxAllowedLevel]: 구독 상태에 따른 최대 허용 레벨 (무료: 1, 프리미엄: 9)
  static Future<LevelUpResult> checkForLevelUp({int maxAllowedLevel = 9}) async {
    try {
      // 현재 통계 가져오기
      final stats = await DreamStatisticsService.getStatistics();
      final currentLevel = DreamStatisticsService.calculateLevel(
        stats,
        maxAllowedLevel: maxAllowedLevel,
      );

      // 이전 레벨 가져오기
      final lastKnownLevel = await getLastKnownLevel();

      debugPrint('🔍 Level Check: Last=$lastKnownLevel, Current=$currentLevel (Max: $maxAllowedLevel)');

      // 레벨업 발생 여부
      if (currentLevel > lastKnownLevel) {
        // 레벨업 발생!
        debugPrint('🎉 LEVEL UP! $lastKnownLevel → $currentLevel');

        // 레벨 저장
        await saveLastKnownLevel(currentLevel);
        await incrementLevelUpCount();
        await updateHighestLevel(currentLevel);
        await updateLastCheckDate();

        // AI 크레딧 보너스 지급
        await AIcreditService.earnLevelUpBonus();

        // 캐릭터 진화 체크
        final characterEvolution = await _checkCharacterEvolution();

        if (characterEvolution != null) {
          // 레벨업 + 캐릭터 진화
          debugPrint('✨ Character Evolution! Stage ${characterEvolution['stage']}');
          return LevelUpResult.withCharacterEvolution(
            oldLevel: lastKnownLevel,
            newLevel: currentLevel,
            newCharacterStage: characterEvolution['stage'] as int,
            newCharacterName: characterEvolution['name'] as String,
          );
        } else {
          // 레벨업만
          return LevelUpResult.levelUpOnly(
            oldLevel: lastKnownLevel,
            newLevel: currentLevel,
          );
        }
      }

      // 레벨업 없음
      return LevelUpResult.noLevelUp(currentLevel: currentLevel);
    } catch (e) {
      debugPrint('❌ Error checking level up: $e');
      return LevelUpResult.noLevelUp();
    }
  }

  /// 캐릭터 진화 체크
  ///
  /// 이전 캐릭터 단계와 현재 단계를 비교
  /// 진화 발생 시 {stage, name} 반환, 없으면 null
  static Future<Map<String, dynamic>?> _checkCharacterEvolution() async {
    try {
      // 현재 훈련 일수 확인
      final trainingDays = await ChecklistHistoryService.getProgramProgress();

      // 현재 캐릭터 단계 (일수 기반)
      final currentStage = CharacterEvolution.getStageForDays(trainingDays);

      // 이전 캐릭터 단계
      final lastStageIndex = await getLastCharacterStage();

      // 단계 인덱스 (stage0=0, stage1=1, ...)
      final currentStageIndex = int.parse(currentStage.id.replaceAll('stage', ''));

      debugPrint('🎭 Character Check: Days=$trainingDays, Last=$lastStageIndex, Current=$currentStageIndex');

      if (currentStageIndex > lastStageIndex) {
        // 캐릭터 진화 발생!
        await saveLastCharacterStage(currentStageIndex);
        return {
          'stage': currentStageIndex,
          'name': currentStage.name,
        };
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error checking character evolution: $e');
      return null;
    }
  }

  /// 마지막으로 알려진 레벨 가져오기
  static Future<int> getLastKnownLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyLastKnownLevel) ?? 1; // 기본값 1
    } catch (e) {
      debugPrint('❌ Error getting last known level: $e');
      return 1;
    }
  }

  /// 레벨 저장
  static Future<void> saveLastKnownLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyLastKnownLevel, level);
      debugPrint('💾 Saved level: $level');
    } catch (e) {
      debugPrint('❌ Error saving level: $e');
    }
  }

  /// 레벨업 횟수 증가
  static Future<void> incrementLevelUpCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final count = prefs.getInt(_keyLevelUpCount) ?? 0;
      await prefs.setInt(_keyLevelUpCount, count + 1);
      debugPrint('📊 Level up count: ${count + 1}');
    } catch (e) {
      debugPrint('❌ Error incrementing level up count: $e');
    }
  }

  /// 최고 레벨 업데이트
  static Future<void> updateHighestLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final highest = prefs.getInt(_keyHighestLevel) ?? 0;
      if (level > highest) {
        await prefs.setInt(_keyHighestLevel, level);
        debugPrint('🏆 New highest level: $level');
      }
    } catch (e) {
      debugPrint('❌ Error updating highest level: $e');
    }
  }

  /// 마지막 체크 날짜 업데이트
  static Future<void> updateLastCheckDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().toIso8601String();
      await prefs.setString(_keyLastCheckDate, now);
    } catch (e) {
      debugPrint('❌ Error updating last check date: $e');
    }
  }

  /// 마지막 캐릭터 단계 가져오기
  static Future<int> getLastCharacterStage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyLastCharacterStage) ?? 0; // 기본값 stage0
    } catch (e) {
      debugPrint('❌ Error getting last character stage: $e');
      return 0;
    }
  }

  /// 캐릭터 단계 저장
  static Future<void> saveLastCharacterStage(int stage) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyLastCharacterStage, stage);
      debugPrint('💾 Saved character stage: $stage');
    } catch (e) {
      debugPrint('❌ Error saving character stage: $e');
    }
  }

  /// 총 레벨업 횟수 가져오기
  static Future<int> getLevelUpCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyLevelUpCount) ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting level up count: $e');
      return 0;
    }
  }

  /// 최고 도달 레벨 가져오기
  static Future<int> getHighestLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyHighestLevel) ?? 1;
    } catch (e) {
      debugPrint('❌ Error getting highest level: $e');
      return 1;
    }
  }

  /// 레벨 데이터 초기화 (테스트/디버그용)
  static Future<void> resetLevelData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyLastKnownLevel);
      await prefs.remove(_keyLastCheckDate);
      await prefs.remove(_keyLevelUpCount);
      await prefs.remove(_keyHighestLevel);
      await prefs.remove(_keyLastCharacterStage);
      debugPrint('🔄 Level data reset');
    } catch (e) {
      debugPrint('❌ Error resetting level data: $e');
    }
  }

  /// 레벨 통계 가져오기
  static Future<Map<String, dynamic>> getLevelStats() async {
    return {
      'lastKnownLevel': await getLastKnownLevel(),
      'levelUpCount': await getLevelUpCount(),
      'highestLevel': await getHighestLevel(),
      'lastCharacterStage': await getLastCharacterStage(),
    };
  }
}
