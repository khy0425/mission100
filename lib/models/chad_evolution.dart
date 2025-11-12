import 'package:flutter/material.dart';
import 'package:lucid_dream_100/generated/l10n/app_localizations.dart';

/// Dream Spirit 진화 단계 열거형 (14 Levels + Initial)
enum ChadEvolutionStage {
  sleepCapChad, // Week 0: Dreaming Novice (꿈꾸는 초심자)
  basicChad, // Week 1: Aware Dreamer (자각하는 꿈꾸는 자)
  coffeeChad, // Week 2: Alert Dreamer (각성된 꿈꾸는 자)
  frontFacingChad, // Week 3: Focused Dreamer (집중하는 꿈꾸는 자)
  confidentChad, // Week 4: Confident Lucid Dreamer (자신감 있는 자각몽가)
  sunglassesChad, // Week 5: Cool Lucid Master (쿨한 자각몽 마스터)
  smilingChad, // Week 6: Joyful Dream Walker (기쁜 꿈 걷는 자)
  winkChad, // Week 7: Charismatic Dreamer (카리스마 넘치는 꿈꾸는 자)
  gamerChad, // Week 8: Focused Dream Master (집중된 꿈 마스터)
  laserEyesChad, // Week 9: Powerful Lucid Dreamer (강력한 자각몽가)
  laserEyesHudChad, // Week 10: Advanced Dream Controller (고급 꿈 통제자)
  glowingEyesChad, // Week 11: Radiant Dream Master (빛나는 꿈 마스터)
  doubleChad, // Week 12: Twin Dream Walker (쌍둥이 꿈 걷는 자)
  tripleChad, // Week 13: Trinity Dream Master (삼위일체 꿈 마스터)
  godChad, // Week 14: Dream God (꿈의 신)
}

/// Dream Spirit 진화 데이터 모델
class ChadEvolution {
  final ChadEvolutionStage stage;
  final String name;
  final String description;
  final String imagePath;
  final String? evolutionAnimationPath; // 진화 애니메이션 GIF 경로
  final int requiredWeek;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String unlockMessage;

  const ChadEvolution({
    required this.stage,
    required this.name,
    required this.description,
    required this.imagePath,
    this.evolutionAnimationPath,
    required this.requiredWeek,
    required this.isUnlocked,
    this.unlockedAt,
    required this.unlockMessage,
  });

  /// 기본 Dream Spirit 진화 단계들 (15-Level System)
  static const List<ChadEvolution> defaultStages = [
    // Stage 0: Initial
    ChadEvolution(
      stage: ChadEvolutionStage.sleepCapChad,
      name: '꿈꾸는 초심자',
      description: '자각몽 여정을 시작하는 Dream Spirit입니다.\n꿈의 세계에 첫 발을 내딛었습니다!',
      imagePath: 'assets/images/chad/basic/sleepCapChad.png',
      requiredWeek: 0,
      isUnlocked: true,
      unlockMessage: '꿈의 여정이 시작됩니다. 자각의 첫 걸음을 내딛었습니다.',
    ),
    // Level 1: Basic Chad
    ChadEvolution(
      stage: ChadEvolutionStage.basicChad,
      name: '자각하는 꿈꾸는 자',
      description: '첫 번째 진화를 완료한 Dream Spirit입니다.\n꿈과 현실을 구분하기 시작했습니다!',
      imagePath: 'assets/images/chad/basic/basicChad.png',
      requiredWeek: 1,
      isUnlocked: false,
      unlockMessage: '🌙 1단계 자각: 꿈 속에서 깨어나기 시작했습니다!',
    ),
    // Level 2: Coffee Chad
    ChadEvolution(
      stage: ChadEvolutionStage.coffeeChad,
      name: '각성된 꿈꾸는 자',
      description: '☕ 꿈 속에서 완전히 깨어난 Dream Spirit입니다.\n꿈의 명료도가 높아집니다!',
      imagePath: 'assets/images/chad/basic/coffeeChad.png',
      requiredWeek: 2,
      isUnlocked: false,
      unlockMessage: '☕ 2단계 자각: 꿈의 명료도가 증가했습니다!',
    ),
    // Level 3: Front Facing Chad
    ChadEvolution(
      stage: ChadEvolutionStage.frontFacingChad,
      name: '집중하는 꿈꾸는 자',
      description: '👀 꿈 속 세계에 집중하는 Dream Spirit입니다.\n리얼리티 체크를 습관화했습니다!',
      imagePath: 'assets/images/chad/basic/frontFacingChad.png',
      requiredWeek: 3,
      isUnlocked: false,
      unlockMessage: '👀 3단계 자각: 꿈의 세계가 선명해졌습니다!',
    ),
    // Level 4: Confident Chad
    ChadEvolution(
      stage: ChadEvolutionStage.confidentChad,
      name: '자신감 있는 자각몽가',
      description: '💪 꿈을 통제할 수 있는 Dream Spirit입니다.\n자각몽 컨트롤이 시작됩니다!',
      imagePath: 'assets/images/chad/basic/confidentChad.png',
      requiredWeek: 4,
      isUnlocked: false,
      unlockMessage: '💪 4단계 자각: 꿈을 통제하기 시작했습니다!',
    ),
    // Level 5: Sunglasses Chad
    ChadEvolution(
      stage: ChadEvolutionStage.sunglassesChad,
      name: '쿨한 자각몽 마스터',
      description: '🕶️ 여유롭게 꿈을 즐기는 Dream Spirit입니다.\n꿈 속에서 자유자재로 움직입니다!',
      imagePath: 'assets/images/chad/basic/sunglassesChad.png',
      requiredWeek: 5,
      isUnlocked: false,
      unlockMessage: '🕶️ 5단계 자각: 꿈을 자유롭게 즐깁니다!',
    ),
    // Level 6: Smiling Chad
    ChadEvolution(
      stage: ChadEvolutionStage.smilingChad,
      name: '기쁜 꿈 걷는 자',
      description: '😄 꿈 속에서 행복을 느끼는 Dream Spirit입니다.\n완벽한 자각몽 경험!',
      imagePath: 'assets/images/chad/basic/smilingChad.png',
      requiredWeek: 6,
      isUnlocked: false,
      unlockMessage: '😄 6단계 자각: 꿈 속에서 완벽한 행복을 느낍니다!',
    ),
    // Level 7: Wink Chad
    ChadEvolution(
      stage: ChadEvolutionStage.winkChad,
      name: '카리스마 넘치는 꿈꾸는 자',
      description: '😉 꿈 속에서 모든 것을 통제하는 Dream Spirit입니다.\n완전한 자각몽 마스터!',
      imagePath: 'assets/images/chad/basic/winkChad.png',
      requiredWeek: 7,
      isUnlocked: false,
      unlockMessage: '😉 7단계 자각: 완벽한 꿈 통제력을 얻었습니다!',
    ),
    // Level 8: Gamer Chad
    ChadEvolution(
      stage: ChadEvolutionStage.gamerChad,
      name: '집중된 꿈 마스터',
      description: '🎮 극도로 집중된 상태의 Dream Spirit입니다.\n꿈의 모든 디테일을 인지합니다!',
      imagePath: 'assets/images/chad/basic/gamerChad.png',
      requiredWeek: 8,
      isUnlocked: false,
      unlockMessage: '🎮 8단계 자각: 초집중 상태로 꿈을 관찰합니다!',
    ),
    // Level 9: Laser Eyes Chad
    ChadEvolution(
      stage: ChadEvolutionStage.laserEyesChad,
      name: '강력한 자각몽가',
      description: '⚡ 강력한 에너지를 가진 Dream Spirit입니다.\n꿈의 모든 요소를 자유자재로 변화시킵니다!',
      imagePath: 'assets/images/chad/basic/laserEyesChad.png',
      requiredWeek: 9,
      isUnlocked: false,
      unlockMessage: '⚡ 9단계 자각: 꿈을 완벽하게 변화시킵니다!',
    ),
    // Level 10: Laser Eyes HUD Chad
    ChadEvolution(
      stage: ChadEvolutionStage.laserEyesHudChad,
      name: '고급 꿈 통제자',
      description: '⚡🎯 고도의 통제력을 가진 Dream Spirit입니다.\n꿈의 모든 시스템을 파악합니다!',
      imagePath: 'assets/images/chad/basic/laserEyesHudChad.png',
      requiredWeek: 10,
      isUnlocked: false,
      unlockMessage: '⚡🎯 10단계 자각: 완벽한 꿈 분석 능력을 얻었습니다!',
    ),
    // Level 11: Glowing Eyes Chad
    ChadEvolution(
      stage: ChadEvolutionStage.glowingEyesChad,
      name: '빛나는 꿈 마스터',
      description: '✨ 눈부신 빛을 발하는 Dream Spirit입니다.\n꿈의 에너지가 넘쳐흐릅니다!',
      imagePath: 'assets/images/chad/basic/glowingEyesChad.png',
      requiredWeek: 11,
      isUnlocked: false,
      unlockMessage: '✨ 11단계 자각: 꿈의 에너지가 폭발합니다!',
    ),
    // Level 12: Double Chad
    ChadEvolution(
      stage: ChadEvolutionStage.doubleChad,
      name: '쌍둥이 꿈 걷는 자',
      description: '👥 두 배의 인식력을 가진 Dream Spirit입니다.\n동시에 여러 꿈을 인지합니다!',
      imagePath: 'assets/images/chad/basic/doubleChad.png',
      requiredWeek: 12,
      isUnlocked: false,
      unlockMessage: '👥 12단계 자각: 다중 꿈 인식이 가능해졌습니다!',
    ),
    // Level 13: Triple Chad
    ChadEvolution(
      stage: ChadEvolutionStage.tripleChad,
      name: '삼위일체 꿈 마스터',
      description: '👥👥 완벽한 조화를 이룬 Dream Spirit입니다.\n꿈·현실·의식이 하나가 됩니다!',
      imagePath: 'assets/images/chad/basic/tripleChad.png',
      requiredWeek: 13,
      isUnlocked: false,
      unlockMessage: '👥👥 13단계 자각: 삼위일체 완성! 완벽한 조화!',
    ),
    // Level 14: GOD CHAD (Final)
    ChadEvolution(
      stage: ChadEvolutionStage.godChad,
      name: '꿈의 신',
      description: '👑🌟 전설적인 최종 진화 Dream Spirit입니다.\n꿈의 세계를 완전히 지배합니다!',
      imagePath: 'assets/images/chad/basic/godChad.png',
      evolutionAnimationPath: 'assets/images/chad/evolution/level14_final.gif',
      requiredWeek: 14,
      isUnlocked: false,
      unlockMessage: '👑🌟 14단계 자각(극한): 꿈의 신 등극! 완벽한 자각몽 마스터!',
    ),
  ];

  /// 단계별 색상 테마 (15-Level System)
  Color get themeColor {
    switch (stage) {
      case ChadEvolutionStage.sleepCapChad:
        return const Color(0xFF9C88FF); // 보라색 (Sleep)
      case ChadEvolutionStage.basicChad:
        return const Color(0xFF4DABF7); // 파란색 (Basic)
      case ChadEvolutionStage.coffeeChad:
        return const Color(0xFF8B4513); // 갈색 (Coffee)
      case ChadEvolutionStage.frontFacingChad:
        return const Color(0xFF22C55E); // 초록색 (Front Facing)
      case ChadEvolutionStage.confidentChad:
        return const Color(0xFF51CF66); // 밝은 초록색 (Confident)
      case ChadEvolutionStage.sunglassesChad:
        return const Color(0xFF1F1F1F); // 검은색 (Sunglasses)
      case ChadEvolutionStage.smilingChad:
        return const Color(0xFFFBBF24); // 노란색 (Smiling)
      case ChadEvolutionStage.winkChad:
        return const Color(0xFFF59E0B); // 앰버 (Wink)
      case ChadEvolutionStage.gamerChad:
        return const Color(0xFF8B5CF6); // 보라색 (Gamer)
      case ChadEvolutionStage.laserEyesChad:
        return const Color(0xFFFF6B6B); // 빨간색 (Laser Eyes)
      case ChadEvolutionStage.laserEyesHudChad:
        return const Color(0xFF00D9FF); // 사이안 (HUD)
      case ChadEvolutionStage.glowingEyesChad:
        return const Color(0xFFFFD43B); // 금색 (Glowing Eyes)
      case ChadEvolutionStage.doubleChad:
        return const Color(0xFF6366F1); // 인디고 (Double)
      case ChadEvolutionStage.tripleChad:
        return const Color(0xFFFF6B35); // 주황색 (Triple)
      case ChadEvolutionStage.godChad:
        return const Color(0xFFFFD700); // 순금색 (GOD)
    }
  }

  /// 단계 번호 (0-9)
  int get stageNumber => stage.index;

  /// 다음 단계 여부
  bool get hasNextStage => stageNumber < ChadEvolutionStage.values.length - 1;

  /// 최종 단계 여부
  bool get isFinalStage => stage == ChadEvolutionStage.godChad;

  /// JSON으로부터 ChadEvolution 생성
  factory ChadEvolution.fromJson(Map<String, dynamic> json) {
    return ChadEvolution(
      stage: ChadEvolutionStage.values.firstWhere(
        (e) => e.toString().split('.').last == json['stage'],
        orElse: () => ChadEvolutionStage.sleepCapChad,
      ),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      evolutionAnimationPath: json['evolutionAnimationPath'] as String?,
      requiredWeek: json['requiredWeek'] as int? ?? 0,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      unlockMessage: json['unlockMessage'] as String? ?? '',
    );
  }

  /// ChadEvolution을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'stage': stage.toString().split('.').last,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'evolutionAnimationPath': evolutionAnimationPath,
      'requiredWeek': requiredWeek,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'unlockMessage': unlockMessage,
    };
  }

  /// ChadEvolution 복사본 생성
  ChadEvolution copyWith({
    ChadEvolutionStage? stage,
    String? name,
    String? description,
    String? imagePath,
    String? evolutionAnimationPath,
    int? requiredWeek,
    bool? isUnlocked,
    DateTime? unlockedAt,
    String? unlockMessage,
  }) {
    return ChadEvolution(
      stage: stage ?? this.stage,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      evolutionAnimationPath: evolutionAnimationPath ?? this.evolutionAnimationPath,
      requiredWeek: requiredWeek ?? this.requiredWeek,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      unlockMessage: unlockMessage ?? this.unlockMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChadEvolution &&
        other.stage == stage &&
        other.name == name &&
        other.description == description &&
        other.imagePath == imagePath &&
        other.requiredWeek == requiredWeek &&
        other.isUnlocked == isUnlocked &&
        other.unlockedAt == unlockedAt &&
        other.unlockMessage == unlockMessage;
  }

  @override
  int get hashCode {
    return stage.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imagePath.hashCode ^
        requiredWeek.hashCode ^
        isUnlocked.hashCode ^
        unlockedAt.hashCode ^
        unlockMessage.hashCode;
  }

  @override
  String toString() {
    return 'ChadEvolution(stage: $stage, name: $name, isUnlocked: $isUnlocked)';
  }
}

/// Chad 진화 상태 모델
class ChadEvolutionState {
  final ChadEvolutionStage currentStage;
  final List<ChadEvolution> unlockedStages;
  final DateTime? lastEvolutionAt;
  final int totalEvolutions;

  const ChadEvolutionState({
    required this.currentStage,
    required this.unlockedStages,
    this.lastEvolutionAt,
    required this.totalEvolutions,
  });

  /// 현재 Chad 정보
  ChadEvolution get currentChad {
    return ChadEvolution.defaultStages.firstWhere(
      (chad) => chad.stage == currentStage,
      orElse: () => ChadEvolution.defaultStages.first,
    );
  }

  /// 다음 Chad 정보
  ChadEvolution? get nextChad {
    final currentIndex = currentStage.index;
    if (currentIndex < ChadEvolution.defaultStages.length - 1) {
      return ChadEvolution.defaultStages[currentIndex + 1];
    }
    return null;
  }

  /// 진화 진행률 (0.0 ~ 1.0)
  double get evolutionProgress {
    final totalStages = ChadEvolution.defaultStages.length;
    return (currentStage.index + 1) / totalStages;
  }

  /// 최종 진화 완료 여부
  bool get isMaxEvolution => currentStage == ChadEvolutionStage.godChad;

  /// JSON으로부터 ChadEvolutionState 생성
  factory ChadEvolutionState.fromJson(Map<String, dynamic> json) {
    return ChadEvolutionState(
      currentStage: ChadEvolutionStage.values.firstWhere(
        (e) => e.toString().split('.').last == json['currentStage'],
        orElse: () => ChadEvolutionStage.sleepCapChad,
      ),
      unlockedStages: (json['unlockedStages'] as List<dynamic>?)
              ?.map((e) => ChadEvolution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastEvolutionAt: json['lastEvolutionAt'] != null
          ? DateTime.parse(json['lastEvolutionAt'] as String)
          : null,
      totalEvolutions: json['totalEvolutions'] as int? ?? 0,
    );
  }

  /// ChadEvolutionState를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'currentStage': currentStage.toString().split('.').last,
      'unlockedStages': unlockedStages.map((e) => e.toJson()).toList(),
      'lastEvolutionAt': lastEvolutionAt?.toIso8601String(),
      'totalEvolutions': totalEvolutions,
    };
  }

  /// ChadEvolutionState 복사본 생성
  ChadEvolutionState copyWith({
    ChadEvolutionStage? currentStage,
    List<ChadEvolution>? unlockedStages,
    DateTime? lastEvolutionAt,
    int? totalEvolutions,
  }) {
    return ChadEvolutionState(
      currentStage: currentStage ?? this.currentStage,
      unlockedStages: unlockedStages ?? this.unlockedStages,
      lastEvolutionAt: lastEvolutionAt ?? this.lastEvolutionAt,
      totalEvolutions: totalEvolutions ?? this.totalEvolutions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChadEvolutionState &&
        other.currentStage == currentStage &&
        other.unlockedStages.length == unlockedStages.length &&
        other.lastEvolutionAt == lastEvolutionAt &&
        other.totalEvolutions == totalEvolutions;
  }

  @override
  int get hashCode {
    return currentStage.hashCode ^
        unlockedStages.hashCode ^
        lastEvolutionAt.hashCode ^
        totalEvolutions.hashCode;
  }

  @override
  String toString() {
    return 'ChadEvolutionState(currentStage: $currentStage, totalEvolutions: $totalEvolutions)';
  }
}

/// Dream Spirit 통계 모델 - 자각몽 성과 기반 지표
class ChadStats {
  final int chadLevel; // Dream Spirit 레벨 (1-14)
  final int brainjoltDegree; // 자각 단계 (1-14단계)
  final double chadAura; // Dream Clarity 꿈 명료도 (0-100%)
  final double jawlineSharpness; // Lucidity Level 자각 수준 (0-100%)
  final int crowdAdmiration; // Dream Mastery Points 꿈 마스터리 포인트 (0-999+)
  final int brainjoltVoltage; // Dream Energy 꿈 에너지 (E)
  final String memePower; // Dream Mastery Tier 꿈 마스터리 등급
  final int chadConsistency; // Dream Streak 꿈 일기 연속성 (일)
  final int totalChadHours; // Total Dream Hours 총 꿈 시간 (시간)

  const ChadStats({
    required this.chadLevel,
    required this.brainjoltDegree,
    required this.chadAura,
    required this.jawlineSharpness,
    required this.crowdAdmiration,
    required this.brainjoltVoltage,
    required this.memePower,
    required this.chadConsistency,
    required this.totalChadHours,
  });

  /// 자각몽 데이터로부터 ChadStats 생성
  factory ChadStats.fromWorkoutData({
    required int level,
    required int streakDays,
    required int completedMissions,
    required int totalMinutes,
    required int shareCount,
  }) {
    // Dream Spirit 레벨 (1-14)
    final chadLevel = level.clamp(1, 14);

    // 자각 단계 = Dream Spirit 레벨
    final brainjoltDegree = chadLevel;

    // Dream Clarity 꿈 명료도: 연속일수 기반 (최대 100%)
    final chadAura = (streakDays * 2.0).clamp(0.0, 100.0);

    // Lucidity Level 자각 수준: 완료된 미션 수 기반 (최대 100%)
    final jawlineSharpness = (completedMissions * 3.0).clamp(0.0, 100.0);

    // Dream Mastery Points 꿈 마스터리 포인트: 공유 횟수 * 10
    final crowdAdmiration = (shareCount * 10).clamp(0, 999);

    // Dream Energy 꿈 에너지: 레벨 * 1000E
    final brainjoltVoltage = chadLevel * 1000;

    // Dream Mastery Tier 꿈 마스터리 등급
    String memePower;
    if (chadLevel >= 14) {
      memePower = 'DREAM GOD';
    } else if (chadLevel >= 11) {
      memePower = 'LEGENDARY DREAMER';
    } else if (chadLevel >= 7) {
      memePower = 'MASTER DREAMER';
    } else if (chadLevel >= 4) {
      memePower = 'SKILLED DREAMER';
    } else {
      memePower = 'NOVICE DREAMER';
    }

    // Dream Streak 꿈 일기 연속성 = 연속일수
    final chadConsistency = streakDays;

    // Total Dream Hours 총 꿈 시간 (분 -> 시간)
    final totalChadHours = (totalMinutes / 60).floor();

    return ChadStats(
      chadLevel: chadLevel,
      brainjoltDegree: brainjoltDegree,
      chadAura: chadAura,
      jawlineSharpness: jawlineSharpness,
      crowdAdmiration: crowdAdmiration,
      brainjoltVoltage: brainjoltVoltage,
      memePower: memePower,
      chadConsistency: chadConsistency,
      totalChadHours: totalChadHours,
    );
  }

  /// JSON으로부터 ChadStats 생성
  factory ChadStats.fromJson(Map<String, dynamic> json) {
    return ChadStats(
      chadLevel: json['chadLevel'] as int? ?? 1,
      brainjoltDegree: json['brainjoltDegree'] as int? ?? 1,
      chadAura: (json['chadAura'] as num?)?.toDouble() ?? 0.0,
      jawlineSharpness: (json['jawlineSharpness'] as num?)?.toDouble() ?? 0.0,
      crowdAdmiration: json['crowdAdmiration'] as int? ?? 0,
      brainjoltVoltage: json['brainjoltVoltage'] as int? ?? 1000,
      memePower: json['memePower'] as String? ?? 'COMMON',
      chadConsistency: json['chadConsistency'] as int? ?? 0,
      totalChadHours: json['totalChadHours'] as int? ?? 0,
    );
  }

  /// ChadStats를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'chadLevel': chadLevel,
      'brainjoltDegree': brainjoltDegree,
      'chadAura': chadAura,
      'jawlineSharpness': jawlineSharpness,
      'crowdAdmiration': crowdAdmiration,
      'brainjoltVoltage': brainjoltVoltage,
      'memePower': memePower,
      'chadConsistency': chadConsistency,
      'totalChadHours': totalChadHours,
    };
  }

  /// ChadStats 복사본 생성
  ChadStats copyWith({
    int? chadLevel,
    int? brainjoltDegree,
    double? chadAura,
    double? jawlineSharpness,
    int? crowdAdmiration,
    int? brainjoltVoltage,
    String? memePower,
    int? chadConsistency,
    int? totalChadHours,
  }) {
    return ChadStats(
      chadLevel: chadLevel ?? this.chadLevel,
      brainjoltDegree: brainjoltDegree ?? this.brainjoltDegree,
      chadAura: chadAura ?? this.chadAura,
      jawlineSharpness: jawlineSharpness ?? this.jawlineSharpness,
      crowdAdmiration: crowdAdmiration ?? this.crowdAdmiration,
      brainjoltVoltage: brainjoltVoltage ?? this.brainjoltVoltage,
      memePower: memePower ?? this.memePower,
      chadConsistency: chadConsistency ?? this.chadConsistency,
      totalChadHours: totalChadHours ?? this.totalChadHours,
    );
  }

  @override
  String toString() {
    return 'DreamSpiritStats(level: $chadLevel, lucidity: $brainjoltDegree단계, clarity: ${chadAura.toStringAsFixed(1)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChadStats &&
        other.chadLevel == chadLevel &&
        other.brainjoltDegree == brainjoltDegree &&
        other.chadAura == chadAura &&
        other.jawlineSharpness == jawlineSharpness &&
        other.crowdAdmiration == crowdAdmiration &&
        other.brainjoltVoltage == brainjoltVoltage &&
        other.memePower == memePower &&
        other.chadConsistency == chadConsistency &&
        other.totalChadHours == totalChadHours;
  }

  @override
  int get hashCode {
    return chadLevel.hashCode ^
        brainjoltDegree.hashCode ^
        chadAura.hashCode ^
        jawlineSharpness.hashCode ^
        crowdAdmiration.hashCode ^
        brainjoltVoltage.hashCode ^
        memePower.hashCode ^
        chadConsistency.hashCode ^
        totalChadHours.hashCode;
  }
}

/// ChadEvolutionStage에 대한 Localization Extension
extension ChadEvolutionStageLocalization on ChadEvolutionStage {
  /// Localized stage name
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case ChadEvolutionStage.sleepCapChad:
        return l10n.dreamSpiritStage0Name;
      case ChadEvolutionStage.basicChad:
        return l10n.dreamSpiritStage1Name;
      case ChadEvolutionStage.coffeeChad:
        return l10n.dreamSpiritStage2Name;
      case ChadEvolutionStage.frontFacingChad:
        return l10n.dreamSpiritStage3Name;
      case ChadEvolutionStage.confidentChad:
        return l10n.dreamSpiritStage4Name;
      case ChadEvolutionStage.sunglassesChad:
        return l10n.dreamSpiritStage5Name;
      case ChadEvolutionStage.smilingChad:
        return l10n.dreamSpiritStage6Name;
      case ChadEvolutionStage.winkChad:
        return l10n.dreamSpiritStage7Name;
      case ChadEvolutionStage.gamerChad:
        return l10n.dreamSpiritStage8Name;
      case ChadEvolutionStage.laserEyesChad:
        return l10n.dreamSpiritStage9Name;
      case ChadEvolutionStage.laserEyesHudChad:
        return l10n.dreamSpiritStage10Name;
      case ChadEvolutionStage.glowingEyesChad:
        return l10n.dreamSpiritStage11Name;
      case ChadEvolutionStage.doubleChad:
        return l10n.dreamSpiritStage12Name;
      case ChadEvolutionStage.tripleChad:
        return l10n.dreamSpiritStage13Name;
      case ChadEvolutionStage.godChad:
        return l10n.dreamSpiritStage14Name;
    }
  }

  /// Localized stage description
  String localizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case ChadEvolutionStage.sleepCapChad:
        return l10n.dreamSpiritStage0Desc;
      case ChadEvolutionStage.basicChad:
        return l10n.dreamSpiritStage1Desc;
      case ChadEvolutionStage.coffeeChad:
        return l10n.dreamSpiritStage2Desc;
      case ChadEvolutionStage.frontFacingChad:
        return l10n.dreamSpiritStage3Desc;
      case ChadEvolutionStage.confidentChad:
        return l10n.dreamSpiritStage4Desc;
      case ChadEvolutionStage.sunglassesChad:
        return l10n.dreamSpiritStage5Desc;
      case ChadEvolutionStage.smilingChad:
        return l10n.dreamSpiritStage6Desc;
      case ChadEvolutionStage.winkChad:
        return l10n.dreamSpiritStage7Desc;
      case ChadEvolutionStage.gamerChad:
        return l10n.dreamSpiritStage8Desc;
      case ChadEvolutionStage.laserEyesChad:
        return l10n.dreamSpiritStage9Desc;
      case ChadEvolutionStage.laserEyesHudChad:
        return l10n.dreamSpiritStage10Desc;
      case ChadEvolutionStage.glowingEyesChad:
        return l10n.dreamSpiritStage11Desc;
      case ChadEvolutionStage.doubleChad:
        return l10n.dreamSpiritStage12Desc;
      case ChadEvolutionStage.tripleChad:
        return l10n.dreamSpiritStage13Desc;
      case ChadEvolutionStage.godChad:
        return l10n.dreamSpiritStage14Desc;
    }
  }

  /// Localized unlock message
  String localizedUnlockMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case ChadEvolutionStage.sleepCapChad:
        return l10n.dreamSpiritStage0Unlock;
      case ChadEvolutionStage.basicChad:
        return l10n.dreamSpiritStage1Unlock;
      case ChadEvolutionStage.coffeeChad:
        return l10n.dreamSpiritStage2Unlock;
      case ChadEvolutionStage.frontFacingChad:
        return l10n.dreamSpiritStage3Unlock;
      case ChadEvolutionStage.confidentChad:
        return l10n.dreamSpiritStage4Unlock;
      case ChadEvolutionStage.sunglassesChad:
        return l10n.dreamSpiritStage5Unlock;
      case ChadEvolutionStage.smilingChad:
        return l10n.dreamSpiritStage6Unlock;
      case ChadEvolutionStage.winkChad:
        return l10n.dreamSpiritStage7Unlock;
      case ChadEvolutionStage.gamerChad:
        return l10n.dreamSpiritStage8Unlock;
      case ChadEvolutionStage.laserEyesChad:
        return l10n.dreamSpiritStage9Unlock;
      case ChadEvolutionStage.laserEyesHudChad:
        return l10n.dreamSpiritStage10Unlock;
      case ChadEvolutionStage.glowingEyesChad:
        return l10n.dreamSpiritStage11Unlock;
      case ChadEvolutionStage.doubleChad:
        return l10n.dreamSpiritStage12Unlock;
      case ChadEvolutionStage.tripleChad:
        return l10n.dreamSpiritStage13Unlock;
      case ChadEvolutionStage.godChad:
        return l10n.dreamSpiritStage14Unlock;
    }
  }

  /// Week requirement for this stage
  int get requiredWeek {
    return index;
  }

  /// Image path for this stage
  String get imagePath {
    switch (this) {
      case ChadEvolutionStage.sleepCapChad:
        return 'assets/images/chad/basic/sleepCapChad.png';
      case ChadEvolutionStage.basicChad:
        return 'assets/images/chad/basic/basicChad.png';
      case ChadEvolutionStage.coffeeChad:
        return 'assets/images/chad/basic/coffeeChad.png';
      case ChadEvolutionStage.frontFacingChad:
        return 'assets/images/chad/basic/frontFacingChad.png';
      case ChadEvolutionStage.confidentChad:
        return 'assets/images/chad/basic/confidentChad.png';
      case ChadEvolutionStage.sunglassesChad:
        return 'assets/images/chad/basic/sunglassesChad.png';
      case ChadEvolutionStage.smilingChad:
        return 'assets/images/chad/basic/smilingChad.png';
      case ChadEvolutionStage.winkChad:
        return 'assets/images/chad/basic/winkChad.png';
      case ChadEvolutionStage.gamerChad:
        return 'assets/images/chad/basic/gamerChad.png';
      case ChadEvolutionStage.laserEyesChad:
        return 'assets/images/chad/basic/laserEyesChad.png';
      case ChadEvolutionStage.laserEyesHudChad:
        return 'assets/images/chad/basic/laserEyesHudChad.png';
      case ChadEvolutionStage.glowingEyesChad:
        return 'assets/images/chad/basic/glowingEyesChad.png';
      case ChadEvolutionStage.doubleChad:
        return 'assets/images/chad/basic/doubleChad.png';
      case ChadEvolutionStage.tripleChad:
        return 'assets/images/chad/basic/tripleChad.png';
      case ChadEvolutionStage.godChad:
        return 'assets/images/chad/basic/godChad.png';
    }
  }

  /// Evolution animation path (optional)
  String? get evolutionAnimationPath {
    if (this == ChadEvolutionStage.godChad) {
      return 'assets/images/chad/evolution/level14_final.gif';
    }
    return null;
  }
}

/// ChadEvolution에 대한 Factory Extension
extension ChadEvolutionFactory on ChadEvolution {
  /// BuildContext를 사용하여 localized ChadEvolution 생성
  static List<ChadEvolution> getLocalizedStages(BuildContext context) {
    return ChadEvolutionStage.values.map((stage) {
      return ChadEvolution(
        stage: stage,
        name: stage.localizedName(context),
        description: stage.localizedDescription(context),
        imagePath: stage.imagePath,
        evolutionAnimationPath: stage.evolutionAnimationPath,
        requiredWeek: stage.requiredWeek,
        isUnlocked: stage == ChadEvolutionStage.sleepCapChad, // Only first stage unlocked by default
        unlockMessage: stage.localizedUnlockMessage(context),
      );
    }).toList();
  }
}
