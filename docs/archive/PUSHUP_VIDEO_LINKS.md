# 푸쉬업 운동 유튜브 쇼츠 링크 (MVP)

각 운동별 유튜브 쇼츠 링크 - 빠른 출시용!

---

## ✅ 링크 체크리스트 - 한국어/영어 (app_ko.arb / app_en.arb)

각 운동별로 **한국어**, **영어** 쇼츠를 준비합니다.
Flutter에서 디바이스 로케일(ko/en)을 감지해서 자동으로 적절한 언어 영상을 보여줍니다!

### 🔵 Standard (1개)

#### **standard_pushup**
- [ ] 🇰🇷 **한국어**: `스탠다드 푸쉬업 쇼츠` 또는 `완벽한 푸쉬업 자세`
  - URL: `https://youtube.com/shorts/qeK3LrNRN2o?si=UpDjiIEcGBMZdRIw`
- [ ] 🇺🇸 **English**: 
  - URL: `https://youtube.com/shorts/4Bc1tPaYkOo?si=9kRAT-0liXtl5NwB`

---

### 🟢 Beginner (3개)

#### **knee_pushup**
- [ ] 🇰🇷 **한국어**: `무릎 푸쉬업 초보자`
  - URL: `https://youtube.com/shorts/S9_wN5w6J_s?si=kal2op6plWLIbrkq`
- [ ] 🇺🇸 **English**: `knee push up beginner shorts`
  - URL: `https://youtube.com/shorts/rrVwNeIpy-k?si=cO-m0ffZbhB9GvsD`

#### **wall_pushup**
- [ ] 🇰🇷 **한국어**: `벽 푸쉬업 쇼츠`
  - URL: `https://youtube.com/shorts/-TMXETQfnRU?si=34PrLV6V1yo4GJQH`
- [ ] 🇺🇸 **English**: `wall push up tutorial shorts`
  - URL: `https://youtube.com/shorts/-TMXETQfnRU?si=34PrLV6V1yo4GJQH`

#### **incline_pushup**
- [x] 🇰🇷 **한국어**: `https://youtube.com/shorts/DORUKQ3zLIo?si=WrLVks7iCQLkyU2X`
- [ ] 🇺🇸 **English**: `incline push up shorts`
  - URL: `https://youtube.com/shorts/DORUKQ3zLIo?si=4hG1sHddRmmMSwa7`

---

### 🟡 Intermediate (3개)

#### **wide_pushup**
- [ ] 🇰🇷 **한국어**: `와이드 푸쉬업 가슴 운동`
  - URL: `https://youtu.be/cmHZnB2QfFI?si=Vze3fmJ6qPGRIqTI` //쇼츠가 아님
- [ ] 🇺🇸 **English**: `wide push up chest shorts`
  - URL: `https://youtube.com/shorts/5VcUrU_Yn9A?si=IgzgCeT9oioi_04d`

#### **diamond_pushup**
- [ ] 🇰🇷 **한국어**: `다이아몬드 푸쉬업 삼두근`
  - URL: `https://youtube.com/shorts/PPTj-MW2tcs?si=N1Ov2pDR8ewiPoSB`
- [ ] 🇺🇸 **English**: `diamond push up triceps shorts`
  - URL: `https://youtube.com/shorts/PPTj-MW2tcs?si=N1Ov2pDR8ewiPoSB`

#### **decline_pushup**
- [ ] 🇰🇷 **한국어**: `디클라인 푸쉬업 쇼츠`
  - URL: `https://youtu.be/AeDw1tlXczo?si=lu78SdsLr9Ba4ON7&t=9` //쇼츠가 아님
- [ ] 🇺🇸 **English**: `decline push up shorts`
  - URL: `https://youtube.com/shorts/dcV-ATSeryA?si=PtPULllWHi0uNAzA`

---

### 🔴 Advanced (3개)

#### **one_arm_pushup**
- [ ] 🇰🇷 **한국어**: `원암 푸쉬업 고급`
  - URL: `https://youtube.com/shorts/bh9PsSfGZ2o?si=HUeiRVtZmyE8v2Uh`
- [ ] 🇺🇸 **English**: `one arm push up tutorial shorts`
  - URL: `https://youtube.com/shorts/bh9PsSfGZ2o?si=HUeiRVtZmyE8v2Uh`

#### **plyometric_pushup**
- [ ] 🇰🇷 **한국어**: `플라이오메트릭 푸쉬업 폭발적`
  - URL: `https://youtu.be/ql3CC2kjZl8?si=uT0Q5CTT71_xTp41&t=3` //쇼츠가 아님
- [ ] 🇺🇸 **English**: `plyometric push up explosive shorts`
  - URL: `https://youtube.com/shorts/oTfU-qt6cGc?si=AiQV8pcY06Z2wQmh`

#### **archer_pushup**
- [ ] 🇰🇷 **한국어**: `아처 푸쉬업 쇼츠`
  - URL: `https://youtube.com/shorts/mzr0RYNDzzI?si=UOQVoccGw5osoV1J`
- [ ] 🇺🇸 **English**: `archer push up tutorial shorts`
  - URL: `https://youtube.com/shorts/mzr0RYNDzzI?si=UOQVoccGw5osoV1J`

---

## 🔍 빠른 검색 팁

### YouTube에서 검색하는 방법:
1. YouTube 앱/웹 열기
2. 위 검색 키워드 복사해서 검색
3. 필터: `Shorts` 선택
4. 짧고(60초 이하) 정확한 자세 설명하는 영상 선택
5. `공유` → `링크 복사`
6. 위 체크리스트에 붙여넣기

### 좋은 영상 선택 기준:
- 길이: 30-90초 (너무 길지 않게)
- 자막: 한국어 또는 영어
- 화질: 선명한 측면 각도
- 내용: 올바른 자세 + 주의사항 포함

---

## 📱 Flutter 구현 방법 - 다국어 자동 감지

### 1단계: 운동 비디오 데이터 모델

```dart
// lib/models/exercise_video.dart
class ExerciseVideo {
  final String exerciseId;
  final Map<String, String> videoUrls; // 언어별 URL

  ExerciseVideo({
    required this.exerciseId,
    required this.videoUrls,
  });

  // 디바이스 로케일에 맞는 URL 반환
  String getVideoUrl(String languageCode) {
    // 1순위: 사용자 언어 (ko 또는 en)
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
}
```

### 2단계: 운동 비디오 데이터 (예시)

```dart
// lib/data/pushup_videos.dart
final Map<String, ExerciseVideo> pushupVideos = {
  'standard_pushup': ExerciseVideo(
    exerciseId: 'standard_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
  'incline_pushup': ExerciseVideo(
    exerciseId: 'incline_pushup',
    videoUrls: {
      'ko': 'https://youtube.com/shorts/DORUKQ3zLIo?si=WrLVks7iCQLkyU2X',
      'en': '[English shorts URL]',
    },
  ),
  'knee_pushup': ExerciseVideo(
    exerciseId: 'knee_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
  'wall_pushup': ExerciseVideo(
    exerciseId: 'wall_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
  'wide_pushup': ExerciseVideo(
    exerciseId: 'wide_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
  'diamond_pushup': ExerciseVideo(
    exerciseId: 'diamond_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
  'decline_pushup': ExerciseVideo(
    exerciseId: 'decline_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
  'one_arm_pushup': ExerciseVideo(
    exerciseId: 'one_arm_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
  'plyometric_pushup': ExerciseVideo(
    exerciseId: 'plyometric_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
  'archer_pushup': ExerciseVideo(
    exerciseId: 'archer_pushup',
    videoUrls: {
      'ko': '[한국어 쇼츠 URL]',
      'en': '[English shorts URL]',
    },
  ),
};
```

### 3단계: UI 위젯 구현

```dart
// lib/widgets/exercise_video_button.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseVideoButton extends StatelessWidget {
  final ExerciseVideo video;

  const ExerciseVideoButton({required this.video});

  @override
  Widget build(BuildContext context) {
    // 디바이스 로케일 감지
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode; // 'ko', 'en', 'ja' 등

    // 해당 언어의 비디오 URL 가져오기
    final videoUrl = video.getVideoUrl(languageCode);

    return ElevatedButton.icon(
      icon: Icon(Icons.play_circle_outline, size: 28),
      label: Text(
        _getButtonText(languageCode),
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () => _launchVideo(context, videoUrl),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 56),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }

  String _getButtonText(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return '운동 영상 보기 🇰🇷';
      default:
        return 'Watch Video 🇺🇸';
    }
  }

  Future<void> _launchVideo(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // YouTube 앱으로 열기
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('영상을 열 수 없습니다')),
      );
    }
  }
}
```

### 4단계: 화면에서 사용하기

```dart
// lib/screens/exercise_detail_screen.dart
import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    final video = pushupVideos[exerciseId]!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text('운동 설명')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 로케일 정보 표시 (디버깅용)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Current Locale: ${locale.languageCode}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // 비디오 버튼
            ExerciseVideoButton(video: video),

            SizedBox(height: 24),

            // 나머지 운동 설명...
            // (PUSHUP_EXERCISE_GUIDE.md의 내용 사용)
          ],
        ),
      ),
    );
  }
}
```

### 5단계: pubspec.yaml 설정

```yaml
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.2.0

# 다국어 지원 설정
flutter:
  generate: true # flutter_localizations 사용시
```

---

## 🌍 지원 언어별 동작

| 디바이스 설정 | 표시되는 영상 | 버튼 텍스트 |
|--------------|--------------|-------------|
| 🇰🇷 한국어 (ko) | 한국어 쇼츠 | "운동 영상 보기 🇰🇷" |
| 🇺🇸 English (en) | English Shorts | "Watch Video 🇺🇸" |
| 🇯🇵 日本語 | English Shorts (fallback) | "Watch Video 🇺🇸" |
| 🇨🇳 中文 | English Shorts (fallback) | "Watch Video 🇺🇸" |
| 🇫🇷 Français | English Shorts (fallback) | "Watch Video 🇺🇸" |
| 기타 모든 언어 | English Shorts (fallback) | "Watch Video 🇺🇸" |

---

## 🚀 MVP 장점

### 1. 글로벌 사용자 경험
- 각 나라 사용자에게 자국어 영상 자동 제공
- 언어 장벽 없이 정확한 운동 자세 학습

### 2. 빠른 구현
- YouTube 링크만 준비하면 끝
- 자체 비디오 호스팅 불필요 (비용 절감)

### 3. 검증 후 업그레이드
- Phase 1 (지금): 외부 YouTube 링크
- Phase 2 (리텐션 확인 후): 자체 제작 영상
- Phase 3 (스케일업 후): AR/3D 가이드

---

## 🎬 추천 유튜브 채널

### 1. Calisthenicmovement (영어, 고품질)
- 정확한 자세 설명
- 깔끔한 영상
- https://www.youtube.com/@Calisthenicmovement

### 2. 핏블리 FITFULLY (한국어)
- 한국어 설명
- 초보자 친화적
- https://www.youtube.com/@FITFULLY

### 3. ATHLEAN-X (영어, 전문적)
- 의학적 설명
- 잘못된 자세 교정
- https://www.youtube.com/@athleanx

---

## 📋 운동별 추천 영상 (예시)

### 1. 스탠다드 푸쉬업
```
제목: Perfect Push-up Form
채널: Calisthenicmovement
길이: 60초 (쇼츠)
URL: https://youtube.com/shorts/[ID]
```

### 2. 무릎 푸쉬업
```
제목: Knee Push-ups for Beginners
채널: FITFULLY
길이: 45초
URL: https://youtube.com/shorts/[ID]
```

### 3. 다이아몬드 푸쉬업
```
제목: Diamond Push-up Tutorial
채널: ATHLEAN-X
길이: 90초
URL: https://youtube.com/shorts/[ID]
```

---

## 💡 Flutter 코드 예시 (MVP)

### exercise_detail_screen.dart
```dart
class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseName;
  final String videoUrl;
  final String description;
  final List<String> steps;
  final String breathing;
  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎬 영상 버튼 (외부 링크)
            ElevatedButton.icon(
              icon: Icon(Icons.play_circle_outline),
              label: Text('운동 영상 보기'),
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(videoUrl))) {
                  await launchUrl(
                    Uri.parse(videoUrl),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),

            SizedBox(height: 24),

            // 📍 시작 자세
            _buildSection(
              '시작 자세',
              Icons.accessibility_new,
              description,
            ),

            SizedBox(height: 16),

            // 🔄 동작 단계
            _buildSection(
              '동작',
              Icons.fitness_center,
              steps.join('\n'),
            ),

            SizedBox(height: 16),

            // 💨 호흡법
            _buildSection(
              '호흡법',
              Icons.air,
              breathing,
            ),

            SizedBox(height: 16),

            // ⚠️ 주의사항
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          '주의사항',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ...warnings.map((w) => Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(w),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, String content) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
```

### pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.2.0  # 외부 링크용
  # youtube_player_flutter: ^8.1.2  # 나중에 임베드하려면
```

---

## 🎯 MVP 구현 단계 (30분 완료)

### 1단계: 유튜브에서 영상 찾기 (10분)
- 각 운동별 1개씩 쇼츠 찾기
- URL 복사

### 2단계: Flutter 코드 작성 (15분)
- `url_launcher` 패키지 추가
- 버튼에 링크 연결
- 텍스트 설명 추가 (이미 완료!)

### 3단계: 테스트 (5분)
- 앱 실행
- 버튼 클릭 → 유튜브 열림 확인

---

## 📈 나중에 업그레이드 (리텐션 좋으면)

### Phase 1: MVP (지금)
```dart
// 외부 유튜브 링크
ElevatedButton(
  onPressed: () => launchUrl(...),
  child: Text('영상 보기'),
)
```

### Phase 2: 업그레이드 (나중에)
```dart
// 앱 내 유튜브 재생
YoutubePlayer(...)
```

### Phase 3: 프리미엄 (많이 나중에)
```dart
// 자체 제작 영상/GIF
Image.asset('custom_animation.gif')
```

---

## 💰 비용 비교

| 방법 | 시간 | 비용 | 품질 |
|------|------|------|------|
| **MVP (유튜브 링크)** | 30분 | 무료 | 충분 |
| 미드저니 에셋 | 수 시간 | $30/월 | 불확실 |
| 전문 영상 제작 | 수 주 | 수백만원 | 최고 |

---

## ✅ 즉시 실행 가능한 TODO

1. [ ] 유튜브에서 10개 운동 영상 찾기 (10분)
2. [ ] URL 리스트 만들기
3. [ ] Flutter 코드 수정 (15분)
4. [ ] 테스트
5. [ ] 출시! 🚀

도와드릴까요? 유튜브 영상 검색해서 링크 모아드릴 수 있습니다!
