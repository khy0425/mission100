import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/rpe_data.dart';

/// RPE (자각운동강도) 입력 위젯
class RPEInputWidget extends StatefulWidget {
  final Function(RPEData) onRPESelected;
  final double? initialValue;
  final bool showDescription;
  final EdgeInsets padding;

  const RPEInputWidget({
    super.key,
    required this.onRPESelected,
    this.initialValue,
    this.showDescription = true,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  State<RPEInputWidget> createState() => _RPEInputWidgetState();
}

class _RPEInputWidgetState extends State<RPEInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  int? _selectedRPE;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (widget.initialValue != null) {
      _selectedRPE = widget.initialValue!.round();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onRPESelected(RPEOption option) {
    setState(() {
      _selectedRPE = option.value;
      _showFeedback = true;
    });

    // 햅틱 피드백
    HapticFeedback.mediumImpact();

    // 애니메이션 실행
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    _slideController.forward();

    // RPE 데이터 생성 및 콜백 호출
    final rpeData = RPEData(
      value: option.value,
      description: option.description,
      emoji: option.emoji,
      timestamp: DateTime.now(),
    );

    widget.onRPESelected(rpeData);

    // 2초 후 피드백 숨김
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showFeedback = false);
        _slideController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 제목
          Text(
            '어제 운동이 어떠셨나요?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // 부제목
          Text(
            'RPE 척도로 운동 강도를 알려주세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // RPE 옵션 버튼들
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: RPEOption.standardOptions.map((option) {
              final isSelected = _selectedRPE == option.value;

              return GestureDetector(
                onTap: () => _onRPESelected(option),
                child: AnimatedBuilder(
                  animation: _scaleController,
                  builder: (context, child) {
                    final scale = isSelected && _scaleController.isAnimating
                        ? 1.0 + (_scaleController.value * 0.1)
                        : 1.0;

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 100,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 이모지
                            Text(
                              option.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),

                            const SizedBox(height: 8),

                            // RPE 값
                            Text(
                              option.value.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[700],
                              ),
                            ),

                            const SizedBox(height: 4),

                            // 라벨
                            Text(
                              option.label,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // 선택된 옵션 설명
          if (_selectedRPE != null && widget.showDescription)
            AnimatedBuilder(
              animation: _slideController,
              builder: (context, child) {
                final selectedOption = RPEOption.standardOptions
                    .firstWhere((option) => option.value == _selectedRPE);

                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: _slideController,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedOption.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'RPE ${selectedOption.value} - ${selectedOption.label}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedOption.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          // 피드백 메시지
          if (_showFeedback)
            AnimatedBuilder(
              animation: _slideController,
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '피드백이 저장되었습니다! 다음 운동이 자동으로 조정됩니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// 간단한 RPE 슬라이더 위젯 (투자자 데모용)
class RPESliderWidget extends StatefulWidget {
  final Function(int) onRPEChanged;
  final int initialValue;

  const RPESliderWidget({
    super.key,
    required this.onRPEChanged,
    this.initialValue = 5,
  });

  @override
  State<RPESliderWidget> createState() => _RPESliderWidgetState();
}

class _RPESliderWidgetState extends State<RPESliderWidget> {
  late int _currentRPE;

  @override
  void initState() {
    super.initState();
    _currentRPE = widget.initialValue;
  }

  String _getEmoji(int rpe) {
    if (rpe <= 2) return '😴';
    if (rpe <= 4) return '😊';
    if (rpe <= 6) return '💪';
    if (rpe <= 8) return '😅';
    return '🥵';
  }

  String _getLabel(int rpe) {
    if (rpe <= 2) return '너무 쉬움';
    if (rpe <= 4) return '쉬움';
    if (rpe <= 6) return '적당함';
    if (rpe <= 8) return '힘듦';
    return '매우 힘듦';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '운동 강도는 어떠셨나요?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 20),

          // RPE 이모지 및 값 표시
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  _getEmoji(_currentRPE),
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  'RPE $_currentRPE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  _getLabel(_currentRPE),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // RPE 슬라이더
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: Theme.of(context).primaryColor,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              trackHeight: 6,
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: _currentRPE.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: _currentRPE.toString(),
              onChanged: (value) {
                setState(() {
                  _currentRPE = value.round();
                });
                widget.onRPEChanged(_currentRPE);
                HapticFeedback.selectionClick();
              },
            ),
          ),

          // 스케일 레이블
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1\n매우 쉬움',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '5\n적당함',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '10\n한계',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
