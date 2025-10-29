import 'package:flutter/material.dart';
import '../../models/pushup_form_guide.dart';
import '../../services/workout/pushup_form_guide_service.dart';
import 'section_header.dart';
import 'difficulty_header.dart';
import 'variation_card.dart';

/// 변형 운동 탭 위젯
class VariationsTab extends StatelessWidget {
  final List<PushupVariation> variations;
  final String headerTitle;
  final String headerSubtitle;
  final String beginnerLabel;
  final String intermediateLabel;
  final String advancedLabel;
  final Widget Function(PushupVariation, Color) buildVariationImage;

  const VariationsTab({
    super.key,
    required this.variations,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.beginnerLabel,
    required this.intermediateLabel,
    required this.advancedLabel,
    required this.buildVariationImage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            SectionHeader(
              title: headerTitle,
              subtitle: headerSubtitle,
              icon: Icons.fitness_center,
              color: const Color(0xFFFFD43B),
            ),

            const SizedBox(height: 16),

            // 난이도별 변형 운동
            ..._buildVariationsByDifficulty(),

            const SizedBox(height: 80), // 광고 공간
          ],
        ),
      ),
    );
  }

  List<Widget> _buildVariationsByDifficulty() {
    final groupedVariations = <String, List<PushupVariation>>{};

    for (final variation in variations) {
      groupedVariations
          .putIfAbsent(variation.difficulty, () => [])
          .add(variation);
    }

    final difficulties = ['beginner', 'intermediate', 'advanced'];
    final difficultyNames = {
      'beginner': beginnerLabel,
      'intermediate': intermediateLabel,
      'advanced': advancedLabel,
    };

    return difficulties.expand((difficulty) {
      final variations = groupedVariations[difficulty] ?? [];
      if (variations.isEmpty) return <Widget>[];

      final difficultyColor = Color(
        PushupFormGuideService.getDifficultyColor(difficulty),
      );

      return [
        // 난이도 제목
        DifficultyHeader(
          difficultyName: difficultyNames[difficulty] ?? difficulty,
          color: difficultyColor,
        ),

        // 변형 운동들
        ...variations.map((variation) => VariationCard(
              variation: variation,
              buildVariationImage: buildVariationImage,
            )),

        const SizedBox(height: 20),
      ];
    }).toList();
  }
}
