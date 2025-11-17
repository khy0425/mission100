import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// 챌린지 포기 버튼
  ///
  /// In ko, this message translates to:
  /// **'포기하기'**
  String get abandon;

  /// 앱 정보 제목
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get aboutApp;

  /// 정보 제목
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get aboutInfo;

  /// Achieved status
  ///
  /// In ko, this message translates to:
  /// **'달성'**
  String get achieved;

  /// 되돌릴 수 없는 작업 경고
  ///
  /// In ko, this message translates to:
  /// **'되돌릴 수 없다! 신중하게!'**
  String get actionCannotBeUndone;

  /// 권한 활성화 상태 라벨
  ///
  /// In ko, this message translates to:
  /// **'활성화됨'**
  String get activated;

  /// Permission activated status
  ///
  /// In ko, this message translates to:
  /// **'활성화됨'**
  String get activatedStatus;

  /// 광고가 없을 때 표시되는 대체 메시지
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿가 되는 여정, 함께 간다! 💪'**
  String get adFallbackMessage;

  /// 광고 라벨
  ///
  /// In ko, this message translates to:
  /// **'광고'**
  String get advertisement;

  /// 권한 허용 버튼
  ///
  /// In ko, this message translates to:
  /// **'권한 허용하기'**
  String get allowPermissions;

  /// 알파 엠퍼러 도메인 타이틀
  ///
  /// In ko, this message translates to:
  /// **'💀 ALPHA EMPEROR DOMAIN 💀'**
  String get alphaEmperorDomain;

  /// 고급 특징 1
  ///
  /// In ko, this message translates to:
  /// **'고급 변형 푸시업'**
  String get alphaFeature1;

  /// 고급 특징 2
  ///
  /// In ko, this message translates to:
  /// **'폭발적 파워 훈련'**
  String get alphaFeature2;

  /// 고급 특징 3
  ///
  /// In ko, this message translates to:
  /// **'플라이오메트릭 운동'**
  String get alphaFeature3;

  /// 고급 특징 4
  ///
  /// In ko, this message translates to:
  /// **'기가드림 스피릿 완성 코스'**
  String get alphaFeature4;

  /// 고급 짧은 이름
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿'**
  String get alphaShort;

  /// Animation effect setting
  ///
  /// In ko, this message translates to:
  /// **'애니메이션 효과'**
  String get animationEffect;

  /// 애니메이션 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'애니메이션'**
  String get animations;

  /// 애니메이션 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'앱의 애니메이션 효과를 활성화/비활성화한다'**
  String get animationsDesc;

  /// 애니메이션 비활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'애니메이션이 비활성화되었다'**
  String get animationsDisabled;

  /// 애니메이션 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'애니메이션이 활성화되었다'**
  String get animationsEnabled;

  /// Animation effects setting description
  ///
  /// In ko, this message translates to:
  /// **'앱 전체의 애니메이션 효과를 켜거나 끕니다'**
  String get animationsEnabledDesc;

  /// 앱 정보 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get appInfo;

  /// 앱 정보 설명
  ///
  /// In ko, this message translates to:
  /// **'버전 정보 및 개발자 정보'**
  String get appInfoDesc;

  /// 앱 평가 제목
  ///
  /// In ko, this message translates to:
  /// **'앱 평가'**
  String get appRating;

  /// 앱 평가 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'앱 평가 기능은 준비 중이다'**
  String get appRatingComingSoon;

  /// No description provided for @appSlogan.
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿가 되는 여정'**
  String get appSlogan;

  /// 앱 바 제목
  ///
  /// In ko, this message translates to:
  /// **'⚡ ALPHA EMPEROR DOMAIN ⚡'**
  String get appTitle;

  /// App version
  ///
  /// In ko, this message translates to:
  /// **'앱 버전'**
  String get appVersion;

  /// 외관 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'외관 설정'**
  String get appearance;

  /// Step 4 title - ascending motion
  ///
  /// In ko, this message translates to:
  /// **'상승 동작'**
  String get ascendingMotion;

  /// Step 4 description
  ///
  /// In ko, this message translates to:
  /// **'팔을 펴며 시작 자세로 돌아갑니다.'**
  String get ascendingMotionDesc;

  /// 평균 달성률
  ///
  /// In ko, this message translates to:
  /// **'평균 달성률'**
  String get averageCompletion;

  /// Average score label
  ///
  /// In ko, this message translates to:
  /// **'평균 점수'**
  String get averageScore;

  /// No description provided for @awesomeButton.
  ///
  /// In ko, this message translates to:
  /// **'멋져요!'**
  String get awesomeButton;

  /// 데이터 백업 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터를 백업하는 중...'**
  String get backingUpData;

  /// Benefits label
  ///
  /// In ko, this message translates to:
  /// **'운동 효과'**
  String get benefits;

  /// 효과 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'🚀 이렇게 LEGENDARY BEAST가 된다 🚀'**
  String get benefitsSection;

  /// No description provided for @brainjoltDegree.
  ///
  /// In ko, this message translates to:
  /// **'뇌절 도수'**
  String get brainjoltDegree;

  /// No description provided for @brainjoltWithDegree.
  ///
  /// In ko, this message translates to:
  /// **'🧠 뇌절 {degree}도'**
  String brainjoltWithDegree(Object degree);

  /// 호흡법 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'🌪️ ALPHA EMPEROR 호흡법 🌪️'**
  String get breathingSection;

  /// 빌드 정보
  ///
  /// In ko, this message translates to:
  /// **'빌드: {buildNumber}'**
  String buildInfo(String buildNumber);

  /// Built with Flutter
  ///
  /// In ko, this message translates to:
  /// **'Flutter로 제작됨'**
  String get builtWithFlutter;

  /// 달력 탭 제목
  ///
  /// In ko, this message translates to:
  /// **'달력'**
  String get calendar;

  /// 달력 화면 배너 텍스트
  ///
  /// In ko, this message translates to:
  /// **'꾸준함이 나만의 힘! 📅'**
  String get calendarBannerText;

  /// No description provided for @calendarIcon.
  ///
  /// In ko, this message translates to:
  /// **'📅'**
  String get calendarIcon;

  /// 회당 칼로리 소모량
  ///
  /// In ko, this message translates to:
  /// **'{calories}kcal/회'**
  String caloriesPerRep(int calories);

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// 취소 버튼 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancelButton;

  /// 퀴즈 데이터 로드 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'퀴즈 데이터를 불러올 수 없다'**
  String get cannotLoadQuizData;

  /// Cannot open GitHub error
  ///
  /// In ko, this message translates to:
  /// **'GitHub을 열 수 없다'**
  String get cannotOpenGithub;

  /// Error message when privacy policy cannot be opened
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침을 열 수 없다'**
  String get cannotOpenPrivacyPolicy;

  /// Error message when terms of service cannot be opened
  ///
  /// In ko, this message translates to:
  /// **'이용약관을 열 수 없다'**
  String get cannotOpenTermsOfService;

  /// No description provided for @checkIcon.
  ///
  /// In ko, this message translates to:
  /// **'✅'**
  String get checkIcon;

  /// 가슴 근육군
  ///
  /// In ko, this message translates to:
  /// **'가슴'**
  String get chest;

  /// No description provided for @closeButton.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get closeButton;

  /// 축소된 상태 안내
  ///
  /// In ko, this message translates to:
  /// **'축소됨. 탭하여 확장'**
  String get collapsedTapToExpand;

  /// 준비 중 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🚀 Coming Soon'**
  String get comingSoon;

  /// 일반 등급
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get common;

  /// Tab title for common mistakes
  ///
  /// In ko, this message translates to:
  /// **'일반적인\n실수'**
  String get commonMistakes;

  /// 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get complete;

  /// Completed status
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get completed;

  /// Completed count label
  ///
  /// In ko, this message translates to:
  /// **'완료한 횟수'**
  String get completedCount;

  /// 완료 레이블
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get completedLabel;

  /// 완료 메시지 1
  ///
  /// In ko, this message translates to:
  /// **'🔥 바로 그거다! ABSOLUTE DOMINATION, FXXK YEAH! 🔥'**
  String get completionMessage1;

  /// 완료 메시지 10
  ///
  /// In ko, this message translates to:
  /// **'👑 나만의 하루? 아니다! EMPEROR OF ALPHAS의 제국 건설 완료, 만삣삐! 👑'**
  String get completionMessage10;

  /// 완료 메시지 2
  ///
  /// In ko, this message translates to:
  /// **'⚡ 오늘 ALPHA STORM이 몰아쳤다, 만삣삐! 세상이 떨고 있어! ⚡'**
  String get completionMessage2;

  /// 완료 메시지 3
  ///
  /// In ko, this message translates to:
  /// **'👑 드림 스피릿에 가까워진 게 아니다... 이제 드림 스피릿를 넘어섰다! 👑'**
  String get completionMessage3;

  /// 완료 메시지 4
  ///
  /// In ko, this message translates to:
  /// **'🚀 드림 스피릿답다고? 틀렸다! 이제 LEGENDARY BEAST MODE다, YOU MONSTER! 🚀'**
  String get completionMessage4;

  /// 완료 메시지 5
  ///
  /// In ko, this message translates to:
  /// **'⚡ 드림 스피릿 에너지 레벨: ∞ 무한대 돌파! 우주가 경배한다! ⚡'**
  String get completionMessage5;

  /// 완료 메시지 6
  ///
  /// In ko, this message translates to:
  /// **'🦁 존경? 그딴 건 지났다! 이제 온 세상이 너에게 절한다, 만삣삐! 🦁'**
  String get completionMessage6;

  /// 완료 메시지 7
  ///
  /// In ko, this message translates to:
  /// **'🔱 드림 스피릿가 승인했다고? 아니다! GOD TIER가 탄생을 인정했다! 🔱'**
  String get completionMessage7;

  /// 완료 메시지 8
  ///
  /// In ko, this message translates to:
  /// **'🌪️ 드림 스피릿 게임 레벨업? 틀렸다! ALPHA DIMENSION을 정복했다, FXXK BEAST! 🌪️'**
  String get completionMessage8;

  /// 완료 메시지 9
  ///
  /// In ko, this message translates to:
  /// **'💥 순수한 드림 스피릿 퍼포먼스가 아니다... 이제 PURE LEGENDARY DOMINANCE! 💥'**
  String get completionMessage9;

  /// 달성률 퍼센트 형식
  ///
  /// In ko, this message translates to:
  /// **'{percentage}%'**
  String completionPercentage(int percentage);

  /// Completion rate label
  ///
  /// In ko, this message translates to:
  /// **'완료율'**
  String get completionRate;

  /// 확인 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// 축하 메시지
  ///
  /// In ko, this message translates to:
  /// **'축하합니다!'**
  String get congratulations;

  /// Congratulations message for permissions
  ///
  /// In ko, this message translates to:
  /// **'완벽! 모든 권한 설정 완료! 🎉'**
  String get congratulationsMessage;

  /// 영상 설명 6
  ///
  /// In ko, this message translates to:
  /// **'꾸준한 운동으로 근력 향상'**
  String get consistentStrengthImprovement;

  /// 운동 계속 또는 새 운동 시작 선택
  ///
  /// In ko, this message translates to:
  /// **'이전 훈련을 이어서 계속할래?\\n아니면 새 훈련을 시작할래?'**
  String get continueOrStartNew;

  /// 저작권 및 슬로건
  ///
  /// In ko, this message translates to:
  /// **'© 2024 Lucid Dream Team\n모든 권리 보유\n\n💪 자각몽 마스터가 되는 그 날까지!'**
  String get copyrightMission100;

  /// 코어 근육군
  ///
  /// In ko, this message translates to:
  /// **'코어'**
  String get core;

  /// Correct pose label
  ///
  /// In ko, this message translates to:
  /// **'올바른 자세'**
  String get correctPose;

  /// Correction method label
  ///
  /// In ko, this message translates to:
  /// **'교정 방법:'**
  String get correctionMethod;

  /// 개수 단위
  ///
  /// In ko, this message translates to:
  /// **'개'**
  String get count;

  /// Current status label
  ///
  /// In ko, this message translates to:
  /// **'현재'**
  String get current;

  /// 현재 난이도 표시
  ///
  /// In ko, this message translates to:
  /// **'현재: {difficulty} - {description}'**
  String currentDifficulty(String description, String difficulty);

  /// 앱 기능 커스터마이징 설명
  ///
  /// In ko, this message translates to:
  /// **'앱 기능을 사용자 정의하세요'**
  String get customizeAppFeatures;

  /// 리마인더 시간 표시
  ///
  /// In ko, this message translates to:
  /// **'매일 {time}에 알림'**
  String dailyReminderAt(String time);

  /// 일일 알림 설정 부제목
  ///
  /// In ko, this message translates to:
  /// **'매일 정해진 시간에 운동 알림'**
  String get dailyReminderSubtitle;

  /// 다크 모드 옵션
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get darkMode;

  /// 다크 모드 설명
  ///
  /// In ko, this message translates to:
  /// **'🌙 진짜 강자는 어둠 속에서도 강하다'**
  String get darkModeDesc;

  /// 다크 모드 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'다크 모드가 활성화되었습니다'**
  String get darkModeEnabled;

  /// 데이터 관리 제목
  ///
  /// In ko, this message translates to:
  /// **'데이터 관리'**
  String get dataManagement;

  /// 데이터 관리 설명
  ///
  /// In ko, this message translates to:
  /// **'운동 기록 백업 및 복원'**
  String get dataManagementDesc;

  /// 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// Step 2 title - descending motion
  ///
  /// In ko, this message translates to:
  /// **'하강 동작'**
  String get descendingMotion;

  /// Step 2 description
  ///
  /// In ko, this message translates to:
  /// **'팔꿈치를 구부리며 천천히 몸을 아래로 내립니다.'**
  String get descendingMotionDesc;

  /// 설명 라벨
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get description;

  /// No description provided for @descriptionTitle.
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get descriptionTitle;

  /// 개발자 제목
  ///
  /// In ko, this message translates to:
  /// **'개발자'**
  String get developer;

  /// Developer contact information
  ///
  /// In ko, this message translates to:
  /// **'개발자 연락처'**
  String get developerContact;

  /// 개발자 정보
  ///
  /// In ko, this message translates to:
  /// **'개발자 정보'**
  String get developerInfo;

  /// 개발자 정보 설명
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿가 되는 여정을 함께해'**
  String get developerInfoDesc;

  /// 난이도 변경 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'난이도 변경! -> {difficulty} 💪'**
  String difficultyChanged(String difficulty);

  /// 쉬움 난이도
  ///
  /// In ko, this message translates to:
  /// **'쉬움'**
  String get difficultyEasy;

  /// 전문가 난이도
  ///
  /// In ko, this message translates to:
  /// **'전문가'**
  String get difficultyExpert;

  /// 푸시업 극한 난이도
  ///
  /// In ko, this message translates to:
  /// **'기가 드림 스피릿 - 전설의 영역'**
  String get difficultyExtreme;

  /// 어려움 난이도
  ///
  /// In ko, this message translates to:
  /// **'어려움'**
  String get difficultyHard;

  /// 보통 난이도
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get difficultyMedium;

  /// 비활성화 상태
  ///
  /// In ko, this message translates to:
  /// **'비활성화'**
  String get disabled;

  /// Common mistakes section header
  ///
  /// In ko, this message translates to:
  /// **'이런 실수는 하지 마라!'**
  String get dontMakeTheseMistakes;

  /// Lucid Dream 앱 다운로드 메시지
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 앱 다운로드해라! 당신의 꿈을 응원합니다!'**
  String get downloadMission100;

  /// 소요일 레이블
  ///
  /// In ko, this message translates to:
  /// **'소요일'**
  String get durationLabel;

  /// No description provided for @earnedXp.
  ///
  /// In ko, this message translates to:
  /// **'획득 XP'**
  String get earnedXp;

  /// Quiz question 5
  ///
  /// In ko, this message translates to:
  /// **'푸시업에서 팔꿈치의 올바른 각도는?'**
  String get elbowAngleQuiz;

  /// 활성화 상태
  ///
  /// In ko, this message translates to:
  /// **'활성화'**
  String get enabled;

  /// 격려 메시지 1
  ///
  /// In ko, this message translates to:
  /// **'🔥 ALPHA도 시련이 있다, 만삣삐! 하지만 그게 너를 더 강하게 만든다! 🔥'**
  String get encouragementMessage1;

  /// 격려 메시지 10
  ///
  /// In ko, this message translates to:
  /// **'👑 ALPHA 회복력이 아니다... 이제 IMMORTAL PHOENIX POWER다, FXXK YEAH! 👑'**
  String get encouragementMessage10;

  /// 격려 메시지 2
  ///
  /// In ko, this message translates to:
  /// **'⚡ 내일은 LEGENDARY COMEBACK의 날이다! 세상이 너의 부활을 보게 될 것이다! ⚡'**
  String get encouragementMessage2;

  /// 격려 메시지 3
  ///
  /// In ko, this message translates to:
  /// **'👑 진짜 EMPEROR는 절대 굴복하지 않는다, FXXK THE LIMITS! 👑'**
  String get encouragementMessage3;

  /// 격려 메시지 4
  ///
  /// In ko, this message translates to:
  /// **'🚀 이건 그냥 ULTIMATE BOSS FIGHT 모드야! 너는 이미 승리했다! 🚀'**
  String get encouragementMessage4;

  /// 격려 메시지 5
  ///
  /// In ko, this message translates to:
  /// **'🦁 진짜 APEX PREDATOR는 더 강해져서 돌아온다, 만삣삐! 🦁'**
  String get encouragementMessage5;

  /// 격려 메시지 6
  ///
  /// In ko, this message translates to:
  /// **'🔱 ALPHA 정신은 불멸이다! 우주가 끝나도 너는 살아남는다! 🔱'**
  String get encouragementMessage6;

  /// 격려 메시지 7
  ///
  /// In ko, this message translates to:
  /// **'⚡ 아직 LEGEND TRANSFORMATION 진행 중이다, YOU ABSOLUTE UNIT! ⚡'**
  String get encouragementMessage7;

  /// 격려 메시지 8
  ///
  /// In ko, this message translates to:
  /// **'🌪️ EPIC COMEBACK STORM이 몰려온다! 세상이 너의 복귀를 떨며 기다린다! 🌪️'**
  String get encouragementMessage8;

  /// 격려 메시지 9
  ///
  /// In ko, this message translates to:
  /// **'💥 모든 EMPEROR는 시련을 통과한다, 만삣삐! 이게 바로 왕의 길이다! 💥'**
  String get encouragementMessage9;

  /// 암호화 레이블
  ///
  /// In ko, this message translates to:
  /// **'암호화'**
  String get encryption;

  /// 영어 언어 옵션
  ///
  /// In ko, this message translates to:
  /// **'영어'**
  String get english;

  /// No description provided for @englishFlag.
  ///
  /// In ko, this message translates to:
  /// **'🇺🇸'**
  String get englishFlag;

  /// 에픽 등급
  ///
  /// In ko, this message translates to:
  /// **'에픽'**
  String get epic;

  /// No description provided for @evolutionCompleted.
  ///
  /// In ko, this message translates to:
  /// **'🎉 진화 완료! 🎉'**
  String get evolutionCompleted;

  /// Exact alarm permission label
  ///
  /// In ko, this message translates to:
  /// **'정확한 알람 권한'**
  String get exactAlarmPermission;

  /// 목표 횟수 초과 빠른 입력 버튼
  ///
  /// In ko, this message translates to:
  /// **'초과'**
  String get exceed;

  /// Excellent performance label
  ///
  /// In ko, this message translates to:
  /// **'좋음'**
  String get excellent;

  /// 종료 버튼 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'💀 도망가기 💀'**
  String get exitButton;

  /// 계속하기 버튼
  ///
  /// In ko, this message translates to:
  /// **'계속 싸운다, 만삣삐!'**
  String get exitDialogContinue;

  /// 종료 다이얼로그 내용
  ///
  /// In ko, this message translates to:
  /// **'전사는 절대 전투 중에 포기하지 않아!\n너의 정복이 사라질 거야, you idiot!'**
  String get exitDialogMessage;

  /// 종료하기 버튼
  ///
  /// In ko, this message translates to:
  /// **'후퇴한다...'**
  String get exitDialogRetreat;

  /// 종료 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'전투에서 후퇴하겠어, 만삣삐?'**
  String get exitDialogTitle;

  /// 확장된 상태
  ///
  /// In ko, this message translates to:
  /// **'확장됨'**
  String get expanded;

  /// 심혈관 건강 카테고리
  ///
  /// In ko, this message translates to:
  /// **'심혈관 건강'**
  String get factCategoryCardio;

  /// 호르몬 시스템 카테고리
  ///
  /// In ko, this message translates to:
  /// **'호르몬 시스템'**
  String get factCategoryHormone;

  /// 정신건강 카테고리
  ///
  /// In ko, this message translates to:
  /// **'정신건강'**
  String get factCategoryMental;

  /// 대사 시스템 카테고리
  ///
  /// In ko, this message translates to:
  /// **'대사 시스템'**
  String get factCategoryMetabolic;

  /// 신경계 개선 카테고리
  ///
  /// In ko, this message translates to:
  /// **'신경계 개선'**
  String get factCategoryNervous;

  /// 피드백 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'피드백 기능이 곧 추가된다!'**
  String get feedbackComingSoon;

  /// 파일명 플레이스홀더
  ///
  /// In ko, this message translates to:
  /// **'백업_파일명'**
  String get fileNamePlaceholder;

  /// First step achievement
  ///
  /// In ko, this message translates to:
  /// **'첫 걸음'**
  String get firstStep;

  /// First step achievement description
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 워크아웃 완료'**
  String get firstStepDesc;

  /// 삭제될 데이터 목록 안내
  ///
  /// In ko, this message translates to:
  /// **'다음 데이터가 모두 삭제된다:'**
  String get followingDataDeleted;

  /// Font scale setting title
  ///
  /// In ko, this message translates to:
  /// **'글자 크기'**
  String get fontScale;

  /// Font scale setting description
  ///
  /// In ko, this message translates to:
  /// **'앱 전체의 텍스트 크기를 조정한다'**
  String get fontScaleDesc;

  /// 글자 크기 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'글자 크기'**
  String get fontSize;

  /// 글자 크기 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'앱의 글자 크기를 조정한다'**
  String get fontSizeDesc;

  /// 전신 근육군
  ///
  /// In ko, this message translates to:
  /// **'전신'**
  String get fullBody;

  /// 최고급 짧은 이름
  ///
  /// In ko, this message translates to:
  /// **'기가드림 스피릿'**
  String get gigaShort;

  /// GitHub repository link
  ///
  /// In ko, this message translates to:
  /// **'GitHub 저장소'**
  String get githubRepository;

  /// Good status
  ///
  /// In ko, this message translates to:
  /// **'좋음'**
  String get good;

  /// 세트 진행 중 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'네 몸은 네가 명령하는 대로 따를 뿐이야, you idiot! 🔱'**
  String get guidanceMessage;

  /// 목표 횟수의 절반 빠른 입력 버튼
  ///
  /// In ko, this message translates to:
  /// **'절반'**
  String get half;

  /// 고대비 모드 비활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'고대비 모드가 비활성화되었습니다'**
  String get highContrastDisabled;

  /// 고대비 모드 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'고대비 모드가 활성화되었습니다'**
  String get highContrastEnabled;

  /// High contrast mode setting
  ///
  /// In ko, this message translates to:
  /// **'고대비 모드'**
  String get highContrastMode;

  /// High contrast mode setting description
  ///
  /// In ko, this message translates to:
  /// **'시각적 접근성을 위한 고대비 모드를 활성화한다'**
  String get highContrastModeDesc;

  /// 홈 탭
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get home;

  /// 홈 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'💥 ALPHA EMPEROR COMMAND CENTER 💥'**
  String get homeTitle;

  /// Improvement needed label
  ///
  /// In ko, this message translates to:
  /// **'개선 필요'**
  String get improvement;

  /// Improvement needed status
  ///
  /// In ko, this message translates to:
  /// **'개선 필요'**
  String get improvementNeeded;

  /// Instructions label
  ///
  /// In ko, this message translates to:
  /// **'운동 방법'**
  String get instructions;

  /// 실행 방법 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'⚡ EMPEROR EXECUTION 방법 ⚡'**
  String get instructionsSection;

  /// Rest prevention message
  ///
  /// In ko, this message translates to:
  /// **'오늘은 회복의 날이다. 하지만 선택은 너의 것.'**
  String get justWait;

  /// Keep going motivation message
  ///
  /// In ko, this message translates to:
  /// **'🔥 KEEP GOING! 계속해! 🔥'**
  String get keepGoing;

  /// 한국어 표시
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @koreanFlag.
  ///
  /// In ko, this message translates to:
  /// **'🇰🇷'**
  String get koreanFlag;

  /// No description provided for @launchPromoActive.
  ///
  /// In ko, this message translates to:
  /// **'런칭 프로모션 (30일 무료)'**
  String get launchPromoActive;

  /// 범례 제목
  ///
  /// In ko, this message translates to:
  /// **'범례'**
  String get legend;

  /// 라이선스 제목
  ///
  /// In ko, this message translates to:
  /// **'라이선스'**
  String get license;

  /// License information title
  ///
  /// In ko, this message translates to:
  /// **'라이선스 정보'**
  String get licenseInfo;

  /// 라이선스 정보 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'라이선스 정보는 준비 중이다'**
  String get licenseInfoComingSoon;

  /// License information description
  ///
  /// In ko, this message translates to:
  /// **'앱에서 사용된 라이선스 정보..'**
  String get licenseInfoDesc;

  /// 라이트 모드 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'라이트 모드가 활성화되었습니다'**
  String get lightModeEnabled;

  /// 좋아요 버튼 라벨
  ///
  /// In ko, this message translates to:
  /// **'좋아요'**
  String get like;

  /// 좋아요 액션 메시지
  ///
  /// In ko, this message translates to:
  /// **'좋아요! 💪'**
  String get likeMessage;

  /// Button label for list view mode
  ///
  /// In ko, this message translates to:
  /// **'목록 보기'**
  String get listView;

  /// 로딩 중 표시 텍스트
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get loadingText;

  /// No description provided for @logoutButton.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logoutButton;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'정말로 로그아웃하시겠습니까? 저장되지 않은 데이터는 손실될 수 있습니다.'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutSuccessMessage.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 되었습니다'**
  String get logoutSuccessMessage;

  /// No description provided for @logoutTitle.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logoutTitle;

  /// 사랑으로 제작 메시지
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿를 위해 ❤️로 제작'**
  String get madeWithLove;

  /// 분 단위
  ///
  /// In ko, this message translates to:
  /// **'분'**
  String get minutes;

  /// 개발팀 이름
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream Team'**
  String get mission100Team;

  /// 미션 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎉👑💀 MISSION COMPLETE! ALPHA EMPEROR 등극! 💀👑🎉'**
  String get missionComplete;

  /// 일반적인 실수 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'❌ 약자들의 PATHETIC 실수들 ❌'**
  String get mistakesSection;

  /// 날짜 표시용 월 단위
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get month;

  /// 월간 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'월간'**
  String get monthly;

  /// Monthly goal label
  ///
  /// In ko, this message translates to:
  /// **'월간 목표'**
  String get monthlyGoal;

  /// No description provided for @nameLabel.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get nameLabel;

  /// 다음 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get next;

  /// No description provided for @nextButton.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get nextButton;

  /// No data message
  ///
  /// In ko, this message translates to:
  /// **'데이터가 없다'**
  String get noData;

  /// No data available message
  ///
  /// In ko, this message translates to:
  /// **'데이터가 없다'**
  String get noDataAvailable;

  /// OK button text
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get ok;

  /// 확인 버튼 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'🔥 OK, 만삣삐! 🔥'**
  String get okButton;

  /// 보통 운동 완료
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get okay;

  /// Open GitHub repository
  ///
  /// In ko, this message translates to:
  /// **'GitHub에서 소스코드 보기'**
  String get openGithub;

  /// Open in browser button text
  ///
  /// In ko, this message translates to:
  /// **'브라우저에서 열기'**
  String get openInBrowser;

  /// 라이선스 설명
  ///
  /// In ko, this message translates to:
  /// **'오픈소스 라이선스'**
  String get openSourceLicense;

  /// 오픈소스 라이선스
  ///
  /// In ko, this message translates to:
  /// **'오픈소스 라이선스'**
  String get openSourceLicenses;

  /// 오픈소스 라이선스 설명
  ///
  /// In ko, this message translates to:
  /// **'오픈소스 라이선스 보기'**
  String get openSourceLicensesDesc;

  /// Percent complete label
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get percentComplete;

  /// Perfect completion label
  ///
  /// In ko, this message translates to:
  /// **'완벽!'**
  String get perfect;

  /// 밸런스 드림 스피릿 모드 설명
  ///
  /// In ko, this message translates to:
  /// **'완벽한 균형! 주중+주말 최적화 패턴! ⚖️🔥'**
  String get perfectBalanceOptimized;

  /// 평균 달성률 부제목
  ///
  /// In ko, this message translates to:
  /// **'완벽한 수행!'**
  String get perfectExecution;

  /// Perfectionist achievement description
  ///
  /// In ko, this message translates to:
  /// **'한 주 100% 완료'**
  String get perfectionistDesc;

  /// 이미 권한 요청한 경우 메시지
  ///
  /// In ko, this message translates to:
  /// **'이미 권한을 요청했다.\n설정에서 수동으로 허용해주세요.'**
  String get permissionAlreadyRequested;

  /// 권한 혜택 제목
  ///
  /// In ko, this message translates to:
  /// **'이 권한들을 허용하면:'**
  String get permissionBenefits;

  /// No description provided for @permissionBenefitsPrompt.
  ///
  /// In ko, this message translates to:
  /// **'허용하면 다음 기능을 이용할 수 있습니다:'**
  String get permissionBenefitsPrompt;

  /// No description provided for @permissionAllowButton.
  ///
  /// In ko, this message translates to:
  /// **'허용'**
  String get permissionAllowButton;

  /// 알림 권한 제목
  ///
  /// In ko, this message translates to:
  /// **'🔔 알림 권한'**
  String get notificationPermissionTitle;

  /// 알림 권한 설명
  ///
  /// In ko, this message translates to:
  /// **'연습 리마인더와 업적 알림을 받기 위해 필요한다'**
  String get notificationPermissionDesc;

  /// 알림 혜택 1
  ///
  /// In ko, this message translates to:
  /// **'💪 매일 연습 리마인더'**
  String get notificationBenefit1;

  /// 알림 혜택 2
  ///
  /// In ko, this message translates to:
  /// **'🏆 업적 달성 축하 알림'**
  String get notificationBenefit2;

  /// 알림 혜택 3
  ///
  /// In ko, this message translates to:
  /// **'🔥 동기부여 메시지'**
  String get notificationBenefit3;

  /// No description provided for @notificationBenefit4.
  ///
  /// In ko, this message translates to:
  /// **'✨ 새로운 도전과제 알림'**
  String get notificationBenefit4;

  /// No description provided for @backupPermissionTitle.
  ///
  /// In ko, this message translates to:
  /// **'💾 백업 기능'**
  String get backupPermissionTitle;

  /// No description provided for @backupPermissionDesc.
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 데이터를 안전하게 백업하기 위해 저장소 접근이 필요합니다.'**
  String get backupPermissionDesc;

  /// No description provided for @backupBenefit1.
  ///
  /// In ko, this message translates to:
  /// **'📁 꿈 일기 자동 백업'**
  String get backupBenefit1;

  /// No description provided for @backupBenefit2.
  ///
  /// In ko, this message translates to:
  /// **'🔄 기기 변경 시 데이터 복원'**
  String get backupBenefit2;

  /// No description provided for @backupBenefit3.
  ///
  /// In ko, this message translates to:
  /// **'💾 데이터 손실 방지'**
  String get backupBenefit3;

  /// No description provided for @backupBenefit4.
  ///
  /// In ko, this message translates to:
  /// **'☁️ 안전한 데이터 보관'**
  String get backupBenefit4;

  /// 저장소 권한 요청 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장소 권한이 필요한다. 설정에서 허용해주세요.'**
  String get permissionStorageMessage;

  /// 권한 요청 설명
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream에서 최상의 경험을 위해\n다음 권한들이 필요한다:'**
  String get permissionsDescription;

  /// 프로필 생성 요청 메시지
  ///
  /// In ko, this message translates to:
  /// **'프로필을 생성해주세요'**
  String get pleaseCreateProfile;

  /// 부족한 운동 완료
  ///
  /// In ko, this message translates to:
  /// **'부족'**
  String get poor;

  /// 주의사항 제목
  ///
  /// In ko, this message translates to:
  /// **'주의사항'**
  String get precautions;

  /// No description provided for @previous.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get previous;

  /// 이전 버튼
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get previousButton;

  /// Privacy policy title
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicy;

  /// Privacy policy description
  ///
  /// In ko, this message translates to:
  /// **'개인정보 보호 및 처리 방침을 확인'**
  String get privacyPolicyDesc;

  /// 프로필 생성 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'🚀 EMPEROR PROFILE CREATION COMPLETE! ({sessions}개 DOMINATION SESSION 준비됨, 만삣삐!) 🚀'**
  String profileCreated(int sessions);

  /// 목표 초과 버튼
  ///
  /// In ko, this message translates to:
  /// **'💥 LIMIT DESTROYER 💥'**
  String get quickInputBeast;

  /// 목표 60% 버튼
  ///
  /// In ko, this message translates to:
  /// **'⚡ ALPHA 발걸음 ⚡'**
  String get quickInputMedium;

  /// 목표 달성 버튼
  ///
  /// In ko, this message translates to:
  /// **'🚀 GODLIKE 달성 🚀'**
  String get quickInputPerfect;

  /// 목표 50% 버튼
  ///
  /// In ko, this message translates to:
  /// **'🔥 LEGENDARY 함성 🔥'**
  String get quickInputStart;

  /// Quiz button text
  ///
  /// In ko, this message translates to:
  /// **'퀴즈'**
  String get quiz;

  /// 레어 등급
  ///
  /// In ko, this message translates to:
  /// **'레어'**
  String get rare;

  /// Common rarity level
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get rarityCommon;

  /// Epic rarity level
  ///
  /// In ko, this message translates to:
  /// **'에픽'**
  String get rarityEpic;

  /// Rare rarity level
  ///
  /// In ko, this message translates to:
  /// **'레어'**
  String get rarityRare;

  /// 앱 평가 설명
  ///
  /// In ko, this message translates to:
  /// **'Play Store에서 평가하기'**
  String get rateOnPlayStore;

  /// Recommended permission label
  ///
  /// In ko, this message translates to:
  /// **'권장'**
  String get recommendedLabel;

  /// Refresh button
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get refresh;

  /// 새로고침 버튼
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get refreshButton;

  /// Remaining progress label
  ///
  /// In ko, this message translates to:
  /// **'남음'**
  String get remaining;

  /// Remaining count label
  ///
  /// In ko, this message translates to:
  /// **'남은 횟수'**
  String get remainingCount;

  /// 남은 목표 통계 제목
  ///
  /// In ko, this message translates to:
  /// **'남은 목표'**
  String get remainingGoal;

  /// 목표 달성까지 남은 개수
  ///
  /// In ko, this message translates to:
  /// **'목표까지 {remaining}개 남음'**
  String remainingToTarget(int remaining);

  /// 리마인더 시간 설정
  ///
  /// In ko, this message translates to:
  /// **'⏰ 리마인더 시간'**
  String get reminderTime;

  /// 리마인더 시간 변경 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'리마인더 시간이 {time}로 변경되었다'**
  String reminderTimeChanged(String time);

  /// 리마인더 시간 설명
  ///
  /// In ko, this message translates to:
  /// **'⚡ 너의 운명이 결정되는 시간을 정해라!'**
  String get reminderTimeDesc;

  /// No description provided for @renewButton.
  ///
  /// In ko, this message translates to:
  /// **'갱신'**
  String get renewButton;

  /// 운동 횟수 입력 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'기록해라, 만삣삐. 약자는 숫자를 센다, 강자는 전설을 만든다 💪'**
  String get repLogMessage;

  /// 재개 버튼
  ///
  /// In ko, this message translates to:
  /// **'재개'**
  String get resumeButton;

  /// 다시 시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// 다시 시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retryButton;

  /// 중급 특징 1
  ///
  /// In ko, this message translates to:
  /// **'표준 푸시업 마스터'**
  String get risingFeature1;

  /// 중급 특징 2
  ///
  /// In ko, this message translates to:
  /// **'다양한 변형 훈련'**
  String get risingFeature2;

  /// 중급 특징 3
  ///
  /// In ko, this message translates to:
  /// **'근지구력 향상'**
  String get risingFeature3;

  /// 중급 특징 4
  ///
  /// In ko, this message translates to:
  /// **'체계적 진급 프로그램'**
  String get risingFeature4;

  /// 중급 짧은 이름
  ///
  /// In ko, this message translates to:
  /// **'알파 지망생'**
  String get risingShort;

  /// 초급 특징 1
  ///
  /// In ko, this message translates to:
  /// **'무릎 푸시업부터 시작'**
  String get rookieFeature1;

  /// 초급 특징 2
  ///
  /// In ko, this message translates to:
  /// **'폼 교정 중심 훈련'**
  String get rookieFeature2;

  /// 초급 특징 3
  ///
  /// In ko, this message translates to:
  /// **'점진적 강도 증가'**
  String get rookieFeature3;

  /// 초급 특징 4
  ///
  /// In ko, this message translates to:
  /// **'기초 체력 향상'**
  String get rookieFeature4;

  /// 초급 짧은 이름
  ///
  /// In ko, this message translates to:
  /// **'푸시'**
  String get rookieShort;

  /// 저장 버튼 라벨
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// 저장 액션 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장됨 📌'**
  String get saveMessage;

  /// No description provided for @scheduleDaily.
  ///
  /// In ko, this message translates to:
  /// **'매일'**
  String get scheduleDaily;

  /// No description provided for @scheduleNone.
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get scheduleNone;

  /// 스케줄러가 중지된 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'스케줄러 중지됨'**
  String get schedulerStoppedStatus;

  /// 과학적 팩트 10번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 훈련으로 인지 유연성이 42% 증가하여 다양한 관점에서 사고할 수 있게 됩니다.'**
  String get scientificFact10Content;

  /// 과학적 팩트 10번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌈 사고의 유연성이 폭발적으로 증가합니다!'**
  String get scientificFact10Impact;

  /// 과학적 팩트 10번 - 심박출량 증가 제목
  ///
  /// In ko, this message translates to:
  /// **'인지 유연성 향상'**
  String get scientificFact10Title;

  /// 과학적 팩트 11번 내용
  ///
  /// In ko, this message translates to:
  /// **'REM 수면의 질이 30% 향상되어 더 깊고 효율적인 자각몽 훈련이 가능해집니다.'**
  String get scientificFact11Content;

  /// 과학적 팩트 11번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌙 최상의 꿈 상태를 경험하고 있습니다!'**
  String get scientificFact11Impact;

  /// 과학적 팩트 11번 - 혈관신생 촉진 제목
  ///
  /// In ko, this message translates to:
  /// **'REM 수면 질 향상'**
  String get scientificFact11Title;

  /// 과학적 팩트 12번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 훈련으로 수면 주기가 최적화되어 90분 주기가 규칙적으로 유지됩니다.'**
  String get scientificFact12Content;

  /// 과학적 팩트 12번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'⏰ 완벽한 수면 리듬을 획득했습니다!'**
  String get scientificFact12Impact;

  /// 과학적 팩트 12번 - 혈압 정상화 제목
  ///
  /// In ko, this message translates to:
  /// **'수면 주기 최적화'**
  String get scientificFact12Title;

  /// 과학적 팩트 13번 내용
  ///
  /// In ko, this message translates to:
  /// **'깊은 수면 단계(N3)가 20% 증가하여 신체 회복과 성장 호르몬 분비가 촉진됩니다.'**
  String get scientificFact13Content;

  /// 과학적 팩트 13번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'💤 최고의 회복 수면을 취하고 있습니다!'**
  String get scientificFact13Impact;

  /// 과학적 팩트 13번 - 심박변이도 향상 제목
  ///
  /// In ko, this message translates to:
  /// **'깊은 수면 증가'**
  String get scientificFact13Title;

  /// 과학적 팩트 14번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 훈련이 체내 시계를 조절하여 일주기 리듬이 15% 개선됩니다.'**
  String get scientificFact14Content;

  /// 과학적 팩트 14번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌍 자연스러운 생체 리듬을 되찾았습니다!'**
  String get scientificFact14Impact;

  /// 과학적 팩트 14번 - 내피세포 기능 개선 제목
  ///
  /// In ko, this message translates to:
  /// **'일주기 리듬 정렬'**
  String get scientificFact14Title;

  /// 과학적 팩트 15번 내용
  ///
  /// In ko, this message translates to:
  /// **'수면 효율성이 25% 증가하여 같은 시간에 더 많은 휴식을 취할 수 있습니다.'**
  String get scientificFact15Content;

  /// 과학적 팩트 15번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 수면의 질이 비약적으로 향상되고 있습니다!'**
  String get scientificFact15Impact;

  /// 과학적 팩트 15번 - 기초대사율 증가 제목
  ///
  /// In ko, this message translates to:
  /// **'수면 효율성 증가'**
  String get scientificFact15Title;

  /// 과학적 팩트 16번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 중 빠른 안구 운동(REM)이 분당 60-70회로 증가하여 생생한 시각적 경험을 만듭니다.'**
  String get scientificFact16Content;

  /// 과학적 팩트 16번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'👁️ 꿈의 세계가 초고화질로 펼쳐집니다!'**
  String get scientificFact16Impact;

  /// 과학적 팩트 16번 - 인슐린 감수성 향상 제목
  ///
  /// In ko, this message translates to:
  /// **'안구 운동 패턴'**
  String get scientificFact16Title;

  /// 과학적 팩트 17번 내용
  ///
  /// In ko, this message translates to:
  /// **'REM 수면 중 뇌 활동이 깨어있을 때와 유사한 수준으로 증가하여 의식적 사고가 가능합니다.'**
  String get scientificFact17Content;

  /// 과학적 팩트 17번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🧠 잠자는 동안 뇌가 깨어있습니다!'**
  String get scientificFact17Impact;

  /// 과학적 팩트 17번 - 지방 산화 증진 제목
  ///
  /// In ko, this message translates to:
  /// **'REM 뇌 활성화'**
  String get scientificFact17Title;

  /// 과학적 팩트 18번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 훈련이 세로토닌과 도파민 균형을 맞춰 기분과 동기를 개선합니다.'**
  String get scientificFact18Content;

  /// 과학적 팩트 18번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'😊 행복 호르몬이 최적화되고 있습니다!'**
  String get scientificFact18Impact;

  /// 과학적 팩트 18번 - 갈색지방 활성화 제목
  ///
  /// In ko, this message translates to:
  /// **'신경전달물질 조절'**
  String get scientificFact18Title;

  /// 과학적 팩트 19번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 중 아세틸콜린 수치가 30% 증가하여 명료한 의식과 생생한 기억을 만듭니다.'**
  String get scientificFact19Content;

  /// 과학적 팩트 19번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'💡 꿈이 현실처럼 선명해지고 있습니다!'**
  String get scientificFact19Impact;

  /// 과학적 팩트 19번 - 운동 후 산소 소비량 제목
  ///
  /// In ko, this message translates to:
  /// **'아세틸콜린 증가'**
  String get scientificFact19Title;

  /// 과학적 팩트 1 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 중 전두엽 피질의 활동이 일반 꿈 대비 40% 증가하여 자기 인식과 메타인지를 가능하게 합니다.'**
  String get scientificFact1Content;

  /// 과학적 팩트 1 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🧠 의식의 확장이 일어나고 있습니다!'**
  String get scientificFact1Impact;

  /// 과학적 팩트 1 제목
  ///
  /// In ko, this message translates to:
  /// **'전두엽 활성화'**
  String get scientificFact1Title;

  /// 과학적 팩트 20번 내용
  ///
  /// In ko, this message translates to:
  /// **'규칙적인 자각몽 훈련이 멜라토닌과 세로토닌 균형을 맞춰 수면-각성 주기를 최적화합니다.'**
  String get scientificFact20Content;

  /// 과학적 팩트 20번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌗 완벽한 수면 호르몬 균형을 달성했습니다!'**
  String get scientificFact20Impact;

  /// 과학적 팩트 20번 - 성장호르몬 급증 제목
  ///
  /// In ko, this message translates to:
  /// **'세로토닌 균형'**
  String get scientificFact20Title;

  /// 과학적 팩트 21번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 훈련으로 불안 증상이 55% 감소하여 정서적 안정감을 얻을 수 있습니다.'**
  String get scientificFact21Content;

  /// 과학적 팩트 21번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'☮️ 마음의 평화를 찾고 있습니다!'**
  String get scientificFact21Impact;

  /// 과학적 팩트 21번 - 운동 단위 동조화 제목
  ///
  /// In ko, this message translates to:
  /// **'불안 감소'**
  String get scientificFact21Title;

  /// 과학적 팩트 22번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽에서 스트레스를 처리하고 관리하는 능력이 40% 향상됩니다.'**
  String get scientificFact22Content;

  /// 과학적 팩트 22번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🛡️ 스트레스에 대한 저항력이 생기고 있습니다!'**
  String get scientificFact22Impact;

  /// 과학적 팩트 22번 - 신경가소성 증진 제목
  ///
  /// In ko, this message translates to:
  /// **'스트레스 관리 능력'**
  String get scientificFact22Title;

  /// 과학적 팩트 23번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽을 통해 감정을 처리하고 정리하는 능력이 60% 향상되어 심리적 치유가 일어납니다.'**
  String get scientificFact23Content;

  /// 과학적 팩트 23번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'💖 감정의 치유가 일어나고 있습니다!'**
  String get scientificFact23Impact;

  /// 과학적 팩트 23번 - BDNF 분비 증가 제목
  ///
  /// In ko, this message translates to:
  /// **'감정 처리 능력'**
  String get scientificFact23Title;

  /// 과학적 팩트 24번 내용
  ///
  /// In ko, this message translates to:
  /// **'PTSD 환자의 70%가 자각몽 훈련으로 악몽 빈도 감소와 증상 완화를 경험합니다.'**
  String get scientificFact24Content;

  /// 과학적 팩트 24번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌈 트라우마로부터 회복하고 있습니다!'**
  String get scientificFact24Impact;

  /// 과학적 팩트 24번 - 반응 속도 개선 제목
  ///
  /// In ko, this message translates to:
  /// **'PTSD 증상 완화'**
  String get scientificFact24Title;

  /// 과학적 팩트 25번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 훈련이 우울증 증상을 32% 감소시켜 전반적인 기분과 삶의 질을 향상시킵니다.'**
  String get scientificFact25Content;

  /// 과학적 팩트 25번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'✨ 희망과 긍정의 에너지가 충전되고 있습니다!'**
  String get scientificFact25Impact;

  /// 과학적 팩트 25번 - 인터뉴런 활성화 제목
  ///
  /// In ko, this message translates to:
  /// **'우울증 개선'**
  String get scientificFact25Title;

  /// 과학적 팩트 2 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 상태에서 40Hz 감마파가 75% 증가하여 높은 수준의 의식 상태를 나타냅니다.'**
  String get scientificFact2Content;

  /// 과학적 팩트 2 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 초월적 의식 상태에 진입하고 있습니다!'**
  String get scientificFact2Impact;

  /// 과학적 팩트 2 제목
  ///
  /// In ko, this message translates to:
  /// **'감마파 패턴 증가'**
  String get scientificFact2Title;

  /// 과학적 팩트 3번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 훈련 8주 후 전전두엽 피질의 회백질 밀도가 5% 증가합니다.'**
  String get scientificFact3Content;

  /// 과학적 팩트 3번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🧠 두뇌가 물리적으로 강화되고 있습니다!'**
  String get scientificFact3Impact;

  /// 과학적 팩트 3번 - mTOR 신호전달 활성화 제목
  ///
  /// In ko, this message translates to:
  /// **'전전두엽 피질 증가'**
  String get scientificFact3Title;

  /// 과학적 팩트 4번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습을 통해 메타 인지 능력이 34% 향상되어 깨어있을 때도 자기 인식이 증가합니다.'**
  String get scientificFact4Content;

  /// 과학적 팩트 4번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎯 현실에서도 자각력이 강화되고 있습니다!'**
  String get scientificFact4Impact;

  /// 과학적 팩트 4번 - 근육 기억의 영속성 제목
  ///
  /// In ko, this message translates to:
  /// **'메타인지 능력 향상'**
  String get scientificFact4Title;

  /// 과학적 팩트 5번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 중 알파파(8-13Hz)와 베타파(13-30Hz)가 동시에 활성화되는 독특한 의식 상태가 나타납니다.'**
  String get scientificFact5Content;

  /// 과학적 팩트 5번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'✨ 깨어있는 꿈의 상태를 경험하고 있습니다!'**
  String get scientificFact5Impact;

  /// 과학적 팩트 5번 - 운동 단위 동조화 제목
  ///
  /// In ko, this message translates to:
  /// **'혼합 뇌파 상태'**
  String get scientificFact5Title;

  /// 과학적 팩트 6번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 훈련으로 꿈 회상 능력이 300% 향상되어 더 많은 꿈을 기억할 수 있게 됩니다.'**
  String get scientificFact6Content;

  /// 과학적 팩트 6번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'💭 꿈의 세계가 선명하게 열리고 있습니다!'**
  String get scientificFact6Impact;

  /// 과학적 팩트 6번 - 신경가소성 증진 제목
  ///
  /// In ko, this message translates to:
  /// **'꿈 회상력 증가'**
  String get scientificFact6Title;

  /// 과학적 팩트 7번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 중 작업 기억 용량이 25% 증가하여 복잡한 사고와 계획이 가능해집니다.'**
  String get scientificFact7Content;

  /// 과학적 팩트 7번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🧠 꿈 속에서 천재가 되고 있습니다!'**
  String get scientificFact7Impact;

  /// 과학적 팩트 7번 - BDNF 분비 증가 제목
  ///
  /// In ko, this message translates to:
  /// **'작업 기억력 향상'**
  String get scientificFact7Title;

  /// 과학적 팩트 8번 내용
  ///
  /// In ko, this message translates to:
  /// **'REM 수면 중 기억 통합 과정이 50% 효율적으로 진행되어 학습 내용이 장기 기억으로 전환됩니다.'**
  String get scientificFact8Content;

  /// 과학적 팩트 8번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'📚 잠자는 동안 지식이 뇌에 각인됩니다!'**
  String get scientificFact8Impact;

  /// 과학적 팩트 8번 - 반응 속도 개선 제목
  ///
  /// In ko, this message translates to:
  /// **'기억 통합 촉진'**
  String get scientificFact8Title;

  /// 과학적 팩트 9번 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽에서 문제 해결 능력이 23% 향상되어 창의적인 통찰을 얻을 수 있습니다.'**
  String get scientificFact9Content;

  /// 과학적 팩트 9번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'💡 꿈 속에서 해결책을 발견하고 있습니다!'**
  String get scientificFact9Impact;

  /// 과학적 팩트 9번 - 인터뉴런 활성화 제목
  ///
  /// In ko, this message translates to:
  /// **'창의적 문제 해결'**
  String get scientificFact9Title;

  /// 초 단위
  ///
  /// In ko, this message translates to:
  /// **'초'**
  String get seconds;

  /// 선택 버튼 또는 액션
  ///
  /// In ko, this message translates to:
  /// **'선택'**
  String get select;

  /// 시간 선택기 제목
  ///
  /// In ko, this message translates to:
  /// **'시간 선택'**
  String get selectTime;

  /// 선택된 상태
  ///
  /// In ko, this message translates to:
  /// **'선택됨'**
  String get selected;

  /// Send feedback button
  ///
  /// In ko, this message translates to:
  /// **'📧 피드백 보내기'**
  String get sendFeedback;

  /// 피드백 보내기 설명
  ///
  /// In ko, this message translates to:
  /// **'💬 너의 의견을 들려달라! 드림 스피릿들의 목소리가 필요하다!'**
  String get sendFeedbackDesc;

  /// 공유 버튼
  ///
  /// In ko, this message translates to:
  /// **'공유'**
  String get share;

  /// Share button
  ///
  /// In ko, this message translates to:
  /// **'공유'**
  String get shareButton;

  /// 공유 액션 메시지
  ///
  /// In ko, this message translates to:
  /// **'공유 중 📤'**
  String get shareMessage;

  /// 어깨 근육군
  ///
  /// In ko, this message translates to:
  /// **'어깨'**
  String get shoulders;

  /// 건너뛰기 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get skip;

  /// No description provided for @skipButton.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get skipButton;

  /// 권한 건너뛰기 버튼
  ///
  /// In ko, this message translates to:
  /// **'나중에 설정하기'**
  String get skipPermissions;

  /// No description provided for @start.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get start;

  /// 상태 레이블
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get status;

  /// No description provided for @statusAvailable.
  ///
  /// In ko, this message translates to:
  /// **'참여 가능'**
  String get statusAvailable;

  /// No description provided for @statusCompleted.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get statusCompleted;

  /// No description provided for @statusLocked.
  ///
  /// In ko, this message translates to:
  /// **'잠김'**
  String get statusLocked;

  /// No description provided for @storageAccess.
  ///
  /// In ko, this message translates to:
  /// **'📁 저장소 접근'**
  String get storageAccess;

  /// 저장소 혜택 1
  ///
  /// In ko, this message translates to:
  /// **'📁 꿈 일기 데이터 안전 백업'**
  String get storageBenefit1;

  /// 저장소 혜택 2
  ///
  /// In ko, this message translates to:
  /// **'🔄 기기 변경 시 데이터 복원'**
  String get storageBenefit2;

  /// 저장소 혜택 3
  ///
  /// In ko, this message translates to:
  /// **'💾 데이터 손실 방지'**
  String get storageBenefit3;

  /// 저장소 권한 설명
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 데이터 백업 및 복원을 위해 필요한다'**
  String get storagePermissionDesc;

  /// 저장소 권한 제목
  ///
  /// In ko, this message translates to:
  /// **'📁 저장소 권한'**
  String get storagePermissionTitle;

  /// 근력 향상 카테고리
  ///
  /// In ko, this message translates to:
  /// **'근력 향상'**
  String get strengthImprovement;

  /// 영상 제목 6
  ///
  /// In ko, this message translates to:
  /// **'근력의 비밀 💯'**
  String get strengthSecrets;

  /// No description provided for @success.
  ///
  /// In ko, this message translates to:
  /// **'성공'**
  String get success;

  /// 프로필 저장 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'👑 EMPEROR PROFILE SAVED! 너의 전설이 기록되었다, 만삣삐! 👑'**
  String get successProfileSaved;

  /// 스와이프 힌트 텍스트
  ///
  /// In ko, this message translates to:
  /// **'위로 스와이프하여 다음 영상'**
  String get swipeUpHint;

  /// Button label for swipe view mode
  ///
  /// In ko, this message translates to:
  /// **'스와이프 보기'**
  String get swipeView;

  /// 시스템 자동 갱신 알림 채널 설명
  ///
  /// In ko, this message translates to:
  /// **'시스템 자동 갱신 알림'**
  String get systemAutoRenewalChannelDescription;

  /// 목표 횟수 라벨
  ///
  /// In ko, this message translates to:
  /// **'목표'**
  String get target;

  /// Terms of service menu title
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get termsOfService;

  /// Terms of service description
  ///
  /// In ko, this message translates to:
  /// **'앱 사용시 약관 확인'**
  String get termsOfServiceDesc;

  /// 이번 달 라벨
  ///
  /// In ko, this message translates to:
  /// **'이번 달'**
  String get thisMonth;

  /// 운동 횟수 단위
  ///
  /// In ko, this message translates to:
  /// **'회'**
  String get times;

  /// No description provided for @totalExpEarned.
  ///
  /// In ko, this message translates to:
  /// **'총 획득 경험치'**
  String get totalExpEarned;

  /// 총 경험치 라벨
  ///
  /// In ko, this message translates to:
  /// **'총 경험치'**
  String get totalExperience;

  /// 총 목표 라벨
  ///
  /// In ko, this message translates to:
  /// **'총 목표:'**
  String get totalTarget;

  /// 삼두 근육군
  ///
  /// In ko, this message translates to:
  /// **'삼두'**
  String get triceps;

  /// 다시 시도 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get tryAgain;

  /// URL not available dialog message
  ///
  /// In ko, this message translates to:
  /// **'{page} 페이지는 아직 준비되지 않았다. 향후 업데이트에서 제공될 예정이다.'**
  String urlNotAvailableMessage(String page);

  /// URL not available dialog title
  ///
  /// In ko, this message translates to:
  /// **'페이지 준비 중'**
  String get urlNotAvailableTitle;

  /// 버전 레이블
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get version;

  /// 버전 및 빌드 정보
  ///
  /// In ko, this message translates to:
  /// **'버전 {version}+{buildNumber}'**
  String versionAndBuild(String buildNumber, String version);

  /// 버전 정보
  ///
  /// In ko, this message translates to:
  /// **'버전 정보'**
  String get versionInfo;

  /// 버전 정보 설명
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 v1.0.0'**
  String get versionInfoDesc;

  /// 승리의 시간 표시
  ///
  /// In ko, this message translates to:
  /// **'{time} - 승리의 시간!'**
  String victoryTime(String time);

  /// 영상 열기 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'영상을 열 수 없다. YouTube 앱을 확인해주세요.'**
  String get videoCannotOpen;

  /// View all button text
  ///
  /// In ko, this message translates to:
  /// **'전체 보기'**
  String get viewAll;

  /// Wrong pose label
  ///
  /// In ko, this message translates to:
  /// **'잘못된 자세'**
  String get wrongPose;

  /// 연간 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'연간'**
  String get yearly;

  /// No description provided for @later.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get later;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @startFree.
  ///
  /// In ko, this message translates to:
  /// **'무료로 시작하기'**
  String get startFree;

  /// No description provided for @upgrade.
  ///
  /// In ko, this message translates to:
  /// **'업그레이드'**
  String get upgrade;

  /// No description provided for @subscribe.
  ///
  /// In ko, this message translates to:
  /// **'구독하기'**
  String get subscribe;

  /// No description provided for @subscribeNow.
  ///
  /// In ko, this message translates to:
  /// **'지금 구독하기'**
  String get subscribeNow;

  /// No description provided for @startSubscription.
  ///
  /// In ko, this message translates to:
  /// **'구독 시작하기'**
  String get startSubscription;

  /// No description provided for @upgradeToPremium.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄으로 업그레이드'**
  String get upgradeToPremium;

  /// No description provided for @reset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get reset;

  /// No description provided for @signInGoogle.
  ///
  /// In ko, this message translates to:
  /// **'구글로 로그인'**
  String get signInGoogle;

  /// No description provided for @signInGoogleQuick.
  ///
  /// In ko, this message translates to:
  /// **'구글로 3초만에 시작하기'**
  String get signInGoogleQuick;

  /// No description provided for @viewAchievements.
  ///
  /// In ko, this message translates to:
  /// **'업적 보기'**
  String get viewAchievements;

  /// No description provided for @expandAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 확장'**
  String get expandAll;

  /// 시작하기 버튼 텍스트 (이모지 포함)
  ///
  /// In ko, this message translates to:
  /// **'시작하기 🚀'**
  String get getStarted;

  /// No description provided for @error.
  ///
  /// In ko, this message translates to:
  /// **'오류'**
  String get error;

  /// No description provided for @accountInfo.
  ///
  /// In ko, this message translates to:
  /// **'계정 정보'**
  String get accountInfo;

  /// No description provided for @goalSettings.
  ///
  /// In ko, this message translates to:
  /// **'목표 설정'**
  String get goalSettings;

  /// No description provided for @premiumFeatures.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 기능'**
  String get premiumFeatures;

  /// No description provided for @tomorrowChadActivity.
  ///
  /// In ko, this message translates to:
  /// **'내일의 Chad 활동'**
  String get tomorrowChadActivity;

  /// No description provided for @createAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정 생성'**
  String get createAccount;

  /// No description provided for @premiumSubscription.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구독'**
  String get premiumSubscription;

  /// No description provided for @manageSubscription.
  ///
  /// In ko, this message translates to:
  /// **'구독 관리'**
  String get manageSubscription;

  /// No description provided for @tutorial.
  ///
  /// In ko, this message translates to:
  /// **'튜토리얼'**
  String get tutorial;

  /// No description provided for @scientificEvidence.
  ///
  /// In ko, this message translates to:
  /// **'과학적 근거'**
  String get scientificEvidence;

  /// No description provided for @personalizedProgramReady.
  ///
  /// In ko, this message translates to:
  /// **'맞춤형 프로그램 준비완료!'**
  String get personalizedProgramReady;

  /// No description provided for @logoutConfirm.
  ///
  /// In ko, this message translates to:
  /// **'정말로 로그아웃하시겠습니까? 저장되지 않은 데이터는 손실될 수 있습니다.'**
  String get logoutConfirm;

  /// No description provided for @guestMode.
  ///
  /// In ko, this message translates to:
  /// **'게스트 모드'**
  String get guestMode;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 Chad 계정이 있나요?'**
  String get alreadyHaveAccount;

  /// No description provided for @welcome.
  ///
  /// In ko, this message translates to:
  /// **'환영합니다!'**
  String get welcome;

  /// No description provided for @subscriptionSuccess.
  ///
  /// In ko, this message translates to:
  /// **'구독이 성공적으로 완료되었습니다!'**
  String get subscriptionSuccess;

  /// No description provided for @cannotStartPurchase.
  ///
  /// In ko, this message translates to:
  /// **'구매를 시작할 수 없습니다.'**
  String get cannotStartPurchase;

  /// No description provided for @loadingSubscription.
  ///
  /// In ko, this message translates to:
  /// **'구독 상품을 불러오는 중...'**
  String get loadingSubscription;

  /// No description provided for @termsPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'이용약관 및 개인정보처리방침'**
  String get termsPrivacy;

  /// No description provided for @restorePurchases.
  ///
  /// In ko, this message translates to:
  /// **'구매 복원을 시도했습니다.'**
  String get restorePurchases;

  /// No description provided for @competitionTitle.
  ///
  /// In ko, this message translates to:
  /// **'경쟁과 순위'**
  String get competitionTitle;

  /// No description provided for @competitionDesc.
  ///
  /// In ko, this message translates to:
  /// **'다른 사용자와 비교하고 순위를 확인하며 동기부여'**
  String get competitionDesc;

  /// No description provided for @personalRecordTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인 기록'**
  String get personalRecordTitle;

  /// No description provided for @personalRecordDesc.
  ///
  /// In ko, this message translates to:
  /// **'나만의 목표 달성과 개인 기록 향상에 집중'**
  String get personalRecordDesc;

  /// No description provided for @featureRequiresPremium.
  ///
  /// In ko, this message translates to:
  /// **'{featureName}을 사용하려면 프리미엄 구독이 필요합니다.'**
  String featureRequiresPremium(Object featureName);

  /// No description provided for @requiredSubscription.
  ///
  /// In ko, this message translates to:
  /// **'필요한 구독:'**
  String get requiredSubscription;

  /// No description provided for @premiumBenefits.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 혜택'**
  String get premiumBenefits;

  /// No description provided for @premiumSubscriptionPrice.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구독 (₩4,900/월)'**
  String get premiumSubscriptionPrice;

  /// 프리미엄 혜택: 광고 제거
  ///
  /// In ko, this message translates to:
  /// **'광고 제거'**
  String get premiumBenefitAdFree;

  /// No description provided for @premiumBenefitFastLoading.
  ///
  /// In ko, this message translates to:
  /// **'⚡ VIP 빠른 로딩'**
  String get premiumBenefitFastLoading;

  /// No description provided for @premiumBenefitCloudBackup.
  ///
  /// In ko, this message translates to:
  /// **'☁️ 클라우드 백업'**
  String get premiumBenefitCloudBackup;

  /// No description provided for @thisFeature.
  ///
  /// In ko, this message translates to:
  /// **'이 기능'**
  String get thisFeature;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// 일 단위
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get days;

  /// No description provided for @consecutiveGoal.
  ///
  /// In ko, this message translates to:
  /// **'연속 목표'**
  String get consecutiveGoal;

  /// No description provided for @name.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get name;

  /// No description provided for @dayMon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get daySun;

  /// No description provided for @videoDemo.
  ///
  /// In ko, this message translates to:
  /// **'비디오 시연'**
  String get videoDemo;

  /// Semantic label for video placeholder
  ///
  /// In ko, this message translates to:
  /// **'{title} 플레이스홀더. 비디오가 준비되지 않았습니다.'**
  String videoDemoPlaceholder(String title);

  /// No description provided for @loadingVideo.
  ///
  /// In ko, this message translates to:
  /// **'비디오 로딩 중...'**
  String get loadingVideo;

  /// No description provided for @unableToLoadVideo.
  ///
  /// In ko, this message translates to:
  /// **'비디오를 불러올 수 없습니다'**
  String get unableToLoadVideo;

  /// No description provided for @fullscreenComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'풀스크린 기능은 추후 구현 예정입니다.'**
  String get fullscreenComingSoon;

  /// No description provided for @pauseVideo.
  ///
  /// In ko, this message translates to:
  /// **'비디오 일시정지'**
  String get pauseVideo;

  /// No description provided for @playVideo.
  ///
  /// In ko, this message translates to:
  /// **'비디오 재생'**
  String get playVideo;

  /// No description provided for @completionInfo.
  ///
  /// In ko, this message translates to:
  /// **'완료 정보'**
  String get completionInfo;

  /// Completed date format
  ///
  /// In ko, this message translates to:
  /// **'완료일: {date}'**
  String completedDate(String date);

  /// No description provided for @abandonButton.
  ///
  /// In ko, this message translates to:
  /// **'포기'**
  String get abandonButton;

  /// No description provided for @allowButton.
  ///
  /// In ko, this message translates to:
  /// **'허용'**
  String get allowButton;

  /// No description provided for @btnCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get btnCancel;

  /// No description provided for @btnClose.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get btnClose;

  /// No description provided for @btnConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get btnConfirm;

  /// No description provided for @btnExpandAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 확장'**
  String get btnExpandAll;

  /// No description provided for @btnLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get btnLater;

  /// No description provided for @btnPrevious.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get btnPrevious;

  /// No description provided for @btnRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get btnRetry;

  /// No description provided for @btnSave.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get btnSave;

  /// No description provided for @btnSkip.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get btnSkip;

  /// No description provided for @btnSubscribe.
  ///
  /// In ko, this message translates to:
  /// **'구독하기'**
  String get btnSubscribe;

  /// No description provided for @calendarTab.
  ///
  /// In ko, this message translates to:
  /// **'달력'**
  String get calendarTab;

  /// No description provided for @collapsedInfo.
  ///
  /// In ko, this message translates to:
  /// **'축소됨. 탭하여 확장'**
  String get collapsedInfo;

  /// No description provided for @completedStatus.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get completedStatus;

  /// No description provided for @confirmButton.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirmButton;

  /// No description provided for @contactButton.
  ///
  /// In ko, this message translates to:
  /// **'연락'**
  String get contactButton;

  /// No description provided for @currentStatus.
  ///
  /// In ko, this message translates to:
  /// **'현재'**
  String get currentStatus;

  /// No description provided for @descriptionText.
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get descriptionText;

  /// No description provided for @difficultyExpertDesc.
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿 레전드'**
  String get difficultyExpertDesc;

  /// No description provided for @disabledStatus.
  ///
  /// In ko, this message translates to:
  /// **'비활성화'**
  String get disabledStatus;

  /// No description provided for @enabledStatus.
  ///
  /// In ko, this message translates to:
  /// **'활성화'**
  String get enabledStatus;

  /// No description provided for @encryptionLabel.
  ///
  /// In ko, this message translates to:
  /// **'암호화'**
  String get encryptionLabel;

  /// No description provided for @expandedInfo.
  ///
  /// In ko, this message translates to:
  /// **'확장됨'**
  String get expandedInfo;

  /// No description provided for @finishButton.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get finishButton;

  /// No description provided for @goodStatus.
  ///
  /// In ko, this message translates to:
  /// **'좋음'**
  String get goodStatus;

  /// No description provided for @laterButton.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get laterButton;

  /// No description provided for @licenseButton.
  ///
  /// In ko, this message translates to:
  /// **'라이선스'**
  String get licenseButton;

  /// No description provided for @msgLogoutConfirm.
  ///
  /// In ko, this message translates to:
  /// **'정말로 로그아웃하시겠습니까? 저장되지 않은 데이터는 손실될 수 있습니다.'**
  String get msgLogoutConfirm;

  /// No description provided for @msgTermsAndPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'이용약관 및 개인정보처리방침'**
  String get msgTermsAndPrivacy;

  /// No description provided for @perfectionist.
  ///
  /// In ko, this message translates to:
  /// **'완벽주의자'**
  String get perfectionist;

  /// No description provided for @permissionAllowed.
  ///
  /// In ko, this message translates to:
  /// **'허용됨'**
  String get permissionAllowed;

  /// No description provided for @quizButton.
  ///
  /// In ko, this message translates to:
  /// **'퀴즈'**
  String get quizButton;

  /// No description provided for @selectAction.
  ///
  /// In ko, this message translates to:
  /// **'선택'**
  String get selectAction;

  /// No description provided for @selectedState.
  ///
  /// In ko, this message translates to:
  /// **'선택됨'**
  String get selectedState;

  /// No description provided for @startButton.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get startButton;

  /// No description provided for @targetText.
  ///
  /// In ko, this message translates to:
  /// **'목표'**
  String get targetText;

  /// No description provided for @titleLogout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get titleLogout;

  /// No description provided for @titleScientificEvidence.
  ///
  /// In ko, this message translates to:
  /// **'과학적 근거'**
  String get titleScientificEvidence;

  /// No description provided for @welcomeTitle.
  ///
  /// In ko, this message translates to:
  /// **'환영합니다!'**
  String get welcomeTitle;

  /// No description provided for @signupThankYouMessage.
  ///
  /// In ko, this message translates to:
  /// **'🎉 Lucid Dream 100에 가입해주셔서 감사합니다!'**
  String get signupThankYouMessage;

  /// No description provided for @launchEventBenefits.
  ///
  /// In ko, this message translates to:
  /// **'런칭 이벤트 혜택:'**
  String get launchEventBenefits;

  /// No description provided for @benefit1MonthFree.
  ///
  /// In ko, this message translates to:
  /// **'• 1개월 무료 프리미엄 기능'**
  String get benefit1MonthFree;

  /// No description provided for @oneMonthFreePremium.
  ///
  /// In ko, this message translates to:
  /// **'1개월 무료 프리미엄'**
  String get oneMonthFreePremium;

  /// No description provided for @benefit14WeeksProgram.
  ///
  /// In ko, this message translates to:
  /// **'• 전체 30일 프로그램 접근'**
  String get benefit14WeeksProgram;

  /// No description provided for @benefitAllChadStages.
  ///
  /// In ko, this message translates to:
  /// **'• 모든 드림 스피릿 진화 단계'**
  String get benefitAllChadStages;

  /// No description provided for @benefitDetailedStats.
  ///
  /// In ko, this message translates to:
  /// **'• 상세 통계 및 분석'**
  String get benefitDetailedStats;

  /// No description provided for @startWorkoutNow.
  ///
  /// In ko, this message translates to:
  /// **'지금 바로 운동을 시작해보세요! 💪'**
  String get startWorkoutNow;

  /// No description provided for @premiumFeaturesSummary.
  ///
  /// In ko, this message translates to:
  /// **'전체 30일 프로그램 + 모든 드림 스피릿 + 상세 통계'**
  String get premiumFeaturesSummary;

  /// No description provided for @benefitPersonalizedPlan.
  ///
  /// In ko, this message translates to:
  /// **'• 개인화된 운동 계획'**
  String get benefitPersonalizedPlan;

  /// No description provided for @benefitCloudBackup.
  ///
  /// In ko, this message translates to:
  /// **'• 진행상황 클라우드 백업'**
  String get benefitCloudBackup;

  /// No description provided for @benefitBodyAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'• 상세한 체성분 분석'**
  String get benefitBodyAnalysis;

  /// No description provided for @competitionGoalDescription.
  ///
  /// In ko, this message translates to:
  /// **'다른 사용자와 비교하고 순위를 확인하며 동기부여'**
  String get competitionGoalDescription;

  /// No description provided for @personalRecord.
  ///
  /// In ko, this message translates to:
  /// **'개인 기록'**
  String get personalRecord;

  /// No description provided for @personalRecordGoalDescription.
  ///
  /// In ko, this message translates to:
  /// **'나만의 목표 달성과 개인 기록 향상에 집중'**
  String get personalRecordGoalDescription;

  /// No description provided for @viewAllReferences.
  ///
  /// In ko, this message translates to:
  /// **'전체 참고문헌 보기'**
  String get viewAllReferences;

  /// No description provided for @tomorrowActivitiesMessage.
  ///
  /// In ko, this message translates to:
  /// **'Chad가 내일 추천할 활동들이야! 미리 준비해두자! 💪'**
  String get tomorrowActivitiesMessage;

  /// No description provided for @googleLogin.
  ///
  /// In ko, this message translates to:
  /// **'구글로 로그인'**
  String get googleLogin;

  /// No description provided for @googleSignin3Seconds.
  ///
  /// In ko, this message translates to:
  /// **'구글로 3초만에 시작하기'**
  String get googleSignin3Seconds;

  /// No description provided for @alreadyHaveChadAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 Chad 계정이 있나요?'**
  String get alreadyHaveChadAccount;

  /// No description provided for @googleQuickSignup.
  ///
  /// In ko, this message translates to:
  /// **'구글로 빠른 가입'**
  String get googleQuickSignup;

  /// No description provided for @chadActivityCompleted.
  ///
  /// In ko, this message translates to:
  /// **'{activityTitle} 완료! Chad가 자랑스러워해! 💪'**
  String chadActivityCompleted(String activityTitle);

  /// No description provided for @todayWorkoutRecommendation.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 추천 운동'**
  String get todayWorkoutRecommendation;

  /// No description provided for @rpeDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동 강도 평가'**
  String get rpeDialogTitle;

  /// No description provided for @rpeDialogSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘 운동이 얼마나 힘들었나요?'**
  String get rpeDialogSubtitle;

  /// No description provided for @rpeLevel6Title.
  ///
  /// In ko, this message translates to:
  /// **'매우 쉬움'**
  String get rpeLevel6Title;

  /// No description provided for @rpeLevel7Title.
  ///
  /// In ko, this message translates to:
  /// **'쉬움'**
  String get rpeLevel7Title;

  /// No description provided for @rpeLevel8Title.
  ///
  /// In ko, this message translates to:
  /// **'적당함'**
  String get rpeLevel8Title;

  /// No description provided for @rpeLevel9Title.
  ///
  /// In ko, this message translates to:
  /// **'힘듦'**
  String get rpeLevel9Title;

  /// No description provided for @rpeLevel10Title.
  ///
  /// In ko, this message translates to:
  /// **'최대 강도'**
  String get rpeLevel10Title;

  /// No description provided for @rpeLevel6Description.
  ///
  /// In ko, this message translates to:
  /// **'전혀 힘들지 않았어요'**
  String get rpeLevel6Description;

  /// No description provided for @rpeLevel7Description.
  ///
  /// In ko, this message translates to:
  /// **'조금 힘들었어요'**
  String get rpeLevel7Description;

  /// No description provided for @rpeLevel8Description.
  ///
  /// In ko, this message translates to:
  /// **'적당히 힘들었어요'**
  String get rpeLevel8Description;

  /// No description provided for @rpeLevel9Description.
  ///
  /// In ko, this message translates to:
  /// **'많이 힘들었어요'**
  String get rpeLevel9Description;

  /// No description provided for @rpeLevel10Description.
  ///
  /// In ko, this message translates to:
  /// **'최대로 힘들었어요'**
  String get rpeLevel10Description;

  /// No description provided for @signupPromptTitle.
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 시작하기'**
  String get signupPromptTitle;

  /// No description provided for @signupPromptMessage.
  ///
  /// In ko, this message translates to:
  /// **'{goalText}\n\n가입하고 프리미엄 혜택을 받으세요!'**
  String signupPromptMessage(String goalText);

  /// No description provided for @signupPromptLaunchEvent.
  ///
  /// In ko, this message translates to:
  /// **'🎉 런칭 이벤트:'**
  String get signupPromptLaunchEvent;

  /// No description provided for @signupPromptBenefit1.
  ///
  /// In ko, this message translates to:
  /// **'• 1개월 무료 프리미엄'**
  String get signupPromptBenefit1;

  /// No description provided for @signupPromptBenefit2.
  ///
  /// In ko, this message translates to:
  /// **'• 전체 30일 프로그램 접근'**
  String get signupPromptBenefit2;

  /// No description provided for @signupPromptBenefit3.
  ///
  /// In ko, this message translates to:
  /// **'• 모든 드림 스피릿 진화 단계'**
  String get signupPromptBenefit3;

  /// No description provided for @signupPromptBenefit4.
  ///
  /// In ko, this message translates to:
  /// **'• 상세 통계 및 분석'**
  String get signupPromptBenefit4;

  /// No description provided for @signupPromptCallToAction.
  ///
  /// In ko, this message translates to:
  /// **'지금 가입하면 혜택을 받을 수 있어요!'**
  String get signupPromptCallToAction;

  /// No description provided for @expandAllSteps.
  ///
  /// In ko, this message translates to:
  /// **'모든 단계 펼치기'**
  String get expandAllSteps;

  /// No description provided for @noActiveSubscription.
  ///
  /// In ko, this message translates to:
  /// **'활성화된 구독이 없습니다'**
  String get noActiveSubscription;

  /// No description provided for @subscribeForPremium.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 기능을 이용하려면 구독하세요'**
  String get subscribeForPremium;

  /// No description provided for @startSubscriptionButton.
  ///
  /// In ko, this message translates to:
  /// **'구독 시작하기'**
  String get startSubscriptionButton;

  /// No description provided for @chadRecoveryTitle.
  ///
  /// In ko, this message translates to:
  /// **'Chad 회복 가이드'**
  String get chadRecoveryTitle;

  /// No description provided for @chadRecoverySettingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'회복 설정'**
  String get chadRecoverySettingsTitle;

  /// No description provided for @chadRecoverySettingsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'회복 활동 맞춤 설정'**
  String get chadRecoverySettingsSubtitle;

  /// No description provided for @chadWeeklyRecoveryReport.
  ///
  /// In ko, this message translates to:
  /// **'주간 회복 리포트'**
  String get chadWeeklyRecoveryReport;

  /// No description provided for @tomorrowsChadActivity.
  ///
  /// In ko, this message translates to:
  /// **'내일의 Chad 활동'**
  String get tomorrowsChadActivity;

  /// No description provided for @chadActivityDuration.
  ///
  /// In ko, this message translates to:
  /// **'{duration}분 활동'**
  String chadActivityDuration(String duration);

  /// No description provided for @moreActivities.
  ///
  /// In ko, this message translates to:
  /// **'+ {count}개 더 보기'**
  String moreActivities(String count);

  /// No description provided for @chadRecoverySettings.
  ///
  /// In ko, this message translates to:
  /// **'회복 설정'**
  String get chadRecoverySettings;

  /// No description provided for @goalProgramReady.
  ///
  /// In ko, this message translates to:
  /// **'{goalText}을(를) 위한 맞춤 프로그램이 준비되었습니다!'**
  String goalProgramReady(String goalText);

  /// No description provided for @signupToAchieveGoal.
  ///
  /// In ko, this message translates to:
  /// **'목표를 달성하려면 가입하세요'**
  String get signupToAchieveGoal;

  /// No description provided for @startForFree.
  ///
  /// In ko, this message translates to:
  /// **'무료로 시작하기'**
  String get startForFree;

  /// No description provided for @viewAchievement.
  ///
  /// In ko, this message translates to:
  /// **'업적 보기'**
  String get viewAchievement;

  /// No description provided for @chadLevelUpTitle.
  ///
  /// In ko, this message translates to:
  /// **'Chad 레벨 업!'**
  String get chadLevelUpTitle;

  /// No description provided for @viewChad.
  ///
  /// In ko, this message translates to:
  /// **'Chad 보기'**
  String get viewChad;

  /// No description provided for @continueWithGoogle.
  ///
  /// In ko, this message translates to:
  /// **'Google로 계속하기'**
  String get continueWithGoogle;

  /// 데이터 복원 제목
  ///
  /// In ko, this message translates to:
  /// **'• 데이터 복원'**
  String get dataRestore;

  /// 진행도 라벨
  ///
  /// In ko, this message translates to:
  /// **'진행도'**
  String get progress;

  /// 진척도 화면의 통계 하위 탭
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get statisticsTab;

  /// 진척도 화면의 업적 하위 탭
  ///
  /// In ko, this message translates to:
  /// **'🏆 업적'**
  String get achievementsTab;

  /// 캘린더 선택된 날짜 표시
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월 {day}일'**
  String calendarSelectedDate(Object day, Object month, Object year);

  /// 체크리스트 로드 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'체크리스트를 불러오지 못했습니다'**
  String get homeChecklistLoadError;

  /// AI 꿈 분석 카드 타이틀
  ///
  /// In ko, this message translates to:
  /// **'AI 꿈 분석'**
  String get homeAIDreamAnalysisTitle;

  /// AI 꿈 분석 카드 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'당신의 꿈의 비밀을 풀어보세요'**
  String get homeAIDreamAnalysisSubtitle;

  /// AI 어시스턴트 카드 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'Lumi와 자각몽에 대해 대화하기'**
  String get aiAssistantSubtitle;

  /// 일일 보상 다이얼로그 타이틀
  ///
  /// In ko, this message translates to:
  /// **'일일 로그인 보상'**
  String get homeDailyRewardTitle;

  /// 일일 보상 다이얼로그 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 여정에서 멋진 노력을 계속하세요!'**
  String get homeDailyRewardMessage;

  /// 프리미엄 보너스 적용 메시지
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 보너스 적용!'**
  String get homePremiumBonusApplied;

  /// Lumi와 대화 메시지 (보상 개수 포함)
  ///
  /// In ko, this message translates to:
  /// **'Lumi와 대화하고 +{amount} 토큰 받기'**
  String homeChatWithLumiMessage(Object amount);

  /// 나중에 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get homeLaterButton;

  /// 받기 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'받기'**
  String get homeClaimButton;

  /// 일일 보상 받음 메시지
  ///
  /// In ko, this message translates to:
  /// **'+{amount} 토큰을 받았습니다!'**
  String homeDailyRewardReceived(Object amount);

  /// No description provided for @accountInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'계정 정보'**
  String get accountInfoTitle;

  /// No description provided for @accountTypeLabel.
  ///
  /// In ko, this message translates to:
  /// **'계정 유형'**
  String get accountTypeLabel;

  /// Cannot open email app error
  ///
  /// In ko, this message translates to:
  /// **'이메일 앱을 열 수 없다'**
  String get cannotOpenEmail;

  /// Send feedback via email
  ///
  /// In ko, this message translates to:
  /// **'이메일로 의견을 보내주세요'**
  String get emailFeedback;

  /// No description provided for @emailLabel.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get emailLabel;

  /// No description provided for @emailMethod.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get emailMethod;

  /// Send feedback via email
  ///
  /// In ko, this message translates to:
  /// **'이메일로 피드백 보내기'**
  String get feedbackEmail;

  /// No description provided for @freeAccountType.
  ///
  /// In ko, this message translates to:
  /// **'무료 계정'**
  String get freeAccountType;

  /// No description provided for @googleMethod.
  ///
  /// In ko, this message translates to:
  /// **'Google'**
  String get googleMethod;

  /// No description provided for @guestModeMessage.
  ///
  /// In ko, this message translates to:
  /// **'게스트 모드로 사용 중입니다. 로그인하여 진행 상황을 저장하세요.'**
  String get guestModeMessage;

  /// No description provided for @loginButton.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get loginButton;

  /// No description provided for @loginMethodLabel.
  ///
  /// In ko, this message translates to:
  /// **'로그인 방법'**
  String get loginMethodLabel;

  /// No description provided for @logoutFromAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정에서 로그아웃합니다'**
  String get logoutFromAccount;

  /// 사용자 프로필 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'사용자 프로필이 없다'**
  String get noUserProfile;

  /// No description provided for @premiumAccountType.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 계정'**
  String get premiumAccountType;

  /// 사용자 프로필 필요 설명
  ///
  /// In ko, this message translates to:
  /// **'운동을 시작하려면 사용자 프로필이 필요한다'**
  String get userProfileRequired;

  /// No description provided for @accountCreationRequired.
  ///
  /// In ko, this message translates to:
  /// **'간단한 계정 생성이 필요합니다'**
  String get accountCreationRequired;

  /// No description provided for @purchaseProtectionMessage.
  ///
  /// In ko, this message translates to:
  /// **'구매하신 {product}을(를) 안전하게\n관리하고 모든 기기에서 사용하려면\n계정이 필요합니다.'**
  String purchaseProtectionMessage(Object product);

  /// No description provided for @cloudSync.
  ///
  /// In ko, this message translates to:
  /// **'클라우드 동기화'**
  String get cloudSync;

  /// No description provided for @multiDeviceAccess.
  ///
  /// In ko, this message translates to:
  /// **'여러 기기에서 사용'**
  String get multiDeviceAccess;

  /// No description provided for @dataBackupRestore.
  ///
  /// In ko, this message translates to:
  /// **'데이터 백업 & 복원'**
  String get dataBackupRestore;

  /// No description provided for @purchaseHistoryProtection.
  ///
  /// In ko, this message translates to:
  /// **'구매 내역 보호'**
  String get purchaseHistoryProtection;

  /// No description provided for @completesIn30Seconds.
  ///
  /// In ko, this message translates to:
  /// **'30초면 완료됩니다'**
  String get completesIn30Seconds;

  /// No description provided for @keepDataSafe.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 안전하게 보관하세요'**
  String get keepDataSafe;

  /// No description provided for @signupBenefitsMessage.
  ///
  /// In ko, this message translates to:
  /// **'회원가입하시면 모든 운동 기록과\n진행 상황이 클라우드에 자동 백업됩니다.'**
  String get signupBenefitsMessage;

  /// 자동 백업 설정
  ///
  /// In ko, this message translates to:
  /// **'자동 백업'**
  String get autoBackup;

  /// No description provided for @dataRetainOnDeviceChange.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰을 바꿔도 데이터 유지'**
  String get dataRetainOnDeviceChange;

  /// No description provided for @multiDeviceSync.
  ///
  /// In ko, this message translates to:
  /// **'여러 기기 동기화'**
  String get multiDeviceSync;

  /// No description provided for @continueAnywhere.
  ///
  /// In ko, this message translates to:
  /// **'태블릿, 폰 어디서나 이어하기'**
  String get continueAnywhere;

  /// No description provided for @fastAppStart.
  ///
  /// In ko, this message translates to:
  /// **'앱 시작 시 10배 빠른 속도'**
  String get fastAppStart;

  /// No description provided for @allFeaturesWithoutSignup.
  ///
  /// In ko, this message translates to:
  /// **'회원가입 없이도 모든 기능을 사용할 수 있습니다'**
  String get allFeaturesWithoutSignup;

  /// No description provided for @signupIn30Seconds.
  ///
  /// In ko, this message translates to:
  /// **'회원가입 (30초)'**
  String get signupIn30Seconds;

  /// No description provided for @btnSignInGoogle.
  ///
  /// In ko, this message translates to:
  /// **'구글로 로그인'**
  String get btnSignInGoogle;

  /// No description provided for @btnStartGoogleQuick.
  ///
  /// In ko, this message translates to:
  /// **'구글로 3초만에 시작하기'**
  String get btnStartGoogleQuick;

  /// No description provided for @msgAlreadyHaveAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 드림 스피릿 계정이 있나요?'**
  String get msgAlreadyHaveAccount;

  /// No description provided for @msgGuestMode.
  ///
  /// In ko, this message translates to:
  /// **'게스트 모드로 사용 중입니다. 로그인하여 진행 상황을 저장하세요.'**
  String get msgGuestMode;

  /// No description provided for @titleAccountInfo.
  ///
  /// In ko, this message translates to:
  /// **'계정 정보'**
  String get titleAccountInfo;

  /// No description provided for @titleCreateAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정 생성'**
  String get titleCreateAccount;

  /// 구글 로그인 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'구글 로그인에 실패했습니다. 다시 시도해주세요.'**
  String get loginGoogleSignInFailed;

  /// 드림 스피릿과 시작 준비 타이틀
  ///
  /// In ko, this message translates to:
  /// **'자각몽 여정을 시작할 준비가 되셨나요?'**
  String get loginReadyToStartWithChad;

  /// 드림플로우 여정 시작 메시지
  ///
  /// In ko, this message translates to:
  /// **'의식적인 꿈의 세계로 떠나세요'**
  String get loginStartDreamflowJourney;

  /// 드림 스피릿과 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿과 시작하기'**
  String get loginStartWithChad;

  /// 런칭 특별 이벤트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎉 런칭 특별 이벤트'**
  String get loginChadLaunchSpecial;

  /// 무료 체험 제안 메시지
  ///
  /// In ko, this message translates to:
  /// **'프리미엄을 30일 무료로 사용해보세요'**
  String get loginChadFreeTrialOffer;

  /// 이미 계정이 있음 텍스트
  ///
  /// In ko, this message translates to:
  /// **'이미 계정이 있으신가요?'**
  String get loginAlreadyHaveChadAccount;

  /// 이메일 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get loginEmail;

  /// 이메일 필수 검증
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요'**
  String get loginEmailRequired;

  /// 이메일 유효하지 않음 검증
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일을 입력해주세요'**
  String get loginEmailInvalid;

  /// 비밀번호 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get loginPassword;

  /// 비밀번호 필수 검증
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해주세요'**
  String get loginPasswordRequired;

  /// 비밀번호 최소 길이 검증
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 최소 6자 이상이어야 합니다'**
  String get loginPasswordMinLength;

  /// 로그인 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get loginLoginButton;

  /// 약관 동의 필수 검증
  ///
  /// In ko, this message translates to:
  /// **'이용약관에 동의해주세요'**
  String get signupChadTermsAgreementRequired;

  /// 환영 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 여정에 오신 것을 환영합니다!'**
  String get signupChadWelcomeMessage;

  /// 구글 회원가입 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'구글 회원가입에 실패했습니다. 다시 시도해주세요.'**
  String get signupChadGoogleSignupFailed;

  /// 회원가입 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'계정 만들기'**
  String get signupChadScreenTitle;

  /// 회원가입 진행 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'계정을 생성하는 중...'**
  String get signupChadSigningUp;

  /// 무료 한 달 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'무료로 한 달 시작하기'**
  String get signupChadStartFreeMonth;

  /// 런칭 특별 이벤트 타이틀
  ///
  /// In ko, this message translates to:
  /// **'🎊 런칭 특별 이벤트'**
  String get signupChadLaunchSpecialEvent;

  /// 혜택 목록 타이틀
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 혜택'**
  String get signupChadBenefitsList;

  /// 또는 이메일 회원가입 구분선
  ///
  /// In ko, this message translates to:
  /// **'또는 이메일로 가입하기'**
  String get signupChadOrEmailSignup;

  /// 이름 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get signupChadNameLabel;

  /// 이름 필수 검증
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해주세요'**
  String get signupChadNameRequired;

  /// 이름 최소 길이 검증
  ///
  /// In ko, this message translates to:
  /// **'이름은 최소 2자 이상이어야 합니다'**
  String get signupChadNameMinLength;

  /// 이메일 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get signupChadEmailLabel;

  /// 이메일 필수 검증
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요'**
  String get signupChadEmailRequired;

  /// 이메일 유효하지 않음 검증
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일을 입력해주세요'**
  String get signupChadEmailInvalid;

  /// 비밀번호 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get signupChadPasswordLabel;

  /// 비밀번호 필수 검증
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해주세요'**
  String get signupChadPasswordRequired;

  /// 비밀번호 최소 길이 검증
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 최소 6자 이상이어야 합니다'**
  String get signupChadPasswordMinLength;

  /// 비밀번호 확인 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get signupChadConfirmPasswordLabel;

  /// 비밀번호 확인 필수 검증
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 다시 입력해주세요'**
  String get signupChadConfirmPasswordRequired;

  /// 비밀번호 불일치 검증
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않습니다'**
  String get signupChadPasswordsNotMatch;

  /// 약관 동의 체크박스 텍스트
  ///
  /// In ko, this message translates to:
  /// **'이용약관에 동의합니다'**
  String get signupChadTermsAgreement;

  /// 회원가입 화면의 로그인 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get signupChadLoginButton;

  /// 한계 시험 챌린지 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌙 오늘부터 자각몽 여정을 시작할까요?'**
  String get challengeTestYourLimits;

  /// 초기 테스트 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'프로필을 생성하고 자각몽 훈련을 시작해주세요'**
  String get completeInitialTest;

  /// No description provided for @getStartedButton.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get getStartedButton;

  /// 온보딩 적응형 훈련 설명
  ///
  /// In ko, this message translates to:
  /// **'어려우면? → 난이도 조정 ⬇️\n쉬우면? → 새로운 기법 추가 ⬆️\n\n당신에게 맞는 난이도로 간다! 🔥'**
  String get onboardingAdaptiveTrainingDescription;

  /// 온보딩 적응형 훈련 제목
  ///
  /// In ko, this message translates to:
  /// **'🎯 당신에게 맞춰드려요'**
  String get onboardingAdaptiveTrainingTitle;

  /// 온보딩 적응형 훈련 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'오케이! 👌'**
  String get onboardingButtonGotIt;

  /// 온보딩 진화 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'준비됐어요! 💪'**
  String get onboardingButtonGreat;

  /// 온보딩 다음 버튼
  ///
  /// In ko, this message translates to:
  /// **'계속할게요! 💪'**
  String get onboardingButtonNext;

  /// 온보딩 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'시작할게요! 🔥'**
  String get onboardingButtonStart;

  /// 온보딩 테스트 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'시작할게요! 🎯'**
  String get onboardingButtonStartTest;

  /// 온보딩 초기 테스트 설명
  ///
  /// In ko, this message translates to:
  /// **'당신만의 자각몽 여정을 시작하세요.\n\n• 목표 설정하기\n• 꿈 일기 준비\n• 첫 번째 기법 배우기'**
  String get onboardingInitialTestDescription;

  /// 온보딩 초기 테스트 제목
  ///
  /// In ko, this message translates to:
  /// **'여정 시작 준비 ⏱️'**
  String get onboardingInitialTestTitle;

  /// 미션 맞춤형 프로그램 고급 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'11-14주차'**
  String get onboardingMissionAdvancedDesc;

  /// 미션 맞춤형 프로그램 고급 레벨 제목
  ///
  /// In ko, this message translates to:
  /// **'고급자'**
  String get onboardingMissionAdvancedTitle;

  /// 미션 맞춤형 프로그램 과학적 근거 메시지
  ///
  /// In ko, this message translates to:
  /// **'과학적 근거 기반 프로그램'**
  String get onboardingMissionAssurance;

  /// 미션 Week 1-2 제목
  ///
  /// In ko, this message translates to:
  /// **'Week 1-2: 기초 훈련'**
  String get onboardingMissionWeek12Title;

  /// 미션 Week 1-2 설명
  ///
  /// In ko, this message translates to:
  /// **'꿈 회상력 향상 및 리얼리티 체크 습관화'**
  String get onboardingMissionWeek12Desc;

  /// 미션 Week 3-4 제목
  ///
  /// In ko, this message translates to:
  /// **'Week 3-4: 자각몽 입문'**
  String get onboardingMissionWeek34Title;

  /// 미션 Week 3-4 설명
  ///
  /// In ko, this message translates to:
  /// **'WBTB+MILD 기법으로 첫 자각몽 경험'**
  String get onboardingMissionWeek34Desc;

  /// 미션 Week 5-8 제목
  ///
  /// In ko, this message translates to:
  /// **'Week 5-8: 마스터'**
  String get onboardingMissionWeek58Title;

  /// 미션 Week 5-8 설명
  ///
  /// In ko, this message translates to:
  /// **'자각몽 제어 및 고급 기법 마스터'**
  String get onboardingMissionWeek58Desc;

  /// 과학 논문 기반 프로그램 뱃지
  ///
  /// In ko, this message translates to:
  /// **'과학 논문 기반 프로그램'**
  String get onboardingMissionScientificBasis;

  /// 미션 맞춤형 프로그램 초급 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'1-6주차'**
  String get onboardingMissionBeginnerDesc;

  /// 미션 맞춤형 프로그램 초급 레벨 제목
  ///
  /// In ko, this message translates to:
  /// **'초급자'**
  String get onboardingMissionBeginnerTitle;

  /// 미션 맞춤형 프로그램 중급 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'7-10주차'**
  String get onboardingMissionIntermediateDesc;

  /// 미션 맞춤형 프로그램 중급 레벨 제목
  ///
  /// In ko, this message translates to:
  /// **'중급자'**
  String get onboardingMissionIntermediateTitle;

  /// 미션 맞춤형 프로그램 제목
  ///
  /// In ko, this message translates to:
  /// **'맞춤형 14주 프로그램'**
  String get onboardingMissionPersonalizedProgram;

  /// No description provided for @onboardingNext.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get onboardingStart;

  /// 온보딩 환영 화면 설명
  ///
  /// In ko, this message translates to:
  /// **'30일이면 충분해. 당신도 자각몽을 경험할 수 있어요.\n함께 시작해봐요! 🌙'**
  String get onboardingWelcomeDescription;

  /// 온보딩 환영 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'30일, 자각몽 마스터! 🔥'**
  String get onboardingWelcomeTitle;

  /// No description provided for @startTestButton.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get startTestButton;

  /// No description provided for @stepByStepGuide.
  ///
  /// In ko, this message translates to:
  /// **'단계별\n가이드'**
  String get stepByStepGuide;

  /// No description provided for @testAdMessage.
  ///
  /// In ko, this message translates to:
  /// **'테스트 광고 - 자각몽 앱'**
  String get testAdMessage;

  /// No description provided for @tutorialButton.
  ///
  /// In ko, this message translates to:
  /// **'💥 자각몽 MASTER 되기 💥'**
  String get tutorialButton;

  /// No description provided for @tutorialDetailTitle.
  ///
  /// In ko, this message translates to:
  /// **'💥 꿈 기법 MASTER하기 💥'**
  String get tutorialDetailTitle;

  /// No description provided for @tutorialSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'진짜 DREAM MASTER는 기법부터 다르다! 🌙'**
  String get tutorialSubtitle;

  /// No description provided for @tutorialTitle.
  ///
  /// In ko, this message translates to:
  /// **'🔥 자각몽 MASTERY DOJO 🔥'**
  String get tutorialTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In ko, this message translates to:
  /// **'🔥 WELCOME,\nFUTURE DREAM MASTER! 🔥\n각성의 시간이다!'**
  String get welcomeMessage;

  /// No description provided for @startJourney.
  ///
  /// In ko, this message translates to:
  /// **'여정 시작하기! 🚀'**
  String get startJourney;

  /// No description provided for @setWorkoutSchedule.
  ///
  /// In ko, this message translates to:
  /// **'🔥 꿈 연습 스케줄을 설정하세요!'**
  String get setWorkoutSchedule;

  /// No description provided for @workoutScheduleDescription.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 마스터가 되려면 꾸준한 연습이 필요합니다!\n매일 꾸준한 연습해야 합니다. 💪\n\n라이프스타일에 맞는 날을 선택하고,\n알림으로 리마인더하세요! 🚀'**
  String get workoutScheduleDescription;

  /// No description provided for @goalSetupComplete.
  ///
  /// In ko, this message translates to:
  /// **'🎉 목표 설정 완료!'**
  String get goalSetupComplete;

  /// No description provided for @goalSetupCompleteMessage.
  ///
  /// In ko, this message translates to:
  /// **'이제 당신만의 맞춤형 DreamFlow 여정이 시작됩니다.\n런칭 이벤트로 1개월 무료 체험해보세요!'**
  String get goalSetupCompleteMessage;

  /// No description provided for @keyFeatures.
  ///
  /// In ko, this message translates to:
  /// **'✨ 주요 기능'**
  String get keyFeatures;

  /// No description provided for @scientificBasisTitle.
  ///
  /// In ko, this message translates to:
  /// **'과학적 근거 기반'**
  String get scientificBasisTitle;

  /// No description provided for @scientificBasisDesc.
  ///
  /// In ko, this message translates to:
  /// **'최신 자각몽 연구 논문을\n바탕으로 설계된 프로그램'**
  String get scientificBasisDesc;

  /// No description provided for @progressiveOverloadTitle.
  ///
  /// In ko, this message translates to:
  /// **'일일 체크리스트 시스템'**
  String get progressiveOverloadTitle;

  /// No description provided for @progressiveOverloadDesc.
  ///
  /// In ko, this message translates to:
  /// **'WBTB + MILD 기법 등\n46% 성공률 검증된 기법'**
  String get progressiveOverloadDesc;

  /// No description provided for @rpeAdaptationTitle.
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 추적'**
  String get rpeAdaptationTitle;

  /// No description provided for @rpeAdaptationDesc.
  ///
  /// In ko, this message translates to:
  /// **'꿈 회상과\n자각몽 경험을 기록'**
  String get rpeAdaptationDesc;

  /// No description provided for @chadEvolutionTitle.
  ///
  /// In ko, this message translates to:
  /// **'Dream Spirit 진화'**
  String get chadEvolutionTitle;

  /// No description provided for @chadEvolutionDesc.
  ///
  /// In ko, this message translates to:
  /// **'자각몽을 마스터할수록\n성장하는 영혼 가이드'**
  String get chadEvolutionDesc;

  /// No description provided for @readyToStart.
  ///
  /// In ko, this message translates to:
  /// **'준비되셨나요?'**
  String get readyToStart;

  /// No description provided for @readyToStartSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 여정을 시작해보세요'**
  String get readyToStartSubtitle;

  /// No description provided for @getStartedStep1.
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 작성하기'**
  String get getStartedStep1;

  /// No description provided for @getStartedStep2.
  ///
  /// In ko, this message translates to:
  /// **'매일 체크리스트 완료하기'**
  String get getStartedStep2;

  /// No description provided for @getStartedStep3.
  ///
  /// In ko, this message translates to:
  /// **'60일 자각몽 마스터 되기'**
  String get getStartedStep3;

  /// No description provided for @findYourLevel.
  ///
  /// In ko, this message translates to:
  /// **'먼저 간단한 설정으로\n당신의 시작점을 찾아보세요'**
  String get findYourLevel;

  /// No description provided for @step1LevelTest.
  ///
  /// In ko, this message translates to:
  /// **'목표 설정 (1분)'**
  String get step1LevelTest;

  /// No description provided for @step2SetStartDate.
  ///
  /// In ko, this message translates to:
  /// **'연습 시작일 설정'**
  String get step2SetStartDate;

  /// No description provided for @step3StartJourney.
  ///
  /// In ko, this message translates to:
  /// **'30일 여정 시작!'**
  String get step3StartJourney;

  /// No description provided for @awesome.
  ///
  /// In ko, this message translates to:
  /// **'멋져요!'**
  String get awesome;

  /// No description provided for @onboardingProgramIntroTitle.
  ///
  /// In ko, this message translates to:
  /// **'30일 자각몽 프로그램'**
  String get onboardingProgramIntroTitle;

  /// No description provided for @onboardingProgramIntroDescription.
  ///
  /// In ko, this message translates to:
  /// **'과학적으로 설계된 30일 프로그램으로\n자각몽 마스터를 목표로 합니다'**
  String get onboardingProgramIntroDescription;

  /// No description provided for @btnGetStarted.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get btnGetStarted;

  /// No description provided for @msgWelcome.
  ///
  /// In ko, this message translates to:
  /// **'환영합니다!'**
  String get msgWelcome;

  /// No description provided for @titleTutorial.
  ///
  /// In ko, this message translates to:
  /// **'튜토리얼'**
  String get titleTutorial;

  /// No description provided for @goalSetupCurrentWeight.
  ///
  /// In ko, this message translates to:
  /// **'현재 체중 (kg)'**
  String get goalSetupCurrentWeight;

  /// No description provided for @goalSetupTargetWeight.
  ///
  /// In ko, this message translates to:
  /// **'목표 체중 (kg, 선택사항)'**
  String get goalSetupTargetWeight;

  /// No description provided for @goalSetupNextButton.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get goalSetupNextButton;

  /// No description provided for @goalSetupStartButton.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get goalSetupStartButton;

  /// No description provided for @goalSetupLevelBeginnerTitle.
  ///
  /// In ko, this message translates to:
  /// **'초보자'**
  String get goalSetupLevelBeginnerTitle;

  /// No description provided for @goalSetupLevelBeginnerDesc.
  ///
  /// In ko, this message translates to:
  /// **'자각몽을 처음 시작하거나 오랜만에 하는 경우'**
  String get goalSetupLevelBeginnerDesc;

  /// No description provided for @goalSetupLevelIntermediateTitle.
  ///
  /// In ko, this message translates to:
  /// **'중급자'**
  String get goalSetupLevelIntermediateTitle;

  /// No description provided for @goalSetupLevelIntermediateDesc.
  ///
  /// In ko, this message translates to:
  /// **'꾸준히 연습을 해왔고 기본 기법에 익숙한 경우'**
  String get goalSetupLevelIntermediateDesc;

  /// No description provided for @goalSetupLevelAdvancedTitle.
  ///
  /// In ko, this message translates to:
  /// **'고급자'**
  String get goalSetupLevelAdvancedTitle;

  /// No description provided for @goalSetupLevelAdvancedDesc.
  ///
  /// In ko, this message translates to:
  /// **'강도 높은 훈련을 원하고 다양한 고급 기법을 시도하고 싶은 경우'**
  String get goalSetupLevelAdvancedDesc;

  /// No description provided for @goalSetupGoalWeightLossTitle.
  ///
  /// In ko, this message translates to:
  /// **'체중 감량'**
  String get goalSetupGoalWeightLossTitle;

  /// No description provided for @goalSetupGoalWeightLossDesc.
  ///
  /// In ko, this message translates to:
  /// **'체지방을 줄이고 날씬한 몸매 만들기'**
  String get goalSetupGoalWeightLossDesc;

  /// No description provided for @goalSetupGoalMuscleGainTitle.
  ///
  /// In ko, this message translates to:
  /// **'근육 증가'**
  String get goalSetupGoalMuscleGainTitle;

  /// No description provided for @goalSetupGoalMuscleGainDesc.
  ///
  /// In ko, this message translates to:
  /// **'탄탄한 근육과 매력적인 상체 라인 만들기'**
  String get goalSetupGoalMuscleGainDesc;

  /// No description provided for @goalSetupGoalStaminaTitle.
  ///
  /// In ko, this message translates to:
  /// **'체력 향상'**
  String get goalSetupGoalStaminaTitle;

  /// No description provided for @goalSetupGoalStaminaDesc.
  ///
  /// In ko, this message translates to:
  /// **'지구력과 전반적인 체력 개선하기'**
  String get goalSetupGoalStaminaDesc;

  /// No description provided for @goalSetupGoalHealthTitle.
  ///
  /// In ko, this message translates to:
  /// **'전반적인 건강'**
  String get goalSetupGoalHealthTitle;

  /// No description provided for @goalSetupGoalHealthDesc.
  ///
  /// In ko, this message translates to:
  /// **'건강한 생활습관과 균형잡힌 몸만들기'**
  String get goalSetupGoalHealthDesc;

  /// No description provided for @goalSetupTimeDawn.
  ///
  /// In ko, this message translates to:
  /// **'새벽 (5-7시)'**
  String get goalSetupTimeDawn;

  /// No description provided for @goalSetupTimeMorning.
  ///
  /// In ko, this message translates to:
  /// **'아침 (7-9시)'**
  String get goalSetupTimeMorning;

  /// No description provided for @goalSetupTimeLateMorning.
  ///
  /// In ko, this message translates to:
  /// **'오전 (9-12시)'**
  String get goalSetupTimeLateMorning;

  /// No description provided for @goalSetupTimeLunch.
  ///
  /// In ko, this message translates to:
  /// **'점심 (12-14시)'**
  String get goalSetupTimeLunch;

  /// No description provided for @goalSetupTimeAfternoon.
  ///
  /// In ko, this message translates to:
  /// **'오후 (14-17시)'**
  String get goalSetupTimeAfternoon;

  /// No description provided for @goalSetupTimeEvening.
  ///
  /// In ko, this message translates to:
  /// **'저녁 (17-20시)'**
  String get goalSetupTimeEvening;

  /// No description provided for @goalSetupTimeNight.
  ///
  /// In ko, this message translates to:
  /// **'밤 (20-22시)'**
  String get goalSetupTimeNight;

  /// No description provided for @goalSetupWelcomeMessage.
  ///
  /// In ko, this message translates to:
  /// **'이제 당신만의 맞춤형 자각몽 여정이 시작됩니다.\n런칭 이벤트로 1개월 무료 체험해보세요!'**
  String get goalSetupWelcomeMessage;

  /// No description provided for @goalSetupStartJourney.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get goalSetupStartJourney;

  /// No description provided for @goalSetupCompleteTitle.
  ///
  /// In ko, this message translates to:
  /// **'🎉 목표 설정 완료!'**
  String get goalSetupCompleteTitle;

  /// No description provided for @tutorialWelcomeTitle.
  ///
  /// In ko, this message translates to:
  /// **'🌙 Lucid Dream 100'**
  String get tutorialWelcomeTitle;

  /// No description provided for @tutorialWelcomeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'30일 만에 자각몽 마스터 되기'**
  String get tutorialWelcomeSubtitle;

  /// No description provided for @tutorialFeature1Title.
  ///
  /// In ko, this message translates to:
  /// **'과학적 근거 기반'**
  String get tutorialFeature1Title;

  /// No description provided for @tutorialFeature1Desc.
  ///
  /// In ko, this message translates to:
  /// **'최신 자각몽 연구(2014-2024)를\n바탕으로 설계된 프로그램'**
  String get tutorialFeature1Desc;

  /// No description provided for @tutorialFeature2Title.
  ///
  /// In ko, this message translates to:
  /// **'단계별 훈련'**
  String get tutorialFeature2Title;

  /// No description provided for @tutorialFeature2Desc.
  ///
  /// In ko, this message translates to:
  /// **'매일 체계적으로 증가하는 난이도로\n안전하고 효과적인 성장'**
  String get tutorialFeature2Desc;

  /// No description provided for @tutorialFeature3Title.
  ///
  /// In ko, this message translates to:
  /// **'맞춤형 프로그램'**
  String get tutorialFeature3Title;

  /// No description provided for @tutorialFeature3Desc.
  ///
  /// In ko, this message translates to:
  /// **'당신의 진행도에 맞춘\n맞춤형 훈련 계획'**
  String get tutorialFeature3Desc;

  /// No description provided for @tutorialProgramTitle.
  ///
  /// In ko, this message translates to:
  /// **'📋 프로그램 구성'**
  String get tutorialProgramTitle;

  /// No description provided for @tutorialDurationTitle.
  ///
  /// In ko, this message translates to:
  /// **'⏱️ 기간'**
  String get tutorialDurationTitle;

  /// No description provided for @tutorialDurationSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'30일 (매일)'**
  String get tutorialDurationSubtitle;

  /// No description provided for @tutorialDurationDesc.
  ///
  /// In ko, this message translates to:
  /// **'매일 꾸준한 연습\n매일 5-10분 투자'**
  String get tutorialDurationDesc;

  /// No description provided for @tutorialStructureTitle.
  ///
  /// In ko, this message translates to:
  /// **'🌙 구성'**
  String get tutorialStructureTitle;

  /// No description provided for @tutorialStructureSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'체크리스트 + 꿈 일기'**
  String get tutorialStructureSubtitle;

  /// No description provided for @tutorialStructureDesc.
  ///
  /// In ko, this message translates to:
  /// **'메인: 일일 체크리스트\n기록: 꿈 일기 작성'**
  String get tutorialStructureDesc;

  /// No description provided for @tutorialRestTitle.
  ///
  /// In ko, this message translates to:
  /// **'⏳ 소요 시간'**
  String get tutorialRestTitle;

  /// No description provided for @tutorialRestSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'최적화된 시간'**
  String get tutorialRestSubtitle;

  /// No description provided for @tutorialRestDesc.
  ///
  /// In ko, this message translates to:
  /// **'하루: 5-10분\n진행도에 따라 조정'**
  String get tutorialRestDesc;

  /// No description provided for @tutorialTipTitle.
  ///
  /// In ko, this message translates to:
  /// **'💡 꿀팁'**
  String get tutorialTipTitle;

  /// No description provided for @tutorialTipDesc.
  ///
  /// In ko, this message translates to:
  /// **'매일 완료율을 기록하면\n다음 체크리스트가 자동으로 조정됩니다!'**
  String get tutorialTipDesc;

  /// No description provided for @tutorialFormTitle.
  ///
  /// In ko, this message translates to:
  /// **'✅ 핵심 자각몽 기법'**
  String get tutorialFormTitle;

  /// No description provided for @tutorialForm1Title.
  ///
  /// In ko, this message translates to:
  /// **'1. WBTB 기법'**
  String get tutorialForm1Title;

  /// No description provided for @tutorialForm1Desc.
  ///
  /// In ko, this message translates to:
  /// **'일찍 잠들고 4-6시간 후 깨어나\n20-30분 깨어있기'**
  String get tutorialForm1Desc;

  /// No description provided for @tutorialForm2Title.
  ///
  /// In ko, this message translates to:
  /// **'2. MILD 기법'**
  String get tutorialForm2Title;

  /// No description provided for @tutorialForm2Desc.
  ///
  /// In ko, this message translates to:
  /// **'잠들기 전 \"나는 꿈이라는 걸 알아차릴 거야\"\n반복하며 자각 의도 강화'**
  String get tutorialForm2Desc;

  /// No description provided for @tutorialForm3Title.
  ///
  /// In ko, this message translates to:
  /// **'3. Reality Check'**
  String get tutorialForm3Title;

  /// No description provided for @tutorialForm3Desc.
  ///
  /// In ko, this message translates to:
  /// **'하루 10번 이상\n\"지금 꿈인가?\" 확인하기'**
  String get tutorialForm3Desc;

  /// No description provided for @tutorialWarningTitle.
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 주의사항'**
  String get tutorialWarningTitle;

  /// No description provided for @tutorialWarning1.
  ///
  /// In ko, this message translates to:
  /// **'무리하지 말고 자신의 페이스 유지'**
  String get tutorialWarning1;

  /// No description provided for @tutorialWarning2.
  ///
  /// In ko, this message translates to:
  /// **'충분한 수면 시간 확보(7-8시간)'**
  String get tutorialWarning2;

  /// No description provided for @tutorialWarning3.
  ///
  /// In ko, this message translates to:
  /// **'스트레스 받지 않고 즐기기'**
  String get tutorialWarning3;

  /// No description provided for @tutorialWarning4.
  ///
  /// In ko, this message translates to:
  /// **'수면 장애 있으면 전문가 상담'**
  String get tutorialWarning4;

  /// No description provided for @tutorialRpeTitle.
  ///
  /// In ko, this message translates to:
  /// **'📊 완료율이란?'**
  String get tutorialRpeTitle;

  /// No description provided for @tutorialRpeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'일일 체크리스트 달성도'**
  String get tutorialRpeSubtitle;

  /// No description provided for @tutorialRpe6.
  ///
  /// In ko, this message translates to:
  /// **'😊 너무 쉬워요'**
  String get tutorialRpe6;

  /// No description provided for @tutorialRpe6Desc.
  ///
  /// In ko, this message translates to:
  /// **'더 많은 기법을 추가할 수 있어요'**
  String get tutorialRpe6Desc;

  /// No description provided for @tutorialRpe7.
  ///
  /// In ko, this message translates to:
  /// **'🙂 적당해요'**
  String get tutorialRpe7;

  /// No description provided for @tutorialRpe7Desc.
  ///
  /// In ko, this message translates to:
  /// **'딱 좋은 난이도예요'**
  String get tutorialRpe7Desc;

  /// No description provided for @tutorialRpe8.
  ///
  /// In ko, this message translates to:
  /// **'😤 힘들어요'**
  String get tutorialRpe8;

  /// No description provided for @tutorialRpe8Desc.
  ///
  /// In ko, this message translates to:
  /// **'완료하기 버거웠어요'**
  String get tutorialRpe8Desc;

  /// No description provided for @tutorialRpe9.
  ///
  /// In ko, this message translates to:
  /// **'😫 너무 힘들어요'**
  String get tutorialRpe9;

  /// No description provided for @tutorialRpe9Desc.
  ///
  /// In ko, this message translates to:
  /// **'거의 불가능했어요'**
  String get tutorialRpe9Desc;

  /// No description provided for @tutorialRpe10.
  ///
  /// In ko, this message translates to:
  /// **'🤯 완벽!'**
  String get tutorialRpe10;

  /// No description provided for @tutorialRpe10Desc.
  ///
  /// In ko, this message translates to:
  /// **'모든 항목 완료했어요'**
  String get tutorialRpe10Desc;

  /// No description provided for @tutorialAutoAdjustTitle.
  ///
  /// In ko, this message translates to:
  /// **'🎯 똑똑한 자동 조정'**
  String get tutorialAutoAdjustTitle;

  /// No description provided for @tutorialAutoAdjustDesc.
  ///
  /// In ko, this message translates to:
  /// **'완료율을 기록하면 다음 체크리스트가\n자동으로 최적화됩니다!\n\n• 80% 이상: 새 기법 추가\n• 60-80%: 유지\n• 60% 미만: 난이도 조정'**
  String get tutorialAutoAdjustDesc;

  /// No description provided for @tutorialScienceTitle.
  ///
  /// In ko, this message translates to:
  /// **'🔬 과학적 근거'**
  String get tutorialScienceTitle;

  /// No description provided for @tutorialScienceSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'최신 자각몽 연구를 바탕으로 설계되었습니다'**
  String get tutorialScienceSubtitle;

  /// No description provided for @tutorialResearch1Author.
  ///
  /// In ko, this message translates to:
  /// **'Stumbrys et al. (2012)'**
  String get tutorialResearch1Author;

  /// No description provided for @tutorialResearch1Topic.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 유도 기법 효과'**
  String get tutorialResearch1Topic;

  /// No description provided for @tutorialResearch1Finding.
  ///
  /// In ko, this message translates to:
  /// **'MILD + WBTB 조합이 가장 효과적\n46% 성공률 입증'**
  String get tutorialResearch1Finding;

  /// No description provided for @tutorialResearch2Author.
  ///
  /// In ko, this message translates to:
  /// **'LaBerge et al. (2018)'**
  String get tutorialResearch2Author;

  /// No description provided for @tutorialResearch2Topic.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 빈도'**
  String get tutorialResearch2Topic;

  /// No description provided for @tutorialResearch2Finding.
  ///
  /// In ko, this message translates to:
  /// **'주 2-4회 자각몽이\n일반적인 빈도'**
  String get tutorialResearch2Finding;

  /// No description provided for @tutorialResearch3Author.
  ///
  /// In ko, this message translates to:
  /// **'Aspy et al. (2017)'**
  String get tutorialResearch3Author;

  /// No description provided for @tutorialResearch3Topic.
  ///
  /// In ko, this message translates to:
  /// **'MILD 기법 효과'**
  String get tutorialResearch3Topic;

  /// No description provided for @tutorialResearch3Finding.
  ///
  /// In ko, this message translates to:
  /// **'MILD 기법 사용 시\n자각몽 확률 크게 증가'**
  String get tutorialResearch3Finding;

  /// No description provided for @tutorialResearch4Author.
  ///
  /// In ko, this message translates to:
  /// **'Voss et al. (2014)'**
  String get tutorialResearch4Author;

  /// No description provided for @tutorialResearch4Topic.
  ///
  /// In ko, this message translates to:
  /// **'Reality Check'**
  String get tutorialResearch4Topic;

  /// No description provided for @tutorialResearch4Finding.
  ///
  /// In ko, this message translates to:
  /// **'Reality Check 연습이\n자각몽 유도에 도움'**
  String get tutorialResearch4Finding;

  /// 앱 정보 섹션
  ///
  /// In ko, this message translates to:
  /// **'ℹ️ 앱 정보'**
  String get aboutSettings;

  /// 모든 데이터 초기화 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'모든 데이터가 성공적으로 초기화되었다'**
  String get allDataResetSuccessfully;

  /// 외관 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'외관 설정'**
  String get appearanceSettings;

  /// 다음 세트 자동 시작 설정
  ///
  /// In ko, this message translates to:
  /// **'다음 세트 자동 시작'**
  String get autoStartNextSet;

  /// 다음 세트 자동 시작 설명
  ///
  /// In ko, this message translates to:
  /// **'휴식 후 자동으로 다음 세트 시작'**
  String get autoStartNextSetDesc;

  /// Average per session label
  ///
  /// In ko, this message translates to:
  /// **'평균/세션'**
  String get averagePerSession;

  /// 백업 실패로 인해 중단된 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'백업 실패로 인한 중단'**
  String get backupFailureStoppedStatus;

  /// No description provided for @backupRestoreError.
  ///
  /// In ko, this message translates to:
  /// **'백업 복원 중 오류 발생: {error}'**
  String backupRestoreError(Object error);

  /// No description provided for @backupRestoreFailed.
  ///
  /// In ko, this message translates to:
  /// **'백업 복원에 실패했다'**
  String get backupRestoreFailed;

  /// No description provided for @backupRestoredSuccessfully.
  ///
  /// In ko, this message translates to:
  /// **'백업이 성공적으로 복원되었다'**
  String get backupRestoredSuccessfully;

  /// 데이터 백업 설명
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 기록을 백업한다'**
  String get backupWorkoutRecords;

  /// Best week label
  ///
  /// In ko, this message translates to:
  /// **'최고 주차'**
  String get bestWeek;

  /// 총 자각몽 연습 횟수 부제목
  ///
  /// In ko, this message translates to:
  /// **'자각몽 마스터가 된 날들!'**
  String get chadDays;

  /// 알림 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'🔔 알림 설정'**
  String get chadNotificationSettings;

  /// 휴식모드 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'오케이! 오늘은 휴식모드다! 💪😎'**
  String get chadRestModeToday;

  /// 시간 설정 섹션
  ///
  /// In ko, this message translates to:
  /// **'⏰ 시간 설정'**
  String get chadTimeSettings;

  /// 14 consecutive days challenge description
  ///
  /// In ko, this message translates to:
  /// **'14일 동안 연속으로 자각몽 연습하기'**
  String get challenge14DaysDescription;

  /// 14 consecutive days challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'하루도 안 빠지고 14일 연속! 7일 챌린지 클리어 후 도전! 💪'**
  String get challenge14DaysDetailedDescription;

  /// 14 consecutive days challenge title
  ///
  /// In ko, this message translates to:
  /// **'14일 연속 연습'**
  String get challenge14DaysTitle;

  /// 7 consecutive days challenge description
  ///
  /// In ko, this message translates to:
  /// **'7일 동안 연속으로 자각몽 연습하기'**
  String get challenge7DaysDescription;

  /// 7 consecutive days challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'하루도 안 빠지고 7일 연속! 매일 최소 1세트! 🔥'**
  String get challenge7DaysDetailedDescription;

  /// 7 consecutive days challenge title
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 연습'**
  String get challenge7DaysTitle;

  /// Hint for consecutive days challenges
  ///
  /// In ko, this message translates to:
  /// **'매일 꾸준히! 하루라도 빠뜨리면 처음부터 다시! 💪'**
  String get challengeHintConsecutiveDays;

  /// Hint for single session challenges
  ///
  /// In ko, this message translates to:
  /// **'한 번에 목표 개수! 중간에 쉬면 안 돼! 🔥'**
  String get challengeHintSingleSession;

  /// Restart challenge button
  ///
  /// In ko, this message translates to:
  /// **'다시 시작'**
  String get challengeRestartButton;

  /// Challenge type: consecutive days
  ///
  /// In ko, this message translates to:
  /// **'연속 일수'**
  String get challengeTypeConsecutiveDays;

  /// Challenge type: single session
  ///
  /// In ko, this message translates to:
  /// **'단일 세션'**
  String get challengeTypeSingleSession;

  /// Days unit for challenges
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get challengeUnitDays;

  /// Reps unit for challenges
  ///
  /// In ko, this message translates to:
  /// **'개'**
  String get challengeUnitReps;

  /// 마지막 세트 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'전설 등극, 만삣삐!'**
  String get completeSetButton;

  /// 일반 세트 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'또 하나 박살내기!'**
  String get completeSetContinue;

  /// 완료된 횟수 형식
  ///
  /// In ko, this message translates to:
  /// **'완료: {completed}회'**
  String completedRepsFormat(int completed);

  /// Completed sessions label
  ///
  /// In ko, this message translates to:
  /// **'완료 세션'**
  String get completedSessions;

  /// 완료된 세트 수
  ///
  /// In ko, this message translates to:
  /// **'완료된 세트: {count}개'**
  String completedSetsCount(int count);

  /// 데이터 초기화 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'데이터 초기화 확인'**
  String get confirmDataReset;

  /// Consecutive days label
  ///
  /// In ko, this message translates to:
  /// **'연속 일수'**
  String get consecutiveDays;

  /// 연속 연습 차단 제목
  ///
  /// In ko, this message translates to:
  /// **'STOP! 연속 연습 금지!'**
  String get consecutiveWorkoutBlocked;

  /// 연속 연습 차단 메시지
  ///
  /// In ko, this message translates to:
  /// **'야야야! 어제 운동했잖아! 🔥\n\n지금 뭘 하려는거야? 연속 연습이야?\n진짜 강자라면 쉴 때 확실히 쉬는 거다!\n\n💀 과도한 연습은 노답이야!\n😎 오늘은 쿨하게 쉬고 내일 다시 가자! 💪'**
  String get consecutiveWorkoutMessage;

  /// Custom workout days setting
  ///
  /// In ko, this message translates to:
  /// **'연습일 설정'**
  String get customWorkoutDays;

  /// Custom workout days description
  ///
  /// In ko, this message translates to:
  /// **'원하는 요일에 자각몽 연습하도록 설정해'**
  String get customWorkoutDaysDesc;

  /// 일일 알림 설정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'매일 {time} 자각몽 연습 알림 설정 완료! 💪'**
  String dailyNotificationSet(Object time);

  /// 매일 운동 시간 알림 메시지
  ///
  /// In ko, this message translates to:
  /// **'매일 운동 시간 알림! 놓치면 WEAK! 💪'**
  String get dailyWorkoutAlarm;

  /// 일일 자각몽 연습 알림 설정
  ///
  /// In ko, this message translates to:
  /// **'일일 자각몽 연습 알림'**
  String get dailyWorkoutReminder;

  /// 데이터 초기화 제목
  ///
  /// In ko, this message translates to:
  /// **'데이터 초기화'**
  String get dataReset;

  /// 데이터 초기화 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 초기화 기능은 준비 중이다'**
  String get dataResetComingSoon;

  /// 데이터 초기화 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'정말로 모든 데이터를 삭제할래? 이 작업은 되돌릴 수 없다.'**
  String get dataResetConfirm;

  /// 데이터 초기화 설명
  ///
  /// In ko, this message translates to:
  /// **'모든 데이터를 삭제한다'**
  String get dataResetDesc;

  /// 데이터 초기화 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 초기화 중 오류가 발생했다: {error}'**
  String dataResetErrorOccurred(String error);

  /// 데이터 복원 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 복원 기능은 준비 중이다'**
  String get dataRestoreComingSoon;

  /// 데이터 복원 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 복원이 완료되었다! 앱을 재시작해주세요.'**
  String get dataRestoreCompleted;

  /// 데이터 복원 설명
  ///
  /// In ko, this message translates to:
  /// **'백업된 데이터를 복원한다'**
  String get dataRestoreDesc;

  /// 데이터 복원 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 복원에 실패했다. 백업 파일을 확인해주세요.'**
  String get dataRestoreFailed;

  /// 데이터 복원 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 데이터 복원'**
  String get dataRestoreTitle;

  /// 데이터 복원 경고 메시지
  ///
  /// In ko, this message translates to:
  /// **'백업 파일로부터 데이터를 복원하면 현재 데이터가 모두 삭제된다.\\n정말로 복원할래?'**
  String get dataRestoreWarning;

  /// 데이터 관리 섹션
  ///
  /// In ko, this message translates to:
  /// **'💾 데이터 관리'**
  String get dataSettings;

  /// 년월일 한국어 날짜 형식
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월 {day}일'**
  String dateFormatYearMonthDay(int day, int month, int year);

  /// 일 레이블
  ///
  /// In ko, this message translates to:
  /// **'📅 Day'**
  String get dayLabel;

  /// Day number format
  ///
  /// In ko, this message translates to:
  /// **'{day}일차'**
  String dayX(int day);

  /// 일 형식
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String daysFormat(int days);

  /// 데이터 초기화 설명
  ///
  /// In ko, this message translates to:
  /// **'모든 자각몽 연습 기록을 삭제한다'**
  String get deleteAllWorkoutRecords;

  /// 상세 리마인더 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'상세 리마인더 설정'**
  String get detailedReminderSettings;

  /// 난이도 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'난이도 설정'**
  String get difficultySettings;

  /// 난이도 설정 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'난이도 설정 기능은 준비 중이다'**
  String get difficultySettingsComingSoon;

  /// 난이도 설정 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'💪 난이도 설정'**
  String get difficultySettingsTitle;

  /// 오류 발생 시 재시도 요청 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했다. 다시 시도해주세요'**
  String get errorPleaseTryAgain;

  /// First workout completed description
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 자각몽 연습 완료'**
  String get firstWorkoutCompleted;

  /// 첫 자각몽 연습 시작 메시지
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 자각몽 연습을 시작한다! 화이팅!'**
  String get firstWorkoutMessage;

  /// 발견된 자각몽 연습 제목
  ///
  /// In ko, this message translates to:
  /// **'🔍 발견된 자각몽 연습'**
  String get foundWorkout;

  /// No description provided for @fridayFull.
  ///
  /// In ko, this message translates to:
  /// **'금요일'**
  String get fridayFull;

  /// Friday short form
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get fridayShort;

  /// 설정 화면으로 이동 버튼
  ///
  /// In ko, this message translates to:
  /// **'설정으로 이동'**
  String get goToSettings;

  /// 영상 제목 5
  ///
  /// In ko, this message translates to:
  /// **'집에서 하는 자각몽 연습 🏠'**
  String get homeWorkoutPushups;

  /// Hundred reps in one session description
  ///
  /// In ko, this message translates to:
  /// **'한 세션에 100회 달성'**
  String get hundredRepsInOneSession;

  /// 미완료 운동 발견 메시지
  ///
  /// In ko, this message translates to:
  /// **'미완료된 자각몽 연습이 발견되었다!'**
  String get incompleteWorkoutFound;

  /// 언어 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get languageSettings;

  /// 언어 설정 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'언어 설정 기능은 준비 중이다'**
  String get languageSettingsComingSoon;

  /// Level reset title
  ///
  /// In ko, this message translates to:
  /// **'레벨 리셋'**
  String get levelReset;

  /// Level reset confirmation dialog title
  ///
  /// In ko, this message translates to:
  /// **'레벨 리셋 확인'**
  String get levelResetConfirm;

  /// Level reset description
  ///
  /// In ko, this message translates to:
  /// **'모든 진행 상황을 초기화하고 처음부터 시작한다.'**
  String get levelResetDesc;

  /// 앱 설정 관리 설명
  ///
  /// In ko, this message translates to:
  /// **'앱 설정을 관리해'**
  String get manageAppSettings;

  /// 최대 6일 운동 제한 메시지
  ///
  /// In ko, this message translates to:
  /// **'최대 6일까지만 자각몽 연습할 수 있다 (하루는 쉬어야 함)'**
  String get maxSixDaysWorkout;

  /// 최소 하루 쉬는 날 필요 메시지
  ///
  /// In ko, this message translates to:
  /// **'최소 하루는 쉬는 날이 있어야 한다'**
  String get minOneDayRest;

  /// Lucid Dream 100 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 설정'**
  String get mission100Settings;

  /// No description provided for @mondayFull.
  ///
  /// In ko, this message translates to:
  /// **'월요일'**
  String get mondayFull;

  /// Monday short form
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get mondayShort;

  /// 마지막 세트 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'굿 잡! 우주 정복 완료!'**
  String get nextSetButton;

  /// 다음 세트 진행 버튼
  ///
  /// In ko, this message translates to:
  /// **'다음 희생양을 가져와라, 만삣삐!'**
  String get nextSetContinue;

  /// 주 4회 운동 제한 메시지
  ///
  /// In ko, this message translates to:
  /// **'주 4회까지만 자각몽 연습할 수 있다. 충분한 휴식이 필요한다!'**
  String get noConsecutiveSixDays;

  /// 자각몽 연습하기로 결정 버튼
  ///
  /// In ko, this message translates to:
  /// **'아니다! 자각몽 연습할래!'**
  String get noWorkout;

  /// 자각몽 연습 기록이 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 기록이 없다'**
  String get noWorkoutHistory;

  /// 선택된 날짜에 자각몽 연습 기록 없음
  ///
  /// In ko, this message translates to:
  /// **'이 날에는 자각몽 연습 기록이 없다'**
  String get noWorkoutRecordForDate;

  /// 자각몽 연습 기록 없음 제목
  ///
  /// In ko, this message translates to:
  /// **'아직 자각몽 연습 기록이 없어!'**
  String get noWorkoutRecords;

  /// 자각몽 연습 기록이 없는 날 메시지
  ///
  /// In ko, this message translates to:
  /// **'이 날에는 자각몽 연습 기록이 없다'**
  String get noWorkoutThisDay;

  /// 오늘의 운동 없음 메시지 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'🤷‍♂️ 오늘은 휴식? 내일은 더 강력하게! 🔥'**
  String get noWorkoutToday;

  /// No workouts today message
  ///
  /// In ko, this message translates to:
  /// **'이 날에는 자각몽 연습이 없다'**
  String get noWorkoutsToday;

  /// 알림 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notificationSettings;

  /// 알림 설정 실패 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'알림 설정에 실패했다'**
  String get notificationSetupFailed;

  /// 알림 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notificationsSettings;

  /// One week challenge achievement
  ///
  /// In ko, this message translates to:
  /// **'일주일 챌린지'**
  String get oneWeekChallenge;

  /// One week completed description
  ///
  /// In ko, this message translates to:
  /// **'한 주 100% 완료'**
  String get oneWeekCompleted;

  /// 영상 설명 5
  ///
  /// In ko, this message translates to:
  /// **'집에서 할 수 있는 완벽한 자각몽 연습'**
  String get perfectHomeWorkout;

  /// Perfect week achievement
  ///
  /// In ko, this message translates to:
  /// **'완벽주의자'**
  String get perfectWeek;

  /// 프로그램 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'프로그램 완료! 정말 대단한다!'**
  String get programCompletedMessage;

  /// Program progress label
  ///
  /// In ko, this message translates to:
  /// **'프로그램 진행률'**
  String get programProgress;

  /// Program start requirement
  ///
  /// In ko, this message translates to:
  /// **'프로그램 시작'**
  String get programStart;

  /// 운동 진행 상황 - 세트 준비
  ///
  /// In ko, this message translates to:
  /// **'진행: {set}세트 준비 중'**
  String progressSetReady(int set);

  /// 진행 상황 상세
  ///
  /// In ko, this message translates to:
  /// **'{week}주차 - {totalDays}일 중 {completedDays}일 완료'**
  String progressWeekDay(int completedDays, int totalDays, int week);

  /// 최근 자각몽 연습 기록 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 자각몽 연습 기록'**
  String get recentWorkouts;

  /// 자각몽 연습 기록 형식
  ///
  /// In ko, this message translates to:
  /// **'{reps}개 • {percentage}% 달성'**
  String repsAchieved(int percentage, int reps);

  /// Reps completed label
  ///
  /// In ko, this message translates to:
  /// **'회 완료'**
  String get repsCompleted;

  /// 횟수 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String repsCount(int count);

  /// 횟수 형식
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String repsFormat(int count);

  /// 모든 진행 상황 초기화 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'정말로 모든 진행 상황을 초기화할래?'**
  String get resetAllProgressConfirm;

  /// 초기화 버튼
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get resetButton;

  /// 초기화 확인 다이얼로그 메시지
  ///
  /// In ko, this message translates to:
  /// **'정말로 모든 데이터를 삭제할래? 이 작업은 되돌릴 수 없다.'**
  String get resetConfirmMessage;

  /// 초기화 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'모든 데이터 초기화'**
  String get resetConfirmTitle;

  /// 초기화 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'모든 데이터가 성공적으로 초기화되었다'**
  String get resetSuccess;

  /// 데이터 초기화 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터를 초기화하는 중...'**
  String get resettingData;

  /// 휴식일 수용 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'휴식일을 받아들이을래?'**
  String get restDayAccept;

  /// 휴식일 보너스 챌린지 내용
  ///
  /// In ko, this message translates to:
  /// **'휴식일 보너스 챌린지! 💪\n\n• 명상 10분 x 3회\n• 현실 확인 20회\n• 꿈 일기 완벽하게 작성 (완벽한 자세로!)\n\n준비됐어? 진짜 자각몽 마스터만 할 수 있어! 🏆'**
  String get restDayBonusChallenge;

  /// 휴식일 추가 챌린지 메시지
  ///
  /// In ko, this message translates to:
  /// **'휴식일이라고? 그런 건 약한 놈들이나 하는 거야!\n진짜 챔피언들은 매일이 전쟁이다! 🥊\n\n간단한 추가 챌린지로 너의 정신력을 증명해봐!'**
  String get restDayChallenge;

  /// 휴식일 챔피언 모드 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 진짜 챔피언의 선택'**
  String get restDayChampionTitle;

  /// 휴식일 설명 메시지
  ///
  /// In ko, this message translates to:
  /// **'오늘은 프로그램상 휴식일이지만...\n진짜 챔피언들은 쉬지 않는다! 🔥\n\n추가 챌린지를 진행할래?'**
  String get restDayDescription;

  /// Rest day message for non-workout days
  ///
  /// In ko, this message translates to:
  /// **'오늘은 회복의 날. 진정한 강함은 휴식에서 나온다.'**
  String get restDayMessage;

  /// 휴식일 놀리기 메시지
  ///
  /// In ko, this message translates to:
  /// **'누군가는 100일 자각몽 연습하고 있어! 💪\n\n정말 오늘은 쉬실 건가요?'**
  String get restDayTeasing;

  /// 휴식 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'쉬는 것도 성장이야. 다음은 더 강력하게 가자, 만삣삐 🦍'**
  String get restMessage;

  /// 휴식 시간 설명
  ///
  /// In ko, this message translates to:
  /// **'세트 간 휴식 시간 설정'**
  String get restTimeDesc;

  /// 휴식 시간 설정
  ///
  /// In ko, this message translates to:
  /// **'휴식 시간 설정'**
  String get restTimeSettings;

  /// 휴식시간 제목
  ///
  /// In ko, this message translates to:
  /// **'강자들의 재충전 타임, 만삣삐 ⚡'**
  String get restTimeTitle;

  /// 백업 복원 버튼
  ///
  /// In ko, this message translates to:
  /// **'백업 복원'**
  String get restoreBackup;

  /// 데이터 복원 설명
  ///
  /// In ko, this message translates to:
  /// **'백업된 데이터를 복원한다'**
  String get restoreBackupData;

  /// 복원 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'복원 중 오류가 발생했다: {error}'**
  String restoreErrorOccurred(String error);

  /// 복원 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 복원이 성공적으로 완료되었다'**
  String get restoreSuccess;

  /// 데이터 복원 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터를 복원하는 중...'**
  String get restoringData;

  /// 운동 재개 제목
  ///
  /// In ko, this message translates to:
  /// **'💪 자각몽 연습 재개'**
  String get resumeWorkout;

  /// No description provided for @saturdayFull.
  ///
  /// In ko, this message translates to:
  /// **'토요일'**
  String get saturdayFull;

  /// Saturday short form
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get saturdayShort;

  /// 요일 선택 안내
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습할 요일을 선택해 (최대 6일)'**
  String get selectWorkoutDays;

  /// 선택된 요일 표시 형식
  ///
  /// In ko, this message translates to:
  /// **'선택됨: {days} ({count}/6일)'**
  String selectedDaysFormat(int count, String days);

  /// Sessions label
  ///
  /// In ko, this message translates to:
  /// **'세션'**
  String get sessions;

  /// Sessions completed label
  ///
  /// In ko, this message translates to:
  /// **'세션 완료'**
  String get sessionsCompleted;

  /// Sessions completed format
  ///
  /// In ko, this message translates to:
  /// **'{completed}/{total} 세션 완료 • {reps}회'**
  String sessionsCompletedFormat(int completed, int reps, int total);

  /// 목표 미달성이지만 세트 완료시
  ///
  /// In ko, this message translates to:
  /// **'not bad, 만삣삐! 또 하나의 한계를 부숴버렸어 ⚡🔱'**
  String get setCompletedGood;

  /// 목표 달성하고 세트 완료시
  ///
  /// In ko, this message translates to:
  /// **'굿 잡, 만삣삐! 또 하나의 신화가 탄생했어 🔥👑'**
  String get setCompletedSuccess;

  /// 세트 수 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}세트'**
  String setCount(int count);

  /// Set exact alarm permission button
  ///
  /// In ko, this message translates to:
  /// **'정확한 알람 권한 설정하기'**
  String get setExactAlarmPermission;

  /// 세트 형식
  ///
  /// In ko, this message translates to:
  /// **'{setNumber}세트: {reps}회'**
  String setFormat(int reps, int setNumber);

  /// Set format with number and reps
  ///
  /// In ko, this message translates to:
  /// **'{number}세트: {reps}회'**
  String setFormat2(int number, int reps);

  /// Set records label
  ///
  /// In ko, this message translates to:
  /// **'세트별 기록:'**
  String get setRecords;

  /// 세트별 목표 횟수 표시
  ///
  /// In ko, this message translates to:
  /// **'{setIndex}세트: {reps}개'**
  String setRepFormat(int reps, int setIndex);

  /// 세트 수 및 횟수 표시 형식
  ///
  /// In ko, this message translates to:
  /// **'세트 × 횟수'**
  String get setRepsDisplayFormat;

  /// 세트/횟수 형식
  ///
  /// In ko, this message translates to:
  /// **'{setIndex}세트: {reps}개'**
  String setRepsFormat(int reps, int setIndex);

  /// 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// 설정 배너 광고 텍스트
  ///
  /// In ko, this message translates to:
  /// **'나만의 설정을 맞춤화해! ⚙️'**
  String get settingsBannerText;

  /// 설정 저장 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'설정 저장에 실패했다'**
  String get settingsSaveFailed;

  /// 설정 저장 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'설정이 저장되었다'**
  String get settingsSaved;

  /// 설정 화면 부제목
  ///
  /// In ko, this message translates to:
  /// **'당신의 여정을 커스터마이즈해'**
  String get settingsSubtitle;

  /// 설정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'⚙️ 설정'**
  String get settingsTitle;

  /// 7일 연속 챌린지 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔄 7일 연속 챌린지 시작! 하루라도 빠지면 처음부터! 🚀'**
  String get sevenDayStreak;

  /// Seven days exercise description
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 연습'**
  String get sevenDaysExercise;

  /// 운동 결과 공유 버튼
  ///
  /// In ko, this message translates to:
  /// **'공유하기'**
  String get shareWorkout;

  /// No description provided for @singleSessionChallenge.
  ///
  /// In ko, this message translates to:
  /// **'단일 세션 챌린지'**
  String get singleSessionChallenge;

  /// Skip rest button text
  ///
  /// In ko, this message translates to:
  /// **'휴식 건너뛰기'**
  String get skipRest;

  /// 휴식 건너뛰기 버튼
  ///
  /// In ko, this message translates to:
  /// **'휴식? 약자나 해라, 만삣삐! 다음 희생양 가져와!'**
  String get skipRestButton;

  /// 사운드 설정
  ///
  /// In ko, this message translates to:
  /// **'사운드 설정'**
  String get soundSettings;

  /// 사운드 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'운동 피드백음 활성화'**
  String get soundSettingsDesc;

  /// 첫 자각몽 연습 시작 메시지
  ///
  /// In ko, this message translates to:
  /// **'첫 자각몽 연습을 시작하고\\n나만의 전설을 만들어보자! 🔥'**
  String get startFirstWorkout;

  /// 새 자각몽 연습 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'새 자각몽 연습 시작'**
  String get startNewWorkout;

  /// 오늘 자각몽 연습 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'🚀 오늘의 DOMINATION 시작! 🚀'**
  String get startTodayWorkout;

  /// 자각몽 연습 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 시작'**
  String get startWorkout;

  /// 연속 일수 형식
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String streakDays(int days);

  /// 연속 자각몽 연습 알림 설정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'연속 연습 격려 알림이 설정되었다!'**
  String get streakNotificationSet;

  /// 설정 저장 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ ALPHA SETTINGS LOCKED! 완벽한 설정으로 무장 완료! ⚡'**
  String get successSettingsSaved;

  /// 자각몽 연습 완료 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'🚀 WORKOUT DOMINATION COMPLETE! 또 하나의 LEGENDARY ACHIEVEMENT 달성! 🚀'**
  String get successWorkoutCompleted;

  /// No description provided for @sundayFull.
  ///
  /// In ko, this message translates to:
  /// **'일요일'**
  String get sundayFull;

  /// Sunday short form
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get sundayShort;

  /// 목표 횟수 표시
  ///
  /// In ko, this message translates to:
  /// **'목표: {count}회'**
  String targetRepsLabel(int count);

  /// 테마 변경 적용 안내
  ///
  /// In ko, this message translates to:
  /// **'테마 변경은 앱 재시작 후 적용된다'**
  String get themeChangeAfterRestart;

  /// 테마 변경 재시작 안내
  ///
  /// In ko, this message translates to:
  /// **'테마 변경은 앱 재시작 후 적용된다'**
  String get themeChangeRestart;

  /// 테마 및 언어 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'테마 및 언어 설정'**
  String get themeLanguageSettings;

  /// 이번 달 자각몽 연습 횟수
  ///
  /// In ko, this message translates to:
  /// **'이번 달 자각몽 연습'**
  String get thisMonthWorkouts;

  /// 이번 주 진행률 표시
  ///
  /// In ko, this message translates to:
  /// **'이번 주 ({current}주차)'**
  String thisWeekProgress(int current);

  /// No description provided for @thursdayFull.
  ///
  /// In ko, this message translates to:
  /// **'목요일'**
  String get thursdayFull;

  /// Thursday short form
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get thursdayShort;

  /// 오늘의 목표 제목
  ///
  /// In ko, this message translates to:
  /// **'오늘의 목표'**
  String get todayGoalTitle;

  /// Today's mission
  ///
  /// In ko, this message translates to:
  /// **'오늘의 미션'**
  String get todayMission;

  /// 오늘의 미션 제목
  ///
  /// In ko, this message translates to:
  /// **'오늘의 미션'**
  String get todayMissionTitle;

  /// Today's target label
  ///
  /// In ko, this message translates to:
  /// **'오늘의 목표:'**
  String get todayTarget;

  /// 오늘 자각몽 연습 완료 축하 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎉 오늘 자각몽 연습 완료! 🎉'**
  String get todayWorkoutCompleted;

  /// 오늘의 운동 불가 메시지
  ///
  /// In ko, this message translates to:
  /// **'오늘의 운동을 불러올 수 없다'**
  String get todayWorkoutNotAvailable;

  /// 오늘의 목표 제목
  ///
  /// In ko, this message translates to:
  /// **'오늘의 목표'**
  String get todaysGoal;

  /// 총 완료 횟수
  ///
  /// In ko, this message translates to:
  /// **'총 완료 횟수: {reps}회'**
  String totalCompletedReps(int reps);

  /// 총 횟수 형식
  ///
  /// In ko, this message translates to:
  /// **'{totalReps}개'**
  String totalRepsFormat(int totalReps);

  /// 총 자각몽 연습 횟수
  ///
  /// In ko, this message translates to:
  /// **'총 자각몽 연습 횟수'**
  String get totalWorkouts;

  /// 영상 설명 3
  ///
  /// In ko, this message translates to:
  /// **'진정한 드림 스피릿가 되는 마인드셋'**
  String get trueChadMindset;

  /// No description provided for @tuesdayFull.
  ///
  /// In ko, this message translates to:
  /// **'화요일'**
  String get tuesdayFull;

  /// Tuesday short form
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get tuesdayShort;

  /// 진동 설정
  ///
  /// In ko, this message translates to:
  /// **'진동 설정'**
  String get vibrationSettings;

  /// 진동 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'진동 피드백 활성화'**
  String get vibrationSettingsDesc;

  /// 승리의 요일 선택 섹션
  ///
  /// In ko, this message translates to:
  /// **'💪 승리의 요일 선택'**
  String get victoryDaySelection;

  /// No description provided for @wednesdayFull.
  ///
  /// In ko, this message translates to:
  /// **'수요일'**
  String get wednesdayFull;

  /// Wednesday short form
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get wednesdayShort;

  /// Week 1 completed requirement
  ///
  /// In ko, this message translates to:
  /// **'1주차 완료'**
  String get week1Completed;

  /// Week 2 completed requirement
  ///
  /// In ko, this message translates to:
  /// **'2주차 완료'**
  String get week2Completed;

  /// Week 3 completed requirement
  ///
  /// In ko, this message translates to:
  /// **'3주차 완료'**
  String get week3Completed;

  /// Week 4 completed requirement
  ///
  /// In ko, this message translates to:
  /// **'4주차 완료'**
  String get week4Completed;

  /// Week 5 completed requirement
  ///
  /// In ko, this message translates to:
  /// **'5주차 완료'**
  String get week5Completed;

  /// Week 6 completed requirement
  ///
  /// In ko, this message translates to:
  /// **'14주차 완료'**
  String get week6Completed;

  /// Week completed label
  ///
  /// In ko, this message translates to:
  /// **'주차'**
  String get weekCompleted;

  /// 주차 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'주차 완료! 축하드립니다!'**
  String get weekCompletedMessage;

  /// 주차/일차 형식
  ///
  /// In ko, this message translates to:
  /// **'{week}주차 {day}일차'**
  String weekDayFormat(int day, int week);

  /// 전체 프로그램 진행률
  ///
  /// In ko, this message translates to:
  /// **'{current}/{total} 주차'**
  String weekProgress(int current, int total);

  /// No description provided for @weekUnit.
  ///
  /// In ko, this message translates to:
  /// **'주'**
  String get weekUnit;

  /// Week number format
  ///
  /// In ko, this message translates to:
  /// **'{week}주차'**
  String weekX(int week);

  /// 직장인 드림 스피릿 모드 설명
  ///
  /// In ko, this message translates to:
  /// **'주말엔 휴식, 평일엔 무적! 💪'**
  String get weekendRestWeekdayInvincible;

  /// 주간 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'주간'**
  String get weekly;

  /// Weekly challenge achievement
  ///
  /// In ko, this message translates to:
  /// **'일주일 챌린지'**
  String get weeklyChallenge;

  /// Weekly challenge achievement description
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 연습'**
  String get weeklyChallengeDesc;

  /// Weekly details title
  ///
  /// In ko, this message translates to:
  /// **'주차별 상세'**
  String get weeklyDetails;

  /// Weekly goal label
  ///
  /// In ko, this message translates to:
  /// **'주간 목표'**
  String get weeklyGoal;

  /// Weekly growth chart title
  ///
  /// In ko, this message translates to:
  /// **'주간 성장 차트'**
  String get weeklyGrowthChart;

  /// Weekly performance title
  ///
  /// In ko, this message translates to:
  /// **'주간별 성과'**
  String get weeklyPerformance;

  /// 주간 리포트 타이틀
  ///
  /// In ko, this message translates to:
  /// **'📊 주간 리포트 📊'**
  String get weeklyReport;

  /// 요일별 자각몽 연습 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'요일별 자각몽 연습 시간 설정'**
  String get weeklyWorkoutSchedule;

  /// 완료된 주차 수
  ///
  /// In ko, this message translates to:
  /// **'{completed}/{total} 주 완료'**
  String weeksCompleted(int completed, int total);

  /// 진화까지 남은 주차
  ///
  /// In ko, this message translates to:
  /// **'{weeks}주 남음'**
  String weeksRemaining(int weeks);

  /// 운동 버튼 라벨
  ///
  /// In ko, this message translates to:
  /// **'운동'**
  String get workout;

  /// 운동 목표 달성
  ///
  /// In ko, this message translates to:
  /// **'달성'**
  String get workoutAchieved;

  /// 운동 이미 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'오늘의 운동은 이미 완료했다! 💪'**
  String get workoutAlreadyCompleted;

  /// 자각몽 연습 리마인더 자동 갱신 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 리마인더가 자동으로 갱신되었다. 계속해서 건강한 운동 습관을 유지해! 💪'**
  String get workoutAutoRenewalBody;

  /// 자각몽 연습 리마인더 자동 갱신 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'⏰ 자각몽 연습 리마인더 자동 갱신'**
  String get workoutAutoRenewalTitle;

  /// 일반 세트 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'이 세트를 정복하라, 만삣삐!'**
  String get workoutButtonConquer;

  /// 마지막 세트 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'궁극의 승리 차지하라!'**
  String get workoutButtonUltimate;

  /// Workout calendar title
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 캘린더'**
  String get workoutCalendar;

  /// 운동 차트 제목
  ///
  /// In ko, this message translates to:
  /// **'운동 차트'**
  String get workoutChart;

  /// 자각몽 연습 완료 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'레전드다, 만삣삐!'**
  String get workoutCompleteButton;

  /// 자각몽 연습 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'{title} 완전 파괴!\n총 파워 해방: {totalReps}회! 해냈다! ⚡'**
  String workoutCompleteMessage(String title, int totalReps);

  /// 자각몽 연습 완료 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 굿 잡, 만삣삐! 야수 모드 완료! 👑'**
  String get workoutCompleteTitle;

  /// 자각몽 연습 완료 상태
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get workoutCompleted;

  /// 운동 완룀 축하 알림 채널 설명
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 완료 축하 알림'**
  String get workoutCompletionChannelDescription;

  /// 자각몽 연습 완료 성취 메시지
  ///
  /// In ko, this message translates to:
  /// **'목표의 {percentage}% 파괴! 강자의 길을 걷고 있다! KEEP GRINDING! 🔥💪'**
  String workoutCompletionMessage(int percentage);

  /// 운동 횟수 형식
  ///
  /// In ko, this message translates to:
  /// **'{count}회'**
  String workoutCount(int count);

  /// Workout date format
  ///
  /// In ko, this message translates to:
  /// **'{month}월 {day}일 자각몽 연습'**
  String workoutDate(int day, int month);

  /// Workout day notification
  ///
  /// In ko, this message translates to:
  /// **'연습일 전용 알림'**
  String get workoutDayNotification;

  /// Workout day selection title
  ///
  /// In ko, this message translates to:
  /// **'운동 요일 선택'**
  String get workoutDaySelection;

  /// 연습일 전용 모드 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'💪 연습일 전용 알림 모드 활성화! 월,수,금에만 알림이 옵니다!'**
  String get workoutDaysModeActivated;

  /// 연습일 전용 알림 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 연습일 전용 알림'**
  String get workoutDaysOnlyNotifications;

  /// 연습일 전용 알림 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'매일이 아닌 연습일(월,수,금)에만 알림을 받다. 휴식일엔 방해받지 않아요!'**
  String get workoutDaysOnlyNotificationsDesc;

  /// 운동 상세 정보
  ///
  /// In ko, this message translates to:
  /// **'운동: {title}\\n완료된 세트: {sets}개\\n총 횟수: {reps}회'**
  String workoutDetailsWithStats(int reps, int sets, String title);

  /// 자각몽 연습 기록 로딩 실패 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 기록을 불러오는 중 오류가 발생했다: {error}'**
  String workoutHistoryLoadError(String error);

  /// 운동 중단 발견 경고
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 운동 중단 발견'**
  String get workoutInterruptionDetected;

  /// No description provided for @workoutNotificationPermission.
  ///
  /// In ko, this message translates to:
  /// **'🔔 자각몽 연습 알림 권한'**
  String get workoutNotificationPermission;

  /// 운동 주의사항
  ///
  /// In ko, this message translates to:
  /// **'• 최소 하루는 쉬는 날이 있어야 한다\n• 연속으로 6일 이상 자각몽 연습할 수 없다\n• 충분한 휴식은 근육 성장에 필수이다'**
  String get workoutPrecautions;

  /// 자각몽 연습 완료 처리 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 완료 처리 중...'**
  String get workoutProcessing;

  /// 선택된 날짜의 자각몽 연습 기록
  ///
  /// In ko, this message translates to:
  /// **'{month}/{day} 자각몽 연습 기록'**
  String workoutRecordForDate(int day, int month);

  /// 자각몽 연습 기록 및 통계 항목
  ///
  /// In ko, this message translates to:
  /// **'• 자각몽 연습 기록 및 통계'**
  String get workoutRecordsStats;

  /// 자각몽 연습 리마인더 설정
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 리마인더'**
  String get workoutReminder;

  /// 기본 자각몽 연습 리마인더 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'💪 LUCID DREAM 100 운동 시간! LEGENDARY MODE 활성화! 💪'**
  String get workoutReminderDefaultBody;

  /// 자각몽 연습 리마인더 비활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 리마인더가 비활성화되었다'**
  String get workoutReminderDisabled;

  /// 자각몽 연습 리마인더 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 리마인더가 활성화되었다'**
  String get workoutReminderEnabled;

  /// 자각몽 연습 리마인더 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 리마인더 설정'**
  String get workoutReminderSettings;

  /// 자각몽 연습 리마인더 옵션
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 리마인더'**
  String get workoutReminders;

  /// 자각몽 연습 리마인더 알림 채널 설명
  ///
  /// In ko, this message translates to:
  /// **'요일별 자각몽 연습 알림'**
  String get workoutRemindersChannelDescription;

  /// 자각몽 연습 리마인더 설명
  ///
  /// In ko, this message translates to:
  /// **'💀 매일 너를 깨워서 운동시켜줄 거야! 도망갈 생각 마라!'**
  String get workoutRemindersDesc;

  /// 운동 저장 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'운동 저장 중 오류가 발생했다.'**
  String get workoutSaveError;

  /// 운동 화면 광고 대체 메시지
  ///
  /// In ko, this message translates to:
  /// **'나만의 힘을 느껴라! 💪'**
  String get workoutScreenAdMessage;

  /// 운동 설정 섹션
  ///
  /// In ko, this message translates to:
  /// **'💪 자각몽 연습 설정'**
  String get workoutSettings;

  /// 자각몽 연습 시작 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ ALPHA SYSTEM ERROR! 재시도하라, 만삣삐: {error} ⚡'**
  String workoutStartError(String error);

  /// 자각몽 연습 시작 액션 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 시작! 🔥'**
  String get workoutStartMessage;

  /// 운동 시간 통계 제목
  ///
  /// In ko, this message translates to:
  /// **'운동 시간'**
  String get workoutTime;

  /// 운동 팁 제목
  ///
  /// In ko, this message translates to:
  /// **'운동 팁'**
  String get workoutTips;

  /// 운동 팁 내용
  ///
  /// In ko, this message translates to:
  /// **'• 운동 전후 충분한 스트레칭을 해\\n• 정확한 자세가 횟수보다 중요한다\\n• 꾸준함이 가장 중요한 성공 요소이다'**
  String get workoutTipsContent;

  /// 운동 제목 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'💪 전쟁터 💪'**
  String get workoutTitle;

  /// No description provided for @exitWorkout.
  ///
  /// In ko, this message translates to:
  /// **'운동 종료'**
  String get exitWorkout;

  /// No description provided for @exitWorkoutConfirm.
  ///
  /// In ko, this message translates to:
  /// **'운동을 종료하시겠습니까? 진행 상황이 저장되지 않습니다.'**
  String get exitWorkoutConfirm;

  /// No description provided for @selectMinimum3Days.
  ///
  /// In ko, this message translates to:
  /// **'최소 3일은 선택해야 합니다! 💪'**
  String get selectMinimum3Days;

  /// No description provided for @championNeedsConsistency.
  ///
  /// In ko, this message translates to:
  /// **'진정한 챔피언은 일관성이 필요해!\n\n주 3일 이상은 운동해야 진짜 변화가 일어나!\n\n더 선택하고 다시 시도하라! 💪'**
  String get championNeedsConsistency;

  /// Schedule setup complete message with session count
  ///
  /// In ko, this message translates to:
  /// **'🎉 스케줄 설정 완료!\n\n{sessionsCreated}개의 운동 세션이 생성되었다!\nLET\'S GO! 💪🔥'**
  String scheduleSetupComplete(int sessionsCreated);

  /// Schedule setup error message
  ///
  /// In ko, this message translates to:
  /// **'스케줄 설정 중 오류 발생:\n{error}'**
  String scheduleSetupError(String error);

  /// No description provided for @workoutScheduleSetup.
  ///
  /// In ko, this message translates to:
  /// **'운동 스케줄 설정'**
  String get workoutScheduleSetup;

  /// No description provided for @setYourWorkoutSchedule.
  ///
  /// In ko, this message translates to:
  /// **'🔥 운동 스케줄을 설정하세요!'**
  String get setYourWorkoutSchedule;

  /// No description provided for @startTheJourney.
  ///
  /// In ko, this message translates to:
  /// **'여정 시작하기! 🚀'**
  String get startTheJourney;

  /// No description provided for @workoutCompleteSimple.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 완료!'**
  String get workoutCompleteSimple;

  /// No description provided for @workoutCompleteGreatJob.
  ///
  /// In ko, this message translates to:
  /// **'훌륭합니다! 오늘의 운동을 완료했습니다.'**
  String get workoutCompleteGreatJob;

  /// Total reps count message
  ///
  /// In ko, this message translates to:
  /// **'총 횟수: {count}개'**
  String totalRepsCount(int count);

  /// No description provided for @letsStartWorkout.
  ///
  /// In ko, this message translates to:
  /// **'💪 자각몽 연습을 시작합니다! 화이팅!'**
  String get letsStartWorkout;

  /// No description provided for @processingCompletion.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 완료 처리 중...'**
  String get processingCompletion;

  /// No description provided for @cannotShowCompletionDialog.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 완료 화면을 표시할 수 없습니다. 홈으로 돌아갑니다.'**
  String get cannotShowCompletionDialog;

  /// No description provided for @exitWorkoutSaved.
  ///
  /// In ko, this message translates to:
  /// **'정말로 운동을 종료하시겠습니까? 진행률이 저장됩니다.'**
  String get exitWorkoutSaved;

  /// No description provided for @exit.
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get exit;

  /// Data reset error message
  ///
  /// In ko, this message translates to:
  /// **'데이터 초기화 중 오류가 발생했습니다: {error}'**
  String dataResetError(String error);

  /// No description provided for @dataResetProgress.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 초기화하는 중...'**
  String get dataResetProgress;

  /// No description provided for @dataResetSuccess.
  ///
  /// In ko, this message translates to:
  /// **'모든 데이터가 성공적으로 초기화되었습니다'**
  String get dataResetSuccess;

  /// No description provided for @dataResetWarning.
  ///
  /// In ko, this message translates to:
  /// **'다음 데이터가 완전히 삭제됩니다:'**
  String get dataResetWarning;

  /// No description provided for @dataRestoreConfirm.
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 데이터 복원'**
  String get dataRestoreConfirm;

  /// No description provided for @dataRestoreError.
  ///
  /// In ko, this message translates to:
  /// **'데이터 복원에 실패했습니다. 백업 파일을 확인해주세요.'**
  String get dataRestoreError;

  /// No description provided for @dataRestoreProgress.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 복원하는 중...'**
  String get dataRestoreProgress;

  /// No description provided for @dataRestoreSuccess.
  ///
  /// In ko, this message translates to:
  /// **'데이터 복원이 완료되었습니다! 앱을 재시작해주세요.'**
  String get dataRestoreSuccess;

  /// No description provided for @durationDays.
  ///
  /// In ko, this message translates to:
  /// **'기간'**
  String get durationDays;

  /// Reps and completion percentage
  ///
  /// In ko, this message translates to:
  /// **'{reps}회 • {percentage}% 완료'**
  String repsAndCompletion(int reps, int percentage);

  /// No description provided for @restoreButton.
  ///
  /// In ko, this message translates to:
  /// **'복원'**
  String get restoreButton;

  /// No description provided for @chadBecameStronger.
  ///
  /// In ko, this message translates to:
  /// **'✨ Dream Spirit가 성장했습니다'**
  String get chadBecameStronger;

  /// No description provided for @repsDestroyed.
  ///
  /// In ko, this message translates to:
  /// **'✓ 완료한 태스크'**
  String get repsDestroyed;

  /// No description provided for @xpGained.
  ///
  /// In ko, this message translates to:
  /// **'⭐ 획득 경험치'**
  String get xpGained;

  /// No description provided for @timeElapsed.
  ///
  /// In ko, this message translates to:
  /// **'⏱️ 소요 시간'**
  String get timeElapsed;

  /// No description provided for @workoutDestroyed.
  ///
  /// In ko, this message translates to:
  /// **'🌙 오늘의 연습 완료! ✨'**
  String get workoutDestroyed;

  /// No description provided for @workoutDestroyedMessage.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 자각몽 연습을 성공적으로 마쳤습니다'**
  String get workoutDestroyedMessage;

  /// No description provided for @timeDestroyed.
  ///
  /// In ko, this message translates to:
  /// **'⏱️ 연습 시간'**
  String get timeDestroyed;

  /// No description provided for @tomorrowIsRestDay.
  ///
  /// In ko, this message translates to:
  /// **'🌙 내일도 꿈의 여정이 계속됩니다 ✨'**
  String get tomorrowIsRestDay;

  /// No description provided for @recoverToBeStronger.
  ///
  /// In ko, this message translates to:
  /// **'😴 오늘 밤 좋은 꿈 꾸세요 ✨'**
  String get recoverToBeStronger;

  /// No description provided for @tomorrowBeastMode.
  ///
  /// In ko, this message translates to:
  /// **'✨ 내일도 함께 자각몽을 연습해요 🌙'**
  String get tomorrowBeastMode;

  /// No description provided for @legendaryJourneyContinues.
  ///
  /// In ko, this message translates to:
  /// **'🌟 자각몽 마스터로의 여정은 계속됩니다 🌟'**
  String get legendaryJourneyContinues;

  /// No description provided for @chadEvolutionProgress.
  ///
  /// In ko, this message translates to:
  /// **'✨ Dream Spirit 성장 진행률'**
  String get chadEvolutionProgress;

  /// Dream journal task title
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 작성'**
  String get taskDreamJournalTitle;

  /// Dream journal task description
  ///
  /// In ko, this message translates to:
  /// **'매일 아침 기상 직후 꿈을 기록하세요. 꿈 회상 능력은 자각몽의 첫걸음입니다.'**
  String get taskDreamJournalDesc;

  /// Reality check task title
  ///
  /// In ko, this message translates to:
  /// **'현실 확인 (Reality Check)'**
  String get taskRealityCheckTitle;

  /// Reality check task description
  ///
  /// In ko, this message translates to:
  /// **'하루 5회 이상 손바닥을 보며 \"지금 꿈인가?\"를 자문하세요. 손가락을 꿰뚫어보는 연습도 좋습니다.'**
  String get taskRealityCheckDesc;

  /// MILD affirmation task title
  ///
  /// In ko, this message translates to:
  /// **'MILD 확언'**
  String get taskMildTitle;

  /// MILD affirmation task description
  ///
  /// In ko, this message translates to:
  /// **'취침 전 \"다음 꿈에서 나는 깨어있을 것이다\"를 반복하며 자각몽 의도를 확고히 하세요.'**
  String get taskMildDesc;

  /// Sleep hygiene task title
  ///
  /// In ko, this message translates to:
  /// **'수면 위생 체크'**
  String get taskSleepHygieneTitle;

  /// Sleep hygiene task description
  ///
  /// In ko, this message translates to:
  /// **'규칙적인 수면 시간, 어두운 방, 카페인 제한 등 양질의 수면을 위한 환경을 조성하세요.'**
  String get taskSleepHygieneDesc;

  /// WBTB task title
  ///
  /// In ko, this message translates to:
  /// **'WBTB (Wake Back To Bed)'**
  String get taskWbtbTitle;

  /// WBTB task description
  ///
  /// In ko, this message translates to:
  /// **'5시간 수면 후 알람으로 깨어나 20-30분 각성 상태 유지 후 다시 잠들어 REM 수면 진입을 유도하세요.'**
  String get taskWbtbDesc;

  /// Meditation task title
  ///
  /// In ko, this message translates to:
  /// **'명상 (선택)'**
  String get taskMeditationTitle;

  /// Meditation task description
  ///
  /// In ko, this message translates to:
  /// **'10분 이상 마음챙김 명상으로 자각 능력을 키우세요. 자각몽에 큰 도움이 됩니다.'**
  String get taskMeditationDesc;

  /// Quiz question 3
  ///
  /// In ko, this message translates to:
  /// **'초보자에게 가장 적합한 자각몽 기법은?'**
  String get beginnerPushupQuiz;

  /// Step 3 title - bottom position
  ///
  /// In ko, this message translates to:
  /// **'최하점 자세'**
  String get bottomPosition;

  /// Step 3 description
  ///
  /// In ko, this message translates to:
  /// **'가슴이 바닥에 거의 닿는 최하점에서 잠시 정지한다.'**
  String get bottomPositionDesc;

  /// 호흡법 카테고리
  ///
  /// In ko, this message translates to:
  /// **'호흡법'**
  String get breathingTechnique;

  /// Subtitle for pushup form guide
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿이 알려주는 완벽한 자각몽 기법! 💪'**
  String get chadPerfectPushupForm;

  /// 완료된 운동 표시
  ///
  /// In ko, this message translates to:
  /// **'완료: {totalReps}개 / {totalSets}세트'**
  String completedFormat(int totalReps, int totalSets);

  /// Header for 5-step pushup guide
  ///
  /// In ko, this message translates to:
  /// **'올바른 자각몽 기법 5단계'**
  String get correctPushupForm5Steps;

  /// 영상 설명 1
  ///
  /// In ko, this message translates to:
  /// **'올바른 자각몽 기법으로 효과적인 연습'**
  String get correctPushupFormDesc;

  /// Quiz question 1
  ///
  /// In ko, this message translates to:
  /// **'올바른 자각몽 연습 시작 시 중요한 것은?'**
  String get correctPushupQuiz1;

  /// Excellent performance message
  ///
  /// In ko, this message translates to:
  /// **'🚀 EXCELLENT! 완벽한 실행! 🚀'**
  String get excellentPerformance;

  /// Step 5 title - finish position
  ///
  /// In ko, this message translates to:
  /// **'완료 자세'**
  String get finishPosition;

  /// Step 5 description
  ///
  /// In ko, this message translates to:
  /// **'시작 자세로 완전히 돌아와 다음 반복을 준비한다.'**
  String get finishPositionDesc;

  /// 목표 운동 표시
  ///
  /// In ko, this message translates to:
  /// **'목표: {totalReps}개 / {totalSets}세트'**
  String goalFormat(int totalReps, int totalSets);

  /// Good performance message
  ///
  /// In ko, this message translates to:
  /// **'💪 GOOD! 잘하고 있다! 💪'**
  String get goodPerformance;

  /// Hundred pushups achievement
  ///
  /// In ko, this message translates to:
  /// **'자각몽 100일'**
  String get hundredPushups;

  /// Hundred pushups achievement description
  ///
  /// In ko, this message translates to:
  /// **'100일 연속 자각몽 연습 달성'**
  String get hundredPushupsDesc;

  /// 완벽 자세 챌린지 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎯 완벽 자세 챌린지 활성화! 대충하면 안 된다! 💪'**
  String get perfectFormChallenge;

  /// Title for pushup form guide screen
  ///
  /// In ko, this message translates to:
  /// **'완벽한 자각몽 기법'**
  String get perfectPushupForm;

  /// 목표 100% 달성시 메시지
  ///
  /// In ko, this message translates to:
  /// **'🚀 ABSOLUTE PERFECTION! 신을 넘어선 ULTRA GOD EMPEROR 탄생! 👑'**
  String get performanceGodTier;

  /// 목표 50% 이상 달성시 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ GOOD! 약함이 도망치고 있다. ALPHA STORM이 몰려온다, 만삣삐! ⚡'**
  String get performanceMedium;

  /// 기본 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥 할 수 있어? 당연하지! 이제 세상을 정복하러 가자, 만삣삐! 🔥'**
  String get performanceMotivation;

  /// 운동 시작시 메시지
  ///
  /// In ko, this message translates to:
  /// **'💥 시작이 반? 틀렸다! 이미 전설의 문이 열렸다, YOU FUTURE EMPEROR! 💥'**
  String get performanceStart;

  /// 목표 80% 이상 달성시 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔱 철봉이 무릎꿇는다고? 이제 중력이 너에게 항복한다! LEGENDARY BEAST! 🔱'**
  String get performanceStrong;

  /// 영상 제목 4
  ///
  /// In ko, this message translates to:
  /// **'자각몽 100일 도전 🎯'**
  String get pushup100Challenge;

  /// 푸시업 100개 연속 달성 메시지
  ///
  /// In ko, this message translates to:
  /// **'💪💀 자각몽 100일 연속 달성! 인간 초월! 💀💪'**
  String get pushup100Streak;

  /// 아처 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'SSILD 기법'**
  String get pushupArcher;

  /// 아처 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 감각 집중 능력 강화\\n• 시청각촉각 균형 발달\\n• 고급 자각몽 준비\\n• 안정적인 꿈 진입'**
  String get pushupArcherBenefits;

  /// 아처 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'사이클 돌듯 집중해서 호흡해라. 정확성이 생명이다, you idiot!'**
  String get pushupArcherBreathing;

  /// 아처 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'🏹 정확한 사이클이 자각몽 지름길? 맞다! 감각 마스터하면 LEGENDARY LUCID EMPEROR! 🏹'**
  String get pushupArcherChad;

  /// 아처 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'감각씩 집중하는 고급 기술! 균형감각과 집중력이 필요하다, 만삣삐!'**
  String get pushupArcherDesc;

  /// 아처 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 눈 감고 시각에 주의\\n2. 청각 자극에 집중\\n3. 촉각 감각 느끼기\\n4. 4-6회 빠른 사이클\\n5. 양쪽을 번갈아가며, 만삣삐!'**
  String get pushupArcherInstructions;

  /// 아처 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 너무 강하게 집중\\n• 한 감각에만 치우침\\n• 사이클이 불규칙\\n• 조급하게 진행'**
  String get pushupArcherMistakes;

  /// 아처 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'SSILD 기법'**
  String get pushupArcherName;

  /// Quiz question 4
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 시 올바른 호흡법은?'**
  String get pushupBreathingQuiz;

  /// 박수 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'FILD 기법'**
  String get pushupClap;

  /// 박수 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 빠른 꿈 진입 능력\\n• 손가락 집중력 향상\\n• 즉각적인 자각몽\\n• 진짜 마스터의 증명'**
  String get pushupClapBenefits;

  /// 박수 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'깨어날 때 깊게 호흡하고, 손가락 움직임에 집중. 리듬이 중요하다, you idiot!'**
  String get pushupClapBreathing;

  /// 박수 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'👏 손가락 기법이 빠른 진입? 맞다! 이제 EXPLOSIVE LUCID ENTRY의 표현이다! 👏'**
  String get pushupClapChad;

  /// 박수 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'손가락 움직이며 하는 빠른 진입! 진짜 마스터만이 할 수 있다!'**
  String get pushupClapDesc;

  /// 박수 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 알람 후 움직이지 말고\\n2. 손가락을 살짝 움직여라\\n3. 피아노 치듯 교대로\\n4. 꿈 장면이 나타날 때까지\\n5. 연속으로 도전해라, 만삣삐!'**
  String get pushupClapInstructions;

  /// 박수 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 너무 강하게 움직이기\\n• 완전히 깨버리기\\n• 리듬이 불규칙\\n• 조급하게 포기하기'**
  String get pushupClapMistakes;

  /// 박수 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'FILD 기법'**
  String get pushupClapName;

  /// 디클라인 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'꿈 신호 인식'**
  String get pushupDecline;

  /// 디클라인 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 꿈 패턴 파악 능력 강화\\n• 자각몽 트리거 발견\\n• 인식 속도 최대 강화\\n• 전체 자각몽 능력 향상'**
  String get pushupDeclineBenefits;

  /// 디클라인 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'무의식과 싸우면서도 안정된 관찰을 유지해라. 진짜 파워는 여기서 나온다, you idiot!'**
  String get pushupDeclineBreathing;

  /// 디클라인 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'🌪️ 꿈 신호 따위 개무시? 당연하지! 이제 꿈 세계를 지배하라! 신호 인식으로 GODLIKE AWARENESS! 🌪️'**
  String get pushupDeclineChad;

  /// 디클라인 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'관찰력을 높게 올려서 인식 향상! 꿈 신호를 제대로 포착한다!'**
  String get pushupDeclineDesc;

  /// 디클라인 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 꿈 일기에서 반복 요소 찾기\\n2. 개인 꿈 신호 목록 작성\\n3. 현실에서 그 신호 주시하기\\n4. 신호 발견 시 현실 확인\\n5. 꿈에서 신호 인식하라, 만삣삐!'**
  String get pushupDeclineInstructions;

  /// 디클라인 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 신호를 대충 관찰\\n• 패턴을 무시하기\\n• 일기 분석 안 하기\\n• 꿈에서 신호 놓치기'**
  String get pushupDeclineMistakes;

  /// 디클라인 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'꿈 신호 인식'**
  String get pushupDeclineName;

  /// 다이아몬드 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'WBTB 기법'**
  String get pushupDiamond;

  /// 다이아몬드 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 자각몽 확률 극대화\\n• REM 수면 활용\\n• 의식 명료함 강화\\n• 꿈 컨트롤 능력 증가'**
  String get pushupDiamondBenefits;

  /// 다이아몬드 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'집중해서 호흡해라. 의식이 깨어나는 걸 느껴라, you idiot!'**
  String get pushupDiamondBreathing;

  /// 다이아몬드 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'💎 다이아몬드보다 빛나는 의식? 틀렸다! 이제 UNBREAKABLE LUCID MIND다! 한 번만 성공해도 진짜 BEAST 인정! 💎'**
  String get pushupDiamondChad;

  /// 다이아몬드 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'REM 수면 집중 공략! WBTB가 진짜 마스터의 상징이다!'**
  String get pushupDiamondDesc;

  /// 다이아몬드 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 5-6시간 자고 깨어나라\\n2. 20-30분 깨어있어라\\n3. 자각몽에 집중하며 읽기\\n4. 다시 잠들 때 의도 유지\\n5. REM 수면으로 진입하라, 만삣삐!'**
  String get pushupDiamondInstructions;

  /// 다이아몬드 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 너무 오래 깨어있기\\n• 완전히 잠 깨버리기\\n• 의도 없이 다시 자기\\n• 타이밍이 부정확함'**
  String get pushupDiamondMistakes;

  /// 다이아몬드 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'WBTB 기법'**
  String get pushupDiamondName;

  /// 팔굽혀펴기 해시태그
  ///
  /// In ko, this message translates to:
  /// **'#자각몽'**
  String get pushupHashtag;

  /// 인클라인 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'수면 위생'**
  String get pushupIncline;

  /// 인클라인 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 수면 질 향상\\n• 꿈 선명도 강화\\n• 자각몽 성공률 증가\\n• 모든 기법의 기초 다지기'**
  String get pushupInclineBenefits;

  /// 인클라인 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'잠들기 전 호흡도 편안하게. 하지만 규칙성은 최고로, you idiot!'**
  String get pushupInclineBreathing;

  /// 인클라인 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'🚀 환경은 조절하고 수면은 MAX! 완벽한 수면 루틴이면 GOD TIER 입장권 획득이다, 만삣삐! 🚀'**
  String get pushupInclineChad;

  /// 인클라인 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'수면 환경을 이용해서 꿈 품질 향상! 조용하고 어둡게만 해도 충분하다, 만삣삐!'**
  String get pushupInclineDesc;

  /// 인클라인 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 규칙적인 수면 시간 정해라\\n2. 침실을 어둡고 시원하게\\n3. 잠들기 2시간 전 전자기기 끄기\\n4. 편안한 침구 준비\\n5. 점차 완벽한 환경 만들어라!'**
  String get pushupInclineInstructions;

  /// 인클라인 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 불규칙한 수면 시간\\n• 밝은 침실에서 자기\\n• 자기 직전 스마트폰 보기\\n• 너무 급하게 변화 시도'**
  String get pushupInclineMistakes;

  /// 인클라인 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'수면 위생'**
  String get pushupInclineName;

  /// 무릎 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'현실 확인'**
  String get pushupKnee;

  /// 무릎 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 꿈과 현실 구분 능력 향상\\n• 자각몽 인식 훈련\\n• 의식 명료함 강화\\n• 자각몽으로의 단계적 진입'**
  String get pushupKneeBenefits;

  /// 무릎 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'부드럽고 꾸준한 호흡으로 시작해라. 급하게 하지 마라, 만삣삐!'**
  String get pushupKneeBreathing;

  /// 무릎 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'⚡ 시작이 반? 아니다! 이미 ALPHA JOURNEY가 시작됐다! 현실 확인도 EMPEROR의 길이다! ⚡'**
  String get pushupKneeChad;

  /// 무릎 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'입문자도 할 수 있다! 하루 10번 현실 확인 부끄러워하지 마라, 만삣삐!'**
  String get pushupKneeDesc;

  /// 무릎 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 하루에 10번 이상 체크하라\\n2. 손을 자세히 관찰하라\\n3. \'지금 꿈인가?\' 진지하게 물어라\\n4. 주변 환경이 이상한지 확인\\n5. 천천히 확실하게 검증하라, 만삣삐!'**
  String get pushupKneeInstructions;

  /// 무릎 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 대충 형식적으로 체크하기\\n• 하루에 너무 적게 하기\\n• 진지하게 의심하지 않기\\n• 너무 빠르게 지나가기'**
  String get pushupKneeMistakes;

  /// 무릎 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'현실 확인'**
  String get pushupKneeName;

  /// Quiz question 2
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 중 가장 흔한 실수는?'**
  String get pushupMistakeQuiz;

  /// 원핸드 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'고급 WILD'**
  String get pushupOneArm;

  /// 원핸드 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 궁극의 의식 제어\\n• 완벽한 꿈 컨트롤\\n• 전체 자각몽 마스터\\n• 기가 마스터 완성'**
  String get pushupOneArmBenefits;

  /// 원핸드 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'깊고 안정된 호흡으로 집중력을 최고조로. 모든 의식을 하나로, you idiot!'**
  String get pushupOneArmBreathing;

  /// 원핸드 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'🚀 고급 WILD는 마스터 완성형? 틀렸다! 이제 ULTIMATE APEX LUCID GOD 탄생이다, FXXK YEAH! 🚀'**
  String get pushupOneArmChad;

  /// 원핸드 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'고급 WILD는 자각몽의 완성형이다! 이거 한 번이라도 성공하면 진짜 기가 마스터 인정!'**
  String get pushupOneArmDesc;

  /// 원핸드 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 명상과 WILD를 결합\\n2. 환각을 적극 활용\\n3. 의식에 모든 힘을 집중\\n4. 천천히 확실하게\\n5. 기가 마스터 자격을 증명하라!'**
  String get pushupOneArmInstructions;

  /// 원핸드 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 기초가 부족한 상태로 시도\\n• 긴장으로 몸이 굳어짐\\n• 조급하게 진입 시도\\n• 무리한 도전으로 좌절'**
  String get pushupOneArmMistakes;

  /// 원핸드 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'고급 WILD'**
  String get pushupOneArmName;

  /// 파이크 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'WILD 기법'**
  String get pushupPike;

  /// 파이크 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 의식 유지 능력 강화\\n• 직접 꿈 진입 마스터\\n• 극한 집중력 발달\\n• 깊은 자각몽 경험'**
  String get pushupPikeBenefits;

  /// 파이크 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'수면 마비 중에도 안정된 호흡. 의식에 집중해라, you idiot!'**
  String get pushupPikeBreathing;

  /// 파이크 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'⚡ WILD 마스터하면 자유자재? 당연하지! 의식 EMPEROR로 진화하라, 만삣삐! ⚡'**
  String get pushupPikeChad;

  /// 파이크 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'의식 집중 공략! 고급 자각몽의 핵심 기법이다!'**
  String get pushupPikeDesc;

  /// 파이크 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 편안하게 누워 긴장 풀기\\n2. 호흡에 집중하라\\n3. 몸이 잠들게 두되 의식 유지\\n4. 환각 증상을 관찰\\n5. 꿈으로 직접 진입하라, 만삣삐!'**
  String get pushupPikeInstructions;

  /// 파이크 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 너무 긴장해서 잠 못 자기\\n• 의식을 잃어버리기\\n• 수면 마비에 당황하기\\n• 조급하게 포기하기'**
  String get pushupPikeMistakes;

  /// 파이크 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'WILD 기법'**
  String get pushupPikeName;

  /// 기본 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기'**
  String get pushupStandard;

  /// 기본 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 꿈 기억력 향상\\n• 꿈 패턴 인식 능력 강화\\n• 자각몽 빈도 증가\\n• 모든 자각몽 기법의 기초!'**
  String get pushupStandardBenefits;

  /// 기본 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'자기 전 깊게 호흡하며 이완해라. 평온한 마음이 명확한 꿈을 부른다, 만삣삐!'**
  String get pushupStandardBreathing;

  /// 표준 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'🔥 꿈 일기가 제일 중요하다! 매일 쓰면 꿈 세계를 정복한다, 만삣삐! MASTER THE BASICS! 🔥'**
  String get pushupStandardChad;

  /// 기본 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'모든 자각몽의 시작점. 완벽한 꿈 일기가 진짜 마스터를 만든다, 만삣삐!'**
  String get pushupStandardDesc;

  /// 기본 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 잠에서 깨자마자 기록해라, 만삣삐\\n2. 모든 세부사항을 포착하라\\n3. 감정과 색깔도 기록하라\\n4. 꿈 신호를 찾아내라\\n5. 매일 꾸준히 실천하라, 드림 스피릿답게!'**
  String get pushupStandardInstructions;

  /// 기본 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 나중에 쓰겠다고 미루기\\n• 세부사항을 대충 쓰기\\n• 불규칙하게 기록하기\\n• 감정을 무시하기\\n• 너무 빨리 포기하기, fxxk idiot!'**
  String get pushupStandardMistakes;

  /// 기본 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기'**
  String get pushupStandardName;

  /// 푸시업 튜토리얼 화면 부제목
  ///
  /// In ko, this message translates to:
  /// **'진짜 꿈 마스터들은 기법부터 다르다! 💪'**
  String get pushupTutorialSubtitle;

  /// 푸시업 튜토리얼 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿 자각몽 도장'**
  String get pushupTutorialTitle;

  /// 영상 제목 2
  ///
  /// In ko, this message translates to:
  /// **'자각몽 기법 다양화 🔥'**
  String get pushupVariations;

  /// Variations section header
  ///
  /// In ko, this message translates to:
  /// **'난이도별 자각몽 기법'**
  String get pushupVariationsByDifficulty;

  /// 와이드 그립 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'MILD 기법'**
  String get pushupWideGrip;

  /// 와이드 그립 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 자각몽 의도 강화\\n• 꿈 인식 능력 향상\\n• 성공률 극대화\\n• 전체적인 자각몽 능력 발달'**
  String get pushupWideGripBenefits;

  /// 와이드 그립 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'깊은 호흡으로 의도를 각인시켜라. 의식이 확장되는 걸 느껴라, you idiot!'**
  String get pushupWideGripBreathing;

  /// 와이드 그립 푸시업 드림 스피릿 조언
  ///
  /// In ko, this message translates to:
  /// **'🦁 강한 의도? 아니다! 이제 LEGENDARY LUCID MASTER를 만들어라! MILD로 꿈 세계를 압도하라! 🦁'**
  String get pushupWideGripChad;

  /// 와이드 그립 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'의도를 강하게 세워서 자각몽 확률을 더 높게! 진짜 마스터가 되어라!'**
  String get pushupWideGripDesc;

  /// 와이드 그립 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 잠들기 전 \'꿈에서 깨어난다\' 반복\\n2. 최근 꿈을 회상하라\\n3. 자각몽이 되는 순간 상상\\n4. 강한 의도를 유지\\n5. 확신을 가지고 잠들어라, 만삣삐!'**
  String get pushupWideGripInstructions;

  /// 와이드 그립 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 의도가 너무 약함\\n• 대충 형식적으로 반복\\n• 상상이 구체적이지 않음\\n• 확신이 부족함'**
  String get pushupWideGripMistakes;

  /// 와이드 그립 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'MILD 기법'**
  String get pushupWideGripName;

  /// 푸시업 개수 형식
  ///
  /// In ko, this message translates to:
  /// **'{count}회'**
  String pushupsCount(int count);

  /// 푸시업 레이블
  ///
  /// In ko, this message translates to:
  /// **'💪 자각몽 기법'**
  String get pushupsLabel;

  /// 운동 결과 표시 형식
  ///
  /// In ko, this message translates to:
  /// **'전설 등급: {reps}회 ({percentage}%) 🏆'**
  String resultFormat(int percentage, int reps);

  /// Step 1 title - start position
  ///
  /// In ko, this message translates to:
  /// **'시작 자세'**
  String get startPosition;

  /// Step 1 description
  ///
  /// In ko, this message translates to:
  /// **'플랭크 자세로 시작하여 손과 발의 위치를 정확히 설정한다.'**
  String get startPositionDesc;

  /// 횟수 형식
  ///
  /// In ko, this message translates to:
  /// **'{times}회'**
  String timesFormat(int times);

  /// Total workout format
  ///
  /// In ko, this message translates to:
  /// **'총 {reps}회 ({sets}세트)'**
  String totalFormat(int reps, int sets);

  /// Total pushups label
  ///
  /// In ko, this message translates to:
  /// **'총 자각몽 연습'**
  String get totalPushups;

  /// 자세 튜토리얼 조언
  ///
  /// In ko, this message translates to:
  /// **'완벽한 기법이 완벽한 드림 스피릿을 만든다!'**
  String get tutorialAdviceForm;

  /// Tab title for variation exercises
  ///
  /// In ko, this message translates to:
  /// **'변형\n운동'**
  String get variationExercises;

  /// 영상 설명 2
  ///
  /// In ko, this message translates to:
  /// **'다양한 자각몽 기법으로 의식 자극'**
  String get variousPushupStimulation;

  /// No description provided for @watchVideo.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상 보기'**
  String get watchVideo;

  /// No description provided for @specialPushupForChads.
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿을 위한 특별한 자각몽 기법'**
  String get specialPushupForChads;

  /// No description provided for @chadPerfectFormGuide.
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿의 완벽한 자각몽 기법 가이드! 💪'**
  String get chadPerfectFormGuide;

  /// No description provided for @formGuideAdvancedLevel.
  ///
  /// In ko, this message translates to:
  /// **'고급'**
  String get formGuideAdvancedLevel;

  /// No description provided for @formGuideBeginnerLevel.
  ///
  /// In ko, this message translates to:
  /// **'초급'**
  String get formGuideBeginnerLevel;

  /// No description provided for @formGuideCategoryBreathing.
  ///
  /// In ko, this message translates to:
  /// **'호흡'**
  String get formGuideCategoryBreathing;

  /// No description provided for @formGuideCategoryMotivation.
  ///
  /// In ko, this message translates to:
  /// **'동기부여'**
  String get formGuideCategoryMotivation;

  /// No description provided for @formGuideCategoryRecovery.
  ///
  /// In ko, this message translates to:
  /// **'회복'**
  String get formGuideCategoryRecovery;

  /// No description provided for @formGuideIntermediateLevel.
  ///
  /// In ko, this message translates to:
  /// **'중급'**
  String get formGuideIntermediateLevel;

  /// No description provided for @perfectPerformance.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 수행!'**
  String get perfectPerformance;

  /// No description provided for @keyPoints.
  ///
  /// In ko, this message translates to:
  /// **'주요 포인트:'**
  String get keyPoints;

  /// No description provided for @swipeToView.
  ///
  /// In ko, this message translates to:
  /// **'좌우로 스와이프하세요'**
  String get swipeToView;

  /// No description provided for @imageLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'이미지 로드 실패'**
  String get imageLoadFailed;

  /// No description provided for @switchToSwipeView.
  ///
  /// In ko, this message translates to:
  /// **'스와이프 보기로 전환'**
  String get switchToSwipeView;

  /// No description provided for @swipeViewHint.
  ///
  /// In ko, this message translates to:
  /// **'단계별 가이드를 스와이프 형태로 표시합니다'**
  String get swipeViewHint;

  /// Tab title for perfect form guide (combines steps + tips)
  ///
  /// In ko, this message translates to:
  /// **'완벽한\n자세'**
  String get perfectFormGuide;

  /// 컨디션 재체크 가능 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'컨디션을 다시 체크할 수 있어요!'**
  String get canRecheckCondition;

  /// 컨디션 확인 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'Chad가 {condition} 컨디션을 확인했어요!'**
  String chadConfirmedCondition(String condition);

  /// 수면모자 Chad 이름
  ///
  /// In ko, this message translates to:
  /// **'수면모자'**
  String get chadSleepyCap;

  /// 수면모자 Chad 설명
  ///
  /// In ko, this message translates to:
  /// **'여정을 시작하는 단계다.\n아직 잠이 덜 깼지만 곧 깨어날 거야! 😴'**
  String get chadSleepyCapDesc;

  /// 수면모자 드림 스피릿 타이틀
  ///
  /// In ko, this message translates to:
  /// **'수면모자'**
  String get chadTitleSleepy;

  /// 근육 생리학 카테고리
  ///
  /// In ko, this message translates to:
  /// **'근육 생리학'**
  String get factCategoryMuscle;

  /// No description provided for @muscleIcon.
  ///
  /// In ko, this message translates to:
  /// **'💪'**
  String get muscleIcon;

  /// 컨디션 재체크 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'컨디션 다시 체크'**
  String get recheckCondition;

  /// 회복 카테고리
  ///
  /// In ko, this message translates to:
  /// **'회복'**
  String get recovery;

  /// 회복 레벨 - 최고
  ///
  /// In ko, this message translates to:
  /// **'최고'**
  String get recoveryLevelExcellent;

  /// 회복 레벨 - 보통
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get recoveryLevelFair;

  /// 회복 레벨 - 좋음
  ///
  /// In ko, this message translates to:
  /// **'좋음'**
  String get recoveryLevelGood;

  /// 회복 레벨 - 휴식 필요
  ///
  /// In ko, this message translates to:
  /// **'휴식필요'**
  String get recoveryLevelPoor;

  /// 전략적 드림 스피릿 모드 설명
  ///
  /// In ko, this message translates to:
  /// **'과학적 근육 회복 + 지속가능한 파워! 🧠💪'**
  String get scientificRecovery;

  /// 수면모자 드림 스피릿 진화 상태
  ///
  /// In ko, this message translates to:
  /// **'수면모자 진화'**
  String get sleepyChadEvolution;

  /// Sleepy hat chad name
  ///
  /// In ko, this message translates to:
  /// **'수면모자'**
  String get sleepyHatChad;

  /// 타겟 근육 - 가슴
  ///
  /// In ko, this message translates to:
  /// **'가슴'**
  String get targetMuscleChest;

  /// 타겟 근육 - 코어
  ///
  /// In ko, this message translates to:
  /// **'코어'**
  String get targetMuscleCore;

  /// 타겟 근육 - 전신
  ///
  /// In ko, this message translates to:
  /// **'전신'**
  String get targetMuscleFull;

  /// 타겟 근육 - 어깨
  ///
  /// In ko, this message translates to:
  /// **'어깨'**
  String get targetMuscleShoulders;

  /// 타겟 근육 - 삼두근
  ///
  /// In ko, this message translates to:
  /// **'삼두근'**
  String get targetMuscleTriceps;

  /// No description provided for @backupHistory.
  ///
  /// In ko, this message translates to:
  /// **'백업 기록'**
  String get backupHistory;

  /// Best record label
  ///
  /// In ko, this message translates to:
  /// **'최고 기록'**
  String get bestRecord;

  /// 챌린지 진행 중 상태
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get challengeInProgress;

  /// Challenge progress
  ///
  /// In ko, this message translates to:
  /// **'진행률: {progress}%'**
  String challengeProgress(int progress);

  /// 현재 레벨 및 진행률 항목
  ///
  /// In ko, this message translates to:
  /// **'• 현재 레벨 및 진행률'**
  String get currentLevelProgress;

  /// 현재 연속 운동일
  ///
  /// In ko, this message translates to:
  /// **'현재 연속'**
  String get currentStreak;

  /// 일일 정복 기록 타이틀
  ///
  /// In ko, this message translates to:
  /// **'🔥💀 일일 정복 기록 💀🔥'**
  String get dailyConquestRecord;

  /// Experience progress
  ///
  /// In ko, this message translates to:
  /// **'{current} / {required} XP'**
  String expProgress(int current, int required);

  /// In progress status
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get inProgress;

  /// Maximum level reached
  ///
  /// In ko, this message translates to:
  /// **'레벨 {currentLevel} (최대)'**
  String levelProgressMax(int currentLevel);

  /// Current level to next level
  ///
  /// In ko, this message translates to:
  /// **'레벨 {currentLevel} → {nextLevel}'**
  String levelProgressNext(int currentLevel, int nextLevel);

  /// 통계 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'나만의 통계를 불러오는 중...'**
  String get loadingStatistics;

  /// No description provided for @loginToSaveProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행 상황을 저장하려면 로그인하세요'**
  String get loginToSaveProgress;

  /// 월간 진행률 제목
  ///
  /// In ko, this message translates to:
  /// **'월간 진행률'**
  String get monthlyProgress;

  /// 백업 기록이 없을 때 제목
  ///
  /// In ko, this message translates to:
  /// **'백업 기록 없음'**
  String get noBackupRecord;

  /// 차트 데이터가 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'차트 데이터가 없다'**
  String get noChartData;

  /// 파이 차트 데이터가 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'파이 차트 데이터가 없다'**
  String get noPieChartData;

  /// Overall progress label
  ///
  /// In ko, this message translates to:
  /// **'전체 진행률'**
  String get overallProgress;

  /// Overall statistics title
  ///
  /// In ko, this message translates to:
  /// **'전체통계'**
  String get overallStatistics;

  /// Overall statistics label
  ///
  /// In ko, this message translates to:
  /// **'전체 통계'**
  String get overallStats;

  /// Personal records title
  ///
  /// In ko, this message translates to:
  /// **'개인 기록'**
  String get personalRecords;

  /// 진행도 라벨 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'🚀 전설 달성률 🚀'**
  String get progressLabel;

  /// Progress tracking title
  ///
  /// In ko, this message translates to:
  /// **'진행률 추적'**
  String get progressTracking;

  /// Progress visualization section title
  ///
  /// In ko, this message translates to:
  /// **'진행률 시각화'**
  String get progressVisualization;

  /// 통계 탭
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get statistics;

  /// No description provided for @statusInProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get statusInProgress;

  /// 연속 운동 중단 메시지
  ///
  /// In ko, this message translates to:
  /// **'연속 연습이 끊어졌다'**
  String get streakBrokenMessage;

  /// No description provided for @streakChallenge.
  ///
  /// In ko, this message translates to:
  /// **'연속 일수 챌린지'**
  String get streakChallenge;

  /// 연속 운동 지속 메시지
  ///
  /// In ko, this message translates to:
  /// **'연속 연습 계속 중!'**
  String get streakContinueMessage;

  /// 연속 운동 격려 설정
  ///
  /// In ko, this message translates to:
  /// **'연속 연습 격려'**
  String get streakEncouragement;

  /// 연속 운동 격려 설정 부제목
  ///
  /// In ko, this message translates to:
  /// **'3일 연속 연습 시 격려 메시지'**
  String get streakEncouragementSubtitle;

  /// 연속 운동 진행률 라벨
  ///
  /// In ko, this message translates to:
  /// **'연속 연습 진행률'**
  String get streakProgress;

  /// 연속 운동 시작 메시지
  ///
  /// In ko, this message translates to:
  /// **'연속 연습 시작!'**
  String get streakStartMessage;

  /// No description provided for @loadingProgramData.
  ///
  /// In ko, this message translates to:
  /// **'프로그램 데이터를 불러오는 중...'**
  String get loadingProgramData;

  /// No description provided for @startWorkoutToStartProgram.
  ///
  /// In ko, this message translates to:
  /// **'연습을 시작하여 프로그램을 시작하세요! 💪'**
  String get startWorkoutToStartProgram;

  /// No description provided for @progressShownAfterWorkout.
  ///
  /// In ko, this message translates to:
  /// **'연습을 시작하면 진행률이 표시됩니다'**
  String get progressShownAfterWorkout;

  /// No description provided for @overallProgramProgress.
  ///
  /// In ko, this message translates to:
  /// **'전체 프로그램 진행도'**
  String get overallProgramProgress;

  /// Format for weeks progress
  ///
  /// In ko, this message translates to:
  /// **'{current}/{total} 주차'**
  String weeksFormat(int current, int total);

  /// Format for this week label
  ///
  /// In ko, this message translates to:
  /// **'이번 주 ({week}주차)'**
  String thisWeekFormat(int week);

  /// No description provided for @daysCompleted.
  ///
  /// In ko, this message translates to:
  /// **'일 완료'**
  String get daysCompleted;

  /// No description provided for @totalSessions.
  ///
  /// In ko, this message translates to:
  /// **'총 연습 세션'**
  String get totalSessions;

  /// No description provided for @dataBackupProgress.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 백업하는 중...'**
  String get dataBackupProgress;

  /// No description provided for @inProgressStatus.
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get inProgressStatus;

  /// No description provided for @optionPersonalRecordDesc.
  ///
  /// In ko, this message translates to:
  /// **'개인 목표 달성과 기록 향상에 집중합니다'**
  String get optionPersonalRecordDesc;

  /// No description provided for @optionPersonalRecordTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인 기록'**
  String get optionPersonalRecordTitle;

  /// No description provided for @progressText.
  ///
  /// In ko, this message translates to:
  /// **'진행도'**
  String get progressText;

  /// No description provided for @statisticsBannerText.
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿 성장을 확인하라! 📊'**
  String get statisticsBannerText;

  /// No description provided for @progressLoadingError.
  ///
  /// In ko, this message translates to:
  /// **'진행률 데이터 로드 실패'**
  String get progressLoadingError;

  /// No description provided for @progressRepsUnit.
  ///
  /// In ko, this message translates to:
  /// **'{count} 회'**
  String progressRepsUnit(Object count);

  /// No description provided for @progressWeekNumber.
  ///
  /// In ko, this message translates to:
  /// **'{week}주차'**
  String progressWeekNumber(Object week);

  /// No description provided for @progressDateWorkout.
  ///
  /// In ko, this message translates to:
  /// **'날짜: {date}'**
  String progressDateWorkout(Object date);

  /// No description provided for @progressNoWorkoutThisDay.
  ///
  /// In ko, this message translates to:
  /// **'휴식일'**
  String get progressNoWorkoutThisDay;

  /// No description provided for @progressWeekDaySession.
  ///
  /// In ko, this message translates to:
  /// **'{week}주차, {day}일차'**
  String progressWeekDaySession(Object day, Object week);

  /// No description provided for @progressSetsUnit.
  ///
  /// In ko, this message translates to:
  /// **'{count} 세트'**
  String progressSetsUnit(Object count);

  /// No description provided for @progressSetRecordLabel.
  ///
  /// In ko, this message translates to:
  /// **'세트 기록'**
  String get progressSetRecordLabel;

  /// No description provided for @progressSetNumber.
  ///
  /// In ko, this message translates to:
  /// **'{number}세트'**
  String progressSetNumber(Object number);

  /// No description provided for @progressChadEvolutionStage.
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿 진화'**
  String get progressChadEvolutionStage;

  /// No description provided for @progressChadLevel.
  ///
  /// In ko, this message translates to:
  /// **'레벨 {level}'**
  String progressChadLevel(Object level);

  /// No description provided for @progressEvolvingToGigaChad.
  ///
  /// In ko, this message translates to:
  /// **'기가 드림 스피릿으로 진화 중!'**
  String get progressEvolvingToGigaChad;

  /// No description provided for @progressNextLevelRemaining.
  ///
  /// In ko, this message translates to:
  /// **'다음 레벨까지 {remaining} XP'**
  String progressNextLevelRemaining(Object remaining);

  /// No description provided for @progressViewAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 보기'**
  String get progressViewAll;

  /// No description provided for @progressRepsCompleted.
  ///
  /// In ko, this message translates to:
  /// **'{reps} 회 완료'**
  String progressRepsCompleted(Object reps);

  /// No description provided for @progressPersonalRecords.
  ///
  /// In ko, this message translates to:
  /// **'개인 기록'**
  String get progressPersonalRecords;

  /// No description provided for @progressBestRecord.
  ///
  /// In ko, this message translates to:
  /// **'최고 기록'**
  String get progressBestRecord;

  /// No description provided for @progressBestWeek.
  ///
  /// In ko, this message translates to:
  /// **'최고의 주'**
  String get progressBestWeek;

  /// No description provided for @progressConsecutiveDays.
  ///
  /// In ko, this message translates to:
  /// **'연속 일수'**
  String get progressConsecutiveDays;

  /// No description provided for @progressDaysUnit.
  ///
  /// In ko, this message translates to:
  /// **'{count} 일'**
  String progressDaysUnit(Object count);

  /// No description provided for @progressAverageScore.
  ///
  /// In ko, this message translates to:
  /// **'평균 점수'**
  String get progressAverageScore;

  /// No description provided for @progressAchievementFirstStep.
  ///
  /// In ko, this message translates to:
  /// **'첫 발걸음'**
  String get progressAchievementFirstStep;

  /// No description provided for @progressAchievementFirstStepDesc.
  ///
  /// In ko, this message translates to:
  /// **'첫 훈련 세션 완료'**
  String get progressAchievementFirstStepDesc;

  /// No description provided for @progressAchievementHundredPushups.
  ///
  /// In ko, this message translates to:
  /// **'백 개 마크'**
  String get progressAchievementHundredPushups;

  /// No description provided for @progressAchievementHundredPushupsDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 세션에서 푸쉬업 100개 완료'**
  String get progressAchievementHundredPushupsDesc;

  /// No description provided for @progressAchievementPerfectionist.
  ///
  /// In ko, this message translates to:
  /// **'완벽주의자'**
  String get progressAchievementPerfectionist;

  /// No description provided for @progressAchievementPerfectionistDesc.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 자세로 모든 세트 완료'**
  String get progressAchievementPerfectionistDesc;

  /// No description provided for @progressAchievementWeekChallenge.
  ///
  /// In ko, this message translates to:
  /// **'주간 워리어'**
  String get progressAchievementWeekChallenge;

  /// No description provided for @progressAchievementWeekChallengeDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 주의 모든 운동 완료'**
  String get progressAchievementWeekChallengeDesc;

  /// No description provided for @progressCurrentChadStatus.
  ///
  /// In ko, this message translates to:
  /// **'현재 상태'**
  String get progressCurrentChadStatus;

  /// No description provided for @progressMaxLevelAchieved.
  ///
  /// In ko, this message translates to:
  /// **'최대 레벨 달성!'**
  String get progressMaxLevelAchieved;

  /// No description provided for @progressNextLevel.
  ///
  /// In ko, this message translates to:
  /// **'다음 레벨: {title}'**
  String progressNextLevel(Object title);

  /// No description provided for @progressNoData.
  ///
  /// In ko, this message translates to:
  /// **'데이터 없음'**
  String get progressNoData;

  /// No description provided for @progressPercentComplete.
  ///
  /// In ko, this message translates to:
  /// **'{percent}% 완료'**
  String progressPercentComplete(Object percent);

  /// No description provided for @progressRequirementProgramStart.
  ///
  /// In ko, this message translates to:
  /// **'프로그램 시작'**
  String get progressRequirementProgramStart;

  /// No description provided for @progressRequirementWeek1.
  ///
  /// In ko, this message translates to:
  /// **'1주차 완료'**
  String get progressRequirementWeek1;

  /// No description provided for @progressRequirementWeek2.
  ///
  /// In ko, this message translates to:
  /// **'2주차 완료'**
  String get progressRequirementWeek2;

  /// No description provided for @progressRequirementWeek3.
  ///
  /// In ko, this message translates to:
  /// **'3주차 완료'**
  String get progressRequirementWeek3;

  /// No description provided for @progressRequirementWeek4.
  ///
  /// In ko, this message translates to:
  /// **'4주차 완료'**
  String get progressRequirementWeek4;

  /// No description provided for @progressRequirementWeek5.
  ///
  /// In ko, this message translates to:
  /// **'5주차 완료'**
  String get progressRequirementWeek5;

  /// No description provided for @progressRequirementWeek6.
  ///
  /// In ko, this message translates to:
  /// **'6주차 완료'**
  String get progressRequirementWeek6;

  /// No description provided for @progressScoreUnit.
  ///
  /// In ko, this message translates to:
  /// **'{score} 점'**
  String progressScoreUnit(Object score);

  /// No description provided for @progressTooltipWeekComplete.
  ///
  /// In ko, this message translates to:
  /// **'{week}주차: {completionRate}% 완료\\n{completedSessions}/{totalSessions} 세션'**
  String progressTooltipWeekComplete(Object completedSessions,
      Object completionRate, Object totalSessions, Object week);

  /// Advanced level label
  ///
  /// In ko, this message translates to:
  /// **'고급자'**
  String get advancedLevel;

  /// 고급자 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'궁극의 드림 스피릿'**
  String get alphaLevelDescription;

  /// 고급 레벨 부제목
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 11일 이상 - 이미 드림 스피릿 자질'**
  String get alphaLevelSubtitle;

  /// 고급자 레벨 제목
  ///
  /// In ko, this message translates to:
  /// **'고급자'**
  String get alphaLevelTitle;

  /// Beginner level label
  ///
  /// In ko, this message translates to:
  /// **'초급자'**
  String get beginnerLevel;

  /// 초급자 모드 표시
  ///
  /// In ko, this message translates to:
  /// **'초급자 모드'**
  String get beginnerMode;

  /// Variations section subtitle
  ///
  /// In ko, this message translates to:
  /// **'초보자부터 드림 스피릿까지! 단계별로 도전해보자! 🚀'**
  String get beginnerToChad;

  /// 드림 스피릿 레벨 라벨
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿 레벨'**
  String get chadLevel;

  /// 자각몽 상급 난이도
  ///
  /// In ko, this message translates to:
  /// **'드림 스피릿 - 강력한 기가들'**
  String get difficultyAdvanced;

  /// 자각몽 초급 난이도
  ///
  /// In ko, this message translates to:
  /// **'푸시 - 시작하는 만삣삐들'**
  String get difficultyBeginner;

  /// 자각몽 중급 난이도
  ///
  /// In ko, this message translates to:
  /// **'알파 지망생 - 성장하는 드림 스피릿들'**
  String get difficultyIntermediate;

  /// Intermediate level label
  ///
  /// In ko, this message translates to:
  /// **'중급자'**
  String get intermediateLevel;

  /// No description provided for @legendaryChadModeUpgrade.
  ///
  /// In ko, this message translates to:
  /// **'⚡ LEGENDARY MODE 업그레이드! ⚡'**
  String get legendaryChadModeUpgrade;

  /// 고급 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'👑 상당한 실력을 갖춘 ALPHA EMPEROR다.\n이미 많은 LEGENDARY ACHIEVEMENTS를 이루었어, 만삣삐! 👑'**
  String get levelDescAlpha;

  /// 최고급 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'🚀 최고 수준의 ULTRA GIGA 단계다.\n놀라운 GODLIKE POWER를 가지고 있어! 🚀'**
  String get levelDescGiga;

  /// 중급 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'⚡ 기본기를 갖춘 상승하는 ALPHA 단계다.\n더 높은 목표를 향해 DOMINATING 중이야! ⚡'**
  String get levelDescRising;

  /// 초급 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'🔥 ROOKIE 단계. 자각몽 제국의 시작점.\n각성의 여정이 시작되었다. 🔥'**
  String get levelDescRookie;

  /// 고급 목표 메시지
  ///
  /// In ko, this message translates to:
  /// **'👑 목표: 완벽한 폼으로 100개 PERFECT EXECUTION! 👑'**
  String get levelGoalAlpha;

  /// 최고급 목표 메시지
  ///
  /// In ko, this message translates to:
  /// **'🚀 목표: ULTIMATE MASTER로 UNIVERSE DOMINATION! 🚀'**
  String get levelGoalGiga;

  /// 중급 목표 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 목표: 더 강한 ALPHA로 LEGENDARY EVOLUTION! ⚡'**
  String get levelGoalRising;

  /// 초급 목표 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥 목표: 30일 만에 자각몽 마스터 ABSOLUTE DOMINATION! 🔥'**
  String get levelGoalRookie;

  /// 레벨 레이블
  ///
  /// In ko, this message translates to:
  /// **'🏆 레벨'**
  String get levelLabel;

  /// 고급 격려 메시지
  ///
  /// In ko, this message translates to:
  /// **'👑 OUTSTANDING PERFORMANCE다!\n100개 목표까지 DOMINATE하라, FXXK LIMITS! 👑'**
  String get levelMotivationAlpha;

  /// 최고급 격려 메시지
  ///
  /// In ko, this message translates to:
  /// **'🚀 이미 강력한 GIGA 단계군!\n완벽한 100개를 향해 CONQUER THE UNIVERSE! 🚀'**
  String get levelMotivationGiga;

  /// 중급 격려 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ EXCELLENT START다!\n더 강한 ALPHA BEAST가 되어라, 만삣삐! ⚡'**
  String get levelMotivationRising;

  /// 초급 격려 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥 모든 EMPEROR는 여기서 시작한다!\n30일 후 MIND-BLOWING TRANSFORMATION을 경험하라, 만삣삐! 🔥'**
  String get levelMotivationRookie;

  /// 고급 드림 스피릿 이름
  ///
  /// In ko, this message translates to:
  /// **'Alpha'**
  String get levelNameAlpha;

  /// 최고급 드림 스피릿 이름
  ///
  /// In ko, this message translates to:
  /// **'기가 드림 스피릿'**
  String get levelNameGiga;

  /// 중급 드림 스피릿 이름
  ///
  /// In ko, this message translates to:
  /// **'Rising'**
  String get levelNameRising;

  /// 초급 드림 스피릿 이름
  ///
  /// In ko, this message translates to:
  /// **'Rookie'**
  String get levelNameRookie;

  /// 레벨 선택 설명
  ///
  /// In ko, this message translates to:
  /// **'현재 자각몽 연습 경험에 맞는 레벨을 선택해라!\n30일 만에 자각몽 마스터를 위한 맞춤 프로그램이 제공된다!'**
  String get levelSelectionDescription;

  /// 레벨 선택 헤더
  ///
  /// In ko, this message translates to:
  /// **'🏋️‍♂️ 너의 레벨을 선택해라, 만삣삐!'**
  String get levelSelectionHeader;

  /// 레벨 선택 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'💪 레벨 체크'**
  String get levelSelectionTitle;

  /// Maximum level achieved message
  ///
  /// In ko, this message translates to:
  /// **'최고 레벨 달성!'**
  String get maxLevelAchieved;

  /// 새로운 드림 스피릿 등급 텍스트
  ///
  /// In ko, this message translates to:
  /// **'새로운 드림 스피릿 등급'**
  String get newChadLevel;

  /// Progress to next level label
  ///
  /// In ko, this message translates to:
  /// **'다음 레벨까지'**
  String get nextLevel;

  /// Next level progress message
  ///
  /// In ko, this message translates to:
  /// **'다음 레벨까지 30% 남음'**
  String get nextLevelIn;

  /// 중급자 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'성장하는 드림 스피릿'**
  String get risingLevelDescription;

  /// 중급 레벨 부제목
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 6-10일 - 드림 스피릿로 성장 중'**
  String get risingLevelSubtitle;

  /// 중급자 레벨 제목
  ///
  /// In ko, this message translates to:
  /// **'중급자'**
  String get risingLevelTitle;

  /// 초보자 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'천천히 시작하는 드림 스피릿'**
  String get rookieLevelDescription;

  /// 초급 레벨 부제목
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 6일 미만 - 기초부터 차근차근'**
  String get rookieLevelSubtitle;

  /// 초보자 레벨 제목
  ///
  /// In ko, this message translates to:
  /// **'초보자'**
  String get rookieLevelTitle;

  /// 레벨 선택 요청 버튼
  ///
  /// In ko, this message translates to:
  /// **'🔥 레벨을 선택하라, FUTURE EMPEROR! 🔥'**
  String get selectLevelButton;

  /// 선택한 레벨로 시작하기 버튼
  ///
  /// In ko, this message translates to:
  /// **'💥 {level}로 EMPEROR JOURNEY 시작! 💥'**
  String startWithLevel(String level);

  /// No description provided for @levelAndExperience.
  ///
  /// In ko, this message translates to:
  /// **'레벨 & 경험치'**
  String get levelAndExperience;

  /// No description provided for @avgExpPerDay.
  ///
  /// In ko, this message translates to:
  /// **'일평균 경험치'**
  String get avgExpPerDay;

  /// No description provided for @levelUps.
  ///
  /// In ko, this message translates to:
  /// **'레벨업 횟수'**
  String get levelUps;

  /// Number of level ups
  ///
  /// In ko, this message translates to:
  /// **'{count}회'**
  String levelUpsCount(int count);

  /// No description provided for @rookieGoalDesc.
  ///
  /// In ko, this message translates to:
  /// **'5일 이하 → 30일 마스터 달성'**
  String get rookieGoalDesc;

  /// No description provided for @risingGoalDesc.
  ///
  /// In ko, this message translates to:
  /// **'6-10일 → 30일 마스터 달성'**
  String get risingGoalDesc;

  /// No description provided for @alphaGoalDesc.
  ///
  /// In ko, this message translates to:
  /// **'11-20일 → 30일 마스터 달성'**
  String get alphaGoalDesc;

  /// No description provided for @gigaGoalDesc.
  ///
  /// In ko, this message translates to:
  /// **'21일 이상 → 30일+ 마스터 달성'**
  String get gigaGoalDesc;

  /// No description provided for @difficultyAdvancedDesc.
  ///
  /// In ko, this message translates to:
  /// **'진정한 드림 스피릿'**
  String get difficultyAdvancedDesc;

  /// No description provided for @difficultyBeginnerDesc.
  ///
  /// In ko, this message translates to:
  /// **'천천히 시작하는 드림 스피릿'**
  String get difficultyBeginnerDesc;

  /// No description provided for @difficultyIntermediateDesc.
  ///
  /// In ko, this message translates to:
  /// **'꾸준한 드림 스피릿'**
  String get difficultyIntermediateDesc;

  /// Level up title
  ///
  /// In ko, this message translates to:
  /// **'레벨 업'**
  String get levelUp;

  /// Double congratulations message
  ///
  /// In ko, this message translates to:
  /// **'진심으로 축하해'**
  String get doubleCongratulations;

  /// 레벨업 메시지
  ///
  /// In ko, this message translates to:
  /// **'{emoji}💥 LEVEL UP! 한계 박살! 💥{emoji}'**
  String levelUpMessage(String emoji);

  /// Multiple level up message
  ///
  /// In ko, this message translates to:
  /// **'{levels}레벨이나 올랐어!'**
  String levelUpMultipleMessage(int levels);

  /// Days remaining to next level
  ///
  /// In ko, this message translates to:
  /// **'다음 레벨까지 약 {days}일 남음'**
  String daysToNextLevel(int days);

  /// No description provided for @achievementAllRounderDesc.
  ///
  /// In ko, this message translates to:
  /// **'모든 자각몽 체크리스트 타입을 시도했다'**
  String get achievementAllRounderDesc;

  /// No description provided for @achievementAllRounderMotivation.
  ///
  /// In ko, this message translates to:
  /// **'모든 타입 마스터! 올라운더 드림 스피릿! 🌈'**
  String get achievementAllRounderMotivation;

  /// No description provided for @achievementAllRounderTitle.
  ///
  /// In ko, this message translates to:
  /// **'올라운더'**
  String get achievementAllRounderTitle;

  /// 목표 초과 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'야수 모드'**
  String get achievementBeastMode;

  /// 목표 초과 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'목표를 150% 초과 달성하다'**
  String get achievementBeastModeDesc;

  /// 업적 달성 축하 다이얼로그 메시지
  ///
  /// In ko, this message translates to:
  /// **'나만의 힘을 느꼈다! 💪'**
  String get achievementCelebrationMessage;

  /// 100일 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'센츄리온'**
  String get achievementCenturion;

  /// 100일 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 100일 자각몽 연습을 달성하다'**
  String get achievementCenturionDesc;

  /// 100개 누적 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'100일 누적 자각몽 챌린지를 완료했다'**
  String get achievementChallenge100CumulativeDesc;

  /// 100개 누적 챌린지 완료 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'작은 노력들이 큰 성과를 만듭니다!'**
  String get achievementChallenge100CumulativeMotivation;

  /// 100개 누적 챌린지 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'100일 누적 챌린지 완료'**
  String get achievementChallenge100CumulativeTitle;

  /// 14일 연속 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'14일 연속 자각몽 연습 챌린지를 완료했다'**
  String get achievementChallenge14DaysDesc;

  /// 14일 연속 챌린지 완료 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'불굴의 의지! 대단하다! 💪'**
  String get achievementChallenge14DaysMotivation;

  /// 14일 연속 챌린지 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'14일 연속 챌린지 완료'**
  String get achievementChallenge14DaysTitle;

  /// 200개 누적 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'200일 누적 자각몽 챌린지를 완료했다'**
  String get achievementChallenge200CumulativeDesc;

  /// 200개 누적 챌린지 완료 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'진정한 챔피언의 모습이다!'**
  String get achievementChallenge200CumulativeMotivation;

  /// 200개 누적 챌린지 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'200일 누적 챌린지 완료'**
  String get achievementChallenge200CumulativeTitle;

  /// 50개 한번에 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'한 번에 50개 자각몽 기법 챌린지를 완료했다'**
  String get achievementChallenge50SingleDesc;

  /// 50개 한번에 챌린지 완료 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'한계 돌파! 미쳤다! 🔥'**
  String get achievementChallenge50SingleMotivation;

  /// 50개 한번에 챌린지 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'50개 기법 한번에 챌린지 완료'**
  String get achievementChallenge50SingleTitle;

  /// 7일 연속 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 자각몽 연습 챌린지를 완료했다'**
  String get achievementChallenge7DaysDesc;

  /// 7일 연속 챌린지 완료 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'꾸준함이 최고의 무기이다!'**
  String get achievementChallenge7DaysMotivation;

  /// 7일 연속 챌린지 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 챌린지 완료'**
  String get achievementChallenge7DaysTitle;

  /// 챌린지 마스터 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'모든 챌린지를 완료했다'**
  String get achievementChallengeMasterDesc;

  /// 챌린지 마스터 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'당신은 진정한 챌린지 마스터이다!'**
  String get achievementChallengeMasterMotivation;

  /// 챌린지 마스터 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'챌린지 마스터'**
  String get achievementChallengeMasterTitle;

  /// No description provided for @achievementComebackKidDesc.
  ///
  /// In ko, this message translates to:
  /// **'7일 이상 쉰 후 다시 꿈 연습을 시작했다'**
  String get achievementComebackKidDesc;

  /// No description provided for @achievementComebackKidMotivation.
  ///
  /// In ko, this message translates to:
  /// **'포기하지 않는 마음! 컴백의 드림 스피릿! 🔄'**
  String get achievementComebackKidMotivation;

  /// No description provided for @achievementComebackKidTitle.
  ///
  /// In ko, this message translates to:
  /// **'컴백 키드'**
  String get achievementComebackKidTitle;

  /// 달성률 80% 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'평균 달성률 80% 이상을 달성했다'**
  String get achievementCompletionRate80Desc;

  /// 달성률 80% 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'꾸준함이 답이다! 계속 간다! 💪'**
  String get achievementCompletionRate80Motivation;

  /// 달성률 80% 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'우수한 달성률'**
  String get achievementCompletionRate80Title;

  /// 달성률 90% 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'평균 달성률 90% 이상을 달성했다'**
  String get achievementCompletionRate90Desc;

  /// 달성률 90% 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'거의 완벽! 폼 미쳤다! 🔥'**
  String get achievementCompletionRate90Motivation;

  /// 달성률 90% 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'완벽주의자'**
  String get achievementCompletionRate90Title;

  /// 달성률 95% 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'평균 달성률 95% 이상을 달성했다'**
  String get achievementCompletionRate95Desc;

  /// 달성률 95% 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'완벽에 가깝다! 레전드급! 👑'**
  String get achievementCompletionRate95Motivation;

  /// 달성률 95% 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'마스터 퍼포머'**
  String get achievementCompletionRate95Title;

  /// 30일 연속 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'일관성의 왕'**
  String get achievementConsistency;

  /// 30일 연속 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'30일 연속으로 자각몽 연습하다'**
  String get achievementConsistencyDesc;

  /// No description provided for @achievementConsistencyMasterDesc.
  ///
  /// In ko, this message translates to:
  /// **'10일 연속 목표를 정확히 달성했다'**
  String get achievementConsistencyMasterDesc;

  /// No description provided for @achievementConsistencyMasterMotivation.
  ///
  /// In ko, this message translates to:
  /// **'정확한 목표 달성! 일관성의 마스터! 🎯'**
  String get achievementConsistencyMasterMotivation;

  /// No description provided for @achievementConsistencyMasterTitle.
  ///
  /// In ko, this message translates to:
  /// **'일관성의 마스터'**
  String get achievementConsistencyMasterTitle;

  /// 100일 연속 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'헌신'**
  String get achievementDedication;

  /// 100일 연속 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'100일 연속으로 자각몽 연습하다'**
  String get achievementDedicationDesc;

  /// No description provided for @achievementDedicationMasterDesc.
  ///
  /// In ko, this message translates to:
  /// **'앱을 100일 이상 사용했다'**
  String get achievementDedicationMasterDesc;

  /// No description provided for @achievementDedicationMasterMotivation.
  ///
  /// In ko, this message translates to:
  /// **'100일 헌신! 당신은 헌신의 마스터이다! 🎖️'**
  String get achievementDedicationMasterMotivation;

  /// No description provided for @achievementDedicationMasterTitle.
  ///
  /// In ko, this message translates to:
  /// **'헌신의 마스터'**
  String get achievementDedicationMasterTitle;

  /// No description provided for @achievementDoubleTroubleDesc.
  ///
  /// In ko, this message translates to:
  /// **'목표의 200%를 달성했다'**
  String get achievementDoubleTroubleDesc;

  /// No description provided for @achievementDoubleTroubleMotivation.
  ///
  /// In ko, this message translates to:
  /// **'목표의 2배! 더블 트러블 드림 스피릿! 🎪'**
  String get achievementDoubleTroubleMotivation;

  /// No description provided for @achievementDoubleTroubleTitle.
  ///
  /// In ko, this message translates to:
  /// **'더블 트러블'**
  String get achievementDoubleTroubleTitle;

  /// 아침 자각몽 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'얼리버드'**
  String get achievementEarlyBird;

  /// 아침 자각몽 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'오전 7시 이전에 5번 자각몽 연습했다'**
  String get achievementEarlyBirdDesc;

  /// No description provided for @achievementEarlyBirdMotivation.
  ///
  /// In ko, this message translates to:
  /// **'새벽을 정복한 얼리버드 드림 스피릿! 🌅'**
  String get achievementEarlyBirdMotivation;

  /// No description provided for @achievementEarlyBirdTitle.
  ///
  /// In ko, this message translates to:
  /// **'새벽 드림 스피릿'**
  String get achievementEarlyBirdTitle;

  /// 긴 자각몽 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'지구력 왕'**
  String get achievementEndurance;

  /// 긴 자각몽 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'30분 이상 자각몽 연습하다'**
  String get achievementEnduranceDesc;

  /// No description provided for @achievementEnduranceKingDesc.
  ///
  /// In ko, this message translates to:
  /// **'30분 이상 꿈 연습을 지속했다'**
  String get achievementEnduranceKingDesc;

  /// No description provided for @achievementEnduranceKingMotivation.
  ///
  /// In ko, this message translates to:
  /// **'30분 지속! 지구력의 왕! ⏰'**
  String get achievementEnduranceKingMotivation;

  /// No description provided for @achievementEnduranceKingTitle.
  ///
  /// In ko, this message translates to:
  /// **'지구력의 왕'**
  String get achievementEnduranceKingTitle;

  /// No description provided for @achievementFirst100SingleDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 번의 자각몽 연습에서 100개를 달성했다'**
  String get achievementFirst100SingleDesc;

  /// No description provided for @achievementFirst100SingleMotivation.
  ///
  /// In ko, this message translates to:
  /// **'한 번에 100개! 진정한 파워 드림 스피릿! 💥'**
  String get achievementFirst100SingleMotivation;

  /// No description provided for @achievementFirst100SingleTitle.
  ///
  /// In ko, this message translates to:
  /// **'한 번에 100개'**
  String get achievementFirst100SingleTitle;

  /// No description provided for @achievementFirst50Desc.
  ///
  /// In ko, this message translates to:
  /// **'한 번의 자각몽 연습에서 50개를 달성했다'**
  String get achievementFirst50Desc;

  /// No description provided for @achievementFirst50Motivation.
  ///
  /// In ko, this message translates to:
  /// **'50개 돌파! 기반이 단단해진다! 🎊'**
  String get achievementFirst50Motivation;

  /// No description provided for @achievementFirst50Title.
  ///
  /// In ko, this message translates to:
  /// **'첫 50개 돌파'**
  String get achievementFirst50Title;

  /// 첫 번째 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'여정의 시작'**
  String get achievementFirstJourney;

  /// 첫 번째 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 자각몽 연습을 완료하다'**
  String get achievementFirstJourneyDesc;

  /// 신 모드 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'신 모드'**
  String get achievementGodMode;

  /// 신 모드 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'한 세션에서 500일 훈련 이상 달성하다'**
  String get achievementGodModeDesc;

  /// 어려운 난이도 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'강철 의지'**
  String get achievementIronWill;

  /// 어려운 난이도 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'한 번에 200개를 달성했다'**
  String get achievementIronWillDesc;

  /// No description provided for @achievementIronWillMotivation.
  ///
  /// In ko, this message translates to:
  /// **'200개 한 번에! 강철 같은 의지! 🔩'**
  String get achievementIronWillMotivation;

  /// No description provided for @achievementIronWillTitle.
  ///
  /// In ko, this message translates to:
  /// **'강철 의지'**
  String get achievementIronWillTitle;

  /// 10000일 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'전설'**
  String get achievementLegend;

  /// 10000일 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 10000일 자각몽 연습을 달성하다'**
  String get achievementLegendDesc;

  /// No description provided for @achievementLegendaryBeastDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 번에 500개를 달성했다'**
  String get achievementLegendaryBeastDesc;

  /// No description provided for @achievementLegendaryBeastMotivation.
  ///
  /// In ko, this message translates to:
  /// **'500개! 당신은 레전더리 비스트이다! 🐉'**
  String get achievementLegendaryBeastMotivation;

  /// No description provided for @achievementLegendaryBeastTitle.
  ///
  /// In ko, this message translates to:
  /// **'레전더리 비스트'**
  String get achievementLegendaryBeastTitle;

  /// No description provided for @achievementLevel10Desc.
  ///
  /// In ko, this message translates to:
  /// **'레벨 10에 도달했다'**
  String get achievementLevel10Desc;

  /// No description provided for @achievementLevel10Motivation.
  ///
  /// In ko, this message translates to:
  /// **'레벨 10! 고급 나만의 경지! 🏅'**
  String get achievementLevel10Motivation;

  /// No description provided for @achievementLevel10Title.
  ///
  /// In ko, this message translates to:
  /// **'레벨 10 드림 스피릿'**
  String get achievementLevel10Title;

  /// No description provided for @achievementLevel20Desc.
  ///
  /// In ko, this message translates to:
  /// **'레벨 20에 도달했다'**
  String get achievementLevel20Desc;

  /// No description provided for @achievementLevel20Motivation.
  ///
  /// In ko, this message translates to:
  /// **'레벨 20! 드림 스피릿 중의 왕! 👑'**
  String get achievementLevel20Motivation;

  /// No description provided for @achievementLevel20Title.
  ///
  /// In ko, this message translates to:
  /// **'레벨 20 드림 스피릿'**
  String get achievementLevel20Title;

  /// No description provided for @achievementLevel5Desc.
  ///
  /// In ko, this message translates to:
  /// **'레벨 5에 도달했다'**
  String get achievementLevel5Desc;

  /// No description provided for @achievementLevel5Motivation.
  ///
  /// In ko, this message translates to:
  /// **'레벨 5 달성! 중급 나만의 시작! 🌟'**
  String get achievementLevel5Motivation;

  /// No description provided for @achievementLevel5Title.
  ///
  /// In ko, this message translates to:
  /// **'레벨 5 드림 스피릿'**
  String get achievementLevel5Title;

  /// No description provided for @achievementLunchBreakDesc.
  ///
  /// In ko, this message translates to:
  /// **'점심시간(12-2시)에 5번 자각몽 연습했다'**
  String get achievementLunchBreakDesc;

  /// No description provided for @achievementLunchBreakMotivation.
  ///
  /// In ko, this message translates to:
  /// **'점심시간도 놓치지 않는 효율적인 드림 스피릿! 🍽️'**
  String get achievementLunchBreakMotivation;

  /// No description provided for @achievementLunchBreakTitle.
  ///
  /// In ko, this message translates to:
  /// **'점심시간 드림 스피릿'**
  String get achievementLunchBreakTitle;

  /// 5000일 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'마라토너'**
  String get achievementMarathoner;

  /// 5000일 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 5000일 자각몽 연습을 달성하다'**
  String get achievementMarathonerDesc;

  /// No description provided for @achievementMonthlyWarriorDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 달에 20일 이상 자각몽 연습했다'**
  String get achievementMonthlyWarriorDesc;

  /// No description provided for @achievementMonthlyWarriorMotivation.
  ///
  /// In ko, this message translates to:
  /// **'한 달 20일! 월간 전사 드림 스피릿! 📅'**
  String get achievementMonthlyWarriorMotivation;

  /// No description provided for @achievementMonthlyWarriorTitle.
  ///
  /// In ko, this message translates to:
  /// **'월간 전사'**
  String get achievementMonthlyWarriorTitle;

  /// No description provided for @achievementMotivatorDesc.
  ///
  /// In ko, this message translates to:
  /// **'앱을 30일 이상 사용했다'**
  String get achievementMotivatorDesc;

  /// No description provided for @achievementMotivatorMotivation.
  ///
  /// In ko, this message translates to:
  /// **'30일 사용! 진정한 동기부여자! 💡'**
  String get achievementMotivatorMotivation;

  /// No description provided for @achievementMotivatorTitle.
  ///
  /// In ko, this message translates to:
  /// **'동기부여자'**
  String get achievementMotivatorTitle;

  /// 밤 자각몽 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'올빼미'**
  String get achievementNightOwl;

  /// 밤 자각몽 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'오후 10시 이후에 5번 자각몽 연습했다'**
  String get achievementNightOwlDesc;

  /// No description provided for @achievementNightOwlMotivation.
  ///
  /// In ko, this message translates to:
  /// **'밤에도 포기하지 않는 올빼미 드림 스피릿! 🦉'**
  String get achievementNightOwlMotivation;

  /// No description provided for @achievementNightOwlTitle.
  ///
  /// In ko, this message translates to:
  /// **'야행성 드림 스피릿'**
  String get achievementNightOwlTitle;

  /// 업적 알림 채널 설명
  ///
  /// In ko, this message translates to:
  /// **'업적 달성 및 진행률 알림'**
  String get achievementNotificationChannelDescription;

  /// 업적 알림 채널 이름
  ///
  /// In ko, this message translates to:
  /// **'업적 알림'**
  String get achievementNotificationChannelName;

  /// 업적 알림 설정
  ///
  /// In ko, this message translates to:
  /// **'업적 알림'**
  String get achievementNotifications;

  /// 업적 알림 항상 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'업적 알림은 항상 활성화된다'**
  String get achievementNotificationsAlwaysOn;

  /// 업적 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'🏆 새로운 업적 달성 시 너의 승리를 알려준다!'**
  String get achievementNotificationsDesc;

  /// 목표 초과 5일 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'초과달성자'**
  String get achievementOverachiever;

  /// 목표 초과 5일 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'목표의 150%를 5번 달성했다'**
  String get achievementOverachieverDesc;

  /// No description provided for @achievementOverachieverMotivation.
  ///
  /// In ko, this message translates to:
  /// **'목표를 뛰어넘는 오버어치버! 📈'**
  String get achievementOverachieverMotivation;

  /// No description provided for @achievementOverachieverTitle.
  ///
  /// In ko, this message translates to:
  /// **'목표 초과 달성자'**
  String get achievementOverachieverTitle;

  /// No description provided for @achievementPerfect10Desc.
  ///
  /// In ko, this message translates to:
  /// **'10번의 완벽한 꿈 연습을 달성했다'**
  String get achievementPerfect10Desc;

  /// No description provided for @achievementPerfect10Motivation.
  ///
  /// In ko, this message translates to:
  /// **'완벽의 마스터! 드림 스피릿 중의 드림 스피릿! 🏆'**
  String get achievementPerfect10Motivation;

  /// No description provided for @achievementPerfect10Title.
  ///
  /// In ko, this message translates to:
  /// **'마스터 드림 스피릿'**
  String get achievementPerfect10Title;

  /// No description provided for @achievementPerfect20Desc.
  ///
  /// In ko, this message translates to:
  /// **'20번의 완벽한 꿈 연습을 달성했다'**
  String get achievementPerfect20Desc;

  /// No description provided for @achievementPerfect20Motivation.
  ///
  /// In ko, this message translates to:
  /// **'20번 완벽! 당신은 완벽의 화신이다! 💎'**
  String get achievementPerfect20Motivation;

  /// No description provided for @achievementPerfect20Title.
  ///
  /// In ko, this message translates to:
  /// **'완벽 레전드'**
  String get achievementPerfect20Title;

  /// No description provided for @achievementPerfect3Desc.
  ///
  /// In ko, this message translates to:
  /// **'3번의 완벽한 꿈 연습을 달성했다'**
  String get achievementPerfect3Desc;

  /// No description provided for @achievementPerfect3Motivation.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 트리플! 정확성의 드림 스피릿! 🎯'**
  String get achievementPerfect3Motivation;

  /// No description provided for @achievementPerfect3Title.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 트리플'**
  String get achievementPerfect3Title;

  /// No description provided for @achievementPerfect5Desc.
  ///
  /// In ko, this message translates to:
  /// **'5번의 완벽한 꿈 연습을 달성했다'**
  String get achievementPerfect5Desc;

  /// No description provided for @achievementPerfect5Motivation.
  ///
  /// In ko, this message translates to:
  /// **'완벽을 추구하는 진정한 드림 스피릿! ⭐'**
  String get achievementPerfect5Motivation;

  /// No description provided for @achievementPerfect5Title.
  ///
  /// In ko, this message translates to:
  /// **'완벽주의 드림 스피릿'**
  String get achievementPerfect5Title;

  /// 완벽한 세트 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'완벽한 첫 세트'**
  String get achievementPerfectSet;

  /// 완벽한 세트 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'목표를 100% 달성한 세트를 완료하다'**
  String get achievementPerfectSetDesc;

  /// 완벽한 세트 10개 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'완벽주의자'**
  String get achievementPerfectionist;

  /// 완벽한 세트 10개 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'완벽한 세트를 10개 달성하다'**
  String get achievementPerfectionistDesc;

  /// 1000일 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'자각몽 마스터'**
  String get achievementPushupMaster;

  /// 1000일 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 1000일 자각몽 연습을 달성하다'**
  String get achievementPushupMasterDesc;

  /// 일반 등급
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get achievementRarityCommon;

  /// 에픽 등급
  ///
  /// In ko, this message translates to:
  /// **'에픽'**
  String get achievementRarityEpic;

  /// 전설 등급
  ///
  /// In ko, this message translates to:
  /// **'레전더리'**
  String get achievementRarityLegendary;

  /// 신화 등급
  ///
  /// In ko, this message translates to:
  /// **'신화'**
  String get achievementRarityMythic;

  /// 레어 등급
  ///
  /// In ko, this message translates to:
  /// **'레어'**
  String get achievementRarityRare;

  /// 업적 화면 광고 대체 메시지
  ///
  /// In ko, this message translates to:
  /// **'업적을 달성해서 드림 스피릿가 되자! 🏆'**
  String get achievementScreenAdMessage;

  /// No description provided for @achievementSeasonalChampionDesc.
  ///
  /// In ko, this message translates to:
  /// **'3개월 연속 월간 목표를 달성했다'**
  String get achievementSeasonalChampionDesc;

  /// No description provided for @achievementSeasonalChampionMotivation.
  ///
  /// In ko, this message translates to:
  /// **'3개월 연속! 시즌 챔피언! 🏆'**
  String get achievementSeasonalChampionMotivation;

  /// No description provided for @achievementSeasonalChampionTitle.
  ///
  /// In ko, this message translates to:
  /// **'시즌 챔피언'**
  String get achievementSeasonalChampionTitle;

  /// 빠른 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'스피드 데몬'**
  String get achievementSpeedDemon;

  /// 빠른 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'5분 이내에 50개를 완료했다'**
  String get achievementSpeedDemonDesc;

  /// No description provided for @achievementSpeedDemonMotivation.
  ///
  /// In ko, this message translates to:
  /// **'번개 같은 속도! 스피드의 드림 스피릿! 💨'**
  String get achievementSpeedDemonMotivation;

  /// No description provided for @achievementSpeedDemonTitle.
  ///
  /// In ko, this message translates to:
  /// **'스피드 데몬'**
  String get achievementSpeedDemonTitle;

  /// No description provided for @achievementStreak100Desc.
  ///
  /// In ko, this message translates to:
  /// **'100일 연속 자각몽 연습을 완료했다'**
  String get achievementStreak100Desc;

  /// No description provided for @achievementStreak100Motivation.
  ///
  /// In ko, this message translates to:
  /// **'100일 연속! 당신은 살아있는 신화이다! 🌟'**
  String get achievementStreak100Motivation;

  /// No description provided for @achievementStreak100Title.
  ///
  /// In ko, this message translates to:
  /// **'100일 신화 드림 스피릿'**
  String get achievementStreak100Title;

  /// No description provided for @achievementStreak14Desc.
  ///
  /// In ko, this message translates to:
  /// **'14일 연속 자각몽 연습을 완료했다'**
  String get achievementStreak14Desc;

  /// No description provided for @achievementStreak14Motivation.
  ///
  /// In ko, this message translates to:
  /// **'끈기의 왕! 드림 스피릿 중의 드림 스피릿! 🏃‍♂️'**
  String get achievementStreak14Motivation;

  /// No description provided for @achievementStreak14Title.
  ///
  /// In ko, this message translates to:
  /// **'2주 마라톤 드림 스피릿'**
  String get achievementStreak14Title;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In ko, this message translates to:
  /// **'30일 연속 자각몽 연습을 완료했다'**
  String get achievementStreak30Desc;

  /// No description provided for @achievementStreak30Motivation.
  ///
  /// In ko, this message translates to:
  /// **'이제 당신은 나만의 왕이다! 👑'**
  String get achievementStreak30Motivation;

  /// No description provided for @achievementStreak30Title.
  ///
  /// In ko, this message translates to:
  /// **'월간 궁극 드림 스피릿'**
  String get achievementStreak30Title;

  /// No description provided for @achievementStreak3Desc.
  ///
  /// In ko, this message translates to:
  /// **'3일 연속 자각몽 연습을 완료했다'**
  String get achievementStreak3Desc;

  /// No description provided for @achievementStreak3Motivation.
  ///
  /// In ko, this message translates to:
  /// **'꾸준함이 Dream Spirit를 만듭니다! 🔥'**
  String get achievementStreak3Motivation;

  /// No description provided for @achievementStreak3Title.
  ///
  /// In ko, this message translates to:
  /// **'3일 연속 드림 스피릿'**
  String get achievementStreak3Title;

  /// No description provided for @achievementStreak60Desc.
  ///
  /// In ko, this message translates to:
  /// **'60일 연속 자각몽 연습을 완료했다'**
  String get achievementStreak60Desc;

  /// No description provided for @achievementStreak60Motivation.
  ///
  /// In ko, this message translates to:
  /// **'2개월 연속! 당신은 레전드이다! 🏅'**
  String get achievementStreak60Motivation;

  /// No description provided for @achievementStreak60Title.
  ///
  /// In ko, this message translates to:
  /// **'2개월 레전드 드림 스피릿'**
  String get achievementStreak60Title;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 자각몽 연습을 완료했다'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementStreak7Motivation.
  ///
  /// In ko, this message translates to:
  /// **'일주일을 정복한 진정한 드림 스피릿! 💪'**
  String get achievementStreak7Motivation;

  /// No description provided for @achievementStreak7Title.
  ///
  /// In ko, this message translates to:
  /// **'주간 드림 스피릿'**
  String get achievementStreak7Title;

  /// No description provided for @achievementTotal10000Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 10000개의 자각몽 체크리스트을 완료했다'**
  String get achievementTotal10000Desc;

  /// No description provided for @achievementTotal10000Motivation.
  ///
  /// In ko, this message translates to:
  /// **'10000개! 당신은 나만의 신이다! 👑'**
  String get achievementTotal10000Motivation;

  /// No description provided for @achievementTotal10000Title.
  ///
  /// In ko, this message translates to:
  /// **'10000 갓 드림 스피릿'**
  String get achievementTotal10000Title;

  /// No description provided for @achievementTotal1000Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 1000개의 자각몽 체크리스트을 완료했다'**
  String get achievementTotal1000Desc;

  /// No description provided for @achievementTotal1000Motivation.
  ///
  /// In ko, this message translates to:
  /// **'1000개 돌파! 메가 드림 스피릿 달성! ⚡'**
  String get achievementTotal1000Motivation;

  /// No description provided for @achievementTotal1000Title.
  ///
  /// In ko, this message translates to:
  /// **'1000 메가 드림 스피릿'**
  String get achievementTotal1000Title;

  /// No description provided for @achievementTotal100Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 100개의 자각몽 체크리스트을 완료했다'**
  String get achievementTotal100Desc;

  /// No description provided for @achievementTotal100Motivation.
  ///
  /// In ko, this message translates to:
  /// **'첫 100개 돌파! 나만의 기반 완성! 💯'**
  String get achievementTotal100Motivation;

  /// No description provided for @achievementTotal100Title.
  ///
  /// In ko, this message translates to:
  /// **'첫 100개 돌파'**
  String get achievementTotal100Title;

  /// No description provided for @achievementTotal2500Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 2500개의 자각몽 체크리스트을 완료했다'**
  String get achievementTotal2500Desc;

  /// No description provided for @achievementTotal2500Motivation.
  ///
  /// In ko, this message translates to:
  /// **'2500개! 슈퍼 나만의 경지에 도달! 🔥'**
  String get achievementTotal2500Motivation;

  /// No description provided for @achievementTotal2500Title.
  ///
  /// In ko, this message translates to:
  /// **'2500 슈퍼 드림 스피릿'**
  String get achievementTotal2500Title;

  /// No description provided for @achievementTotal250Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 250개의 자각몽 체크리스트을 완료했다'**
  String get achievementTotal250Desc;

  /// No description provided for @achievementTotal250Motivation.
  ///
  /// In ko, this message translates to:
  /// **'250개! 꾸준함의 결과! 🎯'**
  String get achievementTotal250Motivation;

  /// No description provided for @achievementTotal250Title.
  ///
  /// In ko, this message translates to:
  /// **'250 드림 스피릿'**
  String get achievementTotal250Title;

  /// No description provided for @achievementTotal5000Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 5000개의 자각몽 체크리스트을 완료했다'**
  String get achievementTotal5000Desc;

  /// No description provided for @achievementTotal5000Motivation.
  ///
  /// In ko, this message translates to:
  /// **'5000개! 당신은 울트라 Dream Spirit가다! 🌟'**
  String get achievementTotal5000Motivation;

  /// No description provided for @achievementTotal5000Title.
  ///
  /// In ko, this message translates to:
  /// **'5000 울트라 드림 스피릿'**
  String get achievementTotal5000Title;

  /// No description provided for @achievementTotal500Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 500개의 자각몽 체크리스트을 완료했다'**
  String get achievementTotal500Desc;

  /// No description provided for @achievementTotal500Motivation.
  ///
  /// In ko, this message translates to:
  /// **'500개 돌파! 중급 드림 스피릿 달성! 🚀'**
  String get achievementTotal500Motivation;

  /// No description provided for @achievementTotal500Title.
  ///
  /// In ko, this message translates to:
  /// **'500 드림 스피릿'**
  String get achievementTotal500Title;

  /// No description provided for @achievementTotal50Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 50개의 자각몽 체크리스트을 완료했다'**
  String get achievementTotal50Desc;

  /// No description provided for @achievementTotal50Motivation.
  ///
  /// In ko, this message translates to:
  /// **'첫 50개! 새싹이 자란다! 🌱'**
  String get achievementTotal50Motivation;

  /// No description provided for @achievementTotal50Title.
  ///
  /// In ko, this message translates to:
  /// **'첫 50개 총합'**
  String get achievementTotal50Title;

  /// No description provided for @achievementTutorialExplorerDesc.
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 자각몽 체크리스트 튜토리얼을 확인했다'**
  String get achievementTutorialExplorerDesc;

  /// No description provided for @achievementTutorialExplorerMotivation.
  ///
  /// In ko, this message translates to:
  /// **'지식이 나만의 첫 번째 힘이다! 🔍'**
  String get achievementTutorialExplorerMotivation;

  /// No description provided for @achievementTutorialExplorerTitle.
  ///
  /// In ko, this message translates to:
  /// **'탐구하는 드림 스피릿'**
  String get achievementTutorialExplorerTitle;

  /// No description provided for @achievementTutorialMasterDesc.
  ///
  /// In ko, this message translates to:
  /// **'모든 자각몽 체크리스트 튜토리얼을 확인했다'**
  String get achievementTutorialMasterDesc;

  /// No description provided for @achievementTutorialMasterMotivation.
  ///
  /// In ko, this message translates to:
  /// **'모든 기술을 마스터한 자각몽 체크리스트 박사! 🎓'**
  String get achievementTutorialMasterMotivation;

  /// No description provided for @achievementTutorialMasterTitle.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 체크리스트 마스터'**
  String get achievementTutorialMasterTitle;

  /// No description provided for @achievementTutorialStudentDesc.
  ///
  /// In ko, this message translates to:
  /// **'5개의 자각몽 체크리스트 튜토리얼을 확인했다'**
  String get achievementTutorialStudentDesc;

  /// No description provided for @achievementTutorialStudentMotivation.
  ///
  /// In ko, this message translates to:
  /// **'다양한 기술을 배우는 진정한 드림 스피릿! 📚'**
  String get achievementTutorialStudentMotivation;

  /// No description provided for @achievementTutorialStudentTitle.
  ///
  /// In ko, this message translates to:
  /// **'학습하는 드림 스피릿'**
  String get achievementTutorialStudentTitle;

  /// 챌린지 업적 타입 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'🚀 챌린지 비스트'**
  String get achievementTypeChallenge;

  /// 첫 번째 업적 타입 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'🥇 처녀 항해'**
  String get achievementTypeFirst;

  /// 완벽 업적 타입 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'👑 완벽 황제'**
  String get achievementTypePerfect;

  /// 특별 업적 타입 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'💎 스페셜 레전드'**
  String get achievementTypeSpecial;

  /// 통계 업적 타입 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'📊 통계 마스터'**
  String get achievementTypeStatistics;

  /// 연속 업적 타입 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'⚡ 연속 도미넌스'**
  String get achievementTypeStreak;

  /// 볼륨 업적 타입 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'🔥 볼륨 폭격'**
  String get achievementTypeVolume;

  /// 최고 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'궁극의 드림 스피릿'**
  String get achievementUltimate;

  /// 최고 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'모든 업적을 달성하다'**
  String get achievementUltimateDesc;

  /// No description provided for @achievementUltimateMotivation.
  ///
  /// In ko, this message translates to:
  /// **'당신은 궁극의 Dream Spirit가다! 🌟'**
  String get achievementUltimateMotivation;

  /// 업적 달성 타이틀
  ///
  /// In ko, this message translates to:
  /// **'🏆 업적 달성! 🏆'**
  String get achievementUnlocked;

  /// No description provided for @achievementUnstoppableForceDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 번에 300개를 달성했다'**
  String get achievementUnstoppableForceDesc;

  /// No description provided for @achievementUnstoppableForceMotivation.
  ///
  /// In ko, this message translates to:
  /// **'300개! 당신은 멈출 수 없는 힘이다! 🌪️'**
  String get achievementUnstoppableForceMotivation;

  /// No description provided for @achievementUnstoppableForceTitle.
  ///
  /// In ko, this message translates to:
  /// **'멈출 수 없는 힘'**
  String get achievementUnstoppableForceTitle;

  /// 다양한 푸쉬업 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'다양성의 달인'**
  String get achievementVariety;

  /// 다양한 푸쉬업 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'5가지 다른 자각몽 기법 타입을 완료하다'**
  String get achievementVarietyDesc;

  /// No description provided for @achievementVarietySeekerDesc.
  ///
  /// In ko, this message translates to:
  /// **'5가지 다른 자각몽 체크리스트 타입을 시도했다'**
  String get achievementVarietySeekerDesc;

  /// No description provided for @achievementVarietySeekerMotivation.
  ///
  /// In ko, this message translates to:
  /// **'다양함을 추구하는 창의적 드림 스피릿! 🎨'**
  String get achievementVarietySeekerMotivation;

  /// No description provided for @achievementVarietySeekerTitle.
  ///
  /// In ko, this message translates to:
  /// **'다양성 추구자'**
  String get achievementVarietySeekerTitle;

  /// 7일 연속 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'주간 전사'**
  String get achievementWeekWarrior;

  /// 7일 연속 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'7일 연속으로 자각몽 연습하다'**
  String get achievementWeekWarriorDesc;

  /// No description provided for @achievementWeekendWarriorDesc.
  ///
  /// In ko, this message translates to:
  /// **'주말에 꾸준히 자각몽 연습하는 드림 스피릿'**
  String get achievementWeekendWarriorDesc;

  /// No description provided for @achievementWeekendWarriorMotivation.
  ///
  /// In ko, this message translates to:
  /// **'주말에도 멈추지 않는 전사! ⚔️'**
  String get achievementWeekendWarriorMotivation;

  /// No description provided for @achievementWeekendWarriorTitle.
  ///
  /// In ko, this message translates to:
  /// **'주말 전사'**
  String get achievementWeekendWarriorTitle;

  /// 5시간 자각몽 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 자각몽 연습 시간 300분(5시간)을 달성했다'**
  String get achievementWorkoutTime300Desc;

  /// 5시간 자각몽 훈련 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습에 진심인 당신의 모습이 멋집니다!'**
  String get achievementWorkoutTime300Motivation;

  /// 5시간 자각몽 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'5시간 자각몽 연습 마스터'**
  String get achievementWorkoutTime300Title;

  /// 1시간 자각몽 훈련 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 자각몽 연습 시간 60분을 달성했다'**
  String get achievementWorkoutTime60Desc;

  /// 1시간 자각몽 훈련 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'꾸준한 자각몽 연습 누적 중! 💪'**
  String get achievementWorkoutTime60Motivation;

  /// 1시간 자각몽 훈련 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'1시간 자각몽 연습 달성'**
  String get achievementWorkoutTime60Title;

  /// 업적 탭
  ///
  /// In ko, this message translates to:
  /// **'업적'**
  String get achievements;

  /// 업적 및 배지 항목
  ///
  /// In ko, this message translates to:
  /// **'• 업적 및 배지'**
  String get achievementsBadges;

  /// 업적 화면 배너 텍스트
  ///
  /// In ko, this message translates to:
  /// **'업적을 달성해서 드림 스피릿가 되자! 🏆'**
  String get achievementsBannerText;

  /// 모든 업적 획득 제목
  ///
  /// In ko, this message translates to:
  /// **'모든 업적 획득 완료! 🏆'**
  String get allAchievementsUnlocked;

  /// Chad achievements title
  ///
  /// In ko, this message translates to:
  /// **'업적'**
  String get chadAchievements;

  /// Advanced stats feature unlock reward
  ///
  /// In ko, this message translates to:
  /// **'고급 통계 기능 해금'**
  String get challengeRewardAdvancedStats;

  /// Century club badge reward
  ///
  /// In ko, this message translates to:
  /// **'센추리 클럽 배지'**
  String get challengeRewardCenturyClub;

  /// Consecutive warrior badge reward
  ///
  /// In ko, this message translates to:
  /// **'연속 자각몽 연습 전사 배지'**
  String get challengeRewardConsecutiveWarrior;

  /// Dedication master badge reward
  ///
  /// In ko, this message translates to:
  /// **'헌신의 마스터 배지'**
  String get challengeRewardDedicationMaster;

  /// Points reward
  ///
  /// In ko, this message translates to:
  /// **'{points} 포인트'**
  String challengeRewardPoints(String points);

  /// Power lifter badge reward
  ///
  /// In ko, this message translates to:
  /// **'파워 리프터 배지'**
  String get challengeRewardPowerLifter;

  /// Ultimate champion badge reward
  ///
  /// In ko, this message translates to:
  /// **'궁극의 챔피언 배지'**
  String get challengeRewardUltimateChampion;

  /// Challenge rewards section
  ///
  /// In ko, this message translates to:
  /// **'보상'**
  String get challengeRewards;

  /// 미획득 업적 탭
  ///
  /// In ko, this message translates to:
  /// **'미획득 업적 ({count})'**
  String lockedAchievements(int count);

  /// 업적 없음 제목
  ///
  /// In ko, this message translates to:
  /// **'아직 획득한 업적이 없다'**
  String get noAchievementsYet;

  /// 업적 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'업적 달성 시 알림을 받다'**
  String get receiveAchievementNotifications;

  /// 업적 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'자각몽 연습 시작해서 첫 업적 획득하자! 💪'**
  String get startWorkoutForAchievements;

  /// No description provided for @trophyIcon.
  ///
  /// In ko, this message translates to:
  /// **'🏆'**
  String get trophyIcon;

  /// 챌린지 해금 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'더 많은 자각몽 연습을 완료하여 새로운 챌린지를 해금해!'**
  String get unlockMoreChallenges;

  /// 획득한 업적 탭
  ///
  /// In ko, this message translates to:
  /// **'획득한 업적 ({count})'**
  String unlockedAchievements(int count);

  /// Number of achievements completed
  ///
  /// In ko, this message translates to:
  /// **'달성한 업적: {completed}/{total}개'**
  String achievementsCompleted(int completed, int total);

  /// No description provided for @categoryAchievements.
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 업적'**
  String get categoryAchievements;

  /// No description provided for @newAchievementUnlocked.
  ///
  /// In ko, this message translates to:
  /// **'🏆 새로운 업적 달성! 🏆'**
  String get newAchievementUnlocked;

  /// No description provided for @viewAllAchievements.
  ///
  /// In ko, this message translates to:
  /// **'✨ 모든 업적 보기'**
  String get viewAllAchievements;

  /// Shows count of additional items
  ///
  /// In ko, this message translates to:
  /// **'외 {count}개 더!'**
  String andMoreCount(int count);

  /// No description provided for @achievementStatus.
  ///
  /// In ko, this message translates to:
  /// **'업적 현황'**
  String get achievementStatus;

  /// No description provided for @achievementsUnlocked.
  ///
  /// In ko, this message translates to:
  /// **'달성한 업적'**
  String get achievementsUnlocked;

  /// No description provided for @totalXP.
  ///
  /// In ko, this message translates to:
  /// **'총 경험치'**
  String get totalXP;

  /// No description provided for @completion.
  ///
  /// In ko, this message translates to:
  /// **'달성률'**
  String get completion;

  /// Number of achievements unlocked message
  ///
  /// In ko, this message translates to:
  /// **'{count}개의 업적을 달성했습니다!'**
  String achievementsUnlockedFormat(int count);

  /// Total XP earned message
  ///
  /// In ko, this message translates to:
  /// **'총 {totalXP} XP 획득!'**
  String totalXpEarned(int totalXP);

  /// No description provided for @rewardText.
  ///
  /// In ko, this message translates to:
  /// **'보상'**
  String get rewardText;

  /// 보너스 챌린지 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 보너스 챌린지'**
  String get bonusChallenge;

  /// 100 cumulative challenge description
  ///
  /// In ko, this message translates to:
  /// **'총 100일 자각몽 연습 달성'**
  String get challenge100CumulativeDescription;

  /// 100 cumulative challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'여러 세션 합쳐서 총 100일 달성! 💪'**
  String get challenge100CumulativeDetailedDescription;

  /// 100 cumulative challenge title
  ///
  /// In ko, this message translates to:
  /// **'100일 챌린지'**
  String get challenge100CumulativeTitle;

  /// 200 cumulative challenge description
  ///
  /// In ko, this message translates to:
  /// **'총 200일 자각몽 연습 달성'**
  String get challenge200CumulativeDescription;

  /// 200 cumulative challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'여러 세션 합쳐서 총 200일 달성! 100일 클리어 후 도전! 🔥'**
  String get challenge200CumulativeDetailedDescription;

  /// 200 cumulative challenge title
  ///
  /// In ko, this message translates to:
  /// **'200일 챌린지'**
  String get challenge200CumulativeTitle;

  /// 50 single session challenge description
  ///
  /// In ko, this message translates to:
  /// **'한 번의 세션에서 50개 자각몽 기법'**
  String get challenge50SingleDescription;

  /// 50 single session challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'한 번에 50개 기법! 중간에 쉬면 처음부터 다시! 💥'**
  String get challenge50SingleDetailedDescription;

  /// 50 single session challenge title
  ///
  /// In ko, this message translates to:
  /// **'50개 기법 한번에'**
  String get challenge50SingleTitle;

  /// Abandon challenge button
  ///
  /// In ko, this message translates to:
  /// **'포기하기'**
  String get challengeAbandonButton;

  /// Challenge abandoned message
  ///
  /// In ko, this message translates to:
  /// **'챌린지 포기됨'**
  String get challengeAbandoned;

  /// Challenge already active message
  ///
  /// In ko, this message translates to:
  /// **'이미 활성화된 챌린지가 있다'**
  String get challengeAlreadyActive;

  /// 챌린지 시작 불가 메시지
  ///
  /// In ko, this message translates to:
  /// **'아직 챌린지 시작 불가!'**
  String get challengeCannotStart;

  /// Challenge completed message
  ///
  /// In ko, this message translates to:
  /// **'챌린지 완료!'**
  String get challengeCompleted;

  /// Challenge difficulty: easy
  ///
  /// In ko, this message translates to:
  /// **'쉬움'**
  String get challengeDifficultyEasy;

  /// Challenge difficulty: extreme
  ///
  /// In ko, this message translates to:
  /// **'극한'**
  String get challengeDifficultyExtreme;

  /// Challenge difficulty: hard
  ///
  /// In ko, this message translates to:
  /// **'어려움'**
  String get challengeDifficultyHard;

  /// Challenge difficulty: medium
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get challengeDifficultyMedium;

  /// Challenge estimated duration
  ///
  /// In ko, this message translates to:
  /// **'예상 기간: {duration}일'**
  String challengeEstimatedDuration(int duration);

  /// Challenge failed message
  ///
  /// In ko, this message translates to:
  /// **'챌린지 실패'**
  String get challengeFailed;

  /// 챌린지 포기 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'챌린지 포기! 다시 도전하자! 💪'**
  String get challengeGaveUp;

  /// 챌린지 포기 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'정말로 이 챌린지를 포기할래?'**
  String get challengeGiveUpMessage;

  /// 챌린지 포기 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'챌린지 포기'**
  String get challengeGiveUpTitle;

  /// Hint for cumulative challenges
  ///
  /// In ko, this message translates to:
  /// **'여러 번 나눠서 목표 달성! 꾸준히 가자! 💪'**
  String get challengeHintCumulative;

  /// 챌린지 모드
  ///
  /// In ko, this message translates to:
  /// **'챌린지 모드'**
  String get challengeMode;

  /// 챌린지 모드 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥 챌린지 모드 활성화! 정신력을 시험해보자! 💪'**
  String get challengeModeActivated;

  /// 챌린지 모드 설명
  ///
  /// In ko, this message translates to:
  /// **'그냥 기본 연습? 아니면 진짜 챔피언 모드? 🚀\n\n⚡ 챌린지 모드 ON 하면:\n• 더 높은 난이도\n• 보너스 포인트 획득 🏆'**
  String get challengeModeDescription;

  /// 챌린지 모드 활성화 버튼
  ///
  /// In ko, this message translates to:
  /// **'챌린지 모드 ON! 🔥'**
  String get challengeModeOn;

  /// 챌린지 옵션 다이얼로그 내용
  ///
  /// In ko, this message translates to:
  /// **'이 챌린지를 어떻게 할래?'**
  String get challengeOptions;

  /// Challenge prerequisites not met message
  ///
  /// In ko, this message translates to:
  /// **'전제 조건이 충족되지 않았다'**
  String get challengePrerequisitesNotMet;

  /// 영상 설명 4
  ///
  /// In ko, this message translates to:
  /// **'자각몽 100일을 향한 도전 정신'**
  String get challengeSpirit100;

  /// Start challenge button
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get challengeStartButton;

  /// 챌린지 시작 메시지
  ///
  /// In ko, this message translates to:
  /// **'챌린지 시작! 🔥'**
  String get challengeStarted;

  /// Challenge status: active
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get challengeStatusActive;

  /// Challenge status: available
  ///
  /// In ko, this message translates to:
  /// **'도전 가능'**
  String get challengeStatusAvailable;

  /// Challenge status: completed
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get challengeStatusCompleted;

  /// Challenge status: failed
  ///
  /// In ko, this message translates to:
  /// **'실패'**
  String get challengeStatusFailed;

  /// Challenge status: locked
  ///
  /// In ko, this message translates to:
  /// **'잠김'**
  String get challengeStatusLocked;

  /// 완료된 챌린지 탭
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get challengeTabCompleted;

  /// 챌린지 목표
  ///
  /// In ko, this message translates to:
  /// **'목표: {target}{unit}'**
  String challengeTarget(int target, String unit);

  /// 챌린지 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'챌린지'**
  String get challengeTitle;

  /// Challenge type: cumulative
  ///
  /// In ko, this message translates to:
  /// **'누적'**
  String get challengeTypeCumulative;

  /// Active challenges tab
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get challengesActive;

  /// Available challenges tab
  ///
  /// In ko, this message translates to:
  /// **'도전 가능'**
  String get challengesAvailable;

  /// Completed challenges tab
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get challengesCompleted;

  /// Challenges screen title
  ///
  /// In ko, this message translates to:
  /// **'챌린지'**
  String get challengesTitle;

  /// 첫 챌린지 완료 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'첫 챌린지 완료해보자! 💪'**
  String get completeFirstChallenge;

  /// 누적형 챌린지 타입
  ///
  /// In ko, this message translates to:
  /// **'누적 챌린지'**
  String get cumulativeChallenge;

  /// 이벤트 챌린지 기본 제목
  ///
  /// In ko, this message translates to:
  /// **'이벤트 챌린지'**
  String get eventChallenge;

  /// 진행 중인 챌린지 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 챌린지가 없다'**
  String get noActiveChallenges;

  /// 사용 가능한 챌린지 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 챌린지가 없다'**
  String get noChallengesAvailable;

  /// 완료된 챌린지 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'완료된 챌린지가 없다'**
  String get noCompletedChallenges;

  /// Send friend challenge button
  ///
  /// In ko, this message translates to:
  /// **'💀 친구에게 드림 스피릿 도전장 발송! 💀'**
  String get sendFriendChallenge;

  /// 스프린트 챌린지 기본 설명
  ///
  /// In ko, this message translates to:
  /// **'단기간 집중 도전'**
  String get shortTermIntensiveChallenge;

  /// 이벤트 챌린지 기본 설명
  ///
  /// In ko, this message translates to:
  /// **'특별 이벤트 챌린지'**
  String get specialEventChallenge;

  /// 스프린트 챌린지 기본 제목
  ///
  /// In ko, this message translates to:
  /// **'스프린트 챌린지'**
  String get sprintChallenge;

  /// 챌린지 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'챌린지 시작! 🔥'**
  String get startChallenge;

  /// 새 챌린지 시작 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'새 챌린지 시작하자! 🔥'**
  String get startNewChallenge;

  /// No description provided for @challengeCompletedTab.
  ///
  /// In ko, this message translates to:
  /// **'완료됨'**
  String get challengeCompletedTab;

  /// No description provided for @challengeTabTitle.
  ///
  /// In ko, this message translates to:
  /// **'챌린지'**
  String get challengeTabTitle;

  /// Alpha title
  ///
  /// In ko, this message translates to:
  /// **'알파 레벨'**
  String get alphaChad;

  /// 밸런스 차드 모드 제목
  ///
  /// In ko, this message translates to:
  /// **'❤️ 밸런스 차드 모드 (화목토)'**
  String get balanceChadMode;

  /// 차드 되기 초대 메시지
  ///
  /// In ko, this message translates to:
  /// **'💀 너도 차드가 되고 싶다면? 💀'**
  String get becomeChad;

  /// Improvement tips section subtitle
  ///
  /// In ko, this message translates to:
  /// **'이 팁들로 너도 진짜 강자가 될 수 있다! 💎'**
  String get becomeTrueChadTips;

  /// 하단 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥 매일 조금씩? 틀렸다! 매일 LEGENDARY LEVEL UP이다, 만삣삐! 💪'**
  String get bottomMotivation;

  /// 차드 조언 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 나만의 조언'**
  String get chadAdvice;

  /// 알림 시간 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 알림 시간'**
  String get chadAlarmTime;

  /// 기본형 이름
  ///
  /// In ko, this message translates to:
  /// **'기본형'**
  String get chadBasic;

  /// 기본형 설명
  ///
  /// In ko, this message translates to:
  /// **'첫 진화 완료!\n기초 다지기 시작! 🔥'**
  String get chadBasicDesc;

  /// 커피 Chad 이름
  ///
  /// In ko, this message translates to:
  /// **'커피 파워'**
  String get chadCoffee;

  /// 커피 Chad 설명
  ///
  /// In ko, this message translates to:
  /// **'에너지 MAX!\n커피 파워로 더 강해졌다! ☕💪'**
  String get chadCoffeeDesc;

  /// No description provided for @chadConfident.
  ///
  /// In ko, this message translates to:
  /// **'자신감 차드'**
  String get chadConfident;

  /// No description provided for @chadConfidentDesc.
  ///
  /// In ko, this message translates to:
  /// **'자신감 폭발!\n정면 돌파 준비 완료! 💪'**
  String get chadConfidentDesc;

  /// 차드 설명 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'💪 차드 설명'**
  String get chadDescription;

  /// 더블 Chad 이름
  ///
  /// In ko, this message translates to:
  /// **'더블 파워'**
  String get chadDouble;

  /// 더블 Chad 설명
  ///
  /// In ko, this message translates to:
  /// **'최종 진화 완료! 전설 등극!\n2배 파워로 모든 걸 정복한다! 👑'**
  String get chadDoubleDesc;

  /// Chad evolution label
  ///
  /// In ko, this message translates to:
  /// **'진화'**
  String get chadEvolution;

  /// Chad evolution complete notification
  ///
  /// In ko, this message translates to:
  /// **'진화 완료 알림'**
  String get chadEvolutionCompleteNotification;

  /// 진화 격려 알림 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'진화 격려 알림'**
  String get chadEvolutionEncouragementNotifications;

  /// 진화 격려 알림 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'다음 진화까지 3일 남았을 때 격려 메시지를 받다'**
  String get chadEvolutionEncouragementNotificationsDesc;

  /// 진화 완료 알림 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'진화 완료 알림'**
  String get chadEvolutionNotifications;

  /// 진화 완료 알림 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'새로운 단계로 진화했을 때 알림받기'**
  String get chadEvolutionNotificationsDesc;

  /// Chad evolution preview notification
  ///
  /// In ko, this message translates to:
  /// **'진화 예고 알림'**
  String get chadEvolutionPreviewNotification;

  /// 진화 예고 알림 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'진화 예고 알림'**
  String get chadEvolutionPreviewNotifications;

  /// 진화 예고 알림 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'다음 진화까지 1주일 남았을 때 미리 알림을 받다'**
  String get chadEvolutionPreviewNotificationsDesc;

  /// Chad evolution quarantine notification
  ///
  /// In ko, this message translates to:
  /// **'진화 격리 알림'**
  String get chadEvolutionQuarantineNotification;

  /// Chad evolution stage title
  ///
  /// In ko, this message translates to:
  /// **'진화단계'**
  String get chadEvolutionStage;

  /// Chad evolution stages label
  ///
  /// In ko, this message translates to:
  /// **'진화 단계'**
  String get chadEvolutionStages;

  /// 진화 상태 항목
  ///
  /// In ko, this message translates to:
  /// **'• 진화 상태'**
  String get chadEvolutionStatus;

  /// 정면 Chad 이름
  ///
  /// In ko, this message translates to:
  /// **'정면 돌파'**
  String get chadFrontFacing;

  /// 정면 Chad 설명
  ///
  /// In ko, this message translates to:
  /// **'자신감 폭발!\n정면 돌파 준비 완료! 💪'**
  String get chadFrontFacingDesc;

  /// 빛나는눈 Chad 이름
  ///
  /// In ko, this message translates to:
  /// **'빛나는눈 Chad'**
  String get chadGlowingEyes;

  /// 빛나는눈 Chad 설명
  ///
  /// In ko, this message translates to:
  /// **'강력한 힘을 가진 Chad이다.\n눈에서 빛이 나며 엄청난 파워를 보여줍니다!'**
  String get chadGlowingEyesDesc;

  /// No description provided for @chadSmiling.
  ///
  /// In ko, this message translates to:
  /// **'미소 Chad'**
  String get chadSmiling;

  /// No description provided for @chadSmilingDesc.
  ///
  /// In ko, this message translates to:
  /// **'여유로운 미소를 짓는 Chad입니다.\n진정한 강자의 여유!'**
  String get chadSmilingDesc;

  /// No description provided for @chadWink.
  ///
  /// In ko, this message translates to:
  /// **'윙크 Chad'**
  String get chadWink;

  /// No description provided for @chadWinkDesc.
  ///
  /// In ko, this message translates to:
  /// **'윙크하는 Chad입니다.\n최고의 자신감과 매력!'**
  String get chadWinkDesc;

  /// No description provided for @chadGamer.
  ///
  /// In ko, this message translates to:
  /// **'게이머 Chad'**
  String get chadGamer;

  /// No description provided for @chadGamerDesc.
  ///
  /// In ko, this message translates to:
  /// **'게이밍 헤드셋을 착용한 Chad입니다.\n집중력과 반응속도 극대화!'**
  String get chadGamerDesc;

  /// No description provided for @chadGod.
  ///
  /// In ko, this message translates to:
  /// **'갓 차드'**
  String get chadGod;

  /// No description provided for @chadGodDesc.
  ///
  /// In ko, this message translates to:
  /// **'전설의 완성! 신의 경지!\n모든 것을 초월한 궁극의 차드! 👑✨'**
  String get chadGodDesc;

  /// 차드 해시태그
  ///
  /// In ko, this message translates to:
  /// **'#차드'**
  String get chadHashtag;

  /// No description provided for @chadLaserEyes.
  ///
  /// In ko, this message translates to:
  /// **'레이저 차드'**
  String get chadLaserEyes;

  /// No description provided for @chadLaserEyesDesc.
  ///
  /// In ko, this message translates to:
  /// **'강력한 힘을 가진 차드!\n눈에서 빛이 나며 엄청난 파워! ⚡'**
  String get chadLaserEyesDesc;

  /// No description provided for @chadLaserEyesHud.
  ///
  /// In ko, this message translates to:
  /// **'레이저+HUD 차드'**
  String get chadLaserEyesHud;

  /// No description provided for @chadLaserEyesHudDesc.
  ///
  /// In ko, this message translates to:
  /// **'최첨단 시스템 장착!\nHUD와 레이저로 무적 모드! 🎯'**
  String get chadLaserEyesHudDesc;

  /// 차드 레벨 0 메시지 - 수면모자차드
  ///
  /// In ko, this message translates to:
  /// **'🛌 잠에서 깨어나라, 미래의 차드여! 여정이 시작된다!'**
  String get chadMessage0;

  /// 차드 레벨 1 메시지 - 기본차드
  ///
  /// In ko, this message translates to:
  /// **'😎 기본기가 탄탄해지고 있어! 진짜 나만의 시작이야!'**
  String get chadMessage1;

  /// 차드 레벨 2 메시지 - 커피차드
  ///
  /// In ko, this message translates to:
  /// **'☕ 에너지가 넘쳐흘러! 커피보다 강한 힘이 생겼어!'**
  String get chadMessage2;

  /// 차드 레벨 3 메시지 - 정면차드
  ///
  /// In ko, this message translates to:
  /// **'🔥 정면돌파! 어떤 장애물도 막을 수 없다!'**
  String get chadMessage3;

  /// 차드 레벨 4 메시지 - 썬글차드
  ///
  /// In ko, this message translates to:
  /// **'🕶️ 쿨함이 몸에 배었어! 진정한 알파의 모습이야!'**
  String get chadMessage4;

  /// 차드 레벨 5 메시지 - 눈빔차드
  ///
  /// In ko, this message translates to:
  /// **'⚡ 눈빛만으로도 세상을 바꿀 수 있어! 전설의 시작!'**
  String get chadMessage5;

  /// 차드 레벨 6 메시지 - 더블차드
  ///
  /// In ko, this message translates to:
  /// **'👑 최고의 차드 완성! 더블 파워로 우주를 정복하라!'**
  String get chadMessage6;

  /// Chad's advice about mistakes
  ///
  /// In ko, this message translates to:
  /// **'차드도 처음엔 실수했다. 하지만 이제는 완벽하지! 🔥'**
  String get chadMistakesAdvice;

  /// 차드 모드 활성화 설명
  ///
  /// In ko, this message translates to:
  /// **'💪 차드 모드 활성화! 승리의 스케줄을 설정하라! 🔥'**
  String get chadModeActivate;

  /// No description provided for @chadModeActivated.
  ///
  /// In ko, this message translates to:
  /// **'💡 MODE 활성화! 더 정확한 알림은 나중에 설정 가능! 🔥'**
  String get chadModeActivated;

  /// 차드 모드 활성화 상태
  ///
  /// In ko, this message translates to:
  /// **'🔥 {days} {time} - 차드 모드 활성화!'**
  String chadModeActive(String days, String time);

  /// 차드 모드 선택 섹션
  ///
  /// In ko, this message translates to:
  /// **'🚀 차드 모드 선택'**
  String get chadModeSelection;

  /// 차드 모드 대기 상태
  ///
  /// In ko, this message translates to:
  /// **'😴 차드 모드 대기 중...'**
  String get chadModeWaiting;

  /// 아처 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'균형과 집중력이 필요한 고급 기술! 한쪽씩 완벽하게 해내면 진짜 강자 인정!'**
  String get chadMotivationArcher;

  /// 박수 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'폭발적인 파워로 박수를 쳐라! 이거 되면 너도 진짜 강자다, fxxk yeah!'**
  String get chadMotivationClap;

  /// 디클라인 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'높은 곳을 향해 도전하는 것이 차드다! 어깨와 상체가 불타오르는 걸 느껴봐!'**
  String get chadMotivationDecline;

  /// 기본 차드 격려 메시지
  ///
  /// In ko, this message translates to:
  /// **'나만의 길은 험하지만 그래서 더 가치있다! 포기하지 마라, 만삣삐!'**
  String get chadMotivationDefault;

  /// 다이아몬드 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'다이아몬드처럼 귀한 네 삼두근을 만들어라! 팔 근육 폭발하는 기분을 느껴봐!'**
  String get chadMotivationDiamond;

  /// 인클라인 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'단계적으로 올라가는 것이 나만의 길이다! 각도를 점점 낮춰가면서 도전해봐!'**
  String get chadMotivationIncline;

  /// 무릎 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'시작이 반이다! 무릎 푸시업도 제대로 하면 금방 일반 푸시업으로 갈 수 있어!'**
  String get chadMotivationKnee;

  /// 원핸드 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'원핸드 푸시업은 나만의 완성형이다! 이거 한 번이라도 하면 진짜 기가 차드 인정, fxxk yeah!'**
  String get chadMotivationOneArm;

  /// 파이크 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'핸드스탠드의 첫걸음! 어깨 근육이 터져나갈 것 같은 기분을 만끽해라!'**
  String get chadMotivationPike;

  /// 차드 격려 메시지 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 EMPEROR\'S ULTIMATE WISDOM 🔥'**
  String get chadMotivationSection;

  /// 기본 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'기본이 제일 중요하다, 만삣삐! 완벽한 폼으로 하나하나 쌓아가면 진짜 강자가 된다!'**
  String get chadMotivationStandard;

  /// 와이드 그립 푸시업에 대한 차드 격려
  ///
  /// In ko, this message translates to:
  /// **'가슴을 활짝 펴고 나만의 기운을 받아라! 넓은 가슴이 진짜 나만의 상징이다!'**
  String get chadMotivationWideGrip;

  /// 차드 리마인더 제목
  ///
  /// In ko, this message translates to:
  /// **'💪 차드 리마인더'**
  String get chadReminder;

  /// Chad 말풍선 레이블
  ///
  /// In ko, this message translates to:
  /// **'Chad가 말해요'**
  String get chadSays;

  /// Improvement tips section header
  ///
  /// In ko, this message translates to:
  /// **'나만의 특급 비법'**
  String get chadSecretTips;

  /// 영상 제목 3
  ///
  /// In ko, this message translates to:
  /// **'나만의 비밀 ⚡'**
  String get chadSecrets;

  /// YouTube Shorts 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'차드 쇼츠 🔥'**
  String get chadShorts;

  /// 썬글라스 Chad 이름
  ///
  /// In ko, this message translates to:
  /// **'스타일 MAX'**
  String get chadSunglasses;

  /// 썬글라스 Chad 설명
  ///
  /// In ko, this message translates to:
  /// **'스타일 MAX!\n멋도 실력이다! 😎'**
  String get chadSunglassesDesc;

  /// 기본 차드 타이틀
  ///
  /// In ko, this message translates to:
  /// **'기본형'**
  String get chadTitleBasic;

  /// 커피 차드 타이틀
  ///
  /// In ko, this message translates to:
  /// **'커피 Chad'**
  String get chadTitleCoffee;

  /// 썬글 차드 타이틀
  ///
  /// In ko, this message translates to:
  /// **'썬글 Chad'**
  String get chadTitleCool;

  /// 더블 차드 타이틀
  ///
  /// In ko, this message translates to:
  /// **'더블 Chad'**
  String get chadTitleDouble;

  /// 정면 차드 타이틀
  ///
  /// In ko, this message translates to:
  /// **'정면 Chad'**
  String get chadTitleFront;

  /// 눈빨 차드 타이틀
  ///
  /// In ko, this message translates to:
  /// **'눈빨 Chad'**
  String get chadTitleLaser;

  /// No description provided for @chadTriple.
  ///
  /// In ko, this message translates to:
  /// **'트리플 차드'**
  String get chadTriple;

  /// No description provided for @chadTripleDesc.
  ///
  /// In ko, this message translates to:
  /// **'3배 파워 폭발!\n혼자서 셋이 할 일을 한다! 💥'**
  String get chadTripleDesc;

  /// No description provided for @chadQuadruple.
  ///
  /// In ko, this message translates to:
  /// **'Glowing Eyes Chad'**
  String get chadQuadruple;

  /// No description provided for @chadQuadrupleDesc.
  ///
  /// In ko, this message translates to:
  /// **'✨ 눈부신 빛을 발하는 Chad!\n내면의 힘이 폭발한다! ✨'**
  String get chadQuadrupleDesc;

  /// No description provided for @chadPenta.
  ///
  /// In ko, this message translates to:
  /// **'Double Chad'**
  String get chadPenta;

  /// No description provided for @chadPentaDesc.
  ///
  /// In ko, this message translates to:
  /// **'🔥 두 배의 파워!\n혼자서 둘의 몫을 한다! 🔥'**
  String get chadPentaDesc;

  /// No description provided for @chadHexa.
  ///
  /// In ko, this message translates to:
  /// **'Triple Chad'**
  String get chadHexa;

  /// No description provided for @chadHexaDesc.
  ///
  /// In ko, this message translates to:
  /// **'💥 세 배의 파워!\n진정한 강자의 면모! 💥'**
  String get chadHexaDesc;

  /// No description provided for @chadUltra.
  ///
  /// In ko, this message translates to:
  /// **'Ultra Chad'**
  String get chadUltra;

  /// No description provided for @chadUltraDesc.
  ///
  /// In ko, this message translates to:
  /// **'🚀 최고 레벨의 파워!\n압도적인 존재감! 🚀'**
  String get chadUltraDesc;

  /// No description provided for @chadSupreme.
  ///
  /// In ko, this message translates to:
  /// **'Supreme Chad'**
  String get chadSupreme;

  /// No description provided for @chadSupremeDesc.
  ///
  /// In ko, this message translates to:
  /// **'👑 최고의 Chad!\n신에 가까운 힘! 👑'**
  String get chadSupremeDesc;

  /// 통계 화면 배너 텍스트
  ///
  /// In ko, this message translates to:
  /// **'나만의 성장을 확인하라! 📊'**
  String get checkChadGrowth;

  /// 모든 업적 획득 메시지
  ///
  /// In ko, this message translates to:
  /// **'축하한다! 진짜 강자 등극! 🎉'**
  String get congratulationsChad;

  /// 이번 달 운동 부제목
  ///
  /// In ko, this message translates to:
  /// **'꾸준한 차드!'**
  String get consistentChad;

  /// Current Chad state title
  ///
  /// In ko, this message translates to:
  /// **'현재 Chad 상태'**
  String get currentChadState;

  /// 일일 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 오늘도 LEGENDARY\nBEAST MODE로\n세상을 압도해라! ⚡'**
  String get dailyMotivation;

  /// No description provided for @enableChadNotifications.
  ///
  /// In ko, this message translates to:
  /// **'🔥 CHAD 알림 켜기! 만삣삐!'**
  String get enableChadNotifications;

  /// 업적 달성 대화상자 확인 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'나만의 힘을 느껴다! 💪'**
  String get feelThePowerOfChad;

  /// Giga Chad title
  ///
  /// In ko, this message translates to:
  /// **'Giga Chad'**
  String get gigaChad;

  /// Tab title for improvement tips
  ///
  /// In ko, this message translates to:
  /// **'개선\n팁'**
  String get improvementTips;

  /// 여정 참여 메시지
  ///
  /// In ko, this message translates to:
  /// **'차드가 되는 여정에 동참해'**
  String get joinChadJourney;

  /// 여정을 시작하는 차드 진화 상태
  ///
  /// In ko, this message translates to:
  /// **'여정을 시작하는 Chad'**
  String get journeyChadEvolution;

  /// Journey starting chad description
  ///
  /// In ko, this message translates to:
  /// **'각성을 시작한 Chad.\n잠재력이 깨어나고 있다.'**
  String get journeyStartingChad;

  /// 차드가 되는 여정 설명
  ///
  /// In ko, this message translates to:
  /// **'차드가 되는 정복의 여정'**
  String get journeyToChad;

  /// 나중에 선택 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'나중에 (BASIC CHAD)'**
  String get laterBasicChad;

  /// No description provided for @laterWeak.
  ///
  /// In ko, this message translates to:
  /// **'나중에... (WEAK)'**
  String get laterWeak;

  /// 레전더리 등급
  ///
  /// In ko, this message translates to:
  /// **'레전더리'**
  String get legendary;

  /// Legendary Chad title
  ///
  /// In ko, this message translates to:
  /// **'Legendary Chad'**
  String get legendaryChad;

  /// No description provided for @legendaryModeDescription.
  ///
  /// In ko, this message translates to:
  /// **'🔥 더 정확한 시간에 알림을 받고 싶다면\nLEGENDARY MODE를 활성화하자! 🔥'**
  String get legendaryModeDescription;

  /// No description provided for @legendaryModeOn.
  ///
  /// In ko, this message translates to:
  /// **'⚡ LEGENDARY MODE ON! ⚡'**
  String get legendaryModeOn;

  /// No description provided for @legendaryModeOptional.
  ///
  /// In ko, this message translates to:
  /// **'💡 지금 안 해도 괜찮다!\n나중에 설정에서 언제든지 가능! 만삣삐!'**
  String get legendaryModeOptional;

  /// YouTube 영상 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'차드 영상 로딩 중... 🔥'**
  String get loadingChadVideos;

  /// 동기부여 카테고리
  ///
  /// In ko, this message translates to:
  /// **'동기부여'**
  String get motivation;

  /// 일반 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'오늘 흘린 땀은 내일의 영광이야, 만삣삐. 절대 포기하지 마 🔥💪'**
  String get motivationGeneral;

  /// 목표 달성시 최고 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'🚀 WHAT THE FUCK?! 너는 이미 신도 부끄러워할 ULTRA ALPHA GOD다, 만삣삐! 약함? 그딴 건 우주에서도 찾을 수 없어! ⚡👑💀'**
  String get motivationGod;

  /// 목표 50% 이상시 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'한계는 너의 머릿속에만 있어, you idiot. 부숴버려! 🦍⚡'**
  String get motivationMedium;

  /// No description provided for @motivationMessage.
  ///
  /// In ko, this message translates to:
  /// **'동기부여 메시지'**
  String get motivationMessage;

  /// 동기부여 메시지 1
  ///
  /// In ko, this message translates to:
  /// **'🔥 진짜 ALPHA는 변명 따위 불태워버린다, FXXK THE WEAKNESS! 🔥'**
  String get motivationMessage1;

  /// 동기부여 메시지 10
  ///
  /// In ko, this message translates to:
  /// **'🦁 차드 브라더후드? 아니다! ALPHA EMPIRE의 황제에게 경배하라, 만삣삐! 🦁'**
  String get motivationMessage10;

  /// 동기부여 메시지 2
  ///
  /// In ko, this message translates to:
  /// **'⚡ 차드처럼 정복하고, 시그마처럼 지배하라! 휴식도 전략이다 ⚡'**
  String get motivationMessage2;

  /// 동기부여 메시지 3
  ///
  /// In ko, this message translates to:
  /// **'💪 모든 푸시업이 너를 GOD TIER로 끌어올린다, 만삣삐! 💪'**
  String get motivationMessage3;

  /// 동기부여 메시지 4
  ///
  /// In ko, this message translates to:
  /// **'⚡ 차드 에너지 100% 충전 완료! 이제 세상을 평정하라! ⚡'**
  String get motivationMessage4;

  /// 동기부여 메시지 5
  ///
  /// In ko, this message translates to:
  /// **'🚀 차드 진화가 아니다! 이제 LEGEND TRANSFORMATION이다, FXXK YEAH! 🚀'**
  String get motivationMessage5;

  /// 동기부여 메시지 6
  ///
  /// In ko, this message translates to:
  /// **'👑 차드 모드? 그딴 건 지났다. 지금은 EMPEROR MODE: ACTIVATED! 👑'**
  String get motivationMessage6;

  /// 동기부여 메시지 7
  ///
  /// In ko, this message translates to:
  /// **'🌪️ 이렇게 전설들이 탄생한다, 만삣삐! 역사가 너를 기억할 것이다! 🌪️'**
  String get motivationMessage7;

  /// 동기부여 메시지 8
  ///
  /// In ko, this message translates to:
  /// **'⚡ 차드 파워가 아니다... 이제 ALPHA LIGHTNING이 몸을 관통한다! ⚡'**
  String get motivationMessage8;

  /// 동기부여 메시지 9
  ///
  /// In ko, this message translates to:
  /// **'🔱 차드 변신 완료! 이제 ULTIMATE APEX PREDATOR로 진화했다! 🔱'**
  String get motivationMessage9;

  /// 동기부여 메시지 설정
  ///
  /// In ko, this message translates to:
  /// **'동기부여 메시지'**
  String get motivationMessages;

  /// 동기부여 메시지 설명
  ///
  /// In ko, this message translates to:
  /// **'운동 중 동기부여 메시지 표시'**
  String get motivationMessagesDesc;

  /// 목표 80% 이상시 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'포기? 그건 약자나 하는 거야. 더 강하게, 만삣삐! 🔱💪'**
  String get motivationStrong;

  /// 온보딩 진화 설명
  ///
  /// In ko, this message translates to:
  /// **'14주 동안 Chad와 함께 진화!\n\n💪 매주 레벨업 → Level 1~14\n\n마지막에는 GOD CHAD 등극! 👑'**
  String get onboardingChadEvolutionDescription;

  /// 온보딩 진화 제목
  ///
  /// In ko, this message translates to:
  /// **'14주 Chad 진화 🚀'**
  String get onboardingChadEvolutionTitle;

  /// 완벽한 Chad 경험 설명
  ///
  /// In ko, this message translates to:
  /// **'설정을 조정하여 완벽한 Chad 경험을 만들어보세요'**
  String get perfectChadExperience;

  /// 목표 80% 버튼
  ///
  /// In ko, this message translates to:
  /// **'👑 EMPEROR 여유 👑'**
  String get quickInputStrong;

  /// Legendary rarity level
  ///
  /// In ko, this message translates to:
  /// **'레전더리'**
  String get rarityLegendary;

  /// 총 푸시업 부제목
  ///
  /// In ko, this message translates to:
  /// **'진짜 강자 파워!'**
  String get realChadPower;

  /// Rising Chad title
  ///
  /// In ko, this message translates to:
  /// **'Rising Chad'**
  String get risingChad;

  /// Rookie Chad title
  ///
  /// In ko, this message translates to:
  /// **'Rookie Chad'**
  String get rookieChad;

  /// Sigma Chad title
  ///
  /// In ko, this message translates to:
  /// **'Sigma Chad'**
  String get sigmaChad;

  /// 전략적 차드 모드 제목
  ///
  /// In ko, this message translates to:
  /// **'⭐ 전략적 차드 모드 (월수금)'**
  String get strategicChadMode;

  /// 여정 응원 메시지
  ///
  /// In ko, this message translates to:
  /// **'너의 여정을 응원한다! 🔥'**
  String get supportChadJourney;

  /// 진정한 기가차드 완성 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥💀 진정한 기가차드 완성! ALPHA EMPEROR! 💀🔥'**
  String get trueGigaChad;

  /// 기본 푸시업 튜토리얼 조언
  ///
  /// In ko, this message translates to:
  /// **'기본이 제일 중요하다, 만삣삐!'**
  String get tutorialAdviceBasic;

  /// 꾸준함 튜토리얼 조언
  ///
  /// In ko, this message translates to:
  /// **'꾸준함이 차드 파워의 열쇠다!'**
  String get tutorialAdviceConsistency;

  /// 시작 튜토리얼 조언
  ///
  /// In ko, this message translates to:
  /// **'시작이 반이다!'**
  String get tutorialAdviceStart;

  /// Ultra Chad title
  ///
  /// In ko, this message translates to:
  /// **'Ultra Chad'**
  String get ultraChad;

  /// 직장인 차드 모드 제목
  ///
  /// In ko, this message translates to:
  /// **'💼 직장인 차드 모드 (월~금)'**
  String get workerChadMode;

  /// No description provided for @finalEvolutionComplete.
  ///
  /// In ko, this message translates to:
  /// **'최종 진화 완료!'**
  String get finalEvolutionComplete;

  /// Weeks until evolution
  ///
  /// In ko, this message translates to:
  /// **'{weeks}주 후 진화'**
  String weeksToEvolve(int weeks);

  /// No description provided for @readyToEvolve.
  ///
  /// In ko, this message translates to:
  /// **'진화 준비 완료!'**
  String get readyToEvolve;

  /// No description provided for @currentLevel.
  ///
  /// In ko, this message translates to:
  /// **'현재 레벨'**
  String get currentLevel;

  /// No description provided for @selectTodayCondition.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 컨디션을 선택하세요'**
  String get selectTodayCondition;

  /// No description provided for @todayCondition.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 컨디션'**
  String get todayCondition;

  /// No description provided for @chadRecommendedWorkout.
  ///
  /// In ko, this message translates to:
  /// **'차드 추천 운동'**
  String get chadRecommendedWorkout;

  /// No description provided for @chadJourneyTagline.
  ///
  /// In ko, this message translates to:
  /// **'차드가 되는 여정에 함께하라! 🔥'**
  String get chadJourneyTagline;

  /// No description provided for @titleTomorrowChadActivity.
  ///
  /// In ko, this message translates to:
  /// **'내일의 차드 활동'**
  String get titleTomorrowChadActivity;

  /// No description provided for @conditionVeryTired.
  ///
  /// In ko, this message translates to:
  /// **'매우 피곤'**
  String get conditionVeryTired;

  /// No description provided for @conditionGood.
  ///
  /// In ko, this message translates to:
  /// **'좋음'**
  String get conditionGood;

  /// No description provided for @conditionStrong.
  ///
  /// In ko, this message translates to:
  /// **'강함'**
  String get conditionStrong;

  /// No description provided for @conditionSweaty.
  ///
  /// In ko, this message translates to:
  /// **'땀남'**
  String get conditionSweaty;

  /// No description provided for @conditionOnFire.
  ///
  /// In ko, this message translates to:
  /// **'불타는 중'**
  String get conditionOnFire;

  /// No description provided for @chadGreeting.
  ///
  /// In ko, this message translates to:
  /// **'안녕 Bro! Chad야! 💪'**
  String get chadGreeting;

  /// No description provided for @howIsYourConditionToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 컨디션은 어때?'**
  String get howIsYourConditionToday;

  /// No description provided for @chadWillMatchWorkoutIntensityForWeightLoss.
  ///
  /// In ko, this message translates to:
  /// **'체중감량을 위해 Chad가 최적의 운동 강도를 맞춰줄게!'**
  String get chadWillMatchWorkoutIntensityForWeightLoss;

  /// No description provided for @chadWillCreatePerfectRoutineForMuscleGain.
  ///
  /// In ko, this message translates to:
  /// **'근육 증가를 위해 Chad가 완벽한 루틴을 짜줄게!'**
  String get chadWillCreatePerfectRoutineForMuscleGain;

  /// No description provided for @chadWillMakeCustomPlanForEndurance.
  ///
  /// In ko, this message translates to:
  /// **'체력 향상을 위해 Chad가 맞춤 계획 세워줄게!'**
  String get chadWillMakeCustomPlanForEndurance;

  /// No description provided for @chadWillRecommendWorkoutForYou.
  ///
  /// In ko, this message translates to:
  /// **'Chad가 너에게 맞는 운동을 추천해줄게!'**
  String get chadWillRecommendWorkoutForYou;

  /// No description provided for @pleaseCheckYourCondition.
  ///
  /// In ko, this message translates to:
  /// **'컨디션을 체크해줘!'**
  String get pleaseCheckYourCondition;

  /// No description provided for @needRestChadRecommendsStretching.
  ///
  /// In ko, this message translates to:
  /// **'휴식이 필요해 보이네!\nChad가 가벼운 스트레칭 추천해줄게! 🧘‍♂️'**
  String get needRestChadRecommendsStretching;

  /// No description provided for @goodConditionLetsBurnCalories.
  ///
  /// In ko, this message translates to:
  /// **'좋은 컨디션이야!\nChad와 칼로리 태우러 가자! 🔥'**
  String get goodConditionLetsBurnCalories;

  /// No description provided for @perfectConditionLetsBuildMuscle.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 상태네!\nChad와 근육 만들러 가자! 💪'**
  String get perfectConditionLetsBuildMuscle;

  /// No description provided for @goodConditionLetsWorkout.
  ///
  /// In ko, this message translates to:
  /// **'좋은 컨디션이야!\nChad와 운동하러 가자!'**
  String get goodConditionLetsWorkout;

  /// No description provided for @lookingVeryStrongChadPreparedStrongerWorkout.
  ///
  /// In ko, this message translates to:
  /// **'엄청 강해 보이는데?\nChad도 더 강한 운동 준비했어! 🚀'**
  String get lookingVeryStrongChadPreparedStrongerWorkout;

  /// No description provided for @alreadySweatyChadWillShortWarmup.
  ///
  /// In ko, this message translates to:
  /// **'이미 땀이 나고 있네!\nChad가 워밍업은 짧게 갈게! 🏃‍♂️'**
  String get alreadySweatyChadWillShortWarmup;

  /// No description provided for @totallyOnFireChadBeastMode.
  ///
  /// In ko, this message translates to:
  /// **'완전 불타고 있네!\nChad도 Beast Mode로 갈게! 🔥💪'**
  String get totallyOnFireChadBeastMode;

  /// No description provided for @pleaseCheckConditionFirst.
  ///
  /// In ko, this message translates to:
  /// **'컨디션을 먼저 체크해줘!'**
  String get pleaseCheckConditionFirst;

  /// No description provided for @chadActiveRecovery.
  ///
  /// In ko, this message translates to:
  /// **'🧘‍♂️ Chad 액티브 리커버리\n• 가벼운 스트레칭 10분\n• 심호흡 운동\n• 충분한 휴식'**
  String get chadActiveRecovery;

  /// No description provided for @chadBasicRoutine.
  ///
  /// In ko, this message translates to:
  /// **'🎯 Chad 기본 루틴\n• 워밍업 5분\n• 푸시업 기본 세트\n• 마무리 스트레칭'**
  String get chadBasicRoutine;

  /// No description provided for @chadIntermediateRoutine.
  ///
  /// In ko, this message translates to:
  /// **'💪 Chad 중급 루틴\n• 워밍업 5분\n• 푸시업 강화 세트\n• 코어 운동 추가'**
  String get chadIntermediateRoutine;

  /// No description provided for @chadAdvancedRoutine.
  ///
  /// In ko, this message translates to:
  /// **'🚀 Chad 고급 루틴\n• 워밍업 10분\n• 푸시업 고강도 세트\n• 전신 운동 포함'**
  String get chadAdvancedRoutine;

  /// No description provided for @chadPowerRoutine.
  ///
  /// In ko, this message translates to:
  /// **'💪 Chad 파워 루틴\n• 기본 루틴 + 20% 추가\n• 새로운 변형 동작\n• 강도 업그레이드'**
  String get chadPowerRoutine;

  /// No description provided for @chadQuickStart.
  ///
  /// In ko, this message translates to:
  /// **'🏃‍♂️ Chad 빠른 시작\n• 워밍업 단축\n• 바로 메인 운동\n• 효율적인 루틴'**
  String get chadQuickStart;

  /// No description provided for @chadBeastMode.
  ///
  /// In ko, this message translates to:
  /// **'🔥 Chad Beast Mode\n• 최고 강도 운동\n• 도전적인 목표\n• 한계 돌파 세션'**
  String get chadBeastMode;

  /// No description provided for @dreamSpiritStage0Name.
  ///
  /// In ko, this message translates to:
  /// **'꿈꾸는 초심자'**
  String get dreamSpiritStage0Name;

  /// No description provided for @dreamSpiritStage1Name.
  ///
  /// In ko, this message translates to:
  /// **'자각하는 꿈꾸는 자'**
  String get dreamSpiritStage1Name;

  /// No description provided for @dreamSpiritStage2Name.
  ///
  /// In ko, this message translates to:
  /// **'각성된 꿈꾸는 자'**
  String get dreamSpiritStage2Name;

  /// No description provided for @dreamSpiritStage3Name.
  ///
  /// In ko, this message translates to:
  /// **'집중하는 꿈꾸는 자'**
  String get dreamSpiritStage3Name;

  /// No description provided for @dreamSpiritStage4Name.
  ///
  /// In ko, this message translates to:
  /// **'자신감 있는 자각몽가'**
  String get dreamSpiritStage4Name;

  /// No description provided for @dreamSpiritStage5Name.
  ///
  /// In ko, this message translates to:
  /// **'쿨한 자각몽 마스터'**
  String get dreamSpiritStage5Name;

  /// No description provided for @dreamSpiritStage6Name.
  ///
  /// In ko, this message translates to:
  /// **'기쁜 꿈 걷는 자'**
  String get dreamSpiritStage6Name;

  /// No description provided for @dreamSpiritStage7Name.
  ///
  /// In ko, this message translates to:
  /// **'카리스마 넘치는 꿈꾸는 자'**
  String get dreamSpiritStage7Name;

  /// No description provided for @dreamSpiritStage8Name.
  ///
  /// In ko, this message translates to:
  /// **'집중된 꿈 마스터'**
  String get dreamSpiritStage8Name;

  /// No description provided for @dreamSpiritStage9Name.
  ///
  /// In ko, this message translates to:
  /// **'강력한 자각몽가'**
  String get dreamSpiritStage9Name;

  /// No description provided for @dreamSpiritStage10Name.
  ///
  /// In ko, this message translates to:
  /// **'고급 꿈 통제자'**
  String get dreamSpiritStage10Name;

  /// No description provided for @dreamSpiritStage11Name.
  ///
  /// In ko, this message translates to:
  /// **'빛나는 꿈 마스터'**
  String get dreamSpiritStage11Name;

  /// No description provided for @dreamSpiritStage12Name.
  ///
  /// In ko, this message translates to:
  /// **'쌍둥이 꿈 걷는 자'**
  String get dreamSpiritStage12Name;

  /// No description provided for @dreamSpiritStage13Name.
  ///
  /// In ko, this message translates to:
  /// **'삼위일체 꿈 마스터'**
  String get dreamSpiritStage13Name;

  /// No description provided for @dreamSpiritStage14Name.
  ///
  /// In ko, this message translates to:
  /// **'꿈의 신'**
  String get dreamSpiritStage14Name;

  /// No description provided for @dreamSpiritStage0Desc.
  ///
  /// In ko, this message translates to:
  /// **'자각몽 여정을 막 시작했습니다'**
  String get dreamSpiritStage0Desc;

  /// No description provided for @dreamSpiritStage1Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈을 인식하기 시작합니다'**
  String get dreamSpiritStage1Desc;

  /// No description provided for @dreamSpiritStage2Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈의 세계에서 각성 상태를 유지합니다'**
  String get dreamSpiritStage2Desc;

  /// No description provided for @dreamSpiritStage3Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈의 자각에 집중합니다'**
  String get dreamSpiritStage3Desc;

  /// No description provided for @dreamSpiritStage4Desc.
  ///
  /// In ko, this message translates to:
  /// **'자신감 있게 자각몽을 경험합니다'**
  String get dreamSpiritStage4Desc;

  /// No description provided for @dreamSpiritStage5Desc.
  ///
  /// In ko, this message translates to:
  /// **'스타일리시하게 자각몽 기법을 마스터합니다'**
  String get dreamSpiritStage5Desc;

  /// No description provided for @dreamSpiritStage6Desc.
  ///
  /// In ko, this message translates to:
  /// **'기쁨과 함께 꿈을 걸어갑니다'**
  String get dreamSpiritStage6Desc;

  /// No description provided for @dreamSpiritStage7Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈의 영역에서 압도적인 존재감을 보입니다'**
  String get dreamSpiritStage7Desc;

  /// No description provided for @dreamSpiritStage8Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈 마스터리에 완벽히 집중합니다'**
  String get dreamSpiritStage8Desc;

  /// No description provided for @dreamSpiritStage9Desc.
  ///
  /// In ko, this message translates to:
  /// **'강력한 자각몽 능력을 휘두릅니다'**
  String get dreamSpiritStage9Desc;

  /// No description provided for @dreamSpiritStage10Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈 시나리오를 고급스럽게 제어합니다'**
  String get dreamSpiritStage10Desc;

  /// No description provided for @dreamSpiritStage11Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈 탐험에서 빛나는 숙달을 보여줍니다'**
  String get dreamSpiritStage11Desc;

  /// No description provided for @dreamSpiritStage12Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈에서 쌍둥이 길을 걷습니다'**
  String get dreamSpiritStage12Desc;

  /// No description provided for @dreamSpiritStage13Desc.
  ///
  /// In ko, this message translates to:
  /// **'삼위일체 꿈 자각을 달성했습니다'**
  String get dreamSpiritStage13Desc;

  /// No description provided for @dreamSpiritStage14Desc.
  ///
  /// In ko, this message translates to:
  /// **'꿈 영역의 궁극적 마스터입니다'**
  String get dreamSpiritStage14Desc;

  /// No description provided for @dreamSpiritStage0Unlock.
  ///
  /// In ko, this message translates to:
  /// **'🌟 드림 스피릿이 각성했습니다! 자각몽 여정이 지금 시작됩니다!'**
  String get dreamSpiritStage0Unlock;

  /// No description provided for @dreamSpiritStage1Unlock.
  ///
  /// In ko, this message translates to:
  /// **'✨ 축하합니다! 자각하는 꿈꾸는 자가 되었습니다! 연습을 계속하세요!'**
  String get dreamSpiritStage1Unlock;

  /// No description provided for @dreamSpiritStage2Unlock.
  ///
  /// In ko, this message translates to:
  /// **'🎯 놀라워요! 이제 각성된 꿈꾸는 자입니다! 자각력이 성장하고 있어요!'**
  String get dreamSpiritStage2Unlock;

  /// No description provided for @dreamSpiritStage3Unlock.
  ///
  /// In ko, this message translates to:
  /// **'🔥 잘하셨어요! 집중하는 꿈꾸는 자로 진화했습니다! 계속 집중하세요!'**
  String get dreamSpiritStage3Unlock;

  /// No description provided for @dreamSpiritStage4Unlock.
  ///
  /// In ko, this message translates to:
  /// **'💪 인상적이에요! 이제 자신감 있는 자각몽가입니다! 실력이 향상되고 있어요!'**
  String get dreamSpiritStage4Unlock;

  /// No description provided for @dreamSpiritStage5Unlock.
  ///
  /// In ko, this message translates to:
  /// **'😎 멋져요! 쿨한 자각몽 마스터가 되었습니다! 기법을 마스터하고 있어요!'**
  String get dreamSpiritStage5Unlock;

  /// No description provided for @dreamSpiritStage6Unlock.
  ///
  /// In ko, this message translates to:
  /// **'🌈 환상적이에요! 이제 기쁜 꿈 걷는 자입니다! 꿈의 세계를 포용하세요!'**
  String get dreamSpiritStage6Unlock;

  /// No description provided for @dreamSpiritStage7Unlock.
  ///
  /// In ko, this message translates to:
  /// **'⭐ 놀라워요! 카리스마 넘치는 꿈꾸는 자로 진화했습니다! 존재감이 강력해요!'**
  String get dreamSpiritStage7Unlock;

  /// No description provided for @dreamSpiritStage8Unlock.
  ///
  /// In ko, this message translates to:
  /// **'🎓 탁월해요! 이제 집중된 꿈 마스터입니다! 완벽한 숙달이 가까워졌어요!'**
  String get dreamSpiritStage8Unlock;

  /// No description provided for @dreamSpiritStage9Unlock.
  ///
  /// In ko, this message translates to:
  /// **'⚡ 믿을 수 없어요! 강력한 자각몽가가 되었습니다! 능력이 비범해요!'**
  String get dreamSpiritStage9Unlock;

  /// No description provided for @dreamSpiritStage10Unlock.
  ///
  /// In ko, this message translates to:
  /// **'🏆 뛰어나요! 이제 고급 꿈 통제자입니다! 꿈을 지배하고 있어요!'**
  String get dreamSpiritStage10Unlock;

  /// No description provided for @dreamSpiritStage11Unlock.
  ///
  /// In ko, this message translates to:
  /// **'💎 빛나요! 빛나는 꿈 마스터로 진화했습니다! 숙달이 찬란하게 빛나요!'**
  String get dreamSpiritStage11Unlock;

  /// No description provided for @dreamSpiritStage12Unlock.
  ///
  /// In ko, this message translates to:
  /// **'🌟🌟 경이로워요! 이제 쌍둥이 꿈 걷는 자입니다! 여러 꿈의 길을 걷고 있어요!'**
  String get dreamSpiritStage12Unlock;

  /// No description provided for @dreamSpiritStage13Unlock.
  ///
  /// In ko, this message translates to:
  /// **'👑 장엄해요! 삼위일체 꿈 마스터를 달성했습니다! 꿈의 삼위일체가 당신의 것이에요!'**
  String get dreamSpiritStage13Unlock;

  /// No description provided for @dreamSpiritStage14Unlock.
  ///
  /// In ko, this message translates to:
  /// **'🌌 전설이에요! 꿈의 신으로 승천했습니다! 궁극적 마스터리를 달성했어요!'**
  String get dreamSpiritStage14Unlock;

  /// No description provided for @currentSubscription.
  ///
  /// In ko, this message translates to:
  /// **'현재 구독'**
  String get currentSubscription;

  /// No description provided for @freeUsing.
  ///
  /// In ko, this message translates to:
  /// **'무료 사용 중'**
  String get freeUsing;

  /// No description provided for @premiumActive.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구독 활성'**
  String get premiumActive;

  /// 과학적 팩트 10번 설명
  ///
  /// In ko, this message translates to:
  /// **'심박출량 증가는 운동 능력뿜만 아니라 일상 활동의 질도 향상시킵니다.'**
  String get scientificFact10Explanation;

  /// 과학적 팩트 11번 설명
  ///
  /// In ko, this message translates to:
  /// **'새로운 혈관 형성으로 영양소와 산소 공급이 극대화된다.'**
  String get scientificFact11Explanation;

  /// 과학적 팩트 12번 설명
  ///
  /// In ko, this message translates to:
  /// **'혈관 탄성 개선과 말초 저항 감소로 건강한 혈압이 유지된다.'**
  String get scientificFact12Explanation;

  /// 과학적 팩트 13번 설명
  ///
  /// In ko, this message translates to:
  /// **'높은 심박변이도는 자율신경계의 건강한 균형을 나타냅니다.'**
  String get scientificFact13Explanation;

  /// 과학적 팩트 14번 설명
  ///
  /// In ko, this message translates to:
  /// **'건강한 내피세포는 혈관 확장과 항염 작용을 통해 심혈관 질환을 예방한다.'**
  String get scientificFact14Explanation;

  /// 과학적 팩트 15번 설명
  ///
  /// In ko, this message translates to:
  /// **'근육량 증가로 인해 안정 시에도 더 많은 에너지를 소모한다.'**
  String get scientificFact15Explanation;

  /// 과학적 팩트 16번 설명
  ///
  /// In ko, this message translates to:
  /// **'근육의 포도당 흡수 증가로 자연스러운 혈당 관리가 가능해집니다.'**
  String get scientificFact16Explanation;

  /// 과학적 팩트 17번 설명
  ///
  /// In ko, this message translates to:
  /// **'효소 활성 증가로 지방이 에너지원으로 더 효율적으로 사용된다.'**
  String get scientificFact17Explanation;

  /// 과학적 팩트 18번 설명
  ///
  /// In ko, this message translates to:
  /// **'갈색지방은 칼로리를 열로 직접 변환하여 체중 감량에 도움을 줍니다.'**
  String get scientificFact18Explanation;

  /// 과학적 팩트 19번 설명
  ///
  /// In ko, this message translates to:
  /// **'EPOC 효과로 운동이 끝난 후에도 지속적인 에너지 소모가 일어납니다.'**
  String get scientificFact19Explanation;

  /// 과학적 팩트 1 설명
  ///
  /// In ko, this message translates to:
  /// **'근섬유 타입 변환은 약 6-8주 후부터 시작되며, 최대 30% 증가할 수 있다.'**
  String get scientificFact1Explanation;

  /// 과학적 팩트 20번 설명
  ///
  /// In ko, this message translates to:
  /// **'성장호르몬은 근육 성장, 지방 분해, 조직 회복의 핵심 호르몬이다.'**
  String get scientificFact20Explanation;

  /// 과학적 팩트 21번 설명
  ///
  /// In ko, this message translates to:
  /// **'동조화된 운동 단위는 더 큰 힘을 더 효율적으로 생성한다.'**
  String get scientificFact21Explanation;

  /// 과학적 팩트 22번 설명
  ///
  /// In ko, this message translates to:
  /// **'운동으로 인한 신경가소성 증가는 인지 기능 전반의 향상을 가져옵니다.'**
  String get scientificFact22Explanation;

  /// 과학적 팩트 23번 설명
  ///
  /// In ko, this message translates to:
  /// **'BDNF는 뇌의 비료라고 불리며, 새로운 신경 연결을 촉진한다.'**
  String get scientificFact23Explanation;

  /// 과학적 팩트 24번 설명
  ///
  /// In ko, this message translates to:
  /// **'미엘린초의 두께 증가로 신경 신호 전달이 빨라집니다.'**
  String get scientificFact24Explanation;

  /// 과학적 팩트 25번 설명
  ///
  /// In ko, this message translates to:
  /// **'인터뉴런의 정교한 조절로 무의식적으로도 완벽한 자세가 가능해집니다.'**
  String get scientificFact25Explanation;

  /// 과학적 팩트 2 설명
  ///
  /// In ko, this message translates to:
  /// **'미토콘드리아는 세포의 발전소로, 증가하면 피로도가 현저히 감소한다.'**
  String get scientificFact2Explanation;

  /// 과학적 팩트 3번 설명
  ///
  /// In ko, this message translates to:
  /// **'mTOR은 근육 단백질 합성의 마스터 조절자로, 활성화되면 폭발적 성장을 유도한다.'**
  String get scientificFact3Explanation;

  /// 과학적 팩트 4번 설명
  ///
  /// In ko, this message translates to:
  /// **'근섬유 핵이 증가하면 평생 동안 근육 성장의 템플릿이 된다.'**
  String get scientificFact4Explanation;

  /// 과학적 팩트 5번 설명
  ///
  /// In ko, this message translates to:
  /// **'동조화된 운동 단위는 더 큰 힘을 더 효율적으로 생성한다.'**
  String get scientificFact5Explanation;

  /// 과학적 팩트 6번 설명
  ///
  /// In ko, this message translates to:
  /// **'운동으로 인한 신경가소성 증가는 인지 기능 전반의 향상을 가져옵니다.'**
  String get scientificFact6Explanation;

  /// 과학적 팩트 7번 설명
  ///
  /// In ko, this message translates to:
  /// **'BDNF는 뇌의 비료라고 불리며, 새로운 신경 연결을 촉진한다.'**
  String get scientificFact7Explanation;

  /// 과학적 팩트 8번 설명
  ///
  /// In ko, this message translates to:
  /// **'빠른 신경 전달은 일상생활에서 빠르고 정확한 반응을 가능하게 한다.'**
  String get scientificFact8Explanation;

  /// 과학적 팩트 9번 설명
  ///
  /// In ko, this message translates to:
  /// **'인터뉴런의 정교한 조절로 무의식적으로도 완벽한 자세가 가능해집니다.'**
  String get scientificFact9Explanation;

  /// No description provided for @subscriptionExpiringSoon.
  ///
  /// In ko, this message translates to:
  /// **'구독이 곧 만료됩니다. 갱신하시겠습니까?'**
  String get subscriptionExpiringSoon;

  /// No description provided for @subscriptionManagement.
  ///
  /// In ko, this message translates to:
  /// **'구독 관리'**
  String get subscriptionManagement;

  /// No description provided for @freeTrialDaysRemaining.
  ///
  /// In ko, this message translates to:
  /// **'무료 체험 {days}일 남음'**
  String freeTrialDaysRemaining(Object days);

  /// No description provided for @allWorkoutProgramsAvailable.
  ///
  /// In ko, this message translates to:
  /// **'모든 운동 프로그램 이용 가능'**
  String get allWorkoutProgramsAvailable;

  /// No description provided for @premium.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄'**
  String get premium;

  /// No description provided for @promotion.
  ///
  /// In ko, this message translates to:
  /// **'프로모션'**
  String get promotion;

  /// No description provided for @free.
  ///
  /// In ko, this message translates to:
  /// **'무료'**
  String get free;

  /// No description provided for @freePlan.
  ///
  /// In ko, this message translates to:
  /// **'무료 플랜'**
  String get freePlan;

  /// No description provided for @launchPromotion.
  ///
  /// In ko, this message translates to:
  /// **'런칭 프로모션'**
  String get launchPromotion;

  /// No description provided for @premiumMonthly.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 (₩4,900/월)'**
  String get premiumMonthly;

  /// No description provided for @statusActive.
  ///
  /// In ko, this message translates to:
  /// **'활성'**
  String get statusActive;

  /// No description provided for @statusExpired.
  ///
  /// In ko, this message translates to:
  /// **'만료됨'**
  String get statusExpired;

  /// No description provided for @statusCancelled.
  ///
  /// In ko, this message translates to:
  /// **'취소됨'**
  String get statusCancelled;

  /// No description provided for @statusTrial.
  ///
  /// In ko, this message translates to:
  /// **'체험중'**
  String get statusTrial;

  /// No description provided for @unlimited.
  ///
  /// In ko, this message translates to:
  /// **'무제한'**
  String get unlimited;

  /// No description provided for @planLabel.
  ///
  /// In ko, this message translates to:
  /// **'플랜'**
  String get planLabel;

  /// No description provided for @statusLabel.
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get statusLabel;

  /// No description provided for @startDate.
  ///
  /// In ko, this message translates to:
  /// **'시작일'**
  String get startDate;

  /// No description provided for @expiryDate.
  ///
  /// In ko, this message translates to:
  /// **'만료일'**
  String get expiryDate;

  /// No description provided for @autoRenewalEnabled.
  ///
  /// In ko, this message translates to:
  /// **'자동 갱신 활성화'**
  String get autoRenewalEnabled;

  /// No description provided for @btnStartFree.
  ///
  /// In ko, this message translates to:
  /// **'무료로 시작하기'**
  String get btnStartFree;

  /// No description provided for @btnStartSubscription.
  ///
  /// In ko, this message translates to:
  /// **'구독 시작하기'**
  String get btnStartSubscription;

  /// No description provided for @msgCannotStartPurchase.
  ///
  /// In ko, this message translates to:
  /// **'구매를 시작할 수 없습니다.'**
  String get msgCannotStartPurchase;

  /// No description provided for @msgLoadingSubscription.
  ///
  /// In ko, this message translates to:
  /// **'구독 상품을 불러오는 중...'**
  String get msgLoadingSubscription;

  /// No description provided for @msgSubscriptionSuccess.
  ///
  /// In ko, this message translates to:
  /// **'구독이 성공적으로 완료되었습니다!'**
  String get msgSubscriptionSuccess;

  /// No description provided for @titleManageSubscription.
  ///
  /// In ko, this message translates to:
  /// **'구독 관리'**
  String get titleManageSubscription;

  /// No description provided for @titlePremiumFeatures.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 기능'**
  String get titlePremiumFeatures;

  /// No description provided for @titlePremiumSubscription.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구독'**
  String get titlePremiumSubscription;

  /// VIP 환영 다이얼로그 프리미엄 회원 타이틀
  ///
  /// In ko, this message translates to:
  /// **'✨ 프리미엄 회원'**
  String get vipWelcomePremiumMember;

  /// VIP 환영 다이얼로그 런칭 프로모션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'🎉 런칭 프로모션'**
  String get vipWelcomeLaunchPromo;

  /// VIP 환영 다이얼로그 무료 회원 타이틀
  ///
  /// In ko, this message translates to:
  /// **'👋 무료 회원'**
  String get vipWelcomeFreeMember;

  /// VIP 빠른 로딩 배지
  ///
  /// In ko, this message translates to:
  /// **'VIP 10배 빠른 로딩'**
  String get vipFastLoading;

  /// Adaptive theme setting
  ///
  /// In ko, this message translates to:
  /// **'적응형 테마'**
  String get adaptiveTheme;

  /// Adaptive theme description
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정에 따라 자동으로 변경'**
  String get adaptiveThemeDesc;

  /// Allow notification permission button
  ///
  /// In ko, this message translates to:
  /// **'알림 권한 허용하기'**
  String get allowNotificationPermission;

  /// No description provided for @allowNotifications.
  ///
  /// In ko, this message translates to:
  /// **'🔔 알림 허용'**
  String get allowNotifications;

  /// Basic notification permission
  ///
  /// In ko, this message translates to:
  /// **'기본 알림 권한'**
  String get basicNotificationPermission;

  /// Color theme setting
  ///
  /// In ko, this message translates to:
  /// **'색상 테마'**
  String get colorTheme;

  /// 현재 언어 표시
  ///
  /// In ko, this message translates to:
  /// **'현재: {language}'**
  String currentLanguage(String language);

  /// 매일 알림 모드 변경 메시지
  ///
  /// In ko, this message translates to:
  /// **'매일 알림 모드로 변경! 매일 알림 받아요! 📱'**
  String get dailyNotificationModeChanged;

  /// 영어 언어명
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Exact notification permission
  ///
  /// In ko, this message translates to:
  /// **'정확한 알림 권한'**
  String get exactNotificationPermission;

  /// 한국어 언어명
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get koreanLanguage;

  /// 언어 변경 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'언어 변경! -> {language} 💪'**
  String languageChanged(String language);

  /// 언어 설정 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'언어 설정 기능은 준비 중이다'**
  String get languageComingSoon;

  /// No description provided for @notificationActivationMessage.
  ///
  /// In ko, this message translates to:
  /// **'💪 알림 활성화!\n바로 설정하자! FXXK THE EXCUSES! 💪'**
  String get notificationActivationMessage;

  /// No description provided for @notificationActivationTitle.
  ///
  /// In ko, this message translates to:
  /// **'🔥 LUCID DREAM 100 알림 활성화! 🔥'**
  String get notificationActivationTitle;

  /// Checking permission status message
  ///
  /// In ko, this message translates to:
  /// **'알림 권한 상태를 확인하고 있다'**
  String get notificationPermissionCheckingStatus;

  /// 알림 권한 거부 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 알림 권한 필요! 설정에서 허용! 💪'**
  String get notificationPermissionDeniedMessage;

  /// 알림 권한 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'권한 요청 중 오류 발생!'**
  String get notificationPermissionErrorMessage;

  /// 알림 권한 기능 목록
  ///
  /// In ko, this message translates to:
  /// **'• 연습 리마인더\n• 업적 달성 알림\n• 동기부여 메시지'**
  String get notificationPermissionFeatures;

  /// 알림 권한 허용 메시지
  ///
  /// In ko, this message translates to:
  /// **'✅ 알림 권한 허용! 💪'**
  String get notificationPermissionGranted;

  /// 알림 권한 허용 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎉 알림 권한 허용 완료! 여정 시작! 💪'**
  String get notificationPermissionGrantedMessage;

  /// 알림 권한 나중에 설정 메시지
  ///
  /// In ko, this message translates to:
  /// **'나중에 설정에서 알림을 허용할 수 있다.'**
  String get notificationPermissionLaterMessage;

  /// 알림 권한 다이얼로그 메시지
  ///
  /// In ko, this message translates to:
  /// **'푸시 알림을 받으려면 알림 권한이 필요한다.'**
  String get notificationPermissionMessage;

  /// Notification permission needed status
  ///
  /// In ko, this message translates to:
  /// **'❌ 알림 권한 필요'**
  String get notificationPermissionNeeded;

  /// Perfect notification permission status
  ///
  /// In ko, this message translates to:
  /// **'알림 권한 완벽!'**
  String get notificationPermissionPerfect;

  /// 알림 권한 요청 메시지
  ///
  /// In ko, this message translates to:
  /// **'설정에서 알림 권한을 허용해주세요.'**
  String get notificationPermissionRequest;

  /// 알림 권한 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🔔 알림 권한 필요'**
  String get notificationPermissionRequired;

  /// 알림 및 저장소 권한 요청 메시지
  ///
  /// In ko, this message translates to:
  /// **'알림 및 저장소 권한이 필요한다. 설정에서 허용해주세요.'**
  String get permissionNotificationMessage;

  /// 푸시 알림 비활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'푸시 알림이 비활성화되었다'**
  String get pushNotificationDisabled;

  /// 푸시 알림 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'푸시 알림이 활성화되었다'**
  String get pushNotificationEnabled;

  /// 푸시 알림 옵션
  ///
  /// In ko, this message translates to:
  /// **'푸시 알림'**
  String get pushNotifications;

  /// 푸시 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'💥 모든 알림을 받아라! 도망칠 곳은 없다!'**
  String get pushNotificationsDesc;

  /// 푸시 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'일반 알림을 받다'**
  String get receiveGeneralNotifications;

  /// 언어 선택 메시지
  ///
  /// In ko, this message translates to:
  /// **'사용할 언어를 선택해주세요'**
  String get selectLanguage;

  /// 테마 색상 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'테마 색상'**
  String get themeColor;

  /// 테마 색상 변경 메시지
  ///
  /// In ko, this message translates to:
  /// **'테마 색상이 {colorName}로 변경되었다'**
  String themeColorChanged(String colorName);

  /// 테마 색상 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'앱의 메인 색상을 변경한다'**
  String get themeColorDesc;

  /// 테마 색상 선택 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'테마 색상 선택'**
  String get themeColorSelection;

  /// 다크 모드 설명
  ///
  /// In ko, this message translates to:
  /// **'어두운 테마를 사용한다'**
  String get useDarkTheme;

  /// No description provided for @settingsHeader.
  ///
  /// In ko, this message translates to:
  /// **'LUCID DREAM 100 설정'**
  String get settingsHeader;

  /// No description provided for @notificationPermissionStatus.
  ///
  /// In ko, this message translates to:
  /// **'알림 권한 상태'**
  String get notificationPermissionStatus;

  /// No description provided for @basicNotificationRequired.
  ///
  /// In ko, this message translates to:
  /// **'기본 알림을 받기 위해 필요합니다'**
  String get basicNotificationRequired;

  /// No description provided for @exactAlarmRequired.
  ///
  /// In ko, this message translates to:
  /// **'정확한 시간에 알림을 받기 위해 필요합니다'**
  String get exactAlarmRequired;

  /// 필수 권한 라벨
  ///
  /// In ko, this message translates to:
  /// **'필수'**
  String get required;

  /// No description provided for @currentMaxRange.
  ///
  /// In ko, this message translates to:
  /// **'현재 최대 {range}'**
  String currentMaxRange(Object range);

  /// No description provided for @workoutNotifications.
  ///
  /// In ko, this message translates to:
  /// **'연습 알림 설정'**
  String get workoutNotifications;

  /// No description provided for @enableWorkoutReminders.
  ///
  /// In ko, this message translates to:
  /// **'연습 알림 받기'**
  String get enableWorkoutReminders;

  /// No description provided for @getRemindersOnWorkoutDays.
  ///
  /// In ko, this message translates to:
  /// **'선택한 연습일에 알림을 받습니다'**
  String get getRemindersOnWorkoutDays;

  /// No description provided for @notificationTime.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간'**
  String get notificationTime;

  /// No description provided for @canChangeInSettingsAnytime.
  ///
  /// In ko, this message translates to:
  /// **'💡 설정 탭에서 언제든지 변경할 수 있습니다'**
  String get canChangeInSettingsAnytime;

  /// No description provided for @selectWorkoutDaysMin3.
  ///
  /// In ko, this message translates to:
  /// **'연습 요일 선택 (최소 3일)'**
  String get selectWorkoutDaysMin3;

  /// Shows selected days count
  ///
  /// In ko, this message translates to:
  /// **'선택된 날짜: {count}일'**
  String selectedDaysCount(int count);

  /// No description provided for @selectedDaysCountEn.
  ///
  /// In ko, this message translates to:
  /// **'Selected days: {count} days'**
  String selectedDaysCountEn(Object count);

  /// No description provided for @followingSystemSettings.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정을 따릅니다'**
  String get followingSystemSettings;

  /// No description provided for @manualSettingsEnabled.
  ///
  /// In ko, this message translates to:
  /// **'수동 설정이 활성화되었습니다'**
  String get manualSettingsEnabled;

  /// No description provided for @selectColorTheme.
  ///
  /// In ko, this message translates to:
  /// **'색상 테마 선택'**
  String get selectColorTheme;

  /// Theme applied message
  ///
  /// In ko, this message translates to:
  /// **'{theme} 테마가 적용되었습니다'**
  String themeApplied(String theme);

  /// No description provided for @themeBlue.
  ///
  /// In ko, this message translates to:
  /// **'블루'**
  String get themeBlue;

  /// No description provided for @themeGreen.
  ///
  /// In ko, this message translates to:
  /// **'그린'**
  String get themeGreen;

  /// No description provided for @themeOrange.
  ///
  /// In ko, this message translates to:
  /// **'오렌지'**
  String get themeOrange;

  /// No description provided for @themePurple.
  ///
  /// In ko, this message translates to:
  /// **'퍼플'**
  String get themePurple;

  /// No description provided for @themeRed.
  ///
  /// In ko, this message translates to:
  /// **'레드'**
  String get themeRed;

  /// Version label
  ///
  /// In ko, this message translates to:
  /// **'버전: {version}'**
  String versionLabel(String version);

  /// Build label
  ///
  /// In ko, this message translates to:
  /// **'빌드: {build}'**
  String buildLabel(String build);

  /// Package label
  ///
  /// In ko, this message translates to:
  /// **'패키지: {package}'**
  String packageLabel(String package);

  /// No description provided for @achieve100Pushups.
  ///
  /// In ko, this message translates to:
  /// **'30일 만에 자각몽 마스터!\n드림 스피릿과 함께하는 여정! 🔥'**
  String get achieve100Pushups;

  /// No description provided for @techStack.
  ///
  /// In ko, this message translates to:
  /// **'기술 스택:'**
  String get techStack;

  /// No description provided for @sqliteDatabase.
  ///
  /// In ko, this message translates to:
  /// **'SQLite 로컬 데이터베이스'**
  String get sqliteDatabase;

  /// No description provided for @providerStateManagement.
  ///
  /// In ko, this message translates to:
  /// **'Provider 상태 관리'**
  String get providerStateManagement;

  /// No description provided for @licenses.
  ///
  /// In ko, this message translates to:
  /// **'라이선스'**
  String get licenses;

  /// No description provided for @feedbackSubject.
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 피드백'**
  String get feedbackSubject;

  /// No description provided for @feedbackBody.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! Lucid Dream 100 앱에 대한 피드백을 보내드립니다.\n\n'**
  String get feedbackBody;

  /// No description provided for @goalAchievementCelebration.
  ///
  /// In ko, this message translates to:
  /// **'• 목표 달성 축하'**
  String get goalAchievementCelebration;

  /// No description provided for @streakMaintenanceReminder.
  ///
  /// In ko, this message translates to:
  /// **'• 연속 기록 유지 알림'**
  String get streakMaintenanceReminder;

  /// No description provided for @allow.
  ///
  /// In ko, this message translates to:
  /// **'허용'**
  String get allow;

  /// No description provided for @storageBackupRestorePermission.
  ///
  /// In ko, this message translates to:
  /// **'연습 데이터 백업/복원을 위해 저장소 접근 권한이 필요합니다.'**
  String get storageBackupRestorePermission;

  /// No description provided for @workoutRecordBackup.
  ///
  /// In ko, this message translates to:
  /// **'• 연습 기록 백업'**
  String get workoutRecordBackup;

  /// No description provided for @android13FilePickerNote.
  ///
  /// In ko, this message translates to:
  /// **'💡 Android 13+에서는 파일 선택기를 사용하므로 이 권한이 필요하지 않습니다.'**
  String get android13FilePickerNote;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In ko, this message translates to:
  /// **'저장소 권한 필요'**
  String get storagePermissionRequired;

  /// No description provided for @storagePermissionNeededForBackup.
  ///
  /// In ko, this message translates to:
  /// **'데이터 백업 및 복원 기능을 사용하려면\n저장소 접근 권한이 필요합니다.\n\n권한을 허용하시겠습니까?'**
  String get storagePermissionNeededForBackup;

  /// No description provided for @grantPermission.
  ///
  /// In ko, this message translates to:
  /// **'권한 허용'**
  String get grantPermission;

  /// No description provided for @permissionRequired.
  ///
  /// In ko, this message translates to:
  /// **'권한 필요'**
  String get permissionRequired;

  /// No description provided for @storagePermissionDeniedMessage.
  ///
  /// In ko, this message translates to:
  /// **'저장소 권한이 거부되었습니다.\n\n백업/복원 기능을 사용하려면 설정에서\n수동으로 권한을 허용해주세요.\n\n설정 > 앱 > Lucid Dream 100 > 권한 > 저장소'**
  String get storagePermissionDeniedMessage;

  /// No description provided for @permissionGranted.
  ///
  /// In ko, this message translates to:
  /// **'허용됨'**
  String get permissionGranted;

  /// No description provided for @permissionDenied.
  ///
  /// In ko, this message translates to:
  /// **'거부됨'**
  String get permissionDenied;

  /// No description provided for @permissionRestricted.
  ///
  /// In ko, this message translates to:
  /// **'제한됨'**
  String get permissionRestricted;

  /// No description provided for @permissionLimited.
  ///
  /// In ko, this message translates to:
  /// **'제한적 허용'**
  String get permissionLimited;

  /// No description provided for @permissionPermanentlyDenied.
  ///
  /// In ko, this message translates to:
  /// **'영구 거부됨'**
  String get permissionPermanentlyDenied;

  /// No description provided for @permissionUnknown.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없음'**
  String get permissionUnknown;

  /// No description provided for @accountSettings.
  ///
  /// In ko, this message translates to:
  /// **'계정 설정'**
  String get accountSettings;

  /// Logout error message
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 중 오류 발생: {error}'**
  String logoutErrorMessage(String error);

  /// No description provided for @languageKorean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @aboutSettingsScientificBasisTitle.
  ///
  /// In ko, this message translates to:
  /// **'과학적 근거'**
  String get aboutSettingsScientificBasisTitle;

  /// No description provided for @aboutSettingsScientificBasisDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로그램의 과학적 연구 출처'**
  String get aboutSettingsScientificBasisDesc;

  /// No description provided for @aboutSettingsAppName.
  ///
  /// In ko, this message translates to:
  /// **'드림플로 (DreamFlow)'**
  String get aboutSettingsAppName;

  /// No description provided for @aboutSettingsPrivacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침'**
  String get aboutSettingsPrivacyPolicy;

  /// No description provided for @aboutSettingsTermsOfService.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get aboutSettingsTermsOfService;

  /// No description provided for @aboutSettingsScientificDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'과학적 근거'**
  String get aboutSettingsScientificDialogTitle;

  /// No description provided for @aboutSettingsResearchDescription.
  ///
  /// In ko, this message translates to:
  /// **'상체 근력 운동은 주 2-3회가 최적이며, 2분 이상 휴식 시 근비대와 근력 증가가 더 효과적입니다.'**
  String get aboutSettingsResearchDescription;

  /// No description provided for @aboutSettingsTrainingGuidelines.
  ///
  /// In ko, this message translates to:
  /// **'훈련 가이드라인'**
  String get aboutSettingsTrainingGuidelines;

  /// No description provided for @aboutSettingsWeeklyFrequency.
  ///
  /// In ko, this message translates to:
  /// **'주당 빈도'**
  String get aboutSettingsWeeklyFrequency;

  /// No description provided for @aboutSettingsWeeklyFrequencyValue.
  ///
  /// In ko, this message translates to:
  /// **'주 2-3회'**
  String get aboutSettingsWeeklyFrequencyValue;

  /// No description provided for @aboutSettingsRestBetweenSets.
  ///
  /// In ko, this message translates to:
  /// **'세트 간 휴식'**
  String get aboutSettingsRestBetweenSets;

  /// No description provided for @aboutSettingsRestBetweenSetsValue.
  ///
  /// In ko, this message translates to:
  /// **'2-3분 (근력), 1-2분 (근비대)'**
  String get aboutSettingsRestBetweenSetsValue;

  /// No description provided for @aboutSettingsRecoveryTime.
  ///
  /// In ko, this message translates to:
  /// **'회복 시간'**
  String get aboutSettingsRecoveryTime;

  /// No description provided for @aboutSettingsRecoveryTimeValue.
  ///
  /// In ko, this message translates to:
  /// **'48-72시간'**
  String get aboutSettingsRecoveryTimeValue;

  /// No description provided for @aboutSettingsProgramExplanation.
  ///
  /// In ko, this message translates to:
  /// **'이 프로그램은 위 연구 논문의 과학적 근거를 바탕으로 설계된 14주 프로그레시브 오버로드 프로그램입니다.'**
  String get aboutSettingsProgramExplanation;

  /// No description provided for @aboutSettingsConfirmButton.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get aboutSettingsConfirmButton;

  /// 자동 백업 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'정기적으로 자동 백업을 수행한다'**
  String get autoBackupDescription;

  /// 자동 백업이 비활성화된 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'자동 백업 비활성화'**
  String get autoBackupDisabledStatus;

  /// 백업 레이블
  ///
  /// In ko, this message translates to:
  /// **'백업'**
  String get backup;

  /// No description provided for @backupActions.
  ///
  /// In ko, this message translates to:
  /// **'백업 작업'**
  String get backupActions;

  /// 백업 완료 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'데이터 백업 성공! ({size}) 💪'**
  String backupCompletedBody(String size);

  /// 백업 완료 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 백업 완료'**
  String get backupCompletedTitle;

  /// 백업 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'백업 완료!\n저장 위치: {path}'**
  String backupCompletedWithPath(String path);

  /// No description provided for @backupCreatedSuccessfully.
  ///
  /// In ko, this message translates to:
  /// **'백업이 성공적으로 생성되었다'**
  String get backupCreatedSuccessfully;

  /// No description provided for @backupCreationError.
  ///
  /// In ko, this message translates to:
  /// **'백업 생성 중 오류 발생: {error}'**
  String backupCreationError(Object error);

  /// No description provided for @backupCreationFailed.
  ///
  /// In ko, this message translates to:
  /// **'백업 생성 실패: {error}'**
  String backupCreationFailed(Object error);

  /// 백업 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'백업 중 오류: {error}'**
  String backupErrorOccurred(String error);

  /// No description provided for @backupExportFailed.
  ///
  /// In ko, this message translates to:
  /// **'백업 내보내기 실패: {error}'**
  String backupExportFailed(Object error);

  /// 백업 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'백업 실패! 다시 시도! 💪'**
  String get backupFailed;

  /// 백업 실패 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'백업 중 오류 발생! 설정 확인! ⚠️'**
  String get backupFailedBody;

  /// 백업 실패 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 백업 실패'**
  String get backupFailedTitle;

  /// 백업 파일명 레이블
  ///
  /// In ko, this message translates to:
  /// **'백업 파일명'**
  String get backupFileName;

  /// No description provided for @backupFileSaved.
  ///
  /// In ko, this message translates to:
  /// **'백업 파일이 저장되었다:\n{filePath}'**
  String backupFileSaved(Object filePath);

  /// 백업 빈도 설정
  ///
  /// In ko, this message translates to:
  /// **'백업 빈도'**
  String get backupFrequency;

  /// Backup management title
  ///
  /// In ko, this message translates to:
  /// **'백업 관리'**
  String get backupManagement;

  /// Backup management description
  ///
  /// In ko, this message translates to:
  /// **'데이터 백업, 복원 및 자동 백업 설정을 관리한다.'**
  String get backupManagementDesc;

  /// 백업 스케줄 중단 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'연속 실패로 인해 자동 백업이 중단되었다.'**
  String get backupScheduleSuspendedBody;

  /// 백업 스케줄 중단 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 백업 중단'**
  String get backupScheduleSuspendedTitle;

  /// No description provided for @backupStatusLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'백업 상태를 불러오는데 실패했다: {error}'**
  String backupStatusLoadFailed(Object error);

  /// 백업 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 백업이 성공적으로 완료되었다'**
  String get backupSuccess;

  /// 백업 대기 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'백업 대기 중'**
  String get backupWaitingStatus;

  /// 백업 생성 버튼
  ///
  /// In ko, this message translates to:
  /// **'백업 생성'**
  String get createBackup;

  /// 데이터 백업 제목
  ///
  /// In ko, this message translates to:
  /// **'데이터 백업'**
  String get dataBackup;

  /// 데이터 백업 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터 백업 기능은 준비 중이다'**
  String get dataBackupComingSoon;

  /// 데이터 백업 설명
  ///
  /// In ko, this message translates to:
  /// **'💾 너의 드림 스피릿 전설을 영원히 보존한다!'**
  String get dataBackupDesc;

  /// 암호화 백업 버튼
  ///
  /// In ko, this message translates to:
  /// **'암호화 백업'**
  String get encryptedBackup;

  /// No description provided for @encryptedBackupCreated.
  ///
  /// In ko, this message translates to:
  /// **'암호화된 백업이 생성되었다'**
  String get encryptedBackupCreated;

  /// No description provided for @encryptedBackupError.
  ///
  /// In ko, this message translates to:
  /// **'암호화된 백업 생성 중 오류 발생: {error}'**
  String encryptedBackupError(Object error);

  /// No description provided for @encryptedBackupFailed.
  ///
  /// In ko, this message translates to:
  /// **'암호화된 백업 생성 실패: {error}'**
  String encryptedBackupFailed(Object error);

  /// 파일로 내보내기 버튼
  ///
  /// In ko, this message translates to:
  /// **'파일로 내보내기'**
  String get exportToFile;

  /// 마지막 백업 라벨
  ///
  /// In ko, this message translates to:
  /// **'마지막 백업'**
  String get lastBackup;

  /// No description provided for @nextBackup.
  ///
  /// In ko, this message translates to:
  /// **'다음 백업'**
  String get nextBackup;

  /// No description provided for @backupStatus.
  ///
  /// In ko, this message translates to:
  /// **'백업 상태'**
  String get backupStatus;

  /// No description provided for @backupSettings.
  ///
  /// In ko, this message translates to:
  /// **'백업 설정'**
  String get backupSettings;

  /// No description provided for @failureCount.
  ///
  /// In ko, this message translates to:
  /// **'실패 횟수'**
  String get failureCount;

  /// 수동 백업 완료 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'백업이 성공적으로 생성되었다'**
  String get manualBackupCompletedBody;

  /// 수동 백업 완료 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 수동 백업 완료'**
  String get manualBackupCompletedTitle;

  /// 수동 백업 실패 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'백업 생성 중 오류가 발생했다'**
  String get manualBackupFailedBody;

  /// 수동 백업 실패 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'Lucid Dream 100 수동 백업 실패'**
  String get manualBackupFailedTitle;

  /// 백업 기록이 없을 때 설명
  ///
  /// In ko, this message translates to:
  /// **'아직 백업을 생성하지 않았다'**
  String get noBackupCreated;

  /// 백업 빈도 선택 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'백업 빈도 선택'**
  String get selectBackupFrequency;

  /// No description provided for @backupEncryption.
  ///
  /// In ko, this message translates to:
  /// **'백업 암호화'**
  String get backupEncryption;

  /// No description provided for @password.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get password;

  /// No description provided for @enterPasswordForEncryption.
  ///
  /// In ko, this message translates to:
  /// **'백업 암호화에 사용할 비밀번호를 입력하세요'**
  String get enterPasswordForEncryption;

  /// No description provided for @frequencyDaily.
  ///
  /// In ko, this message translates to:
  /// **'매일'**
  String get frequencyDaily;

  /// No description provided for @frequencyWeekly.
  ///
  /// In ko, this message translates to:
  /// **'매주'**
  String get frequencyWeekly;

  /// No description provided for @frequencyMonthly.
  ///
  /// In ko, this message translates to:
  /// **'매월'**
  String get frequencyMonthly;

  /// No description provided for @frequencyManual.
  ///
  /// In ko, this message translates to:
  /// **'수동'**
  String get frequencyManual;

  /// 백업 작업 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'백업 작업'**
  String get backupActionsTitle;

  /// 자동 백업 비활성화 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'자동 백업이 현재 비활성화되어 있다'**
  String get backupAutoBackupDisabled;

  /// 자동 백업 활성화 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'자동 백업이 활성화되어 있다'**
  String get backupAutoBackupEnabled;

  /// 백업 실패 횟수 레이블
  ///
  /// In ko, this message translates to:
  /// **'실패 횟수'**
  String get backupFailureCountLabel;

  /// 백업 실패 횟수 값 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}회 실패'**
  String backupFailureCountValue(Object count);

  /// 백업 빈도 변경 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'백업 빈도가 업데이트되었다'**
  String get backupFrequencyChanged;

  /// 백업 빈도 레이블
  ///
  /// In ko, this message translates to:
  /// **'빈도'**
  String get backupFrequencyLabel;

  /// 백업 기록 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'백업 기록'**
  String get backupHistoryTitle;

  /// 마지막 백업 레이블
  ///
  /// In ko, this message translates to:
  /// **'마지막 백업'**
  String get backupLastBackupLabel;

  /// 다음 백업 레이블
  ///
  /// In ko, this message translates to:
  /// **'다음 백업'**
  String get backupNextBackupLabel;

  /// 백업 설정 변경 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'백업 설정 업데이트에 실패했다: {error}'**
  String backupSettingsChangeFailed(String error);

  /// 백업 설정 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'백업 설정'**
  String get backupSettingsTitle;

  /// 백업 상태 레이블
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get backupStatusLabel;

  /// 가속 적용 메시지 (일수 포함)
  ///
  /// In ko, this message translates to:
  /// **'가속 적용: {days}일'**
  String evolutionBoostApplied(Object days);

  /// 진화 가속 기능 곧 사용 가능 메시지
  ///
  /// In ko, this message translates to:
  /// **'곧 사용 가능'**
  String get evolutionBoostComingSoon;

  /// 다음 진화 가속까지 일수 표시
  ///
  /// In ko, this message translates to:
  /// **'{days}일 후 사용 가능'**
  String evolutionBoostCooldownDays(Object days);

  /// 다음 진화 가속까지 시간 표시
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 후 사용 가능'**
  String evolutionBoostCooldownHours(Object hours);

  /// 다음 진화까지 남은 일수
  ///
  /// In ko, this message translates to:
  /// **'{days}일 남음'**
  String evolutionBoostDaysLeft(Object days);

  /// 진화 가속 기능 설명
  ///
  /// In ko, this message translates to:
  /// **'광고로 진화 가속'**
  String get evolutionBoostDescription;

  /// 이미 최종 진화 상태일 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'이미 최종 진화입니다'**
  String get evolutionBoostMaxLevel;

  /// 다음 진화 단계 레이블
  ///
  /// In ko, this message translates to:
  /// **'다음 진화'**
  String get evolutionBoostNextEvolution;

  /// 남은 가속 횟수 표시
  ///
  /// In ko, this message translates to:
  /// **'남은 횟수: {count}/3'**
  String evolutionBoostRemaining(Object count);

  /// 진화 가속 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'진화가 가속되었습니다!'**
  String get evolutionBoostSuccess;

  /// 진화 가속 기능 제목
  ///
  /// In ko, this message translates to:
  /// **'진화 가속권'**
  String get evolutionBoostTitle;

  /// 광고 보고 진화 가속 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 가속하기'**
  String get evolutionBoostWatchAd;

  /// 광고 보고 보상 받기 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 {reward} 받기'**
  String rewardedAdWatchAndGet(String reward);

  /// 리워드 광고 남은 사용 횟수
  ///
  /// In ko, this message translates to:
  /// **'남은 횟수: {remaining}/{max}'**
  String rewardedAdRemainingUses(int remaining, int max);

  /// 광고 보기 짧은 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 받기'**
  String get rewardedAdWatchButton;

  /// 광고가 곧 사용 가능할 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'곧 사용 가능'**
  String get rewardedAdComingSoon;

  /// 보상 지급 시 스낵바 메시지
  ///
  /// In ko, this message translates to:
  /// **'{icon} {title} 획득!'**
  String rewardedAdRewardGranted(String icon, String title);

  /// 다음 사용까지 시간과 분 표시
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 {minutes}분 후 사용 가능'**
  String rewardedAdAvailableInHours(int hours, int minutes);

  /// 다음 사용까지 분 표시
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 후 사용 가능'**
  String rewardedAdAvailableInMinutes(int minutes);

  /// 토큰 광고 기능 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'광고 기능 준비 중'**
  String get tokenBalanceAdComingSoon;

  /// 일일 토큰 보상 받기 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'보상 받기 (+{amount} 토큰)'**
  String tokenBalanceClaimReward(Object amount);

  /// 일일 토큰 보상 섹션 레이블
  ///
  /// In ko, this message translates to:
  /// **'일일 보상'**
  String get tokenBalanceDailyReward;

  /// 다음 보상 카운트다운 레이블
  ///
  /// In ko, this message translates to:
  /// **'다음 보상'**
  String get tokenBalanceNextReward;

  /// 프리미엄 상태 배지 레이블
  ///
  /// In ko, this message translates to:
  /// **'프리미엄'**
  String get tokenBalancePremium;

  /// 보상 받기 실패 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'보상 받기 실패: {error}'**
  String tokenBalanceRewardFailed(Object error);

  /// 보상 받기 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'보상을 받았습니다!'**
  String get tokenBalanceRewardReceived;

  /// 보상 토큰 양 표시
  ///
  /// In ko, this message translates to:
  /// **'+{amount} 토큰'**
  String tokenBalanceRewardAmount(Object amount);

  /// 토큰 잔액 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'토큰 잔액'**
  String get tokenBalanceTitle;

  /// 대화당 토큰 사용량 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'Lumi와 대화 한 번당 토큰 1개 소모'**
  String get tokenBalanceUsageInfo;

  /// 광고 보고 토큰 받기 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 토큰 받기'**
  String get tokenBalanceWatchAd;

  /// AI 어시스턴트 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'AI 꿈 어시스턴트'**
  String get aiAssistantTitle;

  /// 질문이 선택되지 않았을 때 플레이스홀더
  ///
  /// In ko, this message translates to:
  /// **'위의 기능을 선택하여 시작하세요'**
  String get aiAssistantEmptyQuestion;

  /// 입력이 비었을 때 경고
  ///
  /// In ko, this message translates to:
  /// **'질문이나 꿈을 입력해주세요'**
  String get aiAssistantEmptyInput;

  /// 질문 레이블
  ///
  /// In ko, this message translates to:
  /// **'당신의 질문'**
  String get aiAssistantQuestion;

  /// 응답 레이블
  ///
  /// In ko, this message translates to:
  /// **'Lumi의 답변'**
  String get aiAssistantResponse;

  /// 응답 생성 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'답변 생성 중...'**
  String get aiAssistantGenerating;

  /// 오늘 사용량
  ///
  /// In ko, this message translates to:
  /// **'오늘: {used}/{limit} 사용 ({remaining}개 남음)'**
  String aiAssistantUsageToday(Object used, Object limit, Object remaining);

  /// 사용량 한도 경고
  ///
  /// In ko, this message translates to:
  /// **'일일 한도의 {percentage}%를 사용했습니다!'**
  String aiAssistantUsageWarning(Object percentage);

  /// 무료 티어 배지
  ///
  /// In ko, this message translates to:
  /// **'무료'**
  String get aiAssistantFree;

  /// 프리미엄 티어 배지
  ///
  /// In ko, this message translates to:
  /// **'프리미엄'**
  String get aiAssistantPremium;

  /// 꿈 일기 기능 타이틀
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기'**
  String get aiFeatureDreamJournalTitle;

  /// 꿈 일기 기능 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'꿈 분석하기'**
  String get aiFeatureDreamJournalSubtitle;

  /// 꿈 일기 기능 설명
  ///
  /// In ko, this message translates to:
  /// **'꿈 상징과 의미에 대한 깊은 통찰 얻기'**
  String get aiFeatureDreamJournalDesc;

  /// 꿈 일기 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'꿈을 설명하세요'**
  String get aiFeatureDreamJournalInputLabel;

  /// 꿈 일기 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'당신의 꿈에 대해 말해주세요...'**
  String get aiFeatureDreamJournalInputHint;

  /// 현실 확인 기능 타이틀
  ///
  /// In ko, this message translates to:
  /// **'현실 확인'**
  String get aiFeatureRealityCheckTitle;

  /// 현실 확인 기능 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'자각 훈련'**
  String get aiFeatureRealityCheckSubtitle;

  /// 현실 확인 기능 설명
  ///
  /// In ko, this message translates to:
  /// **'자각몽을 위한 효과적인 현실 확인 기법 배우기'**
  String get aiFeatureRealityCheckDesc;

  /// 현실 확인 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'현실 확인에 대해 질문하기'**
  String get aiFeatureRealityCheckInputLabel;

  /// 현실 확인 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'효과적인 현실 확인은 어떻게 하나요?'**
  String get aiFeatureRealityCheckInputHint;

  /// 기법 기능 타이틀
  ///
  /// In ko, this message translates to:
  /// **'기법'**
  String get aiFeatureTechniqueTitle;

  /// 기법 기능 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'WILD, MILD, WBTB'**
  String get aiFeatureTechniqueSubtitle;

  /// 기법 기능 설명
  ///
  /// In ko, this message translates to:
  /// **'고급 자각몽 기법 마스터하기'**
  String get aiFeatureTechniqueDesc;

  /// 기법 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'기법에 대해 질문하기'**
  String get aiFeatureTechniqueInputLabel;

  /// 기법 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'WILD 기법은 어떻게 작동하나요?'**
  String get aiFeatureTechniqueInputHint;

  /// 명상 기능 타이틀
  ///
  /// In ko, this message translates to:
  /// **'명상'**
  String get aiFeatureMeditationTitle;

  /// 명상 기능 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'마음챙김 연습'**
  String get aiFeatureMeditationSubtitle;

  /// 명상 기능 설명
  ///
  /// In ko, this message translates to:
  /// **'꿈 자각을 향상시키는 명상 기법'**
  String get aiFeatureMeditationDesc;

  /// 명상 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'명상에 대해 질문하기'**
  String get aiFeatureMeditationInputLabel;

  /// 명상 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'자각몽에 도움이 되는 명상은 무엇인가요?'**
  String get aiFeatureMeditationInputHint;

  /// 자유 대화 기능 타이틀
  ///
  /// In ko, this message translates to:
  /// **'자유 대화'**
  String get aiFeatureFreeChatTitle;

  /// 자유 대화 기능 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'무엇이든 질문'**
  String get aiFeatureFreeChatSubtitle;

  /// 자유 대화 기능 설명
  ///
  /// In ko, this message translates to:
  /// **'자각몽 주제에 대해 자유롭게 대화하기'**
  String get aiFeatureFreeChatDesc;

  /// 자유 대화 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'무엇이든 질문하세요'**
  String get aiFeatureFreeChatInputLabel;

  /// 자유 대화 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'자각몽에 대해 무엇이든 물어보세요...'**
  String get aiFeatureFreeChatInputHint;

  /// 분석 모드 선택 타이틀
  ///
  /// In ko, this message translates to:
  /// **'분석 모드 선택'**
  String get analysisModeTitle;

  /// 분석 모드 헤더
  ///
  /// In ko, this message translates to:
  /// **'꿈 분석'**
  String get analysisModeHeader;

  /// 빠른 분석 타이틀
  ///
  /// In ko, this message translates to:
  /// **'빠른 분석'**
  String get analysisQuickTitle;

  /// 빠른 분석 배지
  ///
  /// In ko, this message translates to:
  /// **'빠르고 무료'**
  String get analysisQuickBadge;

  /// 빠른 분석 설명
  ///
  /// In ko, this message translates to:
  /// **'즉시 기본 꿈 해석 받기'**
  String get analysisQuickDesc;

  /// No description provided for @analysisQuickFeature1.
  ///
  /// In ko, this message translates to:
  /// **'즉시 결과'**
  String get analysisQuickFeature1;

  /// No description provided for @analysisQuickFeature2.
  ///
  /// In ko, this message translates to:
  /// **'기본 해석'**
  String get analysisQuickFeature2;

  /// No description provided for @analysisQuickFeature3.
  ///
  /// In ko, this message translates to:
  /// **'토큰 불필요'**
  String get analysisQuickFeature3;

  /// 빠른 분석 버튼
  ///
  /// In ko, this message translates to:
  /// **'빠른 분석 시작'**
  String get analysisQuickButton;

  /// Lumi 분석 타이틀
  ///
  /// In ko, this message translates to:
  /// **'Lumi 깊은 분석'**
  String get analysisLumiTitle;

  /// Lumi 필요 토큰
  ///
  /// In ko, this message translates to:
  /// **'토큰 {tokens}개'**
  String analysisLumiTokens(Object tokens);

  /// Lumi 분석 설명
  ///
  /// In ko, this message translates to:
  /// **'AI 대화와 함께하는 깊은 꿈 분석'**
  String get analysisLumiDesc;

  /// No description provided for @analysisLumiFeature1.
  ///
  /// In ko, this message translates to:
  /// **'깊은 해석'**
  String get analysisLumiFeature1;

  /// No description provided for @analysisLumiFeature2.
  ///
  /// In ko, this message translates to:
  /// **'상징 분석'**
  String get analysisLumiFeature2;

  /// No description provided for @analysisLumiFeature3.
  ///
  /// In ko, this message translates to:
  /// **'패턴 감지'**
  String get analysisLumiFeature3;

  /// No description provided for @analysisLumiFeature4.
  ///
  /// In ko, this message translates to:
  /// **'후속 대화'**
  String get analysisLumiFeature4;

  /// Lumi 분석 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'분석 시작'**
  String get analysisLumiButtonStart;

  /// 토큰 필요 버튼
  ///
  /// In ko, this message translates to:
  /// **'토큰 얻기'**
  String get analysisLumiButtonNeedTokens;

  /// 비교 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'기능 비교'**
  String get analysisComparisonTitle;

  /// 속도 비교 레이블
  ///
  /// In ko, this message translates to:
  /// **'속도'**
  String get analysisComparisonSpeed;

  /// 빠른 분석 속도
  ///
  /// In ko, this message translates to:
  /// **'즉시'**
  String get analysisComparisonSpeedQuick;

  /// Lumi 분석 속도
  ///
  /// In ko, this message translates to:
  /// **'30-60초'**
  String get analysisComparisonSpeedLumi;

  /// 깊이 비교 레이블
  ///
  /// In ko, this message translates to:
  /// **'분석 깊이'**
  String get analysisComparisonDepth;

  /// 빠른 분석 깊이
  ///
  /// In ko, this message translates to:
  /// **'기본'**
  String get analysisComparisonDepthQuick;

  /// Lumi 분석 깊이
  ///
  /// In ko, this message translates to:
  /// **'종합'**
  String get analysisComparisonDepthLumi;

  /// 후속 대화 비교 레이블
  ///
  /// In ko, this message translates to:
  /// **'후속 대화'**
  String get analysisComparisonFollowUp;

  /// 빠른 분석 후속 대화
  ///
  /// In ko, this message translates to:
  /// **'불가능'**
  String get analysisComparisonFollowUpQuick;

  /// Lumi 분석 후속 대화
  ///
  /// In ko, this message translates to:
  /// **'가능'**
  String get analysisComparisonFollowUpLumi;

  /// 비용 비교 레이블
  ///
  /// In ko, this message translates to:
  /// **'비용'**
  String get analysisComparisonCost;

  /// 빠른 분석 비용
  ///
  /// In ko, this message translates to:
  /// **'무료'**
  String get analysisComparisonCostQuick;

  /// Lumi 분석 비용
  ///
  /// In ko, this message translates to:
  /// **'토큰 1개'**
  String get analysisComparisonCostLumi;

  /// 토큰 부족 다이얼로그 타이틀
  ///
  /// In ko, this message translates to:
  /// **'토큰이 부족합니다'**
  String get analysisNoTokensTitle;

  /// 토큰 부족 메시지
  ///
  /// In ko, this message translates to:
  /// **'Lumi 깊은 분석에는 토큰이 필요합니다'**
  String get analysisNoTokensMessage;

  /// 일일 무료 토큰 정보
  ///
  /// In ko, this message translates to:
  /// **'일일 무료 토큰'**
  String get analysisNoTokensDaily;

  /// 무료 티어 일일 토큰
  ///
  /// In ko, this message translates to:
  /// **'하루 1개 토큰'**
  String get analysisNoTokensDailyFree;

  /// 프리미엄 티어 일일 토큰
  ///
  /// In ko, this message translates to:
  /// **'하루 5개 토큰'**
  String get analysisNoTokensDailyPremium;

  /// 프리미엄 무제한 정보
  ///
  /// In ko, this message translates to:
  /// **'프리미엄: 무제한'**
  String get analysisNoTokensPremium;

  /// 프리미엄 보너스
  ///
  /// In ko, this message translates to:
  /// **'일일 토큰 5배'**
  String get analysisNoTokensPremiumBonus;

  /// 토큰을 위한 광고 시청
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 토큰 받기'**
  String get analysisNoTokensAd;

  /// 광고 보상 양
  ///
  /// In ko, this message translates to:
  /// **'+1 토큰'**
  String get analysisNoTokensAdReward;

  /// 일일 토큰 받기 버튼
  ///
  /// In ko, this message translates to:
  /// **'일일 토큰 받기'**
  String get analysisNoTokensClaim;

  /// 토큰 받기 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'일일 토큰을 받았습니다!'**
  String get analysisNoTokensClaimedSnackbar;

  /// 다이얼로그 닫기 버튼
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get analysisNoTokensClose;

  /// 빠른 분석 앱바 타이틀
  ///
  /// In ko, this message translates to:
  /// **'빠른 꿈 분석'**
  String get quickAnalysisAppBar;

  /// 입력 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'꿈을 설명하세요'**
  String get quickAnalysisInputTitle;

  /// 입력 필드 힌트
  ///
  /// In ko, this message translates to:
  /// **'여기에 꿈을 입력하세요...'**
  String get quickAnalysisInputHint;

  /// 글자 수 카운터
  ///
  /// In ko, this message translates to:
  /// **'{current}/{max} 자'**
  String quickAnalysisInputCounter(Object current, Object max);

  /// 분석 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'꿈 분석하기'**
  String get quickAnalysisButtonStart;

  /// 가이드 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'사용 방법'**
  String get quickAnalysisGuideTitle;

  /// 가이드 기능 배지
  ///
  /// In ko, this message translates to:
  /// **'무료'**
  String get quickAnalysisGuideBadge;

  /// 가이드 설명
  ///
  /// In ko, this message translates to:
  /// **'빠른 분석은 즉시 기본 꿈 해석을 제공합니다'**
  String get quickAnalysisGuideDescription;

  /// 즉시 결과 기능
  ///
  /// In ko, this message translates to:
  /// **'즉시 결과'**
  String get quickAnalysisGuideInstantResults;

  /// 기본 해석 기능
  ///
  /// In ko, this message translates to:
  /// **'기본 해석'**
  String get quickAnalysisGuideBasicInterpretation;

  /// 토큰 불필요 기능
  ///
  /// In ko, this message translates to:
  /// **'토큰 불필요'**
  String get quickAnalysisGuideNoTokens;

  /// 로딩 타이틀
  ///
  /// In ko, this message translates to:
  /// **'꿈 분석 중'**
  String get quickAnalysisLoadingTitle;

  /// 로딩 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'잠시만 기다려주세요...'**
  String get quickAnalysisLoadingSubtitle;

  /// 결과 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'분석 결과'**
  String get quickAnalysisResultTitle;

  /// 더 깊은 분석 타이틀
  ///
  /// In ko, this message translates to:
  /// **'더 깊은 분석을 원하시나요?'**
  String get quickAnalysisDeeperTitle;

  /// 더 깊은 분석 설명
  ///
  /// In ko, this message translates to:
  /// **'종합적인 통찰을 위해 Lumi 깊은 분석을 시도하세요'**
  String get quickAnalysisDeeperDescription;

  /// Lumi와 대화 버튼
  ///
  /// In ko, this message translates to:
  /// **'Lumi와 대화하기'**
  String get quickAnalysisButtonChatWithLumi;

  /// 다시 분석하기 버튼
  ///
  /// In ko, this message translates to:
  /// **'다른 꿈 분석하기'**
  String get quickAnalysisButtonAnalyzeAgain;

  /// 빈 입력 에러
  ///
  /// In ko, this message translates to:
  /// **'꿈을 설명해주세요'**
  String get quickAnalysisErrorEmpty;

  /// 너무 짧은 입력 에러
  ///
  /// In ko, this message translates to:
  /// **'더 자세히 설명해주세요 (최소 20자)'**
  String get quickAnalysisErrorTooShort;

  /// 새로고침 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'지우고 다시 시작'**
  String get quickAnalysisRefreshTooltip;

  /// Lumi 대화 앱바 타이틀
  ///
  /// In ko, this message translates to:
  /// **'Lumi와 대화'**
  String get lumiConversationAppBar;

  /// 빈 대화 타이틀
  ///
  /// In ko, this message translates to:
  /// **'꿈 대화 시작하기'**
  String get lumiConversationEmptyTitle;

  /// 빈 대화 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'Lumi에게 꿈에 대해 무엇이든 물어보세요'**
  String get lumiConversationEmptySubtitle;

  /// 입력 필드 힌트
  ///
  /// In ko, this message translates to:
  /// **'꿈에 대해 질문하세요...'**
  String get lumiConversationInputHint;

  /// 생각 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'Lumi가 생각하는 중...'**
  String get lumiConversationThinking;

  /// 로드 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'대화를 불러오지 못했습니다'**
  String get lumiConversationLoadError;

  /// 토큰 다이얼로그 타이틀
  ///
  /// In ko, this message translates to:
  /// **'토큰 1개 필요'**
  String get lumiConversationTokenDialogTitle;

  /// 토큰 다이얼로그 내용
  ///
  /// In ko, this message translates to:
  /// **'이 대화는 토큰 1개를 사용합니다'**
  String get lumiConversationTokenDialogContent;

  /// 토큰 다이얼로그 닫기 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get lumiConversationTokenDialogClose;

  /// 꿈 분석 화면 앱바 타이틀
  ///
  /// In ko, this message translates to:
  /// **'꿈 분석'**
  String get dreamAnalysisAppBar;

  /// 키워드 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'주요 테마'**
  String get dreamAnalysisKeywordsTitle;

  /// 감정 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'감정'**
  String get dreamAnalysisEmotionsTitle;

  /// 상징 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'상징'**
  String get dreamAnalysisSymbolsTitle;

  /// 해석 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'해석'**
  String get dreamAnalysisInterpretationTitle;

  /// 권장사항 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'자각몽 팁'**
  String get dreamAnalysisRecommendationsTitle;

  /// 분석 헤더 타이틀
  ///
  /// In ko, this message translates to:
  /// **'당신의 꿈 분석'**
  String get dreamAnalysisHeaderTitle;

  /// 분석 헤더 서브타이틀
  ///
  /// In ko, this message translates to:
  /// **'Lumi AI 제공'**
  String get dreamAnalysisHeaderSubtitle;

  /// 자각몽 가능성 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'자각몽 가능성'**
  String get dreamAnalysisLucidPotentialTitle;

  /// 높은 자각몽 가능성 레이블
  ///
  /// In ko, this message translates to:
  /// **'높음'**
  String get dreamAnalysisLucidPotentialHigh;

  /// 중간 자각몽 가능성 레이블
  ///
  /// In ko, this message translates to:
  /// **'중간'**
  String get dreamAnalysisLucidPotentialMedium;

  /// 낮은 자각몽 가능성 레이블
  ///
  /// In ko, this message translates to:
  /// **'낮음'**
  String get dreamAnalysisLucidPotentialLow;

  /// 프리미엄 프로모션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'더 깊은 분석 잠금 해제'**
  String get dreamAnalysisPremiumPromoTitle;

  /// 프리미엄 기능 목록
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 회원은 상세한 상징 해석, 개인화된 통찰, 무제한 분석을 받습니다'**
  String get dreamAnalysisPremiumFeatures;

  /// 프리미엄 업그레이드 버튼
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 가입'**
  String get dreamAnalysisPremiumButton;

  /// 분석 실패 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'분석 실패: {error}'**
  String checklistAnalysisError(Object error);

  /// 꿈 분석 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'꿈을 분석하는 중...'**
  String get checklistAnalyzing;

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get checklistCancel;

  /// 완료된 태스크 레이블
  ///
  /// In ko, this message translates to:
  /// **'완료된 태스크'**
  String get checklistCompletedTasks;

  /// 완료된 태스크 수 표시
  ///
  /// In ko, this message translates to:
  /// **'{completed}/{total}'**
  String checklistCompletedTasksValue(Object completed, Object total);

  /// 체크리스트 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'잘하셨어요! 오늘의 훈련을 완료했습니다!'**
  String get checklistCompleteMessage;

  /// 필수 태스크 미완료 경고 메시지
  ///
  /// In ko, this message translates to:
  /// **'모든 필수 태스크를 완료해주세요'**
  String get checklistCompleteRequired;

  /// 필수 태스크 먼저 완료 경고
  ///
  /// In ko, this message translates to:
  /// **'필수 태스크를 먼저 완료하세요'**
  String get checklistCompleteRequiredFirst;

  /// 훈련 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'훈련 완료'**
  String get checklistCompleteTraining;

  /// 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get checklistConfirm;

  /// 일차 완료 타이틀 with 일차 번호
  ///
  /// In ko, this message translates to:
  /// **'{day}일차 완료! 🎉'**
  String checklistDayComplete(Object day);

  /// 앱바 일차 타이틀
  ///
  /// In ko, this message translates to:
  /// **'{day}일차 훈련'**
  String checklistDayTitle(Object day);

  /// 꿈 분석 가능 메시지
  ///
  /// In ko, this message translates to:
  /// **'오늘 무료 분석 1회 가능'**
  String get checklistDreamAnalysisAvailable;

  /// 프리미엄 무제한 분석 배지
  ///
  /// In ko, this message translates to:
  /// **'프리미엄: 무제한'**
  String get checklistDreamAnalysisPremiumUnlimited;

  /// 꿈 분석 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'꿈 분석'**
  String get checklistDreamAnalysisTitle;

  /// 광고 시청으로 분석 추가 메시지
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 분석 1회 더 받기'**
  String get checklistDreamAnalysisWatchAd;

  /// 꿈 입력 필드 힌트
  ///
  /// In ko, this message translates to:
  /// **'꿈을 자세히 설명해주세요...'**
  String get checklistDreamInputHint;

  /// 꿈 입력 버튼
  ///
  /// In ko, this message translates to:
  /// **'꿈 입력'**
  String get checklistEnterDream;

  /// 나가기 버튼
  ///
  /// In ko, this message translates to:
  /// **'나가기'**
  String get checklistExit;

  /// 나가기 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'진행 상황이 저장되지 않습니다. 정말 나가시겠습니까?'**
  String get checklistExitMessage;

  /// 나가기 확인 타이틀
  ///
  /// In ko, this message translates to:
  /// **'훈련 종료?'**
  String get checklistExitTitle;

  /// 무료 분석 가능 횟수
  ///
  /// In ko, this message translates to:
  /// **'오늘 무료 분석 가능'**
  String get checklistFreeAnalysisAvailable;

  /// 무료 분석 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'무료 분석 시작'**
  String get checklistFreeAnalysisStart;

  /// 나중에 버튼
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get checklistLater;

  /// 프리미엄 분석 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'꿈 분석 (프리미엄)'**
  String get checklistPremiumAnalysisStart;

  /// 프리미엄 무제한 배지
  ///
  /// In ko, this message translates to:
  /// **'프리미엄: 무제한'**
  String get checklistPremiumUnlimited;

  /// 진행률 퍼센트
  ///
  /// In ko, this message translates to:
  /// **'{percent}%'**
  String checklistProgressPercent(Object percent);

  /// 필수 태스크 레이블
  ///
  /// In ko, this message translates to:
  /// **'필수 태스크'**
  String get checklistRequiredTasks;

  /// 필수 태스크 완료 수
  ///
  /// In ko, this message translates to:
  /// **'{completed}/{total} 완료'**
  String checklistRequiredTasksValue(Object completed, Object total);

  /// 태스크 목표와 횟수
  ///
  /// In ko, this message translates to:
  /// **'목표: {count}회'**
  String checklistTaskGoal(Object count);

  /// 선택 태스크 배지
  ///
  /// In ko, this message translates to:
  /// **'선택'**
  String get checklistTaskOptional;

  /// 필수 태스크 배지
  ///
  /// In ko, this message translates to:
  /// **'필수'**
  String get checklistTaskRequired;

  /// 소요 시간 레이블
  ///
  /// In ko, this message translates to:
  /// **'소요 시간'**
  String get checklistTimeSpent;

  /// 소요 시간 분 표시
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분'**
  String checklistTimeSpentValue(Object minutes);

  /// 광고 보고 분석 받기 버튼
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 분석 받기'**
  String get checklistWatchAdAnalysis;

  /// 광고 보고 추가 분석 얻기
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 분석 1회 더 받기'**
  String get checklistWatchAdForAnalysis;

  /// WBTB 바쁨 상태
  ///
  /// In ko, this message translates to:
  /// **'바쁜 날 - WBTB 건너뜀'**
  String get checklistWbtbBusy;

  /// WBTB 완료 상태
  ///
  /// In ko, this message translates to:
  /// **'WBTB 완료'**
  String get checklistWbtbCompleted;

  /// WBTB 날 배지
  ///
  /// In ko, this message translates to:
  /// **'🌙 WBTB 날'**
  String get checklistWbtbDayBadge;

  /// WBTB 남은 건너뛰기 횟수
  ///
  /// In ko, this message translates to:
  /// **'이번 주 건너뛰기 {remaining}회 남음'**
  String checklistWbtbRemainingSkips(Object remaining);

  /// WBTB 건너뜀 상태
  ///
  /// In ko, this message translates to:
  /// **'WBTB 건너뜀'**
  String get checklistWbtbSkipped;

  /// 광고 보고 WBTB 건너뛰기
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 오늘 WBTB 건너뛰기'**
  String get checklistWbtbSkipWithAd;

  /// 일일 체크리스트 앱바 제목
  ///
  /// In ko, this message translates to:
  /// **'일일 체크리스트'**
  String get dailyChecklistAppBar;

  /// 일일 체크리스트 완료 상태
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get dailyChecklistComplete;

  /// 우선순위 1 작업 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 우선순위 1 - 필수'**
  String get dailyChecklistPriority1;

  /// 우선순위 2 작업 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'💪 우선순위 2 - 중요'**
  String get dailyChecklistPriority2;

  /// 일반 작업 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'📝 일반 연습'**
  String get dailyChecklistRegular;

  /// 선택 작업 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'⭐ 선택 - 보너스'**
  String get dailyChecklistOptional;

  /// 카운터 진행률 표시
  ///
  /// In ko, this message translates to:
  /// **'{current}/{target}'**
  String dailyChecklistCounterProgress(Object current, Object target);

  /// 연습 간격 안내
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분마다 연습하기'**
  String dailyChecklistPracticeInterval(Object minutes);

  /// 완료 대화상자 제목과 아이콘
  ///
  /// In ko, this message translates to:
  /// **'{icon} 작업 완료!'**
  String dailyChecklistCompletionDialogTitle(Object icon);

  /// 완료 대화상자 내용
  ///
  /// In ko, this message translates to:
  /// **'잘했어! {name}을(를) 완료했다!'**
  String dailyChecklistCompletionDialogContent(Object name);

  /// 대화상자 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get dailyChecklistConfirmButton;

  /// Checklist completion XP earned message
  ///
  /// In ko, this message translates to:
  /// **'훈련 완료! +{xp} XP 획득'**
  String checklistCompletionXP(int xp);

  /// No description provided for @legalDocumentLoadError.
  ///
  /// In ko, this message translates to:
  /// **'문서를 불러올 수 없습니다'**
  String get legalDocumentLoadError;

  /// No description provided for @legalDocumentNotFound.
  ///
  /// In ko, this message translates to:
  /// **'문서를 찾을 수 없습니다: {path}'**
  String legalDocumentNotFound(Object path);

  /// No description provided for @adLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'광고를 불러올 수 없다'**
  String get adLoadFailed;

  /// No description provided for @appInitError.
  ///
  /// In ko, this message translates to:
  /// **'앱 초기화 중 오류 발생!'**
  String get appInitError;

  /// 데이터베이스 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'💥 데이터 요새에 문제 발생! TECH 팀이 복구 중이다! 💥'**
  String get errorDatabase;

  /// 일반 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'🦁 일시적 장애물 발견! 진짜 EMPEROR는 다시 도전한다, 만삣삐! 🦁'**
  String get errorGeneral;

  /// 데이터 로딩 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러오는 중 오류가 발생했다'**
  String get errorLoadingData;

  /// 네트워크 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌪️ 네트워크 연결을 확인하라! ALPHA CONNECTION 필요하다! 🌪️'**
  String get errorNetwork;

  /// 데이터 없음 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔱 데이터를 찾을 수 없다! 새로운 전설을 만들 시간이다, 만삣삐! 🔱'**
  String get errorNotFound;

  /// 일반 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다: {error}'**
  String errorOccurred(String error);

  /// Error occurred with message
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다: {error}'**
  String errorOccurredWithMessage(String error);

  /// 권한 요청 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🔐 권한이 필요해요'**
  String get permissionsRequired;

  /// 프로필 생성 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ PROFILE CREATION FAILED! 다시 도전하라, ALPHA! 오류: {error} ⚡'**
  String profileCreationError(String error);

  /// Required permission label
  ///
  /// In ko, this message translates to:
  /// **'필수'**
  String get requiredLabel;

  /// 공유 실패 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'공유 중 오류 발생!'**
  String get shareError;

  /// No description provided for @statusFailed.
  ///
  /// In ko, this message translates to:
  /// **'실패'**
  String get statusFailed;

  /// 영상 로딩 실패 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'영상 로딩 오류: {error}'**
  String videoLoadError(String error);

  /// 프리미엄 레벨 도달 축하 메시지
  ///
  /// In ko, this message translates to:
  /// **'축하합니다! 🎉'**
  String get premiumCongratulations;

  /// Week 레벨 도달 메시지
  ///
  /// In ko, this message translates to:
  /// **'Week {week} 레벨 도달!'**
  String premiumWeekReached(int week);

  /// 프리미엄 구독 필요 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'Week 2 이상 레벨은\n프리미엄 구독이 필요합니다'**
  String get premiumRequiredMessage;

  /// 프리미엄 혜택: Lumi 진화
  ///
  /// In ko, this message translates to:
  /// **'Lumi 완전 진화 해금'**
  String get premiumBenefitLumiEvolution;

  /// 프리미엄 혜택: Lumi 진화 (짧은 버전)
  ///
  /// In ko, this message translates to:
  /// **'Lumi 완전 진화'**
  String get premiumBenefitLumi;

  /// 프리미엄 혜택: 무제한 AI
  ///
  /// In ko, this message translates to:
  /// **'무제한 AI 분석'**
  String get premiumBenefitUnlimitedAI;

  /// 월간 프리미엄 가격
  ///
  /// In ko, this message translates to:
  /// **'₩5,900'**
  String get premiumPriceMonthly;

  /// 월간 구독 단위
  ///
  /// In ko, this message translates to:
  /// **'/ 월'**
  String get premiumPricePerMonth;

  /// 나중에 버튼
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get premiumLaterButton;

  /// 프리미엄 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 시작'**
  String get premiumStartButton;

  /// 프리미엄 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'DreamFlow Premium'**
  String get premiumDialogTitle;

  /// 프리미엄 주차 해금 메시지
  ///
  /// In ko, this message translates to:
  /// **'Week {week}+ 단계 해금'**
  String premiumUnlockWeeks(int week);

  /// 프리미엄 혜택 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 혜택'**
  String get premiumBenefitsTitle;

  /// 광고 제거 혜택 설명
  ///
  /// In ko, this message translates to:
  /// **'방해 없는 자각몽 훈련'**
  String get premiumBenefitAdFreeDesc;

  /// Lumi 진화 혜택 설명
  ///
  /// In ko, this message translates to:
  /// **'Week 2-14 모든 단계 해금'**
  String get premiumBenefitLumiDesc;

  /// AI 분석 혜택 설명
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 AI 피드백 무제한'**
  String get premiumBenefitAIDesc;

  /// 고급 통계 혜택 설명
  ///
  /// In ko, this message translates to:
  /// **'상세한 진행 상황 분석'**
  String get premiumBenefitStatsDesc;

  /// 프리미엄 혜택: 고급 통계 (짧은 버전)
  ///
  /// In ko, this message translates to:
  /// **'고급 통계'**
  String get premiumBenefitAdvancedStats;

  /// 프리미엄 구독 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 시작하기'**
  String get premiumStartNowButton;

  /// 구독 정보 안내
  ///
  /// In ko, this message translates to:
  /// **'월간 구독 • 언제든 해지 가능'**
  String get premiumSubscriptionInfo;

  /// 토큰 부족 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'토큰이 부족합니다! 체크리스트를 완료하거나 광고를 시청하여 토큰을 받으세요.'**
  String get tokenInsufficientMessage;

  /// 프리미엄 사용자 타입
  ///
  /// In ko, this message translates to:
  /// **'프리미엄'**
  String get tokenUserTypePremium;

  /// 무료 사용자 타입
  ///
  /// In ko, this message translates to:
  /// **'무료'**
  String get tokenUserTypeFree;

  /// 토큰 잔액 표시
  ///
  /// In ko, this message translates to:
  /// **'🎫 보유 토큰: {balance}개 (최대 {maxTokens}개)'**
  String tokenBalanceDisplay(int balance, int maxTokens);

  /// 토큰 획득 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'토큰 획득!'**
  String get tokenRewardTitle;

  /// 프리미엄 일일 보상 라벨
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 일일 보상'**
  String get tokenDailyRewardPremium;

  /// 무료 일일 보상 라벨
  ///
  /// In ko, this message translates to:
  /// **'일일 보상'**
  String get tokenDailyRewardFree;

  /// 연속 출석 보너스 표시
  ///
  /// In ko, this message translates to:
  /// **'{streak}일 연속 보너스 🔥'**
  String tokenStreakBonus(int streak);

  /// 총 획득 토큰 라벨
  ///
  /// In ko, this message translates to:
  /// **'총 획득'**
  String get tokenTotalReward;

  /// 연속 출석 상태 표시
  ///
  /// In ko, this message translates to:
  /// **'{streak}일 연속 출석 중!'**
  String tokenStreakStatus(int streak);

  /// 3일 연속 목표 안내
  ///
  /// In ko, this message translates to:
  /// **'{remaining}일 더 연속 출석하면 보너스 토큰 획득!'**
  String tokenStreakGoal3Days(int remaining);

  /// 7일 연속 목표 안내
  ///
  /// In ko, this message translates to:
  /// **'{remaining}일 더 연속 출석하면 7일 보너스!'**
  String tokenStreakGoal7Days(int remaining);

  /// 토큰 보상 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get tokenRewardConfirm;

  /// 체크리스트 Day 헤더
  ///
  /// In ko, this message translates to:
  /// **'🌙 Day {day}'**
  String checklistDayHeader(int day);

  /// 토큰 소비 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'토큰 소비 실패'**
  String get tokenConsumeFailed;

  /// 꿈 일기 삭제 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 삭제'**
  String get dreamDeleteDialogTitle;

  /// 꿈 일기 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'이 꿈 일기를 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.'**
  String get dreamDeleteDialogContent;

  /// 꿈 일기 삭제 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기가 삭제되었습니다'**
  String get dreamDeletedSuccess;

  /// 꿈 일기 삭제 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'삭제 실패: {error}'**
  String dreamDeleteFailed(String error);

  /// AI 분석 버튼
  ///
  /// In ko, this message translates to:
  /// **'AI 분석'**
  String get aiAnalysis;

  /// 최신순 정렬
  ///
  /// In ko, this message translates to:
  /// **'최신순'**
  String get sortNewest;

  /// 오래된순 정렬
  ///
  /// In ko, this message translates to:
  /// **'오래된순'**
  String get sortOldest;

  /// 자각도 높은순 정렬
  ///
  /// In ko, this message translates to:
  /// **'자각도 높은순'**
  String get sortLucidityHigh;

  /// 새 꿈 일기 작성 버튼
  ///
  /// In ko, this message translates to:
  /// **'새 꿈 일기'**
  String get newDreamJournal;

  /// 꿈 내용 입력 필수 메시지
  ///
  /// In ko, this message translates to:
  /// **'꿈 내용을 입력해주세요.'**
  String get dreamContentRequired;

  /// 꿈 일기 저장 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 저장에 실패했습니다.'**
  String get dreamSaveFailed;

  /// 자각몽 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'자각몽: {count}'**
  String lucidDreamCount(String count);

  /// 일반 꿈 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'일반 꿈: {count}'**
  String normalDreamCount(String count);

  /// 자각몽
  ///
  /// In ko, this message translates to:
  /// **'자각몽'**
  String get lucidDream;

  /// 일반 꿈
  ///
  /// In ko, this message translates to:
  /// **'일반 꿈'**
  String get normalDream;

  /// 꿈을 꾼 날짜 라벨
  ///
  /// In ko, this message translates to:
  /// **'꿈을 꾼 날짜'**
  String get dreamDate;

  /// 기분 점수 라벨
  ///
  /// In ko, this message translates to:
  /// **'기분 점수:'**
  String get moodScore;

  /// 수면 시작 시간 라벨
  ///
  /// In ko, this message translates to:
  /// **'수면 시작'**
  String get sleepStart;

  /// 기상 시간 라벨
  ///
  /// In ko, this message translates to:
  /// **'기상 시간'**
  String get wakeTime;

  /// 수면 시간 라벨
  ///
  /// In ko, this message translates to:
  /// **'수면 시간'**
  String get sleepDuration;

  /// 수면 품질 라벨
  ///
  /// In ko, this message translates to:
  /// **'수면 품질:'**
  String get sleepQuality;

  /// WBTB 기법 사용 표시
  ///
  /// In ko, this message translates to:
  /// **'중간 기상법 사용'**
  String get wbtbUsed;

  /// WBTB 기법 라벨
  ///
  /// In ko, this message translates to:
  /// **'중간 기상법'**
  String get wbtbTechnique;

  /// 통계 화면 미사용 메시지
  ///
  /// In ko, this message translates to:
  /// **'통계 화면은 자각몽 앱에서 사용하지 않습니다'**
  String get progressNotUsed;

  /// 수면 정보 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'수면 정보 (선택)'**
  String get sleepInfoOptional;

  /// 값이 입력되지 않음을 나타내는 텍스트
  ///
  /// In ko, this message translates to:
  /// **'미입력'**
  String get notEntered;

  /// 사용한 기법 레이블
  ///
  /// In ko, this message translates to:
  /// **'사용한 기법:'**
  String get techniquesUsedLabel;

  /// 기분 점수 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'기분 점수 (Mood Score)'**
  String get moodScoreLabel;

  /// 수면 품질 라벨
  ///
  /// In ko, this message translates to:
  /// **'수면 품질'**
  String get sleepQualityLabel;

  /// 사용한 기법 제목
  ///
  /// In ko, this message translates to:
  /// **'사용한 기법'**
  String get techniquesUsedTitle;

  /// WBTB 사용 메시지
  ///
  /// In ko, this message translates to:
  /// **'중간 기상법 사용'**
  String get wbtbUsedMessage;

  /// 수면 정보 제목
  ///
  /// In ko, this message translates to:
  /// **'수면 정보'**
  String get sleepInfoTitle;

  /// 수면 시간 라벨
  ///
  /// In ko, this message translates to:
  /// **'수면 시간'**
  String get sleepDurationLabel;

  /// 수면 시간 값 표시
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 {minutes}분'**
  String sleepDurationValue(String hours, String minutes);

  /// 감정 및 기분 제목
  ///
  /// In ko, this message translates to:
  /// **'감정 및 기분'**
  String get emotionsAndMoodTitle;

  /// 감정 입력 제목
  ///
  /// In ko, this message translates to:
  /// **'감정 (Emotions)'**
  String get emotionsInputTitle;

  /// 꿈 심볼 입력 제목
  ///
  /// In ko, this message translates to:
  /// **'꿈 심볼/키워드 (Dream Signs)'**
  String get dreamSignsInputTitle;

  /// 등장 인물 입력 제목
  ///
  /// In ko, this message translates to:
  /// **'등장 인물 (Characters)'**
  String get charactersInputTitle;

  /// 장소 입력 제목
  ///
  /// In ko, this message translates to:
  /// **'장소 (Locations)'**
  String get locationsInputTitle;

  /// 통계 데이터 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'꿈 데이터가 충분하지 않습니다.\n꿈 일기를 작성하면 통계가 표시됩니다.'**
  String get dreamStatisticsNoData;

  /// 자각몽 성공률 제목
  ///
  /// In ko, this message translates to:
  /// **'자각몽 성공률'**
  String get lucidSuccessRate;

  /// 성공률 퍼센트 표시
  ///
  /// In ko, this message translates to:
  /// **'성공률: {rate}%'**
  String successRatePercent(String rate);

  /// 자각도 추세 제목
  ///
  /// In ko, this message translates to:
  /// **'자각도 추세'**
  String get lucidityTrend;

  /// 최근 10개 꿈 부제목
  ///
  /// In ko, this message translates to:
  /// **'최근 10개 꿈'**
  String get recentDreams10;

  /// 주간 통계 제목
  ///
  /// In ko, this message translates to:
  /// **'주간 통계'**
  String get weeklyStatistics;

  /// 주간 통계 부제목
  ///
  /// In ko, this message translates to:
  /// **'최근 7일간 꿈 기록'**
  String get weeklyStatisticsSubtitle;

  /// 꿈 내용 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'꿈에서 본 것, 느낀 것을 자유롭게 작성하세요...'**
  String get dreamContentHint;

  /// 꿈 검색 힌트
  ///
  /// In ko, this message translates to:
  /// **'꿈 내용, 심볼, 인물, 장소 검색...'**
  String get dreamSearchHint;

  /// 꿈 제목 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 하늘을 나는 꿈'**
  String get dreamTitleHint;

  /// 감정 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'감정 입력 후 Enter'**
  String get emotionInputHint;

  /// 꿈 심볼 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 물, 비행, 학교'**
  String get dreamSignsHint;

  /// 등장 인물 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 엄마, 친구, 낯선 사람'**
  String get charactersHint;

  /// 장소 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 집, 학교, 낯선 도시'**
  String get locationsHint;

  /// 꿈 내용 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'꿈 내용 (필수) *'**
  String get dreamContentLabel;

  /// 꿈 제목 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'제목 (선택)'**
  String get dreamTitleLabel;

  /// 즐겨찾기 툴팁
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기'**
  String get tooltipFavorite;

  /// 수정 툴팁
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get tooltipEdit;

  /// 삭제 툴팁
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get tooltipDelete;

  /// 저장 툴팁
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get tooltipSave;

  /// 꿈 일기 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 수정'**
  String get dreamJournalEdit;

  /// 꿈 일기 작성 제목
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 작성'**
  String get dreamJournalCreate;

  /// 꿈 일기 저장 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기가 저장되었습니다.'**
  String get dreamSavedSuccess;

  /// 꿈 일기 수정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기가 수정되었습니다.'**
  String get dreamUpdatedSuccess;

  /// 전체 꿈 탭
  ///
  /// In ko, this message translates to:
  /// **'전체 ({count})'**
  String tabAllDreams(String count);

  /// 자각몽 탭
  ///
  /// In ko, this message translates to:
  /// **'자각몽 ({count})'**
  String tabLucidDreams(String count);

  /// 즐겨찾기 탭
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기'**
  String get tabFavorites;

  /// 자각몽 배지 텍스트
  ///
  /// In ko, this message translates to:
  /// **'자각몽'**
  String get lucidDreamBadge;

  /// 총 꿈 통계 라벨
  ///
  /// In ko, this message translates to:
  /// **'총 꿈'**
  String get statTotalDreams;

  /// 자각몽 통계 라벨
  ///
  /// In ko, this message translates to:
  /// **'자각몽'**
  String get statLucidDreams;

  /// 평균 자각도 통계 라벨
  ///
  /// In ko, this message translates to:
  /// **'평균 자각도'**
  String get statAvgLucidity;

  /// 메타정보 제목
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get metaInfoTitle;

  /// 작성일 라벨
  ///
  /// In ko, this message translates to:
  /// **'작성일'**
  String get metaCreatedAt;

  /// 수정일 라벨
  ///
  /// In ko, this message translates to:
  /// **'수정일'**
  String get metaUpdatedAt;

  /// 단어 수 라벨
  ///
  /// In ko, this message translates to:
  /// **'단어 수'**
  String get metaWordCount;

  /// 단어 수 값
  ///
  /// In ko, this message translates to:
  /// **'{count} 단어'**
  String metaWordCountValue(String count);

  /// AI 분석 라벨
  ///
  /// In ko, this message translates to:
  /// **'AI 분석'**
  String get metaAiAnalysis;

  /// 완료 상태
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get metaCompleted;

  /// 미완료 상태
  ///
  /// In ko, this message translates to:
  /// **'미완료'**
  String get metaNotCompleted;

  /// 연속 기록 라벨
  ///
  /// In ko, this message translates to:
  /// **'연속 기록'**
  String get statStreakLabel;

  /// 연속 일수
  ///
  /// In ko, this message translates to:
  /// **'{count}일'**
  String statStreakDays(String count);

  /// 무료 체험 남은 일수
  ///
  /// In ko, this message translates to:
  /// **'무료 체험 {days}일 남음'**
  String subscriptionFreeTrialRemaining(String days);

  /// 프리미엄 혜택: 광고 제거
  ///
  /// In ko, this message translates to:
  /// **'광고 제거'**
  String get subscriptionBenefitAdFree;

  /// 프리미엄 혜택: 확장 프로그램
  ///
  /// In ko, this message translates to:
  /// **'60일 확장 프로그램 (Week 1-8)'**
  String get subscriptionBenefitExtendedProgram;

  /// 프리미엄 혜택: Lumi 진화
  ///
  /// In ko, this message translates to:
  /// **'Lumi 6단계 완전 진화'**
  String get subscriptionBenefitLumiEvolution;

  /// 프리미엄 혜택: 무제한 AI 분석
  ///
  /// In ko, this message translates to:
  /// **'무제한 AI 꿈 분석'**
  String get subscriptionBenefitUnlimitedAI;

  /// 프리미엄 혜택: 고급 통계
  ///
  /// In ko, this message translates to:
  /// **'고급 통계 분석'**
  String get subscriptionBenefitAdvancedAnalytics;

  /// 프리미엄 혜택: 데이터 내보내기
  ///
  /// In ko, this message translates to:
  /// **'데이터 내보내기'**
  String get subscriptionBenefitDataExport;

  /// 광고 표시 여부 라벨
  ///
  /// In ko, this message translates to:
  /// **'광고 표시'**
  String get subscriptionAdsLabel;

  /// 예
  ///
  /// In ko, this message translates to:
  /// **'예'**
  String get subscriptionAdsYes;

  /// 아니오 (광고 제거됨)
  ///
  /// In ko, this message translates to:
  /// **'아니오 (광고 제거)'**
  String get subscriptionAdsNoWithAdFree;

  /// 연구 결과 라벨
  ///
  /// In ko, this message translates to:
  /// **'연구 결과'**
  String get weekUnlockResearchLabel;

  /// WBTB + MILD 기법
  ///
  /// In ko, this message translates to:
  /// **'WBTB + MILD 기법'**
  String get weekUnlockWbtbMildTechnique;

  /// 자각몽 성공률 표시
  ///
  /// In ko, this message translates to:
  /// **'46% 자각몽 성공률'**
  String get weekUnlockSuccessRate;

  /// 해금될 기법 라벨
  ///
  /// In ko, this message translates to:
  /// **'해금될 기법'**
  String get weekUnlockTechniquesLabel;

  /// 프리미엄 혜택 섹션 라벨
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 혜택'**
  String get weekUnlockPremiumBenefitsLabel;

  /// 60일 전체 프로그램 접근 혜택
  ///
  /// In ko, this message translates to:
  /// **'🎯 60일 전체 프로그램 접근'**
  String get weekUnlockBenefitFullProgram;

  /// Lumi 6단계 진화 혜택
  ///
  /// In ko, this message translates to:
  /// **'✨ Lumi 6단계 전체 진화'**
  String get weekUnlockBenefitLumiEvolution;

  /// 무제한 AI 분석 혜택
  ///
  /// In ko, this message translates to:
  /// **'🧠 무제한 AI 꿈 분석'**
  String get weekUnlockBenefitUnlimitedAI;

  /// 고급 통계 분석 혜택
  ///
  /// In ko, this message translates to:
  /// **'📊 고급 통계 분석'**
  String get weekUnlockBenefitAdvancedStats;

  /// 광고 완전 제거 혜택
  ///
  /// In ko, this message translates to:
  /// **'🚫 광고 완전 제거'**
  String get weekUnlockBenefitAdRemoval;

  /// Week 2 해금 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🎯 Week 2 기법 해금!'**
  String get weekUnlockWeek2Title;

  /// Week 2 해금 다이얼로그 메시지
  ///
  /// In ko, this message translates to:
  /// **'축하합니다! Week 1을 완료했습니다.\\n\\n연구 기반 자각몽 기법과 60일 확장 프로그램을 경험하려면 프리미엄으로 업그레이드하세요.'**
  String get weekUnlockWeek2Message;

  /// Week 3 해금 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🎯 Week 3 기법 해금!'**
  String get weekUnlockWeek3Title;

  /// Week 3 해금 다이얼로그 메시지
  ///
  /// In ko, this message translates to:
  /// **'축하합니다! Week 2를 완료했습니다.\\n\\n연구에서 증명된 가장 효과적인 기법인 WBTB+MILD를 해금하려면 프리미엄으로 업그레이드하세요.'**
  String get weekUnlockWeek3Message;

  /// Week 5 해금 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🌌 고급 기법 해금!'**
  String get weekUnlockWeek5Title;

  /// Week 5 해금 다이얼로그 메시지
  ///
  /// In ko, this message translates to:
  /// **'Week 5에 도달했습니다!\\n\\nSSILD와 WILD 같은 고급 자각몽 기법을 마스터할 준비가 되셨나요?'**
  String get weekUnlockWeek5Message;

  /// Week 7 해금 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🔮 마스터 기법 해금!'**
  String get weekUnlockWeek7Title;

  /// Week 7 해금 다이얼로그 메시지
  ///
  /// In ko, this message translates to:
  /// **'Week 7 도달! 거의 다 왔습니다.\\n\\n꿈 조종과 안정화 기법으로 자각몽 마스터가 되세요!'**
  String get weekUnlockWeek7Message;

  /// 일반 Week 해금 제목
  ///
  /// In ko, this message translates to:
  /// **'🔓 Week {week} 해금'**
  String weekUnlockGenericTitle(String week);

  /// 일반 Week 해금 메시지
  ///
  /// In ko, this message translates to:
  /// **'Week {prevWeek}을 완료했습니다!\\n\\n다음 단계로 진행하려면 프리미엄이 필요합니다.'**
  String weekUnlockGenericMessage(String prevWeek);

  /// Dream Sign 감지용 ACTION 키워드 (쉼표로 구분)
  ///
  /// In ko, this message translates to:
  /// **'날다,날기,비행,하늘,공중,떠다니,벽,통과,순간이동,텔레포트,죽었다,살아나,부활,변신,초능력,투명,마법'**
  String get dreamSignActionKeywords;

  /// Dream Sign 감지용 FORM 키워드 (쉼표로 구분)
  ///
  /// In ko, this message translates to:
  /// **'얼굴,변형,이상한,괴물,동물,변한,모습,낯선,기묘한,존재하지 않는,불가능한,왜곡,기형,거대한,작은'**
  String get dreamSignFormKeywords;

  /// Dream Sign 감지용 CONTEXT 키워드 (쉼표로 구분)
  ///
  /// In ko, this message translates to:
  /// **'죽은,살아있,과거,미래,어렸을 때,학교,직장,집,낯선 곳,시간,불일치,이상한,말이 안,모순'**
  String get dreamSignContextKeywords;

  /// Dream Sign 감지용 AWARENESS 키워드 (쉼표로 구분)
  ///
  /// In ko, this message translates to:
  /// **'이상하,뭔가,느낌,이상한,이상했,의심,의문,현실,확인,꿈,깨닫,알아차'**
  String get dreamSignAwarenessKeywords;

  /// ACTION 카테고리 Dream Sign 설명
  ///
  /// In ko, this message translates to:
  /// **'비정상적 행동: {keyword}'**
  String dreamSignActionDesc(String keyword);

  /// FORM 카테고리 Dream Sign 설명
  ///
  /// In ko, this message translates to:
  /// **'비정상적 형태: {keyword}'**
  String dreamSignFormDesc(String keyword);

  /// CONTEXT 카테고리 Dream Sign 설명
  ///
  /// In ko, this message translates to:
  /// **'비정상적 맥락: {keyword}'**
  String dreamSignContextDesc(String keyword);

  /// AWARENESS 카테고리 Dream Sign 설명
  ///
  /// In ko, this message translates to:
  /// **'자각 관련: {keyword}'**
  String dreamSignAwarenessDesc(String keyword);

  /// 사용자 입력 심볼 설명
  ///
  /// In ko, this message translates to:
  /// **'꿈 심볼: {symbol}'**
  String dreamSignSymbolDesc(String symbol);

  /// Reality Check 제안: 데이터 부족 메시지
  ///
  /// In ko, this message translates to:
  /// **'아직 충분한 꿈 일기가 없습니다. 매일 꿈을 기록해보세요.'**
  String get dreamSignInsufficientData;

  /// Dream Sign 분석 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다. 나중에 다시 시도해주세요.'**
  String get dreamSignError;

  /// Reality Check 제안: 패턴 소개
  ///
  /// In ko, this message translates to:
  /// **'당신의 꿈에서 \"{patterns}\" 패턴이 자주 나타납니다.'**
  String dreamSignRealityCheckIntro(String patterns);

  /// Reality Check 수행 방법 안내
  ///
  /// In ko, this message translates to:
  /// **'이 요소들을 만날 때마다 Reality Check를 수행하세요:\\n1. 손바닥 확인하기\\n2. 코를 막고 숨쉬기\\n3. 시계 두 번 보기'**
  String get dreamSignRealityCheckInstructions;

  /// Reality Check 권장 빈도
  ///
  /// In ko, this message translates to:
  /// **'하루 {frequency}회 이상 수행하면 효과적입니다.'**
  String dreamSignRealityCheckFrequency(String frequency);

  /// 반복 꿈 패턴 설명
  ///
  /// In ko, this message translates to:
  /// **'공통 요소: {elements} (유사도 {similarity}%)'**
  String dreamSignPatternDesc(String elements, String similarity);

  /// 선택적 태스크 표시
  ///
  /// In ko, this message translates to:
  /// **'(선택)'**
  String get taskOptional;

  /// 꿈 일기 작성 태스크
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기 작성'**
  String get taskDreamJournal;

  /// 현실 확인 태스크
  ///
  /// In ko, this message translates to:
  /// **'현실 확인 (5회)'**
  String get taskRealityCheck;

  /// MILD 확언 태스크
  ///
  /// In ko, this message translates to:
  /// **'MILD 확언'**
  String get taskMildAffirmation;

  /// 수면 위생 체크 태스크
  ///
  /// In ko, this message translates to:
  /// **'수면 위생 체크'**
  String get taskSleepHygiene;

  /// WBTB 수행 태스크
  ///
  /// In ko, this message translates to:
  /// **'WBTB 수행'**
  String get taskWbtb;

  /// 명상 태스크
  ///
  /// In ko, this message translates to:
  /// **'명상 (선택)'**
  String get taskMeditation;

  /// 체크리스트 진행 상황 레이블
  ///
  /// In ko, this message translates to:
  /// **'진행 상황'**
  String get checklistProgressLabel;

  /// 체크리스트 완료 보상 메시지
  ///
  /// In ko, this message translates to:
  /// **'완료! +5 토큰 획득'**
  String get checklistCompletedReward;

  /// 프로그램 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'프로그램을 완료했습니다!'**
  String get programCompleted;

  /// 즐겨찾기 추가 메시지
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기에 추가되었습니다'**
  String get favoriteAdded;

  /// 즐겨찾기 해제 메시지
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기가 해제되었습니다'**
  String get favoriteRemoved;

  /// 제목이 없을 때 표시되는 텍스트
  ///
  /// In ko, this message translates to:
  /// **'(제목 없음)'**
  String get noTitle;

  /// 감정 레이블
  ///
  /// In ko, this message translates to:
  /// **'감정:'**
  String get emotionsLabel;

  /// 등장 인물 레이블
  ///
  /// In ko, this message translates to:
  /// **'등장 인물:'**
  String get charactersLabel;

  /// 장소 레이블
  ///
  /// In ko, this message translates to:
  /// **'장소:'**
  String get locationsLabel;

  /// 꿈 일기 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'꿈 일기'**
  String get dreamJournalTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
