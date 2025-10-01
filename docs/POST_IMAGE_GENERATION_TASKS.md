# 🎨 Chad 이미지 생성 후 작업 계획

## 📋 현재 상황
- Chad 컨디션/활동 이미지 MidJourney 키워드 완성
- 우선순위: 수면차드 → 파워차드 → 비스트차드 → 땀차드 → 쿨차드 → 스트레칭차드 → 명상차드 → 산책차드

---

## 🚀 Phase 1: 이미지 생성 후 즉시 작업

### 1. 파일 처리 및 최적화
```bash
# 생성된 이미지들을 적절한 크기로 최적화
- 해상도: 1024x1024px → 512x512px (앱용)
- 파일 크기: < 500KB per image
- 형식: JPG (고품질 압축)
```

### 2. 디렉토리 구조 적용
```bash
# 새로운 디렉토리 구조로 이미지 배치
assets/images/chad/컨디션/
├── 수면차드.jpg
├── 파워차드.jpg
├── 비스트차드.jpg
├── 땀차드.jpg
└── 쿨차드.jpg

assets/images/chad/활동/
├── 스트레칭차드.jpg
├── 명상차드.jpg
└── 산책차드.jpg
```

### 3. 기존 기본차드.jpg 이동
```bash
# 현재 assets/images/기본차드.jpg를 새 구조로 이동
assets/images/chad/기본차드.jpg
```

---

## 🔧 Phase 2: 코드 업데이트

### 1. pubspec.yaml 수정
```yaml
flutter:
  assets:
    # 기존 개별 파일 선언 제거
    # - assets/images/기본차드.jpg

    # 새로운 폴더 구조 추가
    - assets/images/chad/
    - assets/images/chad/컨디션/
    - assets/images/chad/활동/
    - assets/images/chad/온보딩/
    - assets/images/chad/진화/
```

### 2. Chad 서비스 코드 업데이트

#### chad_condition_service.dart 수정
```dart
// 기존
return "assets/images/기본차드.jpg";

// 새로운 구조
String getChadImageForCondition() {
  switch (currentCondition) {
    case ChadCondition.veryTired:
      return "assets/images/chad/컨디션/수면차드.jpg";
    case ChadCondition.strong:
      return "assets/images/chad/컨디션/파워차드.jpg";
    case ChadCondition.onFire:
      return "assets/images/chad/컨디션/비스트차드.jpg";
    case ChadCondition.sweaty:
      return "assets/images/chad/컨디션/땀차드.jpg";
    case ChadCondition.good:
    default:
      return "assets/images/chad/기본차드.jpg";
  }
}
```

#### chad_recovery_service.dart 수정
```dart
String getChadImageForRecovery() {
  switch (_recoveryLevel) {
    case RecoveryLevel.excellent:
      return "assets/images/chad/컨디션/비스트차드.jpg"; // Beast Chad
    case RecoveryLevel.good:
      return "assets/images/chad/컨디션/쿨차드.jpg"; // Cool Chad
    case RecoveryLevel.poor:
      return "assets/images/chad/컨디션/수면차드.jpg"; // Rest Chad
    case RecoveryLevel.fair:
    default:
      return "assets/images/chad/기본차드.jpg"; // Normal Chad
  }
}
```

#### chad_active_recovery_service.dart 수정
```dart
String getChadImageForActivity(ActiveRecoveryType type) {
  switch (type) {
    case ActiveRecoveryType.stretching:
      return "assets/images/chad/활동/스트레칭차드.jpg";
    case ActiveRecoveryType.breathing:
    case ActiveRecoveryType.mindfulness:
      return "assets/images/chad/활동/명상차드.jpg";
    case ActiveRecoveryType.walking:
      return "assets/images/chad/활동/산책차드.jpg";
    case ActiveRecoveryType.rest:
      return "assets/images/chad/컨디션/수면차드.jpg";
    case ActiveRecoveryType.lightMovement:
    default:
      return "assets/images/chad/기본차드.jpg";
  }
}
```

### 3. apply_chad_mapping.dart 스크립트 업데이트
- 새로운 디렉토리 구조에 맞게 매핑 로직 수정
- 폴더별 이미지 확인 기능 추가

---

## 🧪 Phase 3: 테스트 및 검증

### 1. 이미지 로딩 테스트
```dart
// 새로운 테스트 코드 작성
void testChadImageLoading() {
  // 모든 Chad 이미지가 올바르게 로드되는지 확인
  // 404 에러 없는지 검증
  // 이미지 품질 적절한지 확인
}
```

### 2. 시각적 검증
- [ ] 각 컨디션별 Chad 이미지 적절성 확인
- [ ] 홈화면에서 이미지 전환 자연스러운지 확인
- [ ] 이미지 크기/품질 모바일에서 적절한지 확인

### 3. 성능 테스트
- [ ] 이미지 로딩 속도 측정
- [ ] 메모리 사용량 확인
- [ ] 앱 시작 시간에 영향 없는지 확인

---

## 🚀 Phase 4: 다음 단계 준비

### 1. 온보딩 Chad 이미지 제작 준비
```
우선순위 2: 온보딩 Chad 세트
- 환영차드.jpg (첫 만남)
- 완료차드.jpg (성취 축하)
- 목표차드.jpg (목표 설정)
```

### 2. 진화 Chad 이미지 제작 준비
```
우선순위 3: 진화 Chad 세트
- 성장차드.jpg (Stage 2)
- 마스터차드.jpg (Stage 5)
```

### 3. 운동 가이드 이미지 제작 준비
```
우선순위 4: 표준 푸시업 세트
- 3단계 정적 이미지
- 1개 GIF 애니메이션
- 1개 근육 자극 맵
```

---

## ⚠️ 주의사항

### 1. 파일 백업
- 기존 기본차드.jpg 백업 후 이동
- 변경 전 pubspec.yaml 백업

### 2. 점진적 적용
- 이미지 하나씩 교체하여 안정성 확인
- 각 단계별로 테스트 진행

### 3. 폴백 처리
```dart
// 이미지 로딩 실패 시 기본차드로 폴백
String getChadImage() {
  try {
    return getSpecificChadImage();
  } catch (e) {
    return "assets/images/chad/기본차드.jpg"; // 안전한 폴백
  }
}
```

---

## 📋 체크리스트

### 이미지 생성 완료 후 체크
- [ ] 모든 이미지 다운로드 및 최적화 완료
- [ ] 새 디렉토리 구조 생성
- [ ] 이미지 파일 올바른 위치에 배치
- [ ] pubspec.yaml 업데이트
- [ ] Chad 서비스 코드 수정
- [ ] 테스트 실행
- [ ] 시각적 검증 완료
- [ ] 성능 확인 완료

### 다음 단계 준비
- [ ] 온보딩 Chad 키워드 검토
- [ ] 운동 가이드 이미지 우선순위 확정
- [ ] MidJourney 크레딧 상황 확인

---

**💡 예상 소요 시간: 2-3시간 (이미지 생성 시간 제외)**
**🎯 완료 후 효과: Chad 시스템이 상황별로 완전히 개인화됨**