/// 운동 영상 모델
///
/// 각 운동별 다국어 비디오 URL을 관리합니다.
/// 디바이스 로케일에 따라 적절한 언어의 영상을 자동으로 선택합니다.
class ExerciseVideo {
  /// 운동 ID (예: 'standard_pushup', 'knee_pushup')
  final String exerciseId;

  /// 언어별 비디오 URL 맵
  /// - 'ko': 한국어 영상
  /// - 'en': 영어 영상
  final Map<String, String> videoUrls;

  const ExerciseVideo({
    required this.exerciseId,
    required this.videoUrls,
  });

  /// 디바이스 로케일에 맞는 비디오 URL 반환
  ///
  /// Fallback 우선순위:
  /// 1. 사용자 언어 (ko 또는 en)
  /// 2. 영어 (기본)
  /// 3. 한국어 (영어가 없을 경우)
  /// 4. 첫 번째 URL (모두 없을 경우)
  String getVideoUrl(String languageCode) {
    // 1순위: 사용자 언어
    if (videoUrls.containsKey(languageCode)) {
      return videoUrls[languageCode]!;
    }

    // 2순위: 영어 (기본 fallback)
    if (videoUrls.containsKey('en')) {
      return videoUrls['en']!;
    }

    // 3순위: 한국어 (영어도 없을 경우)
    if (videoUrls.containsKey('ko')) {
      return videoUrls['ko']!;
    }

    // 4순위: 첫 번째 URL
    return videoUrls.values.first;
  }

  /// 사용 가능한 언어 코드 목록
  List<String> get availableLanguages => videoUrls.keys.toList();

  /// 특정 언어의 영상이 있는지 확인
  bool hasLanguage(String languageCode) => videoUrls.containsKey(languageCode);
}
