import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/onboarding_step.dart';

/// 온보딩 플로우를 관리하는 서비스
class OnboardingService extends ChangeNotifier {
  static const String _onboardingProgressKey = 'onboarding_progress';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  OnboardingProgress _progress = const OnboardingProgress(
    status: OnboardingStatus.notStarted,
    currentStepIndex: 0,
    totalSteps: 0,
  );

  List<OnboardingStep> _steps = [];
  bool _isInitialized = false;

  /// 현재 온보딩 진행 상태
  OnboardingProgress get progress => _progress;

  /// 온보딩 스텝 목록
  List<OnboardingStep> get steps => List.unmodifiable(_steps);

  /// 현재 스텝
  OnboardingStep? get currentStep {
    if (_progress.currentStepIndex >= 0 &&
        _progress.currentStepIndex < _steps.length) {
      return _steps[_progress.currentStepIndex];
    }
    return null;
  }

  /// 다음 스텝
  OnboardingStep? get nextStepData {
    final nextIndex = _progress.currentStepIndex + 1;
    if (nextIndex >= 0 && nextIndex < _steps.length) {
      return _steps[nextIndex];
    }
    return null;
  }

  /// 이전 스텝
  OnboardingStep? get previousStepData {
    final prevIndex = _progress.currentStepIndex - 1;
    if (prevIndex >= 0 && prevIndex < _steps.length) {
      return _steps[prevIndex];
    }
    return null;
  }

  /// 첫 번째 스텝인지 확인
  bool get isFirstStep => _progress.currentStepIndex == 0;

  /// 마지막 스텝인지 확인
  bool get isLastStep => _progress.currentStepIndex == _steps.length - 1;

  /// 다음 스텝이 있는지 확인
  bool get hasNextStep => _progress.currentStepIndex < _steps.length - 1;

  /// 이전 스텝이 있는지 확인
  bool get hasPreviousStep => _progress.currentStepIndex > 0;

  /// 온보딩 완료 여부
  bool get isCompleted => _progress.isCompleted;

  /// 온보딩 진행 중 여부
  bool get isInProgress => _progress.isInProgress;

  /// 서비스 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    _initializeSteps();
    await _loadProgress();
    _isInitialized = true;
    notifyListeners();
  }

  /// 온보딩 스텝 초기화
  void _initializeSteps() {
    _steps = [
      const OnboardingStep(
        type: OnboardingStepType.welcome,
        title: 'DreamFlow에 오신 것을 환영합니다!',
        description:
            '60일 동안 자각몽 마스터를 목표로 하는 여정을 시작해보세요.\n과학적으로 검증된 프로그램으로 꿈의 세계를 정복하세요!',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '시작하기',
        canSkip: false,
      ),
      const OnboardingStep(
        type: OnboardingStepType.programIntroduction,
        title: '60일 과학 프로그램',
        description:
            '연구 기반 단계별 잠금 해제 시스템:\n\n🆓 Week 1-2 (무료): 꿈 일기 & 현실 확인\n💎 Week 3-4: WBTB + MILD (46% 성공률!)\n🌟 Week 5-6: SSILD + WILD 고급 기법\n👑 Week 7-9: 꿈 조종 & 마스터리\n\n주차가 올라갈수록 새로운 기법이 해금됩니다!',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '다음',
        canSkip: true,
      ),
      const OnboardingStep(
        type: OnboardingStepType.adaptiveTraining,
        title: '🎯 연습이 너무 힘들거나 쉽다면?',
        description: '걱정마세요! DreamFlow는 여러분의 피드백을 실시간으로 반영합니다.\n\n'
            '💬 연습 후 난이도를 알려주세요\n'
            '📊 너무 힘들었다면 → 다음엔 목표 ⬇️\n'
            '😊 너무 쉬웠다면 → 다음엔 목표 ⬆️\n\n'
            '당신에게 딱 맞는 프로그램으로 자동 조절해드려요!',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '똑똑하네요!',
        canSkip: true,
      ),
      const OnboardingStep(
        type: OnboardingStepType.chadEvolution,
        title: 'Dream Spirit 진화 시스템',
        description:
            '연습을 완료할 때마다 Dream Spirit이 진화합니다!\n\n👻 Sleepy Ghost → ✨ Aware Wisp → 🌟 Lucid Sprite → 🚶 Dream Walker → 🌌 Astral Traveler → 🔮 Oracle → 👑 Master of Dreams\n\n각 단계마다 새로운 Spirit 이미지와 업적을 해제하세요!',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '멋져요!',
        canSkip: true,
      ),
      const OnboardingStep(
        type: OnboardingStepType.initialTest,
        title: '자각몽 경험 조사',
        description:
            '현재 경험 수준을 확인하여 맞춤형 프로그램을 제공합니다.\n\n• 자각몽을 경험해본 적이 있나요?\n• 꿈을 얼마나 자주 기억하나요?\n• 결과에 따라 프로그램이 조정됩니다',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '시작하기',
        canSkip: false,
      ),

      // 목표 설정 단계들
      const OnboardingStep(
        type: OnboardingStepType.goalSetupWeight,
        title: '평균 수면 시간을 알려주세요',
        description:
            '수면 패턴에 맞춰 더 효과적인 자각몽 프로그램을 제공해드려요.\n\n일반적으로 7-9시간의 충분한 수면이 자각몽에 유리합니다.',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '다음',
        canSkip: true,
      ),

      const OnboardingStep(
        type: OnboardingStepType.goalSetupFitnessLevel,
        title: '자각몽 경험이 어느정도인가요?',
        description:
            '레벨에 맞는 프로그램 강도로 조절해드려요.\n\n• 초보자: 기초부터 차근차근\n• 중급자: 적당한 도전으로\n• 고급자: 고급 기법 훈련으로',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '다음',
        canSkip: true,
      ),

      const OnboardingStep(
        type: OnboardingStepType.goalSetupGoal,
        title: '주요 목표를 선택해주세요',
        description:
            '목표에 맞는 자각몽 프로그램과 팁을 제공해드려요.\n\n🌙 자각몽 첫 경험\n✨ 꿈 조종 능력 향상\n🧠 꿈 기억력 강화\n🌟 완전한 자각몽 마스터',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '다음',
        canSkip: true,
      ),

      const OnboardingStep(
        type: OnboardingStepType.goalSetupWorkoutTime,
        title: '주로 언제 취침하시나요?',
        description:
            '취침 시간에 맞춰 알림을 설정해드려요.\n\n현실 확인 리마인더와 WBTB 알람을 최적 시간에 제공합니다.',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '다음',
        canSkip: true,
      ),

      const OnboardingStep(
        type: OnboardingStepType.goalSetupMotivation,
        title: '어떤 방식이 더 동기부여가 되나요?',
        description:
            '선호하는 방식으로 맞춤형 격려와 도전을 제공해드려요.\n\n🏆 경쟁과 순위로 동기부여\n📈 개인 기록 향상에 집중',
        imagePath: 'assets/images/chad/basic/basicChad.png',
        buttonText: '다음',
        canSkip: true,
      ),

      const OnboardingStep(
        type: OnboardingStepType.goalSetupComplete,
        title: '🎉 맞춤형 프로그램 준비완료!',
        description:
            '당신만의 개인화된 DreamFlow가 준비되었습니다!\n\n• 60일 완성 프로그램\n• 개인 목표 기반 추천\n• 최적화된 알림 설정\n\n📊 연구 검증: 2주 훈련으로 17.4% 자각몽 성공!\n지금 2주 무료로 효과를 직접 확인해보세요! 🌙',
        imagePath: 'assets/images/character/stage0_sleepy_ghost.png',
        buttonText: '2주 무료 체험 시작',
        canSkip: true,
      ),
    ];

    _progress = _progress.copyWith(totalSteps: _steps.length);
  }

  /// 저장된 진행 상태 로드
  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 온보딩 완료 여부 확인 (이전 버전 호환성)
      final isCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;
      if (isCompleted) {
        _progress = _progress.copyWith(
          status: OnboardingStatus.completed,
          currentStepIndex: _steps.length,
          completedAt: DateTime.now(),
        );
        return;
      }

      // 상세 진행 상태 로드
      final progressJson = prefs.getString(_onboardingProgressKey);
      if (progressJson != null) {
        final progressData = jsonDecode(progressJson) as Map<String, dynamic>;
        _progress = OnboardingProgress.fromJson(progressData);
      }
    } catch (e) {
      debugPrint('온보딩 진행 상태 로드 오류: $e');
      // 오류 발생 시 기본 상태로 초기화
      _progress = OnboardingProgress(
        status: OnboardingStatus.notStarted,
        currentStepIndex: 0,
        totalSteps: _steps.length,
      );
    }
  }

  /// 진행 상태 저장
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 상세 진행 상태 저장
      final progressJson = jsonEncode(_progress.toJson());
      await prefs.setString(_onboardingProgressKey, progressJson);

      // 완료 여부 저장 (이전 버전 호환성)
      await prefs.setBool(_onboardingCompletedKey, _progress.isCompleted);
    } catch (e) {
      debugPrint('온보딩 진행 상태 저장 오류: $e');
    }
  }

  /// 온보딩 시작
  Future<void> startOnboarding() async {
    if (_progress.status == OnboardingStatus.completed) {
      return; // 이미 완료된 경우 시작하지 않음
    }

    _progress = _progress.copyWith(
      status: OnboardingStatus.inProgress,
      currentStepIndex: 0,
      startedAt: DateTime.now(),
    );

    await _saveProgress();
    notifyListeners();
  }

  /// 다음 스텝으로 이동
  Future<void> nextStep() async {
    if (!hasNextStep) {
      await completeOnboarding();
      return;
    }

    _progress = _progress.copyWith(
      currentStepIndex: _progress.currentStepIndex + 1,
    );

    await _saveProgress();
    notifyListeners();
  }

  /// 이전 스텝으로 이동
  Future<void> previousStep() async {
    if (!hasPreviousStep) return;

    _progress = _progress.copyWith(
      currentStepIndex: _progress.currentStepIndex - 1,
    );

    await _saveProgress();
    notifyListeners();
  }

  /// 특정 스텝으로 이동
  Future<void> goToStep(int stepIndex) async {
    if (stepIndex < 0 || stepIndex >= _steps.length) return;

    _progress = _progress.copyWith(
      currentStepIndex: stepIndex,
      status: OnboardingStatus.inProgress,
    );

    await _saveProgress();
    notifyListeners();
  }

  /// 온보딩 완료
  Future<void> completeOnboarding() async {
    debugPrint('🎯 온보딩 완료 처리 시작...');

    _progress = _progress.copyWith(
      status: OnboardingStatus.completed,
      currentStepIndex: _steps.length,
      completedAt: DateTime.now(),
    );

    await _saveProgress();

    // 추가로 간단한 완료 플래그도 저장 (안전장치)
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      await prefs.setBool('onboarding_definitely_completed', true); // 추가 안전장치
      debugPrint('✅ 온보딩 완료 상태 저장 완료');
    } catch (e) {
      debugPrint('❌ 온보딩 완료 상태 저장 오류: $e');
    }

    notifyListeners();
    debugPrint('🎯 온보딩 완료 처리 끝');
  }

  /// 온보딩 스킵
  Future<void> skipOnboarding() async {
    _progress = _progress.copyWith(
      status: OnboardingStatus.skipped,
      currentStepIndex: _steps.length,
      completedAt: DateTime.now(),
      wasSkipped: true,
    );

    await _saveProgress();
    notifyListeners();
  }

  /// 온보딩 재시작
  Future<void> resetOnboarding() async {
    _progress = OnboardingProgress(
      status: OnboardingStatus.notStarted,
      currentStepIndex: 0,
      totalSteps: _steps.length,
    );

    await _saveProgress();
    notifyListeners();
  }

  /// 온보딩 완료 여부 확인 (정적 메서드)
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 주요 완료 플래그 확인
      final isCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;

      // 추가 안전장치 플래그 확인
      final isDefinitelyCompleted =
          prefs.getBool('onboarding_definitely_completed') ?? false;

      // 상세 진행 상태에서도 확인
      bool isCompletedFromProgress = false;
      try {
        final progressJson = prefs.getString(_onboardingProgressKey);
        if (progressJson != null) {
          final progressData = jsonDecode(progressJson) as Map<String, dynamic>;
          final progress = OnboardingProgress.fromJson(progressData);
          isCompletedFromProgress = progress.isCompleted;
        }
      } catch (e) {
        debugPrint('온보딩 진행 상태 확인 중 오류: $e');
      }

      // 어느 하나라도 완료로 표시되어 있으면 완료로 처리
      final result =
          isCompleted || isDefinitelyCompleted || isCompletedFromProgress;
      debugPrint(
        '온보딩 완료 상태: $result (주요:$isCompleted, 안전장치:$isDefinitelyCompleted, 진행상태:$isCompletedFromProgress)',
      );

      return result;
    } catch (e) {
      debugPrint('온보딩 완료 여부 확인 오류: $e');
      return false;
    }
  }

  /// 현재 스텝이 스킵 가능한지 확인
  bool canSkipCurrentStep() {
    return currentStep?.canSkip ?? false;
  }

  /// 진행률 백분율 (0-100)
  double get progressPercentage => _progress.progressPercentage * 100;

  /// 남은 스텝 수
  int get remainingSteps => _steps.length - _progress.currentStepIndex;
}
