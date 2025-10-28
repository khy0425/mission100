import 'package:flutter/material.dart';

/// 리마인더 설정 카드
class ReminderSettingsCard extends StatelessWidget {
  final List<Widget> children;

  const ReminderSettingsCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7)! : theme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }
}
