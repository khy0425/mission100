import 'package:flutter/material.dart';
import '../../models/assistant_feature.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/ai/assistant_feature_helper.dart';

/// AI 기능 실행 뷰 위젯
///
/// 선택한 AI 기능을 실행하고 결과를 표시
class AIFeatureExecutionViewWidget extends StatelessWidget {
  final AssistantFeature selectedFeature;
  final TextEditingController inputController;
  final ScrollController scrollController;
  final String displayedResponse;
  final bool isLoading;
  final bool isTyping;
  final VoidCallback onExecute;
  final VoidCallback onClose;

  const AIFeatureExecutionViewWidget({
    super.key,
    required this.selectedFeature,
    required this.inputController,
    required this.scrollController,
    required this.displayedResponse,
    required this.isLoading,
    required this.isTyping,
    required this.onExecute,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // 선택된 기능 헤더
        Container(
          padding: const EdgeInsets.all(16),
          color: isDark ? Colors.grey[800] : const Color(0xFFF5F5F5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AssistantFeatureHelper.getFeatureTitle(selectedFeature, l10n),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
        ),

        // 입력 및 결과 영역
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 설명
                Text(
                  AssistantFeatureHelper.getFeatureDescription(selectedFeature, l10n),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),

                // 입력 필드
                if (AssistantFeatureHelper.requiresInput(selectedFeature))
                  TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      labelText: AssistantFeatureHelper.getInputLabel(selectedFeature, l10n),
                      hintText: AssistantFeatureHelper.getInputHint(selectedFeature, l10n),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                const SizedBox(height: 16),

                // 실행 버튼
                ElevatedButton(
                  onPressed: isLoading ? null : onExecute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          l10n.aiAssistantGenerating,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 24),

                // AI 응답
                if (displayedResponse.isNotEmpty || isTyping) ...[
                  Row(
                    children: [
                      Text(
                        l10n.aiAssistantResponse,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isTyping) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      displayedResponse,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
