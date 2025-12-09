import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// 햅틱 피드백 서비스
///
/// 다양한 사용자 액션에 따른 진동 피드백 제공
/// - 체크리스트 완료: 가벼운 진동
/// - 스테이지 업: 강한 진동
/// - 에러: 오류 진동
class HapticFeedbackService {
  static final HapticFeedbackService _instance = HapticFeedbackService._internal();
  factory HapticFeedbackService() => _instance;
  HapticFeedbackService._internal();

  bool _isEnabled = true;

  /// 햅틱 피드백 활성화/비활성화
  bool get isEnabled => _isEnabled;
  set isEnabled(bool value) {
    _isEnabled = value;
    debugPrint('햅틱 피드백 ${value ? "활성화" : "비활성화"}');
  }

  /// 가벼운 탭 피드백 (버튼 탭, 토글 등)
  Future<void> lightTap() async {
    if (!_isEnabled) return;
    await HapticFeedback.lightImpact();
    debugPrint('👆 가벼운 햅틱 피드백');
  }

  /// 중간 탭 피드백 (중요 액션)
  Future<void> mediumTap() async {
    if (!_isEnabled) return;
    await HapticFeedback.mediumImpact();
    debugPrint('👆 중간 햅틱 피드백');
  }

  /// 강한 탭 피드백 (중요 성취)
  Future<void> heavyTap() async {
    if (!_isEnabled) return;
    await HapticFeedback.heavyImpact();
    debugPrint('👆 강한 햅틱 피드백');
  }

  /// 선택 피드백 (체크박스, 라디오 버튼 등)
  Future<void> selectionClick() async {
    if (!_isEnabled) return;
    await HapticFeedback.selectionClick();
    debugPrint('👆 선택 햅틱 피드백');
  }

  /// 진동 피드백 (알림, 경고 등)
  Future<void> vibrate() async {
    if (!_isEnabled) return;
    await HapticFeedback.vibrate();
    debugPrint('📳 진동 피드백');
  }

  // ========== 특수 피드백 패턴 ==========

  /// 체크리스트 항목 완료 피드백
  Future<void> checklistItemCompleted() async {
    if (!_isEnabled) return;
    await HapticFeedback.lightImpact();
    debugPrint('✅ 체크리스트 완료 햅틱');
  }

  /// 일일 체크리스트 전체 완료 피드백 (보상 획득)
  Future<void> dailyChecklistCompleted() async {
    if (!_isEnabled) return;

    // 세 번의 짧은 진동 패턴
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
    debugPrint('🎉 일일 완료 햅틱 피드백');
  }

  /// 스테이지 업 피드백 (레벨업)
  Future<void> stageUp() async {
    if (!_isEnabled) return;

    // 강한 진동 + 짧은 딜레이 + 강한 진동 (축하 패턴)
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
    debugPrint('🎊 스테이지 업 햅틱 피드백');
  }

  /// 마일스톤 달성 피드백 (스트릭 마일스톤 등)
  Future<void> milestoneAchieved() async {
    if (!_isEnabled) return;

    // 두 번의 강한 진동
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.heavyImpact();
    debugPrint('🏆 마일스톤 달성 햅틱 피드백');
  }

  /// 토큰 획득 피드백
  Future<void> tokenEarned() async {
    if (!_isEnabled) return;
    await HapticFeedback.mediumImpact();
    debugPrint('🪙 토큰 획득 햅틱 피드백');
  }

  /// XP 획득 피드백
  Future<void> xpEarned() async {
    if (!_isEnabled) return;
    await HapticFeedback.lightImpact();
    debugPrint('⚡ XP 획득 햅틱 피드백');
  }

  /// 에러 피드백
  Future<void> error() async {
    if (!_isEnabled) return;

    // 짧은 진동 두 번
    await HapticFeedback.vibrate();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.vibrate();
    debugPrint('❌ 에러 햅틱 피드백');
  }

  /// 경고 피드백
  Future<void> warning() async {
    if (!_isEnabled) return;
    await HapticFeedback.vibrate();
    debugPrint('⚠️ 경고 햅틱 피드백');
  }

  /// 성공 피드백
  Future<void> success() async {
    if (!_isEnabled) return;

    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
    debugPrint('✅ 성공 햅틱 피드백');
  }
}
