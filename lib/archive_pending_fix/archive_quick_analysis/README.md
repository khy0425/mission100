# Quick Analysis Feature - Archived

## Why Archived

빠른 꿈 분석 기능이 API 비용 절감을 위해 2025년에 제거되었습니다.

## Reason for Removal

- **문제점**: "빠른 분석"은 무료 기능이었지만, 실제로 OpenAI API를 호출하여 요청당 $0.0002의 비용이 발생했습니다.
- **비용 구조**: 사용자는 무료로 사용하지만, 개발자는 무제한으로 비용을 부담해야 하는 구조였습니다.
- **해결책**: 템플릿 기반 가짜 AI로 대체하는 것보다 기능을 완전히 제거하는 것이 사용자에게 더 정직한 방법이라고 판단했습니다.

## New Flow

이제 사용자는 홈 화면에서 AI 분석을 선택하면 직접 **Lumi 대화 화면**으로 이동합니다.
- Lumi 대화는 토큰 시스템을 사용합니다 (1 토큰 = 1 대화 시작)
- 무료 사용자: 체크리스트 완료 시 1 토큰
- 프리미엄 사용자: 체크리스트 완료 시 5 토큰
- 리워드 광고로도 토큰 획득 가능

## Archived Files

- `quick_analysis_screen.dart` - 빠른 분석 UI 화면
- `analysis_mode_selection_screen.dart` - 분석 모드 선택 화면 (빠른 분석 vs Lumi 대화)

## Related Changes

- `home_screen.dart`: `AnalysisModeSelectionScreen` → `LumiConversationScreen`으로 직접 이동
- `dream_analysis_service_secure.dart`: `quickAnalysis()` 메서드에 `@Deprecated` 추가
- `conversation_token.dart`: 무료 사용자 일일 토큰 3개 → 1개로 변경

## Business Model Validation

일회성 프리미엄 구매 ($9.99)로도 수익성 보장:
- 최악의 경우: 27.75년 손익분기점
- 현실적: 55년 손익분기점
- 결론: 적자 가능성 매우 낮음 (< 1%)

---

**Archived Date**: 2025-01-17
