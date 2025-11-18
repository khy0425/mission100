import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../models/level_up_result.dart';
import '../../models/character_evolution.dart';
import '../../utils/config/constants.dart';
import '../../utils/checklist_data.dart';
import '../../generated/l10n/app_localizations.dart';

/// 레벨업 축하 다이얼로그
///
/// 기능:
/// - Confetti 애니메이션
/// - 레벨업 정보 표시 (이전 레벨 → 새 레벨)
/// - 캐릭터 진화 표시 (선택)
/// - 다음 레벨까지 정보
class LevelUpDialog extends StatefulWidget {
  final LevelUpResult result;
  final int daysToNextLevel;

  const LevelUpDialog({
    super.key,
    required this.result,
    this.daysToNextLevel = 0,
  });

  /// 다이얼로그 표시 헬퍼 함수
  static Future<void> show(
    BuildContext context, {
    required LevelUpResult result,
    int daysToNextLevel = 0,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LevelUpDialog(
        result: result,
        daysToNextLevel: daysToNextLevel,
      ),
    );
  }

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Confetti 컨트롤러
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // 애니메이션 컨트롤러
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // 애니메이션 시작
    _animationController.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // 배경 어둡게
        Container(color: Colors.black54),

        // Confetti 애니메이션 (상단 중앙에서)
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.2,
            colors: const [
              Color(AppColors.primaryColor),
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.pink,
              Colors.purple,
            ],
          ),
        ),

        // 다이얼로그 내용
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 아이콘
                      _buildIcon(),
                      const SizedBox(height: 20),

                      // 타이틀
                      _buildTitle(l10n),
                      const SizedBox(height: 16),

                      // 레벨 변화 표시
                      _buildLevelChange(),
                      const SizedBox(height: 16),

                      // 캐릭터 진화 정보 (있으면)
                      if (widget.result.characterEvolved) ...[
                        _buildCharacterEvolution(l10n),
                        const SizedBox(height: 16),
                        _buildUnlockedTechniques(l10n),
                        const SizedBox(height: 16),
                      ],

                      // 메시지
                      _buildMessage(l10n),
                      const SizedBox(height: 8),

                      // 다음 레벨까지 정보
                      if (widget.daysToNextLevel > 0) ...[
                        _buildNextLevelInfo(l10n),
                        const SizedBox(height: 20),
                      ] else
                        const SizedBox(height: 12),

                      // 확인 버튼
                      _buildConfirmButton(l10n),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 상단 아이콘
  Widget _buildIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(AppColors.primaryColor),
            const Color(AppColors.primaryColor).withValues(alpha: 0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        widget.result.characterEvolved ? Icons.auto_awesome : Icons.trending_up,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  /// 타이틀
  Widget _buildTitle(AppLocalizations l10n) {
    String title = widget.result.characterEvolved
        ? '🎊 ${l10n.doubleCongratulations} 🎊'
        : '🎉 ${l10n.levelUp}! 🎉';

    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(AppColors.primaryColor),
      ),
      textAlign: TextAlign.center,
    );
  }

  /// 레벨 변화 표시
  Widget _buildLevelChange() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 이전 레벨
        _buildLevelBadge(widget.result.oldLevel, isOld: true),
        const SizedBox(width: 16),

        // 화살표
        const Icon(
          Icons.arrow_forward,
          size: 32,
          color: Color(AppColors.primaryColor),
        ),
        const SizedBox(width: 16),

        // 새 레벨
        _buildLevelBadge(widget.result.newLevel, isOld: false),
      ],
    );
  }

  /// 레벨 배지
  Widget _buildLevelBadge(int level, {required bool isOld}) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOld
              ? [
                  Colors.grey[400]!,
                  Colors.grey[500]!,
                ]
              : [
                  const Color(AppColors.primaryColor),
                  const Color(AppColors.accentColor),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isOld ? Colors.grey : const Color(AppColors.primaryColor))
                .withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lv',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$level',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 캐릭터 진화 정보
  Widget _buildCharacterEvolution(AppLocalizations l10n) {
    if (!widget.result.characterEvolved) return const SizedBox.shrink();

    // 캐릭터 이미지 표시
    final characterStage = CharacterEvolution.stages[widget.result.newCharacterStage!];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // 캐릭터 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/character/${characterStage.imageFilename}',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 60,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 캐릭터 이름
          Text(
            widget.result.newCharacterName!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 4),

          // 캐릭터 설명
          Text(
            characterStage.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 해금된 기법 표시
  Widget _buildUnlockedTechniques(AppLocalizations l10n) {
    if (!widget.result.characterEvolved) return const SizedBox.shrink();

    final characterStage = CharacterEvolution.stages[widget.result.newCharacterStage!];
    // CharacterStage는 unlockDays를 사용하므로 week로 변환
    final unlockWeek = (characterStage.unlockDays / 7).ceil();

    // 이 주차에 해금되는 체크리스트 항목들
    final unlockedItems = ChecklistData.getItemsUnlockingAtWeek(unlockWeek);

    if (unlockedItems.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(AppColors.accentColor).withValues(alpha: 0.15),
            const Color(AppColors.primaryColor).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(AppColors.accentColor).withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: const Color(AppColors.accentColor),
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.newTechniqueUnlocked,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(AppColors.primaryColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 해금된 기법 리스트
          ...unlockedItems.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.icon,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nameKo,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (item.researchNote != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.researchNote!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  /// 메시지
  Widget _buildMessage(AppLocalizations l10n) {
    String message;

    if (widget.result.characterEvolved) {
      final stageIndex = widget.result.newCharacterStage!;
      // Map stage index to l10n key
      message = switch (stageIndex) {
        0 => l10n.characterUnlockStage1,
        1 => l10n.characterUnlockStage2,
        2 => l10n.characterUnlockStage3,
        3 => l10n.characterUnlockStage4,
        4 => l10n.characterUnlockStage5,
        5 => l10n.characterUnlockStage6,
        _ => CharacterEvolution.stages[stageIndex].unlockMessage, // Fallback
      };
    } else if (widget.result.multipleLevelUps) {
      message = l10n.levelUpMultipleMessage(widget.result.levelDifference);
    } else {
      message = l10n.levelUpMessage('${widget.result.newLevel}');
    }

    return Text(
      message,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// 다음 레벨까지 정보
  Widget _buildNextLevelInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        l10n.daysToNextLevel(widget.daysToNextLevel),
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  /// 확인 버튼
  Widget _buildConfirmButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppColors.primaryColor),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          l10n.confirm,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
