import 'package:flutter/material.dart';

/// Chad 진화 단계 열거형 (14 Levels + Initial)
enum ChadEvolutionStage {
  sleepCapChad, // Week 0: Sleep Cap Chad (시작)
  basicChad, // Week 1: Basic Chad
  coffeeChad, // Week 2: Coffee Chad
  frontFacingChad, // Week 3: Front Facing Chad
  confidentChad, // Week 4: Confident Chad
  sunglassesChad, // Week 5: Sunglasses Chad
  smilingChad, // Week 6: Smiling Chad
  winkChad, // Week 7: Wink Chad
  gamerChad, // Week 8: Gamer Chad
  laserEyesChad, // Week 9: Laser Eyes Chad
  laserEyesHudChad, // Week 10: Laser Eyes HUD Chad
  glowingEyesChad, // Week 11: Glowing Eyes Chad
  doubleChad, // Week 12: Double Chad
  tripleChad, // Week 13: Triple Chad
  godChad, // Week 14: GOD CHAD (최종)
}

/// Chad 진화 데이터 모델
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

  /// 기본 Chad 진화 단계들 (9-Level System)
  static const List<ChadEvolution> defaultStages = [
    // Stage 0: Initial
    ChadEvolution(
      stage: ChadEvolutionStage.sleepCapChad,
      name: 'Sleep Cap Chad',
      description: '여정을 시작하는 Chad입니다.\n아직 잠이 덜 깬 상태지만 곧 깨어날 것입니다!',
      imagePath: 'assets/images/chad/basic/sleepCapChad.png',
      requiredWeek: 0,
      isUnlocked: true,
      unlockMessage: 'Chad는 완성형이다. 남은 것은 뇌절뿐.',
    ),
    // Level 1: Basic Chad
    ChadEvolution(
      stage: ChadEvolutionStage.basicChad,
      name: 'Basic Chad',
      description: '첫 번째 진화를 완료한 Chad입니다.\n기초 체력을 다지기 시작했습니다!',
      imagePath: 'assets/images/chad/basic/basicChad.png',
      requiredWeek: 1,
      isUnlocked: false,
      unlockMessage: '💪 뇌절 1도: Basic Chad로 진화! 턱선이 날카로워지기 시작했다.',
    ),
    // Level 2: Coffee Chad
    ChadEvolution(
      stage: ChadEvolutionStage.coffeeChad,
      name: 'Coffee Chad',
      description: '☕ 카페인으로 충전된 Chad입니다.\n에너지가 폭발합니다!',
      imagePath: 'assets/images/chad/basic/coffeeChad.png',
      requiredWeek: 2,
      isUnlocked: false,
      unlockMessage: '☕ 뇌절 2도: Coffee Chad로 진화! 카페인 오라가 뿜어져 나온다.',
    ),
    // Level 3: Front Facing Chad
    ChadEvolution(
      stage: ChadEvolutionStage.frontFacingChad,
      name: 'Front Facing Chad',
      description: '👀 정면을 응시하는 Chad입니다.\n각성이 시작되었습니다!',
      imagePath: 'assets/images/chad/basic/frontFacingChad.png',
      requiredWeek: 3,
      isUnlocked: false,
      unlockMessage: '👀 뇌절 3도: Front Facing Chad로 진화! 눈빛이 달라졌다.',
    ),
    // Level 4: Confident Chad
    ChadEvolution(
      stage: ChadEvolutionStage.confidentChad,
      name: 'Confident Chad',
      description: '💪 자신감이 넘치는 Chad입니다.\n당당한 자세를 갖췄습니다!',
      imagePath: 'assets/images/chad/basic/confidentChad.png',
      requiredWeek: 4,
      isUnlocked: false,
      unlockMessage: '💪 뇌절 4도: Confident Chad로 진화! 자신감이 폭발한다.',
    ),
    // Level 5: Sunglasses Chad
    ChadEvolution(
      stage: ChadEvolutionStage.sunglassesChad,
      name: 'Sunglasses Chad',
      description: '🕶️ 쿨한 매력의 Chad입니다.\n선글라스 뒤로 빛나는 눈빛!',
      imagePath: 'assets/images/chad/basic/sunglassesChad.png',
      requiredWeek: 5,
      isUnlocked: false,
      unlockMessage: '🕶️ 뇌절 5도: Sunglasses Chad로 진화! 쿨함이 극대화되었다.',
    ),
    // Level 6: Smiling Chad
    ChadEvolution(
      stage: ChadEvolutionStage.smilingChad,
      name: 'Smiling Chad',
      description: '😄 여유로운 미소를 짓는 Chad입니다.\n진정한 강자의 여유!',
      imagePath: 'assets/images/chad/basic/smilingChad.png',
      requiredWeek: 6,
      isUnlocked: false,
      unlockMessage: '😄 뇌절 6도: Smiling Chad로 진화! 강자의 미소 완성!',
    ),
    // Level 7: Wink Chad
    ChadEvolution(
      stage: ChadEvolutionStage.winkChad,
      name: 'Wink Chad',
      description: '😉 윙크하는 Chad입니다.\n최고의 자신감과 매력!',
      imagePath: 'assets/images/chad/basic/winkChad.png',
      requiredWeek: 7,
      isUnlocked: false,
      unlockMessage: '😉 뇌절 7도: Wink Chad로 진화! 치명적 윙크 습득!',
    ),
    // Level 8: Gamer Chad
    ChadEvolution(
      stage: ChadEvolutionStage.gamerChad,
      name: 'Gamer Chad',
      description: '🎮 게이밍 헤드셋을 착용한 Chad입니다.\n집중력과 반응속도 극대화!',
      imagePath: 'assets/images/chad/basic/gamerChad.png',
      requiredWeek: 8,
      isUnlocked: false,
      unlockMessage: '🎮 뇌절 8도: Gamer Chad로 진화! 반응속도 0.1초!',
    ),
    // Level 9: Laser Eyes Chad
    ChadEvolution(
      stage: ChadEvolutionStage.laserEyesChad,
      name: 'Laser Eyes Chad',
      description: '⚡ 눈에서 레이저가 발사되는 Chad입니다.\n파괴적인 힘을 가졌습니다!',
      imagePath: 'assets/images/chad/basic/laserEyesChad.png',
      requiredWeek: 9,
      isUnlocked: false,
      unlockMessage: '⚡ 뇌절 9도: Laser Eyes Chad로 진화! 레이저 눈빔 발사!',
    ),
    // Level 10: Laser Eyes HUD Chad
    ChadEvolution(
      stage: ChadEvolutionStage.laserEyesHudChad,
      name: 'Laser Eyes HUD Chad',
      description: '⚡🎯 레이저 + HUD 시스템이 장착된 Chad입니다.\n전투력 측정기가 폭발합니다!',
      imagePath: 'assets/images/chad/basic/laserEyesHudChad.png',
      requiredWeek: 10,
      isUnlocked: false,
      unlockMessage: '⚡🎯 뇌절 10도: HUD Chad로 진화! 전투력 측정기 장착!',
    ),
    // Level 11: Glowing Eyes Chad
    ChadEvolution(
      stage: ChadEvolutionStage.glowingEyesChad,
      name: 'Glowing Eyes Chad',
      description: '✨ 눈부신 빛을 발하는 Chad입니다.\n내면의 힘이 폭발합니다!',
      imagePath: 'assets/images/chad/basic/glowingEyesChad.png',
      requiredWeek: 11,
      isUnlocked: false,
      unlockMessage: '✨ 뇌절 11도: Glowing Eyes Chad로 진화! 눈부신 빛이 폭발한다!',
    ),
    // Level 12: Double Chad
    ChadEvolution(
      stage: ChadEvolutionStage.doubleChad,
      name: 'Double Chad',
      description: '👥 두 배의 파워를 가진 Chad입니다.\n분신술이 시작됩니다!',
      imagePath: 'assets/images/chad/basic/doubleChad.png',
      requiredWeek: 12,
      isUnlocked: false,
      unlockMessage: '👥 뇌절 12도: Double Chad로 진화! 분신술 발동!',
    ),
    // Level 13: Triple Chad
    ChadEvolution(
      stage: ChadEvolutionStage.tripleChad,
      name: 'Triple Chad',
      description: '👥👥 세 배의 파워를 가진 Chad입니다.\n삼위일체가 완성됩니다!',
      imagePath: 'assets/images/chad/basic/tripleChad.png',
      requiredWeek: 13,
      isUnlocked: false,
      unlockMessage: '👥👥 뇌절 13도: Triple Chad로 진화! 삼위일체 완성!',
    ),
    // Level 14: GOD CHAD (Final)
    ChadEvolution(
      stage: ChadEvolutionStage.godChad,
      name: 'GOD CHAD',
      description: '👑🌟 전설의 최종 진화 Chad입니다.\n신의 경지에 도달!',
      imagePath: 'assets/images/chad/basic/godChad.png',
      evolutionAnimationPath: 'assets/images/chad/evolution/level14_final.gif',
      requiredWeek: 14,
      isUnlocked: false,
      unlockMessage: '👑🌟 뇌절 14도(극한): GOD CHAD 등극! 신이 되었다!',
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

/// Chad 통계 모델 - 운동 성과 기반 밈 스타일 지표
class ChadStats {
  final int chadLevel; // Chad 레벨 (1-9)
  final int brainjoltDegree; // 뇌절 도수 (1-9도)
  final double chadAura; // Chad Aura (0-100%)
  final double jawlineSharpness; // 턱선 날카로움 (0-100%)
  final int crowdAdmiration; // 군중 찬사 (0-999+)
  final int brainjoltVoltage; // 뇌절 전압 (V)
  final String memePower; // 밈 파워 등급
  final int chadConsistency; // Chad 연속성 (일)
  final int totalChadHours; // 총 Chad 시간 (시간)

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

  /// 운동 데이터로부터 ChadStats 생성
  factory ChadStats.fromWorkoutData({
    required int level,
    required int streakDays,
    required int completedMissions,
    required int totalMinutes,
    required int shareCount,
  }) {
    // Chad 레벨 (1-9)
    final chadLevel = level.clamp(1, 9);

    // 뇌절 도수 = Chad 레벨
    final brainjoltDegree = chadLevel;

    // Chad Aura: 연속일수 기반 (최대 100%)
    final chadAura = (streakDays * 2.0).clamp(0.0, 100.0);

    // 턱선 날카로움: 완료된 미션 수 기반 (최대 100%)
    final jawlineSharpness = (completedMissions * 3.0).clamp(0.0, 100.0);

    // 군중 찬사: 공유 횟수 * 10
    final crowdAdmiration = (shareCount * 10).clamp(0, 999);

    // 뇌절 전압: 레벨 * 1000V
    final brainjoltVoltage = chadLevel * 1000;

    // 밈 파워 등급
    String memePower;
    if (chadLevel >= 9) {
      memePower = 'GOD TIER';
    } else if (chadLevel >= 7) {
      memePower = 'LEGENDARY';
    } else if (chadLevel >= 5) {
      memePower = 'EPIC';
    } else if (chadLevel >= 3) {
      memePower = 'RARE';
    } else {
      memePower = 'COMMON';
    }

    // Chad 연속성 = 연속일수
    final chadConsistency = streakDays;

    // 총 Chad 시간 (분 -> 시간)
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
    return 'ChadStats(level: $chadLevel, brainjolt: $brainjoltDegree도, aura: ${chadAura.toStringAsFixed(1)}%)';
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
