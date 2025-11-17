import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_entry.dart';
import '../../services/data/dream_journal_service.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/dream_statistics_chart_widget.dart';
import '../../widgets/dream_journal/dream_statistics_card_widget.dart';
import '../../widgets/dream_journal/dream_search_bar_widget.dart';
import '../../widgets/dream_journal/dream_list_loading_widget.dart';
import '../../widgets/dream_journal/dream_list_empty_widget.dart';
import '../../widgets/dream_journal/dream_entry_card_widget.dart';
import 'dream_journal_write_screen.dart';
import 'dream_journal_detail_screen.dart';

/// 꿈 일기 목록 화면
class DreamJournalListScreen extends StatefulWidget {
  const DreamJournalListScreen({super.key});

  @override
  State<DreamJournalListScreen> createState() => _DreamJournalListScreenState();
}

class _DreamJournalListScreenState extends State<DreamJournalListScreen>
    with SingleTickerProviderStateMixin {
  final _dreamJournalService = DreamJournalService();
  final _searchController = TextEditingController();

  List<DreamEntry> _allDreams = [];
  List<DreamEntry> _filteredDreams = [];
  bool _isLoading = true;
  String _filterMode = 'all'; // all, lucid, favorite
  String _sortMode = 'date_desc'; // date_desc, date_asc, lucidity_desc

  // 통계
  int _totalDreams = 0;
  int _lucidDreams = 0;
  double _avgLucidity = 0.0;
  int _currentStreak = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _changeFilterMode(['all', 'lucid', 'favorite'][_tabController.index]);
      }
    });
    _loadDreams();
    _loadStatistics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// 꿈 일기 로드
  Future<void> _loadDreams() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final userId = authService.currentUser?.uid ?? 'anonymous';
      final dreams = await _dreamJournalService.getDreamsByUserId(userId);

      setState(() {
        _allDreams = dreams;
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ 꿈 일기 로드 오류: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 통계 로드
  Future<void> _loadStatistics() async {
    try {
      final total = await _dreamJournalService.getTotalDreamCount();
      final lucid = await _dreamJournalService.getLucidDreamCount();
      final avgLucidity = await _dreamJournalService.getAverageLucidityLevel();
      final streak = await _dreamJournalService.getDreamJournalStreak();

      setState(() {
        _totalDreams = total;
        _lucidDreams = lucid;
        _avgLucidity = avgLucidity;
        _currentStreak = streak;
      });
    } catch (e) {
      debugPrint('❌ 통계 로드 오류: $e');
    }
  }

  /// 필터 및 정렬 적용
  void _applyFiltersAndSort() {
    // 1. 필터 적용
    List<DreamEntry> filtered = _allDreams;

    if (_filterMode == 'lucid') {
      filtered = _allDreams.where((d) => d.wasLucid).toList();
    } else if (_filterMode == 'favorite') {
      filtered = _allDreams.where((d) => d.isFavorite).toList();
    }

    // 2. 검색 적용
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((d) {
        return d.title.toLowerCase().contains(query) ||
            d.content.toLowerCase().contains(query) ||
            d.symbols.any((s) => s.toLowerCase().contains(query)) ||
            d.characters.any((c) => c.toLowerCase().contains(query)) ||
            d.locations.any((l) => l.toLowerCase().contains(query));
      }).toList();
    }

    // 3. 정렬 적용
    if (_sortMode == 'date_desc') {
      filtered.sort((a, b) => b.dreamDate.compareTo(a.dreamDate));
    } else if (_sortMode == 'date_asc') {
      filtered.sort((a, b) => a.dreamDate.compareTo(b.dreamDate));
    } else if (_sortMode == 'lucidity_desc') {
      filtered.sort((a, b) => b.lucidityLevel.compareTo(a.lucidityLevel));
    }

    setState(() {
      _filteredDreams = filtered;
    });
  }

  /// 필터 모드 변경
  void _changeFilterMode(String mode) {
    setState(() {
      _filterMode = mode;
      _applyFiltersAndSort();
    });
  }

  /// 정렬 모드 변경
  void _changeSortMode(String mode) {
    setState(() {
      _sortMode = mode;
      _applyFiltersAndSort();
    });
  }

  /// 새 꿈 일기 작성
  void _createNewDream() async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DreamJournalWriteScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.1);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    if (result == true) {
      // 저장 성공 시 목록 새로고침
      await _loadDreams();
      await _loadStatistics();
    }
  }

  /// 꿈 일기 상세 보기
  void _viewDreamDetail(DreamEntry dream) async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DreamJournalDetailScreen(dream: dream),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.1, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    if (result == true) {
      // 변경사항이 있으면 목록 새로고침
      await _loadDreams();
      await _loadStatistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.dreamJournalTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // 정렬 메뉴
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: _changeSortMode,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date_desc',
                child: Text(l10n.sortNewest),
              ),
              PopupMenuItem(
                value: 'date_asc',
                child: Text(l10n.sortOldest),
              ),
              PopupMenuItem(
                value: 'lucidity_desc',
                child: Text(l10n.sortLucidityHigh),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.tabAllDreams(_totalDreams.toString())),
            Tab(text: l10n.tabLucidDreams(_lucidDreams.toString())),
            Tab(text: l10n.tabFavorites),
          ],
        ),
      ),
      body: Column(
        children: [
          // 통계 카드
          DreamStatisticsCardWidget(
            totalDreams: _totalDreams,
            lucidDreams: _lucidDreams,
            avgLucidity: _avgLucidity,
            currentStreak: _currentStreak,
          ),

          // 차트 (통계 시각화)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
            child: DreamStatisticsChartWidget(dreams: _allDreams),
          ),

          // 검색 바
          DreamSearchBarWidget(
            controller: _searchController,
            onChanged: _applyFiltersAndSort,
            onClear: _applyFiltersAndSort,
          ),

          // 꿈 일기 목록
          Expanded(
            child: _isLoading
                ? const DreamListLoadingWidget()
                : _filteredDreams.isEmpty
                    ? DreamListEmptyWidget(
                        filterMode: _filterMode,
                        onCreateNew: _createNewDream,
                      )
                    : _buildDreamList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewDream,
        icon: const Icon(Icons.add),
        label: Text(l10n.newDreamJournal),
      ),
    );
  }


  /// 꿈 일기 목록
  Widget _buildDreamList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadDreams();
        await _loadStatistics();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingS),
        itemCount: _filteredDreams.length,
        itemBuilder: (context, index) {
          final dream = _filteredDreams[index];
          return DreamEntryCardWidget(
            dream: dream,
            onTap: () => _viewDreamDetail(dream),
          );
        },
      ),
    );
  }
}
