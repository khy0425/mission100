import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';

/// 꿈 일기 목록 빈 상태 위젯
///
/// 필터 모드에 따라 다른 메시지 표시 (전체/자각몽/즐겨찾기)
class DreamListEmptyWidget extends StatelessWidget {
  final String filterMode;
  final VoidCallback onCreateNew;

  const DreamListEmptyWidget({
    super.key,
    required this.filterMode,
    required this.onCreateNew,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String message;
    IconData icon;

    if (filterMode == 'lucid') {
      message = l10n.emptyLucidDreams;
      icon = Icons.star_border;
    } else if (filterMode == 'favorite') {
      message = l10n.emptyFavorites;
      icon = Icons.star_border;
    } else {
      message = l10n.emptyAllDreams;
      icon = Icons.auto_stories_outlined;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      icon,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstants.paddingL),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeL,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppConstants.paddingXL),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: ElevatedButton.icon(
                  onPressed: onCreateNew,
                  icon: const Icon(Icons.add, size: 24),
                  label: Text(
                    l10n.writeFirstDream,
                    style: const TextStyle(fontSize: AppConstants.fontSizeL),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingXL,
                      vertical: AppConstants.paddingL,
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
