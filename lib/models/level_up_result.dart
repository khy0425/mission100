/// 레벨업 결과 데이터 모델
///
/// 레벨업 감지 결과를 담는 모델
/// 레벨업 발생 여부, 이전/새 레벨, 캐릭터 진화 여부 포함
class LevelUpResult {
  /// 레벨업 발생 여부
  final bool leveledUp;

  /// 이전 레벨
  final int oldLevel;

  /// 새 레벨
  final int newLevel;

  /// 캐릭터 진화 발생 여부
  final bool characterEvolved;

  /// 새 캐릭터 단계 (진화 시)
  final int? newCharacterStage;

  /// 새 캐릭터 이름 (진화 시)
  final String? newCharacterName;

  const LevelUpResult({
    required this.leveledUp,
    required this.oldLevel,
    required this.newLevel,
    this.characterEvolved = false,
    this.newCharacterStage,
    this.newCharacterName,
  });

  /// 레벨업이 없는 경우
  factory LevelUpResult.noLevelUp({int currentLevel = 1}) {
    return LevelUpResult(
      leveledUp: false,
      oldLevel: currentLevel,
      newLevel: currentLevel,
      characterEvolved: false,
    );
  }

  /// 단순 레벨업만 (캐릭터 진화 없음)
  factory LevelUpResult.levelUpOnly({
    required int oldLevel,
    required int newLevel,
  }) {
    return LevelUpResult(
      leveledUp: true,
      oldLevel: oldLevel,
      newLevel: newLevel,
      characterEvolved: false,
    );
  }

  /// 레벨업 + 캐릭터 진화
  factory LevelUpResult.withCharacterEvolution({
    required int oldLevel,
    required int newLevel,
    required int newCharacterStage,
    required String newCharacterName,
  }) {
    return LevelUpResult(
      leveledUp: true,
      oldLevel: oldLevel,
      newLevel: newLevel,
      characterEvolved: true,
      newCharacterStage: newCharacterStage,
      newCharacterName: newCharacterName,
    );
  }

  /// 레벨 차이
  int get levelDifference => newLevel - oldLevel;

  /// 여러 레벨 상승 여부 (2레벨 이상)
  bool get multipleLevelUps => levelDifference >= 2;

  @override
  String toString() {
    if (!leveledUp) {
      return 'LevelUpResult(No level up, current: $newLevel)';
    }
    if (characterEvolved) {
      return 'LevelUpResult(Lv $oldLevel → $newLevel, Character: $newCharacterName)';
    }
    return 'LevelUpResult(Lv $oldLevel → $newLevel)';
  }
}
