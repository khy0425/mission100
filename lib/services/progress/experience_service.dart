import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:async';

/// 60일 프로그램 기반 경험치 및 레벨 시스템
///
/// 레벨 설계:
/// - Level 1-5: 각 주차마다 레벨 업 (Week 1-5 완료 시)
/// - Level 6-10: 2주마다 레벨 업 (Week 7, 9, 11, 13 완료 시)
/// - Level 11-14: 진화 마일스톤과 연동 (Week 4, 8, 12, 14 완료 시)
///
/// 총 14레벨 시스템 (Week 0 = Level 1, Week 14 = Level 14+)
class ExperienceService extends ChangeNotifier {
  static final ExperienceService _instance = ExperienceService._internal();
  factory ExperienceService() => _instance;
  ExperienceService._internal();

  static const String _experienceDataKey = 'experience_data';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<DocumentSnapshot>? _experienceSubscription;

  ExperienceData _data = const ExperienceData();
  bool _isInitialized = false;

  ExperienceData get data => _data;

  /// 현재 레벨
  int get currentLevel => _data.currentLevel;

  /// 현재 경험치 (총 누적)
  int get currentExp => _data.currentExp;

  /// 총 획득 경험치
  int get totalExpEarned => _data.totalExpEarned;

  /// 최대 레벨 도달 여부
  bool get isMaxLevel => _data.currentLevel >= LevelTable.maxLevel;

  /// 현재 레벨에서의 경험치 (0부터 시작)
  int get currentLevelExp => LevelTable.getCurrentLevelExp(_data.totalExpEarned, _data.currentLevel);

  /// 다음 레벨까지 필요한 경험치
  int get expForNextLevel => LevelTable.getExpToNextLevel(_data.currentExp, _data.currentLevel);

  /// 현재 레벨 진행률 (0.0 ~ 1.0)
  double get levelProgress {
    if (isMaxLevel) return 1.0;
    final nextLevelExp = expForNextLevel;
    if (nextLevelExp <= 0) return 1.0;
    return currentLevelExp / nextLevelExp;
  }

  /// 서비스 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final dataJson = prefs.getString(_experienceDataKey);

      if (dataJson != null) {
        final dataMap = jsonDecode(dataJson) as Map<String, dynamic>;
        _data = ExperienceData.fromJson(dataMap);
      }

      _isInitialized = true;
      debugPrint('✅ ExperienceService 초기화: Level ${_data.currentLevel}, EXP ${_data.currentExp}');
    } catch (e) {
      debugPrint('❌ ExperienceService 초기화 실패: $e');
      _data = const ExperienceData();
      _isInitialized = true;
    }
  }

  /// 운동 완료 시 경험치 획득
  ///
  /// [week] - 완료한 주차 (1-14)
  /// [day] - 완료한 일차 (1-3)
  /// [completionRate] - 운동 완료율 (0.0 - 1.0)
  /// [totalReps] - 총 수행 횟수
  /// [perfectCompletion] - 완벽 수행 여부 (100% 완료 + 시간 내)
  Future<ExpGainResult> addWorkoutExp({
    required int week,
    required int day,
    required double completionRate,
    required int totalReps,
    bool perfectCompletion = false,
  }) async {
    await _ensureInitialized();

    // 기본 경험치 계산
    final baseExp = ExpCalculator.calculateWorkoutExp(
      week: week,
      day: day,
      completionRate: completionRate,
      totalReps: totalReps,
    );

    // 보너스 경험치
    int bonusExp = 0;
    final bonuses = <ExpBonus>[];

    // 완벽 수행 보너스 (20%)
    if (perfectCompletion) {
      final perfectBonus = (baseExp * 0.2).round();
      bonusExp += perfectBonus;
      bonuses.add(ExpBonus(
        type: ExpBonusType.perfectCompletion,
        amount: perfectBonus,
        description: '완벽 수행!',
      ));
    }

    // 연속 일수 보너스 (최대 50%)
    final streakBonus = _calculateStreakBonus(baseExp);
    if (streakBonus > 0) {
      bonusExp += streakBonus;
      bonuses.add(ExpBonus(
        type: ExpBonusType.streak,
        amount: streakBonus,
        description: '${_data.consecutiveDays}일 연속!',
      ));
    }

    final totalExp = baseExp + bonusExp;

    // 경험치 추가 및 레벨업 체크
    return await _addExp(totalExp, bonuses);
  }

  /// 업적 달성 시 경험치 획득
  Future<ExpGainResult> addAchievementExp(int expAmount, String achievementName) async {
    await _ensureInitialized();

    final bonus = ExpBonus(
      type: ExpBonusType.achievement,
      amount: expAmount,
      description: achievementName,
    );

    return await _addExp(expAmount, [bonus]);
  }

  /// 주차 완료 보너스 경험치
  Future<ExpGainResult> addWeekCompletionBonus(int week) async {
    await _ensureInitialized();

    final bonusExp = ExpCalculator.getWeekCompletionBonus(week);

    final bonus = ExpBonus(
      type: ExpBonusType.weekCompletion,
      amount: bonusExp,
      description: 'Week $week 완료!',
    );

    return await _addExp(bonusExp, [bonus]);
  }

  /// 경험치 추가 및 레벨업 처리
  Future<ExpGainResult> _addExp(int expAmount, List<ExpBonus> bonuses) async {
    // 총 누적 경험치 계산
    final newTotalExp = _data.totalExpEarned + expAmount;

    // 새로운 레벨 계산
    final newLevel = LevelTable.getLevelFromTotalExp(newTotalExp);

    // 현재 레벨에서의 경험치 계산
    final newCurrentLevelExp = LevelTable.getCurrentLevelExp(newTotalExp, newLevel);

    // 레벨업 체크
    final levelsGained = <LevelUpInfo>[];

    if (newLevel > _data.currentLevel) {
      // 레벨업 발생!
      for (int level = _data.currentLevel + 1; level <= newLevel; level++) {
        levelsGained.add(LevelUpInfo(
          newLevel: level,
          rewards: LevelTable.getRewardsForLevel(level),
        ));

        debugPrint('🎉 레벨 업! Level $level 달성!');
      }
    }

    // 데이터 업데이트
    _data = _data.copyWith(
      currentLevel: newLevel,
      currentExp: newCurrentLevelExp,
      totalExpEarned: newTotalExp,
      consecutiveDays: _data.consecutiveDays + 1,
      lastExpGainedAt: DateTime.now(),
    );

    await _saveData();
    notifyListeners();

    return ExpGainResult(
      expGained: expAmount,
      bonuses: bonuses,
      levelsGained: levelsGained,
      newLevel: newLevel,
      newExp: newCurrentLevelExp,
      leveledUp: levelsGained.isNotEmpty,
    );
  }

  /// 연속 일수 보너스 계산
  int _calculateStreakBonus(int baseExp) {
    if (_data.consecutiveDays < 3) return 0;

    // 3일: 10%, 7일: 20%, 14일: 30%, 21일+: 50%
    double multiplier = 0.0;
    if (_data.consecutiveDays >= 21) {
      multiplier = 0.5;
    } else if (_data.consecutiveDays >= 14) {
      multiplier = 0.3;
    } else if (_data.consecutiveDays >= 7) {
      multiplier = 0.2;
    } else if (_data.consecutiveDays >= 3) {
      multiplier = 0.1;
    }

    return (baseExp * multiplier).round();
  }

  /// 연속 일수 리셋 (운동 안 한 날)
  Future<void> resetStreak() async {
    await _ensureInitialized();

    _data = _data.copyWith(consecutiveDays: 0);
    await _saveData();
    notifyListeners();

    debugPrint('❌ 연속 일수 리셋');
  }

  /// 다음 레벨까지 필요한 경험치
  int getExpForNextLevel() {
    if (isMaxLevel) return 0;
    return LevelTable.getExpForLevel(_data.currentLevel);
  }

  /// 다음 레벨까지 진행률 (0.0 - 1.0)
  double getProgressToNextLevel() {
    if (isMaxLevel) return 1.0;

    final expNeeded = getExpForNextLevel();
    if (expNeeded == 0) return 1.0;

    return (_data.currentExp / expNeeded).clamp(0.0, 1.0);
  }

  /// 총 누적 경험치 확인 (디버그용)
  int get totalExp => _data.totalExpEarned;

  /// 데이터 저장
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataJson = jsonEncode(_data.toJson());
      await prefs.setString(_experienceDataKey, dataJson);
    } catch (e) {
      debugPrint('❌ ExperienceData 저장 실패: $e');
    }
  }

  /// 초기화 확인
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// 리셋 (디버그용)
  Future<void> reset() async {
    _data = const ExperienceData();
    await _saveData();
    notifyListeners();
    debugPrint('🔄 ExperienceService 리셋');
  }
}

/// 경험치 데이터 모델
class ExperienceData {
  final int currentLevel;
  final int currentExp;
  final int totalExpEarned;
  final int consecutiveDays;
  final DateTime? lastExpGainedAt;

  const ExperienceData({
    this.currentLevel = 1,
    this.currentExp = 0,
    this.totalExpEarned = 0,
    this.consecutiveDays = 0,
    this.lastExpGainedAt,
  });

  factory ExperienceData.fromJson(Map<String, dynamic> json) {
    return ExperienceData(
      currentLevel: json['currentLevel'] as int? ?? 1,
      currentExp: json['currentExp'] as int? ?? 0,
      totalExpEarned: json['totalExpEarned'] as int? ?? 0,
      consecutiveDays: json['consecutiveDays'] as int? ?? 0,
      lastExpGainedAt: json['lastExpGainedAt'] != null
          ? DateTime.parse(json['lastExpGainedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'currentExp': currentExp,
      'totalExpEarned': totalExpEarned,
      'consecutiveDays': consecutiveDays,
      'lastExpGainedAt': lastExpGainedAt?.toIso8601String(),
    };
  }

  ExperienceData copyWith({
    int? currentLevel,
    int? currentExp,
    int? totalExpEarned,
    int? consecutiveDays,
    DateTime? lastExpGainedAt,
  }) {
    return ExperienceData(
      currentLevel: currentLevel ?? this.currentLevel,
      currentExp: currentExp ?? this.currentExp,
      totalExpEarned: totalExpEarned ?? this.totalExpEarned,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      lastExpGainedAt: lastExpGainedAt ?? this.lastExpGainedAt,
    );
  }
}

/// 경험치 계산기
class ExpCalculator {
  /// 운동 경험치 계산
  ///
  /// 기본 공식: baseExp = weekMultiplier * dayMultiplier * repsBonus * completionRate
  static int calculateWorkoutExp({
    required int week,
    required int day,
    required double completionRate,
    required int totalReps,
  }) {
    // 주차별 베이스 경험치 (점점 증가)
    final weekBaseExp = _getWeekBaseExp(week);

    // 일차별 배율 (Day 3이 가장 높음)
    final dayMultiplier = day == 3 ? 1.2 : day == 2 ? 1.1 : 1.0;

    // 횟수 보너스 (10회당 +2 EXP)
    final repsBonus = (totalReps / 10).floor() * 2;

    // 최종 경험치
    final baseExp = (weekBaseExp * dayMultiplier).round();
    final totalExp = ((baseExp + repsBonus) * completionRate).round();

    return totalExp;
  }

  /// 주차별 베이스 경험치
  static int _getWeekBaseExp(int week) {
    // Week 1-4: 50-80 EXP (진화 1단계)
    // Week 5-8: 90-140 EXP (진화 2단계)
    // Week 9-12: 150-210 EXP (진화 3단계)
    // Week 13-14: 220-250 EXP (진화 4단계/마스터)

    if (week <= 4) {
      return 50 + (week - 1) * 10; // 50, 60, 70, 80
    } else if (week <= 8) {
      return 90 + (week - 5) * 15; // 90, 105, 120, 140
    } else if (week <= 12) {
      return 150 + (week - 9) * 20; // 150, 170, 190, 210
    } else {
      return 220 + (week - 13) * 30; // 220, 250
    }
  }

  /// 주차 완료 보너스 경험치
  static int getWeekCompletionBonus(int week) {
    // 진화 주차는 보너스 2배
    final isEvolutionWeek = week == 4 || week == 8 || week == 12 || week == 14;
    final baseBonus = 100 + (week * 20); // 120, 140, ... , 380

    return isEvolutionWeek ? baseBonus * 2 : baseBonus;
  }
}

/// 레벨 테이블 (60일 프로그램 기반 - 밸런스 최적화)
class LevelTable {
  static const int maxLevel = 14;

  /// 각 레벨별 필요 경험치 (다음 레벨까지)
  /// 자동 달성 업적을 기본 수입으로 포함하여 재설계
  static final Map<int, int> _expPerLevel = {
    1: 500,     // Level 1 → 2 (빠른 첫 레벨업)
    2: 750,     // Level 2 → 3 (+50%)
    3: 1000,    // Level 3 → 4 (+33%)
    4: 1250,    // Level 4 → 5 (+25%)
    5: 1500,    // Level 5 → 6 (첫 진화 후, +20%)
    6: 1750,    // Level 6 → 7 (+17%)
    7: 2000,    // Level 7 → 8 (+14%)
    8: 2500,    // Level 8 → 9 (2차 진화 후, +25%)
    9: 3000,    // Level 9 → 10 (+20%)
    10: 3500,   // Level 10 → 11 (+17%)
    11: 4000,   // Level 11 → 12 (+14%)
    12: 5000,   // Level 12 → 13 (3차 진화 후, +25%)
    13: 6000,   // Level 13 → 14 (+20%)
    14: 0,      // MAX Level
  };

  /// 각 레벨 도달에 필요한 누적 경험치
  static final Map<int, int> _cumulativeExp = {
    1: 0,        // 시작
    2: 500,      // Week 1 Day 2 예상
    3: 1250,     // Week 1 완료 예상
    4: 2250,     // Week 2 완료 예상
    5: 3500,     // Week 3 완료 예상
    6: 5000,     // Week 4 완료 예상 (첫 진화)
    7: 6750,     // Week 5 완료 예상
    8: 8750,     // Week 6-7 완료 예상
    9: 11250,    // Week 8 완료 예상 (2차 진화)
    10: 14250,   // Week 9 완료 예상
    11: 17750,   // Week 10 완료 예상
    12: 21750,   // Week 11 완료 예상
    13: 26750,   // Week 12 완료 예상 (3차 진화)
    14: 32750,   // Week 13-14 완료 예상 (최종 진화)
  };

  /// 레벨별로 필요한 경험치 (다음 레벨까지)
  static int getExpForLevel(int level) {
    if (level < 1 || level > maxLevel) return 0;
    return _expPerLevel[level] ?? 0;
  }

  /// 누적 경험치로 현재 레벨 계산
  static int getLevelFromTotalExp(int totalExp) {
    for (int level = maxLevel; level >= 1; level--) {
      if (totalExp >= (_cumulativeExp[level] ?? 0)) {
        return level;
      }
    }
    return 1;
  }

  /// 현재 레벨에서의 잔여 경험치 계산
  static int getCurrentLevelExp(int totalExp, int currentLevel) {
    final cumulativeForCurrentLevel = _cumulativeExp[currentLevel] ?? 0;
    return totalExp - cumulativeForCurrentLevel;
  }

  /// 다음 레벨까지 필요한 경험치
  static int getExpToNextLevel(int currentExp, int currentLevel) {
    if (currentLevel >= maxLevel) return 0;

    final expNeededForLevel = _expPerLevel[currentLevel] ?? 0;
    final currentLevelExp = getCurrentLevelExp(currentExp, currentLevel);

    return expNeededForLevel - currentLevelExp;
  }

  /// 레벨별 보상
  static List<LevelReward> getRewardsForLevel(int level) {
    final rewards = <LevelReward>[];

    // 기본 보상: 모든 레벨
    rewards.add(LevelReward(
      type: RewardType.title,
      value: _getLevelTitle(level),
      description: 'Level $level 타이틀 획득',
    ));

    // 진화 마일스톤 보상 (4, 8, 12, 14)
    if (level == 4 || level == 8 || level == 12 || level == 14) {
      rewards.add(LevelReward(
        type: RewardType.evolutionUnlock,
        value: 'Evolution ${level ~/ 4}',
        description: '캐릭터 진화!',
      ));
    }

    // 5레벨마다 특별 보상
    if (level % 5 == 0) {
      rewards.add(LevelReward(
        type: RewardType.badge,
        value: 'Milestone $level',
        description: '마일스톤 배지 획득',
      ));
    }

    return rewards;
  }

  /// 레벨별 타이틀
  static String _getLevelTitle(int level) {
    if (level <= 2) return '초보자';
    if (level <= 4) return '열정가';
    if (level <= 6) return '도전자';
    if (level <= 8) return '전사';
    if (level <= 10) return '숙련자';
    if (level <= 12) return '고수';
    if (level <= 13) return '달인';
    return '마스터'; // Level 14
  }
}

/// 경험치 획득 결과
class ExpGainResult {
  final int expGained;
  final List<ExpBonus> bonuses;
  final List<LevelUpInfo> levelsGained;
  final int newLevel;
  final int newExp;
  final bool leveledUp;

  const ExpGainResult({
    required this.expGained,
    required this.bonuses,
    required this.levelsGained,
    required this.newLevel,
    required this.newExp,
    required this.leveledUp,
  });

  int get totalBonusExp => bonuses.fold(0, (sum, b) => sum + b.amount);
  int get totalExp => expGained + totalBonusExp;
}

/// 레벨업 정보
class LevelUpInfo {
  final int newLevel;
  final List<LevelReward> rewards;

  const LevelUpInfo({
    required this.newLevel,
    required this.rewards,
  });
}

/// 경험치 보너스
class ExpBonus {
  final ExpBonusType type;
  final int amount;
  final String description;

  const ExpBonus({
    required this.type,
    required this.amount,
    required this.description,
  });
}

/// 보너스 타입
enum ExpBonusType {
  perfectCompletion, // 완벽 수행
  streak,            // 연속 일수
  achievement,       // 업적 달성
  weekCompletion,    // 주차 완료
}

/// 레벨 보상
class LevelReward {
  final RewardType type;
  final String value;
  final String description;

  const LevelReward({
    required this.type,
    required this.value,
    required this.description,
  });
}

/// 보상 타입
enum RewardType {
  title,            // 타이틀
  badge,            // 배지
  evolutionUnlock,  // 진화 해금
}
