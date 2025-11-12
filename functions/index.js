/**
 * Mission100 Firebase Cloud Functions
 *
 * Functions:
 * 1. verifyPurchase - IAP 결제 검증
 * 2. sendWorkoutReminders - 일일 운동 알림 스케줄링
 * 3. onUserLevelUp - Chad 레벨업 이벤트
 * 4. onAchievementUnlocked - 업적 달성 이벤트
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
// 6. Lumi와 대화 (OpenAI GPT-4o-mini)
// ============================================
exports.analyzeWithLumi = onCall({
  secrets: [openaiApiKey],
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const userId = request.auth.uid;
    const {conversationId, userMessage} = request.data;

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

사용자의 꿈을 따뜻하고 공감하는 태도로 분석하며, 다음을 제공합니다:
- 꿈의 심리학적 의미
- 감정 상태 이해
- 실생활 적용 가능한 인사이트
- 명상 또는 자기 성찰 제안

항상 긍정적이고 격려하는 톤을 유지하며, 한국어로 자연스럽게 대화합니다.`,
      });
    }

    // 6. 사용자 메시지 추가
    messages.push({
      role: "user",
      content: userMessage,
    });

    // 7. OpenAI API 호출
    const openaiResponse = await axios.post(
        "https://api.openai.com/v1/chat/completions",
        {
          model: "gpt-4o-mini",
          messages: messages,
          max_tokens: 500,
          temperature: 0.7,
        },
        {
          headers: {
            "Authorization": `Bearer ${openaiApiKey.value()}`,
            "Content-Type": "application/json",
          },
          timeout: 30000, // 30초 타임아웃
        },
    );

    const aiResponse = openaiResponse.data.choices[0].message.content;

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
  secrets: [openaiApiKey],
  cors: true,
}, async (request) => {
  try {
    // 1. 사용자 인증 확인
    if (!request.auth) {
      throw new Error("인증이 필요합니다");
    }

    const {dreamText} = request.data;

    if (!dreamText || dreamText.trim().length === 0) {
      throw new Error("꿈 내용을 입력해주세요");
    }

    // 2. 입력 제한 (500자)
    if (dreamText.length > 500) {
      throw new Error("꿈 내용은 500자 이내로 입력해주세요");
    }

    // 3. OpenAI API 호출 (간단한 분석)
    const openaiResponse = await axios.post(
        "https://api.openai.com/v1/chat/completions",
        {
          model: "gpt-4o-mini",
          messages: [
            {
              role: "system",
              content: `당신은 Lumi, 꿈 분석 전문 AI입니다.
사용자의 꿈을 간단하고 명확하게 분석하여 3-4문장으로 요약합니다.`,
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
            "Authorization": `Bearer ${openaiApiKey.value()}`,
            "Content-Type": "application/json",
          },
          timeout: 20000,
        },
    );

    const analysis = openaiResponse.data.choices[0].message.content;

    return {
      success: true,
      analysis: analysis,
    };
  } catch (error) {
    console.error("Quick analysis error:", error);

    if (error.response?.status === 429) {
      throw new Error("API 사용량 한도 초과. 잠시 후 다시 시도해주세요");
    }

    throw new Error(error.message || "꿈 분석 중 오류가 발생했습니다");
  }
});

// ============================================
// 8. OpenRouter AI Proxy (보안 API 게이트웨이)
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
    const {prompt, model, maxTokens, messages} = request.data;

    // 2. 입력 검증
    if (!prompt && !messages) {
      throw new Error("prompt 또는 messages를 제공해야 합니다");
    }

    // 3. 사용자 구독 상태 확인
    const userDoc = await admin.firestore()
        .collection("users")
        .doc(userId)
        .get();

    const userData = userDoc.data();
    const isPremium = userData?.isPremium || false;

    // 4. 일일 사용량 확인 및 제한
    const today = new Date().toISOString().split("T")[0];
    const usageDoc = await admin.firestore()
        .collection("aiUsage")
        .doc(`${userId}_${today}`)
        .get();

    const currentUsage = usageDoc.exists ? usageDoc.data().count : 0;
    const dailyLimit = isPremium ? 100 : 10;

    if (currentUsage >= dailyLimit) {
      throw new Error(
          `일일 사용 한도(${dailyLimit}회)를 초과했습니다. ` +
          (isPremium ? "내일 다시 시도해주세요" : "프리미엄으로 업그레이드하면 100회까지 사용 가능합니다"),
      );
    }

    // 5. OpenRouter API 호출
    const apiModel = model || "google/gemini-2.0-flash-exp:free";
    const apiMaxTokens = maxTokens || 512;

    let requestBody;
    if (messages) {
      // 대화형 메시지
      requestBody = {
        model: apiModel,
        messages: messages,
        max_tokens: apiMaxTokens,
      };
    } else {
      // 단일 프롬프트
      requestBody = {
        model: apiModel,
        messages: [
          {
            role: "user",
            content: prompt,
          },
        ],
        max_tokens: apiMaxTokens,
      };
    }

    const openrouterResponse = await axios.post(
        "https://openrouter.ai/api/v1/chat/completions",
        requestBody,
        {
          headers: {
            "Authorization": `Bearer ${openrouterApiKey.value()}`,
            "Content-Type": "application/json",
            "HTTP-Referer": "https://lucid-dream-100.app",
            "X-Title": "Lucid Dream 100",
          },
          timeout: 30000, // 30초 타임아웃
        },
    );

    const aiResponse = openrouterResponse.data.choices[0].message.content;

    // 6. 사용량 증가
    await admin.firestore()
        .collection("aiUsage")
        .doc(`${userId}_${today}`)
        .set({
          userId: userId,
          date: today,
          count: admin.firestore.FieldValue.increment(1),
          isPremium: isPremium,
          lastUsed: admin.firestore.FieldValue.serverTimestamp(),
        }, {merge: true});

    console.log(
        `User ${userId} (${isPremium ? "premium" : "free"}): ` +
        `AI usage ${currentUsage + 1}/${dailyLimit}`,
    );

    // 7. 결과 반환
    return {
      success: true,
      response: aiResponse,
      usageCount: currentUsage + 1,
      dailyLimit: dailyLimit,
      remaining: dailyLimit - (currentUsage + 1),
      isPremium: isPremium,
    };
  } catch (error) {
    console.error("OpenRouter proxy error:", error);

    // OpenRouter API 에러 처리
    if (error.response?.status === 429) {
      throw new Error("API 사용량 한도 초과. 잠시 후 다시 시도해주세요");
    } else if (error.response?.status === 401) {
      throw new Error("API 인증 실패. 관리자에게 문의하세요");
    } else if (error.response?.data?.error?.message) {
      throw new Error(`OpenRouter API 오류: ${error.response.data.error.message}`);
    }

    throw new Error(error.message || "AI 호출 중 오류가 발생했습니다");
  }
});
