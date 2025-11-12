import 'package:flutter/material.dart';
import 'package:lucid_dream_100/generated/l10n/app_localizations.dart';

/// 챌린지 타입 (단기 미션 중심)
enum ChallengeType {
  // 🎯 일일 챌린지
  dailyPerfect, // 오늘 완벽한 운동
  // 🔥 주간 챌린지
  weeklyGoal, // 주간 목표 (예: 이번 주 5일 운동)
  // 💪 스킬 챌린지
  skillChallenge, // 특정 기술 도전 (예: 한 번에 30개)
  // 🚀 스프린트 챌린지
  sprintChallenge, // 짧은 기간 집중 (예: 3일 연속)
  // 🎪 이벤트 챌린지
  eventChallenge, // 특별 이벤트 (시즌별, 기념일 등)
}

/// 챌린지 난이도
enum ChallengeDifficulty {
  easy,
  medium,
  hard,
  extreme;

  String get emoji {
    switch (this) {
      case ChallengeDifficulty.easy:
        return '😊';
      case ChallengeDifficulty.medium:
        return '💪';
      case ChallengeDifficulty.hard:
        return '🔥';
      case ChallengeDifficulty.extreme:
        return '💀';
    }
  }

  /// @deprecated Use getChallengeDifficultyName(context, difficulty) instead for i18n support
  String get displayName {
    // 이 메서드는 더 이상 사용하지 마세요. getChallengeDifficultyName()을 사용하세요.
    switch (this) {
      case ChallengeDifficulty.easy:
        return 'Easy'; // 영어로 변경하여 하드코딩 최소화
      case ChallengeDifficulty.medium:
        return 'Medium';
      case ChallengeDifficulty.hard:
        return 'Hard';
      case ChallengeDifficulty.extreme:
        return 'Extreme';
    }
  }
}

/// 챌린지 상태
enum ChallengeStatus {
  available, // 참여 가능
  active, // 진행 중
  completed, // 완료
  failed, // 실패
  locked; // 잠김

  String get emoji {
    switch (this) {
      case ChallengeStatus.available:
        return '⭐';
      case ChallengeStatus.active:
        return '⚡';
      case ChallengeStatus.completed:
        return '✅';
      case ChallengeStatus.failed:
        return '❌';
      case ChallengeStatus.locked:
        return '🔒';
    }
  }

  /// @deprecated Use getChallengeStatusName(context, status) instead for i18n support
  String get displayName {
    // 이 메서드는 더 이상 사용하지 마세요. getChallengeStatusName()을 사용하세요.
    switch (this) {
      case ChallengeStatus.available:
        return 'Available'; // 영어로 변경하여 하드코딩 최소화
      case ChallengeStatus.active:
        return 'In Progress';
      case ChallengeStatus.completed:
        return 'Completed';
      case ChallengeStatus.failed:
        return 'Failed';
      case ChallengeStatus.locked:
        return 'Locked';
    }
  }
}

/// 챌린지 보상
class ChallengeReward {
  final String type; // 'badge', 'points', 'feature' 등
  final String value;
  final String description;

  const ChallengeReward({
    required this.type,
    required this.value,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {'type': type, 'value': value, 'description': description};
  }

  factory ChallengeReward.fromJson(Map<String, dynamic> json) {
    return ChallengeReward(
      type: json['type'] as String? ?? '',
      value: json['value'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class Challenge {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String difficultyKey;
  final int duration; // 일
  final int targetCount; // 목표 개수
  final List<String> milestones; // 마일스톤 설명 키들
  final String rewardKey;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final int currentProgress;

  // 새로운 필드들 추가
  final String? title;
  final String? description;
  final String? detailedDescription;
  final ChallengeType? type;
  final ChallengeDifficulty? difficulty;
  final int? targetValue;
  final String? targetUnit;
  final List<String>? prerequisites;
  final int? estimatedDuration;
  final List<ChallengeReward>? rewards;
  final String? iconPath;
  final ChallengeStatus? status;
  final DateTime? completionDate;
  final DateTime? lastUpdatedAt;

  const Challenge({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.difficultyKey,
    required this.duration,
    required this.targetCount,
    required this.milestones,
    required this.rewardKey,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.currentProgress,
    // 새로운 필드들
    this.title,
    this.description,
    this.detailedDescription,
    this.type,
    this.difficulty,
    this.targetValue,
    this.targetUnit,
    this.prerequisites,
    this.estimatedDuration,
    this.rewards,
    this.iconPath,
    this.status,
    this.completionDate,
    this.lastUpdatedAt,
  });

  /// 진행률 계산 (0.0 ~ 1.0)
  double get progressPercentage {
    if (targetCount == 0) return 0.0;
    return (currentProgress / targetCount).clamp(0.0, 1.0);
  }

  /// 완료 여부
  bool get isCompleted => endDate != null;

  /// 시작 가능 여부
  bool get isAvailable => startDate == null;

  /// 잠김 상태 여부
  bool get isLocked => !isActive;

  /// 실패 상태 여부
  bool get isFailed => false; // Assuming no failure status in the new model

  /// 시작 일시 (테스트 호환성을 위한 getter)
  DateTime? get startedAt => startDate;

  /// 남은 진행량
  int get remainingProgress =>
      (targetCount - currentProgress).clamp(0, targetCount);

  /// 경과 일수 (시작일로부터)
  int get daysSinceStart {
    if (startDate == null) return 0;
    return DateTime.now().difference(startDate!).inDays;
  }

  /// 남은 예상 일수
  int get estimatedDaysRemaining {
    if (isCompleted || (startDate == null && endDate == null)) return 0;
    final elapsed = daysSinceStart;
    return (duration - elapsed).clamp(0, duration);
  }

  Challenge copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? difficultyKey,
    int? duration,
    int? targetCount,
    List<String>? milestones,
    String? rewardKey,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int? currentProgress,
    String? title,
    String? description,
    String? detailedDescription,
    ChallengeType? type,
    ChallengeDifficulty? difficulty,
    int? targetValue,
    String? targetUnit,
    List<String>? prerequisites,
    int? estimatedDuration,
    List<ChallengeReward>? rewards,
    String? iconPath,
    ChallengeStatus? status,
    DateTime? completionDate,
    DateTime? lastUpdatedAt,
  }) {
    return Challenge(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      difficultyKey: difficultyKey ?? this.difficultyKey,
      duration: duration ?? this.duration,
      targetCount: targetCount ?? this.targetCount,
      milestones: milestones ?? this.milestones,
      rewardKey: rewardKey ?? this.rewardKey,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentProgress: currentProgress ?? this.currentProgress,
      title: title ?? this.title,
      description: description ?? this.description,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      targetValue: targetValue ?? this.targetValue,
      targetUnit: targetUnit ?? this.targetUnit,
      prerequisites: prerequisites ?? this.prerequisites,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      rewards: rewards ?? this.rewards,
      iconPath: iconPath ?? this.iconPath,
      status: status ?? this.status,
      completionDate: completionDate ?? this.completionDate,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'difficultyKey': difficultyKey,
      'duration': duration,
      'targetCount': targetCount,
      'milestones': milestones,
      'rewardKey': rewardKey,
      'isActive': isActive,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'currentProgress': currentProgress,
      'title': title,
      'description': description,
      'detailedDescription': detailedDescription,
      'type': type?.name,
      'difficulty': difficulty?.name,
      'targetValue': targetValue,
      'targetUnit': targetUnit,
      'prerequisites': prerequisites,
      'estimatedDuration': estimatedDuration,
      'rewards': rewards?.map((r) => r.toJson()).toList(),
      'iconPath': iconPath,
      'status': status?.name,
      'completionDate': completionDate?.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String? ?? '',
      titleKey: json['titleKey'] as String? ?? '',
      descriptionKey: json['descriptionKey'] as String? ?? '',
      difficultyKey: json['difficultyKey'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      targetCount: json['targetCount'] as int? ?? 0,
      milestones: List<String>.from(json['milestones'] as List? ?? []),
      rewardKey: json['rewardKey'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      currentProgress: json['currentProgress'] as int? ?? 0,
      title: json['title'] as String?,
      description: json['description'] as String?,
      detailedDescription: json['detailedDescription'] as String?,
      type: json['type'] != null
          ? ChallengeType.values.firstWhere(
              (e) => e.name == (json['type'] as String),
            )
          : null,
      difficulty: json['difficulty'] != null
          ? ChallengeDifficulty.values.firstWhere(
              (e) => e.name == (json['difficulty'] as String),
            )
          : null,
      targetValue: json['targetValue'] as int?,
      targetUnit: json['targetUnit'] as String?,
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'] as List)
          : null,
      estimatedDuration: json['estimatedDuration'] as int?,
      rewards: json['rewards'] != null
          ? (json['rewards'] as List)
              .map((r) => ChallengeReward.fromJson(r as Map<String, dynamic>))
              .toList()
          : null,
      iconPath: json['iconPath'] as String?,
      status: json['status'] != null
          ? ChallengeStatus.values.firstWhere(
              (e) => e.name == (json['status'] as String),
            )
          : null,
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Challenge && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Challenge(id: $id, title: $titleKey, status: ${isActive ? "Active" : "Inactive"}, progress: $currentProgress/$targetCount)';
  }
}

/// 챌린지 난이도별 확장 메서드
extension ChallengeDifficultyExtension on String {
  String get displayName {
    switch (this) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      case 'extreme':
        return 'Extreme';
      default:
        throw Exception('Unknown difficulty: $this');
    }
  }

  String get emoji {
    switch (this) {
      case 'easy':
        return '🟢';
      case 'medium':
        return '🟡';
      case 'hard':
        return '🟠';
      case 'extreme':
        return '🔴';
      default:
        throw Exception('Unknown difficulty: $this');
    }
  }
}

/// 챌린지 상태별 확장 메서드
extension ChallengeStatusExtension on bool {
  String get displayName {
    return this ? 'Active' : 'Inactive';
  }

  String get emoji {
    return this ? '🔥' : '🔒';
  }
}

/// 챌린지 난이도를 i18n 문자열로 변환하는 헬퍼 함수
String getChallengeDifficultyName(
  BuildContext context,
  ChallengeDifficulty difficulty,
) {
  final l10n = AppLocalizations.of(context);
  switch (difficulty) {
    case ChallengeDifficulty.easy:
      return l10n.difficultyEasy;
    case ChallengeDifficulty.medium:
      return l10n.difficultyMedium;
    case ChallengeDifficulty.hard:
      return l10n.difficultyHard;
    case ChallengeDifficulty.extreme:
      return l10n.difficultyExtreme;
  }
}

/// 챌린지 상태를 i18n 문자열로 변환하는 헬퍼 함수
String getChallengeStatusName(BuildContext context, ChallengeStatus status) {
  final l10n = AppLocalizations.of(context);
  switch (status) {
    case ChallengeStatus.available:
      return l10n.statusAvailable;
    case ChallengeStatus.active:
      return l10n.statusInProgress;
    case ChallengeStatus.completed:
      return l10n.statusCompleted;
    case ChallengeStatus.failed:
      return l10n.statusFailed;
    case ChallengeStatus.locked:
      return l10n.statusLocked;
  }
}
