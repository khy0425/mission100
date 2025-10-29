import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chad_evolution.dart';
import '../../services/chad/chad_evolution_service.dart';
import '../../generated/app_localizations.dart';
import 'dart:math' as math;

/// Chad 진화 애니메이션 위젯
class ChadEvolutionAnimation extends StatefulWidget {
  final ChadEvolution fromChad;
  final ChadEvolution toChad;
  final VoidCallback? onAnimationComplete;
  final Duration duration;

  const ChadEvolutionAnimation({
    super.key,
    required this.fromChad,
    required this.toChad,
    this.onAnimationComplete,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<ChadEvolutionAnimation> createState() => _ChadEvolutionAnimationState();
}

class _ChadEvolutionAnimationState extends State<ChadEvolutionAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimation();
  }

  void _setupAnimations() {
    // 메인 애니메이션 컨트롤러
    _mainController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 파티클 애니메이션 컨트롤러
    _particleController = AnimationController(
      duration: Duration(
        milliseconds: (widget.duration.inMilliseconds * 0.8).round(),
      ),
      vsync: this,
    );

    // 스케일 애니메이션 컨트롤러
    _scaleController = AnimationController(
      duration: Duration(
        milliseconds: (widget.duration.inMilliseconds * 0.6).round(),
      ),
      vsync: this,
    );

    // 회전 애니메이션 컨트롤러
    _rotationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 페이드 애니메이션
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    // 스케일 애니메이션
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // 회전 애니메이션
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // 색상 애니메이션
    _colorAnimation = ColorTween(
      begin: widget.fromChad.themeColor,
      end: widget.toChad.themeColor,
    ).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );
  }

  void _startAnimation() async {
    // 순차적으로 애니메이션 실행
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // 파티클 애니메이션 시작
    _particleController.forward();

    await Future<void>.delayed(const Duration(milliseconds: 300));

    // 스케일 애니메이션 시작
    _scaleController.forward();

    await Future<void>.delayed(const Duration(milliseconds: 200));

    // 회전 애니메이션 시작
    _rotationController.forward();

    // 메인 애니메이션 시작
    _mainController.forward();

    // 애니메이션 완료 후 콜백 호출
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _mainController,
            _particleController,
            _scaleController,
            _rotationController,
          ]),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // 배경 파티클 효과
                _buildParticleEffect(),

                // 진화 전 Chad (페이드 아웃)
                Opacity(
                  opacity: 1.0 - _fadeAnimation.value,
                  child: Transform.scale(
                    scale: 1.0 - (_scaleAnimation.value - 1.0) * 0.3,
                    child: _buildChadImage(widget.fromChad),
                  ),
                ),

                // 진화 후 Chad (페이드 인)
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 0.1,
                      child: _buildChadImage(widget.toChad),
                    ),
                  ),
                ),

                // 진화 텍스트
                Positioned(
                  bottom: 100,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: _colorAnimation.value?.withValues(
                              alpha: 0.9,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: _colorAnimation.value?.withValues(
                                      alpha: 0.3,
                                    ) ??
                                    Colors.transparent,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Text(
                            AppLocalizations.of(context).evolutionCompleted,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.toChad.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: _colorAnimation.value,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(
                            widget.toChad.unlockMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChadImage(ChadEvolution chad) {
    return FutureBuilder<ImageProvider>(
      future: context.read<ChadEvolutionService>().getChadImage(
            chad.stage,
            targetSize: 200,
          ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: chad.themeColor.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
              image: DecorationImage(image: snapshot.data!, fit: BoxFit.cover),
            ),
          );
        } else {
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(
                  color: chad.themeColor.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildParticleEffect() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter: ParticleEffectPainter(
          animation: _particleController,
          color: _colorAnimation.value ?? widget.toChad.themeColor,
        ),
      ),
    );
  }
}

/// 파티클 효과를 그리는 CustomPainter
class ParticleEffectPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final List<Particle> particles;

  ParticleEffectPainter({required this.animation, required this.color})
      : particles = List.generate(50, (index) => Particle()) {
    animation.addListener(() {
      for (final particle in particles) {
        particle.update(animation.value);
      }
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      final opacity = (1.0 - particle.life) * animation.value;
      paint.color = color.withValues(alpha: opacity * 0.6);

      canvas.drawCircle(
        Offset(size.width * particle.x, size.height * particle.y),
        particle.size * animation.value,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 파티클 클래스
class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double life;
  double maxLife;

  Particle()
      : x = 0.5 + (math.Random().nextDouble() - 0.5) * 0.2,
        y = 0.5 + (math.Random().nextDouble() - 0.5) * 0.2,
        vx = (math.Random().nextDouble() - 0.5) * 0.02,
        vy = (math.Random().nextDouble() - 0.5) * 0.02,
        size = math.Random().nextDouble() * 8 + 2,
        life = 0.0,
        maxLife = math.Random().nextDouble() * 0.8 + 0.2;

  void update(double animationValue) {
    life = animationValue;
    x += vx * animationValue;
    y += vy * animationValue;

    // 화면 경계에서 반사
    if (x < 0 || x > 1) vx *= -1;
    if (y < 0 || y > 1) vy *= -1;

    x = x.clamp(0.0, 1.0);
    y = y.clamp(0.0, 1.0);
  }
}
