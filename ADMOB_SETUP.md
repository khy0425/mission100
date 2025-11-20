# AdMob 설정 가이드

DreamFlow 앱에서 광고를 표시하려면 Google AdMob 계정이 필요합니다.

## 1. Google AdMob 계정 생성

1. [Google AdMob](https://admob.google.com/) 접속
2. Google 계정으로 로그인
3. 앱 등록 (Android)
   - 앱 이름: DreamFlow
   - 플랫폼: Android
   - 패키지 이름: `com.dreamflow.lucid_dream`

## 2. 광고 단위 ID 발급

### 필요한 광고 단위

1. **보상형 광고** (Rewarded Ad)
   - 용도: 토큰 보상 광고
   - 위치: `lib/services/monetization/ad_service.dart:47-49`

2. **전면 광고** (Interstitial Ad)
   - 용도: 화면 전환 시 표시
   - 위치: `lib/services/monetization/ad_service.dart:68-70`

## 3. 광고 ID 설정

### 파일 위치
`lib/services/monetization/ad_service.dart`

### 수정 방법

```dart
// 보상형 광고 ID
String _getRewardedAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-YOUR_PUB_ID/YOUR_REWARDED_AD_ID'; // ← 여기에 실제 ID 입력
  } else if (Platform.isIOS) {
    return 'ca-app-pub-YOUR_PUB_ID/YOUR_IOS_REWARDED_AD_ID';
  }
  return '';
}

// 전면 광고 ID
String _getInterstitialAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-YOUR_PUB_ID/YOUR_INTERSTITIAL_AD_ID'; // ← 여기에 실제 ID 입력
  } else if (Platform.isIOS) {
    return 'ca-app-pub-YOUR_PUB_ID/YOUR_IOS_INTERSTITIAL_AD_ID';
  }
  return '';
}
```

## 4. 테스트 광고 ID

개발/테스트 단계에서는 Google에서 제공하는 테스트 ID를 사용하세요:

```dart
// 보상형 테스트 광고 (Android)
ca-app-pub-3940256099942544/5224354917

// 전면 테스트 광고 (Android)
ca-app-pub-3940256099942544/1033173712
```

## 5. AndroidManifest.xml 설정

`android/app/src/main/AndroidManifest.xml`에 이미 설정되어 있어야 합니다:

```xml
<manifest>
    <application>
        <!-- AdMob App ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-YOUR_ADMOB_APP_ID~YOUR_APP_ID"/>
    </application>
</manifest>
```

## 6. 주의사항

⚠️ **중요:**
- 테스트 단계에서는 반드시 테스트 광고 ID를 사용하세요
- 실제 광고 ID로 직접 클릭하면 계정이 정지될 수 있습니다
- 앱을 출시하기 전에 반드시 실제 광고 ID로 변경하세요

## 7. 확인 방법

1. 앱 실행
2. "토큰 충전" 버튼 클릭
3. 광고 시청 후 토큰 지급 확인

## 참고 문서

- [AdMob 시작 가이드](https://developers.google.com/admob/android/quick-start)
- [광고 단위 생성](https://support.google.com/admob/answer/7356431)
- [테스트 광고 ID](https://developers.google.com/admob/android/test-ads)
