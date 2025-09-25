// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => '⚡ CAMPO DE BATALLA ALFA ⚡';

  @override
  String get repLogMessage =>
      'LOS DÉBILES REGISTRAN NÚMEROS. LOS FUERTES HACEN HISTORIA 💪';

  @override
  String targetRepsLabel(int count) {
    return 'OBJETIVO: $count REPS';
  }

  @override
  String get performanceGodTier =>
      '🚀 ¡PERFECCIÓN ABSOLUTA! ¡EMPERADOR ULTRA DIVINO MÁS ALLÁ DE LOS DIOSES! 👑';

  @override
  String get performanceStrong =>
      '🔱 ¡EL HIERRO SE INCLINA ANTE TU PODER! ¡LA GRAVEDAD SE RINDE! ¡BESTIA LEGENDARIA! 🔱';

  @override
  String get performanceMedium =>
      '⚡ ¡BIEN! ¡LA DEBILIDAD ESTÁ HUYENDO! ¡TORMENTA ALFA EN CAMINO! ⚡';

  @override
  String get performanceStart =>
      '💥 ¿EMPEZAR ES LA MITAD? ¡FALSO! ¡LA PUERTA DE LA LEYENDA YA SE ABRIÓ, FUTURO EMPERADOR! 💥';

  @override
  String get performanceMotivation => '¡TÚ PUEDES HACERLO, SOLO HAZLO! 🔥';

  @override
  String get motivationGod =>
      'TUS MÚSCULOS HAN ALCANZADO EL REINO DIVINO. LA DEBILIDAD ESTÁ MUERTA ⚡👑';

  @override
  String get motivationStrong =>
      'RENDIRSE ES EXCUSA DE DÉBILES. ¡MÁS FUERTE! 🔱💪';

  @override
  String get motivationMedium => '¡BUEN COMIENZO! ¡AHORA ESCALA MÁS ALTO! ⚡🚀';

  @override
  String get motivationGeneral => '오늘 흘린 땀은 내일의 영광이야, 만삣삐. 절대 포기하지 마 🔥💪';

  @override
  String get setCompletedSuccess => '굿 잡, 만삣삐! 또 하나의 신화가 탄생했어 🔥👑';

  @override
  String get setCompletedGood => 'not bad, 만삣삐! 또 하나의 한계를 부숴버렸어 ⚡🔱';

  @override
  String resultFormat(int reps, int percentage) {
    return '전설 등급: $reps회 ($percentage%) 🏆';
  }

  @override
  String get quickInputPerfect => '🚀 GODLIKE 달성 🚀';

  @override
  String get quickInputStrong => '👑 EMPEROR 여유 👑';

  @override
  String get quickInputMedium => '⚡ ALPHA 발걸음 ⚡';

  @override
  String get quickInputStart => '🔥 LEGENDARY 함성 🔥';

  @override
  String get quickInputBeast => '💥 LIMIT DESTROYER 💥';

  @override
  String get restTimeTitle => '강자들의 재충전 타임, 만삣삐 ⚡';

  @override
  String get restMessage => '쉬는 것도 성장이야. 다음은 더 파괴적으로 가자, 만삣삐 🦍';

  @override
  String get skipRestButton => '휴식? 약자나 해라, 만삣삐! 다음 희생양 가져와!';

  @override
  String get nextSetButton => '굿 잡! 우주 정복 완료!';

  @override
  String get nextSetContinue => '다음 희생양을 가져와라, 만삣삐!';

  @override
  String get guidanceMessage => '네 몸은 네가 명령하는 대로 따를 뿐이야, you idiot! 🔱';

  @override
  String get completeSetButton => '전설 등극, 만삣삐!';

  @override
  String get completeSetContinue => '또 하나 박살내기!';

  @override
  String get exitDialogTitle => '전투에서 후퇴하겠어, 만삣삐?';

  @override
  String get exitDialogMessage =>
      '전사는 절대 전투 중에 포기하지 않아!\n너의 정복이 사라질 거야, you idiot!';

  @override
  String get exitDialogContinue => '계속 싸운다, 만삣삐!';

  @override
  String get exitDialogRetreat => '후퇴한다...';

  @override
  String get workoutCompleteTitle => '🔥 굿 잡, 만삣삐! 야수 모드 완료! 👑';

  @override
  String workoutCompleteMessage(String title, int totalReps) {
    return '$title 완전 파괴!\n총 파워 해방: $totalReps회! you did it! ⚡';
  }

  @override
  String get workoutCompleteButton => '레전드다, 만삣삐!';

  @override
  String setFormat(int current, int total) {
    return 'SET $current/$total';
  }

  @override
  String get levelSelectionTitle => '💪 레벨 체크';

  @override
  String get levelSelectionHeader => '🏋️‍♂️ 너의 레벨을 선택해라, 만삣삐!';

  @override
  String get levelSelectionDescription =>
      '현재 푸시업 최대 횟수에 맞는 레벨을 선택해라!\n6주 후 목표 달성을 위한 맞춤 프로그램이 제공된다!';

  @override
  String get rookieLevelTitle => '초보자';

  @override
  String get rookieLevelSubtitle => '푸시업 6개 미만 - 기초부터 차근차근';

  @override
  String get rookieLevelDescription => '천천히 시작하는 차드';

  @override
  String get rookieFeature1 => '무릎 푸시업부터 시작';

  @override
  String get rookieFeature2 => '폼 교정 중심 훈련';

  @override
  String get rookieFeature3 => '점진적 강도 증가';

  @override
  String get rookieFeature4 => '기초 체력 향상';

  @override
  String get risingLevelTitle => '중급자';

  @override
  String get risingLevelSubtitle => '푸시업 6-10개 - 차드로 성장 중';

  @override
  String get risingLevelDescription => '성장하는 차드';

  @override
  String get risingFeature1 => '표준 푸시업 마스터';

  @override
  String get risingFeature2 => '다양한 변형 훈련';

  @override
  String get risingFeature3 => '근지구력 향상';

  @override
  String get risingFeature4 => '체계적 진급 프로그램';

  @override
  String get alphaLevelTitle => '고급자';

  @override
  String get alphaLevelSubtitle => '푸시업 11개 이상 - 이미 차드의 자질';

  @override
  String get alphaLevelDescription => '궁극의 차드';

  @override
  String get alphaFeature1 => '고급 변형 푸시업';

  @override
  String get alphaFeature2 => '폭발적 파워 훈련';

  @override
  String get alphaFeature3 => '플라이오메트릭 운동';

  @override
  String get alphaFeature4 => '기가차드 완성 코스';

  @override
  String get rookieShort => '푸시';

  @override
  String get risingShort => '알파 지망생';

  @override
  String get alphaShort => '차드';

  @override
  String get gigaShort => '기가차드';

  @override
  String get homeTitle => '💥 ALPHA EMPEROR COMMAND CENTER 💥';

  @override
  String get welcomeMessage =>
      '🔥 WELCOME,\nFUTURE EMPEROR! 🔥\n정복의 시간이다, 만삣삐!';

  @override
  String get dailyMotivation => '⚡ 오늘도 LEGENDARY\nBEAST MODE로\n세상을 압도해라! ⚡';

  @override
  String get startTodayWorkout => '🚀 오늘의 DOMINATION 시작! 🚀';

  @override
  String weekProgress(int current, int total) {
    return '$current/$total 주차';
  }

  @override
  String progressWeekDay(int week, int totalDays, int completedDays) {
    return '$week주차 - $totalDays일 중 $completedDays일 완료';
  }

  @override
  String get bottomMotivation =>
      '🔥 매일 조금씩? 틀렸다! 매일 LEGENDARY LEVEL UP이다, 만삣삐! 💪';

  @override
  String workoutStartError(String error) {
    return '⚡ ALPHA SYSTEM ERROR! 재시도하라, 만삣삐: $error ⚡';
  }

  @override
  String get errorGeneral => '🦁 일시적 장애물 발견! 진짜 EMPEROR는 다시 도전한다, 만삣삐! 🦁';

  @override
  String get errorDatabase => '💥 데이터 요새에 문제 발생! TECH CHAD가 복구 중이다! 💥';

  @override
  String get errorNetwork => '🌪️ 네트워크 연결을 확인하라! ALPHA CONNECTION 필요하다! 🌪️';

  @override
  String get errorNotFound => '🔱 데이터를 찾을 수 없다! 새로운 전설을 만들 시간이다, 만삣삐! 🔱';

  @override
  String get successWorkoutCompleted =>
      '🚀 WORKOUT DOMINATION COMPLETE! 또 하나의 LEGENDARY ACHIEVEMENT 달성! 🚀';

  @override
  String get successProfileSaved =>
      '👑 EMPEROR PROFILE SAVED! 너의 전설이 기록되었다, 만삣삐! 👑';

  @override
  String get successSettingsSaved =>
      '⚡ ALPHA SETTINGS LOCKED! 완벽한 설정으로 무장 완료! ⚡';

  @override
  String get firstWorkoutMessage => '첫 번째 운동을 시작합니다! 화이팅!';

  @override
  String get weekCompletedMessage => '주차 완료! 축하드립니다!';

  @override
  String get programCompletedMessage => '프로그램 완료! 정말 대단합니다!';

  @override
  String get streakStartMessage => '연속 운동 시작!';

  @override
  String get streakContinueMessage => '연속 운동 계속 중!';

  @override
  String get streakBrokenMessage => '연속 운동이 끊어졌습니다';

  @override
  String get chadTitleSleepy => '수면모자 Chad';

  @override
  String get chadTitleBasic => '기본 Chad';

  @override
  String get chadTitleCoffee => '커피 Chad';

  @override
  String get chadTitleFront => '정면 Chad';

  @override
  String get chadTitleCool => '썬글 Chad';

  @override
  String get chadTitleLaser => '눈빨 Chad';

  @override
  String get chadTitleDouble => '더블 Chad';

  @override
  String get levelNameRookie => 'Rookie Chad';

  @override
  String get levelNameRising => 'Rising Chad';

  @override
  String get levelNameAlpha => 'Alpha Chad';

  @override
  String get levelNameGiga => '기가 차드';

  @override
  String get levelDescRookie =>
      '🔥 ROOKIE CHAD. 푸시업 제국의 시작점.\n각성의 여정이 시작되었다. 🔥';

  @override
  String get levelDescRising =>
      '⚡ 기본기를 갖춘 상승하는 ALPHA CHAD다.\n더 높은 목표를 향해 DOMINATING 중이야, 만삣삐! ⚡';

  @override
  String get levelDescAlpha =>
      '👑 상당한 실력을 갖춘 ALPHA EMPEROR다.\n이미 많은 LEGENDARY ACHIEVEMENTS를 이루었어, 만삣삐! 👑';

  @override
  String get levelDescGiga =>
      '🚀 최고 수준의 ULTRA GIGA CHAD EMPEROR다.\n놀라운 GODLIKE POWER를 가지고 있어, 만삣삐! 🚀';

  @override
  String get levelMotivationRookie =>
      '🔥 모든 EMPEROR는 여기서 시작한다!\n6주 후 MIND-BLOWING TRANSFORMATION을 경험하라, 만삣삐! 🔥';

  @override
  String get levelMotivationRising =>
      '⚡ EXCELLENT START다!\n더 강한 ALPHA BEAST가 되어라, 만삣삐! ⚡';

  @override
  String get levelMotivationAlpha =>
      '👑 OUTSTANDING PERFORMANCE다!\n100개 목표까지 DOMINATE하라, FXXK LIMITS! 👑';

  @override
  String get levelMotivationGiga =>
      '🚀 이미 강력한 GIGA CHAD군!\n완벽한 100개를 향해 CONQUER THE UNIVERSE, 만삣삐! 🚀';

  @override
  String get levelGoalRookie =>
      '🔥 목표: 6주 후 연속 100개 푸시업 ABSOLUTE DOMINATION! 🔥';

  @override
  String get levelGoalRising => '⚡ 목표: 더 강한 ALPHA CHAD로 LEGENDARY EVOLUTION! ⚡';

  @override
  String get levelGoalAlpha => '👑 목표: 완벽한 폼으로 100개 PERFECT EXECUTION! 👑';

  @override
  String get levelGoalGiga =>
      '🚀 목표: ULTIMATE CHAD MASTER로 UNIVERSE DOMINATION! 🚀';

  @override
  String get workoutButtonUltimate => '궁극의 승리 차지하라!';

  @override
  String get workoutButtonConquer => '이 세트를 정복하라, 만삣삐!';

  @override
  String get motivationMessage1 =>
      '🔥 진짜 ALPHA는 변명 따위 불태워버린다, FXXK THE WEAKNESS! 🔥';

  @override
  String get motivationMessage2 => '⚡ 차드처럼 정복하고, 시그마처럼 지배하라! 휴식도 전략이다 ⚡';

  @override
  String get motivationMessage3 => '💪 모든 푸시업이 너를 GOD TIER로 끌어올린다, 만삣삐! 💪';

  @override
  String get motivationMessage4 => '⚡ 차드 에너지 100% 충전 완료! 이제 세상을 평정하라! ⚡';

  @override
  String get motivationMessage5 =>
      '🚀 차드 진화가 아니다! 이제 LEGEND TRANSFORMATION이다, FXXK YEAH! 🚀';

  @override
  String get motivationMessage6 =>
      '👑 차드 모드? 그딴 건 지났다. 지금은 EMPEROR MODE: ACTIVATED! 👑';

  @override
  String get motivationMessage7 =>
      '🌪️ 이렇게 전설들이 탄생한다, 만삣삐! 역사가 너를 기억할 것이다! 🌪️';

  @override
  String get motivationMessage8 =>
      '⚡ 차드 파워가 아니다... 이제 ALPHA LIGHTNING이 몸을 관통한다! ⚡';

  @override
  String get motivationMessage9 =>
      '🔱 차드 변신 완료! 이제 ULTIMATE APEX PREDATOR로 진화했다! 🔱';

  @override
  String get motivationMessage10 =>
      '🦁 차드 브라더후드? 아니다! ALPHA EMPIRE의 황제에게 경배하라, 만삣삐! 🦁';

  @override
  String get completionMessage1 =>
      '🔥 바로 그거다! ABSOLUTE DOMINATION, FXXK YEAH! 🔥';

  @override
  String get completionMessage2 => '⚡ 오늘 ALPHA STORM이 몰아쳤다, 만삣삐! 세상이 떨고 있어! ⚡';

  @override
  String get completionMessage3 => '👑 차드에 가까워진 게 아니다... 이제 차드를 넘어섰다! 👑';

  @override
  String get completionMessage4 =>
      '🚀 차드답다고? 틀렸다! 이제 LEGENDARY BEAST MODE다, YOU MONSTER! 🚀';

  @override
  String get completionMessage5 => '⚡ 차드 에너지 레벨: ∞ 무한대 돌파! 우주가 경배한다! ⚡';

  @override
  String get completionMessage6 => '🦁 존경? 그딴 건 지났다! 이제 온 세상이 너에게 절한다, 만삣삐! 🦁';

  @override
  String get completionMessage7 => '🔱 차드가 승인했다고? 아니다! GOD TIER가 탄생을 인정했다! 🔱';

  @override
  String get completionMessage8 =>
      '🌪️ 차드 게임 레벨업? 틀렸다! ALPHA DIMENSION을 정복했다, FXXK BEAST! 🌪️';

  @override
  String get completionMessage9 =>
      '💥 순수한 차드 퍼포먼스가 아니다... 이제 PURE LEGENDARY DOMINANCE! 💥';

  @override
  String get completionMessage10 =>
      '👑 차드의 하루? 아니다! EMPEROR OF ALPHAS의 제국 건설 완료, 만삣삐! 👑';

  @override
  String get encouragementMessage1 =>
      '🔥 ALPHA도 시련이 있다, 만삣삐! 하지만 그게 너를 더 강하게 만든다! 🔥';

  @override
  String get encouragementMessage2 =>
      '⚡ 내일은 LEGENDARY COMEBACK의 날이다! 세상이 너의 부활을 보게 될 것이다! ⚡';

  @override
  String get encouragementMessage3 =>
      '👑 진짜 EMPEROR는 절대 굴복하지 않는다, FXXK THE LIMITS! 👑';

  @override
  String get encouragementMessage4 =>
      '🚀 이건 그냥 ULTIMATE BOSS FIGHT 모드야! 너는 이미 승리했다! 🚀';

  @override
  String get encouragementMessage5 =>
      '🦁 진짜 APEX PREDATOR는 더 강해져서 돌아온다, 만삣삐! 🦁';

  @override
  String get encouragementMessage6 => '🔱 ALPHA 정신은 불멸이다! 우주가 끝나도 너는 살아남는다! 🔱';

  @override
  String get encouragementMessage7 =>
      '⚡ 아직 LEGEND TRANSFORMATION 진행 중이다, YOU ABSOLUTE UNIT! ⚡';

  @override
  String get encouragementMessage8 =>
      '🌪️ EPIC COMEBACK STORM이 몰려온다! 세상이 너의 복귀를 떨며 기다린다! 🌪️';

  @override
  String get encouragementMessage9 =>
      '💥 모든 EMPEROR는 시련을 통과한다, 만삣삐! 이게 바로 왕의 길이다! 💥';

  @override
  String get encouragementMessage10 =>
      '👑 ALPHA 회복력이 아니다... 이제 IMMORTAL PHOENIX POWER다, FXXK YEAH! 👑';

  @override
  String get chadMessage0 => '🛌 잠에서 깨어나라, 미래의 차드여! 여정이 시작된다!';

  @override
  String get chadMessage1 => '😎 기본기가 탄탄해지고 있어! 진짜 차드의 시작이야!';

  @override
  String get chadMessage2 => '☕ 에너지가 넘쳐흘러! 커피보다 강한 힘이 생겼어!';

  @override
  String get chadMessage3 => '🔥 정면돌파! 어떤 장애물도 막을 수 없다!';

  @override
  String get chadMessage4 => '🕶️ 쿨함이 몸에 배었어! 진정한 알파의 모습이야!';

  @override
  String get chadMessage5 => '⚡ 눈빛만으로도 세상을 바꿀 수 있어! 전설의 시작!';

  @override
  String get chadMessage6 => '👑 최고의 차드 완성! 더블 파워로 우주를 정복하라!';

  @override
  String get tutorialTitle => '🔥 ALPHA EMPEROR PUSHUP DOJO 🔥';

  @override
  String get tutorialSubtitle => '진짜 EMPEROR는 자세부터 다르다, 만삣삐! 💪';

  @override
  String get tutorialButton => '💥 PUSHUP MASTER 되기 💥';

  @override
  String get difficultyBeginner => '푸시 - 시작하는 만삣삐들';

  @override
  String get difficultyIntermediate => '알파 지망생 - 성장하는 차드들';

  @override
  String get difficultyAdvanced => '차드 - 강력한 기가들';

  @override
  String get difficultyExtreme => '기가 차드 - 전설의 영역';

  @override
  String get targetMuscleChest => '가슴';

  @override
  String get targetMuscleTriceps => '삼두근';

  @override
  String get targetMuscleShoulders => '어깨';

  @override
  String get targetMuscleCore => '코어';

  @override
  String get targetMuscleFull => '전신';

  @override
  String caloriesPerRep(int calories) {
    return '${calories}kcal/회';
  }

  @override
  String get tutorialDetailTitle => '💥 EMPEROR 자세 MASTER하기 💥';

  @override
  String get benefitsSection => '🚀 이렇게 LEGENDARY BEAST가 된다 🚀';

  @override
  String get instructionsSection => '⚡ EMPEROR EXECUTION 방법 ⚡';

  @override
  String get mistakesSection => '❌ 약자들의 PATHETIC 실수들 ❌';

  @override
  String get breathingSection => '🌪️ ALPHA EMPEROR 호흡법 🌪️';

  @override
  String get chadMotivationSection => '🔥 EMPEROR\'S ULTIMATE WISDOM 🔥';

  @override
  String get pushupStandardName => '기본 푸시업';

  @override
  String get pushupStandardDesc => '모든 차드의 시작점. 완벽한 기본기가 진짜 강함이다, 만삣삐!';

  @override
  String get pushupStandardBenefits =>
      '• 가슴근육 전체 발달\\n• 삼두근과 어깨 강화\\n• 기본 체력 향상\\n• 모든 푸시업의 기초가 된다, you idiot!';

  @override
  String get pushupStandardInstructions =>
      '1. 플랭크 자세로 시작한다, 만삣삐\\n2. 손은 어깨 너비로 벌려라\\n3. 몸은 일직선으로 유지해라, 흐트러지지 말고\\n4. 가슴이 바닥에 닿을 때까지 내려가라\\n5. 강하게 밀어올려라, 차드답게!';

  @override
  String get pushupStandardMistakes =>
      '• 엉덩이가 위로 솟음 - 약자들이나 하는 짓이야\\n• 가슴을 끝까지 내리지 않음\\n• 목을 앞으로 빼고 함\\n• 손목이 어깨보다 앞에 위치\\n• 일정한 속도를 유지하지 않음, fxxk idiot!';

  @override
  String get pushupStandardBreathing =>
      '내려갈 때 숨을 마시고, 올라올 때 강하게 내뱉어라. 호흡이 파워다, 만삣삐!';

  @override
  String get pushupStandardChad =>
      '🔥 기본이 제일 어렵다고? 틀렸다! 완벽한 폼 하나가 세상을 정복한다, 만삣삐! MASTER THE BASICS! 🔥';

  @override
  String get pushupKneeName => '무릎 푸시업';

  @override
  String get pushupKneeDesc => '입문자도 할 수 있다! 무릎 대고 하는 거 부끄러워하지 마라, 만삣삐!';

  @override
  String get pushupKneeBenefits =>
      '• 기본 근력 향상\\n• 올바른 푸시업 폼 학습\\n• 어깨와 팔 안정성 강화\\n• 기본 푸시업으로의 단계적 진행';

  @override
  String get pushupKneeInstructions =>
      '1. 무릎을 바닥에 대고 시작하라\\n2. 발목을 들어올려라\\n3. 상체는 기본 푸시업과 동일하게\\n4. 무릎에서 머리까지 일직선 유지\\n5. 천천히 확실하게 움직여라, 만삣삐!';

  @override
  String get pushupKneeMistakes =>
      '• 엉덩이가 뒤로 빠짐\\n• 무릎 위치가 너무 앞쪽\\n• 상체만 움직이고 코어 사용 안 함\\n• 너무 빠르게 동작함';

  @override
  String get pushupKneeBreathing => '부드럽고 꾸준한 호흡으로 시작해라. 급하게 하지 마라, 만삣삐!';

  @override
  String get pushupKneeChad =>
      '⚡ 시작이 반? 아니다! 이미 ALPHA JOURNEY가 시작됐다! 무릎 푸시업도 EMPEROR의 길이다! ⚡';

  @override
  String get pushupInclineName => '인클라인 푸시업';

  @override
  String get pushupInclineDesc => '경사면을 이용해서 난이도 조절! 계단이나 벤치면 충분하다, 만삣삐!';

  @override
  String get pushupInclineBenefits =>
      '• 부담을 줄여 폼 완성\\n• 하부 가슴근육 강화\\n• 어깨 안정성 향상\\n• 기본 푸시업으로의 징검다리';

  @override
  String get pushupInclineInstructions =>
      '1. 벤치나 의자에 손을 올려라\\n2. 몸을 비스듬히 기울여라\\n3. 발가락부터 머리까지 일직선\\n4. 높을수록 쉬워진다, 만삣삐\\n5. 점차 낮은 곳으로 도전해라!';

  @override
  String get pushupInclineMistakes =>
      '• 엉덩이가 위로 솟음\\n• 손목에 과도한 체중\\n• 불안정한 지지대 사용\\n• 각도를 너무 급하게 낮춤';

  @override
  String get pushupInclineBreathing =>
      '각도가 편해진 만큼 호흡도 편안하게. 하지만 집중력은 최고로, you idiot!';

  @override
  String get pushupInclineChad =>
      '🚀 높이는 조절하고 강도는 MAX! 20개 완벽 수행하면 GOD TIER 입장권 획득이다, 만삣삐! 🚀';

  @override
  String get pushupWideGripName => '와이드 그립 푸시업';

  @override
  String get pushupWideGripDesc => '와이드하게 벌려서 가슴을 더 넓게! 진짜 차드 가슴을 만들어라!';

  @override
  String get pushupWideGripBenefits =>
      '• 가슴 바깥쪽 근육 집중 발달\\n• 어깨 안정성 향상\\n• 가슴 넓이 확장\\n• 상체 전체적인 균형 발달';

  @override
  String get pushupWideGripInstructions =>
      '1. 손을 어깨보다 1.5배 넓게 벌려라\\n2. 손가락은 약간 바깥쪽을 향하게\\n3. 가슴이 바닥에 닿을 때까지\\n4. 팔꿈치는 45도 각도 유지\\n5. 넓은 가슴으로 밀어올려라, 만삣삐!';

  @override
  String get pushupWideGripMistakes =>
      '• 손을 너무 넓게 벌림\\n• 팔꿈치가 완전히 바깥쪽\\n• 어깨에 무리가 가는 자세\\n• 가슴을 충분히 내리지 않음';

  @override
  String get pushupWideGripBreathing =>
      '넓은 가슴으로 깊게 숨쉬어라. 가슴이 확장되는 걸 느껴라, you idiot!';

  @override
  String get pushupWideGripChad =>
      '🦁 넓은 가슴? 아니다! 이제 LEGENDARY GORILLA CHEST를 만들어라! 와이드 그립으로 세상을 압도하라! 🦁';

  @override
  String get pushupDiamondName => '다이아몬드 푸시업';

  @override
  String get pushupDiamondDesc => '삼두근 집중 공략! 다이아몬드 모양이 진짜 차드의 상징이다!';

  @override
  String get pushupDiamondBenefits =>
      '• 삼두근 집중 강화\\n• 가슴 안쪽 근육 발달\\n• 팔 전체 근력 향상\\n• 코어 안정성 증가';

  @override
  String get pushupDiamondInstructions =>
      '1. 엄지와 검지로 다이아몬드 모양 만들어라\\n2. 가슴 중앙 아래에 손 위치\\n3. 팔꿈치는 몸에 가깝게 유지\\n4. 가슴이 손에 닿을 때까지\\n5. 삼두근 힘으로 밀어올려라, 만삣삐!';

  @override
  String get pushupDiamondMistakes =>
      '• 손목에 과도한 압력\\n• 팔꿈치가 너무 벌어짐\\n• 몸이 비틀어짐\\n• 다이아몬드 모양이 부정확함';

  @override
  String get pushupDiamondBreathing => '집중해서 호흡해라. 삼두근이 불타는 걸 느껴라, you idiot!';

  @override
  String get pushupDiamondChad =>
      '💎 다이아몬드보다 단단한 팔? 틀렸다! 이제 UNBREAKABLE TITANIUM ARMS다! 10개면 진짜 BEAST 인정! 💎';

  @override
  String get pushupDeclineName => '디클라인 푸시업';

  @override
  String get pushupDeclineDesc => '발을 높게 올려서 강도 업! 어깨와 상체 근육을 제대로 자극한다!';

  @override
  String get pushupDeclineBenefits =>
      '• 상부 가슴근육 집중 발달\\n• 어깨 전면 강화\\n• 코어 안정성 최대 강화\\n• 전신 근력 향상';

  @override
  String get pushupDeclineInstructions =>
      '1. 발을 벤치나 의자에 올려라\\n2. 손은 어깨 아래 정확히\\n3. 몸은 아래쪽으로 기울어진 직선\\n4. 중력의 저항을 이겨내라\\n5. 강하게 밀어올려라, 만삣삐!';

  @override
  String get pushupDeclineMistakes =>
      '• 발 위치가 불안정\\n• 엉덩이가 아래로 처짐\\n• 목에 무리가 가는 자세\\n• 균형을 잃고 비틀어짐';

  @override
  String get pushupDeclineBreathing =>
      '중력과 싸우면서도 안정된 호흡을 유지해라. 진짜 파워는 여기서 나온다, you idiot!';

  @override
  String get pushupDeclineChad =>
      '🌪️ 중력 따위 개무시? 당연하지! 이제 물리법칙을 지배하라! 디클라인으로 GODLIKE SHOULDERS! 🌪️';

  @override
  String get pushupArcherName => '아처 푸시업';

  @override
  String get pushupArcherDesc => '한쪽씩 집중하는 고급 기술! 균형감각과 코어가 필요하다, 만삣삐!';

  @override
  String get pushupArcherBenefits =>
      '• 한쪽 팔 집중 강화\\n• 좌우 균형 발달\\n• 원핸드 푸시업 준비\\n• 코어 회전 안정성 강화';

  @override
  String get pushupArcherInstructions =>
      '1. 와이드 그립으로 시작하라\\n2. 한쪽으로 체중을 기울여라\\n3. 한 팔은 굽히고 다른 팔은 쭉\\n4. 활시위 당기듯 정확하게\\n5. 양쪽을 번갈아가며, 만삣삐!';

  @override
  String get pushupArcherMistakes =>
      '• 몸이 비틀어짐\\n• 쭉 편 팔에도 힘이 들어감\\n• 좌우 동작이 불균등\\n• 코어가 흔들림';

  @override
  String get pushupArcherBreathing =>
      '활시위 당기듯 집중해서 호흡해라. 정확성이 생명이다, you idiot!';

  @override
  String get pushupArcherChad =>
      '🏹 정확한 아처가 원핸드 지름길? 맞다! 양쪽 균등 마스터하면 LEGENDARY ARCHER EMPEROR! 🏹';

  @override
  String get pushupPikeName => '파이크 푸시업';

  @override
  String get pushupPikeDesc => '어깨 집중 공략! 핸드스탠드 푸시업의 전 단계다!';

  @override
  String get pushupPikeBenefits =>
      '• 어깨 전체 근육 강화\\n• 핸드스탠드 푸시업 준비\\n• 상체 수직 힘 발달\\n• 코어와 균형감 향상';

  @override
  String get pushupPikeInstructions =>
      '1. 다운독 자세로 시작하라\\n2. 엉덩이를 최대한 위로\\n3. 머리가 바닥에 가까워질 때까지\\n4. 어깨 힘으로만 밀어올려라\\n5. 역삼각형을 유지하라, 만삣삐!';

  @override
  String get pushupPikeMistakes =>
      '• 엉덩이가 충분히 올라가지 않음\\n• 팔꿈치가 옆으로 벌어짐\\n• 머리로만 지탱하려 함\\n• 발 위치가 너무 멀거나 가까움';

  @override
  String get pushupPikeBreathing => '거꾸로 된 자세에서도 안정된 호흡. 어깨에 집중해라, you idiot!';

  @override
  String get pushupPikeChad =>
      '⚡ 파이크 마스터하면 핸드스탠드? 당연하지! 어깨 EMPEROR로 진화하라, 만삣삐! ⚡';

  @override
  String get pushupClapName => '박수 푸시업';

  @override
  String get pushupClapDesc => '박수치면서 하는 폭발적인 파워! 진짜 차드만이 할 수 있다!';

  @override
  String get pushupClapBenefits =>
      '• 폭발적인 근력 발달\\n• 전신 파워 향상\\n• 순간 반응속도 증가\\n• 진짜 차드의 증명';

  @override
  String get pushupClapInstructions =>
      '1. 기본 푸시업 자세로 시작\\n2. 폭발적으로 밀어올려라\\n3. 공중에서 박수를 쳐라\\n4. 안전하게 착지하라\\n5. 연속으로 도전해라, 만삣삐!';

  @override
  String get pushupClapMistakes =>
      '• 충분한 높이로 올라가지 않음\\n• 착지할 때 손목 부상 위험\\n• 폼이 흐트러짐\\n• 무리한 연속 시도';

  @override
  String get pushupClapBreathing =>
      '폭발할 때 강하게 내뱉고, 착지 후 빠르게 호흡 정리. 리듬이 중요하다, you idiot!';

  @override
  String get pushupClapChad =>
      '👏 박수 푸시업은 파워의 증명? 아니다! 이제 EXPLOSIVE THUNDER POWER의 표현이다! 👏';

  @override
  String get pushupOneArmName => '원핸드 푸시업';

  @override
  String get pushupOneArmDesc =>
      '원핸드 푸시업은 차드의 완성형이다! 이거 한 번이라도 하면 진짜 기가 차드 인정!';

  @override
  String get pushupOneArmBenefits =>
      '• 궁극의 상체 근력\\n• 완벽한 코어 컨트롤\\n• 전신 균형과 조정력\\n• 기가 차드의 완성';

  @override
  String get pushupOneArmInstructions =>
      '1. 다리를 넓게 벌려 균형잡아라\\n2. 한 손은 등 뒤로\\n3. 코어에 모든 힘을 집중\\n4. 천천히 확실하게\\n5. 기가 차드의 자격을 증명하라!';

  @override
  String get pushupOneArmMistakes =>
      '• 다리가 너무 좁음\\n• 몸이 비틀어지며 회전\\n• 반대 손으로 지탱\\n• 무리한 도전으로 부상';

  @override
  String get pushupOneArmBreathing =>
      '깊고 안정된 호흡으로 집중력을 최고조로. 모든 에너지를 하나로, you idiot!';

  @override
  String get pushupOneArmChad =>
      '🚀 원핸드는 차드 완성형? 틀렸다! 이제 ULTIMATE APEX GOD EMPEROR 탄생이다, FXXK YEAH! 🚀';

  @override
  String get selectLevelButton => '🔥 레벨을 선택하라, FUTURE EMPEROR! 🔥';

  @override
  String startWithLevel(String level) {
    return '💥 $level로 EMPEROR JOURNEY 시작! 💥';
  }

  @override
  String profileCreated(int sessions) {
    return '🚀 EMPEROR PROFILE CREATION COMPLETE! ($sessions개 DOMINATION SESSION 준비됨, 만삣삐!) 🚀';
  }

  @override
  String profileCreationError(String error) {
    return '⚡ PROFILE CREATION FAILED! 다시 도전하라, ALPHA! 오류: $error ⚡';
  }

  @override
  String get achievementFirstJourney => '차드 여정의 시작';

  @override
  String get achievementFirstJourneyDesc => '첫 번째 푸쉬업을 완료하다';

  @override
  String get achievementPerfectSet => '완벽한 첫 세트';

  @override
  String get achievementPerfectSetDesc => '목표를 100% 달성한 세트를 완료하다';

  @override
  String get achievementCenturion => '센츄리온';

  @override
  String get achievementCenturionDesc => '총 100회의 푸쉬업을 달성하다';

  @override
  String get achievementWeekWarrior => '주간 전사';

  @override
  String get achievementWeekWarriorDesc => '7일 연속으로 운동하다';

  @override
  String get achievementIronWill => '강철 의지';

  @override
  String get achievementIronWillDesc => '한 번에 200개를 달성했습니다';

  @override
  String get achievementSpeedDemon => '스피드 데몬';

  @override
  String get achievementSpeedDemonDesc => '5분 이내에 50개를 완료했습니다';

  @override
  String get achievementPushupMaster => '푸쉬업 마스터';

  @override
  String get achievementPushupMasterDesc => '총 1000회의 푸쉬업을 달성하다';

  @override
  String get achievementConsistency => '일관성의 왕';

  @override
  String get achievementConsistencyDesc => '30일 연속으로 운동하다';

  @override
  String get achievementBeastMode => '야수 모드';

  @override
  String get achievementBeastModeDesc => '목표를 150% 초과 달성하다';

  @override
  String get achievementMarathoner => '마라토너';

  @override
  String get achievementMarathonerDesc => '총 5000회의 푸쉬업을 달성하다';

  @override
  String get achievementLegend => '전설';

  @override
  String get achievementLegendDesc => '총 10000회의 푸쉬업을 달성하다';

  @override
  String get achievementPerfectionist => '완벽주의자';

  @override
  String get achievementPerfectionistDesc => '완벽한 세트를 10개 달성하다';

  @override
  String get achievementEarlyBird => '얼리버드';

  @override
  String get achievementEarlyBirdDesc => '오전 7시 이전에 5번 운동했습니다';

  @override
  String get achievementNightOwl => '올빼미';

  @override
  String get achievementNightOwlDesc => '오후 10시 이후에 5번 운동했습니다';

  @override
  String get achievementOverachiever => '초과달성자';

  @override
  String get achievementOverachieverDesc => '목표의 150%를 5번 달성했습니다';

  @override
  String get achievementEndurance => '지구력 왕';

  @override
  String get achievementEnduranceDesc => '30분 이상 운동하다';

  @override
  String get achievementVariety => '다양성의 달인';

  @override
  String get achievementVarietyDesc => '5가지 다른 푸쉬업 타입을 완료하다';

  @override
  String get achievementDedication => '헌신';

  @override
  String get achievementDedicationDesc => '100일 연속으로 운동하다';

  @override
  String get achievementUltimate => '궁극의 차드';

  @override
  String get achievementUltimateDesc => '모든 업적을 달성하다';

  @override
  String get achievementGodMode => '신 모드';

  @override
  String get achievementGodModeDesc => '한 세션에서 500회 이상 달성하다';

  @override
  String get achievementRarityCommon => '일반';

  @override
  String get achievementRarityRare => '레어';

  @override
  String get achievementRarityEpic => '에픽';

  @override
  String get achievementRarityLegendary => '레전더리';

  @override
  String get achievementRarityMythic => '신화';

  @override
  String get home => 'Inicio';

  @override
  String get calendar => 'Calendario';

  @override
  String get achievements => 'Logros';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get settings => 'Configuración';

  @override
  String get chadShorts => '차드 쇼츠 🔥';

  @override
  String get settingsTitle => '⚙️ 차드 설정';

  @override
  String get settingsSubtitle => '당신의 차드 여정을 커스터마이즈하세요';

  @override
  String get workoutSettings => '💪 운동 설정';

  @override
  String get notificationSettings => '운동 알림 설정';

  @override
  String get appearanceSettings => '🎨 외형 설정';

  @override
  String get dataSettings => '💾 데이터 관리';

  @override
  String get aboutSettings => 'ℹ️ 앱 정보';

  @override
  String get difficultySettings => '난이도 설정';

  @override
  String get pushNotifications => '푸시 알림';

  @override
  String get pushNotificationsDesc => '💥 모든 알림을 받아라! 도망칠 곳은 없다!';

  @override
  String get achievementNotifications => '업적 알림';

  @override
  String get achievementNotificationsDesc => '🏆 새로운 업적 달성 시 너의 승리를 알려준다!';

  @override
  String get workoutReminders => '운동 리마인더';

  @override
  String get workoutRemindersDesc => '💀 매일 너를 깨워서 운동시켜줄 거야! 도망갈 생각 마라!';

  @override
  String get reminderTime => '⏰ 리마인더 시간';

  @override
  String get reminderTimeDesc => '⚡ 너의 운명이 결정되는 시간을 정해라!';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get darkModeDesc => '🌙 진짜 차드는 어둠 속에서도 강하다';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get dataBackup => '데이터 백업';

  @override
  String get dataBackupDesc => '💾 너의 차드 전설을 영원히 보존한다!';

  @override
  String get dataRestore => '데이터 복원';

  @override
  String get dataRestoreDesc => '백업된 데이터를 복원합니다';

  @override
  String get dataReset => '데이터 초기화';

  @override
  String get dataResetDesc => '모든 데이터를 삭제합니다';

  @override
  String get versionInfo => '버전 정보';

  @override
  String get versionInfoDesc => 'Mission: 100 v1.0.0';

  @override
  String get developerInfo => '개발자 정보';

  @override
  String get developerInfoDesc => '차드가 되는 여정을 함께하세요';

  @override
  String get sendFeedback => '📧 피드백 보내기';

  @override
  String get sendFeedbackDesc => '💬 너의 의견을 들려달라! 차드들의 목소리가 필요하다!';

  @override
  String get common => '일반';

  @override
  String get rare => '레어';

  @override
  String get epic => '에픽';

  @override
  String get legendary => '레전더리';

  @override
  String unlockedAchievements(int count) {
    return '획득한 업적 ($count)';
  }

  @override
  String lockedAchievements(int count) {
    return '미획득 업적 ($count)';
  }

  @override
  String get noAchievementsYet => '아직 획득한 업적이 없습니다';

  @override
  String get startWorkoutForAchievements => '운동을 시작해서 첫 번째 업적을 획득해보세요!';

  @override
  String get allAchievementsUnlocked => '모든 업적을 획득했습니다!';

  @override
  String get congratulationsChad => '축하합니다! 진정한 차드가 되셨습니다! 🎉';

  @override
  String get achievementsBannerText => '업적을 달성해서 차드가 되자! 🏆';

  @override
  String get totalExperience => '총 경험치';

  @override
  String get noWorkoutRecords => '아직 운동 기록이 없어!';

  @override
  String get startFirstWorkout => '첫 운동을 시작하고\\n차드의 전설을 만들어보자! 🔥';

  @override
  String get loadingStatistics => '차드의 통계를 불러오는 중...';

  @override
  String get totalWorkouts => '총 운동 횟수';

  @override
  String workoutCount(int count) {
    return '$count회';
  }

  @override
  String get chadDays => '차드가 된 날들!';

  @override
  String get totalPushups => '총 푸시업';

  @override
  String pushupsCount(int count) {
    return '$count개';
  }

  @override
  String get realChadPower => '진짜 차드 파워!';

  @override
  String get averageCompletion => '평균 달성률';

  @override
  String completionPercentage(int percentage) {
    return '$percentage%';
  }

  @override
  String get perfectExecution => '완벽한 수행!';

  @override
  String get thisMonthWorkouts => '이번 달 운동';

  @override
  String get consistentChad => '꾸준한 차드!';

  @override
  String get currentStreak => '현재 연속';

  @override
  String streakDays(int days) {
    return 'Racha de $days días';
  }

  @override
  String get bestRecord => '최고 기록';

  @override
  String get recentWorkouts => '최근 운동 기록';

  @override
  String repsAchieved(int reps, int percentage) {
    return '$reps개 • $percentage% 달성';
  }

  @override
  String get checkChadGrowth => '차드의 성장을 확인하라! 📊';

  @override
  String workoutRecordForDate(int month, int day) {
    return '$month/$day 운동 기록';
  }

  @override
  String get noWorkoutRecordForDate => '이 날에는 운동 기록이 없습니다';

  @override
  String get calendarBannerText => '꾸준함이 차드의 힘! 📅';

  @override
  String workoutHistoryLoadError(String error) {
    return '운동 기록을 불러오는 중 오류가 발생했습니다: $error';
  }

  @override
  String get completed => '완료';

  @override
  String get current => '현재';

  @override
  String get half => '절반';

  @override
  String get exceed => '초과';

  @override
  String get target => '목표';

  @override
  String get loadingChadVideos => '차드 영상 로딩 중... 🔥';

  @override
  String videoLoadError(String error) {
    return '영상 로딩 오류: $error';
  }

  @override
  String get tryAgain => '다시 시도';

  @override
  String get like => '좋아요';

  @override
  String get share => '공유';

  @override
  String get save => '저장';

  @override
  String get workout => '운동';

  @override
  String get likeMessage => '좋아요! 💪';

  @override
  String get shareMessage => '공유 중 📤';

  @override
  String get saveMessage => '저장됨 📌';

  @override
  String get workoutStartMessage => '운동 시작! 🔥';

  @override
  String get swipeUpHint => '위로 스와이프하여 다음 영상';

  @override
  String get pushupHashtag => '#팔굽혀펴기';

  @override
  String get chadHashtag => '#차드';

  @override
  String get perfectPushupForm => '완벽한 푸시업 자세';

  @override
  String get pushupVariations => '팔굽혀펴기 변형 동작 🔥';

  @override
  String get chadSecrets => '차드의 비밀 ⚡';

  @override
  String get pushup100Challenge => '팔굽혀펴기 100개 도전 🎯';

  @override
  String get homeWorkoutPushups => '홈트 팔굽혀펴기 🏠';

  @override
  String get strengthSecrets => '근력의 비밀 💯';

  @override
  String get correctPushupFormDesc => '올바른 팔굽혀펴기 자세로 효과적인 운동';

  @override
  String get variousPushupStimulation => '다양한 팔굽혀펴기 변형으로 근육 자극';

  @override
  String get trueChadMindset => '진정한 차드가 되는 마인드셋';

  @override
  String get challengeSpirit100 => '팔굽혀펴기 100개를 향한 도전 정신';

  @override
  String get perfectHomeWorkout => '집에서 할 수 있는 완벽한 운동';

  @override
  String get consistentStrengthImprovement => '꾸준한 운동으로 근력 향상';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get confirm => '확인';

  @override
  String get korean => '한국어';

  @override
  String get english => '영어';

  @override
  String get chest => '가슴';

  @override
  String get triceps => '삼두';

  @override
  String get shoulders => '어깨';

  @override
  String get core => '코어';

  @override
  String get fullBody => '전신';

  @override
  String get restTimeSettings => '휴식 시간 설정';

  @override
  String get restTimeDesc => '세트 간 휴식 시간 설정';

  @override
  String get soundSettings => '사운드 설정';

  @override
  String get soundSettingsDesc => '운동 효과음 활성화';

  @override
  String get vibrationSettings => '진동 설정';

  @override
  String get vibrationSettingsDesc => '진동 피드백 활성화';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get dataManagementDesc => '운동 기록 백업 및 복원';

  @override
  String get appInfo => '앱 정보';

  @override
  String get appInfoDesc => '버전 정보 및 개발자 정보';

  @override
  String get seconds => '초';

  @override
  String get minutes => '분';

  @override
  String get motivationMessages => '동기부여 메시지';

  @override
  String get motivationMessagesDesc => '운동 중 동기부여 메시지 표시';

  @override
  String get autoStartNextSet => '다음 세트 자동 시작';

  @override
  String get autoStartNextSetDesc => '휴식 후 자동으로 다음 세트 시작';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyPolicyDesc => '개인정보 보호 및 처리 방침을 확인';

  @override
  String get termsOfService => '이용약관';

  @override
  String get termsOfServiceDesc => '앱 사용시 약관 확인';

  @override
  String get openSourceLicenses => '오픈소스 라이선스';

  @override
  String get openSourceLicensesDesc => '오픈소스 라이선스 보기';

  @override
  String get resetConfirmTitle => '모든 데이터 초기화';

  @override
  String get resetConfirmMessage => '정말로 모든 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get dataResetConfirm => '정말로 모든 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get dataResetComingSoon => '데이터 초기화 기능은 곧 제공될 예정입니다.';

  @override
  String get resetSuccess => '모든 데이터가 성공적으로 초기화되었습니다';

  @override
  String get backupSuccess => '데이터 백업이 성공적으로 완료되었습니다';

  @override
  String get restoreSuccess => '데이터 복원이 성공적으로 완료되었습니다';

  @override
  String get selectTime => '시간 선택';

  @override
  String currentDifficulty(String difficulty, String description) {
    return '현재: $difficulty - $description';
  }

  @override
  String currentLanguage(String language) {
    return '현재: $language';
  }

  @override
  String get darkModeEnabled => '다크 모드가 활성화되었습니다';

  @override
  String get lightModeEnabled => '라이트 모드가 활성화되었습니다';

  @override
  String languageChanged(String language) {
    return '언어가 $language로 변경되었습니다!';
  }

  @override
  String difficultyChanged(String difficulty) {
    return '난이도가 $difficulty로 변경되었습니다!';
  }

  @override
  String get dataBackupComingSoon => '데이터 백업 기능이 곧 추가됩니다!';

  @override
  String get dataRestoreComingSoon => '데이터 복원 기능이 곧 추가됩니다!';

  @override
  String get feedbackComingSoon => '피드백 기능이 곧 추가됩니다!';

  @override
  String reminderTimeChanged(String time) {
    return '리마인더 시간이 $time으로 변경되었습니다!';
  }

  @override
  String get notificationPermissionRequired => '🔔 알림 권한 필요';

  @override
  String get notificationPermissionMessage => '푸시 알림을 받으려면 알림 권한이 필요합니다.';

  @override
  String get notificationPermissionFeatures =>
      '• 운동 리마인더\n• 업적 달성 알림\n• 동기부여 메시지';

  @override
  String get notificationPermissionRequest => '설정에서 알림 권한을 허용해주세요.';

  @override
  String get goToSettings => '설정으로 이동';

  @override
  String get comingSoon => '🚀 Coming Soon';

  @override
  String get difficultySettingsTitle => '💪 난이도 설정';

  @override
  String get notificationPermissionGranted => '알림 권한이 허용되었습니다! 🎉';

  @override
  String get settingsBannerText => '차드의 설정을 맞춤화하세요! ⚙️';

  @override
  String buildInfo(String buildNumber) {
    return '빌드: $buildNumber';
  }

  @override
  String versionAndBuild(String version, String buildNumber) {
    return '버전 $version+$buildNumber';
  }

  @override
  String get madeWithLove => '차드를 위해 ❤️로 제작';

  @override
  String get joinChadJourney => '차드가 되는 여정에 동참하세요';

  @override
  String get supportChadJourney => '당신의 차드 여정을 응원합니다! 🔥';

  @override
  String get selectLanguage => '사용할 언어를 선택해주세요';

  @override
  String get progress => '진행도';

  @override
  String get description => '설명';

  @override
  String get percentComplete => '완료';

  @override
  String get koreanLanguage => '한국어';

  @override
  String get englishLanguage => 'English';

  @override
  String get notificationPermissionGrantedMessage =>
      '🎉 알림 권한이 허용되었습니다! 차드 여정을 시작하세요!';

  @override
  String get notificationPermissionDeniedMessage =>
      '⚠️ 알림 권한이 필요합니다. 설정에서 허용해주세요.';

  @override
  String get notificationPermissionErrorMessage => '권한 요청 중 오류가 발생했습니다.';

  @override
  String get notificationPermissionLaterMessage => '나중에 설정에서 알림을 허용할 수 있습니다.';

  @override
  String get permissionsRequired => '🔐 권한이 필요해요';

  @override
  String get permissionsDescription =>
      'Mission 100에서 최고의 경험을 위해\n다음 권한들이 필요합니다:';

  @override
  String get notificationPermissionTitle => '🔔 알림 권한';

  @override
  String get notificationPermissionDesc => '운동 리마인더와 업적 알림을 받기 위해 필요합니다';

  @override
  String get storagePermissionTitle => '📁 저장소 권한';

  @override
  String get storagePermissionDesc => '운동 데이터 백업 및 복원을 위해 필요합니다';

  @override
  String get allowPermissions => '권한 허용하기';

  @override
  String get skipPermissions => '나중에 설정하기';

  @override
  String get permissionBenefits => '이 권한들을 허용하면:';

  @override
  String get notificationBenefit1 => '💪 매일 운동 리마인더';

  @override
  String get notificationBenefit2 => '🏆 업적 달성 축하 알림';

  @override
  String get notificationBenefit3 => '🔥 동기부여 메시지';

  @override
  String get storageBenefit1 => '📁 운동 데이터 안전 백업';

  @override
  String get storageBenefit2 => '🔄 기기 변경 시 데이터 복원';

  @override
  String get storageBenefit3 => '💾 데이터 손실 방지';

  @override
  String get permissionAlreadyRequested => '이미 권한을 요청했습니다.\n설정에서 수동으로 허용해주세요.';

  @override
  String get videoCannotOpen => '영상을 열 수 없습니다. YouTube 앱을 확인해주세요.';

  @override
  String get advertisement => '광고';

  @override
  String get chadLevel => '차드 레벨';

  @override
  String get progressVisualization => '진행률 시각화';

  @override
  String get weeklyGoal => 'Meta Semanal';

  @override
  String get monthlyGoal => 'Meta Mensual';

  @override
  String get streakProgress => '연속 운동 진행률';

  @override
  String get workoutChart => '운동 차트';

  @override
  String get days => '일';

  @override
  String get monthlyProgress => '월간 진행률';

  @override
  String get thisMonth => '이번 달';

  @override
  String get noWorkoutThisDay => '이 날에는 운동 기록이 없습니다';

  @override
  String get legend => '범례';

  @override
  String get perfect => '완벽!';

  @override
  String get good => '좋음';

  @override
  String get okay => '보통';

  @override
  String get poor => '부족';

  @override
  String get weekly => '주간';

  @override
  String get monthly => '월간';

  @override
  String get yearly => '연간';

  @override
  String get times => '회';

  @override
  String get count => '개';

  @override
  String get noWorkoutHistory => '운동 기록이 없습니다';

  @override
  String get noChartData => '차트 데이터가 없습니다';

  @override
  String get noPieChartData => '파이 차트 데이터가 없습니다';

  @override
  String get month => '월';

  @override
  String get dailyWorkoutReminder => '일일 운동 알림';

  @override
  String get streakEncouragement => '연속 운동 격려';

  @override
  String get streakEncouragementSubtitle => '3일 연속 운동 시 격려 메시지';

  @override
  String get notificationSetupFailed => '알림 설정에 실패했습니다';

  @override
  String get streakNotificationSet => '연속 운동 격려 알림이 설정되었습니다!';

  @override
  String dailyNotificationSet(Object time) {
    return '매일 $time에 운동 알림이 설정되었습니다!';
  }

  @override
  String get dailyReminderSubtitle => '매일 정해진 시간에 운동 알림';

  @override
  String get adFallbackMessage => '차드가 되는 여정을 함께하세요! 💪';

  @override
  String get testAdMessage => '테스트 광고 - 피트니스 앱';

  @override
  String get achievementCelebrationMessage => '차드의 힘을 느꼈다! 💪';

  @override
  String get workoutScreenAdMessage => '차드의 힘을 느껴라! 💪';

  @override
  String get achievementScreenAdMessage => '업적을 달성해서 차드가 되자! 🏆';

  @override
  String get tutorialAdviceBasic => '기본이 제일 중요하다, 만삣삐!';

  @override
  String get tutorialAdviceStart => '시작이 반이다!';

  @override
  String get tutorialAdviceForm => '완벽한 자세가 완벽한 차드를 만든다!';

  @override
  String get tutorialAdviceConsistency => '꾸준함이 차드 파워의 열쇠다!';

  @override
  String get difficultyEasy => '쉬움';

  @override
  String get difficultyMedium => '보통';

  @override
  String get difficultyHard => '어려움';

  @override
  String get difficultyExpert => '전문가';

  @override
  String dateFormatYearMonthDay(int year, int month, int day) {
    return '$year년 $month월 $day일';
  }

  @override
  String get rarityCommon => '일반';

  @override
  String get rarityRare => '레어';

  @override
  String get rarityEpic => '에픽';

  @override
  String get rarityLegendary => '레전더리';

  @override
  String get achievementUltimateMotivation => '당신은 궁극의 차드입니다! 🌟';

  @override
  String get achievementFirst50Title => '첫 50개 돌파';

  @override
  String get achievementFirst50Desc => '한 번의 운동에서 50개를 달성했습니다';

  @override
  String get achievementFirst50Motivation => '50개 돌파! 차드의 기반이 단단해지고 있습니다! 🎊';

  @override
  String get achievementFirst100SingleTitle => '한 번에 100개';

  @override
  String get achievementFirst100SingleDesc => '한 번의 운동에서 100개를 달성했습니다';

  @override
  String get achievementFirst100SingleMotivation => '한 번에 100개! 진정한 파워 차드! 💥';

  @override
  String get achievementStreak3Title => '3일 연속 차드';

  @override
  String get achievementStreak3Desc => '3일 연속 운동을 완료했습니다';

  @override
  String get achievementStreak3Motivation => '꾸준함이 차드를 만듭니다! 🔥';

  @override
  String get achievementStreak7Title => '주간 차드';

  @override
  String get achievementStreak7Desc => '7일 연속 운동을 완료했습니다';

  @override
  String get achievementStreak7Motivation => '일주일을 정복한 진정한 차드! 💪';

  @override
  String get achievementStreak14Title => '2주 마라톤 차드';

  @override
  String get achievementStreak14Desc => '14일 연속 운동을 완료했습니다';

  @override
  String get achievementStreak14Motivation => '끈기의 왕! 차드 중의 차드! 🏃‍♂️';

  @override
  String get achievementStreak30Title => '월간 궁극 차드';

  @override
  String get achievementStreak30Desc => '30일 연속 운동을 완료했습니다';

  @override
  String get achievementStreak30Motivation => '이제 당신은 차드의 왕입니다! 👑';

  @override
  String get achievementStreak60Title => '2개월 레전드 차드';

  @override
  String get achievementStreak60Desc => '60일 연속 운동을 완료했습니다';

  @override
  String get achievementStreak60Motivation => '2개월 연속! 당신은 레전드입니다! 🏅';

  @override
  String get achievementStreak100Title => '100일 신화 차드';

  @override
  String get achievementStreak100Desc => '100일 연속 운동을 완료했습니다';

  @override
  String get achievementStreak100Motivation => '100일 연속! 당신은 살아있는 신화입니다! 🌟';

  @override
  String get achievementTotal50Title => '첫 50개 총합';

  @override
  String get achievementTotal50Desc => '총 50개의 푸시업을 완료했습니다';

  @override
  String get achievementTotal50Motivation => '첫 50개! 차드의 새싹이 자라고 있습니다! 🌱';

  @override
  String get achievementTotal100Title => '첫 100개 돌파';

  @override
  String get achievementTotal100Desc => '총 100개의 푸시업을 완료했습니다';

  @override
  String get achievementTotal100Motivation => '첫 100개 돌파! 차드의 기반 완성! 💯';

  @override
  String get achievementTotal250Title => '250 차드';

  @override
  String get achievementTotal250Desc => '총 250개의 푸시업을 완료했습니다';

  @override
  String get achievementTotal250Motivation => '250개! 꾸준함의 결과! 🎯';

  @override
  String get achievementTotal500Title => '500 차드';

  @override
  String get achievementTotal500Desc => '총 500개의 푸시업을 완료했습니다';

  @override
  String get achievementTotal500Motivation => '500개 돌파! 중급 차드 달성! 🚀';

  @override
  String get achievementTotal1000Title => '1000 메가 차드';

  @override
  String get achievementTotal1000Desc => '총 1000개의 푸시업을 완료했습니다';

  @override
  String get achievementTotal1000Motivation => '1000개 돌파! 메가 차드 달성! ⚡';

  @override
  String get achievementTotal2500Title => '2500 슈퍼 차드';

  @override
  String get achievementTotal2500Desc => '총 2500개의 푸시업을 완료했습니다';

  @override
  String get achievementTotal2500Motivation => '2500개! 슈퍼 차드의 경지에 도달! 🔥';

  @override
  String get achievementTotal5000Title => '5000 울트라 차드';

  @override
  String get achievementTotal5000Desc => '총 5000개의 푸시업을 완료했습니다';

  @override
  String get achievementTotal5000Motivation => '5000개! 당신은 울트라 차드입니다! 🌟';

  @override
  String get achievementTotal10000Title => '10000 갓 차드';

  @override
  String get achievementTotal10000Desc => '총 10000개의 푸시업을 완료했습니다';

  @override
  String get achievementTotal10000Motivation => '10000개! 당신은 차드의 신입니다! 👑';

  @override
  String get achievementPerfect3Title => '완벽한 트리플';

  @override
  String get achievementPerfect3Desc => '3번의 완벽한 운동을 달성했습니다';

  @override
  String get achievementPerfect3Motivation => '완벽한 트리플! 정확성의 차드! 🎯';

  @override
  String get achievementPerfect5Title => '완벽주의 차드';

  @override
  String get achievementPerfect5Desc => '5번의 완벽한 운동을 달성했습니다';

  @override
  String get achievementPerfect5Motivation => '완벽을 추구하는 진정한 차드! ⭐';

  @override
  String get achievementPerfect10Title => '마스터 차드';

  @override
  String get achievementPerfect10Desc => '10번의 완벽한 운동을 달성했습니다';

  @override
  String get achievementPerfect10Motivation => '완벽의 마스터! 차드 중의 차드! 🏆';

  @override
  String get achievementPerfect20Title => '완벽 레전드';

  @override
  String get achievementPerfect20Desc => '20번의 완벽한 운동을 달성했습니다';

  @override
  String get achievementPerfect20Motivation => '20번 완벽! 당신은 완벽의 화신입니다! 💎';

  @override
  String get achievementTutorialExplorerTitle => '탐구하는 차드';

  @override
  String get achievementTutorialExplorerDesc => '첫 번째 푸시업 튜토리얼을 확인했습니다';

  @override
  String get achievementTutorialExplorerMotivation => '지식이 차드의 첫 번째 힘입니다! 🔍';

  @override
  String get achievementTutorialStudentTitle => '학습하는 차드';

  @override
  String get achievementTutorialStudentDesc => '5개의 푸시업 튜토리얼을 확인했습니다';

  @override
  String get achievementTutorialStudentMotivation => '다양한 기술을 배우는 진정한 차드! 📚';

  @override
  String get achievementTutorialMasterTitle => '푸시업 마스터';

  @override
  String get achievementTutorialMasterDesc => '모든 푸시업 튜토리얼을 확인했습니다';

  @override
  String get achievementTutorialMasterMotivation => '모든 기술을 마스터한 푸시업 박사! 🎓';

  @override
  String get achievementEarlyBirdTitle => '새벽 차드';

  @override
  String get achievementEarlyBirdMotivation => '새벽을 정복한 얼리버드 차드! 🌅';

  @override
  String get achievementNightOwlTitle => '야행성 차드';

  @override
  String get achievementNightOwlMotivation => '밤에도 포기하지 않는 올빼미 차드! 🦉';

  @override
  String get achievementWeekendWarriorTitle => '주말 전사';

  @override
  String get achievementWeekendWarriorDesc => '주말에 꾸준히 운동하는 차드';

  @override
  String get achievementWeekendWarriorMotivation => '주말에도 멈추지 않는 전사! ⚔️';

  @override
  String get achievementLunchBreakTitle => '점심시간 차드';

  @override
  String get achievementLunchBreakDesc => '점심시간(12-2시)에 5번 운동했습니다';

  @override
  String get achievementLunchBreakMotivation => '점심시간도 놓치지 않는 효율적인 차드! 🍽️';

  @override
  String get achievementSpeedDemonTitle => '스피드 데몬';

  @override
  String get achievementSpeedDemonMotivation => '번개 같은 속도! 스피드의 차드! 💨';

  @override
  String get achievementEnduranceKingTitle => '지구력의 왕';

  @override
  String get achievementEnduranceKingDesc => '30분 이상 운동을 지속했습니다';

  @override
  String get achievementEnduranceKingMotivation => '30분 지속! 지구력의 왕! ⏰';

  @override
  String get achievementComebackKidTitle => '컴백 키드';

  @override
  String get achievementComebackKidDesc => '7일 이상 쉰 후 다시 운동을 시작했습니다';

  @override
  String get achievementComebackKidMotivation => '포기하지 않는 마음! 컴백의 차드! 🔄';

  @override
  String get achievementOverachieverTitle => '목표 초과 달성자';

  @override
  String get achievementOverachieverMotivation => '목표를 뛰어넘는 오버어치버! 📈';

  @override
  String get achievementDoubleTroubleTitle => '더블 트러블';

  @override
  String get achievementDoubleTroubleDesc => '목표의 200%를 달성했습니다';

  @override
  String get achievementDoubleTroubleMotivation => '목표의 2배! 더블 트러블 차드! 🎪';

  @override
  String get achievementConsistencyMasterTitle => '일관성의 마스터';

  @override
  String get achievementConsistencyMasterDesc => '10일 연속 목표를 정확히 달성했습니다';

  @override
  String get achievementConsistencyMasterMotivation =>
      '정확한 목표 달성! 일관성의 마스터! 🎯';

  @override
  String get achievementLevel5Title => '레벨 5 차드';

  @override
  String get achievementLevel5Desc => '레벨 5에 도달했습니다';

  @override
  String get achievementLevel5Motivation => '레벨 5 달성! 중급 차드의 시작! 🌟';

  @override
  String get achievementLevel10Title => '레벨 10 차드';

  @override
  String get achievementLevel10Desc => '레벨 10에 도달했습니다';

  @override
  String get achievementLevel10Motivation => '레벨 10! 고급 차드의 경지! 🏅';

  @override
  String get achievementLevel20Title => '레벨 20 차드';

  @override
  String get achievementLevel20Desc => '레벨 20에 도달했습니다';

  @override
  String get achievementLevel20Motivation => '레벨 20! 차드 중의 왕! 👑';

  @override
  String get achievementMonthlyWarriorTitle => '월간 전사';

  @override
  String get achievementMonthlyWarriorDesc => '한 달에 20일 이상 운동했습니다';

  @override
  String get achievementMonthlyWarriorMotivation => '한 달 20일! 월간 전사 차드! 📅';

  @override
  String get achievementSeasonalChampionTitle => '시즌 챔피언';

  @override
  String get achievementSeasonalChampionDesc => '3개월 연속 월간 목표를 달성했습니다';

  @override
  String get achievementSeasonalChampionMotivation => '3개월 연속! 시즌 챔피언! 🏆';

  @override
  String get achievementVarietySeekerTitle => '다양성 추구자';

  @override
  String get achievementVarietySeekerDesc => '5가지 다른 푸시업 타입을 시도했습니다';

  @override
  String get achievementVarietySeekerMotivation => '다양함을 추구하는 창의적 차드! 🎨';

  @override
  String get achievementAllRounderTitle => '올라운더';

  @override
  String get achievementAllRounderDesc => '모든 푸시업 타입을 시도했습니다';

  @override
  String get achievementAllRounderMotivation => '모든 타입 마스터! 올라운더 차드! 🌈';

  @override
  String get achievementIronWillTitle => '강철 의지';

  @override
  String get achievementIronWillMotivation => '200개 한 번에! 강철 같은 의지! 🔩';

  @override
  String get achievementUnstoppableForceTitle => '멈출 수 없는 힘';

  @override
  String get achievementUnstoppableForceDesc => '한 번에 300개를 달성했습니다';

  @override
  String get achievementUnstoppableForceMotivation =>
      '300개! 당신은 멈출 수 없는 힘입니다! 🌪️';

  @override
  String get achievementLegendaryBeastTitle => '레전더리 비스트';

  @override
  String get achievementLegendaryBeastDesc => '한 번에 500개를 달성했습니다';

  @override
  String get achievementLegendaryBeastMotivation => '500개! 당신은 레전더리 비스트입니다! 🐉';

  @override
  String get achievementMotivatorTitle => '동기부여자';

  @override
  String get achievementMotivatorDesc => '앱을 30일 이상 사용했습니다';

  @override
  String get achievementMotivatorMotivation => '30일 사용! 진정한 동기부여자! 💡';

  @override
  String get achievementDedicationMasterTitle => '헌신의 마스터';

  @override
  String get achievementDedicationMasterDesc => '앱을 100일 이상 사용했습니다';

  @override
  String get achievementDedicationMasterMotivation =>
      '100일 헌신! 당신은 헌신의 마스터입니다! 🎖️';

  @override
  String get githubRepository => 'GitHub 저장소';

  @override
  String get feedbackEmail => '이메일로 피드백 보내기';

  @override
  String get developerContact => '개발자 연락처';

  @override
  String get openGithub => 'GitHub에서 소스코드 보기';

  @override
  String get emailFeedback => '이메일로 의견을 보내주세요';

  @override
  String get cannotOpenEmail => '이메일 앱을 열 수 없습니다';

  @override
  String get cannotOpenGithub => 'GitHub을 열 수 없습니다';

  @override
  String get appVersion => '앱 버전';

  @override
  String get builtWithFlutter => 'Flutter로 제작됨';

  @override
  String get challenge7DaysTitle => '7일 연속 운동';

  @override
  String get challenge7DaysDescription => '7일 동안 연속으로 운동하기';

  @override
  String get challenge7DaysDetailedDescription =>
      '하루도 빠짐없이 7일 동안 연속으로 운동을 완료하세요. 매일 최소 1세트 이상 운동해야 합니다.';

  @override
  String get challenge50SingleTitle => '50개 한번에';

  @override
  String get challenge50SingleDescription => '한 번의 운동에서 50개 팔굽혀펴기';

  @override
  String get challenge50SingleDetailedDescription =>
      '쉬지 않고 한 번에 50개의 팔굽혀펴기를 완료하세요. 중간에 멈추면 처음부터 다시 시작해야 합니다.';

  @override
  String get challenge100CumulativeTitle => '100개 챌린지';

  @override
  String get challenge100CumulativeDescription => '총 100개 팔굽혀펴기 달성';

  @override
  String get challenge100CumulativeDetailedDescription =>
      '여러 세션에 걸쳐 총 100개의 팔굽혀펴기를 완료하세요.';

  @override
  String get challenge200CumulativeTitle => '200개 챌린지';

  @override
  String get challenge200CumulativeDescription => '총 200개 팔굽혀펴기 달성';

  @override
  String get challenge200CumulativeDetailedDescription =>
      '여러 세션에 걸쳐 총 200개의 팔굽혀펴기를 완료하세요. 100개 챌린지를 완료한 후에 도전할 수 있습니다.';

  @override
  String get challenge14DaysTitle => '14일 연속 운동';

  @override
  String get challenge14DaysDescription => '14일 동안 연속으로 운동하기';

  @override
  String get challenge14DaysDetailedDescription =>
      '하루도 빠짐없이 14일 동안 연속으로 운동을 완료하세요. 7일 연속 챌린지를 완료한 후에 도전할 수 있습니다.';

  @override
  String get challengeRewardConsecutiveWarrior => '연속 운동 전사 배지';

  @override
  String get challengeRewardPowerLifter => '파워 리프터 배지';

  @override
  String get challengeRewardCenturyClub => '센추리 클럽 배지';

  @override
  String get challengeRewardUltimateChampion => '궁극의 챔피언 배지';

  @override
  String get challengeRewardDedicationMaster => '헌신의 마스터 배지';

  @override
  String challengeRewardPoints(String points) {
    return '$points 포인트';
  }

  @override
  String get challengeRewardAdvancedStats => '고급 통계 기능 해금';

  @override
  String get challengeUnitDays => '일';

  @override
  String get challengeUnitReps => '개';

  @override
  String get challengeStatusAvailable => '도전 가능';

  @override
  String get challengeStatusActive => '진행 중';

  @override
  String get challengeStatusCompleted => '완료';

  @override
  String get challengeStatusFailed => '실패';

  @override
  String get challengeStatusLocked => '잠김';

  @override
  String get challengeDifficultyEasy => '쉬움';

  @override
  String get challengeDifficultyMedium => '보통';

  @override
  String get challengeDifficultyHard => '어려움';

  @override
  String get challengeDifficultyExtreme => '극한';

  @override
  String get challengeTypeConsecutiveDays => '연속 일수';

  @override
  String get challengeTypeSingleSession => '단일 세션';

  @override
  String get challengeTypeCumulative => '누적';

  @override
  String get challengesTitle => '챌린지';

  @override
  String get challengesAvailable => '도전 가능';

  @override
  String get challengesActive => '진행 중';

  @override
  String get challengesCompleted => '완료';

  @override
  String get challengeStartButton => '시작하기';

  @override
  String get challengeAbandonButton => '포기하기';

  @override
  String get challengeRestartButton => '다시 시작';

  @override
  String challengeProgress(int progress) {
    return 'Progreso del Desafío';
  }

  @override
  String challengeEstimatedDuration(int duration) {
    return '예상 기간: $duration일';
  }

  @override
  String get challengeRewards => '보상';

  @override
  String get challengeCompleted => '챌린지 완료!';

  @override
  String get challengeFailed => '챌린지 실패';

  @override
  String get challengeStarted => '챌린지가 시작되었습니다! 🔥';

  @override
  String get challengeAbandoned => '챌린지 포기됨';

  @override
  String get challengePrerequisitesNotMet => '전제 조건이 충족되지 않았습니다';

  @override
  String get challengeAlreadyActive => '이미 활성화된 챌린지가 있습니다';

  @override
  String get challengeHintConsecutiveDays =>
      '매일 꾸준히 운동하세요! 하루라도 빠뜨리면 처음부터 다시 시작해야 합니다.';

  @override
  String get challengeHintSingleSession => '한 번에 목표 개수를 달성하세요! 중간에 쉬면 안 됩니다.';

  @override
  String get challengeHintCumulative => '여러 번에 걸쳐 목표를 달성하세요. 꾸준히 하면 됩니다!';

  @override
  String get sendFriendChallenge => '💀 친구에게 차드 도전장 발송! 💀';

  @override
  String get refresh => '새로고침';

  @override
  String get achieved => '달성';

  @override
  String get shareButton => '공유';

  @override
  String get todayMission => '오늘의 미션';

  @override
  String get todayTarget => '오늘의 목표:';

  @override
  String setFormat2(int number, int reps) {
    return '$number세트: $reps회';
  }

  @override
  String completedFormat(int totalReps, int totalSets) {
    return '완료: $totalReps개 / $totalSets세트';
  }

  @override
  String totalFormat(int reps, int sets) {
    return '총 $reps회 ($sets세트)';
  }

  @override
  String get todayWorkoutCompleted => '🎉 오늘 운동 완료! 🎉';

  @override
  String get justWait => '오늘은 회복의 날이다. 하지만 선택은 너의 것.';

  @override
  String get progressTracking => '진행률 추적';

  @override
  String get sleepyHatChad => '수면모자 Chad';

  @override
  String get journeyStartingChad => '각성을 시작한 Chad.\n잠재력이 깨어나고 있다.';

  @override
  String weekDayFormat(int week, int day) {
    return '$week주차 $day일차';
  }

  @override
  String get notificationPermissionPerfect => '알림 권한 완벽!';

  @override
  String get basicNotificationPermission => '기본 알림 권한';

  @override
  String get exactNotificationPermission => '정확한 알림 권한';

  @override
  String get congratulationsMessage => '축하합니다! 모든 권한이 완벽하게 설정되었습니다! 🎉';

  @override
  String get workoutDayNotification => '운동일 전용 알림';

  @override
  String get chadEvolutionCompleteNotification => 'Chad 진화 완료 알림';

  @override
  String get chadEvolutionPreviewNotification => 'Chad 진화 예고 알림';

  @override
  String get chadEvolutionQuarantineNotification => 'Chad 진화 격리 알림';

  @override
  String get themeColor => '테마 색상';

  @override
  String get fontSize => '글자 크기';

  @override
  String get animationEffect => '애니메이션 효과';

  @override
  String get highContrastMode => '고대비 모드';

  @override
  String get backupManagement => '백업 관리';

  @override
  String get backupManagementDesc => '데이터 백업, 복원 및 자동 백업 설정을 관리합니다.';

  @override
  String get levelReset => '레벨 리셋';

  @override
  String get levelResetDesc => '모든 진행 상황을 초기화하고 처음부터 시작합니다.';

  @override
  String get licenseInfo => '라이선스 정보';

  @override
  String get licenseInfoDesc => '앱에서 사용된 라이선스 정보..';

  @override
  String get todayMissionTitle => '오늘의 미션';

  @override
  String get todayGoalTitle => '오늘의 목표';

  @override
  String setRepsFormat(int setCount, int repsCount) {
    return '$setCount세트 × $repsCount회';
  }

  @override
  String completedRepsFormat(int completed) {
    return '완료: $completed회';
  }

  @override
  String totalRepsFormat(int total) {
    return '총 $total회';
  }

  @override
  String get notificationPermissionCheckingStatus => '알림 권한 상태를 확인하고 있습니다';

  @override
  String get notificationPermissionNeeded => '❌ 알림 권한 필요';

  @override
  String get exactAlarmPermission => '정확한 알람 권한';

  @override
  String get allowNotificationPermission => '알림 권한 허용하기';

  @override
  String get setExactAlarmPermission => '정확한 알람 권한 설정하기';

  @override
  String get requiredLabel => '필수';

  @override
  String get recommendedLabel => '권장';

  @override
  String get activatedStatus => '활성화됨';

  @override
  String get themeColorDesc => '앱의 메인 색상을 변경합니다';

  @override
  String get fontScale => '글자 크기';

  @override
  String get fontScaleDesc => '앱 전체의 텍스트 크기를 조정합니다';

  @override
  String get animationsEnabled => '애니메이션이 활성화되었습니다';

  @override
  String get animationsEnabledDesc => '앱 전체의 애니메이션 효과를 켜거나 끕니다';

  @override
  String get highContrastModeDesc => '시각적 접근성을 위한 고대비 모드를 활성화합니다';

  @override
  String get levelResetConfirm => '레벨 리셋 확인';

  @override
  String get urlNotAvailableTitle => '페이지 준비 중';

  @override
  String urlNotAvailableMessage(String page) {
    return '$page 페이지는 아직 준비되지 않았습니다. 향후 업데이트에서 제공될 예정입니다.';
  }

  @override
  String get openInBrowser => '브라우저에서 열기';

  @override
  String get ok => '확인';

  @override
  String get loadingText => '로딩 중...';

  @override
  String get refreshButton => '새로고침';

  @override
  String get errorLoadingData => '데이터를 불러오는 중 오류가 발생했습니다';

  @override
  String get retryButton => '다시 시도';

  @override
  String get noUserProfile => '사용자 프로필이 없습니다';

  @override
  String get completeInitialTest => '초기 테스트를 완료하여 프로필을 생성해주세요';

  @override
  String get sleepyChadEvolution => '수면모자 Chad';

  @override
  String get journeyChadEvolution => '여정을 시작하는 Chad';

  @override
  String get setRepsDisplayFormat => '세트 × 횟수';

  @override
  String weeksRemaining(int weeks) {
    return '$weeks주 남음';
  }

  @override
  String thisWeekProgress(int current) {
    return '이번 주 ($current주차)';
  }

  @override
  String weeksCompleted(int completed, int total) {
    return '$completed/$total 주 완료';
  }

  @override
  String get completionRate => '완료율';

  @override
  String get workoutTime => '운동 시간';

  @override
  String get remainingGoal => '남은 목표';

  @override
  String setRepFormat(int setIndex, int reps) {
    return '$setIndex세트: $reps개';
  }

  @override
  String goalFormat(int totalReps, int totalSets) {
    return '목표: $totalReps개 / $totalSets세트';
  }

  @override
  String get restDayChampionTitle => '🔥 진짜 챔피언의 선택';

  @override
  String get restDayDescription =>
      '오늘은 프로그램상 휴식일이지만...\n진짜 챔피언들은 쉬지 않는다! 🔥\n\n추가 챌린지를 진행하시겠습니까?';

  @override
  String get challengeMode => '챌린지 모드';

  @override
  String get challengeModeDescription =>
      '그냥 기본 운동? 아니면 진짜 챔피언 모드? 🚀\n\n⚡ 챌린지 모드 ON 하면:\n• 더 높은 난이도\n• 보너스 포인트 획득 🏆';

  @override
  String get challengeModeOn => '챌린지 모드 ON! 🔥';

  @override
  String get challengeModeActivated => '🔥 챌린지 모드 활성화! 정신력을 시험해보자! 💪';

  @override
  String get workoutAlreadyCompleted => '오늘의 운동은 이미 완료했습니다! 💪';

  @override
  String get restDayChallenge =>
      '휴식일이라고? 그런 건 약한 놈들이나 하는 거야!\n진짜 챔피언들은 매일이 전쟁이다! 🥊\n\n간단한 추가 챌린지로 너의 정신력을 증명해봐!';

  @override
  String get restDayAccept => '휴식일을 받아들이시겠습니까?';

  @override
  String get restDayTeasing => '누군가는 100개 푸시업하고 있어! 💪\n\n정말 오늘은 쉬실 건가요?';

  @override
  String get noWorkout => '아니다! 운동할래!';

  @override
  String get bonusChallenge => '🔥 보너스 챌린지';

  @override
  String get workoutCompleted => '완료';

  @override
  String get workoutAchieved => '달성';

  @override
  String get shareWorkout => '공유하기';

  @override
  String get shareError => '공유 중 오류가 발생했습니다.';

  @override
  String get workoutSaveError => '운동 저장 중 오류가 발생했습니다.';

  @override
  String setCount(int count) {
    return '$count세트';
  }

  @override
  String repsCount(int count) {
    return '$count개';
  }

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get onboardingNext => '다음';

  @override
  String get permissionNotificationMessage =>
      '알림 및 저장소 권한이 필요합니다. 설정에서 허용해주세요.';

  @override
  String get permissionStorageMessage => '저장소 권한이 필요합니다. 설정에서 허용해주세요.';

  @override
  String get challengeCannotStart => '챌린지를 시작할 수 없습니다.';

  @override
  String get challengeGiveUpTitle => '챌린지 포기';

  @override
  String get challengeGiveUpMessage => '정말로 이 챌린지를 포기하시겠습니까?';

  @override
  String get challengeGaveUp => '챌린지를 포기했습니다.';

  @override
  String get challengeTitle => 'Desafío';

  @override
  String get challengeTabCompleted => '완료';

  @override
  String get noChallengesAvailable => '사용 가능한 챌린지가 없습니다';

  @override
  String get unlockMoreChallenges => '더 많은 운동을 완료하여 새로운 챌린지를 해금하세요!';

  @override
  String get noActiveChallenges => '진행 중인 챌린지가 없습니다';

  @override
  String get startNewChallenge => '새로운 챌린지를 시작해보세요!';

  @override
  String get noCompletedChallenges => '완료된 챌린지가 없습니다';

  @override
  String get completeFirstChallenge => '첫 번째 챌린지를 완료해보세요!';

  @override
  String get pushupTutorialTitle => '차드 푸시업 도장';

  @override
  String get pushupTutorialSubtitle => '진짜 차드들은 자세부터 다르다! 💪';

  @override
  String get pushupStandard => '기본 푸시업';

  @override
  String get pushupKnee => '무릎 푸시업';

  @override
  String get pushupIncline => '인클라인 푸시업';

  @override
  String get pushupWideGrip => '와이드 그립 푸시업';

  @override
  String get pushupDiamond => '다이아몬드 푸시업';

  @override
  String get pushupDecline => '디클라인 푸시업';

  @override
  String get pushupArcher => '아처 푸시업';

  @override
  String get pushupPike => '파이크 푸시업';

  @override
  String get pushupClap => '박수 푸시업';

  @override
  String get pushupOneArm => '원핸드 푸시업';

  @override
  String get chadDescription => '💪 차드 설명';

  @override
  String get chadAdvice => '🔥 차드의 조언';

  @override
  String get chadMotivationStandard =>
      '기본이 제일 중요하다, 만삣삐! 완벽한 폼으로 하나하나 쌓아가면 진짜 차드가 된다!';

  @override
  String get chadMotivationKnee =>
      '시작이 반이다! 무릎 푸시업도 제대로 하면 금방 일반 푸시업으로 갈 수 있어!';

  @override
  String get chadMotivationIncline =>
      '단계적으로 올라가는 것이 차드의 길이다! 각도를 점점 낮춰가면서 도전해봐!';

  @override
  String get chadMotivationWideGrip =>
      '가슴을 활짝 펴고 차드의 기운을 받아라! 넓은 가슴이 진짜 차드의 상징이다!';

  @override
  String get chadMotivationDiamond =>
      '다이아몬드처럼 귀한 네 삼두근을 만들어라! 팔 근육 폭발하는 기분을 느껴봐!';

  @override
  String get chadMotivationDecline =>
      '높은 곳을 향해 도전하는 것이 차드다! 어깨와 상체가 불타오르는 걸 느껴봐!';

  @override
  String get chadMotivationArcher =>
      '균형과 집중력이 필요한 고급 기술! 한쪽씩 완벽하게 해내면 진짜 차드 인정!';

  @override
  String get chadMotivationPike => '핸드스탠드의 첫걸음! 어깨 근육이 터져나갈 것 같은 기분을 만끽해라!';

  @override
  String get chadMotivationClap =>
      '폭발적인 파워로 박수를 쳐라! 이거 되면 너도 진짜 차드다, fxxk yeah!';

  @override
  String get chadMotivationOneArm =>
      '원핸드 푸시업은 차드의 완성형이다! 이거 한 번이라도 하면 진짜 기가 차드 인정, fxxk yeah!';

  @override
  String get chadMotivationDefault => '차드의 길은 험하지만 그래서 더 가치있다! 포기하지 마라, 만삣삐!';

  @override
  String get customWorkoutDays => '운동일 설정';

  @override
  String get customWorkoutDaysDesc => '원하는 요일에 운동하도록 설정하세요';

  @override
  String get workoutDaySelection => '운동 요일 선택';

  @override
  String get selectWorkoutDays => '주 3일 운동할 요일을 선택하세요';

  @override
  String get mondayShort => '월';

  @override
  String get tuesdayShort => '화';

  @override
  String get wednesdayShort => '수';

  @override
  String get thursdayShort => '목';

  @override
  String get fridayShort => '금';

  @override
  String get saturdayShort => '토';

  @override
  String get sundayShort => '일';

  @override
  String get restDayMessage => '오늘은 회복의 날. 진정한 강함은 휴식에서 나온다.';

  @override
  String get workoutDaysOnlyNotifications => '🔥 운동일 전용 알림';

  @override
  String get workoutDaysOnlyNotificationsDesc =>
      '매일이 아닌 운동일(월,수,금)에만 알림을 받습니다. 휴식일엔 방해받지 않아요!';

  @override
  String get chadEvolutionNotifications => 'Chad 진화 완료 알림';

  @override
  String get chadEvolutionNotificationsDesc => 'Chad가 새로운 단계로 진화했을 때 알림을 받습니다';

  @override
  String get chadEvolutionPreviewNotifications => 'Chad 진화 예고 알림';

  @override
  String get chadEvolutionPreviewNotificationsDesc =>
      '다음 진화까지 1주일 남았을 때 미리 알림을 받습니다';

  @override
  String get chadEvolutionEncouragementNotifications => 'Chad 진화 격려 알림';

  @override
  String get chadEvolutionEncouragementNotificationsDesc =>
      '다음 진화까지 3일 남았을 때 격려 메시지를 받습니다';

  @override
  String get workoutReminderDisabled => '운동 리마인더가 비활성화되었습니다';

  @override
  String get workoutDaysModeActivated =>
      '💪 운동일 전용 알림 모드 활성화! 월,수,금에만 알림이 옵니다!';

  @override
  String get dailyNotificationModeChanged => '매일 알림 모드로 변경! 매일 알림 받아요! 📱';

  @override
  String get fontSizeDesc => '앱의 글자 크기를 조정합니다';

  @override
  String get animations => '애니메이션';

  @override
  String get animationsDesc => '앱의 애니메이션 효과를 활성화/비활성화합니다';

  @override
  String get animationsDisabled => '애니메이션이 비활성화되었습니다';

  @override
  String get highContrastEnabled => '고대비 모드가 활성화되었습니다';

  @override
  String get highContrastDisabled => '고대비 모드가 비활성화되었습니다';

  @override
  String get themeColorSelection => '테마 색상 선택';

  @override
  String themeColorChanged(String colorName) {
    return '테마 색상이 $colorName로 변경되었습니다';
  }

  @override
  String get required => '필수';

  @override
  String get activated => '활성화됨';

  @override
  String get perfectFormChallenge => '🎯 완벽 자세 챌린지 활성화! 대충하면 안 된다! 💪';

  @override
  String get sevenDayStreak => '🔄 7일 연속 챌린지 시작! 하루라도 빠지면 처음부터! 🚀';

  @override
  String get challengeTestYourLimits => '💪 오늘 너의 한계를 시험해볼까?';

  @override
  String get restDayBonusChallenge =>
      '휴식일 보너스 챌린지! 💪\n\n• 플랭크 30초 x 3세트\n• 스쿼트 20개 x 2세트\n• 푸시업 10개 (완벽한 자세로!)\n\n준비됐어? 진짜 챔피언만 할 수 있어! 🏆';

  @override
  String get startChallenge => '챌린지 시작! 🔥';

  @override
  String get stepByStepGuide => '단계별\n가이드';

  @override
  String get commonMistakes => 'Errores Comunes';

  @override
  String get variationExercises => '변형\n운동';

  @override
  String get improvementTips => '개선\n팁';

  @override
  String get correctPushupForm5Steps => '올바른 푸시업 자세 5단계';

  @override
  String get chadPerfectPushupForm => '차드가 알려주는 완벽한 푸시업 폼! 💪';

  @override
  String get listView => '목록 보기';

  @override
  String get swipeView => '스와이프 보기';

  @override
  String get quiz => '퀴즈';

  @override
  String get dontMakeTheseMistakes => '이런 실수는 하지 마라!';

  @override
  String get chadMistakesAdvice => '차드도 처음엔 실수했다. 하지만 이제는 완벽하지! 🔥';

  @override
  String get pushupVariationsByDifficulty => '난이도별 푸시업 변형';

  @override
  String get beginnerToChad => '초보자부터 차드까지! 단계별로 도전해보자! 🚀';

  @override
  String get chadSecretTips => '차드의 특급 비법';

  @override
  String get becomeTrueChadTips => '이 팁들로 너도 진짜 차드가 될 수 있다! 💎';

  @override
  String get startPosition => '시작 자세';

  @override
  String get descendingMotion => '하강 동작';

  @override
  String get bottomPosition => '최하점 자세';

  @override
  String get ascendingMotion => '상승 동작';

  @override
  String get finishPosition => '완료 자세';

  @override
  String get startPositionDesc => '플랭크 자세로 시작하여 손과 발의 위치를 정확히 설정합니다.';

  @override
  String get descendingMotionDesc => '팔꿈치를 구부리며 천천히 몸을 아래로 내립니다.';

  @override
  String get bottomPositionDesc => '가슴이 바닥에 거의 닿는 최하점에서 잠시 정지합니다.';

  @override
  String get ascendingMotionDesc => '팔을 펴며 시작 자세로 돌아갑니다.';

  @override
  String get finishPositionDesc => '시작 자세로 완전히 돌아와 다음 반복을 준비합니다.';

  @override
  String get correctPushupQuiz1 => '올바른 푸시업 시작 자세에서 손의 위치는?';

  @override
  String get pushupMistakeQuiz => '푸시업 중 가장 흔한 실수는?';

  @override
  String get beginnerPushupQuiz => '초보자에게 가장 적합한 푸시업 변형은?';

  @override
  String get pushupBreathingQuiz => '푸시업 시 올바른 호흡법은?';

  @override
  String get elbowAngleQuiz => '푸시업에서 팔꿈치의 올바른 각도는?';

  @override
  String get wrongPose => '잘못된 자세';

  @override
  String get correctPose => '올바른 자세';

  @override
  String get correctionMethod => '교정 방법:';

  @override
  String get beginnerLevel => '초급자';

  @override
  String get intermediateLevel => '중급자';

  @override
  String get advancedLevel => '고급자';

  @override
  String get instructions => '운동 방법';

  @override
  String get benefits => '운동 효과';

  @override
  String get breathingTechnique => '호흡법';

  @override
  String get strengthImprovement => '근력 향상';

  @override
  String get recovery => '회복';

  @override
  String get motivation => '동기부여';

  @override
  String get overallProgress => '전체 진행률';

  @override
  String get sessions => '세션';

  @override
  String get completedCount => '완료한 횟수';

  @override
  String get remainingCount => '남은 횟수';

  @override
  String get weeklyGrowthChart => '주간 성장 차트';

  @override
  String get weeklyDetails => '주차별 상세';

  @override
  String get sessionsCompleted => '세션 완료';

  @override
  String get workoutCalendar => '워크아웃 캘린더';

  @override
  String get chadEvolutionStage => 'Chad 진화단계';

  @override
  String get completedSessions => '완료 세션';

  @override
  String get overallStatistics => '전체통계';

  @override
  String get programProgress => '프로그램 진행률';

  @override
  String get repsCompleted => '회 완료';

  @override
  String get weekCompleted => '주차';

  @override
  String get chadEvolutionStages => 'Chad 진화 단계';

  @override
  String get noWorkoutsToday => '이 날에는 워크아웃이 없습니다';

  @override
  String get inProgress => '진행 중';

  @override
  String get setRecords => '세트별 기록:';

  @override
  String get overallStats => '전체 통계';

  @override
  String get averagePerSession => '평균/세션';

  @override
  String get weeklyPerformance => '주간별 성과';

  @override
  String get viewAll => '전체 보기';

  @override
  String get improvementNeeded => '개선 필요';

  @override
  String get personalRecords => '개인 기록';

  @override
  String get bestWeek => '최고 주차';

  @override
  String get consecutiveDays => '연속 일수';

  @override
  String get averageScore => '평균 점수';

  @override
  String get rookieChad => 'Rookie Chad';

  @override
  String get risingChad => 'Rising Chad';

  @override
  String get alphaChad => 'Alpha Chad';

  @override
  String get sigmaChad => 'Sigma Chad';

  @override
  String get gigaChad => 'Giga Chad';

  @override
  String get ultraChad => 'Ultra Chad';

  @override
  String get legendaryChad => 'Legendary Chad';

  @override
  String get currentChadState => '현재 Chad 상태';

  @override
  String get nextLevel => '다음 레벨까지';

  @override
  String get nextLevelIn => '다음 레벨까지 30% 남음';

  @override
  String get maxLevelAchieved => '최고 레벨 달성!';

  @override
  String get programStart => '프로그램 시작';

  @override
  String get week1Completed => '1주차 완료';

  @override
  String get week2Completed => '2주차 완료';

  @override
  String get week3Completed => '3주차 완료';

  @override
  String get week4Completed => '4주차 완료';

  @override
  String get week5Completed => '5주차 완료';

  @override
  String get week6Completed => '6주차 완료';

  @override
  String get firstStep => '첫 걸음';

  @override
  String get firstWorkoutCompleted => '첫 번째 워크아웃 완료';

  @override
  String get oneWeekChallenge => '일주일 챌린지';

  @override
  String get sevenDaysExercise => '7일 연속 운동';

  @override
  String get hundredPushups => '백 푸시업';

  @override
  String get hundredRepsInOneSession => '한 세션에 100회 달성';

  @override
  String get perfectWeek => '완벽주의자';

  @override
  String get oneWeekCompleted => '한 주 100% 완료';

  @override
  String get chadAchievements => 'Chad 업적';

  @override
  String get chadEvolution => 'Chad 진화';

  @override
  String get noData => '데이터가 없습니다';

  @override
  String get weeklyChallenge => '일주일 챌린지';

  @override
  String get improvement => '개선 필요';

  @override
  String get excellent => '좋음';

  @override
  String get noDataAvailable => '데이터가 없습니다';

  @override
  String get firstStepDesc => '첫 번째 워크아웃 완료';

  @override
  String get weeklyChallengeDesc => '7일 연속 운동';

  @override
  String get hundredPushupsDesc => '한 세션에 100회 달성';

  @override
  String get perfectionistDesc => '한 주 100% 완료';

  @override
  String get noWorkoutToday => '이 날에는 워크아웃이 없습니다.';

  @override
  String get remaining => '남음';

  @override
  String workoutDate(int month, int day) {
    return '$month월 $day일 워크아웃';
  }

  @override
  String weekX(int week) {
    return '$week주차';
  }

  @override
  String dayX(int day) {
    return '$day일차';
  }

  @override
  String sessionsCompletedFormat(int completed, int total, int reps) {
    return '$completed/$total 세션 완료 • $reps회';
  }

  @override
  String get cannotOpenPrivacyPolicy => '개인정보처리방침을 열 수 없습니다';

  @override
  String get cannotOpenTermsOfService => '이용약관을 열 수 없습니다';

  @override
  String get excellentPerformance => '🚀 EXCELLENT! 완벽한 실행! 🚀';

  @override
  String get goodPerformance => '💪 GOOD! 잘하고 있다! 💪';

  @override
  String get keepGoing => '🔥 KEEP GOING! 계속해! 🔥';

  @override
  String get skipRest => '휴식 건너뛰기';

  @override
  String get adaptiveTheme => '적응형 테마';

  @override
  String get adaptiveThemeDesc => '시스템 설정에 따라 자동으로 변경';

  @override
  String get colorTheme => '색상 테마';
}
