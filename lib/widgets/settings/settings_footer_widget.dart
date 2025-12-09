import 'package:flutter/material.dart';

/// 설정 화면 하단 푸터 위젯
///
/// 저작권 정보 표시
class SettingsFooterWidget extends StatelessWidget {
  final String copyrightText;

  const SettingsFooterWidget({
    super.key,
    required this.copyrightText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]!.withValues(alpha: 0.3)
            : Colors.grey[50]!.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.grey[700]!.withValues(alpha: 0.2)
              : Colors.grey[300]!.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        copyrightText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          height: 1.6,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
