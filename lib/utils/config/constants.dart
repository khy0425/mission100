import 'package:flutter/material.dart';

class AppConstants {
  // 앱 정보
  static const String appName = '드림플로 (DreamFlow)';
  static const String appSubtitle = '자각몽의 흐름 속으로';
  static const String appSlogan = '30일 프로그램으로 자각몽을 마스터하세요!';
  static const String appDescription =
      '과학적으로 검증된 30일 프로그램으로 자각몽 능력 개발하기';

  // 자각몽 프로그램 관련
  static const int totalDays = 30; // 30일 자각몽 마스터 프로그램 (기본)
  static const int extendedTotalDays = 60; // 60일 확장 프로그램 (프리미엄)
  static const int totalWeeks = 14; // 레거시 호환성 (추후 제거 예정)
  static const int daysPerWeek = 3; // 레거시 호환성 (추후 제거 예정)
  static const int totalWorkoutDays = totalDays; // 30일
  static const int targetLevel = 100; // 최종 목표: 자각몽 마스터 레벨

  // Lumi AI 코치 레벨 관련
  static const int maxLumiLevel = 6;

  // 알림 관련
  static const String notificationChannelId = 'lucid_dream_reminders';
  static const String notificationChannelName = 'Lucid Dream Reminders';
  static const String notificationChannelDesc =
      'Notifications for lucid dream practice reminders and motivation';

  // 공유 프리퍼런스 키
  static const String keyFirstLaunch = 'first_launch';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyThemeMode = 'theme_mode';
  static const String keyRestTimerDuration = 'rest_timer_duration';
  static const String keyNotificationEnabled = 'notification_enabled';
  static const String keyNotificationTime = 'notification_time';

  // 기본값들
  static const int defaultRestTime = 60; // 초
  static const String defaultNotificationTime = '19:00'; // 오후 7시

  // 애니메이션 지속시간
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // 패딩 및 마진
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // 둥근 모서리
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // 폰트 크기
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 24.0;
  static const double fontSizeXXL = 32.0;

  // 아이콘 크기
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // 버튼 크기
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // 그림자
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;

  // 정규식
  static const String timePattern = r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$';

  // 메시지 키들 - 실제 메시지는 AppLocalizations에서 가져올 것
  static const String errorGeneralKey = 'errorGeneral';
  static const String errorDatabaseKey = 'errorDatabase';
  static const String errorNetworkKey = 'errorNetwork';
  static const String errorNotFoundKey = 'errorNotFound';

  static const String successWorkoutCompletedKey = 'successWorkoutCompleted';
  static const String successProfileSavedKey = 'successProfileSaved';
  static const String successSettingsSavedKey = 'successSettingsSaved';

  // URL들 (추후 필요 시)
  static const String githubUrl = 'https://github.com/yourusername/mission100';
  static const String supportEmail = 'support@mission100chad.com';

  // 색상 관련 상수들
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color secondaryColor = Color(0xFF7BD05F);
  static const Color accentColor = Color(0xFFFFB74D);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);
}

// 앱 색상 정의 - 몽환적인 연보라 테마
class AppColors {
  // 기본 브랜드 색상 - 몽환적인 연보라 테마
  static const int primaryColor = 0xFFB39DDB; // 연보라 (몽환적 라벤더)
  static const int secondaryColor = 0xFF9FA8DA; // 페리윙클 (부드러운 인디고)
  static const int accentColor = 0xFFE1BEE7; // 연핑크 라벤더 (부드러운 악센트)

  // 배경 색상 - 라이트/다크 테마 구분
  static const int backgroundLight = 0xFFF3E5F5; // 연라벤더 배경 (라이트 테마)
  static const int backgroundDark = 0xFF1A1625; // 깊은 보라 밤하늘 (다크 테마)
  static const int surfaceLight = 0xFFFAF5FF; // 아주 연한 라벤더 (라이트 테마)
  static const int surfaceDark = 0xFF2D2640; // 보라빛 밤하늘 표면 (다크 테마)

  // 텍스트 색상 - 라이트/다크 테마 구분
  static const int textPrimaryLight = 0xFF4A3C5C; // 진한 보라빛 회색 (라이트 테마)
  static const int textPrimaryDark = 0xFFF3E5F5; // 연라벤더 (다크 테마)
  static const int textSecondaryLight = 0xFF7E6C8A; // 중간 보라빛 회색 (라이트 테마)
  static const int textSecondaryDark = 0xFFCEC2D9; // 연보라 회색 (다크 테마)

  // 상태별 색상 - 몽환적 테마에 맞게 조정
  static const int successColor = 0xFFB39DDB; // 연보라 (성공 - 자각몽 달성)
  static const int warningColor = 0xFFFFCC80; // 부드러운 금빛 (경고 - 달빛)
  static const int errorColor = 0xFFEF9A9A; // 연한 빨강 (에러)
  static const int infoColor = 0xFF9FA8DA; // 페리윙클 (정보 - 몽환적 꿈)

  // Dream Spirit 레벨별 색상 - 몽환적인 꿈의 단계
  static const int rookieColor = 0xFFCE93D8; // 연한 마젠타 (초보 - 얕은 잠)
  static const int risingColor = 0xFFB39DDB; // 연보라 (상승 - REM 수면)
  static const int alphaColor = 0xFF9FA8DA; // 페리윙클 (알파 - 자각몽 시작)
  static const int gigaColor = 0xFFE1BEE7; // 연핑크 라벤더 (기가 - 완전한 자각)

  // 그라데이션 색상 - 몽환적인 연보라 테마
  static const List<int> dreamGradient = [0xFF1A1625, 0xFF2D2640]; // 깊은 보라 밤하늘 그라디언트
  static const List<int> lucidGradient = [0xFFB39DDB, 0xFF9FA8DA]; // 연보라→페리윙클 (몽환적 자각몽)
  static const List<int> nightGradient = [0xFF1A1625, 0xFF3D2B5C]; // 밤하늘 → 진한 보라 (깊은 밤)
  static const List<int> successGradient = [0xFFB39DDB, 0xFFE1BEE7]; // 성공: 연보라→연핑크
  static const List<int> wbtbGradient = [0xFFCE93D8, 0xFFFFCC80]; // WBTB: 마젠타→금빛 (새벽)
}

// Dream Spirit 관련 상수 (내부적으로는 Chad 변수명 유지, MVP 이후 리팩토링 예정)
class ChadConstants {
  // Dream Spirit 진화 조건 (완료된 일수 기준)
  static const Map<int, int> evolutionThresholds = {
    0: 0, // 시작 - 꿈모자 스피릿
    1: 5, // 5일 완료 - 기본 스피릿
    2: 10, // 10일 완료 - 각성 스피릿
    3: 15, // 15일 완료 - 명료 스피릿
    4: 20, // 20일 완료 - 빛나는 스피릿
    5: 25, // 25일 완료 - 자각 스피릿
    6: 30, // 30일 완료 - 마스터 스피릿
  };

  // Dream Spirit 타이틀 키들 (AppLocalizations에서 가져오기 위함)
  static const List<String> chadTitleKeys = [
    'chadTitleSleepy', // 꿈모자 스피릿
    'chadTitleBasic', // 기본 스피릿
    'chadTitleCoffee', // 각성 스피릿
    'chadTitleFront', // 명료 스피릿
    'chadTitleCool', // 빛나는 스피릿
    'chadTitleLaser', // 자각 스피릿
    'chadTitleDouble', // 마스터 스피릿
  ];

  // 특별 이벤트 메시지 키들 (AppLocalizations에서 가져오기 위함)
  static const String firstWorkoutMessageKey = 'firstWorkoutMessage';
  static const String weekCompletedMessageKey = 'weekCompletedMessage';
  static const String programCompletedMessageKey = 'programCompletedMessage';

  // 스트릭 관련 메시지 키들 (AppLocalizations에서 가져오기 위함)
  static const String streakStartMessageKey = 'streakStartMessage';
  static const String streakContinueMessageKey = 'streakContinueMessage';
  static const String streakBrokenMessageKey = 'streakBrokenMessage';
}

// 태블릿 반응형 디자인 헬퍼 클래스
class ResponsiveHelper {
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  static bool isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 900;
  }

  static double getHorizontalPadding(BuildContext context) {
    if (isLargeTablet(context)) return 60.0;
    if (isTablet(context)) return 40.0;
    return 20.0;
  }

  static double getVerticalPadding(BuildContext context) {
    if (isLargeTablet(context)) return 40.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  static double getCardPadding(BuildContext context) {
    if (isLargeTablet(context)) return 32.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  static double getTitleFontSize(BuildContext context) {
    if (isLargeTablet(context)) return 32.0;
    if (isTablet(context)) return 28.0;
    return 24.0;
  }

  static double getSubtitleFontSize(BuildContext context) {
    if (isLargeTablet(context)) return 18.0;
    if (isTablet(context)) return 16.0;
    return 14.0;
  }

  static double getBodyFontSize(BuildContext context) {
    if (isLargeTablet(context)) return 16.0;
    if (isTablet(context)) return 15.0;
    return 14.0;
  }

  static double getButtonHeight(BuildContext context) {
    if (isLargeTablet(context)) return 60.0;
    if (isTablet(context)) return 56.0;
    return 52.0;
  }

  static double getIconSize(BuildContext context) {
    if (isLargeTablet(context)) return 32.0;
    if (isTablet(context)) return 28.0;
    return 24.0;
  }

  static double getImageSize(BuildContext context) {
    if (isLargeTablet(context)) return 200.0;
    if (isTablet(context)) return 160.0;
    return 120.0;
  }

  static EdgeInsets getPagePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getHorizontalPadding(context),
      vertical: getVerticalPadding(context),
    );
  }

  static EdgeInsets getCardMargin(BuildContext context) {
    if (isLargeTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0);
    }
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
    }
    return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  }
}
