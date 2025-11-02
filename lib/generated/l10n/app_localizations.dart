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
  /// **'차드가 되는 여정, 함께 간다! 💪'**
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
  /// **'기가차드 완성 코스'**
  String get alphaFeature4;

  /// 고급 짧은 이름
  ///
  /// In ko, this message translates to:
  /// **'차드'**
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
  /// **'차드가 되는 여정'**
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

  /// Cancel button text
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
  /// **'👑 차드에 가까워진 게 아니다... 이제 차드를 넘어섰다! 👑'**
  String get completionMessage3;

  /// 완료 메시지 4
  ///
  /// In ko, this message translates to:
  /// **'🚀 차드답다고? 틀렸다! 이제 LEGENDARY BEAST MODE다, YOU MONSTER! 🚀'**
  String get completionMessage4;

  /// 완료 메시지 5
  ///
  /// In ko, this message translates to:
  /// **'⚡ 차드 에너지 레벨: ∞ 무한대 돌파! 우주가 경배한다! ⚡'**
  String get completionMessage5;

  /// 완료 메시지 6
  ///
  /// In ko, this message translates to:
  /// **'🦁 존경? 그딴 건 지났다! 이제 온 세상이 너에게 절한다, 만삣삐! 🦁'**
  String get completionMessage6;

  /// 완료 메시지 7
  ///
  /// In ko, this message translates to:
  /// **'🔱 차드가 승인했다고? 아니다! GOD TIER가 탄생을 인정했다! 🔱'**
  String get completionMessage7;

  /// 완료 메시지 8
  ///
  /// In ko, this message translates to:
  /// **'🌪️ 차드 게임 레벨업? 틀렸다! ALPHA DIMENSION을 정복했다, FXXK BEAST! 🌪️'**
  String get completionMessage8;

  /// 완료 메시지 9
  ///
  /// In ko, this message translates to:
  /// **'💥 순수한 차드 퍼포먼스가 아니다... 이제 PURE LEGENDARY DOMINANCE! 💥'**
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
  /// **'이전 운동을 이어서 계속할래?\\n아니면 새 운동을 시작할래?'**
  String get continueOrStartNew;

  /// 저작권 및 슬로건
  ///
  /// In ko, this message translates to:
  /// **'© 2024 Mission 100 Team\n모든 권리 보유\n\n💪 강자가 되는 그 날까지!'**
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

  /// 삭제 버튼 텍스트
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
  /// **'차드가 되는 여정을 함께해'**
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
  /// **'기가 차드 - 전설의 영역'**
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

  /// Mission 100 앱 다운로드 메시지
  ///
  /// In ko, this message translates to:
  /// **'Mission: 100 앱 다운로드해라! 약자는 도망가라!'**
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
  /// **'기가차드'**
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
  /// **'차드를 위해 ❤️로 제작'**
  String get madeWithLove;

  /// 분 단위
  ///
  /// In ko, this message translates to:
  /// **'분'**
  String get minutes;

  /// 개발팀 이름
  ///
  /// In ko, this message translates to:
  /// **'Mission 100 Team'**
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

  /// 밸런스 차드 모드 설명
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

  /// 저장소 권한 요청 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장소 권한이 필요한다. 설정에서 허용해주세요.'**
  String get permissionStorageMessage;

  /// 권한 요청 설명
  ///
  /// In ko, this message translates to:
  /// **'Mission 100에서 최고의 경험을 위해\n다음 권한들이 필요한다:'**
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
  /// **'정기적인 푸시업은 심박출량을 20% 증가시켜 전신 순환을 개선한다.'**
  String get scientificFact10Content;

  /// 과학적 팩트 10번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'❤️ 강력한 심장 펀프 업그레이드!'**
  String get scientificFact10Impact;

  /// 과학적 팩트 10번 - 심박출량 증가 제목
  ///
  /// In ko, this message translates to:
  /// **'심박출량 증가'**
  String get scientificFact10Title;

  /// 과학적 팩트 11번 내용
  ///
  /// In ko, this message translates to:
  /// **'푸시업은 모세혈관 밀도를 30% 증가시켜 근육과 뇌로의 산소 공급을 개선한다.'**
  String get scientificFact11Content;

  /// 과학적 팩트 11번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌊 생명의 고속도로 확장 공사!'**
  String get scientificFact11Impact;

  /// 과학적 팩트 11번 - 혈관신생 촉진 제목
  ///
  /// In ko, this message translates to:
  /// **'혈관신생 촉진'**
  String get scientificFact11Title;

  /// 과학적 팩트 12번 내용
  ///
  /// In ko, this message translates to:
  /// **'12주간의 푸시업 프로그램은 수축기 혈압을 평균 8mmHg 감소시킵니다.'**
  String get scientificFact12Content;

  /// 과학적 팩트 12번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'📉 혈압의 자연스러운 정상화!'**
  String get scientificFact12Impact;

  /// 과학적 팩트 12번 - 혈압 정상화 제목
  ///
  /// In ko, this message translates to:
  /// **'혈압 정상화'**
  String get scientificFact12Title;

  /// 과학적 팩트 13번 내용
  ///
  /// In ko, this message translates to:
  /// **'규칙적인 푸시업은 심박변이도를 35% 향상시켜 스트레스 저항력을 증가시킵니다.'**
  String get scientificFact13Content;

  /// 과학적 팩트 13번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'💎 다이아몬드 같은 심장 리듬!'**
  String get scientificFact13Impact;

  /// 과학적 팩트 13번 - 심박변이도 향상 제목
  ///
  /// In ko, this message translates to:
  /// **'심박변이도 향상'**
  String get scientificFact13Title;

  /// 과학적 팩트 14번 내용
  ///
  /// In ko, this message translates to:
  /// **'고강도 푸시업은 혈관 내피세포 기능을 25% 개선하여 혈관 건강을 증진시킵니다.'**
  String get scientificFact14Content;

  /// 과학적 팩트 14번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'✨ 혈관의 절음 회복!'**
  String get scientificFact14Impact;

  /// 과학적 팩트 14번 - 내피세포 기능 개선 제목
  ///
  /// In ko, this message translates to:
  /// **'내피세포 기능 개선'**
  String get scientificFact14Title;

  /// 과학적 팩트 15번 내용
  ///
  /// In ko, this message translates to:
  /// **'근력 운동인 푸시업은 기초대사율을 15% 증가시켜 24시간 칼로리 소모를 늘립니다.'**
  String get scientificFact15Content;

  /// 과학적 팩트 15번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥 24시간 지방 연소 시스템!'**
  String get scientificFact15Impact;

  /// 과학적 팩트 15번 - 기초대사율 증가 제목
  ///
  /// In ko, this message translates to:
  /// **'기초대사율 증가'**
  String get scientificFact15Title;

  /// 과학적 팩트 16번 내용
  ///
  /// In ko, this message translates to:
  /// **'8주간의 푸시업 훈련은 인슐린 감수성을 40% 향상시켜 혈당 조절을 개선한다.'**
  String get scientificFact16Content;

  /// 과학적 팩트 16번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'📊 완벽한 혈당 제어 시스템!'**
  String get scientificFact16Impact;

  /// 과학적 팩트 16번 - 인슐린 감수성 향상 제목
  ///
  /// In ko, this message translates to:
  /// **'인슐린 감수성 향상'**
  String get scientificFact16Title;

  /// 과학적 팩트 17번 내용
  ///
  /// In ko, this message translates to:
  /// **'푸시업은 지방 산화 효소 활성을 50% 증가시켜 체지방 감소를 가속화한다.'**
  String get scientificFact17Content;

  /// 과학적 팩트 17번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥 지방 용해 터보 엔진!'**
  String get scientificFact17Impact;

  /// 과학적 팩트 17번 - 지방 산화 증진 제목
  ///
  /// In ko, this message translates to:
  /// **'지방 산화 증진'**
  String get scientificFact17Title;

  /// 과학적 팩트 18번 내용
  ///
  /// In ko, this message translates to:
  /// **'고강도 운동은 갈색지방을 활성화시켜 열 생성을 통한 칼로리 소모를 증가시킵니다.'**
  String get scientificFact18Content;

  /// 과학적 팩트 18번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'♨️ 내장 난방 시스템 가동!'**
  String get scientificFact18Impact;

  /// 과학적 팩트 18번 - 갈색지방 활성화 제목
  ///
  /// In ko, this message translates to:
  /// **'갈색지방 활성화'**
  String get scientificFact18Title;

  /// 과학적 팩트 19번 내용
  ///
  /// In ko, this message translates to:
  /// **'고강도 푸시업은 운동 후 최대 24시간 동안 산소 소비량을 증가시켜 추가 칼로리를 소모한다.'**
  String get scientificFact19Content;

  /// 과학적 팩트 19번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌪️ 24시간 애프터번 효과!'**
  String get scientificFact19Impact;

  /// 과학적 팩트 19번 - 운동 후 산소 소비량 제목
  ///
  /// In ko, this message translates to:
  /// **'운동 후 산소 소비량'**
  String get scientificFact19Title;

  /// 과학적 팩트 1 내용
  ///
  /// In ko, this message translates to:
  /// **'정기적인 푸시업은 느린 근섬유(Type I)를 빠른 근섬유(Type II)로 변환시켜 폭발적인 힘을 증가시킵니다.'**
  String get scientificFact1Content;

  /// 과학적 팩트 1 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'💪 근육의 질적 변화가 일어나고 있다!'**
  String get scientificFact1Impact;

  /// 과학적 팩트 1 제목
  ///
  /// In ko, this message translates to:
  /// **'근섬유 타입의 변화'**
  String get scientificFact1Title;

  /// 과학적 팩트 20번 내용
  ///
  /// In ko, this message translates to:
  /// **'고강도 푸시업은 성장호르몬 분비를 최대 500% 증가시켜 근육 성장과 회복을 촉진한다.'**
  String get scientificFact20Content;

  /// 과학적 팩트 20번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🚀 청춘의 호르몬 폭발!'**
  String get scientificFact20Impact;

  /// 과학적 팩트 20번 - 성장호르몬 급증 제목
  ///
  /// In ko, this message translates to:
  /// **'성장호르몬 급증'**
  String get scientificFact20Title;

  /// 과학적 팩트 21번 내용
  ///
  /// In ko, this message translates to:
  /// **'푸시업 훈련은 운동 단위 간 동조화를 70% 향상시켜 폭발적인 힘 발휘를 가능하게 한다.'**
  String get scientificFact21Content;

  /// 과학적 팩트 21번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 신경과 근육의 완벽한 하모니!'**
  String get scientificFact21Impact;

  /// 과학적 팩트 21번 - 운동 단위 동조화 제목
  ///
  /// In ko, this message translates to:
  /// **'운동 단위 동조화'**
  String get scientificFact21Title;

  /// 과학적 팩트 22번 내용
  ///
  /// In ko, this message translates to:
  /// **'규칙적인 푸시업은 운동 피질의 신경가소성을 45% 증가시켜 학습 능력을 향상시킵니다.'**
  String get scientificFact22Content;

  /// 과학적 팩트 22번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🧠 뇌도 함께 진화하고 있다!'**
  String get scientificFact22Impact;

  /// 과학적 팩트 22번 - 신경가소성 증진 제목
  ///
  /// In ko, this message translates to:
  /// **'신경가소성 증진'**
  String get scientificFact22Title;

  /// 과학적 팩트 23번 내용
  ///
  /// In ko, this message translates to:
  /// **'고강도 푸시업은 뇌유래신경영양인자(BDNF)를 최대 300% 증가시켜 뇌 건강을 개선한다.'**
  String get scientificFact23Content;

  /// 과학적 팩트 23번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌟 뇌의 젊음 회복 프로그램 가동!'**
  String get scientificFact23Impact;

  /// 과학적 팩트 23번 - BDNF 분비 증가 제목
  ///
  /// In ko, this message translates to:
  /// **'BDNF 분비 증가'**
  String get scientificFact23Title;

  /// 과학적 팩트 24번 내용
  ///
  /// In ko, this message translates to:
  /// **'14주간의 푸시업 훈련은 신경 전달 속도를 15% 향상시켜 반응 시간을 단축시킵니다.'**
  String get scientificFact24Content;

  /// 과학적 팩트 24번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 번개 같은 반사신경 획득!'**
  String get scientificFact24Impact;

  /// 과학적 팩트 24번 - 반응 속도 개선 제목
  ///
  /// In ko, this message translates to:
  /// **'반응 속도 개선'**
  String get scientificFact24Title;

  /// 과학적 팩트 25번 내용
  ///
  /// In ko, this message translates to:
  /// **'복합 운동인 푸시업은 척수 인터뉴런의 억제 기능을 25% 개선하여 동작의 정확성을 높이다.'**
  String get scientificFact25Content;

  /// 과학적 팩트 25번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎯 완벽한 동작 제어 시스템 구축!'**
  String get scientificFact25Impact;

  /// 과학적 팩트 25번 - 인터뉴런 활성화 제목
  ///
  /// In ko, this message translates to:
  /// **'인터뉴런 활성화'**
  String get scientificFact25Title;

  /// 과학적 팩트 2 내용
  ///
  /// In ko, this message translates to:
  /// **'푸시업은 근육 내 미토콘드리아 밀도를 최대 40% 증가시켜 에너지 생산을 극대화한다.'**
  String get scientificFact2Content;

  /// 과학적 팩트 2 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 무한 에너지 시스템이 구축되고 있다!'**
  String get scientificFact2Impact;

  /// 과학적 팩트 2 제목
  ///
  /// In ko, this message translates to:
  /// **'미토콘드리아 밀도 증가'**
  String get scientificFact2Title;

  /// 과학적 팩트 3번 내용
  ///
  /// In ko, this message translates to:
  /// **'푸시업은 근육 성장의 핵심인 mTOR 신호전달을 300% 활성화시킵니다.'**
  String get scientificFact3Content;

  /// 과학적 팩트 3번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🚀 근육 성장 터보 엔진이 작동한다!'**
  String get scientificFact3Impact;

  /// 과학적 팩트 3번 - mTOR 신호전달 활성화 제목
  ///
  /// In ko, this message translates to:
  /// **'mTOR 신호전달 활성화'**
  String get scientificFact3Title;

  /// 과학적 팩트 4번 내용
  ///
  /// In ko, this message translates to:
  /// **'한 번 발달한 근육은 운동을 중단해도 핵 도메인이 유지되어 10년 후에도 빠른 회복이 가능한다.'**
  String get scientificFact4Content;

  /// 과학적 팩트 4번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🧐 영원한 근육 기억이 새겨지고 있다!'**
  String get scientificFact4Impact;

  /// 과학적 팩트 4번 - 근육 기억의 영속성 제목
  ///
  /// In ko, this message translates to:
  /// **'근육 기억의 영속성'**
  String get scientificFact4Title;

  /// 과학적 팩트 5번 내용
  ///
  /// In ko, this message translates to:
  /// **'푸시업 훈련은 운동 단위 간 동조화를 70% 향상시켜 폭발적인 힘 발휘를 가능하게 한다.'**
  String get scientificFact5Content;

  /// 과학적 팩트 5번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 신경과 근육의 완벽한 하모니!'**
  String get scientificFact5Impact;

  /// 과학적 팩트 5번 - 운동 단위 동조화 제목
  ///
  /// In ko, this message translates to:
  /// **'운동 단위 동조화'**
  String get scientificFact5Title;

  /// 과학적 팩트 6번 내용
  ///
  /// In ko, this message translates to:
  /// **'규칙적인 푸시업은 운동 피질의 신경가소성을 45% 증가시켜 학습 능력을 향상시킵니다.'**
  String get scientificFact6Content;

  /// 과학적 팩트 6번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🧐 뇌도 함께 진화하고 있다!'**
  String get scientificFact6Impact;

  /// 과학적 팩트 6번 - 신경가소성 증진 제목
  ///
  /// In ko, this message translates to:
  /// **'신경가소성 증진'**
  String get scientificFact6Title;

  /// 과학적 팩트 7번 내용
  ///
  /// In ko, this message translates to:
  /// **'고강도 푸시업은 뇌유래신경영양인자(BDNF)를 최대 300% 증가시켜 뇌 건강을 개선한다.'**
  String get scientificFact7Content;

  /// 과학적 팩트 7번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🌟 뇌의 절음 회복 프로그램 가동!'**
  String get scientificFact7Impact;

  /// 과학적 팩트 7번 - BDNF 분비 증가 제목
  ///
  /// In ko, this message translates to:
  /// **'BDNF 분비 증가'**
  String get scientificFact7Title;

  /// 과학적 팩트 8번 내용
  ///
  /// In ko, this message translates to:
  /// **'14주간의 푸시업 훈련은 신경 전달 속도를 15% 향상시켜 반응 시간을 단축시킵니다.'**
  String get scientificFact8Content;

  /// 과학적 팩트 8번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ 번개 같은 반사신경 획득!'**
  String get scientificFact8Impact;

  /// 과학적 팩트 8번 - 반응 속도 개선 제목
  ///
  /// In ko, this message translates to:
  /// **'반응 속도 개선'**
  String get scientificFact8Title;

  /// 과학적 팩트 9번 내용
  ///
  /// In ko, this message translates to:
  /// **'복합 운동인 푸시업은 척수 인터뉴런의 억제 기능을 25% 개선하여 동작의 정확성을 높이다.'**
  String get scientificFact9Content;

  /// 과학적 팩트 9번 임팩트 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎯 완벽한 동작 제어 시스템 구축!'**
  String get scientificFact9Impact;

  /// 과학적 팩트 9번 - 인터뉴런 활성화 제목
  ///
  /// In ko, this message translates to:
  /// **'인터뉴런 활성화'**
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
  /// **'💬 너의 의견을 들려달라! 차드들의 목소리가 필요하다!'**
  String get sendFeedbackDesc;

  /// 공유 버튼 라벨
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
  /// **'📁 운동 데이터 안전 백업'**
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
  /// **'운동 데이터 백업 및 복원을 위해 필요한다'**
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
  /// **'Mission: 100 v1.0.0'**
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

  /// No description provided for @premiumBenefitAdFree.
  ///
  /// In ko, this message translates to:
  /// **'✨ 모든 광고 제거'**
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
  /// **'차드 레전드'**
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
  /// **'🎉 Mission: 100에 가입해주셔서 감사합니다!'**
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
  /// **'• 전체 14주 프로그램 접근'**
  String get benefit14WeeksProgram;

  /// No description provided for @benefitAllChadStages.
  ///
  /// In ko, this message translates to:
  /// **'• 모든 차드 진화 단계'**
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
  /// **'전체 14주 프로그램 + 모든 차드 + 상세 통계'**
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
  /// **'Mission: 100 시작하기'**
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
  /// **'• 전체 14주 프로그램 접근'**
  String get signupPromptBenefit2;

  /// No description provided for @signupPromptBenefit3.
  ///
  /// In ko, this message translates to:
  /// **'• 모든 차드 진화 단계'**
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
  /// **'이미 차드 계정이 있나요?'**
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

  /// 한계 시험 챌린지 메시지
  ///
  /// In ko, this message translates to:
  /// **'💪 오늘 너의 한계를 시험해볼까?'**
  String get challengeTestYourLimits;

  /// 초기 테스트 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'초기 테스트를 완료하여 프로필을 생성해주세요'**
  String get completeInitialTest;

  /// No description provided for @getStartedButton.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get getStartedButton;

  /// 온보딩 적응형 훈련 설명
  ///
  /// In ko, this message translates to:
  /// **'힘들면? → 강도 낮춘다 ⬇️\n쉬우면? → 강도 올린다 ⬆️\n\n너한테 딱 맞는 난이도로 간다! 🔥'**
  String get onboardingAdaptiveTrainingDescription;

  /// 온보딩 적응형 훈련 제목
  ///
  /// In ko, this message translates to:
  /// **'🎯 너한테 딱 맞춰준다'**
  String get onboardingAdaptiveTrainingTitle;

  /// 온보딩 적응형 훈련 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'오케이! 👌'**
  String get onboardingButtonGotIt;

  /// 온보딩 진화 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'각 잡혔다! 💪'**
  String get onboardingButtonGreat;

  /// 온보딩 다음 버튼
  ///
  /// In ko, this message translates to:
  /// **'계속 간다! 💪'**
  String get onboardingButtonNext;

  /// 온보딩 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'바로 간다! 🔥'**
  String get onboardingButtonStart;

  /// 온보딩 테스트 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'바로 체크! 🎯'**
  String get onboardingButtonStartTest;

  /// 온보딩 초기 테스트 설명
  ///
  /// In ko, this message translates to:
  /// **'지금 실력 체크하고\n너한테 딱 맞는 프로그램 시작한다.\n\n• 최대한 많이 해봐\n• 정확한 자세로\n• 결과로 맞춤 프로그램 완성'**
  String get onboardingInitialTestDescription;

  /// 온보딩 초기 테스트 제목
  ///
  /// In ko, this message translates to:
  /// **'실력 체크 타임 ⏱️'**
  String get onboardingInitialTestTitle;

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
  /// **'14주면 충분해. 너도 100개 간다.\n각 잡고 시작하자! 💪'**
  String get onboardingWelcomeDescription;

  /// 온보딩 환영 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'14주, 100개. 가능하다! 🔥'**
  String get onboardingWelcomeTitle;

  /// No description provided for @startTestButton.
  ///
  /// In ko, this message translates to:
  /// **'테스트 시작'**
  String get startTestButton;

  /// No description provided for @stepByStepGuide.
  ///
  /// In ko, this message translates to:
  /// **'단계별\n가이드'**
  String get stepByStepGuide;

  /// No description provided for @testAdMessage.
  ///
  /// In ko, this message translates to:
  /// **'테스트 광고 - 피트니스 앱'**
  String get testAdMessage;

  /// No description provided for @tutorialButton.
  ///
  /// In ko, this message translates to:
  /// **'💥 PUSHUP MASTER 되기 💥'**
  String get tutorialButton;

  /// No description provided for @tutorialDetailTitle.
  ///
  /// In ko, this message translates to:
  /// **'💥 EMPEROR 자세 MASTER하기 💥'**
  String get tutorialDetailTitle;

  /// No description provided for @tutorialSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'진짜 EMPEROR는 자세부터 다르다! 💪'**
  String get tutorialSubtitle;

  /// No description provided for @tutorialTitle.
  ///
  /// In ko, this message translates to:
  /// **'🔥 ALPHA EMPEROR PUSHUP DOJO 🔥'**
  String get tutorialTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In ko, this message translates to:
  /// **'🔥 WELCOME,\nFUTURE EMPEROR! 🔥\n정복의 시간이다!'**
  String get welcomeMessage;

  /// No description provided for @startJourney.
  ///
  /// In ko, this message translates to:
  /// **'여정 시작하기! 🚀'**
  String get startJourney;

  /// No description provided for @setWorkoutSchedule.
  ///
  /// In ko, this message translates to:
  /// **'🔥 운동 스케줄을 설정하세요!'**
  String get setWorkoutSchedule;

  /// No description provided for @workoutScheduleDescription.
  ///
  /// In ko, this message translates to:
  /// **'진정한 챔피언이 되려면 일관성이 필요합니다!\n주 3일 이상 운동해야 합니다. 💪\n\n라이프스타일에 맞는 날을 선택하고,\n알림으로 핑계를 차단하세요! 🚀'**
  String get workoutScheduleDescription;

  /// No description provided for @goalSetupComplete.
  ///
  /// In ko, this message translates to:
  /// **'🎉 목표 설정 완료!'**
  String get goalSetupComplete;

  /// No description provided for @goalSetupCompleteMessage.
  ///
  /// In ko, this message translates to:
  /// **'이제 당신만의 맞춤형 Mission: 100이 시작됩니다.\n런칭 이벤트로 1개월 무료 체험해보세요!'**
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
  /// **'최신 스포츠 과학 논문을\n바탕으로 설계된 프로그램'**
  String get scientificBasisDesc;

  /// No description provided for @progressiveOverloadTitle.
  ///
  /// In ko, this message translates to:
  /// **'점진적 과부하'**
  String get progressiveOverloadTitle;

  /// No description provided for @progressiveOverloadDesc.
  ///
  /// In ko, this message translates to:
  /// **'매주 체계적으로 증가하는\n운동량으로 안전한 성장'**
  String get progressiveOverloadDesc;

  /// No description provided for @rpeAdaptationTitle.
  ///
  /// In ko, this message translates to:
  /// **'RPE 기반 적응'**
  String get rpeAdaptationTitle;

  /// No description provided for @rpeAdaptationDesc.
  ///
  /// In ko, this message translates to:
  /// **'운동 강도를 기록하면\n자동으로 난이도 조정'**
  String get rpeAdaptationDesc;

  /// No description provided for @chadEvolutionTitle.
  ///
  /// In ko, this message translates to:
  /// **'차드 진화 시스템'**
  String get chadEvolutionTitle;

  /// No description provided for @chadEvolutionDesc.
  ///
  /// In ko, this message translates to:
  /// **'운동할수록 성장하는\n나만의 캐릭터'**
  String get chadEvolutionDesc;

  /// No description provided for @readyToStart.
  ///
  /// In ko, this message translates to:
  /// **'준비되셨나요?'**
  String get readyToStart;

  /// No description provided for @findYourLevel.
  ///
  /// In ko, this message translates to:
  /// **'먼저 간단한 레벨 테스트로\n당신의 시작점을 찾아보세요'**
  String get findYourLevel;

  /// No description provided for @step1LevelTest.
  ///
  /// In ko, this message translates to:
  /// **'레벨 테스트 (30초)'**
  String get step1LevelTest;

  /// No description provided for @step2SetStartDate.
  ///
  /// In ko, this message translates to:
  /// **'운동 시작일 설정'**
  String get step2SetStartDate;

  /// No description provided for @step3StartJourney.
  ///
  /// In ko, this message translates to:
  /// **'14주 여정 시작!'**
  String get step3StartJourney;

  /// No description provided for @awesome.
  ///
  /// In ko, this message translates to:
  /// **'멋져요!'**
  String get awesome;

  /// No description provided for @onboardingProgramIntroTitle.
  ///
  /// In ko, this message translates to:
  /// **'14주 프로그램 소개'**
  String get onboardingProgramIntroTitle;

  /// No description provided for @onboardingProgramIntroDescription.
  ///
  /// In ko, this message translates to:
  /// **'과학적으로 설계된 14주 프로그램으로\n100개 푸시업 달성을 목표로 합니다'**
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

  /// No description provided for @tutorialWelcomeTitle.
  ///
  /// In ko, this message translates to:
  /// **'🏋️ Mission 100'**
  String get tutorialWelcomeTitle;

  /// No description provided for @tutorialWelcomeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'14주 만에 푸시업 100개 달성'**
  String get tutorialWelcomeSubtitle;

  /// No description provided for @tutorialFeature1Title.
  ///
  /// In ko, this message translates to:
  /// **'과학적 근거 기반'**
  String get tutorialFeature1Title;

  /// No description provided for @tutorialFeature1Desc.
  ///
  /// In ko, this message translates to:
  /// **'최신 스포츠 과학 논문(2016-2024)을\n바탕으로 설계된 프로그램'**
  String get tutorialFeature1Desc;

  /// No description provided for @tutorialFeature2Title.
  ///
  /// In ko, this message translates to:
  /// **'점진적 과부하'**
  String get tutorialFeature2Title;

  /// No description provided for @tutorialFeature2Desc.
  ///
  /// In ko, this message translates to:
  /// **'매주 체계적으로 증가하는 운동량으로\n안전하고 효과적인 성장'**
  String get tutorialFeature2Desc;

  /// No description provided for @tutorialFeature3Title.
  ///
  /// In ko, this message translates to:
  /// **'개인화된 프로그램'**
  String get tutorialFeature3Title;

  /// No description provided for @tutorialFeature3Desc.
  ///
  /// In ko, this message translates to:
  /// **'당신의 레벨에 맞춘\n맞춤형 운동 계획'**
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
  /// **'14주 (총 42회)'**
  String get tutorialDurationSubtitle;

  /// No description provided for @tutorialDurationDesc.
  ///
  /// In ko, this message translates to:
  /// **'주 3회 운동 (월, 수, 금)\n48시간 회복 시간 보장'**
  String get tutorialDurationDesc;

  /// No description provided for @tutorialStructureTitle.
  ///
  /// In ko, this message translates to:
  /// **'💪 구성'**
  String get tutorialStructureTitle;

  /// No description provided for @tutorialStructureSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'푸시업 + 피니셔'**
  String get tutorialStructureSubtitle;

  /// No description provided for @tutorialStructureDesc.
  ///
  /// In ko, this message translates to:
  /// **'메인: 푸시업 5-9세트\n피니셔: 버피/점프스쿼트 등'**
  String get tutorialStructureDesc;

  /// No description provided for @tutorialRestTitle.
  ///
  /// In ko, this message translates to:
  /// **'⏳ 휴식 시간'**
  String get tutorialRestTitle;

  /// No description provided for @tutorialRestSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'과학적 최적화'**
  String get tutorialRestSubtitle;

  /// No description provided for @tutorialRestDesc.
  ///
  /// In ko, this message translates to:
  /// **'세트간: 45-120초\n레벨/주차별 자동 조정'**
  String get tutorialRestDesc;

  /// No description provided for @tutorialTipTitle.
  ///
  /// In ko, this message translates to:
  /// **'💡 꿀팁'**
  String get tutorialTipTitle;

  /// No description provided for @tutorialTipDesc.
  ///
  /// In ko, this message translates to:
  /// **'매 운동 후 RPE(운동자각도)를 기록하면\n다음 운동 강도가 자동으로 조정됩니다!'**
  String get tutorialTipDesc;

  /// No description provided for @tutorialFormTitle.
  ///
  /// In ko, this message translates to:
  /// **'✅ 올바른 푸시업 자세'**
  String get tutorialFormTitle;

  /// No description provided for @tutorialForm1Title.
  ///
  /// In ko, this message translates to:
  /// **'1. 시작 자세'**
  String get tutorialForm1Title;

  /// No description provided for @tutorialForm1Desc.
  ///
  /// In ko, this message translates to:
  /// **'손을 어깨 너비로 벌리고\n몸을 일직선으로 유지'**
  String get tutorialForm1Desc;

  /// No description provided for @tutorialForm2Title.
  ///
  /// In ko, this message translates to:
  /// **'2. 내려가기'**
  String get tutorialForm2Title;

  /// No description provided for @tutorialForm2Desc.
  ///
  /// In ko, this message translates to:
  /// **'가슴이 바닥에 닿을 때까지\n팔꿈치를 45도 각도로 구부리기'**
  String get tutorialForm2Desc;

  /// No description provided for @tutorialForm3Title.
  ///
  /// In ko, this message translates to:
  /// **'3. 올라오기'**
  String get tutorialForm3Title;

  /// No description provided for @tutorialForm3Desc.
  ///
  /// In ko, this message translates to:
  /// **'가슴과 코어에 힘을 주고\n폭발적으로 밀어올리기'**
  String get tutorialForm3Desc;

  /// No description provided for @tutorialWarningTitle.
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 주의사항'**
  String get tutorialWarningTitle;

  /// No description provided for @tutorialWarning1.
  ///
  /// In ko, this message translates to:
  /// **'허리가 처지지 않도록 코어에 힘주기'**
  String get tutorialWarning1;

  /// No description provided for @tutorialWarning2.
  ///
  /// In ko, this message translates to:
  /// **'목을 과도하게 젖히지 않기'**
  String get tutorialWarning2;

  /// No description provided for @tutorialWarning3.
  ///
  /// In ko, this message translates to:
  /// **'팔꿈치를 몸에 너무 붙이지 않기'**
  String get tutorialWarning3;

  /// No description provided for @tutorialWarning4.
  ///
  /// In ko, this message translates to:
  /// **'통증이 느껴지면 즉시 중단'**
  String get tutorialWarning4;

  /// No description provided for @tutorialRpeTitle.
  ///
  /// In ko, this message translates to:
  /// **'📊 RPE란?'**
  String get tutorialRpeTitle;

  /// No description provided for @tutorialRpeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'Rate of Perceived Exertion\n(운동자각도)'**
  String get tutorialRpeSubtitle;

  /// No description provided for @tutorialRpe6.
  ///
  /// In ko, this message translates to:
  /// **'😊 너무 쉬워요'**
  String get tutorialRpe6;

  /// No description provided for @tutorialRpe6Desc.
  ///
  /// In ko, this message translates to:
  /// **'다음엔 더 할 수 있어요'**
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
  /// **'🤯 한계 돌파!'**
  String get tutorialRpe10;

  /// No description provided for @tutorialRpe10Desc.
  ///
  /// In ko, this message translates to:
  /// **'정말 최선을 다했어요'**
  String get tutorialRpe10Desc;

  /// No description provided for @tutorialAutoAdjustTitle.
  ///
  /// In ko, this message translates to:
  /// **'🎯 똑똑한 자동 조정'**
  String get tutorialAutoAdjustTitle;

  /// No description provided for @tutorialAutoAdjustDesc.
  ///
  /// In ko, this message translates to:
  /// **'RPE를 기록하면 다음 운동 강도가\n자동으로 최적화됩니다!\n\n• RPE 6-7: 난이도 +5%\n• RPE 8: 유지\n• RPE 9-10: 난이도 -5%'**
  String get tutorialAutoAdjustDesc;

  /// No description provided for @tutorialScienceTitle.
  ///
  /// In ko, this message translates to:
  /// **'🔬 과학적 근거'**
  String get tutorialScienceTitle;

  /// No description provided for @tutorialScienceSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'최신 연구 결과를 바탕으로 설계되었습니다'**
  String get tutorialScienceSubtitle;

  /// No description provided for @tutorialResearch1Author.
  ///
  /// In ko, this message translates to:
  /// **'Schoenfeld et al. (2016, 2019)'**
  String get tutorialResearch1Author;

  /// No description provided for @tutorialResearch1Topic.
  ///
  /// In ko, this message translates to:
  /// **'근비대와 훈련 빈도'**
  String get tutorialResearch1Topic;

  /// No description provided for @tutorialResearch1Finding.
  ///
  /// In ko, this message translates to:
  /// **'주 3회 훈련이 근육 성장에 최적\n48시간 회복 시간 권장'**
  String get tutorialResearch1Finding;

  /// No description provided for @tutorialResearch2Author.
  ///
  /// In ko, this message translates to:
  /// **'Grgic et al. (2018)'**
  String get tutorialResearch2Author;

  /// No description provided for @tutorialResearch2Topic.
  ///
  /// In ko, this message translates to:
  /// **'세트간 휴식 시간'**
  String get tutorialResearch2Topic;

  /// No description provided for @tutorialResearch2Finding.
  ///
  /// In ko, this message translates to:
  /// **'60-120초 휴식이\n근비대에 가장 효과적'**
  String get tutorialResearch2Finding;

  /// No description provided for @tutorialResearch3Author.
  ///
  /// In ko, this message translates to:
  /// **'Plotkin et al. (2022)'**
  String get tutorialResearch3Author;

  /// No description provided for @tutorialResearch3Topic.
  ///
  /// In ko, this message translates to:
  /// **'점진적 과부하'**
  String get tutorialResearch3Topic;

  /// No description provided for @tutorialResearch3Finding.
  ///
  /// In ko, this message translates to:
  /// **'점진적 반복 증가가\n근력 향상에 효과적'**
  String get tutorialResearch3Finding;

  /// No description provided for @tutorialResearch4Author.
  ///
  /// In ko, this message translates to:
  /// **'Wang et al. (2024)'**
  String get tutorialResearch4Author;

  /// No description provided for @tutorialResearch4Topic.
  ///
  /// In ko, this message translates to:
  /// **'HIIT + 저항운동 병행'**
  String get tutorialResearch4Topic;

  /// No description provided for @tutorialResearch4Finding.
  ///
  /// In ko, this message translates to:
  /// **'유산소와 근력운동 병행 시\n체력과 근력 동시 향상'**
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
  /// **'운동 기록을 백업한다'**
  String get backupWorkoutRecords;

  /// Best week label
  ///
  /// In ko, this message translates to:
  /// **'최고 주차'**
  String get bestWeek;

  /// 총 운동 횟수 부제목
  ///
  /// In ko, this message translates to:
  /// **'강자가 된 날들!'**
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
  /// **'14일 동안 연속으로 운동하기'**
  String get challenge14DaysDescription;

  /// 14 consecutive days challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'하루도 안 빠지고 14일 연속! 7일 챌린지 클리어 후 도전! 💪'**
  String get challenge14DaysDetailedDescription;

  /// 14 consecutive days challenge title
  ///
  /// In ko, this message translates to:
  /// **'14일 연속 운동'**
  String get challenge14DaysTitle;

  /// 7 consecutive days challenge description
  ///
  /// In ko, this message translates to:
  /// **'7일 동안 연속으로 운동하기'**
  String get challenge7DaysDescription;

  /// 7 consecutive days challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'하루도 안 빠지고 7일 연속! 매일 최소 1세트! 🔥'**
  String get challenge7DaysDetailedDescription;

  /// 7 consecutive days challenge title
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 운동'**
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

  /// 연속 운동 차단 제목
  ///
  /// In ko, this message translates to:
  /// **'STOP! 연속 운동 금지!'**
  String get consecutiveWorkoutBlocked;

  /// 연속 운동 차단 메시지
  ///
  /// In ko, this message translates to:
  /// **'야야야! 어제 운동했잖아! 🔥\n\n지금 뭘 하려는거야? 연속 운동이야?\n진짜 강자라면 쉴 때 확실히 쉬는 거다!\n\n💀 오버트레이닝은 노답이야!\n😎 오늘은 쿨하게 쉬고 내일 다시 가자! 💪'**
  String get consecutiveWorkoutMessage;

  /// Custom workout days setting
  ///
  /// In ko, this message translates to:
  /// **'운동일 설정'**
  String get customWorkoutDays;

  /// Custom workout days description
  ///
  /// In ko, this message translates to:
  /// **'원하는 요일에 운동하도록 설정해'**
  String get customWorkoutDaysDesc;

  /// 일일 알림 설정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'매일 {time} 운동 알림 설정 완료! 💪'**
  String dailyNotificationSet(Object time);

  /// 매일 운동 시간 알림 메시지
  ///
  /// In ko, this message translates to:
  /// **'매일 운동 시간 알림! 놓치면 WEAK! 💪'**
  String get dailyWorkoutAlarm;

  /// 일일 운동 알림 설정
  ///
  /// In ko, this message translates to:
  /// **'일일 운동 알림'**
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
  /// **'모든 운동 기록을 삭제한다'**
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
  /// **'첫 번째 워크아웃 완료'**
  String get firstWorkoutCompleted;

  /// 첫 운동 시작 메시지
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 운동을 시작한다! 화이팅!'**
  String get firstWorkoutMessage;

  /// 발견된 운동 제목
  ///
  /// In ko, this message translates to:
  /// **'🔍 발견된 운동'**
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
  /// **'홈트 팔굽혀펴기 🏠'**
  String get homeWorkoutPushups;

  /// Hundred reps in one session description
  ///
  /// In ko, this message translates to:
  /// **'한 세션에 100회 달성'**
  String get hundredRepsInOneSession;

  /// 미완료 운동 발견 메시지
  ///
  /// In ko, this message translates to:
  /// **'미완료된 운동이 발견되었다!'**
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
  /// **'최대 6일까지만 운동할 수 있다 (하루는 쉬어야 함)'**
  String get maxSixDaysWorkout;

  /// 최소 하루 쉬는 날 필요 메시지
  ///
  /// In ko, this message translates to:
  /// **'최소 하루는 쉬는 날이 있어야 한다'**
  String get minOneDayRest;

  /// Mission 100 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'Mission 100 설정'**
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
  /// **'주 4회까지만 운동할 수 있다. 충분한 휴식이 필요한다!'**
  String get noConsecutiveSixDays;

  /// 운동하기로 결정 버튼
  ///
  /// In ko, this message translates to:
  /// **'아니다! 운동할래!'**
  String get noWorkout;

  /// 운동 기록이 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'운동 기록이 없다'**
  String get noWorkoutHistory;

  /// 선택된 날짜에 운동 기록 없음
  ///
  /// In ko, this message translates to:
  /// **'이 날에는 운동 기록이 없다'**
  String get noWorkoutRecordForDate;

  /// 운동 기록 없음 제목
  ///
  /// In ko, this message translates to:
  /// **'아직 운동 기록이 없어!'**
  String get noWorkoutRecords;

  /// 운동 기록이 없는 날 메시지
  ///
  /// In ko, this message translates to:
  /// **'이 날에는 운동 기록이 없다'**
  String get noWorkoutThisDay;

  /// 오늘의 운동 없음 메시지 - 스타일
  ///
  /// In ko, this message translates to:
  /// **'🤷‍♂️ 오늘은 휴식? 내일은 더 파괴적으로! 🔥'**
  String get noWorkoutToday;

  /// No workouts today message
  ///
  /// In ko, this message translates to:
  /// **'이 날에는 워크아웃이 없다'**
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
  /// **'집에서 할 수 있는 완벽한 운동'**
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

  /// 최근 운동 기록 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 운동 기록'**
  String get recentWorkouts;

  /// 운동 기록 형식
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
  /// **'휴식일 보너스 챌린지! 💪\n\n• 플랭크 30초 x 3세트\n• 스쿼트 20개 x 2세트\n• 푸시업 10개 (완벽한 자세로!)\n\n준비됐어? 진짜 챔피언만 할 수 있어! 🏆'**
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
  /// **'누군가는 100개 푸시업하고 있어! 💪\n\n정말 오늘은 쉬실 건가요?'**
  String get restDayTeasing;

  /// 휴식 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'쉬는 것도 성장이야. 다음은 더 파괴적으로 가자, 만삣삐 🦍'**
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
  /// **'💪 운동 재개'**
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
  /// **'운동할 요일을 선택해 (최대 6일)'**
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
  /// **'7일 연속 운동'**
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
  /// **'운동 효과음 활성화'**
  String get soundSettingsDesc;

  /// 첫 운동 시작 메시지
  ///
  /// In ko, this message translates to:
  /// **'첫 운동을 시작하고\\n나만의 전설을 만들어보자! 🔥'**
  String get startFirstWorkout;

  /// 새 운동 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'새 운동 시작'**
  String get startNewWorkout;

  /// 오늘 운동 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'🚀 오늘의 DOMINATION 시작! 🚀'**
  String get startTodayWorkout;

  /// 운동 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'운동 시작'**
  String get startWorkout;

  /// 연속 일수 형식
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String streakDays(int days);

  /// 연속 운동 알림 설정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'연속 운동 격려 알림이 설정되었다!'**
  String get streakNotificationSet;

  /// 설정 저장 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ ALPHA SETTINGS LOCKED! 완벽한 설정으로 무장 완료! ⚡'**
  String get successSettingsSaved;

  /// 운동 완료 성공 메시지
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

  /// 이번 달 운동 횟수
  ///
  /// In ko, this message translates to:
  /// **'이번 달 운동'**
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

  /// 오늘 운동 완료 축하 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎉 오늘 운동 완료! 🎉'**
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

  /// 총 운동 횟수
  ///
  /// In ko, this message translates to:
  /// **'총 운동 횟수'**
  String get totalWorkouts;

  /// 영상 설명 3
  ///
  /// In ko, this message translates to:
  /// **'진정한 차드가 되는 마인드셋'**
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

  /// 직장인 차드 모드 설명
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
  /// **'7일 연속 운동'**
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

  /// 요일별 운동 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'요일별 운동 시간 설정'**
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

  /// 운동 리마인더 자동 갱신 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'운동 리마인더가 자동으로 갱신되었다. 계속해서 건강한 운동 습관을 유지해! 💪'**
  String get workoutAutoRenewalBody;

  /// 운동 리마인더 자동 갱신 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'⏰ 운동 리마인더 자동 갱신'**
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
  /// **'워크아웃 캘린더'**
  String get workoutCalendar;

  /// 운동 차트 제목
  ///
  /// In ko, this message translates to:
  /// **'운동 차트'**
  String get workoutChart;

  /// 운동 완료 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'레전드다, 만삣삐!'**
  String get workoutCompleteButton;

  /// 운동 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'{title} 완전 파괴!\n총 파워 해방: {totalReps}회! 해냈다! ⚡'**
  String workoutCompleteMessage(String title, int totalReps);

  /// 운동 완료 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 굿 잡, 만삣삐! 야수 모드 완료! 👑'**
  String get workoutCompleteTitle;

  /// 운동 완료 상태
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get workoutCompleted;

  /// 운동 완룀 축하 알림 채널 설명
  ///
  /// In ko, this message translates to:
  /// **'운동 완료 축하 알림'**
  String get workoutCompletionChannelDescription;

  /// 운동 완료 성취 메시지
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
  /// **'{month}월 {day}일 워크아웃'**
  String workoutDate(int day, int month);

  /// Workout day notification
  ///
  /// In ko, this message translates to:
  /// **'운동일 전용 알림'**
  String get workoutDayNotification;

  /// Workout day selection title
  ///
  /// In ko, this message translates to:
  /// **'운동 요일 선택'**
  String get workoutDaySelection;

  /// 운동일 전용 모드 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'💪 운동일 전용 알림 모드 활성화! 월,수,금에만 알림이 옵니다!'**
  String get workoutDaysModeActivated;

  /// 운동일 전용 알림 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'🔥 운동일 전용 알림'**
  String get workoutDaysOnlyNotifications;

  /// 운동일 전용 알림 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'매일이 아닌 운동일(월,수,금)에만 알림을 받다. 휴식일엔 방해받지 않아요!'**
  String get workoutDaysOnlyNotificationsDesc;

  /// 운동 상세 정보
  ///
  /// In ko, this message translates to:
  /// **'운동: {title}\\n완료된 세트: {sets}개\\n총 횟수: {reps}회'**
  String workoutDetailsWithStats(int reps, int sets, String title);

  /// 운동 기록 로딩 실패 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'운동 기록을 불러오는 중 오류가 발생했다: {error}'**
  String workoutHistoryLoadError(String error);

  /// 운동 중단 발견 경고
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 운동 중단 발견'**
  String get workoutInterruptionDetected;

  /// No description provided for @workoutNotificationPermission.
  ///
  /// In ko, this message translates to:
  /// **'🔔 운동 알림 권한'**
  String get workoutNotificationPermission;

  /// 운동 주의사항
  ///
  /// In ko, this message translates to:
  /// **'• 최소 하루는 쉬는 날이 있어야 한다\n• 연속으로 6일 이상 운동할 수 없다\n• 충분한 휴식은 근육 성장에 필수이다'**
  String get workoutPrecautions;

  /// 운동 완료 처리 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'운동 완료 처리 중...'**
  String get workoutProcessing;

  /// 선택된 날짜의 운동 기록
  ///
  /// In ko, this message translates to:
  /// **'{month}/{day} 운동 기록'**
  String workoutRecordForDate(int day, int month);

  /// 운동 기록 및 통계 항목
  ///
  /// In ko, this message translates to:
  /// **'• 운동 기록 및 통계'**
  String get workoutRecordsStats;

  /// 운동 리마인더 설정
  ///
  /// In ko, this message translates to:
  /// **'운동 리마인더'**
  String get workoutReminder;

  /// 기본 운동 리마인더 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'💪 MISSION 100 운동 시간! LEGENDARY MODE 활성화! 💪'**
  String get workoutReminderDefaultBody;

  /// 운동 리마인더 비활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'운동 리마인더가 비활성화되었다'**
  String get workoutReminderDisabled;

  /// 운동 리마인더 활성화 메시지
  ///
  /// In ko, this message translates to:
  /// **'운동 리마인더가 활성화되었다'**
  String get workoutReminderEnabled;

  /// 운동 리마인더 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'운동 리마인더 설정'**
  String get workoutReminderSettings;

  /// 운동 리마인더 옵션
  ///
  /// In ko, this message translates to:
  /// **'운동 리마인더'**
  String get workoutReminders;

  /// 운동 리마인더 알림 채널 설명
  ///
  /// In ko, this message translates to:
  /// **'요일별 운동 알림'**
  String get workoutRemindersChannelDescription;

  /// 운동 리마인더 설명
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
  /// **'💪 운동 설정'**
  String get workoutSettings;

  /// 운동 시작 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'⚡ ALPHA SYSTEM ERROR! 재시도하라, 만삣삐: {error} ⚡'**
  String workoutStartError(String error);

  /// 운동 시작 액션 메시지
  ///
  /// In ko, this message translates to:
  /// **'운동 시작! 🔥'**
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
  /// **'운동 완료!'**
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
  /// **'💪 운동을 시작합니다! 화이팅!'**
  String get letsStartWorkout;

  /// No description provided for @processingCompletion.
  ///
  /// In ko, this message translates to:
  /// **'운동 완료 처리 중...'**
  String get processingCompletion;

  /// No description provided for @cannotShowCompletionDialog.
  ///
  /// In ko, this message translates to:
  /// **'운동 완료 화면을 표시할 수 없습니다. 홈으로 돌아갑니다.'**
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
  /// **'💪 Chad가 더 강해졌다!'**
  String get chadBecameStronger;

  /// No description provided for @repsDestroyed.
  ///
  /// In ko, this message translates to:
  /// **'💀 파괴된 횟수'**
  String get repsDestroyed;

  /// No description provided for @xpGained.
  ///
  /// In ko, this message translates to:
  /// **'💰 획득 XP'**
  String get xpGained;

  /// No description provided for @timeElapsed.
  ///
  /// In ko, this message translates to:
  /// **'⏱️ 소멸 시간'**
  String get timeElapsed;

  /// No description provided for @workoutDestroyed.
  ///
  /// In ko, this message translates to:
  /// **'💀 운동 파괴 완료! 💀'**
  String get workoutDestroyed;

  /// No description provided for @workoutDestroyedMessage.
  ///
  /// In ko, this message translates to:
  /// **'오늘 운동을 완전히 박살냈다!'**
  String get workoutDestroyedMessage;

  /// No description provided for @timeDestroyed.
  ///
  /// In ko, this message translates to:
  /// **'⏱️ 소멸 시간'**
  String get timeDestroyed;

  /// No description provided for @tomorrowIsRestDay.
  ///
  /// In ko, this message translates to:
  /// **'😴 내일은 CHAD 휴식일! 😴'**
  String get tomorrowIsRestDay;

  /// No description provided for @recoverToBeStronger.
  ///
  /// In ko, this message translates to:
  /// **'🌴 완전한 회복으로 더 강한 CHAD가 되자! 💪'**
  String get recoverToBeStronger;

  /// No description provided for @tomorrowBeastMode.
  ///
  /// In ko, this message translates to:
  /// **'🔥 내일: 다시 야수 모드! 🔥'**
  String get tomorrowBeastMode;

  /// No description provided for @legendaryJourneyContinues.
  ///
  /// In ko, this message translates to:
  /// **'💀 LEGENDARY 경지로의 여정은 계속된다! 💀'**
  String get legendaryJourneyContinues;

  /// No description provided for @chadEvolutionProgress.
  ///
  /// In ko, this message translates to:
  /// **'💪 Chad 진화 진행률'**
  String get chadEvolutionProgress;

  /// Quiz question 3
  ///
  /// In ko, this message translates to:
  /// **'초보자에게 가장 적합한 푸시업 변형은?'**
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
  /// **'차드가 알려주는 완벽한 푸시업 폼! 💪'**
  String get chadPerfectPushupForm;

  /// 완료된 운동 표시
  ///
  /// In ko, this message translates to:
  /// **'완료: {totalReps}개 / {totalSets}세트'**
  String completedFormat(int totalReps, int totalSets);

  /// Header for 5-step pushup guide
  ///
  /// In ko, this message translates to:
  /// **'올바른 푸시업 자세 5단계'**
  String get correctPushupForm5Steps;

  /// 영상 설명 1
  ///
  /// In ko, this message translates to:
  /// **'올바른 팔굽혀펴기 자세로 효과적인 운동'**
  String get correctPushupFormDesc;

  /// Quiz question 1
  ///
  /// In ko, this message translates to:
  /// **'올바른 푸시업 시작 자세에서 손의 위치는?'**
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
  /// **'백 푸시업'**
  String get hundredPushups;

  /// Hundred pushups achievement description
  ///
  /// In ko, this message translates to:
  /// **'한 세션에 100회 달성'**
  String get hundredPushupsDesc;

  /// 완벽 자세 챌린지 메시지
  ///
  /// In ko, this message translates to:
  /// **'🎯 완벽 자세 챌린지 활성화! 대충하면 안 된다! 💪'**
  String get perfectFormChallenge;

  /// Title for pushup form guide screen
  ///
  /// In ko, this message translates to:
  /// **'완벽한 푸시업 자세'**
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
  /// **'팔굽혀펴기 100개 도전 🎯'**
  String get pushup100Challenge;

  /// 푸시업 100개 연속 달성 메시지
  ///
  /// In ko, this message translates to:
  /// **'💪💀 푸시업 100개 연속 달성! 인간 초월! 💀💪'**
  String get pushup100Streak;

  /// 아처 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'아처 푸시업'**
  String get pushupArcher;

  /// 아처 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 한쪽 팔 집중 강화\\n• 좌우 균형 발달\\n• 원핸드 푸시업 준비\\n• 코어 회전 안정성 강화'**
  String get pushupArcherBenefits;

  /// 아처 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'활시위 당기듯 집중해서 호흡해라. 정확성이 생명이다, you idiot!'**
  String get pushupArcherBreathing;

  /// 아처 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'🏹 정확한 아처가 원핸드 지름길? 맞다! 양쪽 균등 마스터하면 LEGENDARY ARCHER EMPEROR! 🏹'**
  String get pushupArcherChad;

  /// 아처 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'한쪽씩 집중하는 고급 기술! 균형감각과 코어가 필요하다, 만삣삐!'**
  String get pushupArcherDesc;

  /// 아처 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 와이드 그립으로 시작하라\\n2. 한쪽으로 체중을 기울여라\\n3. 한 팔은 굽히고 다른 팔은 쭉\\n4. 활시위 당기듯 정확하게\\n5. 양쪽을 번갈아가며, 만삣삐!'**
  String get pushupArcherInstructions;

  /// 아처 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 몸이 비틀어짐\\n• 쭉 편 팔에도 힘이 들어감\\n• 좌우 동작이 불균등\\n• 코어가 흔들림'**
  String get pushupArcherMistakes;

  /// 아처 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'아처 푸시업'**
  String get pushupArcherName;

  /// Quiz question 4
  ///
  /// In ko, this message translates to:
  /// **'푸시업 시 올바른 호흡법은?'**
  String get pushupBreathingQuiz;

  /// 박수 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'박수 푸시업'**
  String get pushupClap;

  /// 박수 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 폭발적인 근력 발달\\n• 전신 파워 향상\\n• 순간 반응속도 증가\\n• 진짜 나만의 증명'**
  String get pushupClapBenefits;

  /// 박수 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'폭발할 때 강하게 내뱉고, 착지 후 빠르게 호흡 정리. 리듬이 중요하다, you idiot!'**
  String get pushupClapBreathing;

  /// 박수 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'👏 박수 푸시업은 파워의 증명? 아니다! 이제 EXPLOSIVE THUNDER POWER의 표현이다! 👏'**
  String get pushupClapChad;

  /// 박수 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'박수치면서 하는 폭발적인 파워! 진짜 강자만이 할 수 있다!'**
  String get pushupClapDesc;

  /// 박수 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 기본 푸시업 자세로 시작\\n2. 폭발적으로 밀어올려라\\n3. 공중에서 박수를 쳐라\\n4. 안전하게 착지하라\\n5. 연속으로 도전해라, 만삣삐!'**
  String get pushupClapInstructions;

  /// 박수 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 충분한 높이로 올라가지 않음\\n• 착지할 때 손목 부상 위험\\n• 폼이 흐트러짐\\n• 무리한 연속 시도'**
  String get pushupClapMistakes;

  /// 박수 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'박수 푸시업'**
  String get pushupClapName;

  /// 디클라인 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'디클라인 푸시업'**
  String get pushupDecline;

  /// 디클라인 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 상부 가슴근육 집중 발달\\n• 어깨 전면 강화\\n• 코어 안정성 최대 강화\\n• 전신 근력 향상'**
  String get pushupDeclineBenefits;

  /// 디클라인 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'중력과 싸우면서도 안정된 호흡을 유지해라. 진짜 파워는 여기서 나온다, you idiot!'**
  String get pushupDeclineBreathing;

  /// 디클라인 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'🌪️ 중력 따위 개무시? 당연하지! 이제 물리법칙을 지배하라! 디클라인으로 GODLIKE SHOULDERS! 🌪️'**
  String get pushupDeclineChad;

  /// 디클라인 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'발을 높게 올려서 강도 업! 어깨와 상체 근육을 제대로 자극한다!'**
  String get pushupDeclineDesc;

  /// 디클라인 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 발을 벤치나 의자에 올려라\\n2. 손은 어깨 아래 정확히\\n3. 몸은 아래쪽으로 기울어진 직선\\n4. 중력의 저항을 이겨내라\\n5. 강하게 밀어올려라, 만삣삐!'**
  String get pushupDeclineInstructions;

  /// 디클라인 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 발 위치가 불안정\\n• 엉덩이가 아래로 처짐\\n• 목에 무리가 가는 자세\\n• 균형을 잃고 비틀어짐'**
  String get pushupDeclineMistakes;

  /// 디클라인 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'디클라인 푸시업'**
  String get pushupDeclineName;

  /// 다이아몬드 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'다이아몬드 푸시업'**
  String get pushupDiamond;

  /// 다이아몬드 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 삼두근 집중 강화\\n• 가슴 안쪽 근육 발달\\n• 팔 전체 근력 향상\\n• 코어 안정성 증가'**
  String get pushupDiamondBenefits;

  /// 다이아몬드 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'집중해서 호흡해라. 삼두근이 불타는 걸 느껴라, you idiot!'**
  String get pushupDiamondBreathing;

  /// 다이아몬드 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'💎 다이아몬드보다 단단한 팔? 틀렸다! 이제 UNBREAKABLE TITANIUM ARMS다! 10개면 진짜 BEAST 인정! 💎'**
  String get pushupDiamondChad;

  /// 다이아몬드 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'삼두근 집중 공략! 다이아몬드 모양이 진짜 나만의 상징이다!'**
  String get pushupDiamondDesc;

  /// 다이아몬드 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 엄지와 검지로 다이아몬드 모양 만들어라\\n2. 가슴 중앙 아래에 손 위치\\n3. 팔꿈치는 몸에 가깝게 유지\\n4. 가슴이 손에 닿을 때까지\\n5. 삼두근 힘으로 밀어올려라, 만삣삐!'**
  String get pushupDiamondInstructions;

  /// 다이아몬드 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 손목에 과도한 압력\\n• 팔꿈치가 너무 벌어짐\\n• 몸이 비틀어짐\\n• 다이아몬드 모양이 부정확함'**
  String get pushupDiamondMistakes;

  /// 다이아몬드 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'다이아몬드 푸시업'**
  String get pushupDiamondName;

  /// 팔굽혀펴기 해시태그
  ///
  /// In ko, this message translates to:
  /// **'#팔굽혀펴기'**
  String get pushupHashtag;

  /// 인클라인 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'인클라인 푸시업'**
  String get pushupIncline;

  /// 인클라인 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 부담을 줄여 폼 완성\\n• 하부 가슴근육 강화\\n• 어깨 안정성 향상\\n• 기본 푸시업으로의 징검다리'**
  String get pushupInclineBenefits;

  /// 인클라인 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'각도가 편해진 만큼 호흡도 편안하게. 하지만 집중력은 최고로, you idiot!'**
  String get pushupInclineBreathing;

  /// 인클라인 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'🚀 높이는 조절하고 강도는 MAX! 20개 완벽 수행하면 GOD TIER 입장권 획득이다, 만삣삐! 🚀'**
  String get pushupInclineChad;

  /// 인클라인 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'경사면을 이용해서 난이도 조절! 계단이나 벤치면 충분하다, 만삣삐!'**
  String get pushupInclineDesc;

  /// 인클라인 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 벤치나 의자에 손을 올려라\\n2. 몸을 비스듬히 기울여라\\n3. 발가락부터 머리까지 일직선\\n4. 높을수록 쉬워진다, 만삣삐\\n5. 점차 낮은 곳으로 도전해라!'**
  String get pushupInclineInstructions;

  /// 인클라인 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 엉덩이가 위로 솟음\\n• 손목에 과도한 체중\\n• 불안정한 지지대 사용\\n• 각도를 너무 급하게 낮춤'**
  String get pushupInclineMistakes;

  /// 인클라인 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'인클라인 푸시업'**
  String get pushupInclineName;

  /// 무릎 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'무릎 푸시업'**
  String get pushupKnee;

  /// 무릎 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 기본 근력 향상\\n• 올바른 푸시업 폼 학습\\n• 어깨와 팔 안정성 강화\\n• 기본 푸시업으로의 단계적 진행'**
  String get pushupKneeBenefits;

  /// 무릎 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'부드럽고 꾸준한 호흡으로 시작해라. 급하게 하지 마라, 만삣삐!'**
  String get pushupKneeBreathing;

  /// 무릎 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'⚡ 시작이 반? 아니다! 이미 ALPHA JOURNEY가 시작됐다! 무릎 푸시업도 EMPEROR의 길이다! ⚡'**
  String get pushupKneeChad;

  /// 무릎 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'입문자도 할 수 있다! 무릎 대고 하는 거 부끄러워하지 마라, 만삣삐!'**
  String get pushupKneeDesc;

  /// 무릎 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 무릎을 바닥에 대고 시작하라\\n2. 발목을 들어올려라\\n3. 상체는 기본 푸시업과 동일하게\\n4. 무릎에서 머리까지 일직선 유지\\n5. 천천히 확실하게 움직여라, 만삣삐!'**
  String get pushupKneeInstructions;

  /// 무릎 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 엉덩이가 뒤로 빠짐\\n• 무릎 위치가 너무 앞쪽\\n• 상체만 움직이고 코어 사용 안 함\\n• 너무 빠르게 동작함'**
  String get pushupKneeMistakes;

  /// 무릎 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'무릎 푸시업'**
  String get pushupKneeName;

  /// Quiz question 2
  ///
  /// In ko, this message translates to:
  /// **'푸시업 중 가장 흔한 실수는?'**
  String get pushupMistakeQuiz;

  /// 원핸드 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'원핸드 푸시업'**
  String get pushupOneArm;

  /// 원핸드 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 궁극의 상체 근력\\n• 완벽한 코어 컨트롤\\n• 전신 균형과 조정력\\n• 기가 나만의 완성'**
  String get pushupOneArmBenefits;

  /// 원핸드 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'깊고 안정된 호흡으로 집중력을 최고조로. 모든 에너지를 하나로, you idiot!'**
  String get pushupOneArmBreathing;

  /// 원핸드 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'🚀 원핸드는 차드 완성형? 틀렸다! 이제 ULTIMATE APEX GOD EMPEROR 탄생이다, FXXK YEAH! 🚀'**
  String get pushupOneArmChad;

  /// 원핸드 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'원핸드 푸시업은 나만의 완성형이다! 이거 한 번이라도 하면 진짜 기가 차드 인정!'**
  String get pushupOneArmDesc;

  /// 원핸드 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 다리를 넓게 벌려 균형잡아라\\n2. 한 손은 등 뒤로\\n3. 코어에 모든 힘을 집중\\n4. 천천히 확실하게\\n5. 기가 나만의 자격을 증명하라!'**
  String get pushupOneArmInstructions;

  /// 원핸드 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 다리가 너무 좁음\\n• 몸이 비틀어지며 회전\\n• 반대 손으로 지탱\\n• 무리한 도전으로 부상'**
  String get pushupOneArmMistakes;

  /// 원핸드 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'원핸드 푸시업'**
  String get pushupOneArmName;

  /// 파이크 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'파이크 푸시업'**
  String get pushupPike;

  /// 파이크 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 어깨 전체 근육 강화\\n• 핸드스탠드 푸시업 준비\\n• 상체 수직 힘 발달\\n• 코어와 균형감 향상'**
  String get pushupPikeBenefits;

  /// 파이크 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'거꾸로 된 자세에서도 안정된 호흡. 어깨에 집중해라, you idiot!'**
  String get pushupPikeBreathing;

  /// 파이크 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'⚡ 파이크 마스터하면 핸드스탠드? 당연하지! 어깨 EMPEROR로 진화하라, 만삣삐! ⚡'**
  String get pushupPikeChad;

  /// 파이크 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'어깨 집중 공략! 핸드스탠드 푸시업의 전 단계다!'**
  String get pushupPikeDesc;

  /// 파이크 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 다운독 자세로 시작하라\\n2. 엉덩이를 최대한 위로\\n3. 머리가 바닥에 가까워질 때까지\\n4. 어깨 힘으로만 밀어올려라\\n5. 역삼각형을 유지하라, 만삣삐!'**
  String get pushupPikeInstructions;

  /// 파이크 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 엉덩이가 충분히 올라가지 않음\\n• 팔꿈치가 옆으로 벌어짐\\n• 머리로만 지탱하려 함\\n• 발 위치가 너무 멀거나 가까움'**
  String get pushupPikeMistakes;

  /// 파이크 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'파이크 푸시업'**
  String get pushupPikeName;

  /// 기본 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'기본 푸시업'**
  String get pushupStandard;

  /// 기본 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 가슴근육 전체 발달\\n• 삼두근과 어깨 강화\\n• 기본 체력 향상\\n• 모든 푸시업의 기초가 된다, you idiot!'**
  String get pushupStandardBenefits;

  /// 기본 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'내려갈 때 숨을 마시고, 올라올 때 강하게 내뱉어라. 호흡이 파워다, 만삣삐!'**
  String get pushupStandardBreathing;

  /// 표준 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'🔥 기본이 제일 어렵다고? 틀렸다! 완벽한 폼 하나가 세상을 정복한다, 만삣삐! MASTER THE BASICS! 🔥'**
  String get pushupStandardChad;

  /// 기본 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'모든 나만의 시작점. 완벽한 기본기가 진짜 강함이다, 만삣삐!'**
  String get pushupStandardDesc;

  /// 기본 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 플랭크 자세로 시작한다, 만삣삐\\n2. 손은 어깨 너비로 벌려라\\n3. 몸은 일직선으로 유지해라, 흐트러지지 말고\\n4. 가슴이 바닥에 닿을 때까지 내려가라\\n5. 강하게 밀어올려라, 차드답게!'**
  String get pushupStandardInstructions;

  /// 기본 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 엉덩이가 위로 솟음 - 약자들이나 하는 짓이야\\n• 가슴을 끝까지 내리지 않음\\n• 목을 앞으로 빼고 함\\n• 손목이 어깨보다 앞에 위치\\n• 일정한 속도를 유지하지 않음, fxxk idiot!'**
  String get pushupStandardMistakes;

  /// 기본 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'기본 푸시업'**
  String get pushupStandardName;

  /// 푸시업 튜토리얼 화면 부제목
  ///
  /// In ko, this message translates to:
  /// **'진짜 강자들은 자세부터 다르다! 💪'**
  String get pushupTutorialSubtitle;

  /// 푸시업 튜토리얼 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'차드 푸시업 도장'**
  String get pushupTutorialTitle;

  /// 영상 제목 2
  ///
  /// In ko, this message translates to:
  /// **'팔굽혀펴기 변형 동작 🔥'**
  String get pushupVariations;

  /// Variations section header
  ///
  /// In ko, this message translates to:
  /// **'난이도별 푸시업 변형'**
  String get pushupVariationsByDifficulty;

  /// 와이드 그립 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'와이드 그립 푸시업'**
  String get pushupWideGrip;

  /// 와이드 그립 푸시업 효과
  ///
  /// In ko, this message translates to:
  /// **'• 가슴 바깥쪽 근육 집중 발달\\n• 어깨 안정성 향상\\n• 가슴 넓이 확장\\n• 상체 전체적인 균형 발달'**
  String get pushupWideGripBenefits;

  /// 와이드 그립 푸시업 호흡법
  ///
  /// In ko, this message translates to:
  /// **'넓은 가슴으로 깊게 숨쉬어라. 가슴이 확장되는 걸 느껴라, you idiot!'**
  String get pushupWideGripBreathing;

  /// 와이드 그립 푸시업 차드 조언
  ///
  /// In ko, this message translates to:
  /// **'🦁 넓은 가슴? 아니다! 이제 LEGENDARY GORILLA CHEST를 만들어라! 와이드 그립으로 세상을 압도하라! 🦁'**
  String get pushupWideGripChad;

  /// 와이드 그립 푸시업 설명
  ///
  /// In ko, this message translates to:
  /// **'와이드하게 벌려서 가슴을 더 넓게! 진짜 강자 가슴을 만들어라!'**
  String get pushupWideGripDesc;

  /// 와이드 그립 푸시업 실행법
  ///
  /// In ko, this message translates to:
  /// **'1. 손을 어깨보다 1.5배 넓게 벌려라\\n2. 손가락은 약간 바깥쪽을 향하게\\n3. 가슴이 바닥에 닿을 때까지\\n4. 팔꿈치는 45도 각도 유지\\n5. 넓은 가슴으로 밀어올려라, 만삣삐!'**
  String get pushupWideGripInstructions;

  /// 와이드 그립 푸시업 일반적인 실수
  ///
  /// In ko, this message translates to:
  /// **'• 손을 너무 넓게 벌림\\n• 팔꿈치가 완전히 바깥쪽\\n• 어깨에 무리가 가는 자세\\n• 가슴을 충분히 내리지 않음'**
  String get pushupWideGripMistakes;

  /// 와이드 그립 푸시업 이름
  ///
  /// In ko, this message translates to:
  /// **'와이드 그립 푸시업'**
  String get pushupWideGripName;

  /// 푸시업 개수 형식
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String pushupsCount(int count);

  /// 푸시업 레이블
  ///
  /// In ko, this message translates to:
  /// **'💪 푸시업'**
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
  /// **'총 푸시업'**
  String get totalPushups;

  /// 자세 튜토리얼 조언
  ///
  /// In ko, this message translates to:
  /// **'완벽한 자세가 완벽한 차드를 만든다!'**
  String get tutorialAdviceForm;

  /// Tab title for variation exercises
  ///
  /// In ko, this message translates to:
  /// **'변형\n운동'**
  String get variationExercises;

  /// 영상 설명 2
  ///
  /// In ko, this message translates to:
  /// **'다양한 팔굽혀펴기 변형으로 근육 자극'**
  String get variousPushupStimulation;

  /// No description provided for @watchVideo.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상 보기'**
  String get watchVideo;

  /// No description provided for @specialPushupForChads.
  ///
  /// In ko, this message translates to:
  /// **'차드를 위한 특별한 푸시업'**
  String get specialPushupForChads;

  /// No description provided for @chadPerfectFormGuide.
  ///
  /// In ko, this message translates to:
  /// **'차드의 완벽한 푸시업 폼 가이드! 💪'**
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

  /// 수면모자 차드 타이틀
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

  /// 전략적 차드 모드 설명
  ///
  /// In ko, this message translates to:
  /// **'과학적 근육 회복 + 지속가능한 파워! 🧠💪'**
  String get scientificRecovery;

  /// 수면모자 차드 진화 상태
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

  /// 진행도 라벨
  ///
  /// In ko, this message translates to:
  /// **'진행도'**
  String get progress;

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
  /// **'연속 운동이 끊어졌다'**
  String get streakBrokenMessage;

  /// No description provided for @streakChallenge.
  ///
  /// In ko, this message translates to:
  /// **'연속 일수 챌린지'**
  String get streakChallenge;

  /// 연속 운동 지속 메시지
  ///
  /// In ko, this message translates to:
  /// **'연속 운동 계속 중!'**
  String get streakContinueMessage;

  /// 연속 운동 격려 설정
  ///
  /// In ko, this message translates to:
  /// **'연속 운동 격려'**
  String get streakEncouragement;

  /// 연속 운동 격려 설정 부제목
  ///
  /// In ko, this message translates to:
  /// **'3일 연속 운동 시 격려 메시지'**
  String get streakEncouragementSubtitle;

  /// 연속 운동 진행률 라벨
  ///
  /// In ko, this message translates to:
  /// **'연속 운동 진행률'**
  String get streakProgress;

  /// 연속 운동 시작 메시지
  ///
  /// In ko, this message translates to:
  /// **'연속 운동 시작!'**
  String get streakStartMessage;

  /// No description provided for @loadingProgramData.
  ///
  /// In ko, this message translates to:
  /// **'프로그램 데이터를 불러오는 중...'**
  String get loadingProgramData;

  /// No description provided for @startWorkoutToStartProgram.
  ///
  /// In ko, this message translates to:
  /// **'운동을 시작하여 프로그램을 시작하세요! 💪'**
  String get startWorkoutToStartProgram;

  /// No description provided for @progressShownAfterWorkout.
  ///
  /// In ko, this message translates to:
  /// **'운동을 시작하면 진행률이 표시됩니다'**
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
  /// **'총 운동 세션'**
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
  /// **'차드 성장을 확인하라! 📊'**
  String get statisticsBannerText;

  /// No description provided for @statisticsTab.
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get statisticsTab;

  /// Advanced level label
  ///
  /// In ko, this message translates to:
  /// **'고급자'**
  String get advancedLevel;

  /// 고급자 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'궁극의 차드'**
  String get alphaLevelDescription;

  /// 고급 레벨 부제목
  ///
  /// In ko, this message translates to:
  /// **'푸시업 11개 이상 - 이미 나만의 자질'**
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
  /// **'초보자부터 차드까지! 단계별로 도전해보자! 🚀'**
  String get beginnerToChad;

  /// 차드 레벨 라벨
  ///
  /// In ko, this message translates to:
  /// **'차드 레벨'**
  String get chadLevel;

  /// 푸시업 상급 난이도
  ///
  /// In ko, this message translates to:
  /// **'차드 - 강력한 기가들'**
  String get difficultyAdvanced;

  /// 푸시업 초급 난이도
  ///
  /// In ko, this message translates to:
  /// **'푸시 - 시작하는 만삣삐들'**
  String get difficultyBeginner;

  /// 푸시업 중급 난이도
  ///
  /// In ko, this message translates to:
  /// **'알파 지망생 - 성장하는 차드들'**
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
  /// **'🔥 ROOKIE 단계. 푸시업 제국의 시작점.\n각성의 여정이 시작되었다. 🔥'**
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
  /// **'🔥 목표: 14주 후 연속 100개 푸시업 ABSOLUTE DOMINATION! 🔥'**
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
  /// **'🔥 모든 EMPEROR는 여기서 시작한다!\n14주 후 MIND-BLOWING TRANSFORMATION을 경험하라, 만삣삐! 🔥'**
  String get levelMotivationRookie;

  /// 고급 차드 이름
  ///
  /// In ko, this message translates to:
  /// **'Alpha'**
  String get levelNameAlpha;

  /// 최고급 차드 이름
  ///
  /// In ko, this message translates to:
  /// **'기가 차드'**
  String get levelNameGiga;

  /// 중급 차드 이름
  ///
  /// In ko, this message translates to:
  /// **'Rising'**
  String get levelNameRising;

  /// 초급 차드 이름
  ///
  /// In ko, this message translates to:
  /// **'Rookie'**
  String get levelNameRookie;

  /// 레벨 선택 설명
  ///
  /// In ko, this message translates to:
  /// **'현재 푸시업 최대 횟수에 맞는 레벨을 선택해라!\n14주 후 목표 달성을 위한 맞춤 프로그램이 제공된다!'**
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

  /// 새로운 차드 등급 텍스트
  ///
  /// In ko, this message translates to:
  /// **'새로운 차드 등급'**
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
  /// **'성장하는 차드'**
  String get risingLevelDescription;

  /// 중급 레벨 부제목
  ///
  /// In ko, this message translates to:
  /// **'푸시업 6-10개 - 차드로 성장 중'**
  String get risingLevelSubtitle;

  /// 중급자 레벨 제목
  ///
  /// In ko, this message translates to:
  /// **'중급자'**
  String get risingLevelTitle;

  /// 초보자 레벨 설명
  ///
  /// In ko, this message translates to:
  /// **'천천히 시작하는 차드'**
  String get rookieLevelDescription;

  /// 초급 레벨 부제목
  ///
  /// In ko, this message translates to:
  /// **'푸시업 6개 미만 - 기초부터 차근차근'**
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
  /// **'5개 이하 → 100개 달성'**
  String get rookieGoalDesc;

  /// No description provided for @risingGoalDesc.
  ///
  /// In ko, this message translates to:
  /// **'6-10개 → 100개 달성'**
  String get risingGoalDesc;

  /// No description provided for @alphaGoalDesc.
  ///
  /// In ko, this message translates to:
  /// **'11-20개 → 100개 달성'**
  String get alphaGoalDesc;

  /// No description provided for @gigaGoalDesc.
  ///
  /// In ko, this message translates to:
  /// **'21개 이상 → 100개+ 달성'**
  String get gigaGoalDesc;

  /// No description provided for @difficultyAdvancedDesc.
  ///
  /// In ko, this message translates to:
  /// **'진정한 차드'**
  String get difficultyAdvancedDesc;

  /// No description provided for @difficultyBeginnerDesc.
  ///
  /// In ko, this message translates to:
  /// **'천천히 시작하는 차드'**
  String get difficultyBeginnerDesc;

  /// No description provided for @difficultyIntermediateDesc.
  ///
  /// In ko, this message translates to:
  /// **'꾸준한 차드'**
  String get difficultyIntermediateDesc;

  /// No description provided for @achievementAllRounderDesc.
  ///
  /// In ko, this message translates to:
  /// **'모든 푸시업 타입을 시도했다'**
  String get achievementAllRounderDesc;

  /// No description provided for @achievementAllRounderMotivation.
  ///
  /// In ko, this message translates to:
  /// **'모든 타입 마스터! 올라운더 차드! 🌈'**
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

  /// 100회 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'센츄리온'**
  String get achievementCenturion;

  /// 100회 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 100회의 푸쉬업을 달성하다'**
  String get achievementCenturionDesc;

  /// 100개 누적 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'100개 누적 푸쉬업 챌린지를 완료했다'**
  String get achievementChallenge100CumulativeDesc;

  /// 100개 누적 챌린지 완료 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'작은 노력들이 큰 성과를 만듭니다!'**
  String get achievementChallenge100CumulativeMotivation;

  /// 100개 누적 챌린지 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'100개 누적 챌린지 완료'**
  String get achievementChallenge100CumulativeTitle;

  /// 14일 연속 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'14일 연속 운동 챌린지를 완료했다'**
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
  /// **'200개 누적 푸쉬업 챌린지를 완료했다'**
  String get achievementChallenge200CumulativeDesc;

  /// 200개 누적 챌린지 완료 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'진정한 챔피언의 모습이다!'**
  String get achievementChallenge200CumulativeMotivation;

  /// 200개 누적 챌린지 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'200개 누적 챌린지 완료'**
  String get achievementChallenge200CumulativeTitle;

  /// 50개 한번에 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'한 번에 50개 푸쉬업 챌린지를 완료했다'**
  String get achievementChallenge50SingleDesc;

  /// 50개 한번에 챌린지 완료 업적 동기부여 메시지
  ///
  /// In ko, this message translates to:
  /// **'한계 돌파! 미쳤다! 🔥'**
  String get achievementChallenge50SingleMotivation;

  /// 50개 한번에 챌린지 완료 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'50개 한번에 챌린지 완료'**
  String get achievementChallenge50SingleTitle;

  /// 7일 연속 챌린지 완료 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 운동 챌린지를 완료했다'**
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
  /// **'7일 이상 쉰 후 다시 운동을 시작했다'**
  String get achievementComebackKidDesc;

  /// No description provided for @achievementComebackKidMotivation.
  ///
  /// In ko, this message translates to:
  /// **'포기하지 않는 마음! 컴백의 차드! 🔄'**
  String get achievementComebackKidMotivation;

  /// No description provided for @achievementComebackKidTitle.
  ///
  /// In ko, this message translates to:
  /// **'컴백 키드'**
  String get achievementComebackKidTitle;

  /// 완료율 80% 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'평균 완료율 80% 이상을 달성했다'**
  String get achievementCompletionRate80Desc;

  /// 완료율 80% 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'꾸준함이 답이다! 계속 간다! 💪'**
  String get achievementCompletionRate80Motivation;

  /// 완료율 80% 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'우수한 완료율'**
  String get achievementCompletionRate80Title;

  /// 완료율 90% 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'평균 완료율 90% 이상을 달성했다'**
  String get achievementCompletionRate90Desc;

  /// 완료율 90% 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'거의 완벽! 폼 미쳤다! 🔥'**
  String get achievementCompletionRate90Motivation;

  /// 완료율 90% 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'완벽주의자'**
  String get achievementCompletionRate90Title;

  /// 완료율 95% 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'평균 완료율 95% 이상을 달성했다'**
  String get achievementCompletionRate95Desc;

  /// 완료율 95% 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'완벽에 가깝다! 레전드급! 👑'**
  String get achievementCompletionRate95Motivation;

  /// 완료율 95% 업적 제목
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
  /// **'30일 연속으로 운동하다'**
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
  /// **'100일 연속으로 운동하다'**
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
  /// **'목표의 2배! 더블 트러블 차드! 🎪'**
  String get achievementDoubleTroubleMotivation;

  /// No description provided for @achievementDoubleTroubleTitle.
  ///
  /// In ko, this message translates to:
  /// **'더블 트러블'**
  String get achievementDoubleTroubleTitle;

  /// 아침 운동 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'얼리버드'**
  String get achievementEarlyBird;

  /// 아침 운동 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'오전 7시 이전에 5번 운동했다'**
  String get achievementEarlyBirdDesc;

  /// No description provided for @achievementEarlyBirdMotivation.
  ///
  /// In ko, this message translates to:
  /// **'새벽을 정복한 얼리버드 차드! 🌅'**
  String get achievementEarlyBirdMotivation;

  /// No description provided for @achievementEarlyBirdTitle.
  ///
  /// In ko, this message translates to:
  /// **'새벽 차드'**
  String get achievementEarlyBirdTitle;

  /// 긴 운동 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'지구력 왕'**
  String get achievementEndurance;

  /// 긴 운동 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'30분 이상 운동하다'**
  String get achievementEnduranceDesc;

  /// No description provided for @achievementEnduranceKingDesc.
  ///
  /// In ko, this message translates to:
  /// **'30분 이상 운동을 지속했다'**
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
  /// **'한 번의 운동에서 100개를 달성했다'**
  String get achievementFirst100SingleDesc;

  /// No description provided for @achievementFirst100SingleMotivation.
  ///
  /// In ko, this message translates to:
  /// **'한 번에 100개! 진정한 파워 차드! 💥'**
  String get achievementFirst100SingleMotivation;

  /// No description provided for @achievementFirst100SingleTitle.
  ///
  /// In ko, this message translates to:
  /// **'한 번에 100개'**
  String get achievementFirst100SingleTitle;

  /// No description provided for @achievementFirst50Desc.
  ///
  /// In ko, this message translates to:
  /// **'한 번의 운동에서 50개를 달성했다'**
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
  /// **'첫 번째 푸쉬업을 완료하다'**
  String get achievementFirstJourneyDesc;

  /// 신 모드 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'신 모드'**
  String get achievementGodMode;

  /// 신 모드 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'한 세션에서 500회 이상 달성하다'**
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

  /// 10000회 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'전설'**
  String get achievementLegend;

  /// 10000회 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 10000회의 푸쉬업을 달성하다'**
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
  /// **'레벨 10 차드'**
  String get achievementLevel10Title;

  /// No description provided for @achievementLevel20Desc.
  ///
  /// In ko, this message translates to:
  /// **'레벨 20에 도달했다'**
  String get achievementLevel20Desc;

  /// No description provided for @achievementLevel20Motivation.
  ///
  /// In ko, this message translates to:
  /// **'레벨 20! 차드 중의 왕! 👑'**
  String get achievementLevel20Motivation;

  /// No description provided for @achievementLevel20Title.
  ///
  /// In ko, this message translates to:
  /// **'레벨 20 차드'**
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
  /// **'레벨 5 차드'**
  String get achievementLevel5Title;

  /// No description provided for @achievementLunchBreakDesc.
  ///
  /// In ko, this message translates to:
  /// **'점심시간(12-2시)에 5번 운동했다'**
  String get achievementLunchBreakDesc;

  /// No description provided for @achievementLunchBreakMotivation.
  ///
  /// In ko, this message translates to:
  /// **'점심시간도 놓치지 않는 효율적인 차드! 🍽️'**
  String get achievementLunchBreakMotivation;

  /// No description provided for @achievementLunchBreakTitle.
  ///
  /// In ko, this message translates to:
  /// **'점심시간 차드'**
  String get achievementLunchBreakTitle;

  /// 5000회 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'마라토너'**
  String get achievementMarathoner;

  /// 5000회 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 5000회의 푸쉬업을 달성하다'**
  String get achievementMarathonerDesc;

  /// No description provided for @achievementMonthlyWarriorDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 달에 20일 이상 운동했다'**
  String get achievementMonthlyWarriorDesc;

  /// No description provided for @achievementMonthlyWarriorMotivation.
  ///
  /// In ko, this message translates to:
  /// **'한 달 20일! 월간 전사 차드! 📅'**
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

  /// 밤 운동 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'올빼미'**
  String get achievementNightOwl;

  /// 밤 운동 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'오후 10시 이후에 5번 운동했다'**
  String get achievementNightOwlDesc;

  /// No description provided for @achievementNightOwlMotivation.
  ///
  /// In ko, this message translates to:
  /// **'밤에도 포기하지 않는 올빼미 차드! 🦉'**
  String get achievementNightOwlMotivation;

  /// No description provided for @achievementNightOwlTitle.
  ///
  /// In ko, this message translates to:
  /// **'야행성 차드'**
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

  /// 목표 초과 5회 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'초과달성자'**
  String get achievementOverachiever;

  /// 목표 초과 5회 업적 설명
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
  /// **'10번의 완벽한 운동을 달성했다'**
  String get achievementPerfect10Desc;

  /// No description provided for @achievementPerfect10Motivation.
  ///
  /// In ko, this message translates to:
  /// **'완벽의 마스터! 차드 중의 차드! 🏆'**
  String get achievementPerfect10Motivation;

  /// No description provided for @achievementPerfect10Title.
  ///
  /// In ko, this message translates to:
  /// **'마스터 차드'**
  String get achievementPerfect10Title;

  /// No description provided for @achievementPerfect20Desc.
  ///
  /// In ko, this message translates to:
  /// **'20번의 완벽한 운동을 달성했다'**
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
  /// **'3번의 완벽한 운동을 달성했다'**
  String get achievementPerfect3Desc;

  /// No description provided for @achievementPerfect3Motivation.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 트리플! 정확성의 차드! 🎯'**
  String get achievementPerfect3Motivation;

  /// No description provided for @achievementPerfect3Title.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 트리플'**
  String get achievementPerfect3Title;

  /// No description provided for @achievementPerfect5Desc.
  ///
  /// In ko, this message translates to:
  /// **'5번의 완벽한 운동을 달성했다'**
  String get achievementPerfect5Desc;

  /// No description provided for @achievementPerfect5Motivation.
  ///
  /// In ko, this message translates to:
  /// **'완벽을 추구하는 진정한 차드! ⭐'**
  String get achievementPerfect5Motivation;

  /// No description provided for @achievementPerfect5Title.
  ///
  /// In ko, this message translates to:
  /// **'완벽주의 차드'**
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

  /// 1000회 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'푸쉬업 마스터'**
  String get achievementPushupMaster;

  /// 1000회 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 1000회의 푸쉬업을 달성하다'**
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
  /// **'업적을 달성해서 차드가 되자! 🏆'**
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
  /// **'번개 같은 속도! 스피드의 차드! 💨'**
  String get achievementSpeedDemonMotivation;

  /// No description provided for @achievementSpeedDemonTitle.
  ///
  /// In ko, this message translates to:
  /// **'스피드 데몬'**
  String get achievementSpeedDemonTitle;

  /// No description provided for @achievementStreak100Desc.
  ///
  /// In ko, this message translates to:
  /// **'100일 연속 운동을 완료했다'**
  String get achievementStreak100Desc;

  /// No description provided for @achievementStreak100Motivation.
  ///
  /// In ko, this message translates to:
  /// **'100일 연속! 당신은 살아있는 신화이다! 🌟'**
  String get achievementStreak100Motivation;

  /// No description provided for @achievementStreak100Title.
  ///
  /// In ko, this message translates to:
  /// **'100일 신화 차드'**
  String get achievementStreak100Title;

  /// No description provided for @achievementStreak14Desc.
  ///
  /// In ko, this message translates to:
  /// **'14일 연속 운동을 완료했다'**
  String get achievementStreak14Desc;

  /// No description provided for @achievementStreak14Motivation.
  ///
  /// In ko, this message translates to:
  /// **'끈기의 왕! 차드 중의 차드! 🏃‍♂️'**
  String get achievementStreak14Motivation;

  /// No description provided for @achievementStreak14Title.
  ///
  /// In ko, this message translates to:
  /// **'2주 마라톤 차드'**
  String get achievementStreak14Title;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In ko, this message translates to:
  /// **'30일 연속 운동을 완료했다'**
  String get achievementStreak30Desc;

  /// No description provided for @achievementStreak30Motivation.
  ///
  /// In ko, this message translates to:
  /// **'이제 당신은 나만의 왕이다! 👑'**
  String get achievementStreak30Motivation;

  /// No description provided for @achievementStreak30Title.
  ///
  /// In ko, this message translates to:
  /// **'월간 궁극 차드'**
  String get achievementStreak30Title;

  /// No description provided for @achievementStreak3Desc.
  ///
  /// In ko, this message translates to:
  /// **'3일 연속 운동을 완료했다'**
  String get achievementStreak3Desc;

  /// No description provided for @achievementStreak3Motivation.
  ///
  /// In ko, this message translates to:
  /// **'꾸준함이 차드를 만듭니다! 🔥'**
  String get achievementStreak3Motivation;

  /// No description provided for @achievementStreak3Title.
  ///
  /// In ko, this message translates to:
  /// **'3일 연속 차드'**
  String get achievementStreak3Title;

  /// No description provided for @achievementStreak60Desc.
  ///
  /// In ko, this message translates to:
  /// **'60일 연속 운동을 완료했다'**
  String get achievementStreak60Desc;

  /// No description provided for @achievementStreak60Motivation.
  ///
  /// In ko, this message translates to:
  /// **'2개월 연속! 당신은 레전드이다! 🏅'**
  String get achievementStreak60Motivation;

  /// No description provided for @achievementStreak60Title.
  ///
  /// In ko, this message translates to:
  /// **'2개월 레전드 차드'**
  String get achievementStreak60Title;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 운동을 완료했다'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementStreak7Motivation.
  ///
  /// In ko, this message translates to:
  /// **'일주일을 정복한 진정한 차드! 💪'**
  String get achievementStreak7Motivation;

  /// No description provided for @achievementStreak7Title.
  ///
  /// In ko, this message translates to:
  /// **'주간 차드'**
  String get achievementStreak7Title;

  /// No description provided for @achievementTotal10000Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 10000개의 푸시업을 완료했다'**
  String get achievementTotal10000Desc;

  /// No description provided for @achievementTotal10000Motivation.
  ///
  /// In ko, this message translates to:
  /// **'10000개! 당신은 나만의 신이다! 👑'**
  String get achievementTotal10000Motivation;

  /// No description provided for @achievementTotal10000Title.
  ///
  /// In ko, this message translates to:
  /// **'10000 갓 차드'**
  String get achievementTotal10000Title;

  /// No description provided for @achievementTotal1000Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 1000개의 푸시업을 완료했다'**
  String get achievementTotal1000Desc;

  /// No description provided for @achievementTotal1000Motivation.
  ///
  /// In ko, this message translates to:
  /// **'1000개 돌파! 메가 차드 달성! ⚡'**
  String get achievementTotal1000Motivation;

  /// No description provided for @achievementTotal1000Title.
  ///
  /// In ko, this message translates to:
  /// **'1000 메가 차드'**
  String get achievementTotal1000Title;

  /// No description provided for @achievementTotal100Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 100개의 푸시업을 완료했다'**
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
  /// **'총 2500개의 푸시업을 완료했다'**
  String get achievementTotal2500Desc;

  /// No description provided for @achievementTotal2500Motivation.
  ///
  /// In ko, this message translates to:
  /// **'2500개! 슈퍼 나만의 경지에 도달! 🔥'**
  String get achievementTotal2500Motivation;

  /// No description provided for @achievementTotal2500Title.
  ///
  /// In ko, this message translates to:
  /// **'2500 슈퍼 차드'**
  String get achievementTotal2500Title;

  /// No description provided for @achievementTotal250Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 250개의 푸시업을 완료했다'**
  String get achievementTotal250Desc;

  /// No description provided for @achievementTotal250Motivation.
  ///
  /// In ko, this message translates to:
  /// **'250개! 꾸준함의 결과! 🎯'**
  String get achievementTotal250Motivation;

  /// No description provided for @achievementTotal250Title.
  ///
  /// In ko, this message translates to:
  /// **'250 차드'**
  String get achievementTotal250Title;

  /// No description provided for @achievementTotal5000Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 5000개의 푸시업을 완료했다'**
  String get achievementTotal5000Desc;

  /// No description provided for @achievementTotal5000Motivation.
  ///
  /// In ko, this message translates to:
  /// **'5000개! 당신은 울트라 차드이다! 🌟'**
  String get achievementTotal5000Motivation;

  /// No description provided for @achievementTotal5000Title.
  ///
  /// In ko, this message translates to:
  /// **'5000 울트라 차드'**
  String get achievementTotal5000Title;

  /// No description provided for @achievementTotal500Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 500개의 푸시업을 완료했다'**
  String get achievementTotal500Desc;

  /// No description provided for @achievementTotal500Motivation.
  ///
  /// In ko, this message translates to:
  /// **'500개 돌파! 중급 차드 달성! 🚀'**
  String get achievementTotal500Motivation;

  /// No description provided for @achievementTotal500Title.
  ///
  /// In ko, this message translates to:
  /// **'500 차드'**
  String get achievementTotal500Title;

  /// No description provided for @achievementTotal50Desc.
  ///
  /// In ko, this message translates to:
  /// **'총 50개의 푸시업을 완료했다'**
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
  /// **'첫 번째 푸시업 튜토리얼을 확인했다'**
  String get achievementTutorialExplorerDesc;

  /// No description provided for @achievementTutorialExplorerMotivation.
  ///
  /// In ko, this message translates to:
  /// **'지식이 나만의 첫 번째 힘이다! 🔍'**
  String get achievementTutorialExplorerMotivation;

  /// No description provided for @achievementTutorialExplorerTitle.
  ///
  /// In ko, this message translates to:
  /// **'탐구하는 차드'**
  String get achievementTutorialExplorerTitle;

  /// No description provided for @achievementTutorialMasterDesc.
  ///
  /// In ko, this message translates to:
  /// **'모든 푸시업 튜토리얼을 확인했다'**
  String get achievementTutorialMasterDesc;

  /// No description provided for @achievementTutorialMasterMotivation.
  ///
  /// In ko, this message translates to:
  /// **'모든 기술을 마스터한 푸시업 박사! 🎓'**
  String get achievementTutorialMasterMotivation;

  /// No description provided for @achievementTutorialMasterTitle.
  ///
  /// In ko, this message translates to:
  /// **'푸시업 마스터'**
  String get achievementTutorialMasterTitle;

  /// No description provided for @achievementTutorialStudentDesc.
  ///
  /// In ko, this message translates to:
  /// **'5개의 푸시업 튜토리얼을 확인했다'**
  String get achievementTutorialStudentDesc;

  /// No description provided for @achievementTutorialStudentMotivation.
  ///
  /// In ko, this message translates to:
  /// **'다양한 기술을 배우는 진정한 차드! 📚'**
  String get achievementTutorialStudentMotivation;

  /// No description provided for @achievementTutorialStudentTitle.
  ///
  /// In ko, this message translates to:
  /// **'학습하는 차드'**
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
  /// **'궁극의 차드'**
  String get achievementUltimate;

  /// 최고 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'모든 업적을 달성하다'**
  String get achievementUltimateDesc;

  /// No description provided for @achievementUltimateMotivation.
  ///
  /// In ko, this message translates to:
  /// **'당신은 궁극의 차드이다! 🌟'**
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
  /// **'5가지 다른 푸쉬업 타입을 완료하다'**
  String get achievementVarietyDesc;

  /// No description provided for @achievementVarietySeekerDesc.
  ///
  /// In ko, this message translates to:
  /// **'5가지 다른 푸시업 타입을 시도했다'**
  String get achievementVarietySeekerDesc;

  /// No description provided for @achievementVarietySeekerMotivation.
  ///
  /// In ko, this message translates to:
  /// **'다양함을 추구하는 창의적 차드! 🎨'**
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
  /// **'7일 연속으로 운동하다'**
  String get achievementWeekWarriorDesc;

  /// No description provided for @achievementWeekendWarriorDesc.
  ///
  /// In ko, this message translates to:
  /// **'주말에 꾸준히 운동하는 차드'**
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

  /// 5시간 운동 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 운동 시간 300분(5시간)을 달성했다'**
  String get achievementWorkoutTime300Desc;

  /// 5시간 운동 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'운동에 진심인 당신의 모습이 멋집니다!'**
  String get achievementWorkoutTime300Motivation;

  /// 5시간 운동 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'5시간 운동 마스터'**
  String get achievementWorkoutTime300Title;

  /// 1시간 운동 업적 설명
  ///
  /// In ko, this message translates to:
  /// **'총 운동 시간 60분을 달성했다'**
  String get achievementWorkoutTime60Desc;

  /// 1시간 운동 업적 동기부여
  ///
  /// In ko, this message translates to:
  /// **'꾸준한 운동 누적 중! 💪'**
  String get achievementWorkoutTime60Motivation;

  /// 1시간 운동 업적 제목
  ///
  /// In ko, this message translates to:
  /// **'1시간 운동 달성'**
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
  /// **'업적을 달성해서 차드가 되자! 🏆'**
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
  /// **'연속 운동 전사 배지'**
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

  /// 레벨업 메시지
  ///
  /// In ko, this message translates to:
  /// **'{emoji}💥 LEVEL UP! 한계 박살! 💥{emoji}'**
  String levelUpMessage(String emoji);

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
  /// **'운동 시작해서 첫 업적 획득하자! 💪'**
  String get startWorkoutForAchievements;

  /// No description provided for @trophyIcon.
  ///
  /// In ko, this message translates to:
  /// **'🏆'**
  String get trophyIcon;

  /// 챌린지 해금 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'더 많은 운동을 완료하여 새로운 챌린지를 해금해!'**
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
  /// **'완료율'**
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
  /// **'총 100개 팔굽혀펴기 달성'**
  String get challenge100CumulativeDescription;

  /// 100 cumulative challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'여러 세션 합쳐서 총 100개 달성! 💪'**
  String get challenge100CumulativeDetailedDescription;

  /// 100 cumulative challenge title
  ///
  /// In ko, this message translates to:
  /// **'100개 챌린지'**
  String get challenge100CumulativeTitle;

  /// 200 cumulative challenge description
  ///
  /// In ko, this message translates to:
  /// **'총 200개 팔굽혀펴기 달성'**
  String get challenge200CumulativeDescription;

  /// 200 cumulative challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'여러 세션 합쳐서 총 200개 달성! 100개 클리어 후 도전! 🔥'**
  String get challenge200CumulativeDetailedDescription;

  /// 200 cumulative challenge title
  ///
  /// In ko, this message translates to:
  /// **'200개 챌린지'**
  String get challenge200CumulativeTitle;

  /// 50 single session challenge description
  ///
  /// In ko, this message translates to:
  /// **'한 번의 운동에서 50개 팔굽혀펴기'**
  String get challenge50SingleDescription;

  /// 50 single session challenge detailed description
  ///
  /// In ko, this message translates to:
  /// **'한 번에 50개! 중간에 쉬면 처음부터 다시! 💥'**
  String get challenge50SingleDetailedDescription;

  /// 50 single session challenge title
  ///
  /// In ko, this message translates to:
  /// **'50개 한번에'**
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
  /// **'그냥 기본 운동? 아니면 진짜 챔피언 모드? 🚀\n\n⚡ 챌린지 모드 ON 하면:\n• 더 높은 난이도\n• 보너스 포인트 획득 🏆'**
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
  /// **'팔굽혀펴기 100개를 향한 도전 정신'**
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
  /// **'💀 친구에게 차드 도전장 발송! 💀'**
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
  /// **'🔥 MISSION 100 알림 활성화! 🔥'**
  String get notificationActivationTitle;

  /// 알림 혜택 1
  ///
  /// In ko, this message translates to:
  /// **'💪 매일 운동 리마인더'**
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

  /// 알림 권한 설명
  ///
  /// In ko, this message translates to:
  /// **'운동 리마인더와 업적 알림을 받기 위해 필요한다'**
  String get notificationPermissionDesc;

  /// 알림 권한 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'권한 요청 중 오류 발생!'**
  String get notificationPermissionErrorMessage;

  /// 알림 권한 기능 목록
  ///
  /// In ko, this message translates to:
  /// **'• 운동 리마인더\n• 업적 달성 알림\n• 동기부여 메시지'**
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

  /// 알림 권한 제목
  ///
  /// In ko, this message translates to:
  /// **'🔔 알림 권한'**
  String get notificationPermissionTitle;

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
  /// **'MISSION 100 설정'**
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
  /// **'운동 알림 설정'**
  String get workoutNotifications;

  /// No description provided for @enableWorkoutReminders.
  ///
  /// In ko, this message translates to:
  /// **'운동 알림 받기'**
  String get enableWorkoutReminders;

  /// No description provided for @getRemindersOnWorkoutDays.
  ///
  /// In ko, this message translates to:
  /// **'선택한 운동일에 알림을 받습니다'**
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
  /// **'운동 요일 선택 (최소 3일)'**
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
  /// **'14주 만에 100개 푸쉬업 달성!\n차드가 되는 여정을 함께하세요! 🔥'**
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
  /// **'Mission 100 Chad Pushup 피드백'**
  String get feedbackSubject;

  /// No description provided for @feedbackBody.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! Mission 100 Chad Pushup 앱에 대한 피드백을 보내드립니다.\n\n'**
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
  /// **'운동 데이터 백업/복원을 위해 저장소 접근 권한이 필요합니다.'**
  String get storageBackupRestorePermission;

  /// No description provided for @workoutRecordBackup.
  ///
  /// In ko, this message translates to:
  /// **'• 운동 기록 백업'**
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
  /// **'저장소 권한이 거부되었습니다.\n\n백업/복원 기능을 사용하려면 설정에서\n수동으로 권한을 허용해주세요.\n\n설정 > 앱 > Mission 100 > 권한 > 저장소'**
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
  /// **'Mission 100 백업 완료'**
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
  /// **'Mission 100 백업 실패'**
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
  /// **'Mission 100 백업 중단'**
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
  /// **'💾 너의 차드 전설을 영원히 보존한다!'**
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
  /// **'Mission 100 수동 백업 완료'**
  String get manualBackupCompletedTitle;

  /// 수동 백업 실패 알림 내용
  ///
  /// In ko, this message translates to:
  /// **'백업 생성 중 오류가 발생했다'**
  String get manualBackupFailedBody;

  /// 수동 백업 실패 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'Mission 100 수동 백업 실패'**
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

  /// 일반적인 오류 발생 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했다'**
  String get errorOccurred;

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
