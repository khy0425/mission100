import 'package:flutter/material.dart';
import '../../services/chad/chad_image_service.dart';

/// Evolution Celebration Screen
///
/// Displays evolution GIF animation when user completes milestone weeks (4, 8, 12, 14)
class EvolutionCelebrationScreen extends StatefulWidget {
  final int completedWeek;
  final VoidCallback? onComplete;

  const EvolutionCelebrationScreen({
    super.key,
    required this.completedWeek,
    this.onComplete,
  });

  @override
  State<EvolutionCelebrationScreen> createState() =>
      _EvolutionCelebrationScreenState();
}

class _EvolutionCelebrationScreenState
    extends State<EvolutionCelebrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _dismissScreen();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismissScreen() {
    widget.onComplete?.call();
    Navigator.of(context).pop();
  }

  String? _getEvolutionGif() {
    return ChadImageService.getEvolutionGifPath(widget.completedWeek);
  }

  String _getStageName() {
    return ChadImageService.getEvolutionStageName(widget.completedWeek);
  }

  Color _getStageColor(BuildContext context) {
    switch (widget.completedWeek) {
      case 4:
        return Colors.orange;
      case 8:
        return const Color(0xFF00BCD4); // Cyan/Teal
      case 12:
        return Colors.purple;
      case 14:
        return const Color(0xFFFFD700); // Gold
      default:
        return Theme.of(context).colorScheme.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final evolutionGif = _getEvolutionGif();

    if (evolutionGif == null) {
      // No evolution GIF for this week, dismiss immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dismissScreen();
      });
      return const SizedBox();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: GestureDetector(
        onTap: _dismissScreen,
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    _getStageColor(context).withValues(alpha: 0.3),
                    Theme.of(context).colorScheme.onSurface,
                  ],
                ),
              ),
            ),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Evolution GIF
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildEvolutionGif(evolutionGif, context),
                    ),

                    const SizedBox(height: 40),

                    // "EVOLUTION!" text
                    _buildEvolutionText(context),

                    const SizedBox(height: 20),

                    // New stage name
                    _buildStageTitle(context),

                    const SizedBox(height: 10),

                    // Week completed
                    _buildWeekText(),

                    const SizedBox(height: 30),

                    // Tap to continue hint
                    _buildTapHint(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvolutionGif(String gifPath, BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getStageColor(context).withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          gifPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Evolution GIF 로딩 실패: $gifPath');
            debugPrint('Error: $error');
            // Fallback 1: Show week GIF instead
            final weekGif = ChadImageService.getWeekGifPath(widget.completedWeek);
            return Image.asset(
              weekGif,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Week GIF 로딩 실패: $weekGif');
                // Fallback 2: Show week PNG instead
                final weekPng = ChadImageService.getWeekPngPath(widget.completedWeek);
                return Image.asset(
                  weekPng,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Week PNG 로딩 실패: $weekPng');
                    // Fallback 3: Show error icon
                    return const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.white54,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEvolutionText(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Theme.of(context).colorScheme.surface,
          _getStageColor(context),
        ],
      ).createShader(bounds),
      child: Text(
        'EVOLUTION!',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.surface,
          letterSpacing: 4,
        ),
      ),
    );
  }

  Widget _buildStageTitle(BuildContext context) {
    return Text(
      _getStageName(),
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: _getStageColor(context),
        shadows: [
          Shadow(
            color: _getStageColor(context).withValues(alpha: 0.5),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekText() {
    return Text(
      'Week ${widget.completedWeek} Complete!',
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white70,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildTapHint() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: const Text(
        'Tap anywhere to continue',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white38,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

/// Helper function to show evolution celebration
Future<void> showEvolutionCelebration(
  BuildContext context,
  int completedWeek, {
  VoidCallback? onComplete,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => EvolutionCelebrationScreen(
        completedWeek: completedWeek,
        onComplete: onComplete,
      ),
      fullscreenDialog: true,
    ),
  );
}
