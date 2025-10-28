import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

/// Chad가 진행하는 온보딩 위젯
class ChadOnboardingWidget extends StatefulWidget {
  final String stepType;
  final String title;
  final String description;
  final Widget? customContent;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final String? buttonText;

  const ChadOnboardingWidget({
    super.key,
    required this.stepType,
    required this.title,
    required this.description,
    this.customContent,
    this.onNext,
    this.onSkip,
    this.buttonText,
  });

  @override
  State<ChadOnboardingWidget> createState() => _ChadOnboardingWidgetState();
}

class _ChadOnboardingWidgetState extends State<ChadOnboardingWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _slideController.forward();
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // 온보딩 내용 섹션
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildContentSection(),
              ),
            ),
          ),

          // 버튼 섹션
          _buildButtonSection(),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    // 단계별 이미지/아이콘과 색상 매핑
    String? imagePath;
    IconData? iconData;
    Color iconColor;

    switch (widget.stepType) {
      case 'welcome':
        imagePath = 'assets/images/chad/basic/basicChad.png';
        iconColor = const Color(0xFF4DABF7);
        break;
      case 'programIntroduction':
        iconData = Icons.calendar_month;
        iconColor = const Color(0xFF51CF66);
        break;
      case 'adaptiveTraining':
        iconData = Icons.tune;
        iconColor = const Color(0xFFFF6B6B);
        break;
      case 'chadEvolution':
        imagePath = 'assets/images/chad/basic/basicChad.png';
        iconColor = const Color(0xFFFFD43B);
        break;
      case 'initialTest':
        iconData = Icons.fitness_center;
        iconColor = const Color(0xFFFF8787);
        break;
      default:
        iconData = Icons.info_outline;
        iconColor = const Color(0xFF4DABF7);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // 차드 이미지 또는 아이콘
            if (imagePath != null)
              // 차드 캐릭터 이미지
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else if (iconData != null)
              // 아이콘
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 80,
                  color: iconColor,
                ),
              ),

            const SizedBox(height: 48),

            // 제목 - 더 크고 대담하게
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Color(0xFF212529),
                height: 1.2,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // 설명 - 더 읽기 쉽게
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF495057),
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (widget.customContent != null) ...[
              const SizedBox(height: 32),
              widget.customContent!,
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

Widget _buildButtonSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // 스킵 버튼 (있을 경우)
            if (widget.onSkip != null)
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onSkip,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    side: BorderSide(color: Colors.grey[350]!, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context).skip,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),

            if (widget.onSkip != null) const SizedBox(width: 16),

            // 다음 버튼 - 훨씬 크고 눈에 띄게
            Expanded(
              flex: widget.onSkip != null ? 2 : 1,
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  elevation: 6,
                  shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.buttonText ?? AppLocalizations.of(context).next,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 26,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chad 진행률 표시 위젯
class ChadProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ChadProgressWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${currentStep + 1}/$totalSteps',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
