import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../statistics/statistics_screen.dart';
import '../achievements/achievements_screen.dart';

/// 진척도 화면 - 통계와 업적을 통합한 화면
///
/// 2개의 하위 탭으로 구성:
/// 1. 📊 통계 - 운동 통계 및 차트
/// 2. 🏆 업적 - 달성한 업적 목록
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: [
            Tab(text: AppLocalizations.of(context).statisticsTab),
            Tab(text: AppLocalizations.of(context).achievementsTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // 통계 탭 - 기존 StatisticsScreen의 body 부분을 그대로 사용
          _StatisticsTabContent(),
          // 업적 탭 - 기존 AchievementsScreen의 body 부분을 그대로 사용
          AchievementsScreen(),
        ],
      ),
    );
  }
}

/// 통계 탭 콘텐츠 - StatisticsScreen의 body 부분을 래핑
class _StatisticsTabContent extends StatelessWidget {
  const _StatisticsTabContent();

  @override
  Widget build(BuildContext context) {
    // StatisticsScreen에서 AppBar를 제외한 body 부분만 표시하기 위해
    // StatisticsScreen 자체를 사용하되, 여기서는 단순히 StatisticsScreen의
    // 콘텐츠를 보여주도록 함
    //
    // 참고: StatisticsScreen이 이미 Scaffold를 가지고 있으므로,
    // 여기서는 커스텀 구현 대신 StatisticsScreen의 body 로직을 재사용
    return const StatisticsScreen();
  }
}
