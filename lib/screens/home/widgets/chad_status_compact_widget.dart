import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/app_localizations.dart';
import '../../../services/chad_condition_service.dart';
import '../../../services/chad_recovery_service.dart';
import '../../../models/rpe_data.dart';
import '../../../utils/constants.dart';

/// Chad 상태 간결 위젯
///
/// 컨디션 + 회복 점수를 한 줄로 보여주는 간결한 위젯
class ChadStatusCompactWidget extends StatelessWidget {
  const ChadStatusCompactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Row(
          children: [
            // Chad 아이콘
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_emotions,
                color: Color(AppColors.primaryColor),
                size: 28,
              ),
            ),

            const SizedBox(width: AppConstants.paddingM),

            // 컨디션 상태
            Expanded(
              child: Consumer<ChadConditionService>(
                builder: (context, conditionService, _) {
                  final hasCondition = conditionService.currentCondition != null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.chadSays,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (hasCondition)
                        Row(
                          children: [
                            Text(
                              conditionService.currentCondition!.emoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                conditionService.currentCondition!.koreanName,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          l10n.selectTodayCondition,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(width: AppConstants.paddingS),

            // 회복 점수
            Consumer<ChadRecoveryService>(
              builder: (context, recoveryService, _) {
                final score = recoveryService.recoveryScore;
                final level = recoveryService.recoveryLevel;

                // RecoveryLevel에 따라 l10n 키 가져오기
                String getRecoveryLevelText(BuildContext context) {
                  final l10n = AppLocalizations.of(context);
                  switch (level) {
                    case RecoveryLevel.excellent:
                      return l10n.recoveryLevelExcellent;
                    case RecoveryLevel.good:
                      return l10n.recoveryLevelGood;
                    case RecoveryLevel.fair:
                      return l10n.recoveryLevelFair;
                    case RecoveryLevel.poor:
                      return l10n.recoveryLevelPoor;
                  }
                }

                final status = getRecoveryLevelText(context);

                Color scoreColor;
                if (score >= 80) {
                  scoreColor = Colors.green;
                } else if (score >= 60) {
                  scoreColor = Colors.orange;
                } else {
                  scoreColor = Colors.red;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: scoreColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        status,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 상세 보기 버튼
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () => _showChadStatusDetail(context),
              tooltip: 'View Details',
            ),
          ],
        ),
      ),
    );
  }

  void _showChadStatusDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 핸들 바
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // 제목
                Text(
                  AppLocalizations.of(context).chadSays,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: AppConstants.paddingL),

                // 컨디션 선택 섹션
                Consumer<ChadConditionService>(
                  builder: (context, conditionService, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).selectTodayCondition,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppConstants.paddingM),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ChadCondition.values.map((condition) {
                            final isSelected = conditionService.currentCondition == condition;

                            return FilterChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(condition.emoji),
                                  const SizedBox(width: 4),
                                  Text(condition.koreanName),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (selected) async {
                                if (selected) {
                                  await conditionService.updateCondition(condition);
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppConstants.paddingXL),

                // 회복 점수 상세
                Consumer<ChadRecoveryService>(
                  builder: (context, recoveryService, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recovery Score',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppConstants.paddingM),

                        // 점수 표시
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppConstants.paddingL),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                                const Color(AppColors.primaryColor).withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${recoveryService.recoveryScore}',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: const Color(AppColors.primaryColor),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                recoveryService.recoveryLevel.label,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppConstants.paddingS),
                              Text(
                                recoveryService.getChadRecoveryMessage(),
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
