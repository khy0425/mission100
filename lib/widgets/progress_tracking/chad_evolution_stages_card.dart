import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/user_profile.dart';
import 'chad_stage_item.dart';

/// Chad 진화 단계 카드
class ChadEvolutionStagesCard extends StatelessWidget {
  final UserProfile userProfile;

  const ChadEvolutionStagesCard({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final chadStages = [
      {
        'name': 'Rookie Chad',
        'image': 'assets/images/chad/basic/basicChad.png',
        'requirement': '프로그램 시작',
      },
      {
        'name': 'Rising Chad',
        'image': 'assets/images/chad/basic/basicChad.png',
        'requirement': '1주차 완료',
      },
      {
        'name': 'Alpha Chad',
        'image': 'assets/images/chad/basic/basicChad.png',
        'requirement': '2주차 완료',
      },
      {
        'name': 'Sigma Chad',
        'image': 'assets/images/chad/basic/basicChad.png',
        'requirement': '3주차 완료',
      },
      {
        'name': 'Giga Chad',
        'image': 'assets/images/chad/basic/basicChad.png',
        'requirement': '4주차 완료',
      },
      {
        'name': 'Ultra Chad',
        'image': 'assets/images/chad/basic/basicChad.png',
        'requirement': '5주차 완료',
      },
      {
        'name': 'Legendary Chad',
        'image': 'assets/images/chad/basic/basicChad.png',
        'requirement': '6주차 완료',
      },
    ];

    return Card(
      color: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timeline, color: Color(0xFF4DABF7), size: 24),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).chadEvolutionStages,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4DABF7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...chadStages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              final isUnlocked = index <= userProfile.chadLevel;
              final isCurrent = index == userProfile.chadLevel;

              return ChadStageItem(
                name: stage['name']!,
                imagePath: stage['image']!,
                requirement: stage['requirement']!,
                isUnlocked: isUnlocked,
                isCurrent: isCurrent,
                showConnector: index < chadStages.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }
}
