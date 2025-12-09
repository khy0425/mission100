import 'package:flutter/material.dart';
import '../../models/character_evolution.dart';

/// 캐릭터 진화 화면
///
/// 현재 캐릭터 상태와 진화 단계를 보여주고
/// 다음 단계까지의 진행 상황을 표시합니다.
class CharacterEvolutionScreen extends StatelessWidget {
  final int currentWeek;

  const CharacterEvolutionScreen({
    super.key,
    this.currentWeek = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStage = CharacterEvolution.getStageForWeek(currentWeek);
    final currentStageIndex = CharacterEvolution.getStageIndex(currentStage);
    final nextStage = CharacterEvolution.getNextStage(currentStage);
    final stageColor = Color(int.parse(currentStage.color.replaceFirst('#', '0xFF')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('캐릭터 성장'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current character card
            _buildCurrentCharacterCard(context, theme, currentStage, stageColor),
            const SizedBox(height: 24),

            // Progress to next stage
            if (nextStage != null)
              _buildProgressCard(context, theme, currentStage, nextStage, currentWeek),
            const SizedBox(height: 24),

            // Evolution timeline
            _buildEvolutionTimeline(context, theme, currentStageIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCharacterCard(
    BuildContext context,
    ThemeData theme,
    CharacterStage stage,
    Color stageColor,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              stageColor.withValues(alpha: 0.1),
              stageColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            // Character image
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(80),
                border: Border.all(color: stageColor, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: stageColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(76),
                child: Image.asset(
                  'assets/images/character/${stage.imageFilename}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.spa, size: 80, color: stageColor);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stage name badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: stageColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                stage.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              stage.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Traits
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: stage.traits.map((trait) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: stageColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: stageColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  trait,
                  style: TextStyle(
                    color: stageColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    ThemeData theme,
    CharacterStage currentStage,
    CharacterStage nextStage,
    int currentWeek,
  ) {
    final nextWeek = CharacterEvolution.getWeekForNextStage(currentWeek);
    final nextColor = Color(int.parse(nextStage.color.replaceFirst('#', '0xFF')));

    // Calculate progress
    final currentStageIndex = CharacterEvolution.getStageIndex(currentStage);
    final weekThresholds = [0, 1, 2, 4, 7, 14];
    final startWeek = currentStageIndex < weekThresholds.length
        ? weekThresholds[currentStageIndex]
        : 0;
    final endWeek = nextWeek ?? 14;
    final progress = endWeek > startWeek
        ? (currentWeek - startWeek) / (endWeek - startWeek)
        : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_upward, color: nextColor),
                const SizedBox(width: 8),
                Text(
                  '다음 단계',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Next stage preview
            Row(
              children: [
                // Next stage image (small, greyed)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: nextColor.withValues(alpha: 0.5), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child: Opacity(
                        opacity: 0.6,
                        child: Image.asset(
                          'assets/images/character/${nextStage.imageFilename}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.spa, size: 30, color: Colors.grey[400]);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextStage.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: nextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Week $nextWeek에 해금',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Week badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: nextColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(nextWeek ?? 0) - currentWeek}주 남음',
                    style: TextStyle(
                      color: nextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '진행 상황',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: nextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(nextColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvolutionTimeline(
    BuildContext context,
    ThemeData theme,
    int currentStageIndex,
  ) {
    final stages = CharacterEvolution.stages;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  '성장 여정',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Timeline
            ...List.generate(stages.length, (index) {
              final stage = stages[index];
              final isUnlocked = index <= currentStageIndex;
              final isCurrent = index == currentStageIndex;
              final stageColor = Color(int.parse(stage.color.replaceFirst('#', '0xFF')));

              return _buildTimelineItem(
                context,
                theme,
                stage: stage,
                stageColor: stageColor,
                isUnlocked: isUnlocked,
                isCurrent: isCurrent,
                isLast: index == stages.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    ThemeData theme, {
    required CharacterStage stage,
    required Color stageColor,
    required bool isUnlocked,
    required bool isCurrent,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isUnlocked ? stageColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                  border: isCurrent
                      ? Border.all(color: stageColor, width: 3)
                      : null,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: stageColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isUnlocked ? Icons.check : Icons.lock,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: isUnlocked ? stageColor.withValues(alpha: 0.5) : Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Stage info
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrent
                    ? stageColor.withValues(alpha: 0.1)
                    : (isUnlocked ? Colors.grey[50] : Colors.grey[100]),
                borderRadius: BorderRadius.circular(12),
                border: isCurrent
                    ? Border.all(color: stageColor.withValues(alpha: 0.3))
                    : null,
              ),
              child: Row(
                children: [
                  // Small image
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isUnlocked ? Colors.white : Colors.grey[200],
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: isUnlocked
                          ? Image.asset(
                              'assets/images/character/${stage.imageFilename}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.spa, size: 24, color: stageColor);
                              },
                            )
                          : ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.saturation,
                              ),
                              child: Opacity(
                                opacity: 0.4,
                                child: Image.asset(
                                  'assets/images/character/${stage.imageFilename}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.spa, size: 24, color: Colors.grey[400]);
                                  },
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                stage.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isUnlocked ? stageColor : Colors.grey[500],
                                ),
                              ),
                            ),
                            if (isCurrent)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: stageColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '현재',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isUnlocked
                              ? stage.description
                              : 'Week ${stage.unlockDays ~/ 7}에 해금',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
