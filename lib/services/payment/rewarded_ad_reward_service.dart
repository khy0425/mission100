import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/rewarded_ad_reward.dart';
import 'ad_service.dart';

/// 리워드 광고 보상 관리 서비스
class RewardedAdRewardService extends ChangeNotifier {
  static final RewardedAdRewardService _instance =
      RewardedAdRewardService._internal();
  factory RewardedAdRewardService() => _instance;
  RewardedAdRewardService._internal();

  static const String _storageKey = 'rewarded_ad_usage_records';

  final Map<RewardedAdType, RewardUsageRecord> _usageRecords = {};
  bool _isInitialized = false;

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _loadUsageRecords();
    _isInitialized = true;
    notifyListeners();
  }

  /// 사용 기록 로드
  Future<void> _loadUsageRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = prefs.getString(_storageKey);

      if (recordsJson != null) {
        final List<dynamic> recordsList = json.decode(recordsJson);
        _usageRecords.clear();

        for (final recordJson in recordsList) {
          final record = RewardUsageRecord.fromJson(recordJson);
          _usageRecords[record.type] = record;
        }
      }

      // 없는 타입은 기본값으로 초기화
      for (final type in RewardedAdType.values) {
        _usageRecords.putIfAbsent(
          type,
          () => RewardUsageRecord(type: type, usageCount: 0),
        );
      }

      debugPrint('✅ Loaded ${_usageRecords.length} reward usage records');
    } catch (e) {
      debugPrint('❌ Failed to load reward usage records: $e');
    }
  }

  /// 사용 기록 저장
  Future<void> _saveUsageRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsList =
          _usageRecords.values.map((record) => record.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(recordsList));
      debugPrint('✅ Saved ${recordsList.length} reward usage records');
    } catch (e) {
      debugPrint('❌ Failed to save reward usage records: $e');
    }
  }

  /// 특정 리워드 사용 가능 여부
  bool canUseReward(RewardedAdType type) {
    final record = _usageRecords[type];
    if (record == null) return true;

    final reward = _getReward(type);
    return record.canUse(reward);
  }

  /// 리워드 정보 가져오기
  RewardedAdReward _getReward(RewardedAdType type) {
    switch (type) {
      case RewardedAdType.dreamAnalysis:
        return RewardedAdReward.dreamAnalysis;
      case RewardedAdType.wbtbSkip:
        return RewardedAdReward.wbtbSkip;
      case RewardedAdType.evolutionBoost:
        return RewardedAdReward.evolutionBoost;
      case RewardedAdType.premiumPreview:
        return RewardedAdReward.premiumPreview;
      case RewardedAdType.specialSkin:
        return RewardedAdReward.specialSkin;
    }
  }

  /// 리워드 사용 기록 조회
  RewardUsageRecord? getUsageRecord(RewardedAdType type) {
    return _usageRecords[type];
  }

  /// 남은 사용 횟수
  int getRemainingUsage(RewardedAdType type) {
    final record = _usageRecords[type];
    final reward = _getReward(type);

    if (reward.maxUsage == -1) return 999; // 무제한
    if (record == null) return reward.maxUsage;

    return (reward.maxUsage - record.usageCount).clamp(0, reward.maxUsage);
  }

  /// 다음 사용 가능 시간
  DateTime? getNextAvailableTime(RewardedAdType type) {
    final record = _usageRecords[type];
    if (record == null) return null;

    final reward = _getReward(type);
    return record.getNextAvailableTime(reward);
  }

  /// 리워드 광고 시청 및 보상 지급
  Future<bool> watchAdAndReward(
    RewardedAdType type, {
    required Function() onRewardGranted,
    required Function(String error) onError,
  }) async {
    // 사용 가능 여부 확인
    if (!canUseReward(type)) {
      final nextTime = getNextAvailableTime(type);
      if (nextTime != null) {
        final remaining = nextTime.difference(DateTime.now());
        onError(
            '쿨다운 중입니다. ${remaining.inHours}시간 ${remaining.inMinutes % 60}분 후 다시 시도해주세요.');
      } else {
        onError('사용 가능 횟수를 모두 소진했습니다.');
      }
      return false;
    }

    // 리워드 광고 로드
    AdService().loadRewardedAd();

    // 광고 시청 대기 (실제로는 광고 로드 후 표시)
    await Future.delayed(const Duration(milliseconds: 500));

    // 광고 시청 성공 시 보상 지급
    bool rewardGranted = false;

    AdService().showRewardedAd((amount, adType) {
      // 광고 시청 성공 (adType은 String이므로 무시하고 메서드 파라미터 type 사용)
      rewardGranted = true;
      _grantReward(type);
      onRewardGranted();
    });

    // 광고가 로드되지 않았을 경우
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!rewardGranted) {
      onError('광고를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.');
      return false;
    }

    return true;
  }

  /// 보상 지급 (내부)
  void _grantReward(RewardedAdType type) {
    final record = _usageRecords[type];

    if (record != null) {
      _usageRecords[type] = RewardUsageRecord(
        type: type,
        usageCount: record.usageCount + 1,
        lastUsedAt: DateTime.now(),
      );
    } else {
      _usageRecords[type] = RewardUsageRecord(
        type: type,
        usageCount: 1,
        lastUsedAt: DateTime.now(),
      );
    }

    _saveUsageRecords();
    notifyListeners();

    debugPrint('✅ Granted reward: $type');
  }

  /// 리워드 강제 지급 (테스트/관리자용)
  Future<void> forceGrantReward(RewardedAdType type) async {
    _grantReward(type);
  }

  /// 리워드 사용 기록 초기화
  Future<void> resetUsageRecord(RewardedAdType type) async {
    _usageRecords[type] = RewardUsageRecord(type: type, usageCount: 0);
    await _saveUsageRecords();
    notifyListeners();
  }

  /// 모든 리워드 사용 기록 초기화
  Future<void> resetAllUsageRecords() async {
    _usageRecords.clear();
    for (final type in RewardedAdType.values) {
      _usageRecords[type] = RewardUsageRecord(type: type, usageCount: 0);
    }
    await _saveUsageRecords();
    notifyListeners();
  }
}
