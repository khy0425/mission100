import 'package:flutter/material.dart';
import '../../services/progress/stage_unlock_service.dart';

/// 스테이지 업 알림 다이얼로그
///
/// 스테이지가 올라갈 때 표시되는 심플한 알림 다이얼로그
class StageUpCelebrationDialog extends StatefulWidget {
  final StageChangeResult stageChange;
  final VoidCallback? onDismiss;

  const StageUpCelebrationDialog({
    super.key,
    required this.stageChange,
    this.onDismiss,
  });

  /// 스테이지 업 다이얼로그 표시
  static Future<void> show(
    BuildContext context, {
    required StageChangeResult stageChange,
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => StageUpCelebrationDialog(
        stageChange: stageChange,
        onDismiss: onDismiss,
      ),
    );
  }

  /// SnackBar 스타일로 간단히 표시 (더 자연스러운 방식)
  static void showSnackBar(
    BuildContext context, {
    required StageChangeResult stageChange,
  }) {
    final stageInfo = stageChange.newStageInfo;
    final stageColor = _getStageColorStatic(stageInfo.stage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(stageInfo.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stage ${stageInfo.stage} 달성!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${stageInfo.nameKo} · 일일 ${stageInfo.dailyTokens}토큰',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: stageColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: '자세히',
          textColor: Colors.white,
          onPressed: () {
            show(context, stageChange: stageChange);
          },
        ),
      ),
    );
  }

  static Color _getStageColorStatic(int stage) {
    switch (stage) {
      case 1: return Colors.green;
      case 2: return Colors.teal;
      case 3: return Colors.blue;
      case 4: return Colors.indigo;
      case 5: return Colors.purple;
      case 6: return Colors.amber;
      default: return Colors.blue;
    }
  }

  @override
  State<StageUpCelebrationDialog> createState() => _StageUpCelebrationDialogState();
}

class _StageUpCelebrationDialogState extends State<StageUpCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stageInfo = widget.stageChange.newStageInfo;
    final stageColor = _getStageColor(stageInfo.stage);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 스테이지 이모지
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: stageColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(stageInfo.emoji, style: const TextStyle(fontSize: 40)),
                  ),
                ),
                const SizedBox(height: 16),

                // 스테이지 정보
                Text(
                  stageInfo.nameKo,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: stageColor,
                  ),
                ),
                Text(
                  'Stage ${stageInfo.stage}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                // 토큰 정보
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.token, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '일일 ${stageInfo.dailyTokens}토큰',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),

                // 새로 해금된 기능 (있을 경우)
                if (stageInfo.unlockedFeatures.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '새 기능',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...stageInfo.unlockedFeatures.map((feature) {
                    final featureName = StageUnlockService.getFeatureNameKo(feature);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, size: 16, color: stageColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              featureName,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 20),

                // 확인 버튼
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onDismiss?.call();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: stageColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStageColor(int stage) {
    return StageUpCelebrationDialog._getStageColorStatic(stage);
  }
}
