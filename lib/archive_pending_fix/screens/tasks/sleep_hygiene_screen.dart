import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// 수면 위생 체크리스트 화면
///
/// 좋은 수면을 위한 체크리스트 제공
class SleepHygieneScreen extends StatefulWidget {
  const SleepHygieneScreen({super.key});

  @override
  State<SleepHygieneScreen> createState() => _SleepHygieneScreenState();
}

class _SleepHygieneScreenState extends State<SleepHygieneScreen> {
  final Set<int> _checkedItems = {};
  bool _isCompleting = false;

  // 수면 위생 체크리스트 항목
  final List<String> _itemKeys = [
    'sleepHygiene1',
    'sleepHygiene2',
    'sleepHygiene3',
    'sleepHygiene4',
    'sleepHygiene5',
    'sleepHygiene6',
  ];

  Future<void> _completeTask() async {
    if (_isCompleting) return;

    if (_checkedItems.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).sleepHygieneCheckAtLeast3),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCompleting = true;
    });

    try {
      final taskService = Provider.of<DailyTaskService>(context, listen: false);
      await taskService.toggleTask(LucidDreamTaskType.sleepHygiene, true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).sleepHygieneCompleted,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류 발생: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  String _getItemText(String key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'sleepHygiene1':
        return l10n.sleepHygiene1;
      case 'sleepHygiene2':
        return l10n.sleepHygiene2;
      case 'sleepHygiene3':
        return l10n.sleepHygiene3;
      case 'sleepHygiene4':
        return l10n.sleepHygiene4;
      case 'sleepHygiene5':
        return l10n.sleepHygiene5;
      case 'sleepHygiene6':
        return l10n.sleepHygiene6;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sleepHygieneTitle),
        backgroundColor: const Color(0xFF673AB7),
      ),
      body: SafeArea(
        bottom: true, // 시스템 네비게이션 버튼 영역 확보
        child: Column(
          children: [
          // 안내 배너
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF673AB7).withOpacity(0.1),
                  const Color(0xFF512DA8).withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '😴',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.sleepHygieneGuideTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.sleepHygieneGuideDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // 체크리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 180), // 하단 버튼 공간 확보
              itemCount: _itemKeys.length,
              itemBuilder: (context, index) {
                final isChecked = _checkedItems.contains(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isChecked) {
                          _checkedItems.remove(index);
                        } else {
                          _checkedItems.add(index);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isChecked
                            ? Colors.green.withOpacity(0.1)
                            : theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isChecked ? Colors.green : theme.dividerColor,
                          width: isChecked ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isChecked
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: isChecked ? Colors.green : theme.dividerColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getItemText(_itemKeys[index]),
                              style: TextStyle(
                                fontSize: 15,
                                decoration: isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isChecked
                                    ? theme.colorScheme.onSurface
                                        .withOpacity(0.6)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 진행 상황 및 완료 버튼
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // 진행 상황
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checklist,
                      color: _checkedItems.length >= 3
                          ? Colors.green
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_checkedItems.length} / ${_itemKeys.length} ${l10n.sleepHygieneCompleted}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _checkedItems.length >= 3
                            ? Colors.green
                            : null,
                      ),
                    ),
                  ],
                ),
                if (_checkedItems.length < 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      l10n.sleepHygieneCheckAtLeast3,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                // 완료 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkedItems.length >= 3 && !_isCompleting
                        ? _completeTask
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isCompleting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                l10n.completeTask,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 배너 광고 (네비게이션 바 회피)
          Consumer<AuthService>(
            builder: (context, authService, child) {
              return const AdBannerWidget(
                margin: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
              );
            },
          ),

          // 네비게이션 바를 위한 추가 공간 확보
          const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
