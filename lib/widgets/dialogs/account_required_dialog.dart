import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';

/// 구매 시 회원가입 유도 다이얼로그
class AccountRequiredDialog extends StatelessWidget {
  final String productName;
  final VoidCallback onSignUp;
  final VoidCallback? onCancel;

  const AccountRequiredDialog({
    Key? key,
    required this.productName,
    required this.onSignUp,
    this.onCancel,
  }) : super(key: key);

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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_circle,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // 제목
            Text(
              l10n.accountCreationRequired,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 설명
            Text(
              l10n.purchaseProtectionMessage(productName),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 혜택 리스트
            _buildBenefitItem(Icons.cloud_done, l10n.cloudSync),
            const SizedBox(height: 12),
            _buildBenefitItem(Icons.devices, l10n.multiDeviceAccess),
            const SizedBox(height: 12),
            _buildBenefitItem(Icons.backup, l10n.dataBackupRestore),
            const SizedBox(height: 12),
            _buildBenefitItem(Icons.lock, l10n.purchaseHistoryProtection),
            const SizedBox(height: 24),

            // 버튼들
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCancel != null) onCancel!();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(l10n.later),
                  ),
                ),
                const SizedBox(width: 12),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.createAccount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 안내 문구
            Text(
              l10n.completesIn30Seconds,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// 간편 사용을 위한 헬퍼 함수
Future<bool?> showAccountRequiredDialog(
  BuildContext context, {
  required String productName,
  required VoidCallback onSignUp,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AccountRequiredDialog(
      productName: productName,
      onSignUp: onSignUp,
      onCancel: () {},
    ),
  );
}
