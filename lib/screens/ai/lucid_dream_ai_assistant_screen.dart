import 'package:flutter/material.dart';
import '../../services/ai/openrouter_proxy_service.dart';
import '../../generated/l10n/app_localizations.dart';

/// 자각몽 AI 어시스턴트 화면
///
/// OpenRouter를 활용한 다양한 자각몽 관련 AI 기능 제공
/// - 무료: 10회/일
/// - 프리미엄: 100회/일
class LucidDreamAIAssistantScreen extends StatefulWidget {
  const LucidDreamAIAssistantScreen({super.key});

  @override
  State<LucidDreamAIAssistantScreen> createState() =>
      _LucidDreamAIAssistantScreenState();
}

class _LucidDreamAIAssistantScreenState
    extends State<LucidDreamAIAssistantScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final OpenRouterProxyService _proxyService = OpenRouterProxyService();

  String _response = '';
  bool _isLoading = false;
  final String _selectedModel = 'google/gemini-2.0-flash-exp:free';

  // 사용량 정보
  int _usageCount = 0;
  int _dailyLimit = 10;
  int _remaining = 10;
  bool _isPremium = false;

  // 선택된 기능
  AssistantFeature? _selectedFeature;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String prompt) async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final result = await _proxyService.sendMessage(
        prompt: prompt,
        model: _selectedModel,
        maxTokens: 512,
      );

      setState(() {
        _response = result.response;
        _usageCount = result.usageCount;
        _dailyLimit = result.dailyLimit;
        _remaining = result.remaining;
        _isPremium = result.isPremium;
        _isLoading = false;
      });

      // 응답 영역으로 스크롤
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      // 사용량 경고 표시
      if (result.shouldShowWarning && mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.aiAssistantUsageWarning((result.usagePercentage * 100).toInt()),
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _useFeature(AssistantFeature feature) {
    setState(() {
      _selectedFeature = feature;
      _inputController.text = '';
      _response = '';
    });
  }

  void _executeFeature() {
    if (_selectedFeature == null) return;

    final input = _inputController.text.trim();
    final l10n = AppLocalizations.of(context);
    String prompt = '';

    switch (_selectedFeature!) {
      case AssistantFeature.dreamJournal:
        if (input.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.aiAssistantEmptyInput)),
          );
          return;
        }
        prompt = '''
You are a lucid dream expert. Please structure the following dream content into a structured dream journal:

"$input"

Please write in the following format:
1. Dream Title
2. Main Scenes (3-5 bullet points)
3. Emotional State
4. Dream Signs (Lucid Dream Signals)
5. Techniques to try next time

Please write concisely and practically.
''';
        break;

      case AssistantFeature.techniqueRecommendation:
        prompt = '''
You are a lucid dream expert.
Please recommend 3 effective lucid dream techniques for ${input.isEmpty ? 'beginners' : input}.

For each technique:
1. Technique Name
2. How to Execute (clear and simple)
3. Effectiveness & Success Rate
4. Precautions

Please explain specifically so that it can be applied in practice immediately.
''';
        break;

      case AssistantFeature.meditationScript:
        prompt = '''
You are a meditation expert.
Please write a ${input.isEmpty ? '5' : input} minute meditation script for inducing lucid dreams.

Elements to include:
- Relaxing breath guidance
- Body relaxation stages
- Visualization (entering the dream world)
- Strengthening awareness
- Positive affirmations

Please write in a warm and calm tone.
''';
        break;

      case AssistantFeature.realityCheck:
        prompt = '''
You are a lucid dream expert.
Please suggest 5 Reality Check ideas that can be practiced in daily life.

For each idea:
1. Specific situation/trigger
2. How to check
3. Characteristics that appear in dreams
4. Practice tips

Please suggest creative and practical ideas.
${input.isNotEmpty ? '\nPlease especially consider the following situation: $input' : ''}
''';
        break;

      case AssistantFeature.freeChat:
        if (input.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.aiAssistantEmptyQuestion)),
          );
          return;
        }
        prompt = '''
You are a lucid dream expert AI assistant.
Please answer the user's question kindly and professionally:

"$input"

Provide a balanced answer with scientific evidence and practical advice,
and write concisely and easy to understand.
''';
        break;
    }

    _sendMessage(prompt);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiAssistantTitle),
        backgroundColor: const Color(0xFF26A69A),
      ),
      body: Column(
        children: [
          // 사용량 표시
          _buildUsageIndicator(l10n),

          // 기능 선택 그리드
          if (_selectedFeature == null) ...[
            Expanded(
              child: _buildFeatureGrid(l10n),
            ),
          ] else ...[
            // 선택된 기능 실행 화면
            Expanded(
              child: _buildFeatureExecutionView(l10n),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUsageIndicator(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _isPremium ? Colors.purple[400]! : Colors.teal[400]!,
            _isPremium ? Colors.purple[600]! : Colors.teal[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            _isPremium ? Icons.workspace_premium : Icons.psychology,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isPremium ? l10n.aiAssistantPremium : l10n.aiAssistantFree,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  l10n.aiAssistantUsageToday(_usageCount, _dailyLimit, _remaining),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (_usageCount > 0)
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                value: _usageCount / _dailyLimit,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.aiAssistantQuestion,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildFeatureCard(
                AssistantFeature.dreamJournal,
                '📝',
                l10n.aiFeatureDreamJournalTitle,
                l10n.aiFeatureDreamJournalSubtitle,
                Colors.blue,
              ),
              _buildFeatureCard(
                AssistantFeature.techniqueRecommendation,
                '💡',
                l10n.aiFeatureTechniqueTitle,
                l10n.aiFeatureTechniqueSubtitle,
                Colors.orange,
              ),
              _buildFeatureCard(
                AssistantFeature.meditationScript,
                '🧘',
                l10n.aiFeatureMeditationTitle,
                l10n.aiFeatureMeditationSubtitle,
                Colors.purple,
              ),
              _buildFeatureCard(
                AssistantFeature.realityCheck,
                '✋',
                l10n.aiFeatureRealityCheckTitle,
                l10n.aiFeatureRealityCheckSubtitle,
                Colors.green,
              ),
              _buildFeatureCard(
                AssistantFeature.freeChat,
                '💬',
                l10n.aiFeatureFreeChatTitle,
                l10n.aiFeatureFreeChatSubtitle,
                Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    AssistantFeature feature,
    String emoji,
    String title,
    String subtitle,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _useFeature(feature),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureExecutionView(AppLocalizations l10n) {
    return Column(
      children: [
        // 선택된 기능 헤더
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.teal[50],
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _getFeatureTitle(_selectedFeature!, l10n),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedFeature = null;
                    _response = '';
                    _inputController.clear();
                  });
                },
              ),
            ],
          ),
        ),

        // 입력 및 결과 영역
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 설명
                Text(
                  _getFeatureDescription(_selectedFeature!, l10n),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),

                // 입력 필드
                if (_requiresInput(_selectedFeature!))
                  TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      labelText: _getInputLabel(_selectedFeature!, l10n),
                      hintText: _getInputHint(_selectedFeature!, l10n),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                const SizedBox(height: 16),

                // 실행 버튼
                ElevatedButton(
                  onPressed: _isLoading ? null : _executeFeature,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          l10n.aiAssistantGenerating,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 24),

                // AI 응답
                if (_response.isNotEmpty) ...[
                  Text(
                    l10n.aiAssistantResponse,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      _response,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getFeatureTitle(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalTitle;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueTitle;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationTitle;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckTitle;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatTitle;
    }
  }

  String _getFeatureDescription(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalDesc;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueDesc;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationDesc;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckDesc;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatDesc;
    }
  }

  bool _requiresInput(AssistantFeature feature) {
    return feature == AssistantFeature.dreamJournal ||
        feature == AssistantFeature.freeChat;
  }

  String _getInputLabel(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalInputLabel;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueInputLabel;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationInputLabel;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckInputLabel;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatInputLabel;
    }
  }

  String _getInputHint(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalInputHint;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueInputHint;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationInputHint;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckInputHint;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatInputHint;
    }
  }
}

enum AssistantFeature {
  dreamJournal,
  techniqueRecommendation,
  meditationScript,
  realityCheck,
  freeChat,
}
