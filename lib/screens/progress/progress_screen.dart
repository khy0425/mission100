import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/common/ad_banner_widget.dart';
// DreamFlow - Workout/Chad 제거됨 (아카이브)
// DreamFlow - Achievements/업적 제거됨 (통계만 표시)
import '../../widgets/progress/dream_calendar_widget.dart';

/// 진척도 화면 - 꿈 일기 통계 화면
///
/// 업적 시스템 제거됨 - 실제 사용 통계만 표시
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).progress,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true, // 시스템 네비게이션 버튼 영역 확보
        child: Column(
          children: [
            // 꿈 일기 캘린더 (스크롤 가능)
            const Expanded(
              child: DreamCalendarWidget(),
            ),

            // 하단 배너 광고 (네비게이션 바 회피)
            Consumer<AuthService>(
              builder: (context, authService, child) {
                return const AdBannerWidget(
                  margin: EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                  ),
                );
              },
            ),

            // 네비게이션 바를 위한 추가 공간 확보
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
