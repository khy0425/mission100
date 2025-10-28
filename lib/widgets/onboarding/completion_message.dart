import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// 목표 설정 완료 메시지
class CompletionMessage extends StatelessWidget {
  const CompletionMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
        ),
      ),
      child: const Column(
        children: [
          Text(
            '🎉 목표 설정 완료!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.primaryColor),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '이제 당신만의 맞춤형 Mission: 100이 시작됩니다.\n런칭 이벤트로 1개월 무료 체험해보세요!',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
