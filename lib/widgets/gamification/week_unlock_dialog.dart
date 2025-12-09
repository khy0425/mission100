import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../utils/checklist_data.dart';
import '../../screens/settings/subscription_screen.dart';

/// Week 3+ 해금 다이얼로그 (Progressive Unlock System)
///
/// 기능:
/// - Week 2 완료 후 Week 3 진입 시 표시
/// - 연구 기반 메시지 (WBTB+MILD 46% 성공률)
/// - 프리미엄 구독 안내
/// - 해금될 기법 미리보기
class WeekUnlockDialog extends StatelessWidget {
  final int weekNumber;
  final String? customTitle;
  final String? customMessage;

  const WeekUnlockDialog({
    super.key,
    required this.weekNumber,
    this.customTitle,
    this.customMessage,
  });

  /// Week 2 다이얼로그 (Model B 첫 Premium 진입점!)
  static Future<void> showWeek2Dialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const WeekUnlockDialog(
        weekNumber: 2,
      ),
    );
  }

  /// Week 3 전용 다이얼로그
  static Future<void> showWeek3Dialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const WeekUnlockDialog(
        weekNumber: 3,
      ),
    );
  }

  /// Week 5 다이얼로그 (고급 기법)
  static Future<void> showWeek5Dialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const WeekUnlockDialog(
        weekNumber: 5,
      ),
    );
  }

  /// Week 7 다이얼로그 (마스터 기법)
  static Future<void> showWeek7Dialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const WeekUnlockDialog(
        weekNumber: 7,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dialogData = _getDialogData(weekNumber, l10n);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 잠금 아이콘
            _buildLockIcon(),
            const SizedBox(height: 20),

            // 타이틀
            Text(
              customTitle ?? dialogData['title'] as String,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.primaryColor),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Week 배지
            _buildWeekBadge(),
            const SizedBox(height: 16),

            // 메시지
            Text(
              customMessage ?? dialogData['message'] as String,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 연구 기반 하이라이트 (Week 3만)
            if (weekNumber == 3) ...[
              _buildResearchHighlight(),
              const SizedBox(height: 20),
            ],

            // 해금될 기법 미리보기
            _buildUnlockedTechniquesPreview(l10n),
            const SizedBox(height: 24),

            // 프리미엄 혜택
            _buildPremiumBenefits(l10n),
            const SizedBox(height: 24),

            // 버튼들
            _buildButtons(context, l10n),
          ],
        ),
      ),
    );
  }

  /// 잠금 아이콘
  Widget _buildLockIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(AppColors.accentColor),
            const Color(AppColors.accentColor).withValues(alpha: 0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.accentColor).withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.lock_open,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  /// Week 배지
  Widget _buildWeekBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(AppColors.primaryColor),
            const Color(AppColors.accentColor),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Week $weekNumber',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 연구 기반 하이라이트 (Week 3 전용)
  Widget _buildResearchHighlight() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(AppColors.primaryColor).withValues(alpha: 0.15),
            const Color(AppColors.accentColor).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.science,
                color: Color(AppColors.primaryColor),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '연구 결과',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColors.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'WBTB + MILD 기법',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '46% 성공률',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.accentColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Australian National Study',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// 해금될 기법 미리보기
  Widget _buildUnlockedTechniquesPreview(AppLocalizations l10n) {
    final items = ChecklistData.getItemsUnlockingAtWeek(weekNumber);

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: const Color(AppColors.accentColor),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.weekUnlockTechniquesLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(AppColors.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.icon,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nameKo,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.researchNote != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.researchNote!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  /// 프리미엄 혜택
  Widget _buildPremiumBenefits(AppLocalizations l10n) {
    final benefits = [
      l10n.weekUnlockBenefitFullProgram,
      l10n.weekUnlockBenefitLumiEvolution,
      l10n.weekUnlockBenefitUnlimitedAI,
      l10n.weekUnlockBenefitAdvancedStats,
      l10n.weekUnlockBenefitAdRemoval,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(AppColors.accentColor).withValues(alpha: 0.2),
            const Color(AppColors.primaryColor).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(AppColors.accentColor).withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.workspace_premium,
                color: Color(AppColors.accentColor),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.weekUnlockPremiumBenefitsLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(AppColors.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...benefits.map((benefit) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              benefit,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
                height: 1.3,
              ),
            ),
          )),
        ],
      ),
    );
  }

  /// 버튼들
  Widget _buildButtons(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // 구독하기 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SubscriptionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppColors.primaryColor),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.workspace_premium, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.upgradeToPremium,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 나중에 버튼
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.later,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  /// Week별 다이얼로그 데이터
  Map<String, dynamic> _getDialogData(int week, AppLocalizations l10n) {
    switch (week) {
      case 2:
        return {
          'title': l10n.weekUnlockWeek2Title,
          'message': l10n.weekUnlockWeek2Message,
        };
      case 3:
        return {
          'title': l10n.weekUnlockWeek3Title,
          'message': l10n.weekUnlockWeek3Message,
        };
      case 5:
        return {
          'title': l10n.weekUnlockWeek5Title,
          'message': l10n.weekUnlockWeek5Message,
        };
      case 7:
        return {
          'title': l10n.weekUnlockWeek7Title,
          'message': l10n.weekUnlockWeek7Message,
        };
      default:
        return {
          'title': l10n.weekUnlockGenericTitle(week.toString()),
          'message': l10n.weekUnlockGenericMessage((week - 1).toString()),
        };
    }
  }
}
