import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/exercise_video.dart';
import '../../utils/helpers/youtube_utils.dart';

/// 앱 내부에서 YouTube 비디오를 재생하는 위젯
class YoutubePlayerInlineWidget extends StatefulWidget {
  final ExerciseVideo video;
  final bool autoPlay;
  final bool showControls;
  final String? title;
  final String? description;

  const YoutubePlayerInlineWidget({
    super.key,
    required this.video,
    this.autoPlay = false,
    this.showControls = true,
    this.title,
    this.description,
  });

  @override
  State<YoutubePlayerInlineWidget> createState() =>
      _YoutubePlayerInlineWidgetState();
}

class _YoutubePlayerInlineWidgetState extends State<YoutubePlayerInlineWidget> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      // 현재 로케일에 맞는 비디오 URL 가져오기
      final locale = View.of(context).platformDispatcher.locale.languageCode;
      final videoUrl = widget.video.getVideoUrl(locale);

      // Shorts URL을 일반 URL로 변환
      final convertedUrl = YoutubeUtils.convertShortsToRegularUrl(videoUrl);

      // 비디오 ID 추출
      final videoId = YoutubeUtils.extractVideoId(convertedUrl);

      if (videoId == null) {
        setState(() {
          _errorMessage = 'Invalid YouTube URL';
        });
        return;
      }

      // YouTube 플레이어 컨트롤러 초기화
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: widget.autoPlay,
          mute: false,
          enableCaption: true,
          controlsVisibleAtStart: widget.showControls,
          hideThumbnail: false,
          forceHD: false,
        ),
      )..addListener(_listener);

      debugPrint('YouTube Player initialized for video: $videoId');
    } catch (e) {
      debugPrint('Error initializing YouTube player: $e');
      setState(() {
        _errorMessage = 'Failed to load video: $e';
      });
    }
  }

  void _listener() {
    if (_isPlayerReady && mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        // 전체 화면 진입 시 처리
        debugPrint('Entered fullscreen mode');
      },
      onExitFullScreen: () {
        // 전체 화면 종료 시 처리
        debugPrint('Exited fullscreen mode');
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: const Color(0xFF4DABF7),
        onReady: () {
          debugPrint('YouTube player ready');
          setState(() {
            _isPlayerReady = true;
          });
        },
        onEnded: (metadata) {
          debugPrint('Video ended');
          // 비디오 종료 시 처리 (필요시)
        },
      ),
      builder: (context, player) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // YouTube 플레이어
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: player,
            ),

            const SizedBox(height: 12),

            // 비디오 정보
            if (widget.title != null && widget.title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.title!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

            if (widget.description != null && widget.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
