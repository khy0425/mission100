import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 주의사항 아이템
class WarningItem extends StatelessWidget {
  final String text;

  const WarningItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Row(
        children: [
          Icon(Icons.close, color: Colors.red, size: 20),
          const SizedBox(width: AppConstants.paddingS),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.red[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
