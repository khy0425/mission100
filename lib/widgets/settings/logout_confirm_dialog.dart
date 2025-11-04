import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 로그아웃 확인 다이얼로그
class LogoutConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmDialog({
    super.key,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => LogoutConfirmDialog(
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.logout),
      content: Text(l10n.logoutConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: Text(l10n.logout),
        ),
      ],
    );
  }
}
