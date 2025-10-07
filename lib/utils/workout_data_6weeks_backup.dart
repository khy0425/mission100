import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/exercise_type.dart';

/// 🏋️ Mission100 운동 데이터 구조 (과학적 근거 기반)
///
/// 참고 논문:
/// - Schoenfeld et al. (2016, 2019): 주 3회 훈련, 48시간 회복
/// - Grgic et al. (2018): 60-120초 세트간 휴식
/// - Plotkin et al. (2022): 반복 증가 방식 효과적
/// - Wang et al. (2024): HIIT + 저항 운동 병행 효과

/// 운동 세트 정보 (하위 호환성 유지)
class ExerciseSet {
  final ExerciseType type;
  final int reps;

  const ExerciseSet({required this.type, required this.reps});
}

/// 피니셔 운동 종류
enum FinisherType {
  burpee,          // 버피
  mountainClimber, // 마운틴 클라이머
  jumpSquat,       // 점프 스쿼트
  none,           // 피니셔 없음
}

/// 일일 운동 프로그램
class DailyWorkout {
  // ============ 푸시업 세션 (메인) ============

  /// 푸시업 각 세트의 반복 횟수
  /// 예: [2, 3, 2, 2, 3] = 5세트, 총 12회
  final List<int> pushupSets;

  /// 푸시업 세트간 휴식 시간 (초)
  /// 과학적 근거: Grgic et al. (2018)
  /// - 근비대: 60-90초 최적
  /// - 초보자: 60-120초
  final int pushupRestSeconds;

  // ============ 피니셔 (서브) ============

  /// 피니셔 운동 종류
  final FinisherType finisherType;

  /// 피니셔 각 세트의 반복 횟수
  /// 예: [5, 5] = 2세트, 총 10회
  final List<int> finisherSets;

  /// 피니셔 세트간 휴식 시간 (초)
  final int finisherRestSeconds;

  // ============ 전환 휴식 ============

  /// 푸시업 → 피니셔 사이 전환 휴식 (초)
  /// 목적: 상체 근육 회복, 심박수 안정화
  /// 권장: 120-180초 (2-3분)
  final int transitionRestSeconds;

  const DailyWorkout({
    required this.pushupSets,
    required this.pushupRestSeconds,
    this.finisherType = FinisherType.burpee,
    this.finisherSets = const [],
    this.finisherRestSeconds = 60,
    this.transitionRestSeconds = 120,
  });

  // ============ 계산 메서드 ============

  /// 총 푸시업 횟수
  int get totalPushups => pushupSets.fold(0, (sum, reps) => sum + reps);

  /// 총 피니셔 횟수
  int get totalFinisher => finisherSets.fold(0, (sum, reps) => sum + reps);

  /// 푸시업 세트 수
  int get pushupSetCount => pushupSets.length;

  /// 피니셔 세트 수
  int get finisherSetCount => finisherSets.length;

  /// 마지막 푸시업 세트 (+ 표시용)
  int get lastPushupSet => pushupSets.isEmpty ? 0 : pushupSets.last;

  /// 예상 푸시업 시간 (초)
  /// 계산: (세트 수 - 1) × 휴식시간 + 총 횟수 × 3초/회
  int get estimatedPushupDuration {
    if (pushupSetCount == 0) return 0;
    int restTime = (pushupSetCount - 1) * pushupRestSeconds;
    int exerciseTime = totalPushups * 3; // 1회당 평균 3초
    return restTime + exerciseTime;
  }

  /// 예상 피니셔 시간 (초)
  int get estimatedFinisherDuration {
    if (finisherSetCount == 0) return 0;
    int restTime = (finisherSetCount - 1) * finisherRestSeconds;
    int exerciseTime = totalFinisher * 4; // 버피는 1회당 평균 4초
    return restTime + exerciseTime;
  }

  /// 예상 총 운동 시간 (초)
  int get estimatedTotalDuration {
    int total = estimatedPushupDuration;
    if (finisherSetCount > 0) {
      total += transitionRestSeconds + estimatedFinisherDuration;
    }
    return total;
  }

  /// 예상 총 운동 시간 (분)
  int get estimatedMinutes => (estimatedTotalDuration / 60).ceil();

  /// 운동 설명 텍스트
  String get description {
    String pushup = '푸시업 $pushupSetCount세트 (총 $totalPushups개)';
    if (finisherSetCount > 0) {
      String finisherName = _getFinisherName(finisherType);
      return '$pushup + $finisherName $finisherSetCount세트 (총 $totalFinisher개)';
    }
    return pushup;
  }

  /// 피니셔 이름 (한국어)
  static String _getFinisherName(FinisherType type) {
    switch (type) {
      case FinisherType.burpee:
        return '버피';
      case FinisherType.mountainClimber:
        return '마운틴 클라이머';
      case FinisherType.jumpSquat:
        return '점프 스쿼트';
      case FinisherType.none:
        return '';
    }
  }

  /// ExerciseSet 리스트로 변환 (하위 호환성)
  /// 푸시업 세트들 + 피니셔 세트들로 변환
  List<ExerciseSet> toSets() {
    final sets = <ExerciseSet>[];

    // 푸시업 세트 추가
    for (final reps in pushupSets) {
      sets.add(ExerciseSet(type: ExerciseType.pushup, reps: reps));
    }

    // 피니셔 세트 추가
    if (finisherSets.isNotEmpty) {
      final finisherExerciseType = _getFinisherExerciseType(finisherType);
      for (final reps in finisherSets) {
        sets.add(ExerciseSet(type: finisherExerciseType, reps: reps));
      }
    }

    return sets;
  }

  /// 피니셔 타입을 ExerciseType으로 변환
  static ExerciseType _getFinisherExerciseType(FinisherType type) {
    // 현재는 모든 피니셔를 burpee로 처리 (기존 ExerciseType이 burpee, pushup만 지원)
    return ExerciseType.burpee;
  }

  /// 하위 호환성: 총 버피 횟수 (피니셔)
  int get burpees => totalFinisher;

  /// 하위 호환성: 총 푸시업 횟수
  int get pushups => totalPushups;

  @override
  String toString() {
    return 'DailyWorkout(pushup: $pushupSetCount세트/$totalPushups개, '
        'finisher: ${_getFinisherName(finisherType)} $finisherSetCount세트/$totalFinisher개, '
        '예상시간: ${estimatedMinutes}분)';
  }
}

/// 운동 데이터 클래스
class WorkoutData {
  // ============================================================
  // 6주 운동 프로그램 데이터
  //
  // 출처: docs/운동/WORKOUT_PLAN_EXTRACTED.md
  // 과학적 근거: docs/운동/SCIENTIFIC_EVIDENCE_REVIEW.md
  // ============================================================

  /// 레벨 1: 5개 이하 (초보)
  static Map<int, Map<int, DailyWorkout>> get level1Program => {
        1: {
          // Week 1
          1: const DailyWorkout(
            pushupSets: [2, 3, 2, 2, 3], // 총 12개
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [5, 5], // 총 10개
            transitionRestSeconds: 180, // 3분 (초보자)
          ),
          2: const DailyWorkout(
            pushupSets: [3, 4, 2, 3, 4], // 총 16개
            pushupRestSeconds: 60,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [20, 20], // 20초 × 2세트
            transitionRestSeconds: 180,
          ),
          3: const DailyWorkout(
            pushupSets: [4, 5, 4, 4, 5], // 총 22개
            pushupRestSeconds: 60,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [8, 8], // 총 16개
            transitionRestSeconds: 180,
          ),
        },
        2: {
          // Week 2
          1: const DailyWorkout(
            pushupSets: [4, 6, 4, 4, 6],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [6, 6],
            transitionRestSeconds: 150,
          ),
          2: const DailyWorkout(
            pushupSets: [5, 6, 4, 4, 7],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [25, 25],
            transitionRestSeconds: 150,
          ),
          3: const DailyWorkout(
            pushupSets: [5, 7, 5, 5, 8],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [10, 10],
            transitionRestSeconds: 150,
          ),
        },
        3: {
          // Week 3
          1: const DailyWorkout(
            pushupSets: [10, 12, 7, 7, 9],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [8, 8, 8],
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [10, 12, 8, 8, 12],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [30, 30, 30],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [11, 13, 9, 9, 13],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [12, 12, 12],
            transitionRestSeconds: 120,
          ),
        },
        4: {
          // Week 4
          1: const DailyWorkout(
            pushupSets: [12, 14, 11, 10, 16],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [10, 10, 10],
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [14, 16, 12, 12, 18],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [35, 35, 35],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [16, 18, 13, 13, 20],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [15, 15, 15],
            transitionRestSeconds: 120,
          ),
        },
        5: {
          // Week 5
          1: const DailyWorkout(
            pushupSets: [17, 19, 15, 15, 20],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [12, 12, 12],
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [10, 10, 13, 13, 10, 10, 9, 25],
            pushupRestSeconds: 45,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [40, 40, 40],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [13, 13, 15, 15, 12, 12, 10, 30],
            pushupRestSeconds: 45,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [18, 18, 18],
            transitionRestSeconds: 120,
          ),
        },
        6: {
          // Week 6 - 최종 목표!
          1: const DailyWorkout(
            pushupSets: [25, 30, 20, 15, 40],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [], // AMRAP 2분
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [14, 14, 15, 15, 14, 14, 10, 10, 44],
            pushupRestSeconds: 45,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [45, 45, 45],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [13, 13, 17, 17, 16, 16, 14, 14, 50],
            pushupRestSeconds: 45,
            finisherType: FinisherType.burpee,
            finisherSets: [20, 20, 20], // 최종 파이널 챌린지!
            transitionRestSeconds: 120,
          ),
        },
      };

  /// 레벨 2: 6-10개 (중급)
  static Map<int, Map<int, DailyWorkout>> get level2Program => {
        1: {
          1: const DailyWorkout(
            pushupSets: [6, 6, 4, 4, 5],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [6, 6],
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [6, 8, 6, 6, 7],
            pushupRestSeconds: 60,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [25, 25],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [8, 10, 7, 7, 10],
            pushupRestSeconds: 60,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [10, 10],
            transitionRestSeconds: 120,
          ),
        },
        2: {
          1: const DailyWorkout(
            pushupSets: [9, 11, 8, 8, 11],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [7, 7],
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [10, 12, 9, 9, 13],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [30, 30],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [12, 13, 10, 10, 15],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [12, 12],
            transitionRestSeconds: 120,
          ),
        },
        3: {
          1: const DailyWorkout(
            pushupSets: [12, 17, 13, 13, 17],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [10, 10, 10],
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [14, 19, 14, 14, 19],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [35, 35, 35],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [16, 21, 15, 15, 21],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [15, 15, 15],
            transitionRestSeconds: 120,
          ),
        },
        4: {
          1: const DailyWorkout(
            pushupSets: [18, 22, 16, 16, 25],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [12, 12, 12],
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [20, 25, 20, 20, 28],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [40, 40, 40],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [23, 28, 23, 23, 33],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [18, 18, 18],
            transitionRestSeconds: 120,
          ),
        },
        5: {
          1: const DailyWorkout(
            pushupSets: [28, 35, 25, 22, 35],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [15, 15, 15],
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [18, 18, 20, 20, 14, 14, 16, 40],
            pushupRestSeconds: 45,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [40, 40, 40],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [18, 18, 20, 20, 17, 17, 20, 45],
            pushupRestSeconds: 45,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [20, 20, 20],
            transitionRestSeconds: 120,
          ),
        },
        6: {
          1: const DailyWorkout(
            pushupSets: [40, 50, 25, 25, 50],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [], // AMRAP
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [20, 20, 23, 23, 20, 20, 18, 18, 53],
            pushupRestSeconds: 45,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [50, 50, 50],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            pushupSets: [22, 22, 30, 30, 25, 25, 18, 18, 55],
            pushupRestSeconds: 45,
            finisherType: FinisherType.burpee,
            finisherSets: [20, 20, 20],
            transitionRestSeconds: 120,
          ),
        },
      };

  /// 레벨 3: 11-20개 (고급)
  static Map<int, Map<int, DailyWorkout>> get level3Program => {
        1: {
          1: const DailyWorkout(
            pushupSets: [10, 12, 7, 7, 9],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [8, 8],
            transitionRestSeconds: 90,
          ),
          2: const DailyWorkout(
            pushupSets: [10, 12, 8, 8, 12],
            pushupRestSeconds: 60,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [30, 30],
            transitionRestSeconds: 90,
          ),
          3: const DailyWorkout(
            pushupSets: [11, 15, 9, 9, 13],
            pushupRestSeconds: 60,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [12, 12],
            transitionRestSeconds: 90,
          ),
        },
        2: {
          1: const DailyWorkout(
            pushupSets: [14, 14, 10, 10, 15],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [8, 8],
            transitionRestSeconds: 90,
          ),
          2: const DailyWorkout(
            pushupSets: [14, 16, 12, 12, 17],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [35, 35],
            transitionRestSeconds: 90,
          ),
          3: const DailyWorkout(
            pushupSets: [16, 17, 14, 14, 20],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [15, 15],
            transitionRestSeconds: 90,
          ),
        },
        3: {
          1: const DailyWorkout(
            pushupSets: [14, 18, 14, 14, 20],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [10, 10, 10],
            transitionRestSeconds: 90,
          ),
          2: const DailyWorkout(
            pushupSets: [20, 25, 15, 15, 25],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [40, 40, 40],
            transitionRestSeconds: 90,
          ),
          3: const DailyWorkout(
            pushupSets: [22, 30, 20, 20, 28],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [18, 18, 18],
            transitionRestSeconds: 90,
          ),
        },
        4: {
          1: const DailyWorkout(
            pushupSets: [21, 25, 21, 21, 32],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [12, 12, 12],
            transitionRestSeconds: 90,
          ),
          2: const DailyWorkout(
            pushupSets: [25, 29, 25, 25, 36],
            pushupRestSeconds: 90,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [40, 40, 40],
            transitionRestSeconds: 90,
          ),
          3: const DailyWorkout(
            pushupSets: [29, 33, 29, 29, 40],
            pushupRestSeconds: 120,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [20, 20, 20],
            transitionRestSeconds: 90,
          ),
        },
        5: {
          1: const DailyWorkout(
            pushupSets: [36, 40, 30, 24, 40],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [15, 15, 15],
            transitionRestSeconds: 90,
          ),
          2: const DailyWorkout(
            pushupSets: [19, 19, 22, 22, 18, 18, 22, 45],
            pushupRestSeconds: 45,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [45, 45, 45],
            transitionRestSeconds: 90,
          ),
          3: const DailyWorkout(
            pushupSets: [20, 20, 24, 24, 20, 20, 22, 50],
            pushupRestSeconds: 45,
            finisherType: FinisherType.jumpSquat,
            finisherSets: [22, 22, 22],
            transitionRestSeconds: 90,
          ),
        },
        6: {
          1: const DailyWorkout(
            pushupSets: [45, 55, 35, 30, 55],
            pushupRestSeconds: 60,
            finisherType: FinisherType.burpee,
            finisherSets: [], // AMRAP
            transitionRestSeconds: 120,
          ),
          2: const DailyWorkout(
            pushupSets: [22, 22, 30, 30, 24, 24, 18, 18, 58],
            pushupRestSeconds: 45,
            finisherType: FinisherType.mountainClimber,
            finisherSets: [50, 50, 50],
            transitionRestSeconds: 120,
          ),
          3: const DailyWorkout(
            // 🏆 최종일! Mission100 완료!
            pushupSets: [26, 26, 33, 33, 26, 26, 22, 22, 60],
            pushupRestSeconds: 45,
            finisherType: FinisherType.burpee,
            finisherSets: [20, 20, 20], // 그랜드 피니셔
            transitionRestSeconds: 120,
          ),
        },
      };

  // ============================================================
  // 헬퍼 메서드
  // ============================================================

  /// 레벨에 따른 프로그램 가져오기
  static Map<int, Map<int, DailyWorkout>> getProgram(UserLevel level) {
    switch (level) {
      case UserLevel.rookie:
        return level1Program;
      case UserLevel.rising:
        return level2Program;
      case UserLevel.alpha:
      case UserLevel.giga:
        return level3Program;
    }
  }

  /// 특정 주차, 일차의 운동 가져오기
  static DailyWorkout? getWorkout(UserLevel level, int week, int day) {
    final program = getProgram(level);
    return program[week]?[day];
  }

  /// 주차별 총 푸시업 횟수
  static int getWeeklyPushupTotal(UserLevel level, int week) {
    final program = getProgram(level);
    final weekData = program[week];
    if (weekData == null) return 0;

    int total = 0;
    for (var day = 1; day <= 3; day++) {
      final workout = weekData[day];
      if (workout != null) {
        total += workout.totalPushups;
      }
    }
    return total;
  }

  /// 전체 프로그램 총 푸시업 횟수
  static int getProgramPushupTotal(UserLevel level) {
    int total = 0;
    for (var week = 1; week <= 6; week++) {
      total += getWeeklyPushupTotal(level, week);
    }
    return total;
  }

  /// 레벨별 색상
  static Map<UserLevel, Color> get levelColors => {
        UserLevel.rookie: const Color(0xFF4DABF7), // 파란색
        UserLevel.rising: const Color(0xFF51CF66), // 초록색
        UserLevel.alpha: const Color(0xFFFFB000), // 금색
        UserLevel.giga: const Color(0xFFE53E3E), // 빨간색
      };

  /// 차드 진화 이미지 경로
  static List<String> get chadImagePaths => [
        'assets/images/chad/chad_week0_rookie.png',
        'assets/images/chad/chad_week1_rookie.png',
        'assets/images/chad/chad_week2_rising.png',
        'assets/images/chad/chad_week3_rising.png',
        'assets/images/chad/chad_week4_alpha.png',
        'assets/images/chad/chad_week5_alpha.png',
        'assets/images/chad/chad_week6_giga.png',
      ];

  /// 차드 이미지 가져오기
  static String getChadImage(int week) {
    if (week < 0 || week >= chadImagePaths.length) {
      return chadImagePaths[0];
    }
    return chadImagePaths[week];
  }

  /// RPE 조정값 계산
  static double calculateIntensityFromRPE(int rpeLevel) {
    switch (rpeLevel) {
      case 1:
        return 1.2; // 너무 쉬움 → 20% 증가
      case 2:
        return 1.1; // 쉬움 → 10% 증가
      case 3:
        return 1.0; // 적당 → 유지
      case 4:
        return 0.9; // 힘듦 → 10% 감소
      case 5:
        return 0.8; // 너무 힘듦 → 20% 감소
      default:
        return 1.0;
    }
  }

  /// 하위 호환성: 특정 워크아웃의 총 횟수 계산
  static int getTotalReps(DailyWorkout workout) {
    return workout.totalPushups + workout.totalFinisher;
  }

  /// 하위 호환성: 주차별 총 운동량 계산 (푸시업 + 피니셔)
  static int getWeeklyTotal(UserLevel level, int week) {
    final program = getProgram(level);
    final weekData = program[week];
    if (weekData == null) return 0;

    int total = 0;
    for (var day = 1; day <= 3; day++) {
      final workout = weekData[day];
      if (workout != null) {
        total += getTotalReps(workout);
      }
    }
    return total;
  }

  /// 하위 호환성: 전체 프로그램 총 운동량 계산
  static int getProgramTotal(UserLevel level) {
    int total = 0;
    for (var week = 1; week <= 6; week++) {
      total += getWeeklyTotal(level, week);
    }
    return total;
  }

  /// 하위 호환성: 레벨별 휴식 시간 (이제 pushupRestSeconds로 대체됨)
  static Map<UserLevel, int> get restTimeSeconds => {
        UserLevel.rookie: 90,
        UserLevel.rising: 90,
        UserLevel.alpha: 90,
        UserLevel.giga: 90,
      };

  /// 하위 호환성: 이전 workoutPrograms 맵 (레거시 코드용)
  static Map<UserLevel, Map<int, Map<int, List<int>>>>? get workoutPrograms => null;
}
