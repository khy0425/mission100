import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../generated/l10n/app_localizations.dart';

/// 백업 히스토리 카드
class BackupHistoryCard extends StatelessWidget {
  final DateTime? lastBackupTime;

  const BackupHistoryCard({
    super.key,
    required this.lastBackupTime,
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
            Text(
              AppLocalizations.of(context).backupHistory,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (lastBackupTime != null)
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(AppLocalizations.of(context).lastBackup),
                subtitle: Text(_formatDateTime(lastBackupTime!)),
                trailing: Text(
                  AppLocalizations.of(context).success,
                ),
              )
            else
              ListTile(
                leading: const Icon(Icons.info, color: Colors.grey),
                title: Text(AppLocalizations.of(context).noBackupRecord),
                subtitle: Text(AppLocalizations.of(context).noBackupCreated),
              ),
          ],
        ),
      ),
    );
  }
}
