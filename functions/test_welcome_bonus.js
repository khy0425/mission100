/**
 * 환영 보너스 테스트 스크립트
 *
 * 이 스크립트는 다음을 수행합니다:
 * 1. 익명 사용자 목록 조회
 * 2. 특정 사용자의 토큰 문서 삭제 (신규 사용자 시뮬레이션)
 * 3. 토큰 문서 조회 (환영 보너스 지급 후 확인)
 */

const admin = require('firebase-admin');

// Firebase Admin 초기화
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const auth = admin.auth();

async function listUsers() {
  console.log('\n📋 Listing users...\n');

  try {
    const listUsersResult = await auth.listUsers(5); // 최대 5명만 조회

    if (listUsersResult.users.length === 0) {
      console.log('No users found.');
      return [];
    }

    listUsersResult.users.forEach((userRecord, index) => {
      console.log(`${index + 1}. User ID: ${userRecord.uid}`);
      console.log(`   Provider: ${userRecord.providerData.length > 0 ? userRecord.providerData[0].providerId : 'anonymous'}`);
      console.log(`   Created: ${userRecord.metadata.creationTime}`);
      console.log('');
    });

    return listUsersResult.users;
  } catch (error) {
    console.error('❌ Error listing users:', error);
    return [];
  }
}

async function checkTokenDocument(userId) {
  console.log(`\n🔍 Checking token document for user: ${userId}\n`);

  try {
    const tokenDoc = await db.collection('conversationTokens').doc(userId).get();

    if (tokenDoc.exists) {
      const data = tokenDoc.data();
      console.log('✅ Token document exists:');
      console.log(`   - Balance: ${data.balance}`);
      console.log(`   - Total Earned: ${data.totalEarned}`);
      console.log(`   - Total Spent: ${data.totalSpent}`);
      console.log(`   - First Time Bonus: ${data.firstTimeBonus || false}`);
      console.log(`   - Created At: ${data.createdAt?.toDate() || 'N/A'}`);
      return true;
    } else {
      console.log('⚠️  Token document does NOT exist (new user)');
      return false;
    }
  } catch (error) {
    console.error('❌ Error checking token document:', error);
    return false;
  }
}

async function deleteTokenDocument(userId) {
  console.log(`\n🗑️  Deleting token document for user: ${userId}\n`);

  try {
    await db.collection('conversationTokens').doc(userId).delete();
    console.log('✅ Token document deleted successfully!');
    console.log('   This simulates a new user who has never received the welcome bonus.');
    console.log('   Now restart the app to trigger the welcome bonus flow.');
    return true;
  } catch (error) {
    console.error('❌ Error deleting token document:', error);
    return false;
  }
}

async function main() {
  console.log('\n========================================');
  console.log('   WELCOME BONUS TEST SCRIPT');
  console.log('========================================\n');

  // 1. 사용자 목록 조회
  const users = await listUsers();

  if (users.length === 0) {
    console.log('\n❌ No users found. Please create a user first.');
    process.exit(1);
  }

  // 2. 첫 번째 사용자 선택
  const testUser = users[0];
  const userId = testUser.uid;

  console.log(`\n🎯 Selected test user: ${userId}\n`);

  // 3. 현재 토큰 문서 상태 확인
  console.log('Step 1: Check current token document state');
  const exists = await checkTokenDocument(userId);

  if (exists) {
    // 4. 토큰 문서 삭제 (신규 사용자 시뮬레이션)
    console.log('\nStep 2: Delete token document to simulate new user');
    const deleted = await deleteTokenDocument(userId);

    if (deleted) {
      // 5. 삭제 후 확인
      console.log('\nStep 3: Verify deletion');
      await checkTokenDocument(userId);

      console.log('\n========================================');
      console.log('✅ TEST PREPARATION COMPLETE!');
      console.log('========================================\n');
      console.log('📱 Next steps:');
      console.log('   1. Restart your app');
      console.log('   2. The ConversationTokenService will detect this is a "new" user');
      console.log('   3. Cloud Function grantWelcomeBonus will be called');
      console.log('   4. User should receive 1 welcome token');
      console.log('\n🔍 To verify:');
      console.log('   Run this script again to see the token document with balance: 1');
      console.log('');
    }
  } else {
    console.log('\n⚠️  User already has no token document (already a new user)');
    console.log('   Just restart the app to trigger the welcome bonus.');
  }

  process.exit(0);
}

main();
