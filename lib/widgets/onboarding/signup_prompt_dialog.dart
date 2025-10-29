import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 회원가입 안내 다이얼로그
class SignupPromptDialog extends StatelessWidget {
  final String goalText;
  final VoidCallback onSkip;
  final VoidCallback onSignup;

  const SignupPromptDialog({
    super.key,
    required this.goalText,
    required this.onSkip,
    required this.onSignup,
  });

  static void show(
    BuildContext context, {
    required String goalText,
    required VoidCallback onSkip,
    required VoidCallback onSignup,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SignupPromptDialog(
        goalText: goalText,
        onSkip: onSkip,
        onSignup: onSignup,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.stars, color: Color(AppColors.primaryColor)),
          SizedBox(width: 8),
          Text('맞춤형 프로그램 준비완료!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$goalText를 위한 개인화된 프로그램이 준비되었습니다!',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('🎁 런칭 이벤트 혜택:'),
          const Text('• 1개월 무료 프리미엄'),
          const Text('• 개인화된 운동 계획'),
          const Text('• 진행상황 클라우드 백업'),
          const Text('• 상세한 체성분 분석'),
          const SizedBox(height: 16),
          const Text(
            '지금 가입하고 목표를 달성해보세요! 💪',
            style: TextStyle(
              color: Color(AppColors.primaryColor),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onSkip,
          child: const Text('나중에'),
        ),
        ElevatedButton(
          onPressed: onSignup,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(AppColors.primaryColor),
            foregroundColor: Colors.white,
          ),
          child: const Text('무료로 시작하기'),
        ),
      ],
    );
  }
}
