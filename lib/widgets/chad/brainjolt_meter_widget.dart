import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 뇌절 미터 위젯 - Chad 레벨의 뇌절 도수를 시각적으로 표시
class BrainjoltMeter extends StatefulWidget {
  final int brainjoltDegree; // 1-9도
  final double intensity; // 0.0-1.0 (현재 레벨 내 진행도)
  final double size;
  final bool showLabel;
  final bool animate;

  const BrainjoltMeter({
    super.key,
    required this.brainjoltDegree,
    this.intensity = 1.0,
    this.size = 200.0,
    this.showLabel = true,
    this.animate = true,
  });

  @override
  State<BrainjoltMeter> createState() => _BrainjoltMeterState();
}

class _BrainjoltMeterState extends State<BrainjoltMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.intensity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(BrainjoltMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.intensity != widget.intensity ||
        oldWidget.brainjoltDegree != widget.brainjoltDegree) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.intensity,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBrainjoltColor(int degree) {
    switch (degree) {
      case 1:
        return const Color(0xFF4DABF7); // 파란색
      case 2:
        return const Color(0xFF8B4513); // 갈색
      case 3:
        return const Color(0xFF51CF66); // 초록색
      case 4:
        return const Color(0xFF000000); // 검은색
      case 5:
        return const Color(0xFFFF6B6B); // 빨간색
      case 6:
        return const Color(0xFF00D9FF); // 사이안
      case 7:
        return const Color(0xFFFFD43B); // 금색
      case 8:
        return const Color(0xFFFF6B35); // 주황색
      case 9:
        return const Color(0xFFB794F4); // 보라-금색
      default:
        return const Color(0xFF9C88FF); // 기본 보라색
    }
  }

  String _getBrainjoltLabel(int degree) {
    return '뇌절 $degree도';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 원
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _BrainjoltBackgroundPainter(),
          ),

          // 애니메이션 게이지
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _BrainjoltGaugePainter(
                  degree: widget.brainjoltDegree,
                  intensity: _animation.value,
                  color: _getBrainjoltColor(widget.brainjoltDegree),
                ),
              );
            },
          ),

          // 중앙 라벨
          if (widget.showLabel)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 뇌절 도수
                Text(
                  '${widget.brainjoltDegree}',
                  style: TextStyle(
                    fontSize: widget.size * 0.25,
                    fontWeight: FontWeight.bold,
                    color: _getBrainjoltColor(widget.brainjoltDegree),
                    shadows: [
                      Shadow(
                        color: _getBrainjoltColor(widget.brainjoltDegree)
                            .withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // 라벨
                Text(
                  _getBrainjoltLabel(widget.brainjoltDegree),
                  style: TextStyle(
                    fontSize: widget.size * 0.08,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                // 강도 표시
                Text(
                  '${(widget.intensity * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: widget.size * 0.06,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// 뇌절 미터 배경 페인터
class _BrainjoltBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // 외곽 원 (회색)
    final outerPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, outerPaint);

    // 눈금 표시 (9개)
    final tickPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2;

    for (int i = 0; i < 9; i++) {
      final angle = (i / 9) * 2 * math.pi - math.pi / 2;
      final startX = center.dx + (radius - 15) * math.cos(angle);
      final startY = center.dy + (radius - 15) * math.sin(angle);
      final endX = center.dx + (radius - 5) * math.cos(angle);
      final endY = center.dy + (radius - 5) * math.sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 뇌절 미터 게이지 페인터
class _BrainjoltGaugePainter extends CustomPainter {
  final int degree;
  final double intensity;
  final Color color;

  _BrainjoltGaugePainter({
    required this.degree,
    required this.intensity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // 전체 진행도 계산 (0.0 - 1.0)
    final totalProgress = (degree - 1 + intensity) / 9;

    // 게이지 그라디언트
    final gaugePaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0.3),
          color,
          color,
        ],
        stops: const [0.0, 0.5, 1.0],
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + (totalProgress * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // 게이지 그리기
    const startAngle = -math.pi / 2;
    final sweepAngle = totalProgress * 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      gaugePaint,
    );

    // 끝점 강조 (펄스 효과)
    final endAngle = startAngle + sweepAngle;
    final endX = center.dx + radius * math.cos(endAngle);
    final endY = center.dy + radius * math.sin(endAngle);

    final glowPaint = Paint()
      ..color = color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(Offset(endX, endY), 8, glowPaint);

    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(endX, endY), 4, dotPaint);
  }

  @override
  bool shouldRepaint(_BrainjoltGaugePainter oldDelegate) {
    return oldDelegate.degree != degree ||
        oldDelegate.intensity != intensity ||
        oldDelegate.color != color;
  }
}

/// 컴팩트 뇌절 미터 (작은 버전)
class CompactBrainjoltMeter extends StatelessWidget {
  final int brainjoltDegree;
  final double intensity;
  final double height;

  const CompactBrainjoltMeter({
    super.key,
    required this.brainjoltDegree,
    this.intensity = 1.0,
    this.height = 40,
  });

  Color _getBrainjoltColor(int degree) {
    switch (degree) {
      case 1:
        return const Color(0xFF4DABF7);
      case 2:
        return const Color(0xFF8B4513);
      case 3:
        return const Color(0xFF51CF66);
      case 4:
        return const Color(0xFF000000);
      case 5:
        return const Color(0xFFFF6B6B);
      case 6:
        return const Color(0xFF00D9FF);
      case 7:
        return const Color(0xFFFFD43B);
      case 8:
        return const Color(0xFFFF6B35);
      case 9:
        return const Color(0xFFB794F4);
      default:
        return const Color(0xFF9C88FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBrainjoltColor(brainjoltDegree);
    final totalProgress = (brainjoltDegree - 1 + intensity) / 9;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          // 진행 바
          FractionallySizedBox(
            widthFactor: totalProgress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.6),
                    color,
                  ],
                ),
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          // 라벨
          Center(
            child: Text(
              '뇌절 $brainjoltDegree도 (${(intensity * 100).toInt()}%)',
              style: TextStyle(
                fontSize: height * 0.4,
                fontWeight: FontWeight.bold,
                color: totalProgress > 0.5 ? Colors.white : Colors.grey[700],
                shadows: totalProgress > 0.5
                    ? [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
