/**
 * Lucid Dream 100 Firebase Cloud Functions
 *
 * Functions:
 * 1. verifyPurchase - IAP 결제 검증
 * 2. sendWorkoutReminders - 일일 운동 알림 스케줄링
 * 3. onUserLevelUp - 레벨업 이벤트
 * 4. onAchievementUnlocked - 업적 달성 이벤트
 * 5. sendStreakWarnings - 스트릭 위험 알림
 * 6. analyzeWithLumi - Lumi와 대화 (OpenAI GPT-4o-mini)
 * 7. quickDreamAnalysis - 빠른 꿈 분석 (토큰 없이 사용 가능)
 * 8. claimDailyReward - 일일 보상 클레임 (서버측 검증)
 * 9. requestAIConversation - AI 대화 요청 (토큰 차감 + OpenAI API 호출)
 * 10. completeChecklist - 체크리스트 완료 (토큰 보상)
 * 11. openRouterProxy - OpenRouter 무료 AI (Gemini) - 체크리스트용
 */

const {onRequest, onCall} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const {google} = require("googleapis");
const axios = require("axios");
const {defineSecret} = require("firebase-functions/params");

admin.initializeApp();

// OpenAI API 키를 Secret으로 정의
const openaiApiKey = defineSecret("OPENAI_API_KEY");

// OpenRouter API 키를 Secret으로 정의
const openrouterApiKey = defineSecret("OPENROUTER_API_KEY");

// ============================================
// 1. IAP 결제 검증 (Google Play)
// ============================================
exports.verifyPurchase = onRequest(async (req, res) => {
  try {
    const {packageName, productId, purchaseToken} = req.body;

    if (!packageName || !productId || !purchaseToken) {
      return res.status(400).json({
        success: false,
        error: "Missing required parameters",
      });
    }

    // Google Play Developer API 인증
    const auth = new google.auth.GoogleAuth({
      keyFile: "./service-account-key.json", // Firebase Console에서 다운로드
      scopes: ["https://www.googleapis.com/auth/androidpublisher"],
    });

    const androidPublisher = google.androidpublisher({
      version: "v3",
      auth: await auth.getClient(),
    });

    // 구매 검증
    const response = await androidPublisher.purchases.subscriptionsv2.get({
      packageName,
      token: purchaseToken,
    });

    const purchase = response.data;

    // 검증 결과 확인
    const isValid = purchase.acknowledgementState === 1 &&
                    purchase.subscriptionState === "SUBSCRIPTION_STATE_ACTIVE";

    if (isValid) {
      // Firestore에 구독 정보 저장
      const userId = req.body.userId;
      await admin.firestore().collection("subscriptions").doc(userId).set({
        productId,
        purchaseToken,
        expiryTime: purchase.lineItems[0].expiryTime,
        autoRenewing: purchase.lineItems[0].autoRenewingPlan != null,
        verified: true,
        verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, {merge: true});

      return res.json({
        success: true,
        verified: true,
        expiryTime: purchase.lineItems[0].expiryTime,
      });
    } else {
      return res.json({
        success: true,
        verified: false,
        reason: "Subscription not active or not acknowledged",
      });
    }
  } catch (error) {
    console.error("Purchase verification error:", error);
    return res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// ============================================
// 2. 일일 운동 알림 스케줄링 (매일 오전 8시)
// ============================================
exports.sendWorkoutReminders = onSchedule({
  schedule: "0 8 * * *", // 매일 오전 8시 (UTC)
  timeZone: "Asia/Seoul",
}, async (event) => {
  try {
    console.log("Sending workout reminders...");

    // 알림 설정이 활성화된 사용자 조회
    const usersSnapshot = await admin.firestore()
        .collection("userProfiles")
        .where("notificationEnabled", "==", true)
        .get();

    const messages = [];

    for (const doc of usersSnapshot.docs) {
      const userData = doc.data();
      const fcmToken = userData.fcmToken;

      if (!fcmToken) continue;

      // 오늘 운동 완료 여부 확인
      const today = new Date().toISOString().split("T")[0];
      const workoutSnapshot = await admin.firestore()
          .collection("workoutRecords")
          .where("userId", "==", doc.id)
          .where("date", ">=", new Date(today))
          .limit(1)
          .get();

      // 오늘 운동 안 했으면 알림 전송
      if (workoutSnapshot.empty) {
        messages.push({
          token: fcmToken,
          notification: {
            title: "🔥 운동 시간이야!",
            body: `CHAD가 기다리고 있어! 오늘도 BEAST MODE 발동! 💪`,
          },
          data: {
            route: "/workout",
            type: "workout_reminder",
          },
          android: {
            priority: "high",
            notification: {
              sound: "default",
              channelId: "workout_reminders",
            },
          },
          apns: {
            payload: {
              aps: {
                sound: "default",
                badge: 1,
              },
            },
          },
        });
      }
    }

    // 배치 전송
    if (messages.length > 0) {
      const response = await admin.messaging().sendEach(messages);
      console.log(`Sent ${response.successCount} workout reminders`);
      console.log(`Failed: ${response.failureCount}`);
    } else {
      console.log("No users to send reminders to");
    }
  } catch (error) {
    console.error("Error sending workout reminders:", error);
  }
});

// ============================================
// 3. Chad 레벨업 이벤트 (Firestore 트리거)
// ============================================
exports.onUserLevelUp = onDocumentWritten(
    "chadProgress/{userId}",
    async (event) => {
      try {
        const beforeData = event.data.before.data();
        const afterData = event.data.after.data();

        // 레벨이 올랐는지 확인
        if (!beforeData || !afterData) return;
        if (beforeData.level >= afterData.level) return;

        console.log(`User ${event.params.userId} leveled up to ${afterData.level}`);

        // 사용자 FCM 토큰 가져오기
        const userDoc = await admin.firestore()
            .collection("userProfiles")
            .doc(event.params.userId)
            .get();

        const fcmToken = userDoc.data()?.fcmToken;
        if (!fcmToken) return;

        // 레벨업 축하 알림
        await admin.messaging().send({
          token: fcmToken,
          notification: {
            title: "🎉 레벨 업!",
            body: `축하합니다! Chad가 Lv.${afterData.level}로 진화했어요! 🔥`,
          },
          data: {
            route: "/home",
            type: "level_up",
            level: String(afterData.level),
          },
          android: {
            priority: "high",
            notification: {
              sound: "default",
              channelId: "chad_updates",
            },
          },
        });

        console.log("Level up notification sent");
      } catch (error) {
        console.error("Error sending level up notification:", error);
      }
    });

// ============================================
// 4. 업적 달성 이벤트 (Firestore 트리거)
// ============================================
exports.onAchievementUnlocked = onDocumentWritten(
    "achievements/{achievementId}",
    async (event) => {
      try {
        const beforeData = event.data.before.data();
        const afterData = event.data.after.data();

        // 업적이 새로 달성되었는지 확인
        if (!beforeData || !afterData) return;
        if (beforeData.completed) return; // 이미 완료된 경우
        if (!afterData.completed) return; // 아직 미완료

        console.log(`Achievement unlocked: ${event.params.achievementId}`);

        // 사용자 FCM 토큰 가져오기
        const userId = afterData.userId;
        const userDoc = await admin.firestore()
            .collection("userProfiles")
            .doc(userId)
            .get();

        const fcmToken = userDoc.data()?.fcmToken;
        if (!fcmToken) return;

        // 업적 달성 알림
        await admin.messaging().send({
          token: fcmToken,
          notification: {
            title: "🏆 업적 달성!",
            body: `${afterData.title} 업적을 달성했어요! +${afterData.xpReward} XP 획득! 🎉`,
          },
          data: {
            route: "/achievements",
            type: "achievement_unlocked",
            achievementId: event.params.achievementId,
          },
          android: {
            priority: "high",
            notification: {
              sound: "default",
              channelId: "chad_updates",
            },
          },
        });

        console.log("Achievement notification sent");
      } catch (error) {
        console.error("Error sending achievement notification:", error);
      }
    });

// ============================================
// 5. 스트릭 위험 알림 (매일 오후 9시)
// ============================================
exports.sendStreakWarnings = onSchedule({
  schedule: "0 21 * * *", // 매일 오후 9시 (UTC)
  timeZone: "Asia/Seoul",
}, async (event) => {
  try {
    console.log("Checking for streak warnings...");

    // 오늘 운동 안 한 사용자 중 스트릭이 있는 사용자 조회
    const usersSnapshot = await admin.firestore()
        .collection("workoutProgress")
        .where("streak", ">", 0)
        .get();

    const messages = [];
    const today = new Date().toISOString().split("T")[0];

    for (const doc of usersSnapshot.docs) {
      const progressData = doc.data();
      const userId = progressData.userId;

      // 오늘 운동 완료 여부 확인
      const workoutSnapshot = await admin.firestore()
          .collection("workoutRecords")
          .where("userId", "==", userId)
          .where("date", ">=", new Date(today))
          .limit(1)
          .get();

      // 오늘 운동 안 했으면 스트릭 경고
      if (workoutSnapshot.empty) {
        const userDoc = await admin.firestore()
            .collection("userProfiles")
            .doc(userId)
            .get();

        const fcmToken = userDoc.data()?.fcmToken;
        if (!fcmToken) continue;

        messages.push({
          token: fcmToken,
          notification: {
            title: "⚠️ 스트릭 위험!",
            body: `${progressData.streak}일 연속 기록이 끊길 위기! 지금 운동하면 지킬 수 있어요! 🔥`,
          },
          data: {
            route: "/workout",
            type: "streak_warning",
            streak: String(progressData.streak),
          },
          android: {
            priority: "high",
            notification: {
              sound: "default",
              channelId: "workout_reminders",
            },
          },
        });
      }
    }

    if (messages.length > 0) {
      const response = await admin.messaging().sendEach(messages);
      console.log(`Sent ${response.successCount} streak warnings`);
    }
  } catch (error) {
    console.error("Error sending streak warnings:", error);
  }
});

// ============================================
// 6. Lumi와 대화 (OpenRouter - Gemini 2.0 Flash)
// ============================================
exports.analyzeWithLumi = onCall({
  secrets: [openrouterApiKey],
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const userId = request.auth.uid;
    const {conversationId, userMessage, userTitle} = request.data;
    const title = userTitle || "드리머님"; // 기본 칭호 (서버 기본값)

    if (!userMessage || userMessage.trim().length === 0) {
      throw new Error("메시지를 입력해주세요");
    }

    // 2. 입력 제한 (500자)
    if (userMessage.length > 500) {
      throw new Error("메시지는 500자 이내로 입력해주세요");
    }

    // 3. Firestore에서 토큰 확인
    const userDoc = await admin.firestore()
        .collection("users")
        .doc(userId)
        .get();

    const conversationTokens = userDoc.data()?.conversationTokens || 0;

    if (conversationTokens < 1) {
      throw new Error("대화 토큰이 부족합니다");
    }

    // 4. 대화 내역 로드 (최근 10개 메시지)
    let messages = [];

    if (conversationId) {
      const conversationDoc = await admin.firestore()
          .collection("conversations")
          .doc(conversationId)
          .get();

      if (conversationDoc.exists) {
        const conversationData = conversationDoc.data();
        messages = conversationData.messages || [];

        // 최근 10개만 유지
        if (messages.length > 10) {
          messages = messages.slice(-10);
        }
      }
    }

    // 5. 시스템 프롬프트 추가 (대화 시작 시)
    if (messages.length === 0) {
      messages.push({
        role: "system",
        content: `당신은 Lumi, 꿈 분석 전문 AI 어시스턴트입니다.
사용자를 "${title}"이라고 부르며, 따뜻하고 공감하는 태도로 꿈을 분석합니다.

다음을 제공합니다:
- 꿈의 심리학적 의미
- 감정 상태 이해
- 실생활 적용 가능한 인사이트
- 명상 또는 자기 성찰 제안

항상 긍정적이고 격려하는 톤을 유지하며, 사용자의 언어에 맞춰 자연스럽게 대화합니다.`,
      });
    }

    // 6. 사용자 메시지 추가
    messages.push({
      role: "user",
      content: userMessage,
    });

    // 7. OpenRouter API 호출 (Gemini 2.0 Flash)
    const openrouterResponse = await axios.post(
        "https://openrouter.ai/api/v1/chat/completions",
        {
          model: "google/gemini-2.0-flash-001",
          messages: messages,
          max_tokens: 500,
          temperature: 0.7,
        },
        {
          headers: {
            "Authorization": `Bearer ${openrouterApiKey.value()}`,
            "Content-Type": "application/json",
            "HTTP-Referer": "https://dreamflow.app",
            "X-Title": "DreamFlow Lumi Chat",
          },
          timeout: 30000, // 30초 타임아웃
        },
    );

    const aiResponse = openrouterResponse.data.choices[0].message.content;

    // 8. AI 응답 추가
    messages.push({
      role: "assistant",
      content: aiResponse,
    });

    // 9. 대화 내역 저장
    const newConversationId = conversationId ||
        `conv_${userId}_${Date.now()}`;

    await admin.firestore()
        .collection("conversations")
        .doc(newConversationId)
        .set({
          userId: userId,
          conversationId: newConversationId,
          messages: messages,
          lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
        }, {merge: true});

    // 10. 토큰 차감
    await admin.firestore()
        .collection("users")
        .doc(userId)
        .update({
          conversationTokens: admin.firestore.FieldValue.increment(-1),
        });

    console.log(`User ${userId}: conversation token used (${conversationTokens - 1} remaining)`);

    // 11. 결과 반환
    return {
      success: true,
      conversationId: newConversationId,
      response: aiResponse,
      tokensRemaining: conversationTokens - 1,
      messageCount: messages.length,
    };
  } catch (error) {
    console.error("Lumi conversation error:", error);

    // OpenAI API 에러 처리
    if (error.response?.status === 429) {
      throw new Error("API 사용량 한도 초과. 잠시 후 다시 시도해주세요");
    } else if (error.response?.status === 401) {
      throw new Error("API 인증 실패. 관리자에게 문의하세요");
    }

    throw new Error(error.message || "AI 분석 중 오류가 발생했습니다");
  }
});

// ============================================
// 7. 빠른 꿈 분석 (토큰 없이 사용 가능)
// ============================================
exports.quickDreamAnalysis = onCall({
  secrets: [openrouterApiKey],
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const userId = request.auth.uid;
    const {dreamText, userTitle} = request.data;
    const title = userTitle || "드리머님"; // 기본 칭호

    if (!dreamText || dreamText.trim().length === 0) {
      throw new Error("꿈 내용을 입력해주세요");
    }

    // 2. 입력 제한 (500자)
    if (dreamText.length > 500) {
      throw new Error("꿈 내용은 500자 이내로 입력해주세요");
    }

    // 3. 토큰 확인 및 차감 (1 토큰)
    const tokenRef = admin.firestore()
        .collection("conversationTokens")
        .doc(userId);

    const tokenDoc = await tokenRef.get();
    const tokenData = tokenDoc.exists ? tokenDoc.data() : {balance: 0};
    const currentBalance = tokenData.balance || 0;

    if (currentBalance < 1) {
      throw new Error("토큰이 부족합니다. 체크리스트 완료 또는 광고 시청으로 토큰을 획득하세요.");
    }

    // 4. OpenRouter API 호출 (간단한 분석)
    const openrouterResponse = await axios.post(
        "https://openrouter.ai/api/v1/chat/completions",
        {
          model: "google/gemini-2.0-flash-001",
          messages: [
            {
              role: "system",
              content: `당신은 Lumi, 꿈 분석 전문 AI입니다.
사용자를 "${title}"이라고 부르며, 꿈을 간단하고 명확하게 분석하여 3-4문장으로 요약합니다.
항상 따뜻하고 격려하는 톤으로 대화합니다.`,
            },
            {
              role: "user",
              content: `다음 꿈을 분석해주세요:\n\n${dreamText}`,
            },
          ],
          max_tokens: 300,
          temperature: 0.7,
        },
        {
          headers: {
            "Authorization": `Bearer ${openrouterApiKey.value()}`,
            "Content-Type": "application/json",
            "HTTP-Referer": "https://dreamflow.app",
            "X-Title": "DreamFlow Quick Analysis",
          },
          timeout: 20000,
        },
    );

    const analysis = openrouterResponse.data.choices[0].message.content;

    // 5. 토큰 차감 (API 호출 성공 시에만)
    await tokenRef.update({
      balance: currentBalance - 1,
      totalSpent: admin.firestore.FieldValue.increment(1),
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    });

    // 6. 히스토리 기록
    await tokenRef.collection("history").add({
      type: "quick_analysis",
      amount: -1,
      balanceBefore: currentBalance,
      balanceAfter: currentBalance - 1,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`✅ Quick analysis completed. User: ${userId}, Tokens remaining: ${currentBalance - 1}`);

    return {
      success: true,
      analysis: analysis,
      tokensRemaining: currentBalance - 1,
    };
  } catch (error) {
    console.error("Quick analysis error:", error);

    // 429 에러 체크 (여러 방식으로 확인)
    if (error.response?.status === 429 ||
        error.code === "ERR_BAD_REQUEST" && error.message?.includes("429")) {
      throw new Error("API 사용량 한도 초과. 잠시 후 다시 시도해주세요.");
    }

    // axios 에러 메시지 확인
    if (error.message?.includes("429")) {
      throw new Error("API 사용량 한도 초과. 잠시 후 다시 시도해주세요.");
    }

    throw new Error(error.message || "꿈 분석 중 오류가 발생했습니다");
  }
});


// ============================================
// 9. 일일 보상 클레임 (서버측 검증)
// ============================================
exports.claimDailyReward = onCall({
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const userId = request.auth.uid;
    const {isPremium} = request.data; // 프리미엄 상태 받기
    const today = new Date().toISOString().split("T")[0];

    // 2. 이미 오늘 보상을 받았는지 확인
    const rewardDoc = await admin.firestore()
        .collection("dailyRewards")
        .doc(`${userId}_${today}`)
        .get();

    if (rewardDoc.exists) {
      throw new Error("이미 오늘 보상을 받았습니다");
    }

    // 3. 토큰 문서 가져오기 또는 생성
    const tokenRef = admin.firestore()
        .collection("conversationTokens")
        .doc(userId);

    const tokenDoc = await tokenRef.get();
    const tokenData = tokenDoc.exists ? tokenDoc.data() : {
      balance: 0,
      totalEarned: 0,
      totalSpent: 0,
      currentStreak: 0,
      lastClaimDate: null,
    };

    // 4. 스트릭 계산
    let newStreak = 1;
    if (tokenData.lastClaimDate) {
      const lastClaim = new Date(tokenData.lastClaimDate);
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);

      const lastClaimDate = lastClaim.toISOString().split("T")[0];
      const yesterdayDate = yesterday.toISOString().split("T")[0];

      // 어제 클레임했다면 스트릭 증가
      if (lastClaimDate === yesterdayDate) {
        newStreak = (tokenData.currentStreak || 0) + 1;
      }
    }

    // 5. 보상 토큰 계산 (프리미엄 여부에 따라) - 스트릭 보너스 제거됨
    const rewardTokens = isPremium ? 5 : 1; // 프리미엄: 5개, 무료: 1개
    const bonusReason = null;

    // 6. 토큰 증가 및 상태 업데이트
    await tokenRef.set({
      userId: userId,
      balance: (tokenData.balance || 0) + rewardTokens,
      totalEarned: (tokenData.totalEarned || 0) + rewardTokens,
      totalSpent: tokenData.totalSpent || 0,
      currentStreak: newStreak,
      lastClaimDate: today,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    }, {merge: true});

    // 7. 보상 클레임 기록 생성
    await admin.firestore()
        .collection("dailyRewards")
        .doc(`${userId}_${today}`)
        .set({
          userId: userId,
          date: today,
          tokensEarned: rewardTokens,
          streak: newStreak,
          bonusReason: bonusReason,
          claimedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

    // 8. 히스토리 기록
    await admin.firestore()
        .collection("conversationTokens")
        .doc(userId)
        .collection("history")
        .add({
          type: "daily_reward",
          amount: rewardTokens,
          balanceBefore: tokenData.balance || 0,
          balanceAfter: (tokenData.balance || 0) + rewardTokens,
          streak: newStreak,
          bonusReason: bonusReason,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

    console.log(
        `User ${userId}: Daily reward claimed. ` +
        `Tokens: +${rewardTokens}, Streak: ${newStreak}`,
    );

    return {
      success: true,
      tokensEarned: rewardTokens,
      newBalance: (tokenData.balance || 0) + rewardTokens,
      currentStreak: newStreak,
      bonusReason: bonusReason,
    };
  } catch (error) {
    console.error("Daily reward claim error:", error);
    throw new Error(error.message || "보상 수령 중 오류가 발생했습니다");
  }
});

// ============================================
// 10. AI 대화 요청 (토큰 차감 + OpenRouter API 호출)
// ============================================
exports.requestAIConversation = onCall({
  secrets: [openrouterApiKey],
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const userId = request.auth.uid;
    const {messages, conversationId, model} = request.data;

    if (!messages || !Array.isArray(messages) || messages.length === 0) {
      throw new Error("메시지를 제공해야 합니다");
    }

    // 2. 토큰 잔액 확인 (깊은 분석: 3 토큰 필요)
    const DEEP_ANALYSIS_COST = 3;
    const tokenRef = admin.firestore()
        .collection("conversationTokens")
        .doc(userId);

    const tokenDoc = await tokenRef.get();

    if (!tokenDoc.exists || (tokenDoc.data().balance || 0) < DEEP_ANALYSIS_COST) {
      throw new Error(`대화 토큰이 부족합니다. (필요: ${DEEP_ANALYSIS_COST} 토큰)`);
    }

    const tokenData = tokenDoc.data();
    const currentBalance = tokenData.balance || 0;

    // 3. OpenRouter API 호출 (GPT-4o-mini - 깊은 분석, 다른 AI 스타일)
    const apiModel = "openai/gpt-4o-mini"; // 3토큰 가치 차별화

    const openrouterResponse = await axios.post(
        "https://openrouter.ai/api/v1/chat/completions",
        {
          model: apiModel,
          messages: messages,
          max_tokens: 1024,
          temperature: 0.7,
        },
        {
          headers: {
            "Authorization": `Bearer ${openrouterApiKey.value()}`,
            "Content-Type": "application/json",
            "HTTP-Referer": "https://dreamflow.app",
            "X-Title": "DreamFlow Deep Analysis",
          },
          timeout: 30000,
        },
    );

    const aiResponse = openrouterResponse.data.choices[0].message.content;

    // 4. 토큰 차감 (트랜잭션) - 깊은 분석: 3 토큰
    await admin.firestore().runTransaction(async (transaction) => {
      const freshTokenDoc = await transaction.get(tokenRef);
      const freshBalance = freshTokenDoc.data().balance || 0;

      if (freshBalance < DEEP_ANALYSIS_COST) {
        throw new Error(`대화 토큰이 부족합니다. (필요: ${DEEP_ANALYSIS_COST} 토큰)`);
      }

      transaction.update(tokenRef, {
        balance: admin.firestore.FieldValue.increment(-DEEP_ANALYSIS_COST),
        totalSpent: admin.firestore.FieldValue.increment(DEEP_ANALYSIS_COST),
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    // 5. 대화 기록 저장
    const newConversationId = conversationId ||
        `conv_${userId}_${Date.now()}`;

    await admin.firestore()
        .collection("conversations")
        .doc(newConversationId)
        .set({
          userId: userId,
          conversationId: newConversationId,
          messages: [...messages, {role: "assistant", content: aiResponse}],
          lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
        }, {merge: true});

    // 6. 히스토리 기록
    await admin.firestore()
        .collection("conversationTokens")
        .doc(userId)
        .collection("history")
        .add({
          type: "deep_analysis",
          amount: -DEEP_ANALYSIS_COST,
          balanceBefore: currentBalance,
          balanceAfter: currentBalance - DEEP_ANALYSIS_COST,
          conversationId: newConversationId,
          model: apiModel,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

    console.log(
        `User ${userId}: Deep analysis (Lumi conversation). ` +
        `Tokens: -${DEEP_ANALYSIS_COST}, Balance: ${currentBalance - DEEP_ANALYSIS_COST}`,
    );

    return {
      success: true,
      response: aiResponse,
      conversationId: newConversationId,
      tokensRemaining: currentBalance - DEEP_ANALYSIS_COST,
    };
  } catch (error) {
    console.error("AI conversation error:", error);

    if (error.response?.status === 429) {
      throw new Error("API 사용량 한도 초과. 잠시 후 다시 시도해주세요");
    } else if (error.response?.status === 401) {
      throw new Error("API 인증 실패. 관리자에게 문의하세요");
    }

    throw new Error(error.message || "AI 대화 중 오류가 발생했습니다");
  }
});

// ============================================
// 11. 체크리스트 완료 (토큰 보상)
// ============================================
exports.completeChecklist = onCall({
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const userId = request.auth.uid;
    const {week, day, xpEarned} = request.data;

    if (!week || !day) {
      throw new Error("주차와 일차 정보가 필요합니다");
    }

    const today = new Date().toISOString().split("T")[0];
    const checklistId = `${userId}_w${week}_d${day}_${today}`;

    // 2. 이미 완료했는지 확인
    const checklistDoc = await admin.firestore()
        .collection("checklistCompletions")
        .doc(checklistId)
        .get();

    if (checklistDoc.exists) {
      throw new Error("이미 완료한 체크리스트입니다");
    }

    // 3. 토큰 보상 (1 토큰)
    const rewardTokens = 1;

    const tokenRef = admin.firestore()
        .collection("conversationTokens")
        .doc(userId);

    const tokenDoc = await tokenRef.get();
    const currentBalance = tokenDoc.exists ? tokenDoc.data().balance : 0;

    await tokenRef.set({
      userId: userId,
      balance: (currentBalance || 0) + rewardTokens,
      totalEarned: admin.firestore.FieldValue.increment(rewardTokens),
      totalSpent: tokenDoc.exists ? tokenDoc.data().totalSpent : 0,
      currentStreak: tokenDoc.exists ? tokenDoc.data().currentStreak : 0,
      lastClaimDate: tokenDoc.exists ? tokenDoc.data().lastClaimDate : null,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    }, {merge: true});

    // 4. 체크리스트 완료 기록
    await admin.firestore()
        .collection("checklistCompletions")
        .doc(checklistId)
        .set({
          userId: userId,
          week: week,
          day: day,
          date: today,
          tokensEarned: rewardTokens,
          xpEarned: xpEarned || 0,
          completedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

    // 5. 히스토리 기록
    await admin.firestore()
        .collection("conversationTokens")
        .doc(userId)
        .collection("history")
        .add({
          type: "checklist_completion",
          amount: rewardTokens,
          balanceBefore: currentBalance || 0,
          balanceAfter: (currentBalance || 0) + rewardTokens,
          week: week,
          day: day,
          xpEarned: xpEarned || 0,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

    console.log(
        `User ${userId}: Checklist W${week}D${day} completed. ` +
        `Tokens: +${rewardTokens}, XP: +${xpEarned || 0}`,
    );

    return {
      success: true,
      tokensEarned: rewardTokens,
      newBalance: (currentBalance || 0) + rewardTokens,
      xpEarned: xpEarned || 0,
    };
  } catch (error) {
    console.error("Checklist completion error:", error);
    throw new Error(error.message || "체크리스트 완료 처리 중 오류가 발생했습니다");
  }
});

// ============================================
// 11. 광고 시청 토큰 획득
// ============================================
exports.earnRewardAdTokens = onCall({
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const userId = request.auth.uid;
    const {isPremium} = request.data;

    // 2. 토큰 문서 가져오기
    const tokenRef = admin.firestore()
        .collection("conversationTokens")
        .doc(userId);

    const tokenDoc = await tokenRef.get();
    const currentBalance = tokenDoc.exists ? (tokenDoc.data().balance || 0) : 0;
    const tokenData = tokenDoc.data() || {};

    // 3. 일일 광고 시청 횟수 체크
    const lastAdDate = tokenData.lastAdDate;
    const adsWatchedToday = tokenData.adsWatchedToday || 0;
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

    let newAdsWatchedToday = adsWatchedToday;
    if (lastAdDate) {
      const lastAd = new Date(lastAdDate);
      const lastAdDay = new Date(
          lastAd.getFullYear(),
          lastAd.getMonth(),
          lastAd.getDate(),
      );

      if (today > lastAdDay) {
        // 새로운 날 - 카운터 리셋
        newAdsWatchedToday = 0;
      }
    }

    // 4. 일일 최대 광고 시청 횟수 체크 (maxDailyAds = 2)
    const MAX_DAILY_ADS = 2;
    if (newAdsWatchedToday >= MAX_DAILY_ADS) {
      throw new Error(
          `일일 광고 시청 제한에 도달했습니다. (${newAdsWatchedToday}/${MAX_DAILY_ADS})`,
      );
    }

    // 5. 토큰 추가
    const REWARD_AD_TOKENS = 1;
    const maxTokens = isPremium ? 50 : 10;
    const newBalance = Math.min(
        currentBalance + REWARD_AD_TOKENS,
        maxTokens,
    );

    await tokenRef.set({
      userId: userId,
      balance: newBalance,
      totalEarned: admin.firestore.FieldValue.increment(REWARD_AD_TOKENS),
      totalSpent: tokenData.totalSpent || 0,
      currentStreak: tokenData.currentStreak || 0,
      lastClaimDate: tokenData.lastClaimDate || null,
      lastAdDate: now.toISOString(),
      adsWatchedToday: newAdsWatchedToday + 1,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    }, {merge: true});

    // 6. 히스토리 기록
    await tokenRef.collection("history").add({
      type: "reward_ad",
      amount: REWARD_AD_TOKENS,
      balanceBefore: currentBalance,
      balanceAfter: newBalance,
      adsWatchedToday: newAdsWatchedToday + 1,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(
        `User ${userId}: Reward ad watched. ` +
        `Tokens: +${REWARD_AD_TOKENS} (${newAdsWatchedToday + 1}/${MAX_DAILY_ADS} today), ` +
        `Balance: ${newBalance}`,
    );

    return {
      success: true,
      tokensEarned: REWARD_AD_TOKENS,
      newBalance: newBalance,
      adsWatchedToday: newAdsWatchedToday + 1,
      maxDailyAds: MAX_DAILY_ADS,
    };
  } catch (error) {
    console.error("Reward ad token earn error:", error);
    throw new Error(error.message || "광고 토큰 획득 중 오류가 발생했습니다");
  }
});

// ============================================
// 12. OpenRouter Proxy (무료 Gemini) - 체크리스트용
// ============================================
exports.openRouterProxy = onCall({
  secrets: [openrouterApiKey],
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const userId = request.auth.uid;
    const {prompt, messages, model, maxTokens} = request.data;

    // 2. 사용량 체크 (일일 한도)
    const usageRef = admin.firestore()
        .collection("openRouterUsage")
        .doc(userId);

    const today = new Date().toISOString().split("T")[0];
    const usageDoc = await usageRef.get();
    const usageData = usageDoc.exists ? usageDoc.data() : {};

    // 프리미엄 여부 확인
    const subscriptionDoc = await admin.firestore()
        .collection("subscriptions")
        .doc(userId)
        .get();

    const isPremium = subscriptionDoc.exists &&
        (subscriptionDoc.data().type === "premium" ||
         subscriptionDoc.data().type === "launchPromo");

    const dailyLimit = isPremium ? 100 : 10; // 프리미엄: 100회, 무료: 10회
    const usageCount = (usageData.date === today) ? (usageData.count || 0) : 0;

    if (usageCount >= dailyLimit) {
      throw new Error(`일일 사용 한도를 초과했습니다 (${usageCount}/${dailyLimit})`);
    }

    // 3. OpenRouter API 호출 (무료 Gemini)
    const apiModel = model || "google/gemini-2.0-flash-exp:free";
    const requestMessages = messages || [{role: "user", content: prompt}];

    console.log(`OpenRouter request: ${userId}, Model: ${apiModel}`);

    const openRouterResponse = await axios.post(
        "https://openrouter.ai/api/v1/chat/completions",
        {
          model: apiModel,
          messages: requestMessages,
          max_tokens: maxTokens || 512,
        },
        {
          headers: {
            "Authorization": `Bearer ${openrouterApiKey.value()}`,
            "Content-Type": "application/json",
            "HTTP-Referer": "https://luciddream100.app",
            "X-Title": "Lucid Dream 100",
          },
          timeout: 30000,
        },
    );

    const aiResponse = openRouterResponse.data.choices[0].message.content;

    // 4. 사용량 업데이트
    await usageRef.set({
      userId: userId,
      date: today,
      count: usageCount + 1,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    }, {merge: true});

    console.log(
        `OpenRouter response: ${userId}, Usage: ${usageCount + 1}/${dailyLimit}`,
    );

    // 5. 응답 반환
    return {
      success: true,
      response: aiResponse,
      usageCount: usageCount + 1,
      dailyLimit: dailyLimit,
      remaining: dailyLimit - (usageCount + 1),
      isPremium: isPremium,
    };
  } catch (error) {
    console.error("OpenRouter proxy error:", error);

    // 외부 API 에러 처리
    if (error.response) {
      const statusCode = error.response.status;
      const errorMessage = error.response.data?.error?.message ||
          "OpenRouter API 호출 실패";

      throw new Error(`OpenRouter Error (${statusCode}): ${errorMessage}`);
    }

    throw new Error(error.message || "AI 호출 중 오류가 발생했습니다");
  }
});

// ============================================
// 12. 환영 보너스 지급 (신규 사용자)
// ============================================
exports.grantWelcomeBonus = onCall(async (request) => {
  try {
    const userId = request.auth.uid;

    if (!userId) {
      throw new Error("인증이 필요합니다");
    }

    console.log(`🎁 Checking welcome bonus for user: ${userId}`);

    // 토큰 문서 확인
    const tokenRef = admin.firestore()
        .collection("conversationTokens")
        .doc(userId);

    const tokenDoc = await tokenRef.get();

    // 이미 토큰 문서가 있으면 보너스 미지급
    if (tokenDoc.exists) {
      console.log(`ℹ️ User ${userId} already has tokens, skipping welcome bonus`);
      return {
        success: false,
        alreadyGranted: true,
        message: "이미 환영 보너스를 받으셨습니다",
      };
    }

    // 🎁 신규 사용자! 환영 보너스 지급
    console.log(`🎉 NEW USER! Granting welcome bonus to ${userId}`);

    await tokenRef.set({
      userId: userId,
      balance: 1,
      totalEarned: 1,
      totalSpent: 0,
      currentStreak: 0,
      lastClaimDate: null,
      firstTimeBonus: true,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`✅ Welcome bonus granted successfully to ${userId}`);

    return {
      success: true,
      tokensGranted: 1,
      newBalance: 1,
      message: "환영합니다! 첫 방문 보너스로 토큰 1개를 드립니다.",
    };
  } catch (error) {
    console.error("❌ Welcome bonus error:", error);
    throw new Error(error.message || "환영 보너스 지급 중 오류가 발생했습니다");
  }
});
