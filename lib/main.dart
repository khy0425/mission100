import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'utils/config/constants.dart';
import 'screens/home_screen.dart';
// DreamFlow - 온보딩 화면 제거됨 (아카이브)
// import 'screens/onboarding_screen.dart';
import 'screens/onboarding/onboarding_screen.dart'; // 자각몽 전용 온보딩
import 'services/localization/theme_service.dart';
import 'services/localization/locale_service.dart';
import 'services/notification/notification_service.dart';
import 'services/payment/ad_service.dart';
import 'services/payment/rewarded_ad_reward_service.dart';
import 'services/monetization/ad_service.dart' as monetization;
import 'services/ads/reward_ad_service.dart';
import 'services/core/onboarding_service.dart';
// DreamFlow - Chad 서비스 제거됨 (운동 앱 전용)
// import 'services/chad/chad_evolution_service.dart';
// import 'services/chad/chad_image_service.dart';
// import 'services/chad/chad_condition_service.dart';
// import 'services/chad/chad_recovery_service.dart';
// import 'services/chad/chad_active_recovery_service.dart';
import 'services/achievements/achievement_service.dart';
import 'services/data/database_service.dart';
import 'services/progress/challenge_service.dart';
import 'services/auth/auth_service.dart';
import 'services/data/cloud_sync_service.dart'; // Using stub version for testing
import 'services/payment/billing_service.dart';
import 'services/core/deep_link_handler.dart';
import 'services/ai/conversation_token_service.dart';
import 'services/ai/openrouter_service.dart';
import 'services/workout/daily_task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ========================================
    // 1단계: 핵심 초기화 (병렬 실행으로 속도 향상)
    // ========================================
    final stopwatch = Stopwatch()..start();

    // 병렬로 실행 가능한 핵심 초기화들
    await Future.wait([
      // 환경 변수 로드
      dotenv.load(fileName: '.env').then((_) {
        debugPrint('✅ 환경 변수 로드 완료');
      }).catchError((e) {
        debugPrint('⚠️ 환경 변수 로드 실패: $e');
      }),

      // Firebase 초기화
      Firebase.initializeApp().then((_) {
        debugPrint('✅ Firebase 초기화 완료');
      }).catchError((e) {
        debugPrint('⚠️ Firebase 초기화 실패: $e');
      }),

      // 화면 방향 고정
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    ]);

    debugPrint('⏱️ 1단계 완료: ${stopwatch.elapsedMilliseconds}ms');

    // ========================================
    // 2단계: UI 필수 서비스 (병렬 실행)
    // ========================================
    final themeService = ThemeService();
    final localeNotifier = LocaleNotifier();
    final onboardingService = OnboardingService();
    final authService = AuthService();
    final conversationTokenService = ConversationTokenService();

    await Future.wait([
      themeService.initialize().then((_) {
        debugPrint('✅ ThemeService 초기화 완료');
      }),
      localeNotifier.loadLocale().then((_) {
        debugPrint('✅ LocaleService 초기화 완료');
      }),
      onboardingService.initialize().then((_) {
        debugPrint('✅ OnboardingService 초기화 완료');
      }),
      authService.initialize().then((_) {
        debugPrint('✅ AuthService 초기화 완료');
      }),
      conversationTokenService.initialize().then((_) {
        debugPrint('✅ ConversationTokenService 초기화 완료');
      }),
    ]);

    debugPrint('⏱️ 2단계 완료: ${stopwatch.elapsedMilliseconds}ms');

    // ========================================
    // 3단계: 백그라운드 서비스 (non-blocking)
    // ========================================

    // Google Mobile Ads (백그라운드 - UI 차단 안 함)
    unawaited(MobileAds.instance.initialize().then((_) {
      debugPrint('✅ Google Mobile Ads 초기화 완료');
    }).catchError((e) {
      debugPrint('⚠️ Google Mobile Ads 초기화 실패: $e');
    }));

    // OpenRouter AI 서비스 (백그라운드 - 채팅 시 필요)
    final openRouterService = OpenRouterService();
    unawaited(openRouterService.initialize().then((_) {
      debugPrint('✅ OpenRouterService 초기화 완료');
    }).catchError((e) {
      debugPrint('⚠️ OpenRouterService 초기화 실패: $e');
    }));

    debugPrint('🚀 총 초기화 시간: ${stopwatch.elapsedMilliseconds}ms');
    stopwatch.stop();

    // Daily Task 서비스 생성 (초기화 불필요)
    final dailyTaskService = DailyTaskService();
    dailyTaskService.setTokenService(conversationTokenService);
    dailyTaskService.setAuthService(authService);
    debugPrint('✅ DailyTaskService 생성 완료 (토큰 서비스 + Auth 서비스 연결됨)');

    // CloudSync 서비스 초기화 (백그라운드에서) - Using stub for testing
    final cloudSyncService = CloudSyncService();
    unawaited(cloudSyncService.initialize().then((_) {
      debugPrint('✅ CloudSyncService 초기화 완료');
    }).catchError((e) {
      debugPrint('❌ CloudSyncService 초기화 오류: $e');
    }));

    // 빌링 서비스 초기화 (백그라운드에서)
    // 참고: 구독 관리는 AuthService에서 처리됨
    final billingService = BillingService();
    unawaited(billingService.initialize().then((_) {
      debugPrint('✅ BillingService 초기화 완료');
    }).catchError((e) {
      debugPrint('❌ BillingService 초기화 오류: $e');
    }));

    // 리워드 광고 서비스 초기화 (백그라운드에서)
    final rewardedAdRewardService = RewardedAdRewardService();
    unawaited(rewardedAdRewardService.initialize().then((_) {
      debugPrint('✅ RewardedAdRewardService 초기화 완료');
    }).catchError((e) {
      debugPrint('❌ RewardedAdRewardService 초기화 오류: $e');
    }));

    // Google AdMob 광고 초기화 (무료 사용자 수익화)
    final adService = monetization.AdService();
    unawaited(adService.initialize().then((_) {
      debugPrint('✅ AdMob 초기화 완료');
    }).catchError((e) {
      debugPrint('❌ AdMob 초기화 오류: $e');
    }));

    debugPrint('🚀 앱 기본 초기화 완료 - 빠른 시작!');

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: themeService),
          ChangeNotifierProvider.value(value: localeNotifier),
          ChangeNotifierProvider.value(value: onboardingService),
          // DreamFlow - Chad 서비스 제거됨 (운동 앱 전용)
          // ChangeNotifierProvider.value(value: chadEvolutionService),
          // ChangeNotifierProvider.value(value: chadConditionService),
          // ChangeNotifierProvider.value(value: chadRecoveryService),
          // ChangeNotifierProvider.value(value: chadActiveRecoveryService),
          ChangeNotifierProvider.value(value: authService),
          ChangeNotifierProvider.value(value: conversationTokenService),
          ChangeNotifierProvider.value(value: dailyTaskService),
          ChangeNotifierProvider.value(value: rewardedAdRewardService),
          // Provider.value(value: subscriptionService), // 구형 시스템 - AuthService로 대체됨
          Provider.value(value: billingService),
        ],
        child: const MissionApp(),
      ),
    );

    // 나머지 서비스들은 백그라운드에서 초기화 (non-blocking)
    _initializeBackgroundServices();
  } catch (e, stackTrace) {
    debugPrint('🚨 앱 초기화 중 치명적인 오류 발생: $e');
    debugPrint('스택 트레이스: $stackTrace');

    // 앱이 완전히 중단되지 않도록 기본 앱으로 실행
    runApp(
      MaterialApp(
        title: 'DreamFlow',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'An error occurred during app initialization.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: $e',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('Retrying app startup');
                    // App restart logic
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 백그라운드에서 나머지 서비스들을 초기화하는 함수
void _initializeBackgroundServices() {
  // 광고 서비스 초기화 (백그라운드)
  AdService.initialize().then((_) {
    debugPrint('✅ AdService 백그라운드 초기화 완료');
  }).catchError((Object e) {
    debugPrint('❌ AdService 초기화 오류: $e');
  });

  // 리워드 광고 서비스 초기화 및 광고 미리 로드 (백그라운드)
  RewardAdService().loadAd().then((success) {
    if (success) {
      debugPrint('✅ RewardAdService 백그라운드 초기화 및 광고 로드 완료');
    } else {
      debugPrint('⚠️ RewardAdService 초기화됨 (광고 로드 실패)');
    }
  }).catchError((Object e) {
    debugPrint('❌ RewardAdService 초기화 오류: $e');
  });

  // 알림 서비스 초기화 (백그라운드)
  NotificationService.initialize().then((_) async {
    await NotificationService.createNotificationChannels();
    debugPrint('✅ NotificationService 백그라운드 초기화 완료');
  }).catchError((Object e) {
    debugPrint('❌ NotificationService 초기화 오류: $e');
  });

  // DreamFlow - Chad 이미지 서비스 제거됨 (운동 앱 전용)
  // 자각몽 앱에는 Chad 캐릭터가 필요 없습니다
  // ChadImageService().initialize().then((_) {
  //   debugPrint('✅ ChadImageService 백그라운드 초기화 완료');
  // }).catchError((Object e) {
  //   debugPrint('❌ ChadImageService 초기화 오류: $e');
  // });

  // 업적 서비스 초기화 (백그라운드)
  Future.delayed(const Duration(milliseconds: 500), () {
    AchievementService.initialize().then((_) async {
      final totalCount = await AchievementService.getTotalCount();
      final unlockedCount = await AchievementService.getUnlockedCount();
      debugPrint(
        '✅ 업적 서비스 백그라운드 초기화 완료 - 총 $totalCount개 업적, $unlockedCount개 잠금해제',
      );
    }).catchError((Object e) {
      debugPrint('❌ 업적 서비스 초기화 오류: $e');
    });
  });

  // 챌린지 서비스 초기화 (백그라운드)
  Future.delayed(const Duration(milliseconds: 700), () {
    ChallengeService().initialize().then((_) {
      debugPrint('✅ 챌린지 서비스 백그라운드 초기화 완료');
    }).catchError((Object e) {
      debugPrint('❌ 챌린지 서비스 초기화 오류: $e');
    });
  });

  // DreamFlow - Chad 이미지 프리로드 제거됨 (자각몽 앱에는 Chad 캐릭터 불필요)
  // 자각몽 앱은 Lumi AI 캐릭터를 사용합니다
}

// 로케일 변경을 위한 Notifier
class LocaleNotifier extends ChangeNotifier {
  // 기본값을 시스템 언어로 즉시 설정 (동기)
  Locale _locale = WidgetsBinding.instance.platformDispatcher.locales
      .any((locale) => locale.languageCode == 'ko')
      ? LocaleService.koreanLocale
      : LocaleService.englishLocale;

  LocaleNotifier() {
    // 생성 후 SharedPreferences에서 저장된 언어 확인 및 적용
    _initializeLocale();
  }

  Locale get locale => _locale;

  Future<void> _initializeLocale() async {
    // 시스템 언어 기반으로 자동 설정
    await LocaleService.initializeLocale();
    _locale = await LocaleService.getLocale();
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;

    await LocaleService.setLocale(newLocale);
    _locale = newLocale;
    notifyListeners();
  }

  Future<void> loadLocale() async {
    // 로케일 자동 초기화는 스플래시 화면에서 처리
    // await LocaleService.initializeLocale();

    // 설정된 언어 불러오기
    _locale = await LocaleService.getLocale();
    notifyListeners();
  }
}

class MissionApp extends StatefulWidget {
  const MissionApp({super.key});

  @override
  State<MissionApp> createState() => _MissionAppState();
}

class _MissionAppState extends State<MissionApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 앱 생명주기 관찰자 등록
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 앱 생명주기 관찰자 제거
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 앱이 포그라운드로 돌아왔을 때 권한 상태 재확인
    if (state == AppLifecycleState.resumed) {
      debugPrint('🔄 앱이 포그라운드로 돌아왔습니다. 권한 상태 재확인...');

      // 알림 권한 재확인 (약간의 지연 후)
      Future.delayed(const Duration(milliseconds: 500), () {
        NotificationService.recheckPermissionsOnResume();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeService, LocaleNotifier>(
      builder: (context, themeService, localeService, child) {
        return MaterialApp(
          title: 'DreamFlow',
          debugShowCheckedModeBanner: false,
          navigatorKey: DeepLinkHandler.navigatorKey,

          // 테마 설정 - ThemeService의 커스터마이징된 테마 사용
          theme: themeService.getThemeData(),
          darkTheme: themeService.getThemeData(),
          themeMode: themeService.themeMode,

          // 다국어 설정
          locale: localeService.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LocaleService.supportedLocales,

          // 스플래시 화면을 홈으로 설정
          home: const SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await _animationController.forward();

    if (!mounted) return;

    try {
      // 0단계: 스마트 언어 탐지 (앱 실행할 때마다)
      debugPrint('🌐 스마트 언어 탐지 시작...');
      try {
        await LocaleService.initializeLocale();
        debugPrint('🌐 스마트 언어 탐지 완료');

        // 언어 변경이 있었다면 LocaleNotifier 업데이트
        if (mounted) {
          final localeNotifier = Provider.of<LocaleNotifier>(
            context,
            listen: false,
          );
          await localeNotifier.loadLocale();
        }
      } catch (e) {
        debugPrint('🌐 스마트 언어 탐지 오류: $e (기존 설정 유지)');
      }

      // 1단계: 온보딩 완료 여부 확인
      bool isOnboardingCompleted = false;
      try {
        isOnboardingCompleted = await OnboardingService.isOnboardingCompleted();
        debugPrint('온보딩 완료 여부: $isOnboardingCompleted');
      } catch (e) {
        debugPrint('온보딩 서비스 확인 오류: $e (기본값: false 사용)');
        isOnboardingCompleted = false;
      }

      if (!isOnboardingCompleted) {
        // 온보딩이 완료되지 않았으면 온보딩 화면으로
        debugPrint('화면 이동: 온보딩 화면 (첫 실행)');
        if (mounted) {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (context) => const OnboardingScreen(),
            ),
          );
        }
        return;
      }

      // 2단계: UserProfile 생성 여부 확인
      bool hasUserProfile = false;
      try {
        final databaseService = DatabaseService();
        final userProfile = await databaseService.getUserProfile();
        hasUserProfile = userProfile != null;
        debugPrint('UserProfile 존재 여부: $hasUserProfile');
      } catch (e) {
        debugPrint('UserProfile 확인 오류: $e (기본값: false 사용)');
        hasUserProfile = false;
      }

      // 3단계: 화면 결정
      if (hasUserProfile) {
        // 프로필이 있으면 메인 화면으로
        debugPrint('화면 이동: 메인 화면');
        if (mounted) {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      } else {
        // 프로필이 없으면 메인 화면으로 (홈 스크린에서 온보딩 UI 표시)
        debugPrint('화면 이동: 메인 화면 (프로필 생성 필요)');
        if (mounted) {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('🚨 스플래시 화면 초기화 중 치명적인 오류 발생: $e');
      debugPrint('스택 트레이스: $stackTrace');

      // 오류가 발생했을 때 온보딩 화면으로 안전하게 이동
      if (mounted) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    Color(AppColors.nightGradient[0]),
                    Color(AppColors.nightGradient[1]),
                  ]
                : [
                    Color(AppColors.lucidGradient[0]),
                    Color(AppColors.lucidGradient[1]),
                  ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 앱 로고/아이콘 (회전 및 스케일 애니메이션 적용)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.9),
                            const Color(AppColors.accentColor).withValues(alpha: 0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(AppColors.accentColor).withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.nightlight_round,
                        size: 60,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // 앱 이름 (페이드 인 애니메이션)
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
                ),
                child: Text(
                  'DREAMFLOW',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: const Color(AppColors.accentColor).withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 부제목 (페이드 인 애니메이션)
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
                ),
                child: Text(
                  AppLocalizations.of(context).appSlogan,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),

              const SizedBox(height: 40),

                // 로딩 인디케이터 (페이드 인 애니메이션)
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
                  ),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(AppColors.accentColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
