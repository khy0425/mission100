import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/pushup_form_guide.dart';
import '../../services/workout/pushup_form_guide_service.dart';

/// 팔굽혀펴기 변형 운동 카드 위젯
class VariationCard extends StatelessWidget {
  final PushupVariation variation;
  final Widget Function(PushupVariation, Color) buildVariationImage;

  const VariationCard({
    super.key,
    required this.variation,
    required this.buildVariationImage,
  });

  @override
  Widget build(BuildContext context) {
    final difficultyColor = Color(
      PushupFormGuideService.getDifficultyColor(variation.difficulty),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: difficultyColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목과 난이도
              Row(
                children: [
                  Expanded(
                    child: Text(
                      variation.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: difficultyColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      variation.difficulty.toUpperCase(),
                      style: TextStyle(
                        color: difficultyColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 설명
              Text(
                variation.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              // 운동 시연 이미지
              buildVariationImage(variation, difficultyColor),

              const SizedBox(height: 12),

              // 실행 방법
              Text(
                AppLocalizations.of(context).instructions,
                style: const TextStyle(
                  color: Color(0xFF4DABF7),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ...variation.instructions.map(
                (instruction) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Color(0xFF4DABF7),
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          instruction,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 효과
              Text(
                AppLocalizations.of(context).benefits,
                style: const TextStyle(
                  color: Color(0xFF51CF66),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ...variation.benefits.map(
                (benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✓ ',
                        style: TextStyle(
                          color: Color(0xFF51CF66),
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          benefit,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
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
