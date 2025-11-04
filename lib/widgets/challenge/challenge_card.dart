import 'package:flutter/material.dart';
import '../../models/challenge.dart';
import '../../generated/l10n/app_localizations.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onTap;
  final bool showCompletionDate;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.onTap,
    this.showCompletionDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목과 상태
              Row(
                children: [
                  Expanded(
                    child: Text(
                      challenge.title ?? challenge.titleKey,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (challenge.status != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        challenge.status!.displayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // 설명
              Text(
                challenge.description ?? challenge.descriptionKey,
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 12),

              // 진행률 표시 (활성 상태일 때만)
              if (challenge.status == ChallengeStatus.active &&
                  challenge.targetValue != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).challengeProgress(
                        (challenge.progressPercentage * 100).round(),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${((challenge.currentProgress / challenge.targetValue!) * 100).toInt()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (challenge.currentProgress / challenge.targetValue!)
                      .clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    challenge.currentProgress >= challenge.targetValue!
                        ? Colors.green
                        : Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
              ]
              // 목표 정보 (비활성 상태일 때)
              else if (challenge.targetValue != null) ...[
                Text(
                  AppLocalizations.of(context).challengeTarget(
                    challenge.targetValue ?? 0,
                    challenge.targetUnit ?? '',
                  ),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
              ],

              // 난이도와 기타 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (challenge.difficulty != null)
                    Row(
                      children: [
                        Text(
                          challenge.difficulty!.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          challenge.difficulty!.displayName,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  if (challenge.estimatedDuration != null &&
                      challenge.estimatedDuration! > 0)
                    Text(
                      AppLocalizations.of(context).challengeEstimatedDuration(
                        challenge.estimatedDuration!,
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (challenge.status) {
      case ChallengeStatus.available:
        return Colors.green;
      case ChallengeStatus.active:
        return Colors.blue;
      case ChallengeStatus.completed:
        return Colors.purple;
      case ChallengeStatus.failed:
        return Colors.red;
      case ChallengeStatus.locked:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
