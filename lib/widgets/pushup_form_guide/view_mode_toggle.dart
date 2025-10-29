import 'package:flutter/material.dart';
import '../../utils/helpers/accessibility_utils.dart';

/// 뷰 모드 전환 버튼 위젯
class ViewModeToggle extends StatelessWidget {
  final bool isStepViewMode;
  final VoidCallback onListViewPressed;
  final VoidCallback onSwipeViewPressed;
  final String listViewLabel;
  final String swipeViewLabel;

  const ViewModeToggle({
    super.key,
    required this.isStepViewMode,
    required this.onListViewPressed,
    required this.onSwipeViewPressed,
    required this.listViewLabel,
    required this.swipeViewLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            label: AccessibilityUtils.createButtonLabel(
              action: '목록 보기로 전환',
              target: '단계별 가이드',
              state: !isStepViewMode ? '현재 선택됨' : null,
              hint: '단계별 가이드를 목록 형태로 표시합니다',
            ),
            child: ElevatedButton.icon(
              onPressed: onListViewPressed,
              icon: const Icon(Icons.list, size: 18),
              label: Text(listViewLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    !isStepViewMode ? const Color(0xFF4DABF7) : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Semantics(
            button: true,
            label: AccessibilityUtils.createButtonLabel(
              action: '스와이프 보기로 전환',
              target: '단계별 가이드',
              state: isStepViewMode ? '현재 선택됨' : null,
              hint: '단계별 가이드를 스와이프 형태로 표시합니다',
            ),
            child: ElevatedButton.icon(
              onPressed: onSwipeViewPressed,
              icon: const Icon(Icons.swipe, size: 18),
              label: Text(swipeViewLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isStepViewMode ? const Color(0xFF4DABF7) : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
