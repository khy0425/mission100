import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import 'settings_card_widget.dart';

/// 데이터 관리 섹션 위젯
///
/// 백업, 복원, 리셋 기능
class DataManagementSection extends StatelessWidget {
  final Function(String) showSnackBar;

  const DataManagementSection({
    super.key,
    required this.showSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsCardWidget(
      children: [
        ListTile(
          leading: const Icon(Icons.backup),
          title: Text(l10n.dataBackup),
          subtitle: Text(l10n.backupWorkoutRecords),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            showSnackBar(l10n.dataBackupComingSoon);
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.restore),
          title: Text(l10n.dataRestore),
          subtitle: Text(l10n.restoreBackupData),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            showSnackBar(l10n.dataRestoreComingSoon);
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: Text(
            l10n.dataReset,
            style: const TextStyle(color: Colors.red),
          ),
          subtitle: Text(l10n.deleteAllWorkoutRecords),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            showSnackBar(l10n.dataResetComingSoon);
          },
        ),
      ],
    );
  }
}
