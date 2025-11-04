import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/pushup_form_guide.dart';
import '../../utils/helpers/accessibility_utils.dart';

/// 확장 가능한 자세 단계 카드 위젯 (리스트 뷰용)
class ExpandableFormStepCard extends StatelessWidget {
  final FormStep step;
  final int index;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget Function(FormStep) buildMediaContent;

  const ExpandableFormStepCard({
    super.key,
    required this.step,
    required this.index,
    required this.isExpanded,
    required this.onToggle,
    required this.buildMediaContent,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AccessibilityUtils.createCardLabel(
        title: '단계 ${index + 1}: ${step.title}',
        content: step.description,
        additionalInfo: isExpanded
            ? AppLocalizations.of(context).expanded
            : AppLocalizations.of(context).collapsedTapToExpand,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Card(
          color: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF4DABF7), width: 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              onToggle();
              AccessibilityUtils.provideFeedback(
                HapticFeedbackType.selectionClick,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 단계 번호와 제목
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4DABF7),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          step.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: const Color(0xFF4DABF7),
                        size: 24,
                      ),
                    ],
                  ),

                  if (isExpanded) ...[
                    const SizedBox(height: 16),

                    // 설명
                    Text(
                      step.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 미디어 컨텐츠 (비디오 또는 이미지)
                    buildMediaContent(step),

                    const SizedBox(height: 16),

                    // 주요 포인트
                    if (step.keyPoints.isNotEmpty) ...[
                      Text(
                        AppLocalizations.of(context).keyPoints,
                        style: const TextStyle(
                          color: Color(0xFF4DABF7),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...step.keyPoints.map(
                        (point) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '• ',
                                style: TextStyle(
                                  color: Color(0xFF4DABF7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  point,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
