import 'package:flutter/material.dart';

/// 기법(Technique) 모델
///
/// DreamFlow - 자각몽 기법을 위한 모델

/// 기법 카테고리 (자각몽 전용)
enum TechniqueCategory {
  induction,     // 자각몽 유도 기법 (MILD, WILD, FILD, SSILD)
  awareness,     // 현실 인식 (Reality Check, Dream Signs)
  preparation,   // 준비 기법 (WBTB, 수면 스케줄)
  journaling,    // 꿈 일기
  stabilization, // 꿈 안정화 기법
  advanced,      // 고급 기법 (꿈 조종, 비행 등)
}

/// 기법 카테고리 확장 메서드
extension TechniqueCategoryExtension on TechniqueCategory {
  String get displayNameKo {
    switch (this) {
      case TechniqueCategory.induction:
        return '자각몽 유도';
      case TechniqueCategory.awareness:
        return '현실 인식';
      case TechniqueCategory.preparation:
        return '준비 기법';
      case TechniqueCategory.journaling:
        return '꿈 일기';
      case TechniqueCategory.stabilization:
        return '꿈 안정화';
      case TechniqueCategory.advanced:
        return '고급 기법';
    }
  }

  String get displayNameEn {
    switch (this) {
      case TechniqueCategory.induction:
        return 'Dream Induction';
      case TechniqueCategory.awareness:
        return 'Reality Awareness';
      case TechniqueCategory.preparation:
        return 'Preparation';
      case TechniqueCategory.journaling:
        return 'Dream Journal';
      case TechniqueCategory.stabilization:
        return 'Dream Stabilization';
      case TechniqueCategory.advanced:
        return 'Advanced Techniques';
    }
  }

  IconData get icon {
    switch (this) {
      case TechniqueCategory.induction:
        return Icons.nights_stay;
      case TechniqueCategory.awareness:
        return Icons.visibility;
      case TechniqueCategory.preparation:
        return Icons.alarm;
      case TechniqueCategory.journaling:
        return Icons.edit_note;
      case TechniqueCategory.stabilization:
        return Icons.lock;
      case TechniqueCategory.advanced:
        return Icons.auto_awesome;
    }
  }

  Color get color {
    switch (this) {
      case TechniqueCategory.induction:
        return const Color(0xFF7C4DFF); // 보라색 - 꿈 유도
      case TechniqueCategory.awareness:
        return const Color(0xFF00BCD4); // 시안 - 현실 인식
      case TechniqueCategory.preparation:
        return const Color(0xFFFF9800); // 주황 - 준비
      case TechniqueCategory.journaling:
        return const Color(0xFF4CAF50); // 초록 - 일기
      case TechniqueCategory.stabilization:
        return const Color(0xFF2196F3); // 파랑 - 안정화
      case TechniqueCategory.advanced:
        return const Color(0xFFE91E63); // 핑크 - 고급
    }
  }
}

/// 기법 단계
class TechniqueStep {
  final String title;
  final String titleKo;
  final String description;
  final String descriptionKo;
  final int? durationSeconds;
  final IconData? icon;

  const TechniqueStep({
    required this.title,
    required this.titleKo,
    required this.description,
    required this.descriptionKo,
    this.durationSeconds,
    this.icon,
  });
}

/// 기법 팁
class TechniqueTip {
  final String text;
  final String textKo;
  final IconData? icon;

  const TechniqueTip({
    required this.text,
    required this.textKo,
    this.icon,
  });
}

/// 기법 모델
class Technique {
  final String id;
  final String name;
  final String nameKo;
  final String shortDescription;
  final String shortDescriptionKo;
  final String fullDescription;
  final String fullDescriptionKo;
  final TechniqueCategory category;
  final List<TechniqueStep> steps;
  final List<TechniqueTip>? tips;
  final String? researchNote;
  final String? researchNoteKo;
  final int? totalDurationSeconds;
  final String? recommendedTime;
  final String? recommendedTimeKo;
  final bool isInteractive;

  const Technique({
    required this.id,
    required this.name,
    required this.nameKo,
    required this.shortDescription,
    required this.shortDescriptionKo,
    required this.fullDescription,
    required this.fullDescriptionKo,
    required this.category,
    required this.steps,
    this.tips,
    this.researchNote,
    this.researchNoteKo,
    this.totalDurationSeconds,
    this.recommendedTime,
    this.recommendedTimeKo,
    this.isInteractive = false,
  });

  Color get color => category.color;
  IconData get icon => category.icon;

  String get formattedDuration {
    if (totalDurationSeconds == null) return '';
    final minutes = totalDurationSeconds! ~/ 60;
    final seconds = totalDurationSeconds! % 60;
    if (minutes > 0) {
      return seconds > 0 ? '\$minutes분 \$seconds초' : '\$minutes분';
    }
    return '\$seconds초';
  }
}
