// ignore_for_file: deprecated_member_use
// TODO: Migrate to SharePlus.instance.share() API when refactoring social features

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/user_profile.dart';

class SocialShareService {
  /// 앱 이름 가져오기
  static String _getAppName(AppLocalizations l10n) {
    return 'DreamFlow';
  }

  /// 다운로드 메시지 가져오기 (다국어 지원)
  static String _getDownloadMessage(AppLocalizations l10n) {
    final locale = l10n.localeName;
    if (locale == 'ko') {
      return '🌙 너도 자각몽 마스터가 되고 싶다면? DreamFlow 앱 다운로드! 🌙';
    } else {
      return '🌙 Want to master lucid dreaming too? Download DreamFlow app! 🌙';
    }
  }

  /// 일일 연습 공유 메시지 가져오기 (다국어 지원)
  static String _getDailyWorkoutMessage(
    AppLocalizations l10n,
    int currentDay,
    int practiceCount,
    String levelName,
  ) {
    final locale = l10n.localeName;
    final downloadMessage = _getDownloadMessage(l10n);

    if (locale == 'ko') {
      return '''
🌙✨ 오늘의 자각몽 훈련 완료! ✨🌙

⚡ Day $currentDay - 꾸준한 연습이 자각몽을 만든다!
💫 완료한 연습: $practiceCount개
👑 현재 레벨: $levelName

매일매일 꿈의 세계를 탐험하는 중! 🌟
Lumi와 함께 성장하고 있어요! 😊

$downloadMessage

#DreamFlow #자각몽 #LucidDream #꿈일기 #Lumi''';
    } else {
      return '''
🌙✨ Today's Lucid Dream Training Complete! ✨🌙

⚡ Day $currentDay - Consistent practice makes lucid dreams!
💫 Practices Completed: $practiceCount
👑 Current Level: $levelName

Exploring the dream world every day! 🌟
Growing with Lumi! 😊

$downloadMessage

#DreamFlow #LucidDream #DreamJournal #Lumi''';
    }
  }

  /// 레벨업 공유 메시지 가져오기 (다국어 지원)
  static String _getLevelUpMessage(
    AppLocalizations l10n,
    UserLevel newLevel,
    int totalDays,
    int totalPractices,
  ) {
    final locale = l10n.localeName;
    final levelName = _getLevelName(newLevel, l10n);
    final levelEmoji = _getLevelEmoji(newLevel);
    final downloadMessage = _getDownloadMessage(l10n);

    if (locale == 'ko') {
      return '''
$levelEmoji🎉 레벨 업! 새로운 단계에 도달했어요! 🎉$levelEmoji

🎉 새로운 레벨: $levelName
📅 총 훈련일: $totalDays일
💫 총 연습: $totalPractices회

자각몽 마스터의 길을 걷고 있어요! 💪
Lumi도 함께 성장 중! 🌙

$downloadMessage

#DreamFlow #레벨업 #자각몽 #꿈일기''';
    } else {
      return '''
$levelEmoji🎉 LEVEL UP! Reached a new stage! 🎉$levelEmoji

🎉 New Level: $levelName
📅 Total Training Days: $totalDays days
💫 Total Practices: $totalPractices

Walking the path to lucid dream mastery! 💪
Lumi is growing together! 🌙

$downloadMessage

#DreamFlow #LevelUp #LucidDream #DreamJournal''';
    }
  }

  /// 업적 공유 메시지 가져오기 (다국어 지원)
  static String _getAchievementMessage(
    AppLocalizations l10n,
    String achievementTitle,
    String achievementDescription,
    int xpReward,
  ) {
    final locale = l10n.localeName;
    final downloadMessage = _getDownloadMessage(l10n);

    if (locale == 'ko') {
      return '''
🏆✨ 업적 달성! ✨🏆

✨ $achievementTitle
📝 $achievementDescription
🎯 획득 XP: $xpReward점

한 걸음씩 드림 스피릿에 가까워지고 있어요! 💫
Lumi가 축하해주고 있어요! 🌙

$downloadMessage

#DreamFlow #업적달성 #자각몽 #Lumi''';
    } else {
      return '''
🏆✨ Achievement Unlocked! ✨🏆

✨ $achievementTitle
📝 $achievementDescription
🎯 XP Gained: $xpReward points

Getting closer to Dream Spirit step by step! 💫
Lumi is celebrating! 🌙

$downloadMessage

#DreamFlow #Achievement #LucidDream #Lumi''';
    }
  }

  /// 주간 진행률 공유 메시지 가져오기 (다국어 지원)
  static String _getWeeklyProgressMessage(
    AppLocalizations l10n,
    int weekNumber,
    int completedDays,
    int totalPractices,
    double progressPercentage,
  ) {
    final locale = l10n.localeName;
    final appName = _getAppName(l10n);
    final downloadMessage = _getDownloadMessage(l10n);
    final progressBar = _generateProgressBar(progressPercentage);

    if (locale == 'ko') {
      return '''
📊🌙 $appName 주간 리포트 🌙📊

📅 Week $weekNumber
✅ 훈련일: $completedDays일
💫 총 연습: $totalPractices회
📈 진행률: ${progressPercentage.toStringAsFixed(1)}%

$progressBar

꾸준함이 자각몽을 만든다! 🌟
Lumi와 함께 꿈의 세계를 탐험 중! 🔥

$downloadMessage

#DreamFlow #주간리포트 #자각몽 #꾸준함''';
    } else {
      return '''
📊🌙 $appName Weekly Report 🌙📊

📅 Week $weekNumber
✅ Training Days: $completedDays days
💫 Total Practices: $totalPractices
📈 Progress: ${progressPercentage.toStringAsFixed(1)}%

$progressBar

Consistency makes lucid dreams! 🌟
Exploring the dream world with Lumi! 🔥

$downloadMessage

#DreamFlow #WeeklyReport #LucidDream #Consistency''';
    }
  }

  /// 마스터 달성 공유 메시지 가져오기 (다국어 지원)
  static String _get100AchievementMessage(
    AppLocalizations l10n,
    int totalDays,
    int duration,
  ) {
    final locale = l10n.localeName;
    final downloadMessage = _getDownloadMessage(l10n);

    if (locale == 'ko') {
      return '''
🎉👑✨ 드림 스피릿 달성! 자각몽 마스터! ✨👑🎉

🌙 자각몽 훈련 완료 - 꿈의 세계를 정복! 🌙

📅 총 소요일: $duration일
🏆 완료 세션: $totalDays회
🔥 진정한 드림 스피릿 등극! 🔥

꿈 씨앗에서 시작해서...
진짜 드림 스피릿이 되었어요! 💫

이제 꿈 속에서 무엇이든 할 수 있어요.
너도 이 경지에 도달할 수 있을까? 🌙

$downloadMessage

#DreamFlow #드림스피릿 #자각몽마스터 #완료 #꿈의전설''';
    } else {
      return '''
🎉👑✨ DREAM SPIRIT ACHIEVED! LUCID DREAM MASTER! ✨👑🎉

🌙 Lucid Dream Training Complete - Conquered the Dream World! 🌙

📅 Total Duration: $duration days
🏆 Completed Sessions: $totalDays times
🔥 TRUE DREAM SPIRIT ASCENSION! 🔥

Started as a dream seed...
Now became a real Dream Spirit! 💫

Now you can do anything in your dreams.
Can you reach this level too? 🌙

$downloadMessage

#DreamFlow #DreamSpirit #LucidDreamMaster #Complete #DreamLegend''';
    }
  }

  /// 친구 도전장 공유 메시지 가져오기 (다국어 지원)
  static String _getFriendChallengeMessage(
    AppLocalizations l10n,
    String userName,
  ) {
    final locale = l10n.localeName;
    final downloadMessage = _getDownloadMessage(l10n);

    if (locale == 'ko') {
      return '''
🌙💫 자각몽 도전장! 함께 꿈의 세계를 탐험해요! 💫🌙

${userName.isNotEmpty ? userName : '드림 스피릿'}이(가) 너에게 도전장을 보냈어요!

⚡ 미션: 60일 만에 자각몽 마스터 달성
🎯 목표: 꿈 씨앗 → 드림 스피릿 진화
💫 각오: 매일 꾸준히 연습하면 누구나 가능해요!

자각몽의 세계에 함께 도전해볼래요? 🌙
Lumi가 기다리고 있어요! ✨

$downloadMessage

#DreamFlow #자각몽도전 #함께해요 #꿈탐험''';
    } else {
      return '''
🌙💫 Lucid Dream Challenge! Let's explore the dream world together! 💫🌙

${userName.isNotEmpty ? userName : 'A Dream Spirit'} sends you a challenge!

⚡ Mission: Master lucid dreaming in 60 days
🎯 Goal: Dream Seed → Dream Spirit Evolution
💫 Resolve: Anyone can do it with daily practice!

Want to take on the lucid dream challenge together? 🌙
Lumi is waiting! ✨

$downloadMessage

#DreamFlow #LucidDreamChallenge #Together #DreamExploration''';
    }
  }

  /// 동기부여 공유 메시지 가져오기 (다국어 지원)
  static String _getMotivationMessage(
    AppLocalizations l10n,
    String motivationMessage,
  ) {
    final locale = l10n.localeName;
    final downloadMessage = _getDownloadMessage(l10n);

    if (locale == 'ko') {
      return '''
💫🌙 오늘의 자각몽 동기부여 🌙💫

"$motivationMessage"

작은 시작이 큰 변화를 만들어요!
오늘도 꿈의 세계로 한 걸음! 🌟
Lumi가 응원하고 있어요! ✨

$downloadMessage

#DreamFlow #동기부여 #자각몽 #오늘도화이팅''';
    } else {
      return '''
💫🌙 Today's Lucid Dream Motivation 🌙💫

"$motivationMessage"

Small beginnings make big changes!
One step closer to the dream world today! 🌟
Lumi is cheering you on! ✨

$downloadMessage

#DreamFlow #Motivation #LucidDream #KeepGoing''';
    }
  }

  /// 공유 제목 가져오기 (다국어 지원)
  static String _getShareSubject(
    AppLocalizations l10n,
    String type, {
    String? extra,
  }) {
    final locale = l10n.localeName;
    final appName = _getAppName(l10n);

    if (locale == 'ko') {
      switch (type) {
        case 'daily':
          return '$appName - 🌙 Day $extra 자각몽 훈련 완료! 🌙';
        case 'levelup':
          return '$appName - 🎉 $extra 레벨 달성! 🎉';
        case 'achievement':
          return '$appName - 🏆✨ 업적 달성! ✨🏆';
        case 'weekly':
          return '$appName - 📊 Week $extra 리포트 📊';
        case '100achievement':
          return '$appName - 🎉👑 드림 스피릿 달성! 👑🎉';
        case 'challenge':
          return '$appName - 🌙💫 자각몽 도전장! 💫🌙';
        case 'motivation':
          return '$appName - 💫🌙 오늘의 동기부여 🌙💫';
        default:
          return appName;
      }
    } else {
      switch (type) {
        case 'daily':
          return '$appName - 🌙 Day $extra Lucid Dream Training Complete! 🌙';
        case 'levelup':
          return '$appName - 🎉 $extra Level Achieved! 🎉';
        case 'achievement':
          return '$appName - 🏆✨ Achievement Unlocked! ✨🏆';
        case 'weekly':
          return '$appName - 📊 Week $extra Report 📊';
        case '100achievement':
          return '$appName - 🎉👑 Dream Spirit Achieved! 👑🎉';
        case 'challenge':
          return '$appName - 🌙💫 Lucid Dream Challenge! 💫🌙';
        case 'motivation':
          return '$appName - 💫🌙 Today\'s Motivation 🌙💫';
        default:
          return appName;
      }
    }
  }

  /// 일일 연습 기록 공유
  static Future<void> shareDailyWorkout({
    required BuildContext context,
    required int pushupCount,
    required int currentDay,
    required UserLevel level,
  }) async {
    try {
      final l10n = AppLocalizations.of(context);
      final levelName = _getLevelName(level, l10n);

      final message = _getDailyWorkoutMessage(
        l10n,
        currentDay,
        pushupCount,
        levelName,
      );

      await Share.share(
        message,
        subject: _getShareSubject(l10n, 'daily', extra: currentDay.toString()),
      );
    } catch (e) {
      debugPrint('일일 연습 기록 공유 오류: $e');
    }
  }

  /// 레벨업 달성 공유
  static Future<void> shareLevelUp({
    required BuildContext context,
    required UserLevel newLevel,
    required int totalDays,
    required int totalPushups,
  }) async {
    try {
      final l10n = AppLocalizations.of(context);
      final levelName = _getLevelName(newLevel, l10n);

      final message = _getLevelUpMessage(
        l10n,
        newLevel,
        totalDays,
        totalPushups,
      );

      await Share.share(
        message,
        subject: _getShareSubject(l10n, 'levelup', extra: levelName),
      );
    } catch (e) {
      debugPrint('레벨업 공유 오류: $e');
    }
  }

  /// 업적 달성 공유
  static Future<void> shareAchievement({
    required BuildContext context,
    required String achievementTitle,
    required String achievementDescription,
    required int xpReward,
  }) async {
    try {
      final l10n = AppLocalizations.of(context);

      final message = _getAchievementMessage(
        l10n,
        achievementTitle,
        achievementDescription,
        xpReward,
      );

      await Share.share(
        message,
        subject: _getShareSubject(l10n, 'achievement'),
      );
    } catch (e) {
      debugPrint('업적 공유 오류: $e');
    }
  }

  /// 주간 진행률 공유
  static Future<void> shareWeeklyProgress({
    required BuildContext context,
    required int weekNumber,
    required int completedDays,
    required int totalPushups,
    required double progressPercentage,
  }) async {
    try {
      final l10n = AppLocalizations.of(context);

      final message = _getWeeklyProgressMessage(
        l10n,
        weekNumber,
        completedDays,
        totalPushups,
        progressPercentage,
      );

      await Share.share(
        message,
        subject: _getShareSubject(l10n, 'weekly', extra: weekNumber.toString()),
      );
    } catch (e) {
      debugPrint('주간 진행률 공유 오류: $e');
    }
  }

  /// 마스터 달성 공유
  static Future<void> share100Achievement({
    required BuildContext context,
    required int totalDays,
    required DateTime startDate,
  }) async {
    try {
      final l10n = AppLocalizations.of(context);
      final duration = DateTime.now().difference(startDate).inDays;

      final message = _get100AchievementMessage(l10n, totalDays, duration);

      await Share.share(
        message,
        subject: _getShareSubject(l10n, '100achievement'),
      );
    } catch (e) {
      debugPrint('마스터 달성 공유 오류: $e');
    }
  }

  /// 친구 도전장 보내기
  static Future<void> shareFriendChallenge({
    required BuildContext context,
    required String userName,
  }) async {
    try {
      final l10n = AppLocalizations.of(context);

      final message = _getFriendChallengeMessage(l10n, userName);

      await Share.share(message, subject: _getShareSubject(l10n, 'challenge'));
    } catch (e) {
      debugPrint('친구 도전장 공유 오류: $e');
    }
  }

  /// 동기부여 메시지 공유
  static Future<void> shareMotivation({
    required BuildContext context,
    required String motivationMessage,
  }) async {
    try {
      final l10n = AppLocalizations.of(context);

      final message = _getMotivationMessage(l10n, motivationMessage);

      await Share.share(message, subject: _getShareSubject(l10n, 'motivation'));
    } catch (e) {
      debugPrint('동기부여 메시지 공유 오류: $e');
    }
  }

  /// 위젯을 이미지로 캡처하여 공유
  static Future<void> shareWidgetAsImage({
    required GlobalKey repaintBoundaryKey,
    required String message,
    required String subject,
  }) async {
    try {
      // 위젯을 이미지로 캡처
      final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 임시 파일로 저장
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/dreamflow_share.png').create();
      await file.writeAsBytes(pngBytes);

      // 이미지와 텍스트 함께 공유
      await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
        subject: subject,
      );
    } catch (e) {
      debugPrint('위젯 이미지 공유 오류: $e');
      // 이미지 공유 실패 시 텍스트만 공유
      await Share.share(message, subject: subject);
    }
  }

  /// 레벨명 가져오기
  static String _getLevelName(UserLevel level, AppLocalizations l10n) {
    switch (level) {
      case UserLevel.rookie:
        return l10n.rookieShort;
      case UserLevel.rising:
        return l10n.risingShort;
      case UserLevel.alpha:
        return l10n.alphaShort;
      case UserLevel.giga:
        return l10n.gigaShort;
    }
  }

  /// 레벨 이모지 가져오기
  static String _getLevelEmoji(UserLevel level) {
    switch (level) {
      case UserLevel.rookie:
        return '🌱';
      case UserLevel.rising:
        return '🌙';
      case UserLevel.alpha:
        return '⭐';
      case UserLevel.giga:
        return '👑';
    }
  }

  /// 진행률 바 생성
  static String _generateProgressBar(double percentage) {
    const int totalBars = 10;
    final int filledBars = (percentage / 10).round();
    final int emptyBars = totalBars - filledBars;

    return '[${'█' * filledBars}${'░' * emptyBars}] ${percentage.toStringAsFixed(1)}%';
  }
}
