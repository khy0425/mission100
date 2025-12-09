import 'package:flutter/material.dart';
import '../../models/technique.dart';

/// 기법 상세 화면 템플릿
///
/// 모든 앱에서 동일한 UI 패턴을 사용하여 기법 상세 정보를 표시합니다.
/// TechniqueData에서 데이터를 로드하여 표시합니다.
class TechniqueDetailScreen extends StatelessWidget {
  final Technique technique;

  const TechniqueDetailScreen({
    super.key,
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: technique.color,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                technique.nameKo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black26)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      technique.color,
                      technique.color.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    technique.icon,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Duration badges
                  _buildBadges(theme),
                  const SizedBox(height: 24),

                  // Description
                  _buildSection(
                    theme,
                    title: '설명',
                    child: Text(
                      technique.fullDescriptionKo,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Steps
                  _buildSection(
                    theme,
                    title: '단계별 가이드',
                    child: _buildSteps(theme),
                  ),
                  const SizedBox(height: 24),

                  // Tips
                  if (technique.tips != null && technique.tips!.isNotEmpty) ...[
                    _buildSection(
                      theme,
                      title: '팁',
                      child: _buildTips(theme),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Research note
                  if (technique.researchNoteKo != null) ...[
                    _buildResearchNote(theme),
                    const SizedBox(height: 24),
                  ],

                  // Start practice button (if interactive)
                  if (technique.isInteractive) ...[
                    _buildPracticeButton(context, theme),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadges(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Category badge
        _buildBadge(
          icon: technique.category.icon,
          label: technique.category.displayNameKo,
          color: technique.color,
        ),

        // Duration badge
        if (technique.totalDurationSeconds != null)
          _buildBadge(
            icon: Icons.timer,
            label: technique.formattedDuration,
            color: Colors.grey[600]!,
          ),

        // Recommended time badge
        if (technique.recommendedTimeKo != null)
          _buildBadge(
            icon: Icons.schedule,
            label: technique.recommendedTimeKo!,
            color: Colors.grey[600]!,
          ),

        // Interactive badge
        if (technique.isInteractive)
          _buildBadge(
            icon: Icons.touch_app,
            label: '인터랙티브',
            color: Colors.green,
          ),
      ],
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(ThemeData theme, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildSteps(ThemeData theme) {
    return Column(
      children: technique.steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == technique.steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number with line
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: technique.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: technique.color.withValues(alpha: 0.3),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Step content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (step.icon != null) ...[
                          Icon(step.icon, size: 20, color: technique.color),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            step.titleKo,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (step.durationSeconds != null && step.durationSeconds! > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: technique.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${step.durationSeconds}초',
                              style: TextStyle(
                                color: technique.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.descriptionKo,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTips(ThemeData theme) {
    return Column(
      children: technique.tips!.map((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber[200]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                tip.icon ?? Icons.lightbulb,
                color: Colors.amber[700],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tip.textKo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.amber[900],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResearchNote(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.science, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '과학적 근거',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  technique.researchNoteKo!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Navigate to interactive practice screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${technique.nameKo} 연습 기능은 준비 중입니다'),
              backgroundColor: technique.color,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: technique.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, size: 28),
            const SizedBox(width: 8),
            Text(
              '연습 시작하기',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
