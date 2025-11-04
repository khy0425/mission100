import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 부드러운 회원가입 유도 다이얼로그
///
/// 강압적이지 않고 자연스럽게 회원가입의 혜택을 안내합니다.
/// 한 번만 표시되며, 거부해도 앱 사용에 제한이 없습니다.
class GentleSignupPromptDialog extends StatelessWidget {
  final VoidCallback onSignUp;
  final VoidCallback? onDismiss;

  const GentleSignupPromptDialog({
    super.key,
    required this.onSignUp,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    Colors.purple.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_circle,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // 제목
            Text(
              l10n.keepDataSafe,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // 설명
            Text(
              l10n.signupBenefitsMessage,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // 혜택 목록
            _buildBenefitItem(
              Icons.cloud_done,
              l10n.autoBackup,
              l10n.dataRetainOnDeviceChange,
            ),

            const SizedBox(height: 12),

            _buildBenefitItem(
              Icons.devices,
              l10n.multiDeviceSync,
              l10n.continueAnywhere,
            ),

            const SizedBox(height: 12),

            _buildBenefitItem(
              Icons.flash_on,
              l10n.premiumBenefitFastLoading,
              l10n.fastAppStart,
            ),

            const SizedBox(height: 24),

            // 참고 문구
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.allFeaturesWithoutSignup,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 버튼들
            Row(
              children: [
                // 나중에 버튼
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDismiss?.call();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      l10n.later,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 회원가입 버튼
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSignUp();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.signupIn30Seconds,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
