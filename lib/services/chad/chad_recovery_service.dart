import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/rpe_data.dart';
import 'chad_condition_service.dart';

/// Chad 회복 점수 계산 서비스
class ChadRecoveryService extends ChangeNotifier {
  int _recoveryScore = 75; // 기본 점수
  RecoveryLevel _recoveryLevel = RecoveryLevel.good;
  DateTime? _lastCalculation;
  Map<String, dynamic> _personalizedData = {};
  List<RPEData> _recentRPEHistory = [];

  int get recoveryScore => _recoveryScore;
  RecoveryLevel get recoveryLevel => _recoveryLevel;
  DateTime? get lastCalculation => _lastCalculation;
  Map<String, dynamic> get personalizedData => _personalizedData;

  /// 서비스 초기화
  Future<void> initialize() async {
    await _loadPersonalizedData();
    await _loadRecoveryHistory();
    await _calculateRecoveryScore();
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

      debugPrint('Chad 회복 서비스: 개인화 데이터 로드 완료');
    } catch (e) {
      debugPrint('Chad 회복 서비스: 개인화 데이터 로드 실패: $e');
    }
  }

  /// 회복 기록 로드
  Future<void> _loadRecoveryHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastScore = prefs.getInt('chad_last_recovery_score');
      final lastCalculationTimestamp = prefs.getInt('chad_last_calculation');

      if (lastScore != null) {
        _recoveryScore = lastScore;
        _recoveryLevel = RecoveryLevel.fromScore(lastScore);
      }

      if (lastCalculationTimestamp != null) {
        _lastCalculation =
            DateTime.fromMillisecondsSinceEpoch(lastCalculationTimestamp);
      }

      // RPE 히스토리 로드 (최근 7일)
      await _loadRecentRPEHistory();
    } catch (e) {
      debugPrint('Chad 회복 서비스: 회복 기록 로드 실패: $e');
    }
  }

  /// 최근 RPE 히스토리 로드
  Future<void> _loadRecentRPEHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rpeHistoryJson = prefs.getStringList('rpe_history') ?? [];

      _recentRPEHistory = rpeHistoryJson
          .map((json) => RPEData.fromJson(_parseJson(json)))
          .where((rpe) {
        final daysDiff = DateTime.now().difference(rpe.timestamp).inDays;
        return daysDiff <= 7; // 최근 7일
      }).toList();

      debugPrint('Chad 회복 서비스: 최근 RPE 히스토리 ${_recentRPEHistory.length}개 로드');
    } catch (e) {
      debugPrint('Chad 회복 서비스: RPE 히스토리 로드 실패: $e');
    }
  }

  Map<String, dynamic> _parseJson(String jsonString) {
    // JSON 파싱 로직 (간단한 구현)
    // 실제로는 dart:convert를 사용해야 하지만, 여기서는 간단히 처리
    return {}; // 임시
  }

  /// Chad 회복 점수 계산 (메인 로직)
  Future<void> _calculateRecoveryScore() async {
    try {
      // 기본 점수는 75.0에서 시작하지만 변수가 필요없으므로 바로 계산에 사용

      // 1. RPE 기반 점수 조정 (50% 가중치)
      final double rpeScore = _calculateRPEScore();

      // 3. 컨디션 기반 점수 조정 (30% 가중치)
      final double conditionScore = await _calculateConditionScore();

      // 4. 개인화 점수 조정 (20% 가중치)
      final double personalizedScore = _calculatePersonalizedScore();

      // 5. 최종 점수 계산
      _recoveryScore =
          (rpeScore * 0.5 + conditionScore * 0.3 + personalizedScore * 0.2)
              .round();
      _recoveryScore = _recoveryScore.clamp(0, 100);

      // 6. 회복 레벨 결정
      _recoveryLevel = RecoveryLevel.fromScore(_recoveryScore);

      // 7. 계산 시간 기록
      _lastCalculation = DateTime.now();

      // 8. 저장
      await _saveRecoveryScore();

      debugPrint(
          'Chad 회복 점수 계산 완료: $_recoveryScore점 (${_recoveryLevel.label})');
      notifyListeners();
    } catch (e) {
      debugPrint('Chad 회복 점수 계산 실패: $e');
    }
  }

  /// RPE 기반 점수 계산 (50% 가중치)
  double _calculateRPEScore() {
    if (_recentRPEHistory.isEmpty) return 75.0; // 기본 점수

    // 최근 3회 운동의 평균 RPE
    final recentRPEs =
        _recentRPEHistory.take(3).map((rpe) => rpe.value).toList();
    if (recentRPEs.isEmpty) return 75.0;

    final averageRPE = recentRPEs.reduce((a, b) => a + b) / recentRPEs.length;

    // RPE에 따른 점수 계산 (RPE가 높을수록 회복 점수 낮음)
    double rpeScore;
    if (averageRPE <= 4) {
      rpeScore = 90.0; // 너무 쉬웠음 -> 회복 좋음
    } else if (averageRPE <= 6) {
      rpeScore = 80.0; // 적당함 -> 회복 좋음
    } else if (averageRPE <= 8) {
      rpeScore = 60.0; // 힘들었음 -> 회복 필요
    } else {
      rpeScore = 40.0; // 매우 힘들었음 -> 휴식 필요
    }

    return rpeScore;
  }

  /// 컨디션 기반 점수 계산 (30% 가중치)
  Future<double> _calculateConditionScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastConditionScore =
          prefs.getInt('last_chad_condition') ?? 1; // 기본값: 좋음

      // ChadCondition 점수를 회복 점수로 변환
      switch (lastConditionScore) {
        case 0: // veryTired (😴)
          return 30.0;
        case 1: // good (😊)
          return 75.0;
        case 2: // strong (💪)
          return 85.0;
        case 3: // sweaty (😅)
          return 70.0;
        case 4: // onFire (🥵)
          return 95.0;
        default:
          return 75.0;
      }
    } catch (e) {
      debugPrint('컨디션 점수 계산 실패: $e');
      return 75.0;
    }
  }

  /// 개인화 점수 조정 (20% 가중치)
  double _calculatePersonalizedScore() {
    double personalizedScore = 75.0;

    // 피트니스 레벨에 따른 조정
    final level = _personalizedData['fitness_level'] as String?;
    switch (level) {
      case 'beginner':
        personalizedScore += 5.0; // 초보자는 회복이 상대적으로 빠름
        break;
      case 'intermediate':
        personalizedScore += 0.0; // 기본
        break;
      case 'advanced':
        personalizedScore -= 5.0; // 고급자는 강도가 높아 회복이 느림
        break;
    }

    // 목표에 따른 조정
    final goal = _personalizedData['fitness_goal'] as String?;
    switch (goal) {
      case 'weightLoss':
        personalizedScore += 3.0; // 체중감량은 상대적으로 부담이 적음
        break;
      case 'muscleGain':
        personalizedScore -= 3.0; // 근증가는 회복 시간이 더 필요
        break;
      case 'endurance':
        personalizedScore += 2.0; // 지구력은 회복이 빠름
        break;
    }

    return personalizedScore.clamp(0, 100);
  }

  /// 회복 점수 저장
  Future<void> _saveRecoveryScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('chad_last_recovery_score', _recoveryScore);
      await prefs.setInt(
          'chad_last_calculation', _lastCalculation!.millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Chad 회복 점수 저장 실패: $e');
    }
  }

  /// Chad 회복 메시지 생성
  String getChadRecoveryMessage() {
    final goal = _personalizedData['fitness_goal'] as String?;

    String baseMessage =
        'Chad가 분석한 회복 점수: $_recoveryScore점! ${_recoveryLevel.emoji}\n';

    // 회복 레벨별 Chad 메시지
    switch (_recoveryLevel) {
      case RecoveryLevel.excellent:
        baseMessage += '완벽한 컨디션이야! Beast Mode 가보자! 🔥';
        break;
      case RecoveryLevel.good:
        baseMessage += '좋은 상태네! Chad와 오늘도 화이팅! 💪';
        break;
      case RecoveryLevel.fair:
        baseMessage += '괜찮은 상태야! 무리하지 말고 적당히 가자! 😊';
        break;
      case RecoveryLevel.poor:
        baseMessage += '휴식이 필요해 보여! Chad 액티브 리커버리 어때? 🧘‍♂️';
        break;
    }

    // 목표별 개인화 메시지 추가
    if (goal != null) {
      baseMessage += '\n';
      switch (goal) {
        case 'weightLoss':
          baseMessage += '체중감량 목표! Chad가 칼로리 소모 최적화해줄게!';
          break;
        case 'muscleGain':
          baseMessage += '근육 증가 목표! Chad가 회복 시간도 고려해줄게!';
          break;
        case 'endurance':
          baseMessage += '지구력 향상 목표! Chad가 지속가능한 강도로 갈게!';
          break;
        case 'general':
          baseMessage += '건강 관리 목표! Chad가 균형 잡힌 운동 추천해줄게!';
          break;
      }
    }

    return baseMessage;
  }

  /// Chad 이미지 경로 (회복 점수에 따라)
  String getChadImageForRecovery() {
    switch (_recoveryLevel) {
      case RecoveryLevel.excellent:
        return 'assets/images/기본차드.jpg'; // Beast Chad
      case RecoveryLevel.good:
        return 'assets/images/기본차드.jpg'; // Cool Chad
      case RecoveryLevel.fair:
        return 'assets/images/기본차드.jpg'; // Normal Chad
      case RecoveryLevel.poor:
        return 'assets/images/기본차드.jpg'; // Rest Chad
    }
  }

  /// 오늘의 운동 강도 추천
  WorkoutAdjustment getWorkoutAdjustment() {
    switch (_recoveryLevel) {
      case RecoveryLevel.excellent:
        return WorkoutAdjustment.increase(
          intensity: 1.15,
          reason: 'Chad 분석: 최고 컨디션! 강도 업그레이드 🚀',
        );
      case RecoveryLevel.good:
        return WorkoutAdjustment.maintain(
          reason: 'Chad 분석: 좋은 상태! 현재 강도 유지 💪',
        );
      case RecoveryLevel.fair:
        return WorkoutAdjustment.decrease(
          intensity: 0.9,
          reason: 'Chad 분석: 무리하지 말고 적당히 😊',
        );
      case RecoveryLevel.poor:
        return WorkoutAdjustment.decrease(
          intensity: 0.7,
          reason: 'Chad 분석: 휴식이 필요해! 가벼운 운동 🧘‍♂️',
        );
    }
  }

  /// RPE 데이터 추가 (운동 후 호출)
  Future<void> addRPEData(RPEData rpeData) async {
    _recentRPEHistory.insert(0, rpeData);

    // 최근 7일만 유지
    _recentRPEHistory = _recentRPEHistory.where((rpe) {
      final daysDiff = DateTime.now().difference(rpe.timestamp).inDays;
      return daysDiff <= 7;
    }).toList();

    // 회복 점수 재계산
    await _calculateRecoveryScore();
  }

  /// 컨디션 업데이트 (ChadConditionService와 연동)
  Future<void> updateFromCondition(ChadCondition condition) async {
    // 컨디션이 업데이트되면 회복 점수 재계산
    await _calculateRecoveryScore();
  }

  /// 수동으로 회복 점수 재계산
  Future<void> recalculateRecoveryScore() async {
    await _calculateRecoveryScore();
  }
}
