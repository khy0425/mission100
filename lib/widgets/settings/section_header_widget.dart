import 'package:flutter/material.dart';

/// 설정 섹션 헤더 위젯
///
/// 아이콘과 제목으로 구성된 섹션 구분자
class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.blue.withValues(alpha: 0.3), Colors.blue.withValues(alpha: 0.15)]
                  : [Colors.blue.withValues(alpha: 0.15), Colors.blue.withValues(alpha: 0.08)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: isDark ? 0.2 : 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.blue[300] : Colors.blue[600],
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
