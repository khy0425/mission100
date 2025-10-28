import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chad_evolution.dart';
import '../models/progress.dart';
import '../services/notification_service.dart';
import 'chad_image_service.dart';
import 'package:flutter/material.dart';
import '../widgets/level_up_dialog.dart';

/// Chad 진화 시스템을 관리하는 서비스
class ChadEvolutionService extends ChangeNotifier {
  static const String _evolutionStateKey = 'chad_evolution_state';
  static const String _unlockedStagesKey = 'chad_unlocked_stages';

  // 레벨업 다이얼로그 표시를 위한 전역 컨텍스트
  static BuildContext? _globalContext;

  ChadEvolutionState _evolutionState = const ChadEvolutionState(
    currentStage: ChadEvolutionStage.sleepCapChad,
    unlockedStages: [],
    totalEvolutions: 0,
  );

  bool _isInitialized = false;

  /// 진화 애니메이션 표시 여부
  bool _showEvolutionAnimation = false;
  ChadEvolution? _evolutionFromChad;
  ChadEvolution? _evolutionToChad;

  /// 진화 애니메이션 상태
  bool get showEvolutionAnimation => _showEvolutionAnimation;
  ChadEvolution? get evolutionFromChad => _evolutionFromChad;
  ChadEvolution? get evolutionToChad => _evolutionToChad;

  /// 현재 Chad 진화 상태
  ChadEvolutionState get evolutionState => _evolutionState;

  /// 현재 Chad 정보
  ChadEvolution get currentChad => _evolutionState.currentChad;

  /// 다음 Chad 정보
  ChadEvolution? get nextChad => _evolutionState.nextChad;

  /// 진화 진행률 (0.0 ~ 1.0)
  double get evolutionProgress => getEvolutionProgress();

  /// 최종 진화 완료 여부
  bool get isMaxEvolution => _evolutionState.isMaxEvolution;

  /// 해제된 Chad 단계들
  List<ChadEvolution> get unlockedStages => _evolutionState.unlockedStages;

  /// 서비스 초기화
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('ChadEvolutionService 이미 초기화됨');
      return;
    }

    await _loadEvolutionState();
    _isInitialized = true;
    debugPrint('ChadEvolutionService 초기화 완료');
  }

  /// 진화 상태 새로고침 (호환성 메소드)
  Future<void> refreshEvolutionState() async {
    await _loadEvolutionState();
    notifyListeners();
    debugPrint('Chad 진화 상태 새로고침 완료');
  }

  /// 저장된 진화 상태 로드
  Future<void> _loadEvolutionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 진화 상태 로드
      final stateJson = prefs.getString(_evolutionStateKey);
      if (stateJson != null) {
        final stateData = jsonDecode(stateJson) as Map<String, dynamic>;
        _evolutionState = ChadEvolutionState.fromJson(stateData);
      } else {
        // 초기 상태 설정 (수면모자 Chad 해제)
        await _initializeDefaultState();
      }
    } catch (e) {
      debugPrint('Chad 진화 상태 로드 오류: $e');
      await _initializeDefaultState();
    }
  }

  /// 기본 상태 초기화
  Future<void> _initializeDefaultState() async {
    final initialChad = ChadEvolution.defaultStages.first.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );

    _evolutionState = ChadEvolutionState(
      currentStage: ChadEvolutionStage.sleepCapChad,
      unlockedStages: [initialChad],
      totalEvolutions: 0,
    );

    await _saveEvolutionState();
  }

  /// 진화 상태 저장
  Future<void> _saveEvolutionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final stateJson = jsonEncode(_evolutionState.toJson());
      await prefs.setString(_evolutionStateKey, stateJson);

      // 해제된 단계들도 별도 저장 (호환성)
      final unlockedJson = jsonEncode(
        _evolutionState.unlockedStages.map((e) => e.toJson()).toList(),
      );
      await prefs.setString(_unlockedStagesKey, unlockedJson);
    } catch (e) {
      debugPrint('Chad 진화 상태 저장 오류: $e');
    }
  }

  /// Chad 진화 상태 확인 및 업데이트
  Future<bool> checkAndUpdateChadLevel(Progress progress) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // 완료된 주차 수 계산
      int currentWeek = 0;
      for (int week = 1; week <= 6; week++) {
        final weekProgress = progress.weeklyProgress.firstWhere(
          (wp) => wp.week == week,
          orElse: () => WeeklyProgress(week: week),
        );

        if (weekProgress.isWeekCompleted) {
          currentWeek = week;
        } else {
          break; // 연속으로 완료되지 않은 주차가 있으면 중단
        }
      }

      final currentStage = _evolutionState.currentStage;

      // 현재 단계에서 진화 가능한지 확인
      ChadEvolution? nextEvolution;
      for (final chad in ChadEvolution.defaultStages) {
        if (chad.requiredWeek <= currentWeek &&
            chad.stage.index > currentStage.index &&
            !_evolutionState.unlockedStages.any(
              (unlocked) => unlocked.stage == chad.stage,
            )) {
          nextEvolution = chad;
          break;
        }
      }

      if (nextEvolution != null) {
        // 진화 전 Chad 정보 저장
        final fromChad = ChadEvolution.defaultStages.firstWhere(
          (chad) => chad.stage == currentStage,
        );

        // 진화 실행
        await _evolveToStage(nextEvolution.stage);

        // 애니메이션 트리거
        startEvolutionAnimation(fromChad, nextEvolution);

        // 알림 전송
        await _sendEvolutionNotification(nextEvolution);

        debugPrint(
          'Chad 진화 완료: ${currentStage.name} → ${nextEvolution.stage.name}',
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Chad 진화 확인 오류: $e');
      return false;
    }
  }

  /// 현재 주차 계산
  int _calculateCurrentWeek(Progress progress) {
    // 완료된 주차 수 계산
    int completedWeeks = 0;

    for (int week = 1; week <= 6; week++) {
      // weeklyProgress에서 해당 주차 찾기
      final weekProgress = progress.weeklyProgress.firstWhere(
        (wp) => wp.week == week,
        orElse: () => WeeklyProgress(week: week),
      );

      if (weekProgress.isWeekCompleted) {
        completedWeeks = week;
      } else {
        break; // 연속으로 완료되지 않은 주차가 있으면 중단
      }
    }

    return completedWeeks;
  }

  /// 특정 단계로 진화
  Future<ChadEvolution?> _evolveToStage(ChadEvolutionStage targetStage) async {
    try {
      // 목표 Chad 정보 가져오기
      final targetChad = ChadEvolution.defaultStages.firstWhere(
        (chad) => chad.stage == targetStage,
      );

      // 해제된 Chad 생성
      final unlockedChad = targetChad.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );

      // 상태 업데이트
      final updatedUnlockedStages = List<ChadEvolution>.from(
        _evolutionState.unlockedStages,
      );

      // 기존에 해제된 단계인지 확인
      final existingIndex = updatedUnlockedStages.indexWhere(
        (chad) => chad.stage == targetStage,
      );

      if (existingIndex >= 0) {
        updatedUnlockedStages[existingIndex] = unlockedChad;
      } else {
        updatedUnlockedStages.add(unlockedChad);
      }

      _evolutionState = _evolutionState.copyWith(
        currentStage: targetStage,
        unlockedStages: updatedUnlockedStages,
        lastEvolutionAt: DateTime.now(),
        totalEvolutions: _evolutionState.totalEvolutions + 1,
      );

      await _saveEvolutionState();
      notifyListeners();

      // 진화 알림 전송
      await _sendEvolutionNotification(unlockedChad);

      return unlockedChad;
    } catch (e) {
      debugPrint('Chad 진화 오류: $e');
      return null;
    }
  }

  /// 진화 알림 전송
  Future<void> _sendEvolutionNotification(ChadEvolution evolvedChad) async {
    try {
      // 알림 설정 확인
      final isEnabled = await isChadEvolutionNotificationEnabled();
      if (!isEnabled) {
        debugPrint('Chad 진화 알림이 비활성화되어 있습니다.');
        return;
      }

      // 최종 진화인지 확인
      if (evolvedChad.stage == ChadEvolutionStage.godChad) {
        await NotificationService.showChadFinalEvolutionNotification();
      } else {
        await NotificationService.showChadEvolutionNotification(
          evolvedChad.name,
          evolvedChad.unlockMessage,
        );
      }
    } catch (e) {
      debugPrint('Chad 진화 알림 전송 오류: $e');
    }
  }

  /// 진화 예고 알림 전송 (다음 진화까지 1주 남았을 때)
  Future<void> sendEvolutionPreviewNotification([Progress? progress]) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // 알림 설정 확인
      final isEnabled = await isChadEvolutionPreviewNotificationEnabled();
      if (!isEnabled) {
        debugPrint('Chad 진화 예고 알림이 비활성화되어 있습니다.');
        return;
      }

      final nextChad = _evolutionState.nextChad;
      if (nextChad != null) {
        final weeksLeft = getWeeksUntilNextEvolution(progress);
        if (weeksLeft == 1) {
          await NotificationService.showChadEvolutionPreview(
            nextChad.name,
            '$weeksLeft주 남음',
          );
        }
      }
    } catch (e) {
      debugPrint('Chad 진화 예고 알림 전송 오류: $e');
    }
  }

  /// 진화 격려 알림 전송 (진화 조건에 가까워졌을 때)
  Future<void> sendEvolutionEncouragementNotification([
    Progress? progress,
  ]) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // 알림 설정 확인
      final isEnabled = await isChadEvolutionEncouragementNotificationEnabled();
      if (!isEnabled) {
        debugPrint('Chad 진화 격려 알림이 비활성화되어 있습니다.');
        return;
      }

      final currentChad = _evolutionState.currentChad;
      final nextChad = _evolutionState.nextChad;

      if (nextChad != null) {
        final weeksLeft = getWeeksUntilNextEvolution(progress);
        final daysLeft = weeksLeft * 7; // 주를 일로 변환

        // 3일 남았을 때 격려 알림
        if (daysLeft == 3) {
          await NotificationService.showChadEvolutionEncouragement(
            '${currentChad.name}에서 ${nextChad.name}까지 $daysLeft일 남음! 화이팅!',
          );
        }
      }
    } catch (e) {
      debugPrint('Chad 진화 격려 알림 전송 오류: $e');
    }
  }

  /// 진화 상태 확인 및 알림 전송 (주기적 호출용)
  Future<void> checkAndSendProgressNotifications(Progress progress) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // 진화 예고 알림 확인
      await sendEvolutionPreviewNotification(progress);

      // 진화 격려 알림 확인
      await sendEvolutionEncouragementNotification(progress);

      // 실제 진화 확인 및 실행
      await checkAndUpdateChadLevel(progress);
    } catch (e) {
      debugPrint('Chad 진화 진행 상황 확인 오류: $e');
    }
  }

  /// 수동 진화 (테스트/디버그용)
  Future<ChadEvolution?> manualEvolveToStage(
    ChadEvolutionStage targetStage,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }

    return await _evolveToStage(targetStage);
  }

  /// 특정 단계가 해제되었는지 확인
  bool isStageUnlocked(ChadEvolutionStage stage) {
    return _evolutionState.unlockedStages.any((chad) => chad.stage == stage);
  }

  /// 특정 단계의 해제 시간 가져오기
  DateTime? getStageUnlockTime(ChadEvolutionStage stage) {
    final unlockedChad = _evolutionState.unlockedStages.firstWhere(
      (chad) => chad.stage == stage,
      orElse: () => ChadEvolution.defaultStages.first,
    );
    return unlockedChad.unlockedAt;
  }

  /// 진화 상태 리셋 (테스트/디버그용)
  Future<void> resetEvolution() async {
    await _initializeDefaultState();
    notifyListeners();
  }

  /// 모든 단계 해제 (테스트/디버그용)
  Future<void> unlockAllStages() async {
    final allUnlocked = ChadEvolution.defaultStages.map((chad) {
      return chad.copyWith(isUnlocked: true, unlockedAt: DateTime.now());
    }).toList();

    _evolutionState = _evolutionState.copyWith(
      currentStage: ChadEvolutionStage.godChad,
      unlockedStages: allUnlocked,
      totalEvolutions: ChadEvolution.defaultStages.length - 1,
      lastEvolutionAt: DateTime.now(),
    );

    await _saveEvolutionState();
    notifyListeners();
  }

  /// 진화 통계 정보
  Map<String, dynamic> getEvolutionStats() {
    return {
      'currentStage': _evolutionState.currentStage.toString().split('.').last,
      'currentStageName': currentChad.name,
      'totalEvolutions': _evolutionState.totalEvolutions,
      'unlockedStagesCount': _evolutionState.unlockedStages.length,
      'evolutionProgress': evolutionProgress,
      'isMaxEvolution': isMaxEvolution,
      'lastEvolutionAt': _evolutionState.lastEvolutionAt?.toIso8601String(),
    };
  }

  /// 진화 진행률 계산 (0.0 - 1.0)
  double getEvolutionProgress([Progress? progress]) {
    if (_evolutionState.currentStage == ChadEvolutionStage.godChad) {
      return 1.0; // 최종 단계는 100%
    }

    int currentWeek = 0;

    if (progress != null) {
      // 완료된 주차 수 계산
      for (int week = 1; week <= 6; week++) {
        final weekProgress = progress.weeklyProgress.firstWhere(
          (wp) => wp.week == week,
          orElse: () => WeeklyProgress(week: week),
        );

        if (weekProgress.isWeekCompleted) {
          currentWeek = week;
        } else {
          break; // 연속으로 완료되지 않은 주차가 있으면 중단
        }
      }
    } else {
      // Progress가 없으면 기본값 0 (처음 시작 상태)
      currentWeek = 0;
    }

    // 다음 단계가 있는지 확인
    final currentStageIndex = _evolutionState.currentStage.index;
    if (currentStageIndex >= ChadEvolutionStage.values.length - 1) {
      return 1.0; // 마지막 단계
    }

    final nextStage = ChadEvolutionStage.values[currentStageIndex + 1];
    final nextEvolution = ChadEvolution.defaultStages.firstWhere(
      (chad) => chad.stage == nextStage,
    );

    final currentStageWeek = ChadEvolution.defaultStages
        .firstWhere((chad) => chad.stage == _evolutionState.currentStage)
        .requiredWeek;

    // 현재 단계의 요구 주차를 아직 달성하지 못했으면 0%
    if (currentWeek < currentStageWeek) {
      return 0.0;
    }

    final progressInCurrentStage = currentWeek - currentStageWeek;
    final weeksNeededForNext = nextEvolution.requiredWeek - currentStageWeek;

    if (weeksNeededForNext <= 0) return 1.0;

    return (progressInCurrentStage / weeksNeededForNext).clamp(0.0, 1.0);
  }

  /// 다음 진화까지 남은 주차 계산
  int getWeeksUntilNextEvolution([Progress? progress]) {
    if (_evolutionState.currentStage == ChadEvolutionStage.godChad) {
      return 0; // 최종 단계
    }

    // Progress가 없으면 현재 단계에서 필요한 주차 반환
    if (progress == null) {
      final currentStageIndex = _evolutionState.currentStage.index;
      if (currentStageIndex >= ChadEvolutionStage.values.length - 1) {
        return 0;
      }

      final nextStage = ChadEvolutionStage.values[currentStageIndex + 1];
      final nextEvolution = ChadEvolution.defaultStages.firstWhere(
        (chad) => chad.stage == nextStage,
      );

      return nextEvolution.requiredWeek;
    }

    // 완료된 주차 수 계산
    int currentWeek = 0;
    for (int week = 1; week <= 6; week++) {
      final weekProgress = progress.weeklyProgress.firstWhere(
        (wp) => wp.week == week,
        orElse: () => WeeklyProgress(week: week),
      );

      if (weekProgress.isWeekCompleted) {
        currentWeek = week;
      } else {
        break; // 연속으로 완료되지 않은 주차가 있으면 중단
      }
    }

    // 다음 단계가 있는지 확인
    final currentStageIndex = _evolutionState.currentStage.index;
    if (currentStageIndex >= ChadEvolutionStage.values.length - 1) {
      return 0; // 마지막 단계
    }

    final nextStage = ChadEvolutionStage.values[currentStageIndex + 1];
    final nextEvolution = ChadEvolution.defaultStages.firstWhere(
      (chad) => chad.stage == nextStage,
    );

    final weeksLeft = nextEvolution.requiredWeek - currentWeek;
    return weeksLeft > 0 ? weeksLeft : 0;
  }

  /// 진화 애니메이션 시작
  void startEvolutionAnimation(ChadEvolution fromChad, ChadEvolution toChad) {
    _evolutionFromChad = fromChad;
    _evolutionToChad = toChad;
    _showEvolutionAnimation = true;
    notifyListeners();
  }

  /// 진화 애니메이션 완료
  void completeEvolutionAnimation() {
    _showEvolutionAnimation = false;
    _evolutionFromChad = null;
    _evolutionToChad = null;
    notifyListeners();
  }

  /// 다음 단계로 진화 (디버그/테스트용)
  Future<void> evolveToNextStage() async {
    final currentStage = _evolutionState.currentStage;
    final nextStageIndex = currentStage.index + 1;

    if (nextStageIndex < ChadEvolutionStage.values.length) {
      final nextStage = ChadEvolutionStage.values[nextStageIndex];
      await _evolveToStage(nextStage);
    }
  }

  /// Chad 진화 알림 설정 저장
  Future<void> setChadEvolutionNotificationEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('chad_evolution_notifications', enabled);
      debugPrint('Chad 진화 알림 설정: $enabled');
    } catch (e) {
      debugPrint('Chad 진화 알림 설정 저장 오류: $e');
    }
  }

  /// Chad 진화 알림 설정 가져오기
  Future<bool> isChadEvolutionNotificationEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('chad_evolution_notifications') ?? true; // 기본값: 활성화
    } catch (e) {
      debugPrint('Chad 진화 알림 설정 로드 오류: $e');
      return true;
    }
  }

  /// Chad 진화 예고 알림 설정 저장
  Future<void> setChadEvolutionPreviewNotificationEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('chad_evolution_preview_notifications', enabled);
      debugPrint('Chad 진화 예고 알림 설정: $enabled');
    } catch (e) {
      debugPrint('Chad 진화 예고 알림 설정 저장 오류: $e');
    }
  }

  /// Chad 진화 예고 알림 설정 가져오기
  Future<bool> isChadEvolutionPreviewNotificationEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('chad_evolution_preview_notifications') ??
          true; // 기본값: 활성화
    } catch (e) {
      debugPrint('Chad 진화 예고 알림 설정 로드 오류: $e');
      return true;
    }
  }

  /// Chad 진화 격려 알림 설정 저장
  Future<void> setChadEvolutionEncouragementNotificationEnabled(
    bool enabled,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
        'chad_evolution_encouragement_notifications',
        enabled,
      );
      debugPrint('Chad 진화 격려 알림 설정: $enabled');
    } catch (e) {
      debugPrint('Chad 진화 격려 알림 설정 저장 오류: $e');
    }
  }

  /// Chad 진화 격려 알림 설정 가져오기
  Future<bool> isChadEvolutionEncouragementNotificationEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('chad_evolution_encouragement_notifications') ??
          true; // 기본값: 활성화
    } catch (e) {
      debugPrint('Chad 진화 격려 알림 설정 로드 오류: $e');
      return true;
    }
  }

  /// 모든 Chad 진화 알림 설정 가져오기
  Future<Map<String, bool>> getAllChadEvolutionNotificationSettings() async {
    return {
      'evolution': await isChadEvolutionNotificationEnabled(),
      'preview': await isChadEvolutionPreviewNotificationEnabled(),
      'encouragement': await isChadEvolutionEncouragementNotificationEnabled(),
    };
  }

  /// Chad 이미지 가져오기 (최적화된 버전)
  Future<ImageProvider> getChadImage(
    ChadEvolutionStage stage, {
    int? targetSize,
  }) async {
    return await ChadImageService().getChadImage(stage, targetSize: targetSize);
  }

  /// 현재 Chad 이미지 가져오기
  Future<ImageProvider> getCurrentChadImage({int? targetSize}) async {
    return await getChadImage(
      _evolutionState.currentStage,
      targetSize: targetSize,
    );
  }

  /// 다음 Chad 이미지 가져오기 (진화 예고용)
  Future<ImageProvider?> getNextChadImage({int? targetSize}) async {
    final nextChad = _evolutionState.nextChad;
    if (nextChad != null) {
      return await getChadImage(nextChad.stage, targetSize: targetSize);
    }
    return null;
  }

  /// 다음 진화 이미지들 프리로드
  Future<void> preloadUpcomingImages({int? targetSize}) async {
    await ChadImageService().preloadUpcomingChadImages(
      _evolutionState.currentStage,
      targetSize: targetSize,
    );
  }

  /// 모든 Chad 이미지 프리로드 (앱 시작 시)
  Future<void> preloadAllImages({int? targetSize}) async {
    await ChadImageService().preloadAllChadImages(targetSize: targetSize);
  }

  /// 이미지 캐시 통계
  Map<String, dynamic> getImageCacheStats() {
    return ChadImageService().getCacheStats();
  }

  /// 이미지 캐시 크기 가져오기
  Future<int> getImageCacheSize() async {
    return await ChadImageService().getCacheSize();
  }

  /// 이미지 캐시 정리
  Future<void> clearImageCache({bool memoryOnly = false}) async {
    await ChadImageService().clearCache(memoryOnly: memoryOnly);
  }

  /// 메모리 압박 시 이미지 캐시 정리
  void onMemoryPressure() {
    ChadImageService().onMemoryPressure();
  }

  /// 전역 컨텍스트 설정 (레벨업 다이얼로그 표시용)
  static void setGlobalContext(BuildContext context) {
    _globalContext = context;
  }

  /// 현재 Chad 레벨 가져오기 (static 메서드)
  static Future<int> getCurrentLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('chad_level') ?? 1;
    } catch (e) {
      debugPrint('현재 레벨 로드 오류: $e');
      return 1;
    }
  }

  /// 현재 경험치 가져오기
  static Future<int> getCurrentExperience() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('chad_experience') ?? 0;
    } catch (e) {
      debugPrint('현재 경험치 로드 오류: $e');
      return 0;
    }
  }

  /// 경험치 추가
  static Future<void> addExperience(int amount) async {
    try {
      if (amount <= 0) return;

      final prefs = await SharedPreferences.getInstance();
      final currentXP = await getCurrentExperience();
      final newXP = currentXP + amount;

      await prefs.setInt('chad_experience', newXP);
      debugPrint('경험치 추가: $amount XP (총: $newXP XP)');

      // CloudSyncService에 변경사항 알림
      try {
        // import 'cloud_sync_service.dart'; 추가 필요
        // final cloudSyncService = CloudSyncService();
        // await cloudSyncService.onChadXPChanged();
      } catch (e) {
        debugPrint('클라우드 동기화 알림 오류: $e');
      }

      // 레벨업 확인
      await _checkLevelUp(newXP);
    } catch (e) {
      debugPrint('경험치 추가 오류: $e');
    }
  }

  /// 다음 레벨까지 필요한 경험치 계산
  static Future<int> getExperienceNeededForNextLevel(int currentLevel) async {
    // 레벨별 필요 경험치 (예: 100, 250, 450, 700, 1000, ...)
    final requiredXP = _calculateRequiredXP(currentLevel + 1);
    final currentXP = await getCurrentExperience();

    return (requiredXP - currentXP).clamp(0, double.infinity).toInt();
  }

  /// 레벨별 총 필요 경험치 계산
  static int _calculateRequiredXP(int level) {
    // 레벨 1: 0 XP (시작점)
    // 레벨 2: 100 XP
    // 레벨 3: 250 XP (150 추가)
    // 레벨 4: 450 XP (200 추가)
    // 레벨 5: 700 XP (250 추가)
    if (level <= 1) return 0;

    int totalXP = 0;
    for (int i = 2; i <= level; i++) {
      totalXP += 50 + (i * 50); // 점진적 증가
    }
    return totalXP;
  }

  /// 레벨업 확인 및 처리
  static Future<bool> _checkLevelUp(int currentXP) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentLevel = await getCurrentLevel();
      final requiredXP = _calculateRequiredXP(currentLevel + 1);

      if (currentXP >= requiredXP) {
        // 레벨업!
        final newLevel = currentLevel + 1;
        await prefs.setInt('chad_level', newLevel);

        debugPrint('🎉 레벨업! 레벨 $currentLevel → $newLevel');

        // 레벨업 다이얼로그 표시
        if (_globalContext != null && _globalContext!.mounted) {
          try {
            final rewardInfo = _getLevelUpReward(newLevel);
            showDialog(
              context: _globalContext!,
              barrierDismissible: false,
              builder: (context) => LevelUpDialog(
                oldLevel: currentLevel,
                newLevel: newLevel,
                rewardTitle: rewardInfo['title']!,
                rewardDescription: rewardInfo['description']!,
              ),
            );
          } catch (e) {
            debugPrint('레벨업 다이얼로그 표시 오류: $e');
          }
        }

        // 레벨업 알림 전송 (백그라운드용)
        try {
          await NotificationService.showChadEvolutionNotification(
            '레벨 $newLevel Chad',
            '업적을 통해 성장했습니다!',
          );
        } catch (e) {
          debugPrint('레벨업 알림 전송 오류: $e');
        }

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('레벨업 확인 오류: $e');
      return false;
    }
  }

  /// XP 진행률 계산 (현재 레벨에서 다음 레벨까지)
  static Future<double> getXPProgress() async {
    try {
      final currentLevel = await getCurrentLevel();
      final currentXP = await getCurrentExperience();

      final currentLevelRequiredXP = _calculateRequiredXP(currentLevel);
      final nextLevelRequiredXP = _calculateRequiredXP(currentLevel + 1);

      final xpInCurrentLevel = currentXP - currentLevelRequiredXP;
      final xpNeededForNextLevel = nextLevelRequiredXP - currentLevelRequiredXP;

      if (xpNeededForNextLevel <= 0) return 1.0;

      return (xpInCurrentLevel / xpNeededForNextLevel).clamp(0.0, 1.0);
    } catch (e) {
      debugPrint('XP 진행률 계산 오류: $e');
      return 0.0;
    }
  }

  /// 경험치 시스템 리셋 (디버그용)
  static Future<void> resetExperience() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('chad_level');
      await prefs.remove('chad_experience');
      debugPrint('경험치 시스템 리셋 완료');
    } catch (e) {
      debugPrint('경험치 시스템 리셋 오류: $e');
    }
  }

  /// 레벨별 보상 정보 반환
  static Map<String, String> _getLevelUpReward(int level) {
    switch (level) {
      case 2:
        return {
          'title': '🎯 기본 차드 해제!',
          'description': '첫 번째 진화 완료! 기본 차드가 되었습니다.',
        };
      case 3:
        return {
          'title': '☕ 커피 차드 해제!',
          'description': '카페인 파워 업! 더 강력한 운동이 가능합니다.',
        };
      case 5:
        return {
          'title': '🕶️ 선글라스 차드 해제!',
          'description': '쿨한 차드 모드 활성화! 스타일과 실력을 겸비했습니다.',
        };
      case 7:
        return {
          'title': '👀 레이저 차드 해제!',
          'description': '눈빔 차드 등장! 강력한 레이저로 모든 것을 파괴합니다!',
        };
      case 10:
        return {
          'title': '👥 더블 차드 해제!',
          'description': '최강의 더블 차드! 두 배의 파워로 무적 모드 돌입!',
        };
      case 15:
        return {
          'title': '🎖️ 마스터 차드 해제!',
          'description': '모든 차드의 정점! 전설적인 마스터 차드가 되었습니다!',
        };
      case 20:
        return {
          'title': '👑 레전드 차드 해제!',
          'description': '차드 중의 차드! 이제 누구도 당신을 막을 수 없습니다!',
        };
      default:
        if (level >= 25) {
          return {
            'title': '🌟 MEGA CHAD 모드!',
            'description': '한계를 초월한 MEGA CHAD! 우주적 파워를 손에 넣었습니다!',
          };
        } else {
          return {
            'title': '💪 파워 업 완료!',
            'description': '레벨 $level 차드로 진화! 더욱 강력해진 파워를 느껴보세요!',
          };
        }
    }
  }

  /// Chad 통계 계산 (Progress 데이터로부터)
  Future<ChadStats> calculateChadStats(Progress progress) async {
    try {
      final currentLevel = _evolutionState.currentStage.index;
      final streakDays = progress.consecutiveDays;
      final completedMissions = progress.totalWorkouts;
      final totalMinutes = progress.totalWorkouts * 30; // 평균 30분 가정
      final shareCount = 0; // TODO: 공유 기능 구현 시 실제 값 사용

      return ChadStats.fromWorkoutData(
        level: currentLevel,
        streakDays: streakDays,
        completedMissions: completedMissions,
        totalMinutes: totalMinutes,
        shareCount: shareCount,
      );
    } catch (e) {
      debugPrint('Chad 통계 계산 오류: $e');
      // 기본값 반환
      return const ChadStats(
        chadLevel: 1,
        brainjoltDegree: 1,
        chadAura: 0.0,
        jawlineSharpness: 0.0,
        crowdAdmiration: 0,
        brainjoltVoltage: 1000,
        memePower: 'COMMON',
        chadConsistency: 0,
        totalChadHours: 0,
      );
    }
  }

  /// 현재 Chad 통계 가져오기
  Future<ChadStats> getCurrentChadStats() async {
    try {
      // Progress 데이터 가져오기 (ProgressTrackerService 필요)
      // 여기서는 임시로 기본값 사용
      return const ChadStats(
        chadLevel: 1,
        brainjoltDegree: 1,
        chadAura: 0.0,
        jawlineSharpness: 0.0,
        crowdAdmiration: 0,
        brainjoltVoltage: 1000,
        memePower: 'COMMON',
        chadConsistency: 0,
        totalChadHours: 0,
      );
    } catch (e) {
      debugPrint('현재 Chad 통계 가져오기 오류: $e');
      return const ChadStats(
        chadLevel: 1,
        brainjoltDegree: 1,
        chadAura: 0.0,
        jawlineSharpness: 0.0,
        crowdAdmiration: 0,
        brainjoltVoltage: 1000,
        memePower: 'COMMON',
        chadConsistency: 0,
        totalChadHours: 0,
      );
    }
  }
}
