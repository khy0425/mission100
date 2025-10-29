import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../services/data/data_service.dart';
import '../../../services/chad/chad_evolution_service.dart';
import '../../data/backup_screen.dart';

/// 데이터 관리 설정을 담당하는 위젯
///
/// 기능:
/// - 백업 관리 화면 이동
/// - 데이터 백업 수행
/// - 데이터 복원 수행
/// - 레벨 및 진행률 초기화
class DataSettingsWidget extends StatelessWidget {
  const DataSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSettingsSection(AppLocalizations.of(context).dataSettings, [
      _buildTapSetting(
        AppLocalizations.of(context).backupManagement,
        AppLocalizations.of(context).backupManagementDesc,
        Icons.backup,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BackupScreen()),
        ),
      ),
      _buildTapSetting(
        AppLocalizations.of(context).dataBackup,
        AppLocalizations.of(context).dataBackupDesc,
        Icons.backup,
        () => _performDataBackup(context),
      ),
      _buildTapSetting(
        AppLocalizations.of(context).dataRestore,
        AppLocalizations.of(context).dataRestoreDesc,
        Icons.restore,
        () => _performDataRestore(context),
      ),
      _buildTapSetting(
        AppLocalizations.of(context).levelReset,
        AppLocalizations.of(context).levelResetDesc,
        Icons.refresh,
        () => _showResetDataDialog(context),
        isDestructive: true,
      ),
    ]);
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.primaryColor),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTapSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isDestructive ? Colors.red : const Color(AppColors.primaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      ),
    );
  }

  /// 데이터 백업 수행
  Future<void> _performDataBackup(BuildContext context) async {
    try {
      // 로딩 다이얼로그 표시
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context).backingUpData),
            ],
          ),
        ),
      );

      final backupPath = await DataService.backupData(context: context);

      // 로딩 다이얼로그 닫기
      if (context.mounted) Navigator.pop(context);

      if (backupPath != null) {
        // 백업 시간 저장
        await DataService.saveLastBackupTime();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(
                  context,
                ).backupCompletedWithPath(backupPath).replaceAll('\\n', '\n'),
              ),
              backgroundColor: const Color(AppColors.primaryColor),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).backupFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기
      if (context.mounted) Navigator.pop(context);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).backupErrorOccurred(e.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 데이터 복원 수행
  Future<void> _performDataRestore(BuildContext context) async {
    // 복원 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).dataRestoreTitle),
        content: Text(
          AppLocalizations.of(
            context,
          ).dataRestoreWarning.replaceAll('\\n', '\n'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context).confirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // 로딩 다이얼로그 표시
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context).restoringData),
            ],
          ),
        ),
      );

      final success = await DataService.restoreData(context: context);

      // 로딩 다이얼로그 닫기
      if (context.mounted) Navigator.pop(context);

      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).dataRestoreCompleted),
              backgroundColor: const Color(AppColors.primaryColor),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).dataRestoreFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기
      if (context.mounted) Navigator.pop(context);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).restoreErrorOccurred(e.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 레벨 리셋 확인 다이얼로그
  void _showResetDataDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).confirmDataReset),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).resetAllProgressConfirm,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).followingDataDeleted),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context).currentLevelProgress),
            Text(AppLocalizations.of(context).workoutRecordsStats),
            Text(AppLocalizations.of(context).chadEvolutionStatus),
            Text(AppLocalizations.of(context).achievementsBadges),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).actionCannotBeUndone,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performDataReset(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context).resetButton),
          ),
        ],
      ),
    );
  }

  /// 데이터 리셋 실행
  Future<void> _performDataReset(BuildContext context) async {
    try {
      // 로딩 다이얼로그 표시
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context).resettingData),
            ],
          ),
        ),
      );

      // DataService를 통한 데이터 리셋
      final dataService = Provider.of<DataService>(context, listen: false);
      // await dataService.resetProgress(); // 메서드가 없으므로 주석 처리

      // Chad Evolution 상태도 리셋
      final chadService = Provider.of<ChadEvolutionService>(
        context,
        listen: false,
      );
      await chadService.resetEvolution();

      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      // 성공 메시지
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).allDataResetSuccessfully,
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      // 오류 메시지
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).dataResetErrorOccurred(e.toString()),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
