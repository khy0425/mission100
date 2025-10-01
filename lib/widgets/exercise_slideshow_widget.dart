import 'dart:async';
import 'package:flutter/material.dart';

class ExerciseSlideshowWidget extends StatefulWidget {
  final List<String> imagePaths;
  final Duration slideDuration;
  final double height;
  final BoxFit fit;

  const ExerciseSlideshowWidget({
    Key? key,
    required this.imagePaths,
    this.slideDuration = const Duration(seconds: 2),
    this.height = 300,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  State<ExerciseSlideshowWidget> createState() =>
      _ExerciseSlideshowWidgetState();
}

class _ExerciseSlideshowWidgetState extends State<ExerciseSlideshowWidget>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 페이드 애니메이션 설정
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    // 자동 슬라이드 타이머 시작
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.slideDuration, (timer) {
      _nextImage();
    });
  }

  void _nextImage() {
    if (mounted) {
      _animationController.reverse().then((_) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
        });
        _animationController.forward();
      });
    }
  }

  void _previousImage() {
    if (mounted) {
      _animationController.reverse().then((_) {
        setState(() {
          _currentIndex = (_currentIndex - 1 + widget.imagePaths.length) %
              widget.imagePaths.length;
        });
        _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4DABF7), width: 2),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, color: Color(0xFF4DABF7), size: 48),
              SizedBox(height: 8),
              Text(
                '이미지 없음',
                style: TextStyle(color: Color(0xFF4DABF7), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4DABF7), width: 2),
      ),
      child: Stack(
        children: [
          // 이미지 표시
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                widget.imagePaths[_currentIndex],
                width: double.infinity,
                height: widget.height,
                fit: widget.fit,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: Color(0xFFFF6B6B),
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '이미지 로드 실패',
                            style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 단계 표시
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'STEP ${_currentIndex + 1} / ${widget.imagePaths.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 이전/다음 버튼
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  _timer.cancel();
                  _previousImage();
                  _startTimer();
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  _timer.cancel();
                  _nextImage();
                  _startTimer();
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // 인디케이터
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imagePaths.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentIndex
                        ? const Color(0xFF4DABF7)
                        : Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),

          // 재생/일시정지 버튼
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                if (_timer.isActive) {
                  _timer.cancel();
                } else {
                  _startTimer();
                }
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _timer.isActive ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
