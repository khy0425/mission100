import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// 꿈 조종 연습 화면
class DreamControlScreen extends StatefulWidget {
  const DreamControlScreen({super.key});

  @override
  State<DreamControlScreen> createState() => _DreamControlScreenState();
}

class _DreamControlScreenState extends State<DreamControlScreen> {
  final Set<int> _learnedSkills = {};
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
                    AppLocalizations.of(context).dreamControlCompleted,
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

    final skills = [
      {'icon': '🦅', 'title': l10n.dreamControlSkill1, 'desc': l10n.dreamControlSkill1Desc, 'color': Colors.blue},
      {'icon': '✨', 'title': l10n.dreamControlSkill2, 'desc': l10n.dreamControlSkill2Desc, 'color': Colors.amber},
      {'icon': '🚪', 'title': l10n.dreamControlSkill3, 'desc': l10n.dreamControlSkill3Desc, 'color': Colors.purple},
      {'icon': '💬', 'title': l10n.dreamControlSkill4, 'desc': l10n.dreamControlSkill4Desc, 'color': Colors.green},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dreamControlTitle),
        backgroundColor: const Color(0xFFE65100),
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
                    const Color(0xFFE65100).withOpacity(0.1),
                    const Color(0xFFBF360C).withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text('🎮', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.dreamControlGuideTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.dreamControlGuideDescription,
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
                  Icon(Icons.school, color: _learnedSkills.length >= 2 ? Colors.green : Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    l10n.dreamControlPracticeCount(_learnedSkills.length),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _learnedSkills.length >= 2 ? Colors.green : null,
                    ),
                  ),
                ],
              ),
            ),

            // 스킬 그리드
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  final skill = skills[index];
                  final isLearned = _learnedSkills.contains(index);
                  final color = skill['color'] as Color;

                  return InkWell(
                    onTap: () {
                      _showSkillDetail(context, skill, index, isLearned);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isLearned ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLearned ? color : Colors.grey.shade300,
                          width: isLearned ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(skill['icon'] as String, style: const TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            skill['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isLearned ? color : null,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          if (isLearned)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('학습 완료', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                        ],
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
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.dreamControlTip, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),

            // 완료 버튼
            if (_learnedSkills.length >= 2)
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

  void _showSkillDetail(BuildContext context, Map<String, dynamic> skill, int index, bool isLearned) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(skill['icon'] as String, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(child: Text(skill['title'] as String)),
          ],
        ),
        content: Text(skill['desc'] as String),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (!isLearned) {
                setState(() => _learnedSkills.add(index));
              }
            },
            child: Text(isLearned ? '확인' : '학습 완료'),
          ),
        ],
      ),
    );
  }
}
