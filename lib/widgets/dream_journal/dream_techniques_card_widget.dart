import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_sign.dart';
import '../../generated/l10n/app_localizations.dart';

/// 사용한 기법 카드 위젯
///
/// WBTB, MILD, WILD 등 사용한 자각몽 기법 표시
class DreamTechniquesCardWidget extends StatelessWidget {
  final bool usedWbtb;
  final List<String> techniquesUsed;

  const DreamTechniquesCardWidget({
    super.key,
    required this.usedWbtb,
    required this.techniquesUsed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.techniquesUsedTitle,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            if (usedWbtb)
              ListTile(
                leading: const Icon(Icons.alarm, color: Colors.orange),
                title: const Text('WBTB (Wake Back To Bed)'),
                subtitle: Text(l10n.wbtbUsedMessage),
                contentPadding: EdgeInsets.zero,
              ),
            ...(techniquesUsed.map((techniqueName) {
              final technique = LucidDreamTechnique.values.firstWhere(
                (t) => t.name == techniqueName,
                orElse: () => LucidDreamTechnique.mild,
              );
              return ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(technique.displayName),
                subtitle: Text(technique.description),
                contentPadding: EdgeInsets.zero,
              );
            })),
          ],
        ),
      ),
    );
  }
}
