import '../models/exercise_video.dart';

/// 푸쉬업 운동별 비디오 데이터
///
/// 각 운동마다 한국어(ko)와 영어(en) 비디오 URL을 제공합니다.
/// 일부 비디오는 YouTube Shorts가 아닌 일반 YouTube 링크이지만,
/// 모두 짧은 길이의 튜토리얼 영상입니다.
final Map<String, ExerciseVideo> pushupVideos = {
  // 🔵 Standard
  'standard_pushup': const ExerciseVideo(
    exerciseId: 'standard_pushup',
    videoUrls: {
      'ko': 'https://youtube.com/shorts/qeK3LrNRN2o?si=UpDjiIEcGBMZdRIw',
      'en': 'https://youtube.com/shorts/4Bc1tPaYkOo?si=9kRAT-0liXtl5NwB',
    },
  ),

  // 🟢 Beginner - Knee Pushup
  'knee_pushup': const ExerciseVideo(
    exerciseId: 'knee_pushup',
    videoUrls: {
      'ko': 'https://youtube.com/shorts/S9_wN5w6J_s?si=kal2op6plWLIbrkq',
      'en': 'https://youtube.com/shorts/rrVwNeIpy-k?si=cO-m0ffZbhB9GvsD',
    },
  ),

  // 🟢 Beginner - Wall Pushup
  'wall_pushup': const ExerciseVideo(
    exerciseId: 'wall_pushup',
    videoUrls: {
      'ko': 'https://youtube.com/shorts/-TMXETQfnRU?si=34PrLV6V1yo4GJQH',
      'en': 'https://youtube.com/shorts/-TMXETQfnRU?si=34PrLV6V1yo4GJQH',
    },
  ),

  // 🟢 Beginner - Incline Pushup
  'incline_pushup': const ExerciseVideo(
    exerciseId: 'incline_pushup',
    videoUrls: {
      'ko': 'https://youtube.com/shorts/DORUKQ3zLIo?si=WrLVks7iCQLkyU2X',
      'en': 'https://youtube.com/shorts/DORUKQ3zLIo?si=4hG1sHddRmmMSwa7',
    },
  ),

  // 🟡 Intermediate - Wide Pushup
  'wide_pushup': const ExerciseVideo(
    exerciseId: 'wide_pushup',
    videoUrls: {
      // 한국어는 쇼츠가 아닌 일반 영상 (짧은 튜토리얼)
      'ko': 'https://youtu.be/cmHZnB2QfFI?si=Vze3fmJ6qPGRIqTI',
      'en': 'https://youtube.com/shorts/5VcUrU_Yn9A?si=IgzgCeT9oioi_04d',
    },
  ),

  // 🟡 Intermediate - Diamond Pushup
  'diamond_pushup': const ExerciseVideo(
    exerciseId: 'diamond_pushup',
    videoUrls: {
      'ko': 'https://youtube.com/shorts/PPTj-MW2tcs?si=N1Ov2pDR8ewiPoSB',
      'en': 'https://youtube.com/shorts/PPTj-MW2tcs?si=N1Ov2pDR8ewiPoSB',
    },
  ),

  // 🟡 Intermediate - Decline Pushup
  'decline_pushup': const ExerciseVideo(
    exerciseId: 'decline_pushup',
    videoUrls: {
      // 한국어는 쇼츠가 아닌 일반 영상 (타임스탬프 포함)
      'ko': 'https://youtu.be/AeDw1tlXczo?si=lu78SdsLr9Ba4ON7&t=9',
      'en': 'https://youtube.com/shorts/dcV-ATSeryA?si=PtPULllWHi0uNAzA',
    },
  ),

  // 🔴 Advanced - One Arm Pushup
  'one_arm_pushup': const ExerciseVideo(
    exerciseId: 'one_arm_pushup',
    videoUrls: {
      'ko': 'https://youtube.com/shorts/bh9PsSfGZ2o?si=HUeiRVtZmyE8v2Uh',
      'en': 'https://youtube.com/shorts/bh9PsSfGZ2o?si=HUeiRVtZmyE8v2Uh',
    },
  ),

  // 🔴 Advanced - Plyometric Pushup
  'plyometric_pushup': const ExerciseVideo(
    exerciseId: 'plyometric_pushup',
    videoUrls: {
      // 한국어는 쇼츠가 아닌 일반 영상 (타임스탬프 포함)
      'ko': 'https://youtu.be/ql3CC2kjZl8?si=uT0Q5CTT71_xTp41&t=3',
      'en': 'https://youtube.com/shorts/oTfU-qt6cGc?si=AiQV8pcY06Z2wQmh',
    },
  ),

  // 🔴 Advanced - Archer Pushup
  'archer_pushup': const ExerciseVideo(
    exerciseId: 'archer_pushup',
    videoUrls: {
      'ko': 'https://youtube.com/shorts/mzr0RYNDzzI?si=UOQVoccGw5osoV1J',
      'en': 'https://youtube.com/shorts/mzr0RYNDzzI?si=UOQVoccGw5osoV1J',
    },
  ),
};

/// 특정 운동의 비디오를 가져옵니다.
///
/// [exerciseId]가 존재하지 않으면 null을 반환합니다.
ExerciseVideo? getExerciseVideo(String exerciseId) {
  return pushupVideos[exerciseId];
}

/// 모든 푸쉬업 비디오 목록을 반환합니다.
List<ExerciseVideo> getAllPushupVideos() {
  return pushupVideos.values.toList();
}

/// 난이도별 푸쉬업 비디오 목록을 반환합니다.
Map<String, List<String>> getPushupVideosByDifficulty() {
  return {
    'standard': ['standard_pushup'],
    'beginner': ['knee_pushup', 'wall_pushup', 'incline_pushup'],
    'intermediate': ['wide_pushup', 'diamond_pushup', 'decline_pushup'],
    'advanced': ['one_arm_pushup', 'plyometric_pushup', 'archer_pushup'],
  };
}
