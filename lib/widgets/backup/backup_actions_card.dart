import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';

/// 백업 액션 버튼 카드
class BackupActionsCard extends StatelessWidget {
  final bool isCreatingBackup;
  final bool isRestoringBackup;
  final VoidCallback onCreateBackup;
  final VoidCallback onCreateEncryptedBackup;
  final VoidCallback onExportBackup;
  final VoidCallback onRestoreBackup;

  const BackupActionsCard({
    super.key,
    required this.isCreatingBackup,
    required this.isRestoringBackup,
    required this.onCreateBackup,
    required this.onCreateEncryptedBackup,
    required this.onExportBackup,
    required this.onRestoreBackup,
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
              AppLocalizations.of(context).backupActions,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isCreatingBackup ? null : onCreateBackup,
                    icon: isCreatingBackup
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.backup),
                    label: Text(AppLocalizations.of(context).createBackup),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BCD4),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isCreatingBackup ? null : onCreateEncryptedBackup,
                    icon: const Icon(Icons.lock),
                    label: Text(AppLocalizations.of(context).encryptedBackup),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isCreatingBackup ? null : onExportBackup,
                    icon: const Icon(Icons.file_download),
                    label: Text(AppLocalizations.of(context).exportToFile),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isRestoringBackup ? null : onRestoreBackup,
                    icon: isRestoringBackup
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.restore),
                    label: Text(AppLocalizations.of(context).restoreBackup),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
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
}
