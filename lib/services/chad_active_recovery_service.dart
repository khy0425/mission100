import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rpe_data.dart';

/// Chad 액티브 리커버리 활동 타입
enum ActiveRecoveryType {
  lightMovement, // 가벼운 움직임
  stretching, // 스트레칭
  breathing, // 호흡 운동
  walking, // 산책
  mindfulness, // 마음챙김/명상
  rest, // 완전 휴식
}

/// Chad 액티브 리커버리 활동 데이터
class ActiveRecoveryActivity {
  final String id;
  final ActiveRecoveryType type;
  final String title;
  final String description;
  final String chadMessage;
  final String chadImagePath;
  final int durationMinutes;
  final List<String> instructions;
  final List<String> benefits;
  final int caloriesBurn; // 예상 칼로리 소모

  const ActiveRecoveryActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.chadMessage,
    required this.chadImagePath,
    required this.durationMinutes,
    required this.instructions,
    required this.benefits,
    required this.caloriesBurn,
  });
}

/// Chad 액티브 리커버리 관리 서비스
class ChadActiveRecoveryService extends ChangeNotifier {
  Map<String, dynamic> _personalizedData = {};
  RecoveryLevel _currentRecoveryLevel = RecoveryLevel.good;
  List<ActiveRecoveryActivity> _todayActivities = [];
  DateTime? _lastActivityDate;
  int _completedActivitiesCount = 0;

  Map<String, dynamic> get personalizedData => _personalizedData;
  RecoveryLevel get currentRecoveryLevel => _currentRecoveryLevel;
  List<ActiveRecoveryActivity> get todayActivities => _todayActivities;
  DateTime? get lastActivityDate => _lastActivityDate;
  int get completedActivitiesCount => _completedActivitiesCount;

  /// 서비스 초기화
  Future<void> initialize() async {
    await _loadPersonalizedData();
    await _loadRecoveryLevel();
    await _generateTodayActivities();
  }

  /// 개인화 데이터 로드
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

      debugPrint('Chad 액티브 리커버리: 개인화 데이터 로드 완료');
    } catch (e) {
      debugPrint('Chad 액티브 리커버리: 개인화 데이터 로드 실패: $e');
    }
  }

  /// 현재 회복 레벨 로드
  Future<void> _loadRecoveryLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recoveryScore = prefs.getInt('chad_last_recovery_score') ?? 75;
      _currentRecoveryLevel = RecoveryLevel.fromScore(recoveryScore);
    } catch (e) {
      debugPrint('Chad 액티브 리커버리: 회복 레벨 로드 실패: $e');
    }
  }

  /// 오늘의 Chad 액티브 리커버리 활동 생성
  Future<void> _generateTodayActivities() async {
    _todayActivities = [];

    // 회복 레벨에 따른 활동 선택
    switch (_currentRecoveryLevel) {
      case RecoveryLevel.excellent:
        _todayActivities = _getExcellentLevelActivities();
        break;
      case RecoveryLevel.good:
        _todayActivities = _getGoodLevelActivities();
        break;
      case RecoveryLevel.fair:
        _todayActivities = _getFairLevelActivities();
        break;
      case RecoveryLevel.poor:
        _todayActivities = _getPoorLevelActivities();
        break;
    }

    // 개인화 적용
    _applyPersonalizationToActivities();

    debugPrint('Chad 액티브 리커버리: 오늘의 활동 ${_todayActivities.length}개 생성');
    notifyListeners();
  }

  /// 회복 레벨별 활동 정의

  /// 최고 레벨 (80+점) - 가벼운 활동으로 컨디션 유지
  List<ActiveRecoveryActivity> _getExcellentLevelActivities() {
    return [
      ActiveRecoveryActivity(
        id: 'excellent_light_pushup',
        type: ActiveRecoveryType.lightMovement,
        title: 'Chad 가벼운 푸시업',
        description: '무릎 대고 천천히 하는 Chad 스타일 푸시업',
        chadMessage: "🔥 완벽한 컨디션이야! Chad와 가벼운 움직임으로 몸 풀어보자!",
        chadImagePath: "assets/images/기본차드.jpg",
        durationMinutes: 10,
        instructions: [
          '1. 무릎을 바닥에 대고 엎드려요',
          '2. 팔을 어깨 너비로 벌려요',
          '3. 천천히 5개씩 3세트',
          '4. 세트 간 1분 휴식',
        ],
        benefits: ['혈액순환 촉진', '관절 유연성 유지', '근육 활성화'],
        caloriesBurn: 30,
      ),
      ActiveRecoveryActivity(
        id: 'excellent_stretching',
        type: ActiveRecoveryType.stretching,
        title: 'Chad 상체 스트레칭',
        description: '어깨와 가슴 근육을 풀어주는 Chad 스트레칭',
        chadMessage: "💪 강한 너도 유연성이 중요해! Chad와 함께 몸을 풀어보자!",
        chadImagePath: "assets/images/기본차드.jpg",
        durationMinutes: 15,
        instructions: [
          '1. 양팔을 벽에 대고 가슴 스트레칭 (30초)',
          '2. 어깨 돌리기 앞뒤로 10회씩',
          '3. 목 좌우 스트레칭 (20초씩)',
          '4. 팔 십자 스트레칭 (30초씩)',
        ],
        benefits: ['근육 긴장 완화', '자세 개선', '부상 예방'],
        caloriesBurn: 25,
      ),
    ];
  }

  /// 좋음 레벨 (60-79점) - 적당한 활동
  List<ActiveRecoveryActivity> _getGoodLevelActivities() {
    return [
      ActiveRecoveryActivity(
        id: 'good_walking',
        type: ActiveRecoveryType.walking,
        title: 'Chad 산책 타임',
        description: 'Chad와 함께하는 가벼운 동네 산책',
        chadMessage: "⚡ 좋은 컨디션이네! Chad와 산책하면서 몸도 마음도 리프레시!",
        chadImagePath: "assets/images/기본차드.jpg",
        durationMinutes: 20,
        instructions: [
          '1. 편안한 속도로 20분간 걷기',
          '2. 중간중간 심호흡하기',
          '3. 주변 풍경 감상하며 걷기',
          '4. 물 한 컵 마시며 마무리',
        ],
        benefits: ['심혈관 건강', '스트레스 해소', '비타민 D 합성'],
        caloriesBurn: 80,
      ),
      ActiveRecoveryActivity(
        id: 'good_breathing',
        type: ActiveRecoveryType.breathing,
        title: 'Chad 호흡 운동',
        description: '4-7-8 호흡법으로 몸과 마음 진정시키기',
        chadMessage: "🧘‍♂️ Chad도 명상해! 깊게 숨쉬면서 에너지 충전하자!",
        chadImagePath: "assets/images/기본차드.jpg",
        durationMinutes: 10,
        instructions: [
          '1. 편안히 앉아 눈을 감아요',
          '2. 4초간 코로 숨을 들이마셔요',
          '3. 7초간 숨을 참아요',
          '4. 8초간 입으로 숨을 내쉬어요',
          '5. 5회 반복하세요',
        ],
        benefits: ['스트레스 감소', '집중력 향상', '수면 질 개선'],
        caloriesBurn: 10,
      ),
    ];
  }

  /// 보통 레벨 (40-59점) - 가벼운 회복 활동
  List<ActiveRecoveryActivity> _getFairLevelActivities() {
    return [
      ActiveRecoveryActivity(
        id: 'fair_gentle_stretch',
        type: ActiveRecoveryType.stretching,
        title: 'Chad 젠틀 스트레칭',
        description: '부드럽고 느린 전신 스트레칭',
        chadMessage: "😊 무리하지 말고 Chad와 천천히 몸을 풀어보자!",
        chadImagePath: "assets/images/기본차드.jpg",
        durationMinutes: 15,
        instructions: [
          '1. 목과 어깨 천천히 돌리기',
          '2. 팔과 다리 가볍게 흔들기',
          '3. 앉아서 허리 좌우로 비틀기',
          '4. 무릎 가슴으로 당기기',
        ],
        benefits: ['근육 이완', '혈액순환', '긴장 완화'],
        caloriesBurn: 20,
      ),
      ActiveRecoveryActivity(
        id: 'fair_mindfulness',
        type: ActiveRecoveryType.mindfulness,
        title: 'Chad 마음챙김',
        description: '현재 순간에 집중하는 Chad 스타일 명상',
        chadMessage: "🧘‍♂️ Chad와 함께 마음의 평화를 찾아보자!",
        chadImagePath: "assets/images/기본차드.jpg",
        durationMinutes: 10,
        instructions: [
          '1. 편안한 자세로 앉아요',
          '2. 자연스럽게 호흡해요',
          '3. 떠오르는 생각을 그냥 관찰해요',
          '4. 호흡에 다시 집중해요',
        ],
        benefits: ['정신 안정', '집중력 향상', '감정 조절'],
        caloriesBurn: 5,
      ),
    ];
  }

  /// 휴식 필요 레벨 (40점 미만) - 완전 휴식 중심
  List<ActiveRecoveryActivity> _getPoorLevelActivities() {
    return [
      ActiveRecoveryActivity(
        id: 'poor_rest',
        type: ActiveRecoveryType.rest,
        title: 'Chad 완전 휴식',
        description: 'Chad가 추천하는 완전한 휴식과 회복',
        chadMessage: "😴 Bro, 오늘은 완전 휴식이 최고야! Chad도 쉴 때는 확실히 쉬어!",
        chadImagePath: "assets/images/기본차드.jpg",
        durationMinutes: 30,
        instructions: [
          '1. 편안한 곳에 누워요',
          '2. 눈을 감고 몸의 긴장을 풀어요',
          '3. 깊고 느린 호흡을 해요',
          '4. 충분한 수분을 섭취해요',
        ],
        benefits: ['완전한 회복', '스트레스 해소', '에너지 재충전'],
        caloriesBurn: 0,
      ),
      ActiveRecoveryActivity(
        id: 'poor_gentle_breathing',
        type: ActiveRecoveryType.breathing,
        title: 'Chad 치유 호흡',
        description: '몸과 마음을 치유하는 Chad 호흡법',
        chadMessage: "💨 깊게 숨쉬어! Chad가 함께 회복 에너지를 충전해줄게!",
        chadImagePath: "assets/images/기본차드.jpg",
        durationMinutes: 8,
        instructions: [
          '1. 편안히 앉거나 누워요',
          '2. 배에 손을 올려요',
          '3. 배가 부풀도록 천천히 숨을 들이마셔요',
          '4. 더 천천히 숨을 내쉬어요',
        ],
        benefits: ['자율신경 안정', '회복 촉진', '스트레스 완화'],
        caloriesBurn: 5,
      ),
    ];
  }

  /// 개인화 적용
  void _applyPersonalizationToActivities() {
    final goal = _personalizedData['fitness_goal'] as String?;
    final level = _personalizedData['fitness_level'] as String?;

    for (int i = 0; i < _todayActivities.length; i++) {
      final activity = _todayActivities[i];
      String personalizedMessage = activity.chadMessage;

      // 목표별 개인화 메시지 추가
      switch (goal) {
        case 'weightLoss':
          personalizedMessage += "\n💡 체중감량 팁: 가벼운 활동도 칼로리 소모에 도움이 돼!";
          break;
        case 'muscleGain':
          personalizedMessage += "\n💪 근육 성장 팁: 휴식도 근육이 자라는 시간이야!";
          break;
        case 'endurance':
          personalizedMessage += "\n🏃‍♂️ 체력 향상 팁: 회복이 더 강한 체력을 만들어!";
          break;
        case 'general':
          personalizedMessage += "\n🌟 건강 관리 팁: 꾸준한 회복이 건강의 비결이야!";
          break;
      }

      // 피트니스 레벨별 조정
      switch (level) {
        case 'beginner':
          personalizedMessage += "\n🌱 초보자 응원: 천천히 해도 괜찮아! Chad가 응원해!";
          break;
        case 'intermediate':
          personalizedMessage += "\n⚡ 중급자 격려: 꾸준함이 실력이야! Chad와 함께 성장하자!";
          break;
        case 'advanced':
          personalizedMessage += "\n🚀 고급자 조언: 회복도 실력! Chad와 완벽한 밸런스 맞추자!";
          break;
      }

      // 개인화된 메시지로 업데이트 (새 객체 생성)
      _todayActivities[i] = ActiveRecoveryActivity(
        id: activity.id,
        type: activity.type,
        title: activity.title,
        description: activity.description,
        chadMessage: personalizedMessage,
        chadImagePath: activity.chadImagePath,
        durationMinutes: activity.durationMinutes,
        instructions: activity.instructions,
        benefits: activity.benefits,
        caloriesBurn: activity.caloriesBurn,
      );
    }
  }

  /// Chad 오늘의 회복 활동 추천 메시지
  String getTodayRecoveryRecommendation() {
    final goal = _personalizedData['fitness_goal'] as String?;

    String baseMessage = "안녕 Bro! Chad야! 💪\n";

    switch (_currentRecoveryLevel) {
      case RecoveryLevel.excellent:
        baseMessage += "완벽한 컨디션이네! 가벼운 활동으로 몸 상태 유지하자! 🔥";
        break;
      case RecoveryLevel.good:
        baseMessage += "좋은 상태야! Chad와 함께 적당한 회복 활동하자! ⚡";
        break;
      case RecoveryLevel.fair:
        baseMessage += "조금 지쳐 보이는데? Chad 가벼운 활동으로 회복하자! 😊";
        break;
      case RecoveryLevel.poor:
        baseMessage += "휴식이 많이 필요해 보여! Chad와 완전 회복 모드! 😴";
        break;
    }

    // 목표별 추가 메시지
    if (goal != null) {
      baseMessage += "\n\n";
      switch (goal) {
        case 'weightLoss':
          baseMessage += "체중감량 목표! 가벼운 활동도 칼로리 소모에 도움이 돼!";
          break;
        case 'muscleGain':
          baseMessage += "근육 증가 목표! 회복이 더 강한 근육을 만들어!";
          break;
        case 'endurance':
          baseMessage += "체력 향상 목표! 스마트한 회복이 지구력의 비결!";
          break;
        case 'general':
          baseMessage += "건강 관리 목표! 균형잡힌 회복이 건강의 핵심!";
          break;
      }
    }

    return baseMessage;
  }

  /// 활동 완료 처리
  Future<void> completeActivity(String activityId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _completedActivitiesCount++;
      _lastActivityDate = DateTime.now();

      await prefs.setInt(
          'chad_recovery_completed_count', _completedActivitiesCount);
      await prefs.setInt('chad_recovery_last_activity',
          _lastActivityDate!.millisecondsSinceEpoch);

      debugPrint('Chad 액티브 리커버리: 활동 "$activityId" 완료');
      notifyListeners();
    } catch (e) {
      debugPrint('Chad 액티브 리커버리: 활동 완료 저장 실패: $e');
    }
  }

  /// 회복 레벨 업데이트 (다른 서비스에서 호출)
  Future<void> updateRecoveryLevel(RecoveryLevel newLevel) async {
    if (_currentRecoveryLevel != newLevel) {
      _currentRecoveryLevel = newLevel;
      await _generateTodayActivities();
    }
  }

  /// 주간 액티브 리커버리 리포트
  String getWeeklyRecoveryReport() {
    return "이번 주 Chad 액티브 리커버리: $_completedActivitiesCount회 완료! 💪\n"
        "Chad가 분석한 결과: ${_getRecoveryPerformanceMessage()}";
  }

  String _getRecoveryPerformanceMessage() {
    if (_completedActivitiesCount >= 5) {
      return "완벽한 회복 관리! Chad도 감동했어! 🌟";
    } else if (_completedActivitiesCount >= 3) {
      return "좋은 회복 습관! Chad와 함께 더 발전하자! 👍";
    } else if (_completedActivitiesCount >= 1) {
      return "시작이 반이야! Chad가 더 도와줄게! 💪";
    } else {
      return "Chad와 함께 회복도 신경써보자! 😊";
    }
  }

  /// 내일 회복 활동 미리보기
  List<ActiveRecoveryActivity> getTomorrowPreview() {
    // 현재 회복 레벨 기준으로 내일 활동 미리보기
    return _todayActivities;
  }
}
