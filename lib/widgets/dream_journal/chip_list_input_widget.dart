import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 칩 리스트 입력 위젯 (재사용 가능)
///
/// 감정, 심볼, 인물, 장소 등 리스트 형태의 입력을 위한 공통 위젯
class ChipListInputWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Function(String) onItemAdded;
  final Function(String) onItemRemoved;

  const ChipListInputWidget({
    super.key,
    required this.title,
    required this.items,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.onItemAdded,
    required this.onItemRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeM,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            if (items.isNotEmpty)
              Wrap(
                spacing: AppConstants.paddingS,
                children: items
                    .map((item) => Chip(
                          label: Text(item),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => onItemRemoved(item),
                        ))
                    .toList(),
              ),
            const SizedBox(height: AppConstants.paddingS),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(prefixIcon),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  onItemAdded(value.trim());
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
