import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/workout_program_service.dart';

/// 현재 Chad 상태 카드
class CurrentChadCard extends StatelessWidget {
  final UserProfile userProfile;
  final ProgramProgress? programProgress;

  const CurrentChadCard({
    super.key,
    required this.userProfile,
    required this.programProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Chad 레벨에 따른 이미지 및 정보
    final chadImages = [
      'assets/images/기본차드.jpg',
      'assets/images/기본차드.jpg',
      'assets/images/기본차드.jpg',
      'assets/images/기본차드.jpg',
      'assets/images/기본차드.jpg',
      'assets/images/기본차드.jpg',
      'assets/images/기본차드.jpg',
    ];

    final chadTitles = [
      'Rookie Chad',
      'Rising Chad',
      'Alpha Chad',
      'Sigma Chad',
      'Giga Chad',
      'Ultra Chad',
      'Legendary Chad',
    ];

    final currentLevel = userProfile.chadLevel.clamp(
      0,
      chadImages.length - 1,
    );
    final nextLevel = (currentLevel + 1).clamp(0, chadImages.length - 1);

    // 진행률 계산 (임시 로직)
    final progressToNext = programProgress != null
        ? (programProgress!.progressPercentage * 100) % 100 / 100
        : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      child: Card(
        color: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.emoji_events, color: Color(0xFFFFD43B), size: 24),
                  SizedBox(width: 8),
                  Text(
                    '현재 Chad 상태',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD43B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // 현재 Chad 이미지
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD43B).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        chadImages[currentLevel],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chadTitles[currentLevel],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD43B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userProfile.level.displayName,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 다음 레벨 진행률
                        if (currentLevel < chadImages.length - 1) ...[
                          Text(
                            '다음 레벨: ${chadTitles[nextLevel]}',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progressToNext,
                            backgroundColor: Colors.grey.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFFD43B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(progressToNext * 100).toInt()}% 완료',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFD43B,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(
                                  0xFFFFD43B,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xFFFFD43B),
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '최고 레벨 달성!',
                                  style: TextStyle(
                                    color: Color(0xFFFFD43B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
