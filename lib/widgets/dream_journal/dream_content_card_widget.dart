import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 꿈 내용 카드 위젯
///
/// 꿈의 본문 내용을 표시
class DreamContentCardWidget extends StatelessWidget {
  final String content;

  const DreamContentCardWidget({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.article, size: 20),
                SizedBox(width: 8),
                Text(
                  '꿈 내용',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              content,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeM,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
