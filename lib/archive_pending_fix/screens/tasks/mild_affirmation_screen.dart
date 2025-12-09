import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// MILD 확언(Affirmation) 연습 화면
///
/// 사용자가 MILD 기법을 연습하도록 가이드
/// 잠들기 전 암시문을 반복하는 기법
class MildAffirmationScreen extends StatefulWidget {
  const MildAffirmationScreen({super.key});

  @override
  State<MildAffirmationScreen> createState() => _MildAffirmationScreenState();
}

class _MildAffirmationScreenState extends State<MildAffirmationScreen> {
  int _selectedAffirmationIndex = 0;
  int _repetitionCount = 0;
  bool _isCompleting = false;

  // 미리 준비된 MILD 확언 문구
  final List<String> _affirmationKeys = [
    'mildAffirmation1',
    'mildAffirmation2',
    'mildAffirmation3',
    'mildAffirmation4',
    'mildAffirmation5',
  ];

  void _incrementRepetition() {
    setState(() {
      _repetitionCount++;
    });
  }

  void _resetRepetition() {
    setState(() {
      _repetitionCount = 0;
    });
  }

  Future<void> _completeTask() async {
    if (_isCompleting) return;

    if (_repetitionCount < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).mildRepeatAtLeast3Times),
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
      await taskService.toggleTask(LucidDreamTaskType.mildAffirmation, true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).mildCompleted,
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

  String _getAffirmationText(String key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'mildAffirmation1':
        return l10n.mildAffirmation1;
      case 'mildAffirmation2':
        return l10n.mildAffirmation2;
      case 'mildAffirmation3':
        return l10n.mildAffirmation3;
      case 'mildAffirmation4':
        return l10n.mildAffirmation4;
      case 'mildAffirmation5':
        return l10n.mildAffirmation5;
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
        title: Text(l10n.mildTitle),
        backgroundColor: const Color(0xFF2196F3),
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
                  const Color(0xFF2196F3).withOpacity(0.1),
                  const Color(0xFF1976D2).withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '🌙',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.mildGuideTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.mildGuideDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 180), // 하단 버튼 공간 확보
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 확언 선택
                  Text(
                    l10n.mildSelectAffirmation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_affirmationKeys.length, (index) {
                    final isSelected = _selectedAffirmationIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAffirmationIndex = index;
                            _repetitionCount = 0;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2196F3).withOpacity(0.1)
                                : theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2196F3)
                                  : theme.dividerColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? const Color(0xFF2196F3)
                                    : theme.dividerColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getAffirmationText(_affirmationKeys[index]),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // 반복 섹션
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2196F3).withOpacity(0.1),
                          const Color(0xFF1976D2).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF2196F3).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.mildCurrentAffirmation,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getAffirmationText(
                              _affirmationKeys[_selectedAffirmationIndex]),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // 반복 횟수
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.repeat,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$_repetitionCount ${l10n.mildTimes}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // 반복 버튼
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _repetitionCount > 0
                                    ? _resetRepetition
                                    : null,
                                icon: const Icon(Icons.refresh),
                                label: Text(l10n.mildReset),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: _incrementRepetition,
                                icon: const Icon(Icons.add_circle_outline),
                                label: Text(l10n.mildRepeat),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2196F3),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_repetitionCount > 0 && _repetitionCount < 3)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              l10n.mildRepeatAtLeast3Times,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 팁
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.lightBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.lightBlue,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.mildTip,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 완료 버튼
          if (_repetitionCount >= 3)
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
              child: ElevatedButton(
                onPressed: _isCompleting ? null : _completeTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
