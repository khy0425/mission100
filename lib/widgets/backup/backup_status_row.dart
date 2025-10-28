import 'package:flutter/material.dart';

/// 백업 상태 행 위젯
class BackupStatusRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isError;

  const BackupStatusRow({
    super.key,
    required this.label,
    required this.value,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              color: isError ? Colors.red : null,
              fontWeight: isError ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
