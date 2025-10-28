import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// 권한 화면 타이틀
class PermissionTitle extends StatelessWidget {
  final String text;

  const PermissionTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: const Color(AppColors.primaryColor),
      ),
      textAlign: TextAlign.center,
    );
  }
}
