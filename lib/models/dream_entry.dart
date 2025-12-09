/// 꿈 일기 항목
///
/// 사용자가 기록한 꿈의 완전한 데이터 구조
class DreamEntry {
  final String id;
  final String userId; // Firebase Auth UID (익명 사용자도 로컬 ID 사용)
  final DateTime createdAt; // 꿈 기록 작성 시간
  final DateTime? updatedAt; // 마지막 수정 시간
  final DateTime dreamDate; // 실제 꿈을 꾼 날짜

  // 꿈 내용
  final String title; // 꿈 제목 (선택)
  final String content; // 꿈 내용 (필수)

  // 자각몽 관련
  final int lucidityLevel; // 자각도 (0-10)
  final bool wasLucid; // 자각몽 여부

  // 감정 및 분위기
  final List<String> emotions; // 감정 태그 ['기쁨', '불안', '흥분']
  final int? moodScore; // 기분 점수 (1-5)

  // 꿈 특성
  final List<String> symbols; // 꿈 심볼/키워드 ['물', '비행', '학교']
  final List<String> characters; // 등장 인물 ['엄마', '친구', '낯선 사람']
  final List<String> locations; // 장소 ['집', '학교', '낯선 도시']

  // 수면 정보
  final DateTime? sleepTime; // 수면 시작 시간
  final DateTime? wakeTime; // 기상 시간
  final int? sleepQuality; // 수면 품질 (1-5)

  // 자각몽 기법
  final List<String> techniquesUsed; // 사용한 기법 ['MILD', 'WBTB', 'Reality Check']
  final bool usedWbtb; // WBTB 사용 여부

  // AI 분석 연결
  final String? aiAnalysisId; // AI 분석 결과 ID (DreamConversation.id)
  final bool hasAiAnalysis; // AI 분석 완료 여부

  // 메타데이터
  final List<String> tags; // 사용자 정의 태그
  final bool isFavorite; // 즐겨찾기
  final String? imageUrl; // 첨부 이미지 URL (선택)
  final String? voiceNoteUrl; // 음성 메모 URL (선택)

  // 패턴 분석용
  final int? repeatPatternId; // 반복 패턴 ID (같은 유형의 꿈들을 그룹화)
  final bool isRecurring; // 반복되는 꿈 여부

  const DreamEntry({
    required this.id,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
    required this.dreamDate,
    this.title = '',
    required this.content,
    this.lucidityLevel = 0,
    this.wasLucid = false,
    this.emotions = const [],
    this.moodScore,
    this.symbols = const [],
    this.characters = const [],
    this.locations = const [],
    this.sleepTime,
    this.wakeTime,
    this.sleepQuality,
    this.techniquesUsed = const [],
    this.usedWbtb = false,
    this.aiAnalysisId,
    this.hasAiAnalysis = false,
    this.tags = const [],
    this.isFavorite = false,
    this.imageUrl,
    this.voiceNoteUrl,
    this.repeatPatternId,
    this.isRecurring = false,
  });

  /// 새 꿈 일기 생성
  factory DreamEntry.create({
    required String userId,
    required String content,
    String title = '',
    DateTime? dreamDate,
    int lucidityLevel = 0,
  }) {
    final now = DateTime.now();
    return DreamEntry(
      id: 'dream_${userId}_${now.millisecondsSinceEpoch}',
      userId: userId,
      createdAt: now,
      dreamDate: dreamDate ?? now,
      title: title,
      content: content,
      lucidityLevel: lucidityLevel,
      wasLucid: lucidityLevel >= 5, // 자각도 5 이상이면 자각몽으로 간주
    );
  }

  /// 꿈 일기 수정
  DreamEntry copyWith({
    String? title,
    String? content,
    int? lucidityLevel,
    bool? wasLucid,
    List<String>? emotions,
    int? moodScore,
    List<String>? symbols,
    List<String>? characters,
    List<String>? locations,
    DateTime? sleepTime,
    DateTime? wakeTime,
    int? sleepQuality,
    List<String>? techniquesUsed,
    bool? usedWbtb,
    String? aiAnalysisId,
    bool? hasAiAnalysis,
    List<String>? tags,
    bool? isFavorite,
    String? imageUrl,
    String? voiceNoteUrl,
    int? repeatPatternId,
    bool? isRecurring,
  }) {
    return DreamEntry(
      id: id,
      userId: userId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      dreamDate: dreamDate,
      title: title ?? this.title,
      content: content ?? this.content,
      lucidityLevel: lucidityLevel ?? this.lucidityLevel,
      wasLucid: wasLucid ?? this.wasLucid,
      emotions: emotions ?? this.emotions,
      moodScore: moodScore ?? this.moodScore,
      symbols: symbols ?? this.symbols,
      characters: characters ?? this.characters,
      locations: locations ?? this.locations,
      sleepTime: sleepTime ?? this.sleepTime,
      wakeTime: wakeTime ?? this.wakeTime,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      techniquesUsed: techniquesUsed ?? this.techniquesUsed,
      usedWbtb: usedWbtb ?? this.usedWbtb,
      aiAnalysisId: aiAnalysisId ?? this.aiAnalysisId,
      hasAiAnalysis: hasAiAnalysis ?? this.hasAiAnalysis,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      voiceNoteUrl: voiceNoteUrl ?? this.voiceNoteUrl,
      repeatPatternId: repeatPatternId ?? this.repeatPatternId,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }

  /// Database JSON 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'dreamDate': dreamDate.toIso8601String(),
      'title': title,
      'content': content,
      'lucidityLevel': lucidityLevel,
      'wasLucid': wasLucid ? 1 : 0,
      'emotions': emotions.join(','),
      'moodScore': moodScore,
      'symbols': symbols.join(','),
      'characters': characters.join(','),
      'locations': locations.join(','),
      'sleepTime': sleepTime?.toIso8601String(),
      'wakeTime': wakeTime?.toIso8601String(),
      'sleepQuality': sleepQuality,
      'techniquesUsed': techniquesUsed.join(','),
      'usedWbtb': usedWbtb ? 1 : 0,
      'aiAnalysisId': aiAnalysisId,
      'hasAiAnalysis': hasAiAnalysis ? 1 : 0,
      'tags': tags.join(','),
      'isFavorite': isFavorite ? 1 : 0,
      'imageUrl': imageUrl,
      'voiceNoteUrl': voiceNoteUrl,
      'repeatPatternId': repeatPatternId,
      'isRecurring': isRecurring ? 1 : 0,
    };
  }

  /// Database에서 로드
  factory DreamEntry.fromMap(Map<String, dynamic> map) {
    return DreamEntry(
      id: map['id'] as String,
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      dreamDate: DateTime.parse(map['dreamDate'] as String),
      title: map['title'] as String? ?? '',
      content: map['content'] as String,
      lucidityLevel: map['lucidityLevel'] as int? ?? 0,
      wasLucid: (map['wasLucid'] as int? ?? 0) == 1,
      emotions: _parseStringList(map['emotions'] as String?),
      moodScore: map['moodScore'] as int?,
      symbols: _parseStringList(map['symbols'] as String?),
      characters: _parseStringList(map['characters'] as String?),
      locations: _parseStringList(map['locations'] as String?),
      sleepTime: map['sleepTime'] != null
          ? DateTime.parse(map['sleepTime'] as String)
          : null,
      wakeTime: map['wakeTime'] != null
          ? DateTime.parse(map['wakeTime'] as String)
          : null,
      sleepQuality: map['sleepQuality'] as int?,
      techniquesUsed: _parseStringList(map['techniquesUsed'] as String?),
      usedWbtb: (map['usedWbtb'] as int? ?? 0) == 1,
      aiAnalysisId: map['aiAnalysisId'] as String?,
      hasAiAnalysis: (map['hasAiAnalysis'] as int? ?? 0) == 1,
      tags: _parseStringList(map['tags'] as String?),
      isFavorite: (map['isFavorite'] as int? ?? 0) == 1,
      imageUrl: map['imageUrl'] as String?,
      voiceNoteUrl: map['voiceNoteUrl'] as String?,
      repeatPatternId: map['repeatPatternId'] as int?,
      isRecurring: (map['isRecurring'] as int? ?? 0) == 1,
    );
  }

  /// 쉼표로 구분된 문자열을 리스트로 변환
  static List<String> _parseStringList(String? str) {
    if (str == null || str.isEmpty) return [];
    return str.split(',').where((s) => s.isNotEmpty).toList();
  }

  /// JSON 변환 (Firebase/API용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'dreamDate': dreamDate.toIso8601String(),
      'title': title,
      'content': content,
      'lucidityLevel': lucidityLevel,
      'wasLucid': wasLucid,
      'emotions': emotions,
      'moodScore': moodScore,
      'symbols': symbols,
      'characters': characters,
      'locations': locations,
      'sleepTime': sleepTime?.toIso8601String(),
      'wakeTime': wakeTime?.toIso8601String(),
      'sleepQuality': sleepQuality,
      'techniquesUsed': techniquesUsed,
      'usedWbtb': usedWbtb,
      'aiAnalysisId': aiAnalysisId,
      'hasAiAnalysis': hasAiAnalysis,
      'tags': tags,
      'isFavorite': isFavorite,
      'imageUrl': imageUrl,
      'voiceNoteUrl': voiceNoteUrl,
      'repeatPatternId': repeatPatternId,
      'isRecurring': isRecurring,
    };
  }

  factory DreamEntry.fromJson(Map<String, dynamic> json) {
    return DreamEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      dreamDate: DateTime.parse(json['dreamDate'] as String),
      title: json['title'] as String? ?? '',
      content: json['content'] as String,
      lucidityLevel: json['lucidityLevel'] as int? ?? 0,
      wasLucid: json['wasLucid'] as bool? ?? false,
      emotions: (json['emotions'] as List?)?.cast<String>() ?? [],
      moodScore: json['moodScore'] as int?,
      symbols: (json['symbols'] as List?)?.cast<String>() ?? [],
      characters: (json['characters'] as List?)?.cast<String>() ?? [],
      locations: (json['locations'] as List?)?.cast<String>() ?? [],
      sleepTime: json['sleepTime'] != null
          ? DateTime.parse(json['sleepTime'] as String)
          : null,
      wakeTime: json['wakeTime'] != null
          ? DateTime.parse(json['wakeTime'] as String)
          : null,
      sleepQuality: json['sleepQuality'] as int?,
      techniquesUsed: (json['techniquesUsed'] as List?)?.cast<String>() ?? [],
      usedWbtb: json['usedWbtb'] as bool? ?? false,
      aiAnalysisId: json['aiAnalysisId'] as String?,
      hasAiAnalysis: json['hasAiAnalysis'] as bool? ?? false,
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      voiceNoteUrl: json['voiceNoteUrl'] as String?,
      repeatPatternId: json['repeatPatternId'] as int?,
      isRecurring: json['isRecurring'] as bool? ?? false,
    );
  }

  /// 꿈 내용 미리보기 (첫 100자)
  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  /// 꿈 일기 길이
  int get wordCount => content.split(RegExp(r'\s+')).length;

  /// 수면 시간 계산
  Duration? get sleepDuration {
    if (sleepTime == null || wakeTime == null) return null;
    return wakeTime!.difference(sleepTime!);
  }

  /// 자각도 레벨 텍스트
  String get lucidityLevelText {
    if (lucidityLevel == 0) return '일반 꿈';
    if (lucidityLevel <= 3) return '낮은 자각';
    if (lucidityLevel <= 6) return '중간 자각';
    if (lucidityLevel <= 8) return '높은 자각';
    return '완전 자각';
  }

  /// 날짜 표시 문자열 (YYYY-MM-DD)
  String get dateLabel {
    return '${dreamDate.year}-${dreamDate.month.toString().padLeft(2, '0')}-${dreamDate.day.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'DreamEntry(id: $id, date: $dateLabel, lucidity: $lucidityLevel, wasLucid: $wasLucid)';
  }
}
