import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/pushup_form_guide.dart';
import '../../services/workout/pushup_form_guide_service.dart';
import '../../utils/helpers/accessibility_utils.dart';

/// 일반적인 실수 카드 위젯
class CommonMistakeCard extends StatelessWidget {
  final CommonMistake mistake;
  final bool isLast;
  final Widget Function(String, Color, IconData, String, String) buildComparisonImage;

  const CommonMistakeCard({
    super.key,
    required this.mistake,
    required this.isLast,
    required this.buildComparisonImage,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor = Color(
      PushupFormGuideService.getSeverityColor(mistake.severity),
    );
    final corrections = mistake.corrections.join(', ');

    return Semantics(
      label: AccessibilityUtils.createCardLabel(
        title: mistake.title,
        content: mistake.description,
        additionalInfo: '심각도: ${mistake.severity}. 교정 방법: $corrections',
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
        child: Card(
          color: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: severityColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목과 심각도
                Row(
                  children: [
                    Semantics(
                      label: '경고 아이콘',
                      child: Icon(
                        Icons.warning,
                        color: severityColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        mistake.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Semantics(
                      label: '심각도 ${mistake.severity}',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: severityColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          mistake.severity.toUpperCase(),
                          style: TextStyle(
                            color: severityColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 설명
                Text(
                  mistake.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // 잘못된 자세 vs 올바른 자세 이미지
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          buildComparisonImage(
                            mistake.wrongImagePath,
                            const Color(0xFFFF6B6B),
                            Icons.close,
                            '잘못된 자세',
                            '${mistake.title} 잘못된 자세 시연 이미지',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          buildComparisonImage(
                            mistake.correctImagePath,
                            const Color(0xFF51CF66),
                            Icons.check,
                            '올바른 자세',
                            '${mistake.title} 올바른 자세 시연 이미지',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 교정 방법
                Text(
                  AppLocalizations.of(context).correctionMethod,
                  style: const TextStyle(
                    color: Color(0xFF51CF66),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...mistake.corrections.map(
                  (correction) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✓ ',
                          style: TextStyle(
                            color: Color(0xFF51CF66),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            correction,
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
            ),
          ),
        ),
      ),
    );
  }
}
