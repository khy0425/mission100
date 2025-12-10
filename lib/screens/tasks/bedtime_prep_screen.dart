import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// 취침 전 준비 화면
class BedtimePrepScreen extends StatefulWidget {
  const BedtimePrepScreen({super.key});

  @override
  State<BedtimePrepScreen> createState() => _BedtimePrepScreenState();
}

class _BedtimePrepScreenState extends State<BedtimePrepScreen> {
  final Set<int> _checkedItems = {};
  bool _isCompleting = false;

  Future<void> _completeTask() async {
    if (_isCompleting) return;

    if (_checkedItems.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).bedtimePrepCheckAtLeast3),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isCompleting = true);

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
                    AppLocalizations.of(context).bedtimePrepCompleted,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final items = [
      {'icon': '📔', 'text': l10n.bedtimePrepItem1},
      {'icon': '🎯', 'text': l10n.bedtimePrepItem2},
      {'icon': '📱', 'text': l10n.bedtimePrepItem3},
      {'icon': '🛏️', 'text': l10n.bedtimePrepItem4},
      {'icon': '🧠', 'text': l10n.bedtimePrepItem5},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bedtimePrepTitle),
        backgroundColor: const Color(0xFF5E35B1),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 안내 배너
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF5E35B1).withOpacity(0.1),
                    const Color(0xFF4527A0).withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text('🌙', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.bedtimePrepGuideTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.bedtimePrepGuideDescription,
                    style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // 체크리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
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
                          color: isChecked ? Colors.green.withOpacity(0.1) : theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isChecked ? Colors.green : theme.dividerColor,
                            width: isChecked ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                              color: isChecked ? Colors.green : theme.dividerColor,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(item['icon']!, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item['text']!,
                                style: TextStyle(
                                  fontSize: 15,
                                  decoration: isChecked ? TextDecoration.lineThrough : null,
                                  color: isChecked
                                      ? theme.colorScheme.onSurface.withOpacity(0.6)
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

            // 진행 상황
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.checklist,
                        color: _checkedItems.length >= 3 ? Colors.green : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_checkedItems.length} / ${items.length}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _checkedItems.length >= 3 ? Colors.green : null,
                        ),
                      ),
                    ],
                  ),
                  if (_checkedItems.length < 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        l10n.bedtimePrepCheckAtLeast3,
                        style: TextStyle(fontSize: 13, color: Colors.orange.shade700),
                      ),
                    ),
                ],
              ),
            ),

            // 완료 버튼
            if (_checkedItems.length >= 3)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: _isCompleting ? null : _completeTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isCompleting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, size: 24),
                            const SizedBox(width: 8),
                            Text(l10n.completeTask, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                ),
              ),

            Consumer<AuthService>(
              builder: (context, authService, child) => const AdBannerWidget(margin: EdgeInsets.only(top: 8, bottom: 8)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
