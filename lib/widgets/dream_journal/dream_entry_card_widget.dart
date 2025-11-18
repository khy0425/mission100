import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_entry.dart';

/// 꿈 일기 엔트리 카드 위젯
///
/// 개별 꿈 일기를 표시하는 카드 (날짜, 제목, 내용, 태그, 자각도 등)
class DreamEntryCardWidget extends StatelessWidget {
  final DreamEntry dream;
  final VoidCallback onTap;

  const DreamEntryCardWidget({
    super.key,
    required this.dream,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingS,
        vertical: AppConstants.paddingS,
      ),
      elevation: AppConstants.elevationS,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (날짜, 자각도, 즐겨찾기)
              Row(
                children: [
                  // 날짜
                  Chip(
                    avatar: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      dream.dateLabel,
                      style: const TextStyle(fontSize: AppConstants.fontSizeXS),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: AppConstants.paddingS),
                  // 자각도
                  if (dream.wasLucid)
                    Chip(
                      avatar: const Icon(Icons.star, size: 16),
                      label: Text(
                        l10n.lucidDreamLevel(dream.lucidityLevel),
                        style: const TextStyle(fontSize: AppConstants.fontSizeXS),
                      ),
                      backgroundColor: Colors.amber.shade100,
                      visualDensity: VisualDensity.compact,
                    ),
                  const Spacer(),
                  // 즐겨찾기
                  if (dream.isFavorite)
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                ],
              ),
              const SizedBox(height: AppConstants.paddingS),

              // 제목
              if (dream.title.isNotEmpty) ...[
                Text(
                  dream.title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.paddingS),
              ],

              // 내용 미리보기
              Text(
                dream.preview,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeS,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.paddingS),

              // 태그 (감정, 심볼)
              Wrap(
                spacing: AppConstants.paddingS,
                runSpacing: AppConstants.paddingS,
                children: [
                  ...dream.emotions.take(3).map(
                        (emotion) => _buildSmallChip(
                          emotion,
                          Icons.mood,
                          Colors.pink.shade100,
                        ),
                      ),
                  ...dream.symbols.take(3).map(
                        (symbol) => _buildSmallChip(
                          symbol,
                          Icons.auto_awesome,
                          Colors.purple.shade100,
                        ),
                      ),
                  if (dream.emotions.length + dream.symbols.length > 6)
                    _buildSmallChip(
                      '+${dream.emotions.length + dream.symbols.length - 6}',
                      Icons.more_horiz,
                      Colors.grey.shade200,
                    ),
                ],
              ),

              // 푸터 (단어 수, AI 분석 여부)
              const SizedBox(height: AppConstants.paddingS),
              Row(
                children: [
                  Icon(
                    Icons.text_fields,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${dream.wordCount} 단어',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXS,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  if (dream.hasAiAnalysis) ...[
                    Icon(
                      Icons.psychology,
                      size: 14,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.aiAnalysisCompleted,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXS,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: AppConstants.fontSizeXS),
          ),
        ],
      ),
    );
  }
}
