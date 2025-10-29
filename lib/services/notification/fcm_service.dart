import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../notification/notification_service.dart';
import '../core/deep_link_handler.dart';

/// Top-level function for background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 FCM Background Message: ${message.notification?.title}');
}

/// FCM (Firebase Cloud Messaging) 서비스
/// 푸시 알림 관리
class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isInitialized = false;
  String? _fcmToken;

  /// FCM 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('🚀 FCM 초기화 시작');

      // 1. 권한 요청
      final granted = await _requestPermission();
      if (!granted) {
        debugPrint('⚠️ FCM 권한이 거부됨');
        return;
      }

      // 2. Background message handler 설정
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // 3. FCM 토큰 가져오기 및 저장
      await _getFCMToken();

      // 4. Foreground 메시지 리스너
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 5. Background/Terminated 메시지 클릭 리스너
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);

      // 6. 토큰 갱신 리스너
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      // 7. 앱이 terminated 상태에서 알림 클릭으로 열렸는지 확인
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        await _handleMessageOpened(initialMessage);
      }

      _isInitialized = true;
      debugPrint('✅ FCM 초기화 완료');
    } catch (e) {
      debugPrint('❌ FCM 초기화 오류: $e');
    }
  }

  /// 푸시 알림 권한 요청
  Future<bool> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ FCM 권한 승인됨');
        return true;
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('✅ FCM 임시 권한 승인됨');
        return true;
      } else {
        debugPrint('❌ FCM 권한 거부됨');
        return false;
      }
    } catch (e) {
      debugPrint('❌ FCM 권한 요청 오류: $e');
      return false;
    }
  }

  /// FCM 토큰 가져오기 및 Firestore 저장
  Future<void> _getFCMToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _fcmToken = token;
        debugPrint('✅ FCM 토큰 획득: $token');

        // Firestore에 저장
        await _saveFCMToken(token);
      }
    } catch (e) {
      debugPrint('❌ FCM 토큰 가져오기 오류: $e');
    }
  }

  /// FCM 토큰을 Firestore에 저장
  Future<void> _saveFCMToken(String token) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('⚠️ 로그인 필요 - FCM 토큰 저장 안함');
        return;
      }

      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });

      debugPrint('✅ FCM 토큰 Firestore 저장 완료');
    } catch (e) {
      debugPrint('❌ FCM 토큰 Firestore 저장 오류: $e');
    }
  }

  /// 토큰 갱신 시 호출
  Future<void> _onTokenRefresh(String token) async {
    debugPrint('🔄 FCM 토큰 갱신: $token');
    _fcmToken = token;
    await _saveFCMToken(token);
  }

  /// Foreground 메시지 처리
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('🔔 FCM Foreground Message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    // NotificationService를 사용하여 로컬 알림 표시
    final notificationService = NotificationService();
    await notificationService.showNotification(
      title: notification.title ?? 'Mission100',
      body: notification.body ?? '',
      id: message.hashCode,
    );

    debugPrint('✅ 푸시 알림 표시 완료: ${notification.title}');
  }

  /// Background/Terminated에서 알림 클릭 시
  Future<void> _handleMessageOpened(RemoteMessage message) async {
    debugPrint('🔔 FCM Message Opened: ${message.notification?.title}');

    // 딥링크 핸들러를 사용한 화면 라우팅 처리
    final deepLinkHandler = DeepLinkHandler();
    final parsedData = deepLinkHandler.parseNotificationPayload(message.data);

    final route = parsedData['route'] as String?;
    final params = parsedData['params'] as Map<String, dynamic>?;

    if (route != null) {
      debugPrint('📱 화면 이동: $route (params: $params)');
      await deepLinkHandler.handleDeepLink(route, params: params);
    }
  }

  /// 특정 토픽 구독
  Future<void> subscribeTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('✅ FCM 토픽 구독: $topic');
    } catch (e) {
      debugPrint('❌ FCM 토픽 구독 오류: $e');
    }
  }

  /// 특정 토픽 구독 해제
  Future<void> unsubscribeTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('✅ FCM 토픽 구독 해제: $topic');
    } catch (e) {
      debugPrint('❌ FCM 토픽 구독 해제 오류: $e');
    }
  }

  /// 사용자별 토픽 구독 (운동 알림 등)
  Future<void> subscribeToUserTopics() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // 기본 토픽 구독
    await subscribeTopic('all_users'); // 모든 사용자
    await subscribeTopic('workout_reminders'); // 운동 알림
    await subscribeTopic('chad_updates'); // Chad 업데이트

    debugPrint('✅ 사용자 토픽 구독 완료');
  }

  /// FCM 토큰 반환 (외부 접근용)
  String? get fcmToken => _fcmToken;

  /// FCM 서비스 정리
  void dispose() {
    debugPrint('🧹 FCM 서비스 정리');
  }
}
