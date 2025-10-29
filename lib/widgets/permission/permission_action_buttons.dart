import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 권한 화면 액션 버튼들
class PermissionActionButtons extends StatelessWidget {
  final bool isRequesting;
  final bool hasRequestedBefore;
  final VoidCallback onRequestPermissions;
  final VoidCallback onSkip;
  final String allowText;
  final String skipText;

  const PermissionActionButtons({
    super.key,
    required this.isRequesting,
    required this.hasRequestedBefore,
    required this.onRequestPermissions,
    required this.onSkip,
    required this.allowText,
    required this.skipText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isRequesting ? null : onRequestPermissions,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppColors.primaryColor),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              elevation: 4,
            ),
            child: isRequesting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    allowText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: isRequesting ? null : onSkip,
          child: Text(
            skipText,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
