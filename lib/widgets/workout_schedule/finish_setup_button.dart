import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';

/// 설정 완료 버튼
class FinishSetupButton extends StatelessWidget{
  final int selectedDaysCount;
  final VoidCallback onFinish;

  const FinishSetupButton({
    super.key,
    required this.selectedDaysCount,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedDaysCount >= 3 ? onFinish : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedDaysCount >= 3
              ? const Color(AppColors.primaryColor)
              : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: selectedDaysCount >= 3 ? 4 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              color: selectedDaysCount >= 3 ? Colors.black : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).startJourney,
              style: TextStyle(
                color:
                    selectedDaysCount >= 3 ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
