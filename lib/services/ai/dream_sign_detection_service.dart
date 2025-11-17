import 'package:flutter/foundation.dart';
import '../../models/dream_entry.dart';
import '../../models/dream_sign.dart';
import '../../generated/l10n/app_localizations.dart';
import '../data/dream_journal_service.dart';

/// Dream Sign 자동 감지 및 패턴 분석 서비스
///
/// 출처:
/// - Tholey, P. (1983). "Techniques for inducing and manipulating lucid dreams"
/// - LaBerge, S. (1985). "Lucid Dreaming"
/// - Stumbrys et al. (2012). "Induction of lucid dreams: A systematic review"
///
/// 주요 기능:
/// 1. 꿈 내용에서 Dream Sign 자동 감지
/// 2. 반복 패턴 추적 (빈도 분석)
/// 3. 자각몽 유도 잠재력 계산
/// 4. Reality Check 훈련 제안
class DreamSignDetectionService {
  static final DreamSignDetectionService _instance =
      DreamSignDetectionService._internal();
  factory DreamSignDetectionService() => _instance;
  DreamSignDetectionService._internal();

  final DreamJournalService _journalService = DreamJournalService();

  /// 전체 꿈 일기에서 Dream Sign 패턴 분석
  Future<DreamSignAnalysisResult> analyzeAllDreams(
    String userId,
    AppLocalizations l10n,
  ) async {
    try {
      final dreams = await _journalService.getDreamsByUserId(userId);

      if (dreams.isEmpty) {
        return DreamSignAnalysisResult.empty();
      }

      // 모든 Dream Sign 수집
      final List<DreamSign> allSigns = [];
      for (final dream in dreams) {
        final signs = await detectDreamSigns(dream, l10n);
        allSigns.addAll(signs);
      }

      // 빈도 분석
      final frequencyMap = _analyzeFrequency(allSigns);

      // 카테고리별 분포
      final categoryDistribution = _analyzeCategoryDistribution(allSigns);

      // 자각몽 유도 잠재력이 높은 Dream Sign 추출
      final topPotentialSigns = _getTopPotentialSigns(frequencyMap);

      // 최근 트렌드 (최근 7일)
      final recentSigns = _getRecentSigns(allSigns, days: 7);

      debugPrint('✅ Dream Sign 분석 완료: 총 ${allSigns.length}개 감지');

      return DreamSignAnalysisResult(
        totalSignsDetected: allSigns.length,
        uniqueSignsCount: frequencyMap.length,
        frequencyMap: frequencyMap,
        categoryDistribution: categoryDistribution,
        topPotentialSigns: topPotentialSigns,
        recentSigns: recentSigns,
        analysisDate: DateTime.now(),
      );
    } catch (e) {
      debugPrint('❌ Dream Sign 분석 오류: $e');
      return DreamSignAnalysisResult.empty();
    }
  }

  /// 단일 꿈에서 Dream Sign 감지
  Future<List<DreamSign>> detectDreamSigns(
    DreamEntry dream,
    AppLocalizations l10n,
  ) async {
    final List<DreamSign> detectedSigns = [];

    // 1. ACTION - 비정상적 행동 감지
    final actionKeywords = l10n.dreamSignActionKeywords.split(',');

    for (final keyword in actionKeywords) {
      final trimmedKeyword = keyword.trim();
      if (dream.content.toLowerCase().contains(trimmedKeyword.toLowerCase()) ||
          dream.symbols.any((s) => s.toLowerCase().contains(trimmedKeyword.toLowerCase()))) {
        detectedSigns.add(DreamSign(
          id: 'sign_${dream.id}_action_$trimmedKeyword',
          category: DreamSignCategory.action,
          description: l10n.dreamSignActionDesc(trimmedKeyword),
          frequency: 1,
          firstSeen: dream.dreamDate,
          lastSeen: dream.dreamDate,
        ));
      }
    }

    // 2. FORM - 비정상적 형태 감지
    final formKeywords = l10n.dreamSignFormKeywords.split(',');

    for (final keyword in formKeywords) {
      final trimmedKeyword = keyword.trim();
      if (dream.content.toLowerCase().contains(trimmedKeyword.toLowerCase()) ||
          dream.characters.any((c) => c.toLowerCase().contains(trimmedKeyword.toLowerCase())) ||
          dream.locations.any((l) => l.toLowerCase().contains(trimmedKeyword.toLowerCase()))) {
        detectedSigns.add(DreamSign(
          id: 'sign_${dream.id}_form_$trimmedKeyword',
          category: DreamSignCategory.form,
          description: l10n.dreamSignFormDesc(trimmedKeyword),
          frequency: 1,
          firstSeen: dream.dreamDate,
          lastSeen: dream.dreamDate,
        ));
      }
    }

    // 3. CONTEXT - 비정상적 맥락 감지
    final contextKeywords = l10n.dreamSignContextKeywords.split(',');

    for (final keyword in contextKeywords) {
      final trimmedKeyword = keyword.trim();
      if (dream.content.toLowerCase().contains(trimmedKeyword.toLowerCase()) ||
          dream.locations.any((l) => l.toLowerCase().contains(trimmedKeyword.toLowerCase()))) {
        detectedSigns.add(DreamSign(
          id: 'sign_${dream.id}_context_$trimmedKeyword',
          category: DreamSignCategory.context,
          description: l10n.dreamSignContextDesc(trimmedKeyword),
          frequency: 1,
          firstSeen: dream.dreamDate,
          lastSeen: dream.dreamDate,
        ));
      }
    }

    // 4. AWARENESS - 자각 관련 표현 감지
    final awarenessKeywords = l10n.dreamSignAwarenessKeywords.split(',');

    for (final keyword in awarenessKeywords) {
      final trimmedKeyword = keyword.trim();
      if (dream.content.toLowerCase().contains(trimmedKeyword.toLowerCase())) {
        detectedSigns.add(DreamSign(
          id: 'sign_${dream.id}_awareness_$trimmedKeyword',
          category: DreamSignCategory.awareness,
          description: l10n.dreamSignAwarenessDesc(trimmedKeyword),
          frequency: 1,
          firstSeen: dream.dreamDate,
          lastSeen: dream.dreamDate,
        ));
      }
    }

    // 5. 사용자가 명시적으로 입력한 Symbols
    for (final symbol in dream.symbols) {
      // 중복 방지 (이미 키워드로 감지된 것 제외)
      if (!detectedSigns.any((s) => s.description.contains(symbol))) {
        detectedSigns.add(DreamSign(
          id: 'sign_${dream.id}_symbol_$symbol',
          category: _categorizeDreamSymbol(symbol, l10n),
          description: l10n.dreamSignSymbolDesc(symbol),
          frequency: 1,
          firstSeen: dream.dreamDate,
          lastSeen: dream.dreamDate,
        ));
      }
    }

    return detectedSigns;
  }

  /// Dream Sign 빈도 분석
  Map<String, DreamSignFrequency> _analyzeFrequency(List<DreamSign> signs) {
    final Map<String, DreamSignFrequency> frequencyMap = {};

    for (final sign in signs) {
      if (frequencyMap.containsKey(sign.description)) {
        final existing = frequencyMap[sign.description]!;
        frequencyMap[sign.description] = DreamSignFrequency(
          description: sign.description,
          category: sign.category,
          count: existing.count + 1,
          firstSeen: existing.firstSeen,
          lastSeen: sign.lastSeen,
          lucidityPotential: sign.category.lucidityPotential,
        );
      } else {
        frequencyMap[sign.description] = DreamSignFrequency(
          description: sign.description,
          category: sign.category,
          count: 1,
          firstSeen: sign.firstSeen,
          lastSeen: sign.lastSeen,
          lucidityPotential: sign.category.lucidityPotential,
        );
      }
    }

    return frequencyMap;
  }

  /// 카테고리별 분포 분석
  Map<DreamSignCategory, int> _analyzeCategoryDistribution(
      List<DreamSign> signs) {
    final Map<DreamSignCategory, int> distribution = {
      DreamSignCategory.awareness: 0,
      DreamSignCategory.action: 0,
      DreamSignCategory.form: 0,
      DreamSignCategory.context: 0,
    };

    for (final sign in signs) {
      distribution[sign.category] = (distribution[sign.category] ?? 0) + 1;
    }

    return distribution;
  }

  /// 자각몽 유도 잠재력이 높은 Dream Sign 추출
  List<DreamSignFrequency> _getTopPotentialSigns(
    Map<String, DreamSignFrequency> frequencyMap, {
    int limit = 10,
  }) {
    final signs = frequencyMap.values.toList();

    // 정렬: (빈도 × 자각몽 유도 잠재력)이 높은 순
    signs.sort((a, b) {
      final scoreA = a.count * a.lucidityPotential;
      final scoreB = b.count * b.lucidityPotential;
      return scoreB.compareTo(scoreA);
    });

    return signs.take(limit).toList();
  }

  /// 최근 Dream Sign 추출
  List<DreamSign> _getRecentSigns(List<DreamSign> signs, {int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return signs.where((s) => s.lastSeen.isAfter(cutoffDate)).toList();
  }

  /// Dream Symbol을 카테고리로 분류
  DreamSignCategory _categorizeDreamSymbol(String symbol, AppLocalizations l10n) {
    final symbolLower = symbol.toLowerCase();

    // Action 관련 (대표 키워드 일부 확인)
    final actionSample = l10n.dreamSignActionKeywords.split(',').take(5);
    for (final keyword in actionSample) {
      if (symbolLower.contains(keyword.trim().toLowerCase())) {
        return DreamSignCategory.action;
      }
    }

    // Form 관련 (대표 키워드 일부 확인)
    final formSample = l10n.dreamSignFormKeywords.split(',').take(5);
    for (final keyword in formSample) {
      if (symbolLower.contains(keyword.trim().toLowerCase())) {
        return DreamSignCategory.form;
      }
    }

    // Context 관련 (대표 키워드 일부 확인)
    final contextSample = l10n.dreamSignContextKeywords.split(',').take(5);
    for (final keyword in contextSample) {
      if (symbolLower.contains(keyword.trim().toLowerCase())) {
        return DreamSignCategory.context;
      }
    }

    // 기본값: Awareness
    return DreamSignCategory.awareness;
  }

  /// 반복되는 꿈 감지 (유사도 기반)
  ///
  /// 연구 근거: Zadra et al. (2006) - "Recurrent dreams: their relation to life events"
  Future<List<RecurringDreamPattern>> detectRecurringDreams(
      String userId) async {
    try {
      final dreams = await _journalService.getDreamsByUserId(userId);

      if (dreams.length < 2) {
        return [];
      }

      final List<RecurringDreamPattern> patterns = [];

      // 각 꿈을 다른 꿈들과 비교
      for (int i = 0; i < dreams.length; i++) {
        for (int j = i + 1; j < dreams.length; j++) {
          final similarity = _calculateDreamSimilarity(dreams[i], dreams[j]);

          // 유사도 60% 이상이면 반복 패턴으로 간주
          if (similarity >= 0.6) {
            patterns.add(RecurringDreamPattern(
              dream1: dreams[i],
              dream2: dreams[j],
              similarityScore: similarity,
              sharedElements: _getSharedElements(dreams[i], dreams[j]),
            ));
          }
        }
      }

      debugPrint('✅ 반복 꿈 패턴 ${patterns.length}개 감지');
      return patterns;
    } catch (e) {
      debugPrint('❌ 반복 꿈 감지 오류: $e');
      return [];
    }
  }

  /// 두 꿈 간 유사도 계산 (0.0 - 1.0)
  double _calculateDreamSimilarity(DreamEntry dream1, DreamEntry dream2) {
    double score = 0.0;
    int totalChecks = 0;

    // 1. Symbols 유사도 (가중치: 40%)
    final symbolSimilarity =
        _calculateListSimilarity(dream1.symbols, dream2.symbols);
    score += symbolSimilarity * 0.4;
    totalChecks++;

    // 2. Characters 유사도 (가중치: 30%)
    final characterSimilarity =
        _calculateListSimilarity(dream1.characters, dream2.characters);
    score += characterSimilarity * 0.3;
    totalChecks++;

    // 3. Locations 유사도 (가중치: 20%)
    final locationSimilarity =
        _calculateListSimilarity(dream1.locations, dream2.locations);
    score += locationSimilarity * 0.2;
    totalChecks++;

    // 4. Emotions 유사도 (가중치: 10%)
    final emotionSimilarity =
        _calculateListSimilarity(dream1.emotions, dream2.emotions);
    score += emotionSimilarity * 0.1;
    totalChecks++;

    return score;
  }

  /// 리스트 간 유사도 계산 (Jaccard similarity)
  double _calculateListSimilarity(List<String> list1, List<String> list2) {
    if (list1.isEmpty && list2.isEmpty) return 1.0;
    if (list1.isEmpty || list2.isEmpty) return 0.0;

    final set1 = Set<String>.from(list1);
    final set2 = Set<String>.from(list2);

    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;

    return intersection / union;
  }

  /// 공유 요소 추출
  List<String> _getSharedElements(DreamEntry dream1, DreamEntry dream2) {
    final sharedElements = <String>[];

    // Symbols
    final sharedSymbols =
        Set<String>.from(dream1.symbols).intersection(Set.from(dream2.symbols));
    sharedElements.addAll(sharedSymbols);

    // Characters
    final sharedCharacters = Set<String>.from(dream1.characters)
        .intersection(Set.from(dream2.characters));
    sharedElements.addAll(sharedCharacters);

    // Locations
    final sharedLocations = Set<String>.from(dream1.locations)
        .intersection(Set.from(dream2.locations));
    sharedElements.addAll(sharedLocations);

    return sharedElements;
  }

  /// Reality Check 훈련 제안 생성
  ///
  /// 연구 근거: Aspy et al. (2017) - "Reality testing and MILD for lucid dreams"
  Future<RealityCheckSuggestion> generateRealityCheckSuggestion(
    String userId,
    AppLocalizations l10n,
  ) async {
    try {
      final analysisResult = await analyzeAllDreams(userId, l10n);

      if (analysisResult.topPotentialSigns.isEmpty) {
        return RealityCheckSuggestion(
          message: l10n.dreamSignInsufficientData,
          targetSigns: [],
          recommendedFrequency: 5,
        );
      }

      // 가장 빈도가 높은 상위 3개 Dream Sign 추출
      final topSigns = analysisResult.topPotentialSigns.take(3).toList();

      // 제안 메시지 생성
      final signDescriptions = topSigns.map((s) => s.description).join(', ');
      final frequency = _calculateRecommendedFrequency(topSigns);
      final message =
          '${l10n.dreamSignRealityCheckIntro(signDescriptions)}\n\n'
          '${l10n.dreamSignRealityCheckInstructions}\n\n'
          '${l10n.dreamSignRealityCheckFrequency(frequency.toString())}';

      return RealityCheckSuggestion(
        message: message,
        targetSigns: topSigns,
        recommendedFrequency: frequency,
      );
    } catch (e) {
      debugPrint('❌ Reality Check 제안 생성 오류: $e');
      return RealityCheckSuggestion(
        message: l10n.dreamSignError,
        targetSigns: [],
        recommendedFrequency: 5,
      );
    }
  }

  /// 권장 Reality Check 빈도 계산
  int _calculateRecommendedFrequency(List<DreamSignFrequency> signs) {
    if (signs.isEmpty) return 5;

    // 평균 빈도에 비례하여 계산 (최소 5회, 최대 15회)
    final avgFrequency =
        signs.map((s) => s.count).reduce((a, b) => a + b) / signs.length;

    return (5 + avgFrequency * 2).clamp(5, 15).toInt();
  }
}

/// Dream Sign 분석 결과
class DreamSignAnalysisResult {
  final int totalSignsDetected; // 총 감지된 Dream Sign 수
  final int uniqueSignsCount; // 고유한 Dream Sign 수
  final Map<String, DreamSignFrequency> frequencyMap; // 빈도 맵
  final Map<DreamSignCategory, int> categoryDistribution; // 카테고리 분포
  final List<DreamSignFrequency> topPotentialSigns; // 상위 잠재력 Sign
  final List<DreamSign> recentSigns; // 최근 Sign
  final DateTime analysisDate; // 분석 일시

  const DreamSignAnalysisResult({
    required this.totalSignsDetected,
    required this.uniqueSignsCount,
    required this.frequencyMap,
    required this.categoryDistribution,
    required this.topPotentialSigns,
    required this.recentSigns,
    required this.analysisDate,
  });

  factory DreamSignAnalysisResult.empty() {
    return DreamSignAnalysisResult(
      totalSignsDetected: 0,
      uniqueSignsCount: 0,
      frequencyMap: {},
      categoryDistribution: {
        DreamSignCategory.awareness: 0,
        DreamSignCategory.action: 0,
        DreamSignCategory.form: 0,
        DreamSignCategory.context: 0,
      },
      topPotentialSigns: [],
      recentSigns: [],
      analysisDate: DateTime.now(),
    );
  }

  bool get hasData => totalSignsDetected > 0;
}

/// Dream Sign 빈도 데이터
class DreamSignFrequency {
  final String description;
  final DreamSignCategory category;
  final int count; // 출현 횟수
  final DateTime firstSeen;
  final DateTime lastSeen;
  final double lucidityPotential; // 자각몽 유도 잠재력

  const DreamSignFrequency({
    required this.description,
    required this.category,
    required this.count,
    required this.firstSeen,
    required this.lastSeen,
    required this.lucidityPotential,
  });

  /// 우선순위 점수 (빈도 × 잠재력)
  double get priorityScore => count * lucidityPotential;
}

/// 반복되는 꿈 패턴
class RecurringDreamPattern {
  final DreamEntry dream1;
  final DreamEntry dream2;
  final double similarityScore; // 유사도 (0.0 - 1.0)
  final List<String> sharedElements; // 공유 요소

  const RecurringDreamPattern({
    required this.dream1,
    required this.dream2,
    required this.similarityScore,
    required this.sharedElements,
  });

  /// 패턴 설명 (로컬라이제이션 지원)
  String getDescription(AppLocalizations l10n) {
    final elements = sharedElements.take(3).join(', ');
    final similarity = (similarityScore * 100).toStringAsFixed(0);
    return l10n.dreamSignPatternDesc(elements, similarity);
  }
}

/// Reality Check 훈련 제안
class RealityCheckSuggestion {
  final String message;
  final List<DreamSignFrequency> targetSigns;
  final int recommendedFrequency; // 권장 하루 횟수

  const RealityCheckSuggestion({
    required this.message,
    required this.targetSigns,
    required this.recommendedFrequency,
  });
}
