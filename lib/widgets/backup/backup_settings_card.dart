import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import '../../services/backup_scheduler.dart';
import '../../services/data_backup_service.dart';

/// 백업 설정 카드
class BackupSettingsCard extends StatelessWidget {
  final BackupStatus status;
  final Function(bool) onToggleAutoBackup;
  final VoidCallback onChangeFrequency;
  final String Function(BackupFrequency) getFrequencyText;

  const BackupSettingsCard({
    super.key,
    required this.status,
    required this.onToggleAutoBackup,
    required this.onChangeFrequency,
    required this.getFrequencyText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).backupSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).autoBackup),
              subtitle: Text(
                AppLocalizations.of(context).autoBackupDescription,
              ),
              value: status.autoBackupEnabled,
              onChanged: onToggleAutoBackup,
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).backupFrequency),
              subtitle: Text(getFrequencyText(status.frequency)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: onChangeFrequency,
            ),
          ],
        ),
      ),
    );
  }
}
