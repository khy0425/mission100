import 'package:flutter/material.dart';
import 'legend_item.dart';

/// 범례 카드
class LegendCard extends StatelessWidget {
  final String legendTitle;
  final String perfectLabel;
  final String goodLabel;
  final String okayLabel;
  final String poorLabel;

  const LegendCard({
    super.key,
    required this.legendTitle,
    required this.perfectLabel,
    required this.goodLabel,
    required this.okayLabel,
    required this.poorLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              legendTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LegendItem(color: Colors.green.shade400, label: perfectLabel),
                LegendItem(color: Colors.blue.shade400, label: goodLabel),
                LegendItem(color: Colors.orange.shade400, label: okayLabel),
                LegendItem(color: Colors.red.shade400, label: poorLabel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
