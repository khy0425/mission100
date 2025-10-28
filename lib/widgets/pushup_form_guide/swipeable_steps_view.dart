import 'package:flutter/material.dart';
import '../../models/pushup_form_guide.dart';
import 'form_step_card.dart';
import 'step_progress_indicator.dart';

/// 스와이프 형식 단계 뷰 위젯
class SwipeableStepsView extends StatefulWidget {
  final List<FormStep> formSteps;
  final Widget Function(FormStep) buildMediaContent;
  final String swipeHint;

  const SwipeableStepsView({
    super.key,
    required this.formSteps,
    required this.buildMediaContent,
    required this.swipeHint,
  });

  @override
  State<SwipeableStepsView> createState() => _SwipeableStepsViewState();
}

class _SwipeableStepsViewState extends State<SwipeableStepsView> {
  late PageController _stepPageController;
  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _stepPageController = PageController();
  }

  @override
  void dispose() {
    _stepPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 진행률 표시기
        StepProgressIndicator(
          currentStep: _currentStepIndex,
          totalSteps: widget.formSteps.length,
          swipeHint: widget.swipeHint,
        ),

        // 스와이프 가능한 단계별 가이드
        Expanded(
          child: PageView.builder(
            controller: _stepPageController,
            onPageChanged: (index) {
              setState(() {
                _currentStepIndex = index;
              });
            },
            itemCount: widget.formSteps.length,
            itemBuilder: (context, index) {
              final step = widget.formSteps[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FormStepCard(
                  step: step,
                  index: index,
                  buildMediaContent: widget.buildMediaContent,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
