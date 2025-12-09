/**
 * 간단한 AI 대화 테스트
 *
 * Firebase Emulator 없이 직접 HTTP로 테스트합니다.
 *
 * 실행 방법:
 * GOOGLE_APPLICATION_CREDENTIALS=path/to/serviceAccountKey.json node test_simple.js
 */

const https = require('https');

// Firebase Functions URL
const PROJECT_ID = 'mission100-app';
const REGION = 'us-central1';
const FUNCTION_NAME = 'analyzeWithLumi';
const FUNCTION_URL = `https://${REGION}-${PROJECT_ID}.cloudfunctions.net/${FUNCTION_NAME}`;

async function testAIConversation() {
  console.log('🧪 AI 대화 간단 테스트\n');
  console.log(`📡 Functions URL: ${FUNCTION_URL}\n`);

  // 테스트 데이터
  const testData = {
    data: {
      conversationId: null,
      userMessage: '안녕, Lumi! 자각몽이 뭐야?'
    }
  };

  console.log('📤 테스트 메시지:', testData.data.userMessage);
  console.log('⚠️  주의: 이 테스트는 인증 없이 호출하므로 실패할 수 있습니다.');
  console.log('   실제 앱에서 로그인 후 테스트하거나,');
  console.log('   Service Account 키로 인증해야 합니다.\n');

  const postData = JSON.stringify(testData);

  const options = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(postData),
    },
  };

  return new Promise((resolve, reject) => {
    const req = https.request(FUNCTION_URL, options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        console.log(`📊 HTTP Status: ${res.statusCode}\n`);

        if (res.statusCode === 200) {
          try {
            const result = JSON.parse(data);
            console.log('✅ 응답 수신 성공!');
            console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            console.log(JSON.stringify(result, null, 2));
            console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
            resolve(result);
          } catch (e) {
            console.log('⚠️ JSON 파싱 실패');
            console.log('Raw response:', data);
            reject(e);
          }
        } else {
          console.log('❌ 요청 실패');
          console.log('응답 내용:', data);

          if (res.statusCode === 401 || res.statusCode === 403) {
            console.log('\n💡 인증 오류입니다. 다음 방법으로 테스트하세요:');
            console.log('   1. 실제 앱에서 로그인 후 테스트');
            console.log('   2. Service Account 키 사용');
            console.log('   3. Firebase Emulator 사용\n');
          }

          reject(new Error(`HTTP ${res.statusCode}: ${data}`));
        }
      });
    });

    req.on('error', (error) => {
      console.error('❌ 네트워크 오류:', error.message);
      reject(error);
    });

    req.write(postData);
    req.end();
  });
}

// 실행
testAIConversation()
  .then(() => {
    console.log('🎉 테스트 완료!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('\n❌ 테스트 실패');
    process.exit(1);
  });
