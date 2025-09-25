import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';


class ShareCardWidget extends StatelessWidget {
  final ShareCardType type;
  final Map<String, dynamic> data;

  const ShareCardWidget({
    super.key,
    required this.type,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(AppColors.primaryColor).withValues(alpha: 0.8),
                  const Color(AppColors.primaryColor).withValues(alpha: 0.6),
                ]
              : [
                  const Color(AppColors.primaryColor),
                  const Color(AppColors.primaryColor).withValues(alpha: 0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, l10n),
          const SizedBox(height: 20),
          _buildContent(context, l10n),
          const SizedBox(height: 20),
          _buildFooter(context, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.fitness_center,
            color: Color(AppColors.primaryColor),
            size: 30,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.alphaEmperorDomain,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                l10n.journeyToChad,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    switch (type) {
      case ShareCardType.dailyWorkout:
        return _buildDailyWorkoutContent(context, l10n);
      case ShareCardType.levelUp:
        return _buildLevelUpContent(context, l10n);
      case ShareCardType.achievement:
        return _buildAchievementContent(context, l10n);
      case ShareCardType.weeklyProgress:
        return _buildWeeklyProgressContent(context, l10n);
      case ShareCardType.mission100:
        return _buildMission100Content(context, l10n);
    }
  }

  Widget _buildDailyWorkoutContent(BuildContext context, AppLocalizations l10n) {
    final pushupCount = data['pushupCount'] as int;
    final currentDay = data['currentDay'] as int;
    final level = data['level'] as UserLevel;
    final levelName = _getLevelName(level, l10n);

    return Column(
      children: [
        Text(
          l10n.dailyConquestRecord,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.dayLabel,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '$currentDay',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.pushupsLabel,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    l10n.repsFormat(pushupCount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.levelLabel,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    levelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelUpContent(BuildContext context, AppLocalizations l10n) {
    final newLevel = data['newLevel'] as UserLevel;
    final totalDays = data['totalDays'] as int;
    final totalPushups = data['totalPushups'] as int;
    final levelName = _getLevelName(newLevel, l10n);
    final levelEmoji = _getLevelEmoji(newLevel);

    return Column(
      children: [
        Text(
          l10n.levelUpMessage(levelEmoji),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                l10n.newChadLevel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              Text(
                levelName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        '📅',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        l10n.daysFormat(totalDays),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '💪',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        l10n.repsFormat(totalPushups),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementContent(BuildContext context, AppLocalizations l10n) {
    final title = data['title'] as String;
    final description = data['description'] as String;
    final xpReward = data['xpReward'] as int;

    return Column(
      children: [
        Text(
          l10n.achievementUnlocked,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '🎯 +${xpReward} XP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressContent(BuildContext context, AppLocalizations l10n) {
    final weekNumber = data['weekNumber'] as int;
    final completedDays = data['completedDays'] as int;
    final totalPushups = data['totalPushups'] as int;
    final progressPercentage = data['progressPercentage'] as double;

    return Column(
      children: [
        Text(
          l10n.weeklyReport,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Week $weekNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.checkIcon, style: const TextStyle(fontSize: 20)),
                      Text(
                        l10n.daysFormat(completedDays),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.muscleIcon, style: const TextStyle(fontSize: 20)),
                      Text(
                        l10n.repsFormat(totalPushups),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildProgressBar(progressPercentage),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMission100Content(BuildContext context, AppLocalizations l10n) {
    final totalDays = data['totalDays'] as int;
    final duration = data['duration'] as int;

    return Column(
      children: [
        Text(
          l10n.missionComplete,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                l10n.pushup100Streak,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.calendarIcon, style: const TextStyle(fontSize: 20)),
                      Text(
                        l10n.daysFormat(duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.durationLabel,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.trophyIcon, style: const TextStyle(fontSize: 20)),
                      Text(
                        l10n.timesFormat(totalDays),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.completedLabel,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.trueGigaChad,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double percentage) {
    return Column(
      children: [
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.white.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.becomeChad,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        Text(
          l10n.downloadMission100,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getLevelName(UserLevel level, AppLocalizations l10n) {
    switch (level) {
      case UserLevel.rookie:
        return l10n.rookieShort;
      case UserLevel.rising:
        return l10n.risingShort;
      case UserLevel.alpha:
        return l10n.alphaShort;
      case UserLevel.giga:
        return l10n.gigaShort;
    }
  }

  String _getLevelEmoji(UserLevel level) {
    switch (level) {
      case UserLevel.rookie:
        return '🌱';
      case UserLevel.rising:
        return '🔥';
      case UserLevel.alpha:
        return '⚡';
      case UserLevel.giga:
        return '👑';
    }
  }
}

enum ShareCardType {
  dailyWorkout,
  levelUp,
  achievement,
  weeklyProgress,
  mission100,
} 