import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/assistant_feature.dart';

/// AI 어시스턴트 기능 헬퍼
///
/// 각 AI 기능에 대한 제목, 설명, 입력 레이블 등을 제공
class AssistantFeatureHelper {
  /// 기능별 제목
  static String getFeatureTitle(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalTitle;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueTitle;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationTitle;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckTitle;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatTitle;
    }
  }

  /// 기능별 부제목
  static String getFeatureSubtitle(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalSubtitle;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueSubtitle;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationSubtitle;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckSubtitle;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatSubtitle;
    }
  }

  /// 기능별 설명
  static String getFeatureDescription(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalDesc;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueDesc;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationDesc;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckDesc;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatDesc;
    }
  }

  /// 입력 필드 필요 여부
  static bool requiresInput(AssistantFeature feature) {
    return feature == AssistantFeature.dreamJournal ||
        feature == AssistantFeature.freeChat;
  }

  /// 입력 레이블
  static String getInputLabel(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalInputLabel;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueInputLabel;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationInputLabel;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckInputLabel;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatInputLabel;
    }
  }

  /// 입력 힌트
  static String getInputHint(AssistantFeature feature, AppLocalizations l10n) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return l10n.aiFeatureDreamJournalInputHint;
      case AssistantFeature.techniqueRecommendation:
        return l10n.aiFeatureTechniqueInputHint;
      case AssistantFeature.meditationScript:
        return l10n.aiFeatureMeditationInputHint;
      case AssistantFeature.realityCheck:
        return l10n.aiFeatureRealityCheckInputHint;
      case AssistantFeature.freeChat:
        return l10n.aiFeatureFreeChatInputHint;
    }
  }

  /// 기능별 이모지
  static String getFeatureEmoji(AssistantFeature feature) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return '📝';
      case AssistantFeature.techniqueRecommendation:
        return '💡';
      case AssistantFeature.meditationScript:
        return '🧘';
      case AssistantFeature.realityCheck:
        return '✋';
      case AssistantFeature.freeChat:
        return '💬';
    }
  }

  /// 기능별 색상
  static Color getFeatureColor(AssistantFeature feature) {
    switch (feature) {
      case AssistantFeature.dreamJournal:
        return Colors.blue;
      case AssistantFeature.techniqueRecommendation:
        return Colors.orange;
      case AssistantFeature.meditationScript:
        return Colors.purple;
      case AssistantFeature.realityCheck:
        return Colors.green;
      case AssistantFeature.freeChat:
        return Colors.teal;
    }
  }
}
