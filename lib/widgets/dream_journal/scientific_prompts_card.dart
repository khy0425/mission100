import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_sign.dart';

/// 과학적 꿈 회상 팁 카드
///
/// Schredl (2002) 연구 기반 꿈 회상 프롬프트를 표시하는 확장/축소 가능한 카드
class ScientificPromptsCard extends StatelessWidget {
  final bool initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const ScientificPromptsCard({
    super.key,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF5F5F5), // 연한 회색 배경으로 변경 (가독성 개선)
      elevation: AppConstants.elevationS,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: const Icon(Icons.lightbulb, color: Color(AppColors.primaryColor)),
        title: const Text(
          '꿈 회상 팁 (과학적 근거)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.fontSizeM,
            color: Colors.black87, // 텍스트 색상 명시
          ),
        ),
        subtitle: const Text(
          'Schredl (2002) 연구 기반',
          style: TextStyle(
            fontSize: AppConstants.fontSizeXS,
            color: Colors.black54, // 서브타이틀 색상 명시
          ),
        ),
        onExpansionChanged: onExpansionChanged,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPromptItem('💭 ${DreamRecallPrompt.emotionFirst}'),
                _buildPromptItem('⏪ ${DreamRecallPrompt.reverseOrder}'),
                _buildPromptItem('✨ ${DreamRecallPrompt.fragmentsOkay}'),
                _buildPromptItem('⚡ ${DreamRecallPrompt.writeFast}'),
                _buildPromptItem('📝 ${DreamRecallPrompt.keywordsOkay}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeS,
          color: Colors.black87, // 팁 텍스트 색상 명시 (가독성 개선)
        ),
      ),
    );
  }
}
