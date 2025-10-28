import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// 로딩 상태 화면
class LoadingView extends StatelessWidget {
  final String loadingText;
  final double imageSize;

  const LoadingView({
    super.key,
    required this.loadingText,
    this.imageSize = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  Color(AppColors.chadGradient[0]),
                  Color(AppColors.chadGradient[1]),
                ]
              : [theme.colorScheme.surface, const Color(0xFFF5F5F5)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(imageSize / 2),
            ),
            child: Icon(
              Icons.fitness_center,
              size: imageSize / 2,
              color: const Color(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          Text(
            loadingText,
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
