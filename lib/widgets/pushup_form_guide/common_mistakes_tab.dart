import 'package:flutter/material.dart';
import '../../models/pushup_form_guide.dart';
import 'section_header.dart';
import 'common_mistake_card.dart';

/// 흔한 실수 탭 위젯
class CommonMistakesTab extends StatelessWidget {
  final List<CommonMistake> mistakes;
  final String headerTitle;
  final String headerSubtitle;
  final Widget Function(String, Color, IconData, String, String)
      buildComparisonImage;

  const CommonMistakesTab({
    super.key,
    required this.mistakes,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.buildComparisonImage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 헤더
            SectionHeader(
              title: headerTitle,
              subtitle: headerSubtitle,
              icon: Icons.warning,
              color: const Color(0xFFFF6B6B),
            ),

            const SizedBox(height: 16),

            // 실수 목록
            ...List.generate(mistakes.length, (index) {
              final mistake = mistakes[index];
              return CommonMistakeCard(
                mistake: mistake,
                isLast: index == mistakes.length - 1,
                buildComparisonImage: buildComparisonImage,
              );
            }),

            const SizedBox(height: 80), // 광고 공간
          ],
        ),
      ),
    );
  }
}
