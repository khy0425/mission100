import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 메타 정보 카드 위젯
///
/// 작성일, 수정일, 단어 수, AI 분석 여부 표시
class DreamMetaInfoCardWidget extends StatelessWidget {
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int wordCount;
  final bool hasAiAnalysis;

  const DreamMetaInfoCardWidget({
    super.key,
    required this.createdAt,
    this.updatedAt,
    required this.wordCount,
    required this.hasAiAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.metaInfoTitle,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow(l10n.metaCreatedAt, _formatDateTime(createdAt)),
            if (updatedAt != null)
              _buildInfoRow(l10n.metaUpdatedAt, _formatDateTime(updatedAt!)),
            _buildInfoRow(l10n.metaWordCount, l10n.metaWordCountValue(wordCount.toString())),
            _buildInfoRow(
              l10n.metaAiAnalysis,
              hasAiAnalysis ? l10n.metaCompleted : l10n.metaNotCompleted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: AppConstants.fontSizeS,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeS,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
