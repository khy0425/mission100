import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/pushup_form_guide.dart';

/// 개선 팁 카드 위젯
class ImprovementTipCard extends StatelessWidget {
  final ImprovementTip tip;
  final bool isLast;

  const ImprovementTipCard({
    super.key,
    required this.tip,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColors = {
      AppLocalizations.of(context).breathingTechnique: const Color(0xFF4DABF7),
      AppLocalizations.of(context).strengthImprovement: const Color(
        0xFF51CF66,
      ),
      AppLocalizations.of(context).recovery: const Color(0xFFFFD43B),
      AppLocalizations.of(context).motivation: const Color(0xFFFF6B6B),
    };

    final categoryColor =
        categoryColors[tip.category] ?? const Color(0xFF4DABF7);

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Card(
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: categoryColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카테고리와 제목
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tip.category,
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                tip.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // 설명
              Text(
                tip.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              // 실행 항목들
              Text(
                AppLocalizations.of(context).instructions,
                style: const TextStyle(
                  color: Color(0xFF4DABF7),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...tip.actionItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 ',
                        style: TextStyle(color: categoryColor, fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          item,
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
    );
  }
}
