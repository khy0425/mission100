import 'package:flutter/material.dart';
import '../../models/pushup_form_guide.dart';
import '../../generated/l10n/app_localizations.dart';

/// 자세 단계 카드 위젯 (스와이프 뷰용)
class FormStepCard extends StatelessWidget {
  final FormStep step;
  final int index;
  final Widget Function(FormStep) buildMediaContent;

  const FormStepCard({
    super.key,
    required this.step,
    required this.index,
    required this.buildMediaContent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF4DABF7), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 단계 번호와 제목
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4DABF7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      step.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 설명
              Text(
                step.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // 미디어 컨텐츠
              buildMediaContent(step),

              const SizedBox(height: 20),

              // 주요 포인트
              if (step.keyPoints.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context).keyPoints,
                  style: const TextStyle(
                    color: Color(0xFF4DABF7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...step.keyPoints.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Color(0xFF4DABF7),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
