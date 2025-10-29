import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../generated/app_localizations.dart';
import '../../services/data/backup_scheduler.dart';
import '../../services/data/data_backup_service.dart';
import 'backup_status_row.dart';

/// 백업 상태 카드
class BackupStatusCard extends StatelessWidget {
  final BackupStatus status;
  final String Function(BackupFrequency) getFrequencyText;

  const BackupStatusCard({
    super.key,
    required this.status,
    required this.getFrequencyText,
  });

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  status.autoBackupEnabled
                      ? Icons.backup
                      : Icons.backup_outlined,
                  color: status.autoBackupEnabled ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).backupStatus,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BackupStatusRow(
              label: AppLocalizations.of(context).status,
              value: status.statusText,
            ),
            if (status.lastBackupTime != null)
              BackupStatusRow(
                label: AppLocalizations.of(context).lastBackup,
                value: _formatDateTime(status.lastBackupTime!),
              ),
            if (status.nextBackupTime != null)
              BackupStatusRow(
                label: AppLocalizations.of(context).nextBackup,
                value: _formatDateTime(status.nextBackupTime!),
              ),
            BackupStatusRow(
              label: AppLocalizations.of(context).backupFrequency,
              value: getFrequencyText(status.frequency),
            ),
            BackupStatusRow(
              label: AppLocalizations.of(context).encryption,
              value: status.encryptionEnabled
                  ? AppLocalizations.of(context).enabled
                  : AppLocalizations.of(context).disabled,
            ),
            if (status.failureCount > 0)
              BackupStatusRow(
                label: AppLocalizations.of(context).failureCount,
                value: '${status.failureCount}${AppLocalizations.of(context).times}',
                isError: true,
              ),
          ],
        ),
      ),
    );
  }
}
