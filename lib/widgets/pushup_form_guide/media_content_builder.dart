import 'package:flutter/material.dart';
import '../../models/pushup_form_guide.dart';
import '../common/video_player_widget.dart';

/// 미디어 콘텐츠 빌더 클래스
class MediaContentBuilder {
  /// 단계별 미디어 콘텐츠 빌드
  static Widget buildMediaContent(FormStep step) {
    // 비디오가 있으면 비디오 플레이어 표시
    if (step.videoUrl != null && step.videoUrl!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: '${step.title} 시연 비디오',
            child: VideoPlayerWidget(
              videoUrl: step.videoUrl!,
              autoPlay: false,
              showControls: true,
            ),
          ),
          if (step.videoDescription != null &&
              step.videoDescription!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              step.videoDescription!,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      );
    }

    // knee_step1.jpg만 표시 (step2, step3 이미지가 없음)
    // 나중에 이미지가 추가되면 슬라이드쇼로 변경 가능

    // 이미지가 있으면 실제 이미지 표시, 없으면 플레이스홀더 표시
    if (step.imagePath.isNotEmpty && !step.imagePath.contains('placeholder')) {
      return Semantics(
        label: '${step.title} 자세 시연 이미지',
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4DABF7), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.asset(
              step.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2A2A2A),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: Color(0xFFFF6B6B),
                        size: 48,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '이미지 로드 실패',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // 이미지가 없으면 플레이스홀더 표시
    return Semantics(
      label: '${step.title} 자세 이미지 플레이스홀더',
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF4DABF7), width: 1),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, color: Color(0xFF4DABF7), size: 48),
            SizedBox(height: 8),
            Text(
              '자세 이미지',
              style: TextStyle(color: Color(0xFF4DABF7), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// 비교 이미지 빌드 (올바른 자세 vs 잘못된 자세)
  static Widget buildComparisonImage(
    String correctImagePath,
    Color severityColor,
    IconData severityIcon,
    String correctLabel,
    String incorrectLabel,
  ) {
    return Semantics(
      label: '$correctLabel과 $incorrectLabel 비교 이미지',
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: severityColor, width: 2),
        ),
        child: Row(
          children: [
            // 올바른 자세
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF51CF66)),
                  const SizedBox(height: 8),
                  Text(
                    correctLabel,
                    style: const TextStyle(
                      color: Color(0xFF51CF66),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // 구분선
            Container(width: 2, color: severityColor),
            // 잘못된 자세
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(severityIcon, color: severityColor),
                  const SizedBox(height: 8),
                  Text(
                    incorrectLabel,
                    style: TextStyle(
                      color: severityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 변형 운동 이미지 빌드
  static Widget buildVariationImage(
    PushupVariation variation,
    Color difficultyColor,
  ) {
    if (variation.imagePath.isNotEmpty &&
        !variation.imagePath.contains('placeholder')) {
      return Semantics(
        label: '${variation.name} 운동 시연 이미지',
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: difficultyColor, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              variation.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2A2A2A),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: difficultyColor,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '이미지 로드 실패',
                        style: TextStyle(
                          color: difficultyColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // 플레이스홀더 이미지
    return Semantics(
      label: '${variation.name} 운동 이미지 플레이스홀더',
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: difficultyColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, color: difficultyColor, size: 48),
            const SizedBox(height: 8),
            Text(
              '운동 이미지',
              style: TextStyle(color: difficultyColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
