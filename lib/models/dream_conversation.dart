/// Lumi와의 꿈 분석 대화 세션
class DreamConversation {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ConversationMessage> messages;
  final int tokenCount; // 누적 토큰 수 (비용 관리)

  const DreamConversation({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    required this.tokenCount,
  });

  /// 새 대화 세션 생성
  static DreamConversation create(String userId) {
    final now = DateTime.now();
    return DreamConversation(
      id: 'conv_${userId}_${now.millisecondsSinceEpoch}',
      userId: userId,
      createdAt: now,
      updatedAt: now,
      messages: [],
      tokenCount: 0,
    );
  }

  /// 메시지 추가
  DreamConversation addMessage(ConversationMessage message) {
    return DreamConversation(
      id: id,
      userId: userId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      messages: [...messages, message],
      tokenCount: tokenCount + message.estimatedTokens,
    );
  }

  /// 토큰 수 제한 체크 (비용 관리)
  bool get isTokenLimitReached => tokenCount > 5000; // 예: 5000 토큰 제한

  /// 대화 요약 필요 여부
  bool get needsSummary => messages.length > 10;

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'tokenCount': tokenCount,
    };
  }

  factory DreamConversation.fromJson(Map<String, dynamic> json) {
    return DreamConversation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      messages: (json['messages'] as List)
          .map((m) => ConversationMessage.fromJson(m))
          .toList(),
      tokenCount: json['tokenCount'] as int? ?? 0,
    );
  }

  /// OpenAI API 형식으로 변환
  List<Map<String, String>> toOpenAIMessages() {
    return messages
        .map((m) => {
              'role': m.role,
              'content': m.content,
            })
        .toList();
  }
}

/// 대화 메시지
class ConversationMessage {
  final String role; // 'system', 'user', 'assistant'
  final String content;
  final DateTime timestamp;
  final int estimatedTokens;

  const ConversationMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    required this.estimatedTokens,
  });

  /// 사용자 메시지 생성
  static ConversationMessage user(String content) {
    return ConversationMessage(
      role: 'user',
      content: content,
      timestamp: DateTime.now(),
      estimatedTokens: _estimateTokens(content),
    );
  }

  /// AI 응답 메시지 생성
  static ConversationMessage assistant(String content) {
    return ConversationMessage(
      role: 'assistant',
      content: content,
      timestamp: DateTime.now(),
      estimatedTokens: _estimateTokens(content),
    );
  }

  /// 시스템 프롬프트 생성
  static ConversationMessage system(String content) {
    return ConversationMessage(
      role: 'system',
      content: content,
      timestamp: DateTime.now(),
      estimatedTokens: _estimateTokens(content),
    );
  }

  /// 토큰 수 추정 (대략 4자당 1토큰)
  static int _estimateTokens(String text) {
    return (text.length / 4).ceil();
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'estimatedTokens': estimatedTokens,
    };
  }

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      role: json['role'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      estimatedTokens: json['estimatedTokens'] as int? ?? 0,
    );
  }
}
