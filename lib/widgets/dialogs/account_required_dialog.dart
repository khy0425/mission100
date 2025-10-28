import 'package:flutter/material.dart';

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
                gradient: const LinearGradient(
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
            const Text(
              '간단한 계정 생성이 필요합니다',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 설명
            Text(
              '구매하신 $productName을(를) 안전하게\n관리하고 모든 기기에서 사용하려면\n계정이 필요합니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 혜택 리스트
            _buildBenefitItem(Icons.cloud_done, '클라우드 동기화'),
            const SizedBox(height: 12),
            _buildBenefitItem(Icons.devices, '여러 기기에서 사용'),
            const SizedBox(height: 12),
            _buildBenefitItem(Icons.backup, '데이터 백업 & 복원'),
            const SizedBox(height: 12),
            _buildBenefitItem(Icons.lock, '구매 내역 보호'),
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
                    child: const Text('나중에'),
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
                    child: const Text(
                      '계정 만들기',
                      style: TextStyle(
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
              '30초면 완료됩니다',
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
