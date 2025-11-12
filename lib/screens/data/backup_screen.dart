import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/data/data_backup_service.dart';
import '../../services/data/backup_scheduler.dart';

/// 백업 관리 화면
/// 백업 생성, 복원, 설정 관리 기능을 제공
class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final DataBackupService _backupService = DataBackupService();
  final BackupScheduler _scheduler = BackupScheduler();

  BackupStatus? _backupStatus;
  bool _isLoading = false;
  bool _isCreatingBackup = false;
  bool _isRestoringBackup = false;

  @override
  void initState() {
    super.initState();
    _loadBackupStatus();
  }

  /// 백업 상태 로드
  Future<void> _loadBackupStatus() async {
    setState(() => _isLoading = true);

    try {
      final status = await _scheduler.getBackupStatus();
      setState(() => _backupStatus = status);
    } catch (e) {
      _showErrorSnackBar(
        AppLocalizations.of(context).backupStatusLoadFailed(e.toString()),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 수동 백업 생성
  Future<void> _createManualBackup() async {
    setState(() => _isCreatingBackup = true);

    try {
      final result = await _scheduler.performManualBackup();

      if (result.success) {
        _showSuccessSnackBar(
          AppLocalizations.of(context).backupCreatedSuccessfully,
        );
        await _loadBackupStatus();
      } else {
        _showErrorSnackBar(
          AppLocalizations.of(
            context,
          ).backupCreationFailed(result.error ?? ''),
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        AppLocalizations.of(context).backupCreationError(e.toString()),
      );
    } finally {
      setState(() => _isCreatingBackup = false);
    }
  }

  /// 암호화된 백업 생성
  Future<void> _createEncryptedBackup() async {
    final password = await _showPasswordDialog(AppLocalizations.of(context).backupEncryption);
    if (password == null || password.isEmpty) return;

    setState(() => _isCreatingBackup = true);

    try {
      final result = await _scheduler.performManualBackup(
        password: password,
        encrypt: true,
      );

      if (result.success) {
        _showSuccessSnackBar(
          AppLocalizations.of(context).encryptedBackupCreated,
        );
        await _loadBackupStatus();
      } else {
        _showErrorSnackBar(
          AppLocalizations.of(
            context,
          ).encryptedBackupFailed(result.error ?? ''),
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        AppLocalizations.of(context).encryptedBackupError(e.toString()),
      );
    } finally {
      setState(() => _isCreatingBackup = false);
    }
  }

  /// 백업 파일로 내보내기
  Future<void> _exportBackup() async {
    setState(() => _isCreatingBackup = true);

    try {
      final filePath = await _backupService.exportBackupToFile(
        context: context,
      );

      if (filePath != null) {
        _showSuccessSnackBar(
          AppLocalizations.of(context).backupFileSaved(filePath),
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        AppLocalizations.of(context).backupExportFailed(e.toString()),
      );
    } finally {
      setState(() => _isCreatingBackup = false);
    }
  }

  /// 백업 복원
  Future<void> _restoreBackup() async {
    setState(() => _isRestoringBackup = true);

    try {
      final context = this.context; // BuildContext를 미리 캡처
      final success = await _backupService.restoreFromBackup(context: context);

      if (success) {
        _showSuccessSnackBar(
          AppLocalizations.of(context).backupRestoredSuccessfully,
        );
        await _loadBackupStatus();
      } else {
        _showErrorSnackBar(AppLocalizations.of(context).backupRestoreFailed);
      }
    } catch (e) {
      _showErrorSnackBar(
        AppLocalizations.of(context).backupRestoreError(e.toString()),
      );
    } finally {
      if (mounted) setState(() => _isRestoringBackup = false);
    }
  }

  /// 자동 백업 설정 토글
  Future<void> _toggleAutoBackup(bool enabled) async {
    try {
      await _scheduler.updateBackupSettings(autoBackupEnabled: enabled);

      await _loadBackupStatus();

      final l10n = AppLocalizations.of(context);
      _showSuccessSnackBar(enabled ? l10n.backupAutoBackupEnabled : l10n.backupAutoBackupDisabled);
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context).backupSettingsChangeFailed(e.toString()));
    }
  }

  /// 백업 빈도 변경
  Future<void> _changeBackupFrequency() async {
    final frequency = await _showFrequencyDialog();
    if (frequency == null) return;

    try {
      await _scheduler.updateBackupSettings(frequency: frequency);
      await _loadBackupStatus();
      _showSuccessSnackBar(AppLocalizations.of(context).backupFrequencyChanged);
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context).backupSettingsChangeFailed(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).backupManagement),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadBackupStatus,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBackupContent(),
    );
  }

  Widget _buildBackupContent() {
    if (_backupStatus == null) {
      return Center(child: Text(AppLocalizations.of(context).errorLoadingData));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildBackupActions(),
          const SizedBox(height: 16),
          _buildSettingsCard(),
          const SizedBox(height: 16),
          _buildBackupHistory(),
        ],
      ),
    );
  }

  /// 백업 상태 카드
  Widget _buildStatusCard() {
    final status = _backupStatus!;

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
                  AppLocalizations.of(context).backupStatusLabel,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              AppLocalizations.of(context).status,
              status.statusText,
            ),
            if (status.lastBackupTime != null)
              _buildStatusRow(
                AppLocalizations.of(context).backupLastBackupLabel,
                _formatDateTime(status.lastBackupTime!),
              ),
            if (status.nextBackupTime != null)
              _buildStatusRow(AppLocalizations.of(context).backupNextBackupLabel, _formatDateTime(status.nextBackupTime!)),
            _buildStatusRow(AppLocalizations.of(context).backupFrequencyLabel, _getFrequencyText(status.frequency)),
            _buildStatusRow(
              AppLocalizations.of(context).encryption,
              status.encryptionEnabled
                  ? AppLocalizations.of(context).enabled
                  : AppLocalizations.of(context).disabled,
            ),
            if (status.failureCount > 0)
              _buildStatusRow(
                AppLocalizations.of(context).backupFailureCountLabel,
                AppLocalizations.of(context).backupFailureCountValue(status.failureCount),
                isError: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              color: isError ? Colors.red : null,
              fontWeight: isError ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }

  /// 백업 액션 버튼들
  Widget _buildBackupActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).backupActionsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isCreatingBackup ? null : _createManualBackup,
                    icon: _isCreatingBackup
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.backup),
                    label: Text(AppLocalizations.of(context).createBackup),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _isCreatingBackup ? null : _createEncryptedBackup,
                    icon: const Icon(Icons.lock),
                    label: Text(AppLocalizations.of(context).encryptedBackup),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
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
                    onPressed: _isCreatingBackup ? null : _exportBackup,
                    icon: const Icon(Icons.file_download),
                    label: Text(AppLocalizations.of(context).exportToFile),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRestoringBackup ? null : _restoreBackup,
                    icon: _isRestoringBackup
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.restore),
                    label: Text(AppLocalizations.of(context).restoreBackup),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
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

  /// 설정 카드
  Widget _buildSettingsCard() {
    final status = _backupStatus!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).backupSettingsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).autoBackup),
              subtitle: Text(
                AppLocalizations.of(context).autoBackupDescription,
              ),
              value: status.autoBackupEnabled,
              onChanged: _toggleAutoBackup,
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).backupFrequency),
              subtitle: Text(_getFrequencyText(status.frequency)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _changeBackupFrequency,
            ),
          ],
        ),
      ),
    );
  }

  /// 백업 히스토리 (간단한 버전)
  Widget _buildBackupHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).backupHistoryTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_backupStatus!.lastBackupTime != null)
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(AppLocalizations.of(context).lastBackup),
                subtitle: Text(_formatDateTime(_backupStatus!.lastBackupTime!)),
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

  /// 비밀번호 입력 다이얼로그
  Future<String?> _showPasswordDialog(String title) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).password,
            hintText: AppLocalizations.of(context).enterPasswordForEncryption,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(AppLocalizations.of(context).confirm),
          ),
        ],
      ),
    );
  }

  /// 확인 다이얼로그

  /// 백업 빈도 선택 다이얼로그
  Future<BackupFrequency?> _showFrequencyDialog() async {
    return showDialog<BackupFrequency>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).selectBackupFrequency),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: BackupFrequency.values.map((frequency) {
            return ListTile(
              title: Text(_getFrequencyText(frequency)),
              onTap: () => Navigator.pop(context, frequency),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 날짜 시간 포맷팅
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  /// 백업 빈도 텍스트
  String _getFrequencyText(BackupFrequency frequency) {
    final l10n = AppLocalizations.of(context);
    switch (frequency) {
      case BackupFrequency.daily:
        return l10n.frequencyDaily;
      case BackupFrequency.weekly:
        return l10n.frequencyWeekly;
      case BackupFrequency.monthly:
        return l10n.frequencyMonthly;
      case BackupFrequency.manual:
        return l10n.frequencyManual;
    }
  }

  /// 성공 스낵바
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  /// 오류 스낵바
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
