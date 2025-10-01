import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chad 컨디션 상태 열거형
enum ChadCondition {
  veryTired(0, '😴', '매우 피곤'),
  good(1, '😊', '좋음'),
  strong(2, '💪', '강함'),
  sweaty(3, '😅', '땀남'),
  onFire(4, '🥵', '불타는 중');

  const ChadCondition(this.score, this.emoji, this.koreanName);

  final int score;
  final String emoji;
  final String koreanName;
}

/// Chad 컨디션 관리 서비스
class ChadConditionService extends ChangeNotifier {
  ChadCondition? _currentCondition;
  DateTime? _lastConditionCheck;
  Map<String, dynamic> _personalizedData = {};

  ChadCondition? get currentCondition => _currentCondition;
  DateTime? get lastConditionCheck => _lastConditionCheck;
  Map<String, dynamic> get personalizedData => _personalizedData;

  /// 오늘 컨디션을 체크했는지 확인
  bool get hasCheckedToday {
    if (_lastConditionCheck == null) return false;
    final now = DateTime.now();
    final lastCheck = _lastConditionCheck!;
    return now.year == lastCheck.year &&
        now.month == lastCheck.month &&
        now.day == lastCheck.day;
  }

  /// 서비스 초기화
  Future<void> initialize() async {
    await _loadPersonalizedData();
    await _loadLastCondition();
  }

  /// 개인화 데이터 로드 (온보딩에서 수집한 데이터)
  Future<void> _loadPersonalizedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _personalizedData = {
        'fitness_goal': prefs.getString('fitness_goal'),
        'fitness_level': prefs.getString('fitness_level'),
        'current_weight': prefs.getDouble('current_weight'),
        'target_weight': prefs.getDouble('target_weight'),
        'workout_times': prefs.getStringList('workout_times'),
        'likes_competition': prefs.getBool('likes_competition'),
      };

      debugPrint('Chad 개인화 데이터 로드 완료: $_personalizedData');
    } catch (e) {
      debugPrint('Chad 개인화 데이터 로드 실패: $e');
    }
  }

  /// 마지막 컨디션 상태 로드
  Future<void> _loadLastCondition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conditionScore = prefs.getInt('last_chad_condition');
      final lastCheckTimestamp = prefs.getInt('last_condition_check');

      if (conditionScore != null) {
        _currentCondition = ChadCondition.values.firstWhere(
          (condition) => condition.score == conditionScore,
          orElse: () => ChadCondition.good,
        );
      }

      if (lastCheckTimestamp != null) {
        _lastConditionCheck =
            DateTime.fromMillisecondsSinceEpoch(lastCheckTimestamp);
      }
    } catch (e) {
      debugPrint('Chad 컨디션 로드 실패: $e');
    }
  }

  /// 컨디션 업데이트
  Future<void> updateCondition(ChadCondition condition) async {
    _currentCondition = condition;
    _lastConditionCheck = DateTime.now();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_chad_condition', condition.score);
      await prefs.setInt(
          'last_condition_check', _lastConditionCheck!.millisecondsSinceEpoch);

      debugPrint('Chad 컨디션 업데이트: ${condition.koreanName}');
      notifyListeners();
    } catch (e) {
      debugPrint('Chad 컨디션 저장 실패: $e');
    }
  }

  /// Chad의 개인화된 컨디션 체크 메시지
  String getChadConditionMessage() {
    final goal = _personalizedData['fitness_goal'] as String?;
    final level = _personalizedData['fitness_level'] as String?;

    String baseMessage = '안녕 Bro! Chad야! 💪\n';

    if (!hasCheckedToday) {
      baseMessage += '오늘 컨디션은 어때?\n';

      // 목표별 개인화 메시지
      switch (goal) {
        case 'weightLoss':
          baseMessage += '체중감량을 위해 Chad가 최적의 운동 강도를 맞춰줄게!';
          break;
        case 'muscleGain':
          baseMessage += '근육 증가를 위해 Chad가 완벽한 루틴을 짜줄게!';
          break;
        case 'endurance':
          baseMessage += '체력 향상을 위해 Chad가 맞춤 계획 세워줄게!';
          break;
        default:
          baseMessage += 'Chad가 너에게 맞는 운동을 추천해줄게!';
      }
    } else {
      baseMessage += _getConditionBasedMessage();
    }

    return baseMessage;
  }

  /// 현재 컨디션에 따른 Chad 메시지
  String _getConditionBasedMessage() {
    if (_currentCondition == null) return '컨디션을 체크해줘!';

    final goal = _personalizedData['fitness_goal'] as String?;

    switch (_currentCondition!) {
      case ChadCondition.veryTired:
        return '휴식이 필요해 보이네!\nChad가 가벼운 스트레칭 추천해줄게! 🧘‍♂️';

      case ChadCondition.good:
        switch (goal) {
          case 'weightLoss':
            return '좋은 컨디션이야!\nChad와 칼로리 태우러 가자! 🔥';
          case 'muscleGain':
            return '완벽한 상태네!\nChad와 근육 만들러 가자! 💪';
          default:
            return '좋은 컨디션이야!\nChad와 운동하러 가자!';
        }

      case ChadCondition.strong:
        return '엄청 강해 보이는데?\nChad도 더 강한 운동 준비했어! 🚀';

      case ChadCondition.sweaty:
        return '이미 땀이 나고 있네!\nChad가 워밍업은 짧게 갈게! 🏃‍♂️';

      case ChadCondition.onFire:
        return '완전 불타고 있네!\nChad도 Beast Mode로 갈게! 🔥💪';
    }
  }

  /// Chad 이미지 경로 (컨디션에 따라)
  String getChadImageForCondition() {
    if (_currentCondition == null) return 'assets/images/기본차드.jpg';

    switch (_currentCondition!) {
      case ChadCondition.veryTired:
        return 'assets/images/기본차드.jpg';
      case ChadCondition.good:
        return 'assets/images/기본차드.jpg';
      case ChadCondition.strong:
        return 'assets/images/기본차드.jpg';
      case ChadCondition.sweaty:
        return 'assets/images/기본차드.jpg';
      case ChadCondition.onFire:
        return 'assets/images/기본차드.jpg';
    }
  }

  /// 컨디션에 따른 오늘의 운동 추천
  String getTodayWorkoutRecommendation() {
    if (_currentCondition == null) return '컨디션을 먼저 체크해줘!';

    final level = _personalizedData['fitness_level'] as String?;

    switch (_currentCondition!) {
      case ChadCondition.veryTired:
        return '🧘‍♂️ Chad 액티브 리커버리\n• 가벼운 스트레칭 10분\n• 심호흡 운동\n• 충분한 휴식';

      case ChadCondition.good:
        switch (level) {
          case 'beginner':
            return '🎯 Chad 기본 루틴\n• 워밍업 5분\n• 푸시업 기본 세트\n• 마무리 스트레칭';
          case 'intermediate':
            return '💪 Chad 중급 루틴\n• 워밍업 5분\n• 푸시업 강화 세트\n• 코어 운동 추가';
          default:
            return '🚀 Chad 고급 루틴\n• 워밍업 10분\n• 푸시업 고강도 세트\n• 전신 운동 포함';
        }

      case ChadCondition.strong:
        return '💪 Chad 파워 루틴\n• 기본 루틴 + 20% 추가\n• 새로운 변형 동작\n• 강도 업그레이드';

      case ChadCondition.sweaty:
        return '🏃‍♂️ Chad 빠른 시작\n• 워밍업 단축\n• 바로 메인 운동\n• 효율적인 루틴';

      case ChadCondition.onFire:
        return '🔥 Chad Beast Mode\n• 최고 강도 운동\n• 도전적인 목표\n• 한계 돌파 세션';
    }
  }

  /// 컨디션 기록 초기화 (테스트/디버그용)
  Future<void> resetCondition() async {
    _currentCondition = null;
    _lastConditionCheck = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_chad_condition');
      await prefs.remove('last_condition_check');
      notifyListeners();
    } catch (e) {
      debugPrint('Chad 컨디션 초기화 실패: $e');
    }
  }
}
