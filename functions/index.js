/**
 * Mission100 Firebase Cloud Functions
 *
 * Functions:
 * 1. verifyPurchase - IAP 결제 검증
 * 2. sendWorkoutReminders - 일일 운동 알림 스케줄링
 * 3. onUserLevelUp - Chad 레벨업 이벤트
 * 4. onAchievementUnlocked - 업적 달성 이벤트
 */

const {onRequest} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const {google} = require("googleapis");

admin.initializeApp();

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
