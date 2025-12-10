import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// 자각몽 안정화 훈련 화면
class StabilizationScreen extends StatefulWidget {
  const StabilizationScreen({super.key});

  @override
  State<StabilizationScreen> createState() => _StabilizationScreenState();
}

class _StabilizationScreenState extends State<StabilizationScreen> {
  final Set<int> _learnedTechs = {};
  bool _isCompleting = false;

  Future<void> _completeTask() async {
    if (_isCompleting) return;

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
                    AppLocalizations.of(context).stabilizationCompleted,
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

    final techniques = [
      {'icon': '🤲', 'title': l10n.stabilizationTech1, 'desc': l10n.stabilizationTech1Desc},
      {'icon': '🌀', 'title': l10n.stabilizationTech2, 'desc': l10n.stabilizationTech2Desc},
      {'icon': '👁️', 'title': l10n.stabilizationTech3, 'desc': l10n.stabilizationTech3Desc},
      {'icon': '📢', 'title': l10n.stabilizationTech4, 'desc': l10n.stabilizationTech4Desc},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stabilizationTitle),
        backgroundColor: const Color(0xFF00695C),
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
                    const Color(0xFF00695C).withOpacity(0.1),
                    const Color(0xFF004D40).withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text('⚖️', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.stabilizationGuideTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.stabilizationGuideDescription,
                    style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // 진행 상황
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, color: _learnedTechs.length >= 2 ? Colors.green : Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    l10n.stabilizationLearnCount(_learnedTechs.length),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _learnedTechs.length >= 2 ? Colors.green : null,
                    ),
                  ),
                ],
              ),
            ),

            // 기법 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: techniques.length,
                itemBuilder: (context, index) {
                  final tech = techniques[index];
                  final isLearned = _learnedTechs.contains(index);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isLearned) {
                            _learnedTechs.remove(index);
                          } else {
                            _learnedTechs.add(index);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isLearned ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isLearned ? Colors.green : Colors.grey.shade300,
                            width: isLearned ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isLearned
                                    ? Colors.green.withOpacity(0.2)
                                    : const Color(0xFF00695C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(tech['icon']!, style: const TextStyle(fontSize: 32)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tech['title']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isLearned ? Colors.green[700] : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tech['desc']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isLearned ? Icons.check_circle : Icons.circle_outlined,
                              color: isLearned ? Colors.green : Colors.grey,
                              size: 28,
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
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.teal),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.stabilizationTip, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),

            // 완료 버튼
            if (_learnedTechs.length >= 2)
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
