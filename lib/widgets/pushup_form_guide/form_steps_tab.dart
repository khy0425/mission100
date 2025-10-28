import 'package:flutter/material.dart';
import '../../models/pushup_form_guide.dart';
import '../../utils/accessibility_utils.dart';
import 'section_header.dart';
import 'view_mode_toggle.dart';
import 'list_steps_view.dart';
import 'swipeable_steps_view.dart';

/// 폼 단계 탭 위젯
class FormStepsTab extends StatefulWidget {
  final List<FormStep> formSteps;
  final Widget Function(FormStep) buildMediaContent;
  final String headerTitle;
  final String headerSubtitle;
  final String listViewLabel;
  final String swipeViewLabel;
  final String swipeHint;

  const FormStepsTab({
    super.key,
    required this.formSteps,
    required this.buildMediaContent,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.listViewLabel,
    required this.swipeViewLabel,
    required this.swipeHint,
  });

  @override
  State<FormStepsTab> createState() => _FormStepsTabState();
}

class _FormStepsTabState extends State<FormStepsTab> {
  bool _isStepViewMode = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // 헤더와 컨트롤
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 헤더
                SectionHeader(
                  title: widget.headerTitle,
                  subtitle: widget.headerSubtitle,
                  icon: Icons.fitness_center,
                  color: const Color(0xFF4DABF7),
                ),

                const SizedBox(height: 16),

                // 뷰 모드 전환 버튼들
                ViewModeToggle(
                  isStepViewMode: _isStepViewMode,
                  onListViewPressed: () =>
                      setState(() => _isStepViewMode = false),
                  onSwipeViewPressed: () =>
                      setState(() => _isStepViewMode = true),
                  listViewLabel: widget.listViewLabel,
                  swipeViewLabel: widget.swipeViewLabel,
                ),
                const SizedBox(height: 12),
                Semantics(
                  button: true,
                  label: AccessibilityUtils.createButtonLabel(
                    action: '전체 확장',
                    target: '단계별 가이드',
                    hint: '모든 단계를 한 번에 펼쳐 보여줍니다',
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // 전체 확장 기능은 ListStepsView 내부에서 처리되므로 여기서는 토글만
                      setState(() => _isStepViewMode = false);
                    },
                    icon: const Icon(Icons.unfold_more, size: 18),
                    label: const Text('전체 확장'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87.withValues(alpha: 0.7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 내용 영역
          Expanded(
            child: _isStepViewMode
                ? SwipeableStepsView(
                    formSteps: widget.formSteps,
                    buildMediaContent: widget.buildMediaContent,
                    swipeHint: widget.swipeHint,
                  )
                : ListStepsView(
                    formSteps: widget.formSteps,
                    buildMediaContent: widget.buildMediaContent,
                  ),
          ),
        ],
      ),
    );
  }
}
