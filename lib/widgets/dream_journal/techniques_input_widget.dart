import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_sign.dart';
import '../../generated/l10n/app_localizations.dart';

/// 사용한 기법 입력 위젯
///
/// WBTB 및 다양한 자각몽 유도 기법(MILD, WILD 등)을 선택할 수 있는 위젯
class TechniquesInputWidget extends StatelessWidget {
  final bool usedWbtb;
  final List<LucidDreamTechnique> techniquesUsed;
  final Function(bool) onWbtbChanged;
  final Function(LucidDreamTechnique, bool) onTechniqueChanged;

  const TechniquesInputWidget({
    super.key,
    required this.usedWbtb,
    required this.techniquesUsed,
    required this.onWbtbChanged,
    required this.onTechniqueChanged,
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
            Text(
              l10n.techniquesUsedLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeM,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            CheckboxListTile(
              title: const Text('WBTB (Wake Back To Bed)'),
              subtitle: Text(l10n.wbtbTechnique),
              value: usedWbtb,
              onChanged: (value) => onWbtbChanged(value ?? false),
            ),
            const Divider(),
            ...LucidDreamTechnique.values.map((technique) {
              final isSelected = techniquesUsed.contains(technique);
              return CheckboxListTile(
                title: Text(technique.displayName),
                subtitle: Text(
                  technique.description,
                  style: const TextStyle(fontSize: AppConstants.fontSizeXS),
                ),
                value: isSelected,
                onChanged: (value) => onTechniqueChanged(technique, value ?? false),
              );
            }),
          ],
        ),
      ),
    );
  }
}
