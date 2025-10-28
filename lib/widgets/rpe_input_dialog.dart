import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 📊 RPE (운동자각도) 입력 다이얼로그
///
/// 운동 완료 후 사용자의 운동 강도를 평가하는 다이얼로그
/// - 6-10 스케일
/// - 감정 이모티콘
/// - 자동 조정 피드백
class RPEInputDialog extends StatefulWidget {
  final Function(int rpe) onRPESelected;
  final String? workoutSummary;

  const RPEInputDialog({
    super.key,
    required this.onRPESelected,
    this.workoutSummary,
  });

  @override
  State<RPEInputDialog> createState() => _RPEInputDialogState();

  /// 다이얼로그 표시 헬퍼 메서드
  static Future<int?> show(
    BuildContext context, {
    String? workoutSummary,
  }) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // 반드시 선택해야 함
      builder: (context) => RPEInputDialog(
        onRPESelected: (rpe) {
          Navigator.of(context).pop(rpe);
        },
        workoutSummary: workoutSummary,
      ),
    );
  }
}

class _RPEInputDialogState extends State<RPEInputDialog>
    with SingleTickerProviderStateMixin {
  int? _selectedRPE;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectRPE(int rpe) {
    setState(() {
      _selectedRPE = rpe;
    });
  }

  void _confirm() {
    if (_selectedRPE != null) {
      widget.onRPESelected(_selectedRPE!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    decoration: BoxDecoration(
                      color: const Color(AppColors.primaryColor)
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Color(AppColors.primaryColor),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '운동이 얼마나 힘들었나요?',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'RPE (운동자각도)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingXL),

              // 운동 요약 (옵션)
              if (widget.workoutSummary != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fitness_center, size: 20),
                      const SizedBox(width: AppConstants.paddingS),
                      Expanded(
                        child: Text(
                          widget.workoutSummary!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),
              ],

              // RPE 스케일 (6-10)
              ..._buildRPEOptions(theme),

              const SizedBox(height: AppConstants.paddingXL),

              // 선택된 RPE 설명
              if (_selectedRPE != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingL),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getRPEColor(_selectedRPE!).withValues(alpha: 0.1),
                        _getRPEColor(_selectedRPE!).withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _getRPEEmoji(_selectedRPE!),
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: AppConstants.paddingS),
                      Text(
                        _getRPETitle(_selectedRPE!),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getRPEColor(_selectedRPE!),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.paddingXS),
                      Text(
                        _getRPEDescription(_selectedRPE!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),
              ],

              // 버튼들
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingM,
                        ),
                      ),
                      child: const Text('건너뛰기'),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _selectedRPE != null ? _confirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppColors.primaryColor),
                        foregroundColor: theme.colorScheme.surface,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingM,
                        ),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRPEOptions(ThemeData theme) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRPEButton(6, theme),
          _buildRPEButton(7, theme),
          _buildRPEButton(8, theme),
        ],
      ),
      const SizedBox(height: AppConstants.paddingM),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRPEButton(9, theme),
          _buildRPEButton(10, theme),
          const SizedBox(width: 64), // 균형을 위한 빈 공간
        ],
      ),
    ];
  }

  Widget _buildRPEButton(int rpe, ThemeData theme) {
    final isSelected = _selectedRPE == rpe;
    final color = _getRPEColor(rpe);

    return GestureDetector(
      onTap: () => _selectRPE(rpe),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected ? color : theme.colorScheme.surface,
          border: Border.all(
            color: color,
            width: isSelected ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getRPEEmoji(rpe),
              style: TextStyle(fontSize: isSelected ? 28 : 24),
            ),
            const SizedBox(height: 2),
            Text(
              rpe.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? theme.colorScheme.surface : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRPEColor(int rpe) {
    switch (rpe) {
      case 6:
      case 7:
        return Colors.green;
      case 8:
        return Colors.orange;
      case 9:
      case 10:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getRPEEmoji(int rpe) {
    switch (rpe) {
      case 6:
        return '😊';
      case 7:
        return '🙂';
      case 8:
        return '😤';
      case 9:
        return '😫';
      case 10:
        return '🤯';
      default:
        return '🤔';
    }
  }

  String _getRPETitle(int rpe) {
    switch (rpe) {
      case 6:
        return '너무 쉬워요';
      case 7:
        return '적당해요';
      case 8:
        return '힘들어요';
      case 9:
        return '너무 힘들어요';
      case 10:
        return '한계 돌파!';
      default:
        return '';
    }
  }

  String _getRPEDescription(int rpe) {
    switch (rpe) {
      case 6:
        return '다음엔 더 할 수 있을 것 같아요\n→ 다음 운동 강도 +5%';
      case 7:
        return '딱 좋은 난이도였어요\n→ 다음 운동 강도 유지';
      case 8:
        return '완료하기 버거웠어요\n→ 다음 운동 강도 유지';
      case 9:
        return '거의 불가능했어요\n→ 다음 운동 강도 -5%';
      case 10:
        return '정말 최선을 다했어요\n→ 다음 운동 강도 -10%';
      default:
        return '';
    }
  }
}
