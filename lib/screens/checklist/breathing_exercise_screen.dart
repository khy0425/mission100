import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/checklist_data.dart';

/// 4-7-8 호흡 운동 인터랙티브 화면
class BreathingExerciseScreen extends StatefulWidget {
  final ChecklistItem item;
  final VoidCallback? onCompleted;

  const BreathingExerciseScreen({
    super.key,
    required this.item,
    this.onCompleted,
  });

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  // 4-7-8 호흡법: 들숨 4초, 멈춤 7초, 날숨 8초
  static const int inhaleSeconds = 4;
  static const int holdSeconds = 7;
  static const int exhaleSeconds = 8;
  static const int totalCycles = 3;

  bool _isRunning = false;
  bool _isCompleted = false;
  int _currentCycle = 0;
  String _currentPhase = 'ready'; // ready, inhale, hold, exhale
  int _countdown = 0;
  Timer? _timer;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: inhaleSeconds),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isRunning = true;
      _currentCycle = 1;
    });
    _startInhale();
  }

  void _startInhale() {
    setState(() {
      _currentPhase = 'inhale';
      _countdown = inhaleSeconds;
    });
    _animationController.duration = const Duration(seconds: inhaleSeconds);
    _animationController.forward(from: 0);
    _startCountdown(inhaleSeconds, _startHold);
  }

  void _startHold() {
    setState(() {
      _currentPhase = 'hold';
      _countdown = holdSeconds;
    });
    _startCountdown(holdSeconds, _startExhale);
  }

  void _startExhale() {
    setState(() {
      _currentPhase = 'exhale';
      _countdown = exhaleSeconds;
    });
    _animationController.duration = const Duration(seconds: exhaleSeconds);
    _animationController.reverse(from: 1);
    _startCountdown(exhaleSeconds, _onCycleComplete);
  }

  void _startCountdown(int seconds, VoidCallback onComplete) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  void _onCycleComplete() {
    if (_currentCycle < totalCycles) {
      setState(() => _currentCycle++);
      _startInhale();
    } else {
      setState(() {
        _isRunning = false;
        _isCompleted = true;
        _currentPhase = 'complete';
      });
    }
  }

  void _reset() {
    _timer?.cancel();
    _animationController.reset();
    setState(() {
      _isRunning = false;
      _isCompleted = false;
      _currentCycle = 0;
      _currentPhase = 'ready';
      _countdown = 0;
    });
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case 'inhale':
        return '들이쉬세요';
      case 'hold':
        return '멈추세요';
      case 'exhale':
        return '내쉬세요';
      case 'complete':
        return '완료!';
      default:
        return '시작하기';
    }
  }

  Color _getPhaseColor() {
    switch (_currentPhase) {
      case 'inhale':
        return Colors.blue;
      case 'hold':
        return Colors.purple;
      case 'exhale':
        return Colors.teal;
      case 'complete':
        return Colors.green;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phaseColor = _getPhaseColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.nameKo),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 설명
              if (!_isRunning && !_isCompleted) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: theme.primaryColor),
                            const SizedBox(width: 8),
                            const Text(
                              '4-7-8 호흡법이란?',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '4-7-8 호흡법은 긴장과 불안을 줄이는 효과적인 호흡 기법입니다.\n\n'
                          '• 4초간 들이쉬기\n'
                          '• 7초간 숨 참기\n'
                          '• 8초간 천천히 내쉬기\n\n'
                          '3회 반복하면 마음이 차분해집니다.',
                          style: TextStyle(height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 호흡 원 애니메이션
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 사이클 표시
                      if (_isRunning || _isCompleted)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(totalCycles, (index) {
                              final isActive = index < _currentCycle;
                              final isCurrent = index == _currentCycle - 1;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: isCurrent ? 14 : 10,
                                height: isCurrent ? 14 : 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive ? phaseColor : Colors.grey[300],
                                  border: isCurrent
                                      ? Border.all(color: phaseColor, width: 2)
                                      : null,
                                ),
                              );
                            }),
                          ),
                        ),

                      // 호흡 원
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isRunning ? _scaleAnimation.value : 1.0,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: phaseColor.withValues(alpha: 0.2),
                                border: Border.all(color: phaseColor, width: 4),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_isRunning)
                                      Text(
                                        '$_countdown',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: phaseColor,
                                        ),
                                      ),
                                    Text(
                                      _getPhaseText(),
                                      style: TextStyle(
                                        fontSize: _isRunning ? 18 : 24,
                                        fontWeight: FontWeight.w600,
                                        color: phaseColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // 단계 표시
                      if (_isRunning)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPhaseIndicator('들숨', inhaleSeconds, _currentPhase == 'inhale'),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              _buildPhaseIndicator('멈춤', holdSeconds, _currentPhase == 'hold'),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              _buildPhaseIndicator('날숨', exhaleSeconds, _currentPhase == 'exhale'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // 버튼
              if (!_isRunning)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isCompleted
                        ? () {
                            widget.onCompleted?.call();
                            Navigator.pop(context);
                          }
                        : _startBreathing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isCompleted ? Colors.green : null,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _isCompleted ? '완료하기' : '시작하기',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),

              if (_isRunning)
                TextButton(
                  onPressed: _reset,
                  child: const Text('다시 시작'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseIndicator(String label, int seconds, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? _getPhaseColor().withValues(alpha: 0.2) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: isActive ? Border.all(color: _getPhaseColor()) : null,
      ),
      child: Text(
        '$label ${seconds}초',
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? _getPhaseColor() : Colors.grey[600],
        ),
      ),
    );
  }
}
