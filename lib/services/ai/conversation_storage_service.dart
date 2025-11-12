import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/dream_conversation.dart';

/// Lumi 대화 내역 저장 서비스
class ConversationStorageService {
  static final ConversationStorageService _instance =
      ConversationStorageService._internal();
  factory ConversationStorageService() => _instance;
  ConversationStorageService._internal();

  static const String _conversationsKey = 'lumi_conversations';
  static const String _activeConversationKey = 'active_conversation_id';

  /// 모든 대화 세션 로드
  Future<List<DreamConversation>> loadAllConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conversationsJson = prefs.getString(_conversationsKey);

      if (conversationsJson == null) return [];

      final List<dynamic> conversationsList = json.decode(conversationsJson);
      return conversationsList
          .map((c) => DreamConversation.fromJson(c))
          .toList();
    } catch (e) {
      debugPrint('❌ Failed to load conversations: $e');
      return [];
    }
  }

  /// 특정 대화 세션 로드
  Future<DreamConversation?> loadConversation(String conversationId) async {
    final conversations = await loadAllConversations();
    try {
      return conversations.firstWhere((c) => c.id == conversationId);
    } catch (e) {
      return null;
    }
  }

  /// 현재 활성 대화 세션 로드
  Future<DreamConversation?> loadActiveConversation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final activeId = prefs.getString(_activeConversationKey);

      if (activeId == null) return null;

      return await loadConversation(activeId);
    } catch (e) {
      debugPrint('❌ Failed to load active conversation: $e');
      return null;
    }
  }

  /// 대화 세션 저장
  Future<void> saveConversation(DreamConversation conversation) async {
    try {
      final conversations = await loadAllConversations();

      // 기존 대화 업데이트 또는 새 대화 추가
      final index = conversations.indexWhere((c) => c.id == conversation.id);
      if (index != -1) {
        conversations[index] = conversation;
      } else {
        conversations.add(conversation);
      }

      // 저장 (최근 20개만 유지)
      final recentConversations = conversations.length > 20
          ? conversations.sublist(conversations.length - 20)
          : conversations;

      final prefs = await SharedPreferences.getInstance();
      final conversationsJson =
          json.encode(recentConversations.map((c) => c.toJson()).toList());
      await prefs.setString(_conversationsKey, conversationsJson);

      debugPrint('✅ Saved conversation: ${conversation.id}');
    } catch (e) {
      debugPrint('❌ Failed to save conversation: $e');
    }
  }

  /// 현재 활성 대화 세션 설정
  Future<void> setActiveConversation(String conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeConversationKey, conversationId);
      debugPrint('✅ Set active conversation: $conversationId');
    } catch (e) {
      debugPrint('❌ Failed to set active conversation: $e');
    }
  }

  /// 새 대화 시작
  Future<DreamConversation> startNewConversation(String userId) async {
    final conversation = DreamConversation.create(userId);
    await saveConversation(conversation);
    await setActiveConversation(conversation.id);
    return conversation;
  }

  /// 대화 세션 삭제
  Future<void> deleteConversation(String conversationId) async {
    try {
      final conversations = await loadAllConversations();
      conversations.removeWhere((c) => c.id == conversationId);

      final prefs = await SharedPreferences.getInstance();
      final conversationsJson =
          json.encode(conversations.map((c) => c.toJson()).toList());
      await prefs.setString(_conversationsKey, conversationsJson);

      // 활성 대화였다면 초기화
      final activeId = prefs.getString(_activeConversationKey);
      if (activeId == conversationId) {
        await prefs.remove(_activeConversationKey);
      }

      debugPrint('✅ Deleted conversation: $conversationId');
    } catch (e) {
      debugPrint('❌ Failed to delete conversation: $e');
    }
  }

  /// 모든 대화 삭제
  Future<void> deleteAllConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_conversationsKey);
      await prefs.remove(_activeConversationKey);
      debugPrint('✅ Deleted all conversations');
    } catch (e) {
      debugPrint('❌ Failed to delete all conversations: $e');
    }
  }
}
