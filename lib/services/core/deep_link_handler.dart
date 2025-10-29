import 'package:flutter/material.dart';

/// 딥링크 핸들러 - 푸시 알림 등에서 화면 라우팅 처리
class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  // GlobalKey for navigator
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// 딥링크 URL 파싱 및 화면 이동
  Future<void> handleDeepLink(String? route, {Map<String, dynamic>? params}) async {
    if (route == null || route.isEmpty) {
      debugPrint('⚠️ DeepLink: Empty route');
      return;
    }

    debugPrint('🔗 DeepLink: Handling route - $route');

    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint('❌ DeepLink: Navigator context not available');
      return;
    }

    try {
      switch (route) {
        // 홈 화면
        case '/':
        case '/home':
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          break;

        // 운동 화면
        case '/workout':
          final workoutId = params?['workoutId'] as String?;
          if (workoutId != null) {
            Navigator.of(context).pushNamed('/workout', arguments: {'workoutId': workoutId});
          } else {
            Navigator.of(context).pushNamed('/workout');
          }
          break;

        // 운동 기록 화면
        case '/workout-history':
          Navigator.of(context).pushNamed('/workout-history');
          break;

        // 업적 화면
        case '/achievements':
          final achievementId = params?['achievementId'] as String?;
          if (achievementId != null) {
            Navigator.of(context).pushNamed(
              '/achievements',
              arguments: {'highlightId': achievementId},
            );
          } else {
            Navigator.of(context).pushNamed('/achievements');
          }
          break;

        // Chad 화면
        case '/chad':
          Navigator.of(context).pushNamed('/chad');
          break;

        // 프로필 화면
        case '/profile':
          Navigator.of(context).pushNamed('/profile');
          break;

        // 설정 화면
        case '/settings':
          Navigator.of(context).pushNamed('/settings');
          break;

        // 구독 화면
        case '/subscription':
          Navigator.of(context).pushNamed('/subscription');
          break;

        // 챌린지 화면
        case '/challenge':
          final challengeId = params?['challengeId'] as String?;
          if (challengeId != null) {
            Navigator.of(context).pushNamed(
              '/challenge',
              arguments: {'challengeId': challengeId},
            );
          } else {
            Navigator.of(context).pushNamed('/challenge');
          }
          break;

        // 캘린더 화면
        case '/calendar':
          Navigator.of(context).pushNamed('/calendar');
          break;

        // 통계 화면
        case '/stats':
        case '/progress':
          Navigator.of(context).pushNamed('/progress');
          break;

        // 온보딩 화면
        case '/onboarding':
          Navigator.of(context).pushNamed('/onboarding');
          break;

        // 운동 완료 화면
        case '/workout-complete':
          final workoutData = params?['workoutData'] as Map<String, dynamic>?;
          if (workoutData != null) {
            Navigator.of(context).pushNamed(
              '/workout-complete',
              arguments: workoutData,
            );
          }
          break;

        // 새 업적 알림
        case '/achievement-unlocked':
          final achievementData = params?['achievementData'] as Map<String, dynamic>?;
          if (achievementData != null) {
            _showAchievementDialog(context, achievementData);
          }
          break;

        // Chad 레벨업 알림
        case '/chad-level-up':
          final levelData = params?['levelData'] as Map<String, dynamic>?;
          if (levelData != null) {
            _showChadLevelUpDialog(context, levelData);
          }
          break;

        // 기본: 알 수 없는 라우트
        default:
          debugPrint('⚠️ DeepLink: Unknown route - $route');
          // 기본적으로 홈 화면으로 이동
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }

      debugPrint('✅ DeepLink: Navigation completed');
    } catch (e) {
      debugPrint('❌ DeepLink: Navigation error - $e');
    }
  }

  /// 업적 달성 다이얼로그 표시
  void _showAchievementDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 새로운 업적 달성!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data['title'] ?? '업적 달성',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(data['description'] ?? ''),
            const SizedBox(height: 16),
            Text(
              '+${data['xpReward'] ?? 0} XP',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/achievements');
            },
            child: const Text('업적 보기'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  /// Chad 레벨업 다이얼로그 표시
  void _showChadLevelUpDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Chad 레벨 업!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Level ${data['newLevel'] ?? 1}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(data['message'] ?? 'Chad가 성장했습니다!'),
            if (data['newStage'] != null) ...[
              const SizedBox(height: 16),
              Text(
                '새로운 단계: ${data['newStage']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/chad');
            },
            child: const Text('Chad 보기'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  /// 외부 URL 파싱 (예: mission100://workout?id=123)
  Map<String, dynamic> parseDeepLinkUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final route = uri.path;
      final params = uri.queryParameters;

      debugPrint('🔗 DeepLink URL parsed: route=$route, params=$params');

      return {
        'route': route,
        'params': params,
      };
    } catch (e) {
      debugPrint('❌ DeepLink: Failed to parse URL - $e');
      return {
        'route': '/',
        'params': <String, dynamic>{},
      };
    }
  }

  /// 푸시 알림 페이로드에서 라우팅 정보 추출
  Map<String, dynamic> parseNotificationPayload(Map<String, dynamic> payload) {
    try {
      final route = payload['route'] as String? ?? '/';
      final paramsJson = payload['params'] as Map<String, dynamic>? ?? {};

      debugPrint('🔔 Notification payload parsed: route=$route, params=$paramsJson');

      return {
        'route': route,
        'params': paramsJson,
      };
    } catch (e) {
      debugPrint('❌ DeepLink: Failed to parse notification payload - $e');
      return {
        'route': '/',
        'params': <String, dynamic>{},
      };
    }
  }
}
