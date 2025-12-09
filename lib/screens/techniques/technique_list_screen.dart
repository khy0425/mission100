import 'package:flutter/material.dart';
import '../../models/technique.dart';
import '../../utils/technique_data.dart';
import '../../widgets/common/ad_banner_widget.dart';
import 'technique_detail_screen.dart';

/// 기법 목록 화면
///
/// 모든 기법을 카테고리별로 표시하고 상세 페이지로 이동합니다.
class TechniqueListScreen extends StatelessWidget {
  const TechniqueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final techniques = TechniqueData.allTechniques;

    // 카테고리별로 그룹화
    final Map<TechniqueCategory, List<Technique>> groupedTechniques = {};
    for (final technique in techniques) {
      groupedTechniques.putIfAbsent(technique.category, () => []);
      groupedTechniques[technique.category]!.add(technique);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('기법 가이드'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedTechniques.length,
              itemBuilder: (context, index) {
                final category = groupedTechniques.keys.elementAt(index);
                final categoryTechniques = groupedTechniques[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(category.icon, color: category.color, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            category.displayNameKo,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: category.color,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Technique cards
                    ...categoryTechniques.map((technique) => _buildTechniqueCard(
                      context,
                      theme,
                      technique,
                    )),

                    if (index < groupedTechniques.length - 1)
                      const Divider(height: 32),
                  ],
                );
              },
            ),
          ),
          // 하단 배너 광고
          const SafeArea(
            top: false,
            child: AdBannerWidget(margin: EdgeInsets.symmetric(vertical: 8)),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniqueCard(
    BuildContext context,
    ThemeData theme,
    Technique technique,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TechniqueDetailScreen(technique: technique),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: technique.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  technique.icon,
                  color: technique.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      technique.nameKo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      technique.shortDescriptionKo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Badges
                    Wrap(
                      spacing: 6,
                      children: [
                        if (technique.formattedDuration.isNotEmpty)
                          _buildMiniTag(
                            Icons.timer,
                            technique.formattedDuration,
                            Colors.grey[600]!,
                          ),
                        if (technique.isInteractive)
                          _buildMiniTag(
                            Icons.touch_app,
                            '인터랙티브',
                            Colors.green,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
