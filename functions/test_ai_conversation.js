/**
 * AI 대화 테스트 스크립트 (Node.js)
 *
 * 실행 방법:
 * node test_ai_conversation.js
 */

const admin = require('firebase-admin');
const axios = require('axios');

// Firebase Admin 초기화
admin.initializeApp();

async function testAIConversation() {
  console.log('🧪 AI 대화 테스트 시작...\n');

  try {
    // 1. 익명 사용자 생성
    console.log('📝 Step 1: 익명 사용자 생성 중...');
    const userRecord = await admin.auth().createUser({
      displayName: 'Test User',
    });
    console.log(`✅ 사용자 생성 완료: ${userRecord.uid}\n`);

    // 2. Custom Token 생성
    console.log('🔑 Step 2: Custom Token 생성 중...');
    const customToken = await admin.auth().createCustomToken(userRecord.uid);
    console.log(`✅ Token 생성 완료\n`);

    // 3. Firebase Functions URL
    const projectId = 'mission100-app';
    const region = 'us-central1';
    const functionUrl = `https://${region}-${projectId}.cloudfunctions.net/analyzeWithLumi`;

    console.log(`📡 Step 3: AI 함수 호출 중...`);
    console.log(`   URL: ${functionUrl}`);
    console.log(`   메시지: "안녕, Lumi! 자각몽이 뭐야?"\n`);

    // 4. AI 대화 함수 호출 (첫 번째 메시지)
    const response1 = await axios.post(
      functionUrl,
      {
        data: {
          conversationId: null,
          userMessage: '안녕, Lumi! 자각몽이 뭐야?',
        },
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${customToken}`,
        },
      }
    );

    const result1 = response1.data.result;
    console.log('✅ AI 응답 수신 완료!');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('📝 응답 내용:');
    console.log(result1.response);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log(`�� 대화 ID: ${result1.conversationId}`);
    console.log(`💬 메시지 카운트: ${result1.messageCount}`);
    console.log(`🎫 남은 토큰: ${result1.tokensRemaining}\n`);

    // 5. 같은 대화에서 두 번째 메시지
    console.log('📡 Step 4: 연속 대화 테스트...');
    console.log(`   메시지: "꿈 일기를 쓰는 게 도움이 될까?"\n`);

    const response2 = await axios.post(
      functionUrl,
      {
        data: {
          conversationId: result1.conversationId,
          userMessage: '꿈 일기를 쓰는 게 도움이 될까?',
        },
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${customToken}`,
        },
      }
    );

    const result2 = response2.data.result;
    console.log('✅ 두 번째 응답 수신 완료!');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('📝 응답 내용:');
    console.log(result2.response);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log(`🆔 대화 ID: ${result2.conversationId}`);
    console.log(`💬 메시지 카운트: ${result2.messageCount}`);
    console.log(`🎫 남은 토큰: ${result2.tokensRemaining}\n`);

    // 6. 검증
    console.log('🔍 Step 5: 결과 검증...');
    const checks = [
      {
        name: 'AI 응답이 비어있지 않음',
        pass: result1.response && result1.response.length > 0,
      },
      {
        name: '두 번째 응답도 비어있지 않음',
        pass: result2.response && result2.response.length > 0,
      },
      {
        name: '대화 ID가 유지됨',
        pass: result1.conversationId === result2.conversationId,
      },
      {
        name: '메시지 카운트가 2',
        pass: result2.messageCount === 2,
      },
    ];

    checks.forEach((check) => {
      const icon = check.pass ? '✅' : '❌';
      console.log(`   ${icon} ${check.name}`);
    });

    const allPassed = checks.every((c) => c.pass);

    if (allPassed) {
      console.log('\n🎉 모든 테스트 통과! AI가 정상 작동합니다.');
    } else {
      console.log('\n⚠️ 일부 테스트 실패');
    }

    // 7. 테스트 사용자 삭제
    console.log('\n🧹 정리 중: 테스트 사용자 삭제...');
    await admin.auth().deleteUser(userRecord.uid);
    console.log('✅ 정리 완료\n');

    process.exit(allPassed ? 0 : 1);

  } catch (error) {
    console.error('\n❌ 테스트 실패:');
    console.error(error.response?.data || error.message || error);
    process.exit(1);
  }
}

// 테스트 실행
testAIConversation();
