import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucid_dream_100/services/ai/dream_analysis_service_secure.dart';

/// AI 대화 테스트
///
/// 이 테스트는 Firebase Functions의 analyzeWithLumi가 정상 작동하는지 확인합니다.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Firebase 초기화 (실제 프로젝트 사용)
    try {
      await Firebase.initializeApp();
      print('✅ Firebase 초기화 완료');
    } catch (e) {
      print('⚠️ Firebase 이미 초기화됨: $e');
    }

    // 익명 로그인
    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
        print('✅ 익명 로그인 완료: ${auth.currentUser?.uid}');
      } else {
        print('✅ 이미 로그인됨: ${auth.currentUser?.uid}');
      }
    } catch (e) {
      print('❌ 로그인 실패: $e');
    }
  });

  test('Lumi AI 대화 테스트 - 간단한 인사', () async {
    print('\n🧪 테스트 시작: Lumi와 대화하기');

    final service = DreamAnalysisServiceSecure();

    try {
      print('📤 메시지 전송: "안녕, Lumi! 자각몽이 뭐야?"');

      final result = await service.analyzeWithConversation(
        conversationId: null, // 새 대화 시작
        userMessage: '안녕, Lumi! 자각몽이 뭐야?',
      );

      print('✅ AI 응답 수신 완료!');
      print('📝 응답 내용:\n${result.response}');
      print('🎫 남은 토큰: ${result.tokensRemaining}');
      print('💬 메시지 카운트: ${result.messageCount}');
      print('🆔 대화 ID: ${result.conversationId}');

      // 검증
      expect(result.response.isNotEmpty, true, reason: 'AI 응답이 비어있습니다');
      expect(result.conversationId.isNotEmpty, true, reason: '대화 ID가 생성되지 않았습니다');
      expect(result.messageCount, 1, reason: '메시지 카운트가 1이 아닙니다');

      print('\n✅ 테스트 통과! AI가 정상 응답했습니다.');

    } catch (e) {
      print('❌ 테스트 실패: $e');
      rethrow;
    }
  });

  test('Lumi AI 대화 테스트 - 연속 대화', () async {
    print('\n🧪 테스트 시작: 연속 대화하기');

    final service = DreamAnalysisServiceSecure();

    try {
      // 첫 번째 메시지
      print('📤 1번째 메시지: "안녕!"');
      final result1 = await service.analyzeWithConversation(
        conversationId: null,
        userMessage: '안녕!',
      );
      print('✅ 1번째 응답: ${result1.response.substring(0, 50)}...');

      final conversationId = result1.conversationId;

      // 두 번째 메시지 (같은 대화 이어서)
      print('\n📤 2번째 메시지: "자각몽을 꾸려면 어떻게 해야 해?"');
      final result2 = await service.analyzeWithConversation(
        conversationId: conversationId,
        userMessage: '자각몽을 꾸려면 어떻게 해야 해?',
      );
      print('✅ 2번째 응답: ${result2.response.substring(0, 50)}...');

      // 검증
      expect(result2.conversationId, conversationId, reason: '대화 ID가 유지되지 않았습니다');
      expect(result2.messageCount, 2, reason: '메시지 카운트가 2가 아닙니다');

      print('\n✅ 연속 대화 테스트 통과!');
      print('📊 최종 상태:');
      print('   - 대화 ID: $conversationId');
      print('   - 총 메시지: ${result2.messageCount}');
      print('   - 남은 토큰: ${result2.tokensRemaining}');

    } catch (e) {
      print('❌ 테스트 실패: $e');
      rethrow;
    }
  });

  test('Lumi AI 대화 테스트 - 긴 메시지', () async {
    print('\n🧪 테스트 시작: 긴 꿈 이야기 분석');

    final service = DreamAnalysisServiceSecure();

    try {
      final longDream = '''
어젯밤 꿈에서 나는 하늘을 날고 있었어.
날개 없이도 자유롭게 날 수 있다는 걸 깨달았고,
그 순간 "아, 이건 꿈이구나!"라고 생각했어.
그래서 의식적으로 더 높이 날아올랐고,
아름다운 구름 위를 걸어다녔어.
정말 신기한 경험이었어!
''';

      print('📤 메시지 전송: 긴 꿈 이야기 (${longDream.length}자)');

      final result = await service.analyzeWithConversation(
        conversationId: null,
        userMessage: longDream,
      );

      print('✅ AI 응답 수신 완료!');
      print('📝 응답 길이: ${result.response.length}자');
      print('📝 응답 내용:\n${result.response}');

      // 검증
      expect(result.response.length, greaterThan(50), reason: '응답이 너무 짧습니다');

      print('\n✅ 긴 메시지 테스트 통과!');

    } catch (e) {
      print('❌ 테스트 실패: $e');
      rethrow;
    }
  });
}
