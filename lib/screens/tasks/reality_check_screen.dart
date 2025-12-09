import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// 현실 확인(Reality Check) 연습 화면
///
/// 사용자가 실제로 현실 확인 기법을 연습하도록 가이드
/// 완료 시 체크리스트에 자동 반영
class RealityCheckScreen extends StatefulWidget {
  const RealityCheckScreen({super.key});

  @override
  State<RealityCheckScreen> createState() => _RealityCheckScreenState();
}

class _RealityCheckScreenState extends State<RealityCheckScreen> {
  final Set<int> _completedMethods = {};
  bool _isCompleting = false;

  // 현실 확인 기법 목록
  final List<RealityCheckMethod> _methods = const [
    RealityCheckMethod(
      icon: '✋',
      titleKey: 'realityCheckFingerCount',
      descriptionKey: 'realityCheckFingerCountDesc',
      instructionKey: 'realityCheckFingerCountInstruction',
    ),
    RealityCheckMethod(
      icon: '⏰',
      titleKey: 'realityCheckClockCheck',
      descriptionKey: 'realityCheckClockCheckDesc',
      instructionKey: 'realityCheckClockCheckInstruction',
    ),
    RealityCheckMethod(
      icon: '📖',
      titleKey: 'realityCheckTextRead',
      descriptionKey: 'realityCheckTextReadDesc',
      instructionKey: 'realityCheckTextReadInstruction',
    ),
    RealityCheckMethod(
      icon: '👃',
      titleKey: 'realityCheckNosePinch',
      descriptionKey: 'realityCheckNosePinchDesc',
      instructionKey: 'realityCheckNosePinchInstruction',
    ),
    RealityCheckMethod(
      icon: '🤚',
      titleKey: 'realityCheckHandPush',
      descriptionKey: 'realityCheckHandPushDesc',
      instructionKey: 'realityCheckHandPushInstruction',
    ),
  ];

  Future<void> _completeTask() async {
    if (_isCompleting) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      final taskService = Provider.of<DailyTaskService>(context, listen: false);
      await taskService.toggleTask(LucidDreamTaskType.realityCheck, true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).realityCheckCompleted,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // 화면 닫기
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

  void _showMethodGuide(int index) {
    final method = _methods[index];
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(method.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_getLocalizedText(method.titleKey, l10n)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getLocalizedText(method.descriptionKey, l10n),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tips_and_updates, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        l10n.realityCheckHowTo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_getLocalizedText(method.instructionKey, l10n)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _completedMethods.add(index);
              });
            },
            child: Text(l10n.realityCheckTried),
          ),
        ],
      ),
    );
  }

  String _getLocalizedText(String key, AppLocalizations l10n) {
    // ARB 파일에서 키에 해당하는 텍스트를 가져옵니다
    switch (key) {
      case 'realityCheckFingerCount':
        return l10n.realityCheckFingerCount;
      case 'realityCheckFingerCountDesc':
        return l10n.realityCheckFingerCountDesc;
      case 'realityCheckFingerCountInstruction':
        return l10n.realityCheckFingerCountInstruction;
      case 'realityCheckClockCheck':
        return l10n.realityCheckClockCheck;
      case 'realityCheckClockCheckDesc':
        return l10n.realityCheckClockCheckDesc;
      case 'realityCheckClockCheckInstruction':
        return l10n.realityCheckClockCheckInstruction;
      case 'realityCheckTextRead':
        return l10n.realityCheckTextRead;
      case 'realityCheckTextReadDesc':
        return l10n.realityCheckTextReadDesc;
      case 'realityCheckTextReadInstruction':
        return l10n.realityCheckTextReadInstruction;
      case 'realityCheckNosePinch':
        return l10n.realityCheckNosePinch;
      case 'realityCheckNosePinchDesc':
        return l10n.realityCheckNosePinchDesc;
      case 'realityCheckNosePinchInstruction':
        return l10n.realityCheckNosePinchInstruction;
      case 'realityCheckHandPush':
        return l10n.realityCheckHandPush;
      case 'realityCheckHandPushDesc':
        return l10n.realityCheckHandPushDesc;
      case 'realityCheckHandPushInstruction':
        return l10n.realityCheckHandPushInstruction;
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
        title: Text(l10n.realityCheckTitle),
        backgroundColor: const Color(0xFF9C27B0),
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
                  const Color(0xFF9C27B0).withOpacity(0.1),
                  const Color(0xFF673AB7).withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '💭',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.realityCheckGuideTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.realityCheckGuideDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // 현실 확인 기법 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 180), // 하단 버튼 공간 확보
              itemCount: _methods.length,
              itemBuilder: (context, index) {
                final method = _methods[index];
                final isCompleted = _completedMethods.contains(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _showMethodGuide(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.withOpacity(0.1)
                            : theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCompleted
                              ? Colors.green
                              : theme.dividerColor,
                          width: isCompleted ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // 아이콘
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Colors.green.withOpacity(0.2)
                                  : theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                method.icon,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // 텍스트
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getLocalizedText(method.titleKey, l10n),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getLocalizedText(method.descriptionKey, l10n),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // 체크 표시
                          if (isCompleted)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 28,
                            )
                          else
                            Icon(
                              Icons.arrow_forward_ios,
                              color: theme.dividerColor,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 완료 버튼
          if (_completedMethods.isNotEmpty)
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

/// 현실 확인 기법 데이터 모델
class RealityCheckMethod {
  final String icon;
  final String titleKey;
  final String descriptionKey;
  final String instructionKey;

  const RealityCheckMethod({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
    required this.instructionKey,
  });
}
