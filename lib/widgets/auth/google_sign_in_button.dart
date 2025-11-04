import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// Google Material Design 스타일의 로그인 버튼
///
/// Google의 공식 CSS 디자인을 Flutter로 구현
/// - Material Design 3 스타일
/// - Hover, Focus, Active 상태 지원
/// - 접근성 최적화
class GoogleSignInButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? text;
  final double? width;
  final double height;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text,
    this.width,
    this.height = 40,
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 218),
            curve: Curves.easeOut,
            width: widget.width ?? double.infinity,
            height: widget.height,
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 100, // min-content 대신 고정값
            ),
            decoration: BoxDecoration(
              // Background color
              color: isDisabled
                  ? const Color(0x61FFFFFF) // #ffffff61
                  : const Color(0xFFF2F2F2),

              // Border radius
              borderRadius: BorderRadius.circular(20),

              // Box shadow (hover 시)
              boxShadow: !isDisabled && _isHovered
                  ? const [
                      BoxShadow(
                        color: Color(0x4D3C4043), // rgba(60, 64, 67, .30)
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                      BoxShadow(
                        color: Color(0x263C4043), // rgba(60, 64, 67, .15)
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDisabled ? null : widget.onPressed,
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: Stack(
                  children: [
                    // State overlay (hover, focus, active)
                    if (!isDisabled)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 218),
                        opacity: _getStateOpacity(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF001D35), // #001d35
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                    // Disabled state overlay
                    if (isDisabled)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x1F1F1F1F), // #1f1f1f1f
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                    // Content wrapper
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Google icon
                          if (!widget.isLoading)
                            Opacity(
                              opacity: isDisabled ? 0.38 : 1.0,
                              child: _buildGoogleIcon(),
                            ),

                          // Loading indicator
                          if (widget.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF1F1F1F),
                                ),
                              ),
                            ),

                          const SizedBox(width: 12),

                          // Text
                          Flexible(
                            child: Opacity(
                              opacity: isDisabled ? 0.38 : 1.0,
                              child: Builder(
                                builder: (context) => Text(
                                  widget.text ?? AppLocalizations.of(context).signInGoogle,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.25,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 상태에 따른 오버레이 투명도 계산
  double _getStateOpacity() {
    if (_isPressed || _isFocused) {
      return 0.12; // 12% opacity
    } else if (_isHovered) {
      return 0.08; // 8% opacity
    }
    return 0.0;
  }

  /// Google 로고 SVG 위젯
  ///
  /// Google Brand Guidelines에 맞는 공식 로고
  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

/// Google 로고를 그리는 CustomPainter
///
/// Google의 공식 4가지 색상 사용:
/// - Blue: #4285F4
/// - Red: #EA4335
/// - Yellow: #FBBC05
/// - Green: #34A853
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Google "G" 로고 - 간단한 원형 구현
    // 실제 로고는 복잡하므로 Material Icons의 Google 아이콘 사용 권장

    // Blue arc (top right)
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      -0.5,
      1.5,
      false,
      bluePaint,
    );

    // Red arc (top left)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      1.0,
      1.0,
      false,
      redPaint,
    );

    // Yellow arc (bottom left)
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      2.0,
      0.8,
      false,
      yellowPaint,
    );

    // Green arc (bottom right) - with gap for letter opening
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      2.8,
      1.0,
      false,
      greenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
