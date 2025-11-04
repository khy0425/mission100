import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/exercise_video.dart';

/// 운동 영상을 외부 앱(YouTube)에서 재생하는 버튼 위젯
///
/// 디바이스 로케일에 따라 자동으로 적절한 언어의 영상을 선택합니다.
/// - 한국어 설정: 한국어 영상 재생
/// - 영어 설정: 영어 영상 재생
/// - 기타 언어: 영어 영상 재생 (fallback)
class ExerciseVideoButton extends StatelessWidget {
  /// 재생할 운동 영상 정보
  final ExerciseVideo video;

  /// 버튼 스타일 커스터마이징 (선택사항)
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final IconData? icon;

  const ExerciseVideoButton({
    super.key,
    required this.video,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // 디바이스 로케일 감지
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode; // 'ko', 'en' 등

    // 해당 언어의 비디오 URL 가져오기
    final videoUrl = video.getVideoUrl(languageCode);

    return ElevatedButton.icon(
      icon: Icon(
        icon ?? Icons.play_circle_outline,
        size: 28,
      ),
      label: Text(
        _getButtonText(context),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => _launchVideo(context, videoUrl),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, height ?? 56),
        backgroundColor: backgroundColor ?? Colors.red,
        foregroundColor: foregroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }

  /// 로케일에 따른 버튼 텍스트 반환
  String _getButtonText(BuildContext context) {
    return AppLocalizations.of(context).watchVideo;
  }

  /// YouTube 영상 실행
  ///
  /// 외부 YouTube 앱으로 영상을 엽니다.
  /// 실패 시 사용자에게 에러 메시지를 표시합니다.
  Future<void> _launchVideo(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    try {
      final canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // YouTube 앱으로 열기
        );
      } else {
        if (context.mounted) {
          _showErrorSnackbar(context, 'Cannot open video URL');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackbar(context, 'Failed to launch video: $e');
      }
    }
  }

  /// 에러 스낵바 표시
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
