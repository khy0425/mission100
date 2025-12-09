import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 꿈 일기 목록 로딩 상태 위젯
///
/// 애니메이션 효과가 있는 로딩 화면
class DreamListLoadingWidget extends StatelessWidget {
  const DreamListLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppConstants.paddingL),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: const Text(
                  '꿈 일기를 불러오는 중...',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeM,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
