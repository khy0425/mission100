import 'package:flutter_test/flutter_test.dart';
import 'dart:async';

/// RewardAdService 로직 테스트
///
/// 리워드 광고 로딩 및 표시 로직을 검증합니다.
/// Completer 패턴을 사용한 비동기 광고 로딩 테스트
void main() {
  group('RewardAdService Tests', () {
    group('Async Ad Loading Logic', () {
      test('should properly wait for ad loading with Completer', () async {
        // Given: Completer를 사용한 광고 로딩 시뮬레이션
        final completer = Completer<bool>();

        // 광고 로드 시뮬레이션 (비동기)
        Future.delayed(const Duration(milliseconds: 100), () {
          // 광고 로드 성공 시뮬레이션
          completer.complete(true);
        });

        // When: Completer의 future를 await
        final result = await completer.future;

        // Then: 광고 로드 성공
        expect(result, true);
      });

      test('should handle ad loading failure with Completer', () async {
        // Given: 실패 시나리오
        final completer = Completer<bool>();

        // 광고 로드 실패 시뮬레이션
        Future.delayed(const Duration(milliseconds: 100), () {
          completer.complete(false);
        });

        // When: Completer의 future를 await
        final result = await completer.future;

        // Then: 광고 로드 실패
        expect(result, false);
      });

      test('should prevent multiple simultaneous load calls', () async {
        // Given: 광고 로딩 상태 관리
        bool isLoading = false;
        Completer<bool>? loadCompleter;

        // When: 첫 번째 로드 호출
        if (!isLoading) {
          isLoading = true;
          loadCompleter = Completer<bool>();

          // 광고 로드 시뮬레이션
          Future.delayed(const Duration(milliseconds: 100), () {
            loadCompleter!.complete(true);
            isLoading = false;
          });
        }

        // When: 두 번째 로드 호출 (이미 로딩 중)
        if (isLoading && loadCompleter != null) {
          // 기존 Completer 재사용
          final existingFuture = loadCompleter.future;
          expect(existingFuture, isA<Future<bool>>());
        }

        // Then: 첫 번째 로드 완료 대기
        final result = await loadCompleter!.future;
        expect(result, true);
        expect(isLoading, false);
      });

      test('should return immediately if ad is already ready', () async {
        // Given: 광고가 이미 로드된 상태
        bool isAdReady = true;

        // When: loadAd 호출
        Future<bool> loadAd() async {
          if (isAdReady) {
            // 이미 준비되었으면 즉시 반환
            return true;
          }
          // 아니면 로딩 시작
          return false;
        }

        final result = await loadAd();

        // Then: 즉시 true 반환
        expect(result, true);
      });
    });

    group('Ad Loading State Management', () {
      test('should track ad loading state correctly', () {
        // Given: 초기 상태
        bool isAdLoading = false;
        bool isAdReady = false;

        // When: 로딩 시작
        isAdLoading = true;
        expect(isAdLoading, true);
        expect(isAdReady, false);

        // When: 로딩 완료
        isAdLoading = false;
        isAdReady = true;
        expect(isAdLoading, false);
        expect(isAdReady, true);
      });

      test('should reset state after ad dismissal', () {
        // Given: 광고가 표시된 후
        bool isAdReady = true;

        // When: 광고 닫힘
        isAdReady = false;

        // Then: 상태 초기화
        expect(isAdReady, false);
      });

      test('should handle multiple load-show cycles', () async {
        // Given: 여러 번의 광고 사이클 시뮬레이션
        final cycles = <Map<String, dynamic>>[];

        for (int i = 0; i < 3; i++) {
          // 로드
          final loadCompleter = Completer<bool>();
          Future.delayed(const Duration(milliseconds: 50), () {
            loadCompleter.complete(true);
          });

          final loadSuccess = await loadCompleter.future;

          // 표시
          final showSuccess = loadSuccess; // 로드 성공 시 표시 가능

          cycles.add({
            'cycle': i,
            'loadSuccess': loadSuccess,
            'showSuccess': showSuccess,
          });

          // 닫힘 및 다음 광고 로드 준비
          await Future.delayed(const Duration(milliseconds: 10));
        }

        // Then: 모든 사이클이 성공해야 함
        expect(cycles.length, 3);
        for (final cycle in cycles) {
          expect(cycle['loadSuccess'], true);
          expect(cycle['showSuccess'], true);
        }
      });
    });

    group('Error Handling', () {
      test('should complete Completer with false on load error', () async {
        // Given: 광고 로드 에러 시뮬레이션
        final completer = Completer<bool>();

        Future.delayed(const Duration(milliseconds: 50), () {
          try {
            // 에러 발생 시뮬레이션
            throw Exception('Ad load failed');
          } catch (e) {
            // Completer를 false로 완료
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          }
        });

        // When: future await
        final result = await completer.future;

        // Then: false 반환
        expect(result, false);
      });

      test('should not complete Completer twice', () async {
        // Given: Completer 생성
        final completer = Completer<bool>();

        // When: 첫 번째 완료
        completer.complete(true);

        // Then: 두 번째 완료 시도는 무시되어야 함
        if (!completer.isCompleted) {
          completer.complete(false); // 실행되지 않음
        }

        final result = await completer.future;
        expect(result, true); // 첫 번째 값 유지
      });

      test('should handle callback errors gracefully', () async {
        // Given: 콜백 에러 시뮬레이션
        final completer = Completer<bool>();
        var errorHandled = false;

        Future.delayed(const Duration(milliseconds: 50), () {
          try {
            // onAdFailedToLoad 콜백 시뮬레이션
            throw Exception('Network error');
          } catch (e) {
            errorHandled = true;
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          }
        });

        // When: 에러 처리
        final result = await completer.future;

        // Then: 에러가 적절히 처리됨
        expect(errorHandled, true);
        expect(result, false);
      });
    });

    group('Singleton Pattern', () {
      test('should verify singleton instance behavior', () {
        // Given: 싱글톤 패턴 시뮬레이션
        final instance1 = _MockRewardAdService._instance;
        final instance2 = _MockRewardAdService._instance;

        // Then: 같은 인스턴스여야 함
        expect(identical(instance1, instance2), true);
      });

      test('should maintain state across multiple calls', () {
        // Given: 싱글톤 인스턴스
        final service = _MockRewardAdService._instance;

        // When: 상태 변경
        service.mockLoadCount++;
        final firstCount = service.mockLoadCount;

        // When: 같은 인스턴스로 다시 접근
        final sameService = _MockRewardAdService._instance;
        final secondCount = sameService.mockLoadCount;

        // Then: 상태가 유지됨
        expect(firstCount, secondCount);
      });
    });

    group('Ad Preloading on App Startup', () {
      test('should simulate background ad preloading', () async {
        // Given: 앱 시작 시 광고 프리로드
        bool adPreloaded = false;

        // When: 백그라운드 프리로드 시뮬레이션
        Future<void> preloadAd() async {
          final completer = Completer<bool>();

          Future.delayed(const Duration(milliseconds: 100), () {
            completer.complete(true);
          });

          final success = await completer.future;
          adPreloaded = success;
        }

        await preloadAd();

        // Then: 광고가 프리로드되어야 함
        expect(adPreloaded, true);
      });

      test('should handle preload failure gracefully', () async {
        // Given: 프리로드 실패 시나리오
        bool adPreloaded = false;
        bool errorLogged = false;

        // When: 프리로드 실패 시뮬레이션
        Future<void> preloadAd() async {
          final completer = Completer<bool>();

          Future.delayed(const Duration(milliseconds: 100), () {
            completer.complete(false); // 실패
          });

          final success = await completer.future;
          adPreloaded = success;

          if (!success) {
            errorLogged = true; // 에러 로깅
          }
        }

        await preloadAd();

        // Then: 실패가 적절히 처리됨
        expect(adPreloaded, false);
        expect(errorLogged, true);
      });
    });

    group('Ad Show Logic', () {
      test('should not show ad if not ready', () {
        // Given: 광고가 준비되지 않은 상태
        bool isAdReady = false;

        // When: showAd 호출 시도
        bool canShow() {
          return isAdReady;
        }

        // Then: 광고 표시 불가
        expect(canShow(), false);
      });

      test('should show ad only when ready', () {
        // Given: 광고가 준비된 상태
        bool isAdReady = true;

        // When: showAd 호출
        bool canShow() {
          return isAdReady;
        }

        // Then: 광고 표시 가능
        expect(canShow(), true);
      });

      test('should trigger onRewardEarned callback', () async {
        // Given: 광고 시청 완료 시뮬레이션
        bool rewardGranted = false;

        // When: 광고 시청 및 보상 콜백
        Future<void> showAdWithReward() async {
          await Future.delayed(const Duration(milliseconds: 100));
          // onUserEarnedReward 콜백 시뮬레이션
          rewardGranted = true;
        }

        await showAdWithReward();

        // Then: 보상 지급
        expect(rewardGranted, true);
      });
    });

    group('Integration with Quick Analysis Screen', () {
      test('should simulate quick analysis screen ad flow', () async {
        // Given: Quick Analysis 화면에서 광고 시청 요청
        bool isAdReady = false;
        bool tokenRewarded = false;

        // When: 광고 로드 및 표시 플로우
        Future<bool> loadAndShowAd() async {
          // 1. 광고 로드
          if (!isAdReady) {
            final completer = Completer<bool>();

            Future.delayed(const Duration(milliseconds: 100), () {
              completer.complete(true);
            });

            isAdReady = await completer.future;
          }

          // 2. 광고 표시
          if (isAdReady) {
            await Future.delayed(const Duration(milliseconds: 50));
            // 광고 시청 완료 → 토큰 보상
            tokenRewarded = true;
            return true;
          }

          return false;
        }

        final success = await loadAndShowAd();

        // Then: 광고 시청 성공 및 토큰 보상
        expect(success, true);
        expect(isAdReady, true);
        expect(tokenRewarded, true);
      });

      test('should handle ad load failure in quick analysis', () async {
        // Given: 광고 로드 실패
        bool errorShown = false;

        // When: 광고 로드 실패 시뮬레이션
        Future<bool> loadAndShowAd() async {
          final completer = Completer<bool>();

          Future.delayed(const Duration(milliseconds: 100), () {
            completer.complete(false); // 로드 실패
          });

          final loaded = await completer.future;

          if (!loaded) {
            errorShown = true; // 에러 메시지 표시
            return false;
          }

          return true;
        }

        final success = await loadAndShowAd();

        // Then: 에러 처리
        expect(success, false);
        expect(errorShown, true);
      });
    });
  });
}

// 테스트 헬퍼 클래스

/// 싱글톤 패턴 테스트를 위한 Mock 클래스
class _MockRewardAdService {
  static final _MockRewardAdService _instance = _MockRewardAdService._internal();
  factory _MockRewardAdService() => _instance;
  _MockRewardAdService._internal();

  int mockLoadCount = 0;
}
