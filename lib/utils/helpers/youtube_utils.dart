/// YouTube URL 관련 유틸리티 함수
class YoutubeUtils {
  /// YouTube Shorts URL을 일반 YouTube URL로 변환
  ///
  /// Shorts URL: https://youtube.com/shorts/VIDEO_ID
  /// 일반 URL: https://www.youtube.com/watch?v=VIDEO_ID
  static String convertShortsToRegularUrl(String url) {
    // 이미 일반 URL이면 그대로 반환
    if (url.contains('watch?v=')) {
      return url;
    }

    // Shorts URL 패턴 체크 및 변환
    final shortsPattern = RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]+)');
    final match = shortsPattern.firstMatch(url);

    if (match != null && match.groupCount >= 1) {
      final videoId = match.group(1);
      return 'https://www.youtube.com/watch?v=$videoId';
    }

    // 변환할 수 없으면 원래 URL 반환
    return url;
  }

  /// YouTube URL에서 비디오 ID 추출
  static String? extractVideoId(String url) {
    // watch?v= 형식
    var pattern = RegExp('[?&]v=([a-zA-Z0-9_-]+)');
    var match = pattern.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }

    // shorts/ 형식
    pattern = RegExp('shorts/([a-zA-Z0-9_-]+)');
    match = pattern.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }

    // youtu.be 짧은 URL 형식
    pattern = RegExp(r'youtu\.be/([a-zA-Z0-9_-]+)');
    match = pattern.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }

    return null;
  }
}
