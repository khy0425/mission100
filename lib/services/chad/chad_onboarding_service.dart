import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chad가 진행하는 온보딩 서비스
class ChadOnboardingService extends ChangeNotifier {
  String _currentChadMessage = '';
  String _currentChadImage = 'assets/images/기본차드.jpg';
  final Map<String, dynamic> _collectedData = {};

  String get currentChadMessage => _currentChadMessage;
  String get currentChadImage => _currentChadImage;
  Map<String, dynamic> get collectedData => _collectedData;

  /// 온보딩 단계별 Chad 메시지 생성
  String getChadMessageForStep(String stepType) {
    switch (stepType) {
      case 'welcome':
        _currentChadMessage =
            '안녕 Bro! 나는 Chad야! 🔥\nMission: 100에서 너의 개인 트레이너가 될게!\n함께 6주 만에 100개 푸시업 도전해보자!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'programIntroduction':
        _currentChadMessage =
            'Chad가 특별히 설계한 6주 프로그램이야! 💪\n과학적으로 검증된 방법으로 너를 100개까지 이끌어줄게!\n준비됐어?';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'chadEvolution':
        _currentChadMessage =
            '운동할 때마다 Chad도 함께 진화해! 🚀\nRookie Chad → Giga Chad → Legendary Chad!\n너의 성장이 Chad의 성장이야!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'initialTest':
        _currentChadMessage =
            'Chad가 너의 현재 실력을 체크해볼게! 💯\n최대한 많이 해봐! 정확한 자세로!\nChad가 완벽한 계획 세워줄게!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'goalSetupWeight':
        _currentChadMessage =
            'Chad가 더 정확한 칼로리 계산을 위해 물어볼게! ⚖️\n현재 체중이 어떻게 돼?\n목표 체중도 있으면 Chad가 특별 계획 세워줄게!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'goalSetupFitnessLevel':
        _currentChadMessage =
            'Chad가 네 운동 경험을 알아야겠어! 🏋️‍♂️\n초보자면 Chad가 기초부터 차근차근!\n고급자면 Chad도 강도 높게 갈게!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'goalSetupGoal':
        _currentChadMessage =
            'Chad가 가장 중요하게 생각하는 질문이야! 🎯\n네 목표가 뭐야?\nChad가 그 목표에 맞는 완벽한 전략 짜줄게!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'goalSetupWorkoutTime':
        _currentChadMessage =
            'Chad가 네 스케줄에 맞춰줄게! ⏰\n언제 운동하는 게 좋아?\nChad가 딱 맞는 시간에 알림 보내줄게!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'goalSetupMotivation':
        _currentChadMessage =
            'Chad가 너를 어떻게 동기부여 해줄까? 🔥\n경쟁으로 불타오르는 타입?\n아니면 개인 기록 달성하는 타입?\nChad가 맞춰줄게!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      case 'goalSetupComplete':
        _currentChadMessage =
            'Perfect! Chad가 너만의 맞춤 프로그램 완성했어! 🎉\n이제 Chad AI 트레이너와 함께 Mission: 100 시작하자!\n1개월 무료로 Chad의 모든 기능을 체험해봐!';
        _currentChadImage = 'assets/images/기본차드.jpg';
        break;

      default:
        _currentChadMessage = 'Chad와 함께 해보자! 💪';
        _currentChadImage = 'assets/images/기본차드.jpg';
    }

    notifyListeners();
    return _currentChadMessage;
  }

  /// 온보딩 데이터 수집
  void collectData(String key, dynamic value) {
    _collectedData[key] = value;
    notifyListeners();
  }

  /// 목표별 Chad 개인화 메시지 생성
  String getPersonalizedChadMessage() {
    final goal = _collectedData['fitness_goal'] as String?;
    final level = _collectedData['fitness_level'] as String?;

    String message = 'Chad가 분석한 결과! 🧠\n';

    // 목표별 메시지
    switch (goal) {
      case 'weightLoss':
        message += '체중감량이 목표구나! Chad가 칼로리 폭탄 운동 준비했어! 🔥\n';
        break;
      case 'muscleGain':
        message += '근육 만들기가 목표네! Chad가 근력 강화 특훈 준비했어! 💪\n';
        break;
      case 'endurance':
        message += '체력 향상이 목표야! Chad가 지구력 끝판왕 만들어줄게! ⚡\n';
        break;
      case 'general':
        message += '전반적인 건강이 목표구나! Chad가 균형잡힌 프로그램 짰어! 🌟\n';
        break;
    }

    // 레벨별 메시지
    switch (level) {
      case 'beginner':
        message += '초보자니까 Chad가 기초부터 차근차근 가르쳐줄게!';
        break;
      case 'intermediate':
        message += '중급자네! Chad가 한 단계 업그레이드 시켜줄게!';
        break;
      case 'advanced':
        message += '고급자구나! Chad도 진짜 강도로 갈게!';
        break;
    }

    return message;
  }

  /// 회원가입 유도 Chad 메시지
  String getSignupMotivationMessage() {
    final goal = _collectedData['fitness_goal'] as String?;

    String baseMessage = 'Chad와 더 많은 시간 보내려면 계정이 필요해! 💝\n';

    switch (goal) {
      case 'weightLoss':
        baseMessage += 'Chad 칼로리 추적 + 체중 관리 기능까지!\n';
        break;
      case 'muscleGain':
        baseMessage += 'Chad 근력 분석 + 진화 보너스까지!\n';
        break;
      case 'endurance':
        baseMessage += 'Chad 지구력 측정 + 심박수 가이드까지!\n';
        break;
      default:
        baseMessage += 'Chad 전용 기능들이 기다리고 있어!\n';
    }

    baseMessage += '1개월 무료로 Chad와 함께 시작하자! 🚀';
    return baseMessage;
  }

  /// 온보딩 완료 후 즉시 개인화 적용
  Future<void> applyPersonalizationImmediately() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 수집된 데이터를 SharedPreferences에 저장
      for (final String key in _collectedData.keys) {
        final value = _collectedData[key];

        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }

      // Chad 개인화 활성화 플래그
      await prefs.setBool('chad_personalization_active', true);

      debugPrint('Chad 개인화 데이터 즉시 적용 완료: $_collectedData');
    } catch (e) {
      debugPrint('Chad 개인화 적용 오류: $e');
    }
  }

  /// Chad 온보딩 진행률 메시지
  String getProgressMessage(int currentStep, int totalSteps) {
    final progress = ((currentStep + 1) / totalSteps * 100).round();

    if (progress <= 25) {
      return 'Chad와 함께 시작한지 얼마 안됐네! 계속 가보자! 🔥';
    } else if (progress <= 50) {
      return 'Chad가 보기에 절반 왔어! 잘하고 있어! 💪';
    } else if (progress <= 75) {
      return 'Chad와 거의 다 왔네! 조금만 더! ⚡';
    } else {
      return 'Chad 설정 거의 끝! 곧 시작한다! 🚀';
    }
  }

  /// 데이터 초기화
  void resetData() {
    _collectedData.clear();
    _currentChadMessage = '';
    _currentChadImage = 'assets/images/기본차드.jpg';
    notifyListeners();
  }
}
