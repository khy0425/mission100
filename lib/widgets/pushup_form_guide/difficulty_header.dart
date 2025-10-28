import 'package:flutter/material.dart';

/// 난이도 헤더 위젯
class DifficultyHeader extends StatelessWidget {
  final String difficultyName;
  final Color color;

  const DifficultyHeader({
    super.key,
    required this.difficultyName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.star, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            difficultyName,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
