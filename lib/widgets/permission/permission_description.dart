import 'package:flutter/material.dart';

/// 권한 화면 설명
class PermissionDescription extends StatelessWidget {
  final String text;

  const PermissionDescription({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}
