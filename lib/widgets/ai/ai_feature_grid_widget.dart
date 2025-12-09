import 'package:flutter/material.dart';
import '../../models/assistant_feature.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/ai/feature_card_widget.dart';
import '../../utils/ai/assistant_feature_helper.dart';

/// AI 기능 선택 그리드 위젯
///
/// 사용 가능한 AI 기능들을 그리드로 표시
class AIFeatureGridWidget extends StatelessWidget {
  final Function(AssistantFeature) onFeatureSelected;

  const AIFeatureGridWidget({
    super.key,
    required this.onFeatureSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.aiAssistantQuestion,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: AssistantFeature.values.map((feature) {
              return FeatureCardWidget(
                feature: feature,
                emoji: AssistantFeatureHelper.getFeatureEmoji(feature),
                title: AssistantFeatureHelper.getFeatureTitle(feature, l10n),
                subtitle: AssistantFeatureHelper.getFeatureSubtitle(feature, l10n),
                color: AssistantFeatureHelper.getFeatureColor(feature),
                onTap: () => onFeatureSelected(feature),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
