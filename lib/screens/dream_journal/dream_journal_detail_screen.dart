import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_entry.dart';
import '../../models/dream_sign.dart';
import '../../services/data/dream_journal_service.dart';
import '../../widgets/dream_journal/dream_header_card_widget.dart';
import '../../widgets/dream_journal/dream_content_card_widget.dart';
import '../../widgets/dream_journal/dream_emotions_card_widget.dart';
import '../../widgets/dream_journal/dream_signs_card_widget.dart';
import '../../widgets/dream_journal/dream_sleep_info_card_widget.dart';
import '../../widgets/dream_journal/dream_techniques_card_widget.dart';
import '../../widgets/dream_journal/dream_meta_info_card_widget.dart';
import '../ai/lucid_dream_ai_assistant_screen.dart';
import 'dream_journal_write_screen.dart';

/// 꿈 일기 상세 화면
class DreamJournalDetailScreen extends StatefulWidget {
  final DreamEntry dream;

  const DreamJournalDetailScreen({
    super.key,
    required this.dream,
  });

  @override
  State<DreamJournalDetailScreen> createState() =>
      _DreamJournalDetailScreenState();
}

class _DreamJournalDetailScreenState extends State<DreamJournalDetailScreen> {
  final _dreamJournalService = DreamJournalService();
  late DreamEntry _dream;

  @override
  void initState() {
    super.initState();
    _dream = widget.dream;
  }

  /// 즐겨찾기 토글
  Future<void> _toggleFavorite() async {
    final l10n = AppLocalizations.of(context);
    try {
      final success =
          await _dreamJournalService.toggleFavorite(_dream.id);

      if (success) {
        setState(() {
          _dream = _dream.copyWith(isFavorite: !_dream.isFavorite);
        });
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _dream.isFavorite
                  ? l10n.favoriteAdded
                  : l10n.favoriteRemoved,
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ 즐겨찾기 토글 오류: $e');
    }
  }

  /// 수정
  void _editDream() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DreamJournalWriteScreen(existingDream: _dream),
      ),
    );

    if (result == true) {
      // 수정된 데이터 다시 로드
      final updatedDream = await _dreamJournalService.getDreamById(_dream.id);
      if (updatedDream != null && mounted) {
        setState(() {
          _dream = updatedDream;
        });
      }
    }
  }

  /// 삭제
  void _deleteDream() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dreamDeleteDialogTitle),
        content: Text(l10n.dreamDeleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _dreamJournalService.deleteDream(_dream.id);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.dreamDeletedSuccess),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop(true); // 변경 알림
        }
      } catch (e) {
        debugPrint('❌ 꿈 일기 삭제 오류: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.dreamDeleteFailed(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// AI 분석 요청
  void _analyzeWithAI() async {
    final l10n = AppLocalizations.of(context);
    // 꿈 내용을 AI 분석 형식으로 포맷팅
    final dreamText = '''
제목: ${_dream.title.isNotEmpty ? _dream.title : l10n.noTitle}

날짜: ${_dream.dateLabel}
자각도: ${_dream.lucidityLevel}/10 (${_dream.lucidityLevelText})

꿈 내용:
${_dream.content}

${_dream.emotions.isNotEmpty ? '${l10n.emotionsLabel} ${_dream.emotions.join(', ')}' : ''}
${_dream.symbols.isNotEmpty ? 'Dream Signs: ${_dream.symbols.join(', ')}' : ''}
${_dream.characters.isNotEmpty ? '${l10n.charactersLabel} ${_dream.characters.join(', ')}' : ''}
${_dream.locations.isNotEmpty ? '${l10n.locationsLabel} ${_dream.locations.join(', ')}' : ''}
${_dream.techniquesUsed.isNotEmpty ? '${l10n.techniquesUsedLabel} ${_dream.techniquesUsed.join(', ')}' : ''}
''';

    // AI 어시스턴트 화면으로 이동 (꿈 분석 기능 선택)
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LucidDreamAIAssistantScreen(
          initialContent: dreamText,
          initialFeature: AssistantFeature.dreamJournal,
        ),
      ),
    );
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
          // 즐겨찾기
          IconButton(
            icon: Icon(_dream.isFavorite ? Icons.star : Icons.star_border),
            onPressed: _toggleFavorite,
            tooltip: l10n.tooltipFavorite,
          ),
          // 수정
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editDream,
            tooltip: l10n.tooltipEdit,
          ),
          // 삭제
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteDream,
            tooltip: l10n.tooltipDelete,
          ),
          // 더보기 메뉴
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: 8),
                    Text(l10n.share),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ai_analyze',
                child: Row(
                  children: [
                    const Icon(Icons.psychology),
                    const SizedBox(width: 8),
                    Text(l10n.aiAnalysis),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'ai_analyze') {
                _analyzeWithAI();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 및 자각도 카드
            DreamHeaderCardWidget(dream: _dream),
            const SizedBox(height: AppConstants.paddingM),

            // 제목 (있는 경우)
            if (_dream.title.isNotEmpty) ...[
              Text(
                _dream.title,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeXXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],

            // 내용
            DreamContentCardWidget(content: _dream.content),
            const SizedBox(height: AppConstants.paddingM),

            // 감정 및 기분
            if (_dream.emotions.isNotEmpty || _dream.moodScore != null) ...[
              DreamEmotionsCardWidget(
                emotions: _dream.emotions,
                moodScore: _dream.moodScore,
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],

            // Dream Signs (심볼, 인물, 장소)
            if (_dream.symbols.isNotEmpty ||
                _dream.characters.isNotEmpty ||
                _dream.locations.isNotEmpty) ...[
              DreamSignsCardWidget(
                symbols: _dream.symbols,
                characters: _dream.characters,
                locations: _dream.locations,
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],

            // 수면 정보
            if (_dream.sleepTime != null ||
                _dream.wakeTime != null ||
                _dream.sleepQuality != null) ...[
              DreamSleepInfoCardWidget(
                sleepTime: _dream.sleepTime,
                wakeTime: _dream.wakeTime,
                sleepDuration: _dream.sleepDuration,
                sleepQuality: _dream.sleepQuality,
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],

            // 사용한 기법
            if (_dream.techniquesUsed.isNotEmpty || _dream.usedWbtb) ...[
              DreamTechniquesCardWidget(
                usedWbtb: _dream.usedWbtb,
                techniquesUsed: _dream.techniquesUsed,
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],

            // 메타 정보
            DreamMetaInfoCardWidget(
              createdAt: _dream.createdAt,
              updatedAt: _dream.updatedAt,
              wordCount: _dream.wordCount,
              hasAiAnalysis: _dream.hasAiAnalysis,
            ),
          ],
        ),
      ),
    );
  }
}
