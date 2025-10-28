# 📱 Mission100 앱 아이콘 위치

**날짜**: 2025-10-20

---

## ✅ 기존 아이콘 사용

기존에 이미 멋진 Chad 아이콘이 있습니다!

### 현재 아이콘

**디자인**: 금색 배경에 검은색 썬글라스 Chad 실루엣

**위치**:
```
E:\Projects\mission100_v3\android\app\src\main\res\
├── mipmap-mdpi\launcher_icon.png (48×48)
├── mipmap-hdpi\launcher_icon.png (72×72)
├── mipmap-xhdpi\launcher_icon.png (96×96)
├── mipmap-xxhdpi\launcher_icon.png (144×144)
└── mipmap-xxxhdpi\launcher_icon.png (192×192) ← 가장 큰 파일
```

---

## 📋 앱 스토어 제출용 1024×1024 필요

### 옵션 1: xxxhdpi 이미지 업스케일 (추천!)

**현재 파일**:
```
E:\Projects\mission100_v3\android\app\src\main\res\mipmap-xxxhdpi\launcher_icon.png
```

**크기**: 192×192px

**해결 방법**:
1. 192×192 이미지를 1024×1024로 업스케일
2. 온라인 도구 사용: https://www.simpleimageresizer.com/
3. 또는 Photoshop/GIMP 사용

**저장 위치**:
```
E:\Projects\mission100_v3\assets\icons\app_icon_1024.png
```

---

### 옵션 2: 원본 재생성 (복잡)

원본 파일(`assets/icon/misson100_icon.png`)이 삭제되어 재생성 필요

**pubspec.yaml 설정**:
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/misson100_icon.png"  # ← 이 파일 없음!
```

**재생성 방법**:
1. 1024×1024 Chad 아이콘 새로 만들기
2. `assets/icon/` 폴더 생성
3. `misson100_icon.png` 저장
4. `flutter pub run flutter_launcher_icons:main` 실행

---

## 🎯 추천 작업 순서

### Step 1: xxxhdpi 이미지 확인 (완료!)
- ✅ 위치: `android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png`
- ✅ 크기: 192×192px
- ✅ 디자인: 금색 배경 + 썬글라스 Chad

### Step 2: 1024×1024로 업스케일

**방법 A: 온라인 도구 (가장 쉬움)**
1. https://www.simpleimageresizer.com/ 또는 https://imageresizer.com/ 접속
2. `launcher_icon.png` 업로드
3. 1024×1024로 리사이즈
4. 저장

**방법 B: Windows Paint (간단)**
1. `launcher_icon.png` 파일 우클릭 → 편집
2. 크기 조정 → 1024×1024 픽셀
3. 다른 이름으로 저장

**방법 C: ImageMagick (커맨드라인)**
```bash
magick convert launcher_icon.png -resize 1024x1024 app_icon_1024.png
```

### Step 3: 저장
```
E:\Projects\mission100_v3\assets\icons\app_icon_1024.png
```

---

## ✅ 완료 체크리스트

- [x] 기존 아이콘 위치 확인
- [ ] 1024×1024 업스케일
- [ ] assets/icons/ 폴더 생성
- [ ] app_icon_1024.png 저장
- [ ] Apple App Store에 업로드
- [ ] Google Play Store에 업로드

---

## 📝 참고

### iOS 아이콘
위치: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- 이미 `flutter_launcher_icons`로 생성되어 있음

### Android 아이콘
위치: `android/app/src/main/res/mipmap-*/launcher_icon.png`
- 이미 모든 해상도 생성되어 있음

### 1024×1024만 추가로 필요
- Apple App Store 제출 시 필수
- Google Play Store 제출 시 필수

---

**다음 단계**: xxxhdpi 파일을 1024×1024로 업스케일하고 `assets/icons/app_icon_1024.png`로 저장!
