import 'package:flutter/material.dart';

/// 진행률 추적 오류 위젯
class ProgressErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final String retryButtonText;

  const ProgressErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    required this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Color(0xFFFF6B6B)),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xFFFF6B6B)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4DABF7),
              foregroundColor: Colors.white,
            ),
            child: Text(retryButtonText),
          ),
        ],
      ),
    );
  }
}
