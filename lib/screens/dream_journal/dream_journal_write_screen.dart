import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_entry.dart';
import '../../models/dream_sign.dart';
import '../../services/data/dream_journal_service.dart';
import '../../services/data/daily_task_completion_service.dart';
import '../../services/notification/reality_check_notification_service.dart';
import '../../services/workout/daily_task_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../services/auth/auth_service.dart';
import '../../widgets/dream_journal/chip_list_input_widget.dart';
import '../../widgets/dream_journal/lucidity_score_widget.dart';
import '../../widgets/dream_journal/sleep_data_input_widget.dart';
import '../../widgets/dream_journal/scientific_prompts_card.dart';
import '../../widgets/dream_journal/mood_score_widget.dart';
import '../../widgets/dream_journal/techniques_input_widget.dart';
import '../../widgets/dream_journal/date_picker_field_widget.dart';
import '../../widgets/dream_journal/title_input_field_widget.dart';
import '../../widgets/dream_journal/content_input_field_widget.dart';
import '../../widgets/common/ad_banner_widget.dart';

/// 꿈 일기 작성/수정 화면
///
/// 과학적 근거:
/// - Schredl, M. (2002) - 꿈 일기 작성 방법론
/// - Ebbinghaus - 망각 곡선 (5분 이내 50% 잊음)
/// - Paul Tholey - Dream Sign 분류
/// - Stephen LaBerge - 자각도 척도
class DreamJournalWriteScreen extends StatefulWidget {
  final DreamEntry? existingDream; // 수정 모드인 경우

  const DreamJournalWriteScreen({
    super.key,
    this.existingDream,
  });

  @override
  State<DreamJournalWriteScreen> createState() =>
      _DreamJournalWriteScreenState();
}

class _DreamJournalWriteScreenState extends State<DreamJournalWriteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dreamJournalService = DreamJournalService();

  // Text Controllers
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _emotionController;
  late TextEditingController _symbolController;
  late TextEditingController _characterController;
  late TextEditingController _locationController;

  // Form Data
  late DateTime _dreamDate;
  late int _lucidityLevel;
  late int? _moodScore;
  late int? _sleepQuality;
  late DateTime? _sleepTime;
  late DateTime? _wakeTime;
  late List<String> _emotions;
  late List<String> _symbols;
  late List<String> _characters;
  late List<String> _locations;
  late List<LucidDreamTechnique> _techniquesUsed;
  late bool _usedWbtb;
  late bool _isFavorite;

  bool _isSaving = false;
  bool _showScientificPrompts = true;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.existingDream != null) {
      // 수정 모드
      final dream = widget.existingDream!;
      _titleController = TextEditingController(text: dream.title);
      _contentController = TextEditingController(text: dream.content);
      _dreamDate = dream.dreamDate;
      _lucidityLevel = dream.lucidityLevel;
      _moodScore = dream.moodScore;
      _sleepQuality = dream.sleepQuality;
      _sleepTime = dream.sleepTime;
      _wakeTime = dream.wakeTime;
      _emotions = List.from(dream.emotions);
      _symbols = List.from(dream.symbols);
      _characters = List.from(dream.characters);
      _locations = List.from(dream.locations);
      _techniquesUsed = dream.techniquesUsed
          .map((t) => LucidDreamTechnique.values
              .firstWhere((e) => e.name == t, orElse: () => LucidDreamTechnique.mild))
          .toList();
      _usedWbtb = dream.usedWbtb;
      _isFavorite = dream.isFavorite;
    } else {
      // 새 일기 모드
      _titleController = TextEditingController();
      _contentController = TextEditingController();
      _dreamDate = DateTime.now();
      _lucidityLevel = 0;
      _moodScore = null;
      _sleepQuality = null;
      _sleepTime = null;
      _wakeTime = null;
      _emotions = [];
      _symbols = [];
      _characters = [];
      _locations = [];
      _techniquesUsed = [];
      _usedWbtb = false;
      _isFavorite = false;
    }

    _emotionController = TextEditingController();
    _symbolController = TextEditingController();
    _characterController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _emotionController.dispose();
    _symbolController.dispose();
    _characterController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// 꿈 일기 저장
  Future<void> _saveDream() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.dreamContentRequired),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final authService = AuthService();
      final userId = authService.currentUser?.uid ?? 'anonymous';

      final DreamEntry dream;
      if (widget.existingDream != null) {
        // 수정
        dream = widget.existingDream!.copyWith(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          lucidityLevel: _lucidityLevel,
          wasLucid: _lucidityLevel >= 5,
          emotions: _emotions,
          moodScore: _moodScore,
          symbols: _symbols,
          characters: _characters,
          locations: _locations,
          sleepTime: _sleepTime,
          wakeTime: _wakeTime,
          sleepQuality: _sleepQuality,
          techniquesUsed: _techniquesUsed.map((t) => t.name).toList(),
          usedWbtb: _usedWbtb,
          isFavorite: _isFavorite,
        );
      } else {
        // 새 일기
        dream = DreamEntry(
          id: 'dream_${userId}_${DateTime.now().millisecondsSinceEpoch}',
          userId: userId,
          createdAt: DateTime.now(),
          dreamDate: _dreamDate,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          lucidityLevel: _lucidityLevel,
          wasLucid: _lucidityLevel >= 5,
          emotions: _emotions,
          moodScore: _moodScore,
          symbols: _symbols,
          characters: _characters,
          locations: _locations,
          sleepTime: _sleepTime,
          wakeTime: _wakeTime,
          sleepQuality: _sleepQuality,
          techniquesUsed: _techniquesUsed.map((t) => t.name).toList(),
          usedWbtb: _usedWbtb,
          isFavorite: _isFavorite,
        );
      }

      final success = await _dreamJournalService.saveDream(dream);

      if (success && mounted) {
        // 체크리스트 태스크 자동 완료 표시
        try {
          // 1. SharedPreferences에 저장 (DailyTaskCompletionService)
          final taskCompletionService = DailyTaskCompletionService();
          await taskCompletionService.markTaskCompleted('dream_journal');

          // 2. 메모리 상태 업데이트 (DailyTaskService) - UI가 이걸 보고 있음!
          final dailyTaskService = Provider.of<DailyTaskService>(context, listen: false);
          await dailyTaskService.toggleTask(LucidDreamTaskType.dreamJournal, true);

          debugPrint('✅ 꿈 일기 작성 태스크 자동 완료 처리됨 (SharedPreferences + DailyTaskService)');
        } catch (e) {
          debugPrint('⚠️ 태스크 완료 표시 실패: $e');
        }

        // Reality Check 알림 스케줄링 (꿈 패턴 기반)
        try {
          final rcNotificationService = RealityCheckNotificationService();
          await rcNotificationService
              .scheduleRealityCheckNotificationsAfterDream(l10n);
          debugPrint('✅ Reality Check 알림 스케줄링 완료');
        } catch (e) {
          debugPrint('⚠️ Reality Check 알림 스케줄링 실패: $e');
        }

        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingDream != null
                  ? l10n.dreamUpdatedSuccess
                  : l10n.dreamSavedSuccess,
            ),
            backgroundColor: const Color(AppColors.successColor),
          ),
        );
        Navigator.of(context).pop(true); // 저장 성공 반환
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.dreamSaveFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ 꿈 일기 저장 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorOccurred}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingDream != null ? l10n.dreamJournalEdit : l10n.dreamJournalCreate,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.star : Icons.star_border),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              HapticFeedback.lightImpact();
            },
            tooltip: l10n.tooltipFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveDream,
            tooltip: l10n.tooltipSave,
          ),
        ],
      ),
      extendBodyBehindAppBar: false,
      body: SafeArea(
        bottom: true, // 시스템 네비게이션 버튼 영역 확보
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1a0033), // 다크 보라
                      const Color(0xFF0a0015), // 거의 검정
                    ],
                  ),
                ),
                child: _isSaving
                    ? const Center(child: CircularProgressIndicator())
                    : Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(AppConstants.paddingM),
                          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // 과학적 프롬프트
                    ScientificPromptsCard(
                      initiallyExpanded: _showScientificPrompts,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _showScientificPrompts = expanded;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // 기본 정보 섹션
                    _buildSection(
                      theme: theme,
                      icon: Icons.edit_note,
                      title: '기본 정보',
                      color: const Color(0xFF673AB7),
                      child: Column(
                        children: [
                          DatePickerFieldWidget(
                            selectedDate: _dreamDate,
                            onDateChanged: (date) {
                              setState(() {
                                _dreamDate = date;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TitleInputFieldWidget(controller: _titleController),
                          const SizedBox(height: 16),
                          ContentInputFieldWidget(controller: _contentController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 자각몽 정보 섹션
                    _buildSection(
                      theme: theme,
                      icon: Icons.psychology,
                      title: '자각몽 정보',
                      color: const Color(0xFF9C27B0),
                      child: Column(
                        children: [
                          LucidityScoreWidget(
                            lucidityLevel: _lucidityLevel,
                            onChanged: (value) {
                              setState(() {
                                _lucidityLevel = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TechniquesInputWidget(
                            usedWbtb: _usedWbtb,
                            techniquesUsed: _techniquesUsed,
                            onWbtbChanged: (value) {
                              setState(() {
                                _usedWbtb = value;
                              });
                            },
                            onTechniqueChanged: (technique, value) {
                              setState(() {
                                if (value) {
                                  _techniquesUsed.add(technique);
                                } else {
                                  _techniquesUsed.remove(technique);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 꿈 분석 섹션
                    _buildSection(
                      theme: theme,
                      icon: Icons.analytics,
                      title: '꿈 분석',
                      color: const Color(0xFF2196F3),
                      child: Column(
                        children: [
                          ChipListInputWidget(
                            title: l10n.emotionsInputTitle,
                            items: _emotions,
                            controller: _emotionController,
                            hintText: l10n.emotionInputHint,
                            prefixIcon: Icons.mood,
                            onItemAdded: (value) {
                              setState(() {
                                _emotions.add(value);
                              });
                            },
                            onItemRemoved: (value) {
                              setState(() {
                                _emotions.remove(value);
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          MoodScoreWidget(
                            moodScore: _moodScore,
                            onChanged: (score) {
                              setState(() {
                                _moodScore = score;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ChipListInputWidget(
                            title: l10n.dreamSignsInputTitle,
                            items: _symbols,
                            controller: _symbolController,
                            hintText: l10n.dreamSignsHint,
                            prefixIcon: Icons.auto_awesome,
                            onItemAdded: (value) {
                              setState(() {
                                _symbols.add(value);
                              });
                            },
                            onItemRemoved: (value) {
                              setState(() {
                                _symbols.remove(value);
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ChipListInputWidget(
                            title: l10n.charactersInputTitle,
                            items: _characters,
                            controller: _characterController,
                            hintText: l10n.charactersHint,
                            prefixIcon: Icons.person,
                            onItemAdded: (value) {
                              setState(() {
                                _characters.add(value);
                              });
                            },
                            onItemRemoved: (value) {
                              setState(() {
                                _characters.remove(value);
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ChipListInputWidget(
                            title: l10n.locationsInputTitle,
                            items: _locations,
                            controller: _locationController,
                            hintText: l10n.locationsHint,
                            prefixIcon: Icons.location_on,
                            onItemAdded: (value) {
                              setState(() {
                                _locations.add(value);
                              });
                            },
                            onItemRemoved: (value) {
                              setState(() {
                                _locations.remove(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 수면 데이터 섹션
                    _buildSection(
                      theme: theme,
                      icon: Icons.bedtime,
                      title: '수면 데이터',
                      color: const Color(0xFF4CAF50),
                      child: SleepDataInputWidget(
                        dreamDate: _dreamDate,
                        sleepTime: _sleepTime,
                        wakeTime: _wakeTime,
                        sleepQuality: _sleepQuality,
                        onSleepTimeChanged: (time) {
                          setState(() {
                            _sleepTime = time;
                          });
                        },
                        onWakeTimeChanged: (time) {
                          setState(() {
                            _wakeTime = time;
                          });
                        },
                        onSleepQualityChanged: (quality) {
                          setState(() {
                            _sleepQuality = quality;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingXL * 2),
                  ],
                ),
              ),
            ),
          ),
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

  Widget _buildSection({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 헤더 - 미니멀 디자인
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          // 구분선
          Divider(
            height: 1,
            thickness: 1,
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
          // 섹션 내용
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

}
