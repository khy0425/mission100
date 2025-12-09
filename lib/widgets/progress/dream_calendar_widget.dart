import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/dream_entry.dart';
import '../../services/data/dream_journal_service.dart';
import '../../generated/l10n/app_localizations.dart';

/// 꿈 일기 진척도 캘린더 위젯
///
/// 달력 형태로 꿈 일기 작성 내역을 시각화:
/// - 일반 꿈: 파란색 점
/// - 자각몽: 금색 별
/// - 월별 통계 표시
class DreamCalendarWidget extends StatefulWidget {
  const DreamCalendarWidget({super.key});

  @override
  State<DreamCalendarWidget> createState() => _DreamCalendarWidgetState();
}

class _DreamCalendarWidgetState extends State<DreamCalendarWidget> {
  final DreamJournalService _journalService = DreamJournalService();

  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Map<DateTime, List<DreamEntry>> _dreamsByDate = {};
  bool _isLoading = true;

  // 통계
  int _totalDreams = 0;
  int _lucidDreams = 0;
  int _currentMonthDreams = 0;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadDreams();
  }

  /// 꿈 일기 데이터 로드
  Future<void> _loadDreams() async {
    setState(() => _isLoading = true);

    try {
      // 모든 꿈 일기 가져오기
      final dreams = await _journalService.getAllDreams();

      // 날짜별로 그룹화
      final Map<DateTime, List<DreamEntry>> dreamsByDate = {};
      int lucidCount = 0;
      int currentMonthCount = 0;

      for (final dream in dreams) {
        // 날짜만 비교하기 위해 시간 정보 제거
        final dateKey = DateTime(
          dream.dreamDate.year,
          dream.dreamDate.month,
          dream.dreamDate.day,
        );

        dreamsByDate.putIfAbsent(dateKey, () => []);
        dreamsByDate[dateKey]!.add(dream);

        if (dream.wasLucid) {
          lucidCount++;
        }

        // 현재 월의 꿈 개수 세기
        if (dream.dreamDate.year == _focusedDay.year &&
            dream.dreamDate.month == _focusedDay.month) {
          currentMonthCount++;
        }
      }

      setState(() {
        _dreamsByDate = dreamsByDate;
        _totalDreams = dreams.length;
        _lucidDreams = lucidCount;
        _currentMonthDreams = currentMonthCount;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading dreams: $e');
      setState(() => _isLoading = false);
    }
  }

  /// 특정 날짜의 꿈 일기 목록 가져오기
  List<DreamEntry> _getDreamsForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _dreamsByDate[dateKey] ?? [];
  }

  /// 해당 날짜에 꿈 일기가 있는지 확인
  bool _hasDream(DateTime day) {
    return _getDreamsForDay(day).isNotEmpty;
  }

  /// 해당 날짜에 자각몽이 있는지 확인
  bool _hasLucidDream(DateTime day) {
    final dreams = _getDreamsForDay(day);
    return dreams.any((dream) => dream.wasLucid);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // 통계 카드
          _buildStatisticsCard(theme, l10n),

          const SizedBox(height: 16),

          // 범례
          _buildLegend(theme, l10n),

          const SizedBox(height: 8),

          // 캘린더
          _buildCalendar(theme, l10n),

          const SizedBox(height: 16),

          // 선택한 날짜의 꿈 일기 목록
          if (_getDreamsForDay(_selectedDay).isNotEmpty)
            _buildDreamList(theme, l10n),
        ],
      ),
    );
  }

  /// 통계 카드
  Widget _buildStatisticsCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '꿈 일기 통계',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  theme,
                  '전체 꿈',
                  _totalDreams.toString(),
                  Icons.book,
                  Colors.blue,
                ),
                _buildStatItem(
                  theme,
                  '자각몽',
                  _lucidDreams.toString(),
                  Icons.star,
                  Colors.amber,
                ),
                _buildStatItem(
                  theme,
                  '이번 달',
                  _currentMonthDreams.toString(),
                  Icons.calendar_today,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 통계 아이템
  Widget _buildStatItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// 범례
  Widget _buildLegend(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(
            '일반 꿈',
            Icons.circle,
            Colors.blue,
          ),
          const SizedBox(width: 24),
          _buildLegendItem(
            '자각몽',
            Icons.star,
            Colors.amber,
          ),
        ],
      ),
    );
  }

  /// 범례 아이템
  Widget _buildLegendItem(String label, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  /// 캘린더
  Widget _buildCalendar(ThemeData theme, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.sunday,

          // 스타일
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),

          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ) ?? const TextStyle(),
          ),

          // 날짜 선택 시
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },

          // 월 변경 시
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
              // 현재 월의 꿈 개수 다시 계산
              _currentMonthDreams = _dreamsByDate.entries
                  .where((entry) =>
                      entry.key.year == focusedDay.year &&
                      entry.key.month == focusedDay.month)
                  .fold<int>(0, (sum, entry) => sum + entry.value.length);
            });
          },

          // 날짜별 마커 표시
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (!_hasDream(day)) return null;

              final hasLucid = _hasLucidDream(day);
              final dreamCount = _getDreamsForDay(day).length;

              return Positioned(
                bottom: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasLucid)
                      Icon(
                        Icons.star,
                        size: 8,
                        color: Colors.amber[700],
                      )
                    else
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (dreamCount > 1)
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          '+${dreamCount - 1}',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 선택한 날짜의 꿈 일기 목록
  Widget _buildDreamList(ThemeData theme, AppLocalizations l10n) {
    final dreams = _getDreamsForDay(_selectedDay);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...dreams.map((dream) => _buildDreamListItem(theme, dream)),
          ],
        ),
      ),
    );
  }

  /// 꿈 일기 리스트 아이템
  Widget _buildDreamListItem(ThemeData theme, DreamEntry dream) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            dream.wasLucid ? Icons.star : Icons.nightlight_round,
            color: dream.wasLucid ? Colors.amber : Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dream.title.isNotEmpty)
                  Text(
                    dream.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  dream.preview,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (dream.wasLucid)
                  Text(
                    '${dream.lucidityLevelText} (${dream.lucidityLevel}/10)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
