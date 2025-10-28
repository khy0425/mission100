import 'package:flutter/material.dart';
import '../../models/pushup_form_guide.dart';
import 'section_header.dart';
import 'improvement_tip_card.dart';

/// 개선 팁 탭 위젯
class ImprovementTipsTab extends StatelessWidget {
  final List<ImprovementTip> tips;
  final String headerTitle;
  final String headerSubtitle;

  const ImprovementTipsTab({
    super.key,
    required this.tips,
    required this.headerTitle,
    required this.headerSubtitle,
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
              icon: Icons.tips_and_updates,
              color: const Color(0xFF51CF66),
            ),

            const SizedBox(height: 16),

            // 팁 목록
            ...List.generate(tips.length, (index) {
              final tip = tips[index];
              return ImprovementTipCard(
                tip: tip,
                isLast: index == tips.length - 1,
              );
            }),

            const SizedBox(height: 80), // 광고 공간
          ],
        ),
      ),
    );
  }
}
