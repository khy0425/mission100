import 'package:flutter/material.dart';
import '../../models/pushup_form_guide.dart';
import 'expandable_form_step_card.dart';

/// 목록 형식 단계 뷰 위젯
class ListStepsView extends StatefulWidget {
  final List<FormStep> formSteps;
  final Widget Function(FormStep) buildMediaContent;

  const ListStepsView({
    super.key,
    required this.formSteps,
    required this.buildMediaContent,
  });

  @override
  State<ListStepsView> createState() => _ListStepsViewState();
}

class _ListStepsViewState extends State<ListStepsView> {
  final Map<int, bool> _expandedCards = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 단계별 가이드
          ...List.generate(widget.formSteps.length, (index) {
            final step = widget.formSteps[index];
            return ExpandableFormStepCard(
              step: step,
              index: index,
              isExpanded: _expandedCards[index] ?? false,
              onToggle: () {
                setState(() {
                  _expandedCards[index] = !(_expandedCards[index] ?? false);
                });
              },
              buildMediaContent: widget.buildMediaContent,
            );
          }),
          const SizedBox(height: 80), // 광고 공간 확보
        ],
      ),
    );
  }
}
