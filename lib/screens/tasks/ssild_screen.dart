import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// SSILD (Senses Initiated Lucid Dream) 기법 화면
class SSILDScreen extends StatefulWidget {
  const SSILDScreen({super.key});

  @override
  State<SSILDScreen> createState() => _SSILDScreenState();
}

class _SSILDScreenState extends State<SSILDScreen> {
  int _cycleCount = 0;
  int _currentStep = 0; // 0: 시각, 1: 청각, 2: 신체
  bool _isCompleting = false;

  void _nextStep() {
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      } else {
        _currentStep = 0;
        _cycleCount++;
      }
    });
  }

  Future<void> _completeTask() async {
    if (_isCompleting) return;

    if (_cycleCount < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).ssildMinCycles),
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
      await taskService.toggleTask(LucidDreamTaskType.meditation, true); // Using meditation as proxy

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).ssildCompleted,
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
      if (mounted) {
        setState(() => _isCompleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final steps = [
      {'icon': '👁️', 'title': l10n.ssildStep1Title, 'desc': l10n.ssildStep1Description},
      {'icon': '👂', 'title': l10n.ssildStep2Title, 'desc': l10n.ssildStep2Description},
      {'icon': '🤲', 'title': l10n.ssildStep3Title, 'desc': l10n.ssildStep3Description},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ssildTitle),
        backgroundColor: const Color(0xFF7B1FA2),
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
                    const Color(0xFF7B1FA2).withOpacity(0.1),
                    const Color(0xFF512DA8).withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text('🧘', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.ssildGuideTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.ssildGuideDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // 사이클 카운터
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.loop, color: _cycleCount >= 4 ? Colors.green : Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    l10n.ssildCycleCount(_cycleCount),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _cycleCount >= 4 ? Colors.green : null,
                    ),
                  ),
                ],
              ),
            ),

            // 현재 단계 표시
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 단계 인디케이터
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isActive = index == _currentStep;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: isActive ? 16 : 12,
                          height: isActive ? 16 : 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? const Color(0xFF7B1FA2) : Colors.grey[300],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),

                    // 현재 단계 카드
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B1FA2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF7B1FA2).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(steps[_currentStep]['icon']!, style: const TextStyle(fontSize: 64)),
                          const SizedBox(height: 16),
                          Text(
                            steps[_currentStep]['title']!,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            steps[_currentStep]['desc']!,
                            style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 다음 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _nextStep,
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(_currentStep < 2 ? '다음 감각' : '사이클 완료'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 팁
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.purple),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.ssildTip, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),

            // 완료 버튼
            if (_cycleCount >= 4)
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
