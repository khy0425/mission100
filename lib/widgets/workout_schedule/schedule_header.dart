import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// 운동 스케줄 설정 헤더
class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(AppColors.primaryColor).withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.orange, size: 32),
              const SizedBox(width: 12),
              Text(
                Localizations.localeOf(context).languageCode == 'ko'
                    ? '🔥 운동 스케줄을 설정하세요!'
                    : '🔥 Set Your Workout Schedule!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Localizations.localeOf(context).languageCode == 'ko'
                ? '진정한 챔피언이 되려면 일관성이 필요합니다!\n주 3일 이상 운동해야 합니다. 💪\n\n라이프스타일에 맞는 날을 선택하고,\n알림으로 핑계를 차단하세요! 🚀'
                : 'To become a true champion, you need consistency!\nYou must work out at least 3 days a week. 💪\n\nChoose days that fit your lifestyle,\nand block excuses with reminder notifications! 🚀',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
