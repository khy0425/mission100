import 'package:flutter/material.dart';

/// 저작권 푸터
class CopyrightFooter extends StatelessWidget {
  final String text;
  final bool isDark;

  const CopyrightFooter({
    super.key,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.black.withValues(alpha: 0.7)
              : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey : Colors.grey.withValues(alpha: 0.6),
          height: 1.5,
        ),
      ),
    );
  }
}
