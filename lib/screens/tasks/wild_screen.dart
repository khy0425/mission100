import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// WILD (Wake Initiated Lucid Dream) 기법 화면
class WILDScreen extends StatefulWidget {
  const WILDScreen({super.key});

  @override
  State<WILDScreen> createState() => _WILDScreenState();
}

class _WILDScreenState extends State<WILDScreen> {
  final Set<int> _completedSteps = {};
  bool _isCompleting = false;

  Future<void> _completeTask() async {
    if (_isCompleting) return;

    if (_completedSteps.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).wildCompleteAllSteps),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isCompleting = true);

    try {
      final taskService = Provider.of<DailyTaskService>(context, listen: false);
      await taskService.toggleTask(LucidDreamTaskType.meditation, true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).wildCompleted,
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

    final steps = [
      {'icon': '🛏️', 'title': l10n.wildStep1Title, 'desc': l10n.wildStep1Description},
      {'icon': '🌀', 'title': l10n.wildStep2Title, 'desc': l10n.wildStep2Description},
      {'icon': '🚪', 'title': l10n.wildStep3Title, 'desc': l10n.wildStep3Description},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wildTitle),
        backgroundColor: const Color(0xFF1565C0),
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
                    const Color(0xFF1565C0).withOpacity(0.1),
                    const Color(0xFF0D47A1).withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text('🌊', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.wildGuideTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.wildGuideDescription,
                    style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // 단계 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  final isCompleted = _completedSteps.contains(index);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isCompleted) {
                            _completedSteps.remove(index);
                          } else {
                            _completedSteps.add(index);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCompleted ? Colors.green : Colors.grey.shade300,
                            width: isCompleted ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Colors.green
                                    : const Color(0xFF1565C0).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: isCompleted
                                    ? const Icon(Icons.check, color: Colors.white)
                                    : Text('${index + 1}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(step['icon']!, style: const TextStyle(fontSize: 24)),
                                      const SizedBox(width: 8),
                                      Text(step['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    step['desc']!,
                                    style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                  ),
                                ],
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

            // 팁
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.wildTip, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),

            // 완료 버튼
            if (_completedSteps.length >= 3)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
