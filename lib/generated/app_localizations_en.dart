// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '⚡ ALPHA BATTLEGROUND ⚡';

  @override
  String get repLogMessage => 'WEAK RECORD NUMBERS. STRONG MAKE HISTORY 💪';

  @override
  String targetRepsLabel(int count) {
    return 'TARGET: $count REPS';
  }

  @override
  String get performanceGodTier =>
      '🚀 ABSOLUTE PERFECTION! ULTRA GOD EMPEROR BEYOND GODS! 👑';

  @override
  String get performanceStrong =>
      '🔱 IRON BOWS TO YOUR MIGHT! NOW GRAVITY SURRENDERS TO YOU! LEGENDARY BEAST! 🔱';

  @override
  String get performanceMedium =>
      '⚡ GOOD! WEAKNESS IS FLEEING! ALPHA STORM INCOMING! ⚡';

  @override
  String get performanceStart =>
      '💥 BEGINNING IS HALF? WRONG! LEGEND\'S GATE ALREADY OPENED, YOU FUTURE EMPEROR! 💥';

  @override
  String get performanceMotivation => 'YOU CAN DO IT, JUST DO IT! 🔥';

  @override
  String get motivationGod =>
      '🚀 HOLY FUCKING SHIT, BRO! YOU\'RE AN ABSOLUTE SAVAGE ALPHA GOD! WEAKNESS JUST QUIT THE UNIVERSE! ⚡👑💀';

  @override
  String get motivationStrong =>
      'QUITTING IS EXCUSE FOR THE WEAK. GO HARDER! 🔱💪';

  @override
  String get motivationMedium =>
      'YOUR LIMITS ARE JUST YOUR THOUGHTS. DESTROY THEM! 🦍⚡';

  @override
  String get motivationGeneral =>
      'TODAY\'S SWEAT IS TOMORROW\'S GLORY. NEVER GIVE UP! 🔥💪';

  @override
  String get setCompletedSuccess => 'ANOTHER MYTH IS BORN! 🔥👑';

  @override
  String get setCompletedGood => 'ANOTHER LIMIT DESTROYED! ⚡🔱';

  @override
  String resultFormat(int reps, int percentage) {
    return 'LEGEND RANK: $reps REPS ($percentage%) 🏆';
  }

  @override
  String get quickInputPerfect => '🚀 GODLIKE ACHIEVED 🚀';

  @override
  String get quickInputStrong => '👑 EMPEROR POWER 👑';

  @override
  String get quickInputMedium => '⚡ ALPHA STEPS ⚡';

  @override
  String get quickInputStart => '🔥 LEGENDARY CRY 🔥';

  @override
  String get quickInputBeast => '💥 LIMIT DESTROYER 💥';

  @override
  String get restTimeTitle => 'ALPHA RECHARGE TIME ⚡';

  @override
  String get restMessage =>
      'REST IS ALSO GROWTH. NEXT WILL BE MORE DESTRUCTIVE 🦍';

  @override
  String get appInitError => 'An error occurred during app initialization.';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get notificationActivationTitle =>
      '🔥 MISSION 100 NOTIFICATION ACTIVATE! 🔥';

  @override
  String get notificationActivationMessage =>
      '💪 CHAD NOTIFICATIONS ON!\nLET\'S SET IT UP! FXXK THE EXCUSES! 💪';

  @override
  String get workoutNotificationPermission =>
      '🔔 Workout Notification Permission';

  @override
  String get laterWeak => 'Later... (WEAK)';

  @override
  String get enableChadNotifications => '🔥 ENABLE CHAD NOTIFICATIONS! 🔥';

  @override
  String get legendaryChadModeUpgrade => '⚡ LEGENDARY CHAD MODE UPGRADE! ⚡';

  @override
  String get legendaryModeDescription =>
      '🔥 Want more precise notifications?\nActivate LEGENDARY MODE! 🔥';

  @override
  String get legendaryModeOptional =>
      '💡 It\'s okay if not now!\nYou can set it anytime in settings later! 💪';

  @override
  String get legendaryModeOn => '⚡ LEGENDARY MODE ON! ⚡';

  @override
  String get chadModeActivated =>
      '💡 CHAD MODE ACTIVATED! More precise notifications available in settings! 🔥';

  @override
  String get skipButton => 'Skip';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get nextButton => 'Next';

  @override
  String get awesomeButton => 'Awesome!';

  @override
  String get startTestButton => 'Start Test';

  @override
  String get appSlogan => 'Journey to Become Chad';

  @override
  String backupStatusLoadFailed(Object error) {
    return 'Failed to load backup status: $error';
  }

  @override
  String get backupCreatedSuccessfully => 'Backup created successfully';

  @override
  String backupCreationFailed(Object error) {
    return 'Backup creation failed: $error';
  }

  @override
  String backupCreationError(Object error) {
    return 'Error occurred during backup creation: $error';
  }

  @override
  String get encryptedBackupCreated => 'Encrypted backup created';

  @override
  String encryptedBackupFailed(Object error) {
    return 'Encrypted backup creation failed: $error';
  }

  @override
  String encryptedBackupError(Object error) {
    return 'Error occurred during encrypted backup creation: $error';
  }

  @override
  String backupFileSaved(Object filePath) {
    return 'Backup file saved:\n$filePath';
  }

  @override
  String backupExportFailed(Object error) {
    return 'Backup export failed: $error';
  }

  @override
  String get backupRestoredSuccessfully => 'Backup restored successfully';

  @override
  String get backupRestoreFailed => 'Backup restore failed';

  @override
  String backupRestoreError(Object error) {
    return 'Error occurred during backup restore: $error';
  }

  @override
  String get allowNotifications => '🔔 Allow Notifications';

  @override
  String get storageAccess => '📁 Storage Access';

  @override
  String get notificationPermissionRequired =>
      '🔔 Notification Permission Required';

  @override
  String get dailyWorkoutReminder => 'Daily Workout Reminder';

  @override
  String get common => 'Common';

  @override
  String get rare => 'Rare';

  @override
  String get epic => 'Epic';

  @override
  String get legendary => 'Legendary';

  @override
  String get descriptionTitle => 'Description';

  @override
  String get earnedXp => 'Earned XP';

  @override
  String get motivationMessage => 'Motivation Message';

  @override
  String get percentComplete => 'Complete';

  @override
  String get adLoadFailed => 'Unable to load advertisement';

  @override
  String get evolutionCompleted => '🎉 Evolution Complete! 🎉';

  @override
  String get streakChallenge => 'Streak Challenge';

  @override
  String get singleSessionChallenge => 'Single Session Challenge';

  @override
  String get bestRecord => 'Best Record';

  @override
  String get weekUnit => 'week';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyExtreme => 'Giga Chad - Legendary Territory';

  @override
  String get statusAvailable => 'Available';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusLocked => 'Locked';

  @override
  String challengeTarget(int target, String unit) {
    return 'Target: $target$unit';
  }

  @override
  String challengeEstimatedDuration(int duration) {
    return 'Estimated Duration: $duration days';
  }

  @override
  String get cumulativeChallenge => 'Cumulative Challenge';

  @override
  String remainingToTarget(int remaining) {
    return '$remaining left to reach target';
  }

  @override
  String get sprintChallenge => 'Sprint Challenge';

  @override
  String get shortTermIntensiveChallenge => 'Short-term Intensive Challenge';

  @override
  String get eventChallenge => 'Event Challenge';

  @override
  String get specialEventChallenge => 'Special Event Challenge';

  @override
  String get challengeCompleted => 'Challenge Completed!';

  @override
  String get challengeInProgress => 'In Progress';

  @override
  String get totalTarget => 'Total Target:';

  @override
  String get todayWorkoutCompleted => '🎉 Today\'s Workout Complete! 🎉';

  @override
  String get startWorkout => 'Start Workout';

  @override
  String get feelThePowerOfChad => 'Feel the Power of Chad! 💪';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get scheduleNone => 'None';

  @override
  String get scheduleDaily => 'Daily';

  @override
  String get mondayFull => 'Monday';

  @override
  String get tuesdayFull => 'Tuesday';

  @override
  String get wednesdayFull => 'Wednesday';

  @override
  String get thursdayFull => 'Thursday';

  @override
  String get fridayFull => 'Friday';

  @override
  String get saturdayFull => 'Saturday';

  @override
  String get sundayFull => 'Sunday';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get koreanFlag => '🇰🇷';

  @override
  String get englishFlag => '🇺🇸';

  @override
  String get appVersion => '1.0.0';

  @override
  String get checkIcon => '✅';

  @override
  String get muscleIcon => '💪';

  @override
  String get calendarIcon => '📅';

  @override
  String get trophyIcon => '🏆';

  @override
  String get factCategoryMuscle => 'Muscle Physiology';

  @override
  String get factCategoryNervous => 'Nervous System Enhancement';

  @override
  String get factCategoryCardio => 'Cardiovascular Health';

  @override
  String get factCategoryMetabolic => 'Metabolic System';

  @override
  String get factCategoryHormone => 'Hormonal System';

  @override
  String get factCategoryMental => 'Mental Health';

  @override
  String get scientificFact1Title => 'Muscle Fiber Type Transformation';

  @override
  String get scientificFact1Content =>
      'Regular pushups convert slow-twitch fibers (Type I) to fast-twitch fibers (Type II), increasing explosive power.';

  @override
  String get scientificFact1Impact =>
      '💪 Qualitative muscle transformation in progress!';

  @override
  String get scientificFact1Explanation =>
      'Fiber type conversion begins after 6-8 weeks and can increase up to 30%.';

  @override
  String get scientificFact2Title => 'Mitochondrial Density Increase';

  @override
  String get scientificFact2Content =>
      'Pushups increase muscle mitochondrial density by up to 40%, maximizing energy production.';

  @override
  String get scientificFact2Impact =>
      '⚡ Infinite energy system being constructed!';

  @override
  String get scientificFact2Explanation =>
      'Mitochondria are the powerhouses of cells; their increase significantly reduces fatigue.';

  @override
  String get skipRestButton =>
      'REST? ONLY FOR THE WEAK! BRING THE NEXT VICTIM!';

  @override
  String get nextSetButton => 'UNIVERSE CONQUERED!';

  @override
  String get nextSetContinue => 'BRING THE NEXT SACRIFICE!';

  @override
  String get guidanceMessage => 'YOUR BODY OBEYS YOUR COMMANDS! 🔱';

  @override
  String get completeSetButton => 'ASCEND TO LEGEND!';

  @override
  String get completeSetContinue => 'DESTROY ANOTHER ONE!';

  @override
  String get exitDialogTitle => 'RETREAT FROM BATTLE?';

  @override
  String get exitDialogMessage =>
      'WARRIORS NEVER QUIT MID-BATTLE!\nYOUR CONQUEST WILL BE LOST!';

  @override
  String get exitDialogContinue => 'KEEP FIGHTING!';

  @override
  String get exitDialogRetreat => 'RETREAT...';

  @override
  String get workoutCompleteTitle => '🔥 BEAST MODE COMPLETED! 👑';

  @override
  String workoutCompleteMessage(String title, int totalReps) {
    return '$title COMPLETELY DESTROYED!\nTOTAL POWER UNLEASHED: $totalReps REPS! ⚡';
  }

  @override
  String get workoutCompleteButton => 'LEGENDARY!';

  @override
  String setFormat(int setNumber, int reps) {
    return 'Set $setNumber: $reps reps';
  }

  @override
  String get levelSelectionTitle => '💪 LEVEL CHECK';

  @override
  String get levelSelectionHeader => '🏋️‍♂️ CHOOSE YOUR LEVEL NOW!';

  @override
  String get levelSelectionDescription =>
      'Select your current max pushup count level!\nCustom 6-week program for goal achievement!';

  @override
  String get rookieLevelTitle => 'Rookie';

  @override
  String get rookieLevelSubtitle => 'Under 6 pushups - Build from basics';

  @override
  String get rookieLevelDescription => 'Chad who starts slowly';

  @override
  String get rookieFeature1 => 'Start with knee pushups';

  @override
  String get rookieFeature2 => 'Form-focused training';

  @override
  String get rookieFeature3 => 'Gradual intensity increase';

  @override
  String get rookieFeature4 => 'Build basic fitness';

  @override
  String get risingLevelTitle => 'Rising';

  @override
  String get risingLevelSubtitle => '6-10 pushups - Growing into chad';

  @override
  String get risingLevelDescription => 'Chad who is growing';

  @override
  String get risingFeature1 => 'Master standard pushups';

  @override
  String get risingFeature2 => 'Various training types';

  @override
  String get risingFeature3 => 'Build muscle endurance';

  @override
  String get risingFeature4 => 'Systematic progression';

  @override
  String get alphaLevelTitle => 'Alpha';

  @override
  String get alphaLevelSubtitle => '11+ pushups - Already chad material';

  @override
  String get alphaLevelDescription => 'Ultimate Chad';

  @override
  String get alphaFeature1 => 'Advanced pushup variations';

  @override
  String get alphaFeature2 => 'Explosive power training';

  @override
  String get alphaFeature3 => 'Plyometric exercises';

  @override
  String get alphaFeature4 => 'Complete giga chad course';

  @override
  String get rookieShort => 'PUSH';

  @override
  String get risingShort => 'ALPHA WANNABE';

  @override
  String get alphaShort => 'CHAD';

  @override
  String get gigaShort => 'GIGA CHAD';

  @override
  String get homeTitle => '💥 ALPHA EMPEROR COMMAND CENTER 💥';

  @override
  String get welcomeMessage =>
      '🔥 WELCOME,\nFUTURE EMPEROR! 🔥\nTIME FOR WORLD\nDOMINATION!';

  @override
  String get dailyMotivation =>
      '⚡ ANOTHER DAY OF\nLEGENDARY BEAST MODE!\nCRUSH THE UNIVERSE! ⚡';

  @override
  String get startTodayWorkout => '🚀 START TODAY\'S DOMINATION! 🚀';

  @override
  String weekProgress(int current, int total) {
    return 'Week $current/$total';
  }

  @override
  String progressWeekDay(int week, int totalDays, int completedDays) {
    return 'WEEK $week - $completedDays of $totalDays DAYS COMPLETED';
  }

  @override
  String get bottomMotivation =>
      '🔥 GROW A LITTLE? WRONG! DAILY LEGENDARY LEVEL UP! 💪';

  @override
  String workoutStartError(String error) {
    return '⚡ ALPHA SYSTEM ERROR! RETRY, FUTURE EMPEROR: $error ⚡';
  }

  @override
  String get errorGeneral =>
      '🦁 TEMPORARY OBSTACLE DETECTED! REAL EMPERORS TRY AGAIN! 🦁';

  @override
  String get errorDatabase =>
      '💥 DATA FORTRESS UNDER ATTACK! TECH CHADS FIXING NOW! 💥';

  @override
  String get errorNetwork =>
      '🌪️ CHECK NETWORK CONNECTION! ALPHA CONNECTION REQUIRED! 🌪️';

  @override
  String get errorNotFound =>
      '🔱 DATA NOT FOUND! TIME TO CREATE NEW LEGENDS! 🔱';

  @override
  String get successWorkoutCompleted =>
      '🚀 WORKOUT DOMINATION COMPLETE! ANOTHER LEGENDARY ACHIEVEMENT! 🚀';

  @override
  String get successProfileSaved =>
      '👑 EMPEROR PROFILE SAVED! YOUR LEGEND IS RECORDED! 👑';

  @override
  String get successSettingsSaved =>
      '⚡ ALPHA SETTINGS LOCKED! PERFECT CONFIG ARMED! ⚡';

  @override
  String get firstWorkoutMessage => 'Starting your first workout! Let\'s go!';

  @override
  String get weekCompletedMessage => 'Week completed! Congratulations!';

  @override
  String get programCompletedMessage => 'Program completed! Amazing job!';

  @override
  String get streakStartMessage => 'Workout streak started!';

  @override
  String get streakContinueMessage => 'Workout streak continues!';

  @override
  String get streakBrokenMessage => 'Workout streak broken';

  @override
  String get chadTitleSleepy => 'Sleepy Chad';

  @override
  String get chadTitleBasic => 'Basic Chad';

  @override
  String get chadTitleCoffee => 'Coffee Chad';

  @override
  String get chadTitleFront => 'Front Chad';

  @override
  String get chadTitleCool => 'Cool Chad';

  @override
  String get chadTitleLaser => 'Laser Chad';

  @override
  String get chadTitleDouble => 'Double Chad';

  @override
  String get levelNameRookie => 'ROOKIE CHAD';

  @override
  String get levelNameRising => 'RISING CHAD';

  @override
  String get levelNameAlpha => 'ALPHA CHAD';

  @override
  String get levelNameGiga => 'GIGA CHAD';

  @override
  String get levelDescRookie =>
      '🔥 ROOKIE CHAD. STARTING POINT OF PUSHUP EMPIRE.\nJOURNEY OF AWAKENING HAS BEGUN. 🔥';

  @override
  String get levelDescRising =>
      '⚡ RISING CHAD WITH SOLID FUNDAMENTALS, ASCENDING ALPHA.\nDOMINATING TOWARDS HIGHER GOALS! ⚡';

  @override
  String get levelDescAlpha =>
      '👑 ALPHA CHAD WITH CONSIDERABLE ALPHA EMPEROR SKILLS.\nALREADY ACHIEVED MANY LEGENDARY ACCOMPLISHMENTS! 👑';

  @override
  String get levelDescGiga =>
      '🚀 ULTIMATE ULTRA GIGA CHAD EMPEROR LEVEL.\nPOSSESSES AMAZING GODLIKE POWER! 🚀';

  @override
  String get levelMotivationRookie =>
      '🔥 ALL EMPERORS START HERE!\nEXPERIENCE MIND-BLOWING TRANSFORMATION AFTER 6 WEEKS! 🔥';

  @override
  String get levelMotivationRising =>
      '⚡ EXCELLENT START!\nBECOME STRONGER ALPHA BEAST! ⚡';

  @override
  String get levelMotivationAlpha =>
      '👑 OUTSTANDING PERFORMANCE!\nDOMINATE TO 100 TARGET, FXXK LIMITS! 👑';

  @override
  String get levelMotivationGiga =>
      '🚀 ALREADY POWERFUL GIGA CHAD!\nCONQUER THE PERFECT 100! 🚀';

  @override
  String get levelGoalRookie =>
      '🔥 GOAL: 100 CONSECUTIVE PUSHUPS ABSOLUTE DOMINATION AFTER 6 WEEKS! 🔥';

  @override
  String get levelGoalRising =>
      '⚡ GOAL: STRONGER ALPHA CHAD LEGENDARY EVOLUTION! ⚡';

  @override
  String get levelGoalAlpha =>
      '👑 GOAL: PERFECT FORM 100 REPS PERFECT EXECUTION! 👑';

  @override
  String get levelGoalGiga =>
      '🚀 GOAL: ULTIMATE CHAD MASTER UNIVERSE DOMINATION! 🚀';

  @override
  String get workoutButtonUltimate => 'CLAIM ULTIMATE VICTORY!';

  @override
  String get workoutButtonConquer => 'CONQUER THIS SET!';

  @override
  String get motivationMessage1 =>
      '🔥 REAL ALPHAS BURN EXCUSES ALIVE, FXXK THE WEAKNESS! 🔥';

  @override
  String get motivationMessage2 =>
      '⚡ CONQUER LIKE CHAD, DOMINATE LIKE SIGMA! REST IS STRATEGY ⚡';

  @override
  String get motivationMessage3 => '💪 EVERY REP ELEVATES YOU TO GOD TIER! 💪';

  @override
  String get motivationMessage4 =>
      '⚡ CHAD ENERGY 100% CHARGED! NOW CONQUER THE WORLD! ⚡';

  @override
  String get motivationMessage5 =>
      '🚀 NOT CHAD EVOLUTION! NOW LEGEND TRANSFORMATION, FXXK YEAH! 🚀';

  @override
  String get motivationMessage6 =>
      '👑 CHAD MODE? PAST THAT! NOW EMPEROR MODE: ACTIVATED! 👑';

  @override
  String get motivationMessage7 =>
      '🌪️ THIS IS HOW LEGENDS ARE BORN! HISTORY WILL REMEMBER YOU! 🌪️';

  @override
  String get motivationMessage8 =>
      '⚡ NOT CHAD POWER... NOW ALPHA LIGHTNING FLOWS THROUGH YOUR BODY! ⚡';

  @override
  String get motivationMessage9 =>
      '🔱 CHAD TRANSFORMATION COMPLETE! NOW EVOLVED TO ULTIMATE APEX PREDATOR! 🔱';

  @override
  String get motivationMessage10 =>
      '🦁 CHAD BROTHERHOOD? NO! BOW TO THE ALPHA EMPIRE EMPEROR! 🦁';

  @override
  String get completionMessage1 =>
      '🔥 THAT\'S IT! ABSOLUTE DOMINATION, FXXK YEAH! 🔥';

  @override
  String get completionMessage2 =>
      '⚡ ALPHA STORM HIT TODAY! THE WORLD IS TREMBLING! ⚡';

  @override
  String get completionMessage3 =>
      '👑 NOT CLOSER TO CHAD... NOW SURPASSED CHAD! 👑';

  @override
  String get completionMessage4 =>
      '🚀 CHAD-LIKE? WRONG! NOW LEGENDARY BEAST MODE, YOU MONSTER! 🚀';

  @override
  String get completionMessage5 =>
      '⚡ CHAD ENERGY LEVEL: ∞ INFINITY BREAKTHROUGH! UNIVERSE BOWS! ⚡';

  @override
  String get completionMessage6 =>
      '🦁 RESPECT? PAST THAT! NOW THE WHOLE WORLD BOWS TO YOU! 🦁';

  @override
  String get completionMessage7 =>
      '🔱 CHAD APPROVES? NO! GOD TIER ACKNOWLEDGES BIRTH! 🔱';

  @override
  String get completionMessage8 =>
      '🌪️ CHAD GAME LEVEL UP? WRONG! CONQUERED ALPHA DIMENSION, FXXK BEAST! 🌪️';

  @override
  String get completionMessage9 =>
      '💥 NOT PURE CHAD PERFORMANCE... NOW PURE LEGENDARY DOMINANCE! 💥';

  @override
  String get completionMessage10 =>
      '👑 CHAD\'S DAY? NO! EMPEROR OF ALPHAS EMPIRE BUILDING COMPLETE! 👑';

  @override
  String get encouragementMessage1 =>
      '🔥 ALPHAS HAVE TRIALS TOO! BUT THAT MAKES YOU STRONGER! 🔥';

  @override
  String get encouragementMessage2 =>
      '⚡ TOMORROW IS LEGENDARY COMEBACK DAY! WORLD WILL SEE YOUR RESURRECTION! ⚡';

  @override
  String get encouragementMessage3 =>
      '👑 REAL EMPERORS NEVER SURRENDER, FXXK THE LIMITS! 👑';

  @override
  String get encouragementMessage4 =>
      '🚀 THIS IS JUST ULTIMATE BOSS FIGHT MODE! YOU ALREADY WON! 🚀';

  @override
  String get encouragementMessage5 =>
      '🦁 REAL APEX PREDATORS RETURN STRONGER! 🦁';

  @override
  String get encouragementMessage6 =>
      '🔱 ALPHA SPIRIT IS IMMORTAL! EVEN IF UNIVERSE ENDS, YOU SURVIVE! 🔱';

  @override
  String get encouragementMessage7 =>
      '⚡ STILL LEGEND TRANSFORMATION IN PROGRESS, YOU ABSOLUTE UNIT! ⚡';

  @override
  String get encouragementMessage8 =>
      '🌪️ EPIC COMEBACK STORM INCOMING! WORLD TREMBLES AWAITING YOUR RETURN! 🌪️';

  @override
  String get encouragementMessage9 =>
      '💥 ALL EMPERORS PASS THROUGH TRIALS! THIS IS THE ROYAL PATH! 💥';

  @override
  String get encouragementMessage10 =>
      '👑 NOT CHAD RESILIENCE... NOW IMMORTAL PHOENIX POWER, FXXK YEAH! 👑';

  @override
  String get chadMessage0 =>
      '🛌 Wake up, future Chad! Your journey begins now!';

  @override
  String get chadMessage1 =>
      '😎 Your basics are getting solid! This is the real start of Chad!';

  @override
  String get chadMessage2 =>
      '☕ Energy overflowing! You\'ve got power stronger than coffee!';

  @override
  String get chadMessage3 =>
      '🔥 Frontal breakthrough! No obstacle can stop you!';

  @override
  String get chadMessage4 =>
      '🕶️ Coolness is in your bones! True alpha appearance!';

  @override
  String get chadMessage5 =>
      '⚡ You can change the world with just your eyes! Legend begins!';

  @override
  String get chadMessage6 =>
      '👑 Ultimate Chad complete! Conquer the universe with double power!';

  @override
  String get tutorialTitle => '🔥 ALPHA EMPEROR PUSHUP DOJO 🔥';

  @override
  String get tutorialSubtitle => 'REAL EMPERORS START WITH DIFFERENT FORM! 💪';

  @override
  String get tutorialButton => '💥 BECOME PUSHUP MASTER 💥';

  @override
  String get difficultyBeginner => 'PUSH - Starting Alphas';

  @override
  String get difficultyIntermediate => 'Alpha Wannabe - Growing Chads';

  @override
  String get difficultyAdvanced => 'Chad - Powerful Gigas';

  @override
  String get targetMuscleChest => 'CHEST';

  @override
  String get targetMuscleTriceps => 'TRICEPS';

  @override
  String get targetMuscleShoulders => 'SHOULDERS';

  @override
  String get targetMuscleCore => 'CORE';

  @override
  String get targetMuscleFull => 'FULL BODY';

  @override
  String caloriesPerRep(int calories) {
    return '${calories}kcal/rep';
  }

  @override
  String get tutorialDetailTitle => '💥 MASTER EMPEROR FORM 💥';

  @override
  String get benefitsSection => '🚀 HOW YOU BECOME LEGENDARY BEAST 🚀';

  @override
  String get instructionsSection => '⚡ EMPEROR EXECUTION METHOD ⚡';

  @override
  String get mistakesSection => '❌ WEAKLINGS\' PATHETIC MISTAKES ❌';

  @override
  String get breathingSection => '��️ ALPHA EMPEROR BREATHING 🌪️';

  @override
  String get chadMotivationSection => '🔥 EMPEROR\'S ULTIMATE WISDOM 🔥';

  @override
  String get pushupStandardName => 'STANDARD PUSHUP';

  @override
  String get pushupStandardDesc =>
      'Starting point of all chads. Perfect basics are true strength!';

  @override
  String get pushupStandardBenefits =>
      '• FULL CHEST DEVELOPMENT\\n• TRICEPS AND SHOULDER STRENGTH\\n• BASIC FITNESS IMPROVEMENT\\n• FOUNDATION FOR ALL PUSHUPS, YOU IDIOT!';

  @override
  String get pushupStandardInstructions =>
      '1. START IN PLANK POSITION\\n2. HANDS SHOULDER-WIDTH APART\\n3. KEEP BODY IN STRAIGHT LINE\\n4. LOWER CHEST TO FLOOR\\n5. PUSH UP POWERFULLY, CHAD STYLE!';

  @override
  String get pushupStandardMistakes =>
      '• BUTT STICKING UP - WEAKLING MOVE\\n• NOT LOWERING CHEST FULLY\\n• NECK FORWARD\\n• WRISTS AHEAD OF SHOULDERS\\n• INCONSISTENT TEMPO, FXXK IDIOT!';

  @override
  String get pushupStandardBreathing =>
      'INHALE DOWN, EXHALE UP POWERFULLY. BREATHING IS POWER!';

  @override
  String get pushupStandardChad =>
      '🔥 BASICS HARDEST? WRONG! ONE PERFECT FORM CONQUERS THE WORLD! MASTER THE BASICS! 🔥';

  @override
  String get pushupKneeName => 'KNEE PUSHUP';

  @override
  String get pushupKneeDesc =>
      'Beginners can do it too! Don\'t be ashamed of knee pushups!';

  @override
  String get pushupKneeBenefits =>
      '• BASIC STRENGTH IMPROVEMENT\\n• LEARN PROPER PUSHUP FORM\\n• SHOULDER AND ARM STABILITY\\n• PROGRESSION TO STANDARD PUSHUP';

  @override
  String get pushupKneeInstructions =>
      '1. START ON KNEES\\n2. LIFT ANKLES UP\\n3. UPPER BODY SAME AS STANDARD\\n4. STRAIGHT LINE FROM KNEES TO HEAD\\n5. MOVE SLOWLY AND SURELY!';

  @override
  String get pushupKneeMistakes =>
      '• BUTT SAGGING BACK\\n• KNEES TOO FAR FORWARD\\n• ONLY MOVING UPPER BODY\\n• MOVING TOO FAST';

  @override
  String get pushupKneeBreathing =>
      'SMOOTH, STEADY BREATHING TO START. DON\'T RUSH!';

  @override
  String get pushupKneeChad =>
      '⚡ BEGINNING IS HALF? NO! ALPHA JOURNEY ALREADY STARTED! KNEE PUSHUPS ARE EMPEROR\'S PATH TOO! ⚡';

  @override
  String get pushupInclineName => 'INCLINE PUSHUP';

  @override
  String get pushupInclineDesc =>
      'Use incline to adjust difficulty! Stairs or bench are enough!';

  @override
  String get pushupInclineBenefits =>
      '• REDUCED LOAD FOR FORM PERFECTION\\n• LOWER CHEST STRENGTHENING\\n• SHOULDER STABILITY\\n• BRIDGE TO STANDARD PUSHUP';

  @override
  String get pushupInclineInstructions =>
      '1. HANDS ON BENCH OR CHAIR\\n2. LEAN BODY AT ANGLE\\n3. STRAIGHT LINE TOE TO HEAD\\n4. HIGHER = EASIER\\n5. GRADUALLY GO LOWER!';

  @override
  String get pushupInclineMistakes =>
      '• BUTT STICKING UP\\n• TOO MUCH WEIGHT ON WRISTS\\n• UNSTABLE SUPPORT\\n• LOWERING ANGLE TOO QUICKLY';

  @override
  String get pushupInclineBreathing =>
      'COMFORTABLE BREATHING WITH EASIER ANGLE. BUT MAXIMUM FOCUS, YOU IDIOT!';

  @override
  String get pushupInclineChad =>
      '🚀 ADJUST HEIGHT, MAX INTENSITY! 20 PERFECT REPS = GOD TIER ENTRY TICKET! 🚀';

  @override
  String get pushupWideGripName => 'WIDE GRIP PUSHUP';

  @override
  String get pushupWideGripDesc =>
      'Spread wide for broader chest! Build that real chad chest!';

  @override
  String get pushupWideGripBenefits =>
      '• OUTER CHEST FOCUS\\n• SHOULDER STABILITY\\n• CHEST WIDTH EXPANSION\\n• OVERALL UPPER BODY BALANCE';

  @override
  String get pushupWideGripInstructions =>
      '1. HANDS 1.5X SHOULDER WIDTH\\n2. FINGERS SLIGHTLY OUTWARD\\n3. CHEST TO FLOOR\\n4. ELBOWS AT 45 DEGREES\\n5. PUSH WITH WIDE CHEST!';

  @override
  String get pushupWideGripMistakes =>
      '• HANDS TOO WIDE\\n• ELBOWS COMPLETELY OUT\\n• SHOULDER STRAIN\\n• NOT LOWERING CHEST ENOUGH';

  @override
  String get pushupWideGripBreathing =>
      'BREATHE DEEP WITH WIDE CHEST. FEEL THE EXPANSION, YOU IDIOT!';

  @override
  String get pushupWideGripChad =>
      '🦁 WIDE CHEST? NO! NOW LEGENDARY GORILLA CHEST! DOMINATE WORLD WITH WIDE GRIP! 🦁';

  @override
  String get pushupDiamondName => 'DIAMOND PUSHUP';

  @override
  String get pushupDiamondDesc =>
      'Focused triceps attack! Diamond shape is the symbol of real chad!';

  @override
  String get pushupDiamondBenefits =>
      '• TRICEPS FOCUS\\n• INNER CHEST DEVELOPMENT\\n• FULL ARM STRENGTH\\n• CORE STABILITY INCREASE';

  @override
  String get pushupDiamondInstructions =>
      '1. MAKE DIAMOND WITH THUMBS AND FINGERS\\n2. HANDS BELOW CHEST CENTER\\n3. ELBOWS CLOSE TO BODY\\n4. CHEST TO HANDS\\n5. PUSH WITH TRICEPS POWER!';

  @override
  String get pushupDiamondMistakes =>
      '• EXCESSIVE WRIST PRESSURE\\n• ELBOWS TOO WIDE\\n• BODY TWISTING\\n• INACCURATE DIAMOND SHAPE';

  @override
  String get pushupDiamondBreathing =>
      'FOCUSED BREATHING. FEEL THE TRICEPS BURN, YOU IDIOT!';

  @override
  String get pushupDiamondChad =>
      '💎 HARDER THAN DIAMOND ARMS? WRONG! NOW UNBREAKABLE TITANIUM ARMS! 10 REPS = REAL BEAST RECOGNITION! 💎';

  @override
  String get pushupDeclineName => 'DECLINE PUSHUP';

  @override
  String get pushupDeclineDesc =>
      'Raise feet for increased intensity! Properly stimulate shoulders and upper body!';

  @override
  String get pushupDeclineBenefits =>
      '• UPPER CHEST FOCUS\\n• FRONT SHOULDER STRENGTHENING\\n• MAXIMUM CORE STABILITY\\n• FULL BODY STRENGTH';

  @override
  String get pushupDeclineInstructions =>
      '1. FEET ON BENCH OR CHAIR\\n2. HANDS DIRECTLY UNDER SHOULDERS\\n3. STRAIGHT LINE ANGLED DOWN\\n4. OVERCOME GRAVITY\'S RESISTANCE\\n5. PUSH UP POWERFULLY!';

  @override
  String get pushupDeclineMistakes =>
      '• UNSTABLE FOOT POSITION\\n• BUTT SAGGING DOWN\\n• NECK STRAIN\\n• LOSING BALANCE';

  @override
  String get pushupDeclineBreathing =>
      'STABLE BREATHING WHILE FIGHTING GRAVITY. REAL POWER COMES FROM HERE, YOU IDIOT!';

  @override
  String get pushupDeclineChad =>
      '🌪️ IGNORE GRAVITY? SURE! NOW DOMINATE PHYSICS LAWS! DECLINE = GODLIKE SHOULDERS! 🌪️';

  @override
  String get pushupArcherName => 'ARCHER PUSHUP';

  @override
  String get pushupArcherDesc =>
      'Advanced technique focusing on one side! Requires balance and core!';

  @override
  String get pushupArcherBenefits =>
      '• ONE ARM FOCUS\\n• LEFT-RIGHT BALANCE\\n• ONE-ARM PUSHUP PREPARATION\\n• CORE ROTATIONAL STABILITY';

  @override
  String get pushupArcherInstructions =>
      '1. START WITH WIDE GRIP\\n2. LEAN WEIGHT TO ONE SIDE\\n3. ONE ARM BENT, OTHER STRAIGHT\\n4. PRECISE LIKE BOWSTRING\\n5. ALTERNATE BOTH SIDES!';

  @override
  String get pushupArcherMistakes =>
      '• BODY TWISTING\\n• FORCE IN STRAIGHT ARM\\n• UNEVEN LEFT-RIGHT MOVEMENT\\n• CORE SHAKING';

  @override
  String get pushupArcherBreathing =>
      'FOCUSED BREATHING LIKE DRAWING BOW. ACCURACY IS LIFE, YOU IDIOT!';

  @override
  String get pushupArcherChad =>
      '🏹 PRECISE ARCHER = ONE-ARM SHORTCUT? YES! MASTER BOTH SIDES = LEGENDARY ARCHER EMPEROR! 🏹';

  @override
  String get pushupPikeName => 'PIKE PUSHUP';

  @override
  String get pushupPikeDesc =>
      'Shoulder focused attack! Pre-stage to handstand pushups!';

  @override
  String get pushupPikeBenefits =>
      '• FULL SHOULDER STRENGTHENING\\n• HANDSTAND PUSHUP PREPARATION\\n• VERTICAL UPPER BODY POWER\\n• CORE AND BALANCE IMPROVEMENT';

  @override
  String get pushupPikeInstructions =>
      '1. START IN DOWNWARD DOG\\n2. BUTT AS HIGH AS POSSIBLE\\n3. HEAD CLOSE TO FLOOR\\n4. PUSH WITH SHOULDER POWER ONLY\\n5. MAINTAIN INVERTED TRIANGLE!';

  @override
  String get pushupPikeMistakes =>
      '• BUTT NOT HIGH ENOUGH\\n• ELBOWS OUT TO SIDES\\n• SUPPORTING WITH HEAD ONLY\\n• FEET TOO FAR OR CLOSE';

  @override
  String get pushupPikeBreathing =>
      'STABLE BREATHING IN INVERTED POSITION. FOCUS ON SHOULDERS, YOU IDIOT!';

  @override
  String get pushupPikeChad =>
      '⚡ PIKE MASTER = HANDSTAND? SURE! EVOLVE TO SHOULDER EMPEROR! ⚡';

  @override
  String get pushupClapName => 'CLAP PUSHUP';

  @override
  String get pushupClapDesc =>
      'Explosive power with clapping! Only real chads can do this!';

  @override
  String get pushupClapBenefits =>
      '• EXPLOSIVE STRENGTH DEVELOPMENT\\n• FULL BODY POWER\\n• INSTANT REACTION SPEED\\n• PROOF OF REAL CHAD';

  @override
  String get pushupClapInstructions =>
      '1. START IN STANDARD POSITION\\n2. EXPLODE UP\\n3. CLAP IN AIR\\n4. LAND SAFELY\\n5. TRY CONSECUTIVELY!';

  @override
  String get pushupClapMistakes =>
      '• NOT ENOUGH HEIGHT\\n• WRIST INJURY RISK ON LANDING\\n• FORM BREAKDOWN\\n• EXCESSIVE CONSECUTIVE ATTEMPTS';

  @override
  String get pushupClapBreathing =>
      'EXPLOSIVE EXHALE UP, QUICK BREATHING RESET AFTER LANDING. RHYTHM IS KEY, YOU IDIOT!';

  @override
  String get pushupClapChad =>
      '👏 CLAP PUSHUP = POWER PROOF? NO! NOW EXPLOSIVE THUNDER POWER EXPRESSION! 👏';

  @override
  String get pushupOneArmName => 'ONE-ARM PUSHUP';

  @override
  String get pushupOneArmDesc =>
      'One-arm pushup is the ultimate chad form! Do this even once and you\'re recognized as a real giga chad!';

  @override
  String get pushupOneArmBenefits =>
      '• ULTIMATE UPPER BODY STRENGTH\\n• PERFECT CORE CONTROL\\n• FULL BODY BALANCE AND COORDINATION\\n• GIGA CHAD COMPLETION';

  @override
  String get pushupOneArmInstructions =>
      '1. SPREAD LEGS WIDE FOR BALANCE\\n2. ONE HAND BEHIND BACK\\n3. FOCUS ALL POWER IN CORE\\n4. SLOW AND SURE\\n5. PROVE YOUR GIGA CHAD QUALIFICATION!';

  @override
  String get pushupOneArmMistakes =>
      '• LEGS TOO NARROW\\n• BODY TWISTING AND ROTATING\\n• SUPPORTING WITH OTHER HAND\\n• INJURY FROM EXCESSIVE ATTEMPT';

  @override
  String get pushupOneArmBreathing =>
      'DEEP, STABLE BREATHING FOR MAXIMUM FOCUS. UNITE ALL ENERGY, YOU IDIOT!';

  @override
  String get pushupOneArmChad =>
      '🚀 ONE-ARM = CHAD COMPLETION? WRONG! NOW ULTIMATE APEX GOD EMPEROR BIRTH, FXXK YEAH! 🚀';

  @override
  String get selectLevelButton => '🔥 CHOOSE YOUR LEVEL, FUTURE EMPEROR! 🔥';

  @override
  String startWithLevel(String level) {
    return '💥 START EMPEROR JOURNEY AS $level! 💥';
  }

  @override
  String profileCreated(int sessions) {
    return '🚀 EMPEROR PROFILE CREATION COMPLETE! ($sessions DOMINATION SESSIONS READY!) 🚀';
  }

  @override
  String profileCreationError(String error) {
    return '⚡ PROFILE CREATION FAILED! TRY AGAIN, ALPHA! ERROR: $error ⚡';
  }

  @override
  String get achievementFirstJourney => 'Chad Journey Begins';

  @override
  String get achievementFirstJourneyDesc => 'Complete your first pushup';

  @override
  String get achievementPerfectSet => 'Perfect First Set';

  @override
  String get achievementPerfectSetDesc =>
      'Complete a set achieving 100% of target';

  @override
  String get achievementCenturion => 'Centurion';

  @override
  String get achievementCenturionDesc => 'Achieve a total of 100 pushups';

  @override
  String get achievementWeekWarrior => 'Week Warrior';

  @override
  String get achievementWeekWarriorDesc => 'Work out for 7 consecutive days';

  @override
  String get achievementIronWill => 'Iron Will';

  @override
  String get achievementIronWillDesc => 'Achieved 200 pushups in one go';

  @override
  String get achievementSpeedDemon => 'Speed Demon';

  @override
  String get achievementSpeedDemonDesc =>
      'Completed 50 pushups in under 5 minutes';

  @override
  String get achievementPushupMaster => 'Pushup Master';

  @override
  String get achievementPushupMasterDesc => 'Achieve a total of 1000 pushups';

  @override
  String get achievementConsistency => 'King of Consistency';

  @override
  String get achievementConsistencyDesc => 'Work out for 30 consecutive days';

  @override
  String get achievementBeastMode => 'Beast Mode';

  @override
  String get achievementBeastModeDesc => 'Exceed target by 150%';

  @override
  String get achievementMarathoner => 'Marathoner';

  @override
  String get achievementMarathonerDesc => 'Achieve a total of 5000 pushups';

  @override
  String get achievementLegend => 'Legend';

  @override
  String get achievementLegendDesc => 'Achieve a total of 10000 pushups';

  @override
  String get chadSleepyCap => 'Sleepy Hat Chad';

  @override
  String get chadBasic => 'Basic Chad';

  @override
  String get chadCoffee => 'Coffee Chad';

  @override
  String get chadFrontFacing => 'Front Facing Chad';

  @override
  String get chadSunglasses => 'Sunglasses Chad';

  @override
  String get chadGlowingEyes => 'Glowing Eyes Chad';

  @override
  String get chadDouble => 'Double Chad';

  @override
  String get chadSleepyCapDesc =>
      'Starting your journey Chad.\nStill a bit sleepy but will wake up soon!';

  @override
  String get chadBasicDesc =>
      'Chad who completed the first evolution.\nStarted building basic stamina!';

  @override
  String get chadCoffeeDesc =>
      'Chad overflowing with energy.\nBecame stronger with the power of coffee!';

  @override
  String get chadFrontFacingDesc =>
      'Chad overflowing with confidence.\nFaces challenges head-on with determination!';

  @override
  String get chadSunglassesDesc =>
      'Chad with cool charm.\nShows off stylish appearance wearing sunglasses!';

  @override
  String get chadGlowingEyesDesc =>
      'Chad with incredible power.\nEyes glow with tremendous energy!';

  @override
  String get chadDoubleDesc =>
      'Legendary Chad who completed final evolution.\nConquers everything with double power!';

  @override
  String get todayMission => 'Today\'s Mission';

  @override
  String get todayTarget => 'Today\'s Target:';

  @override
  String weekDayFormat(int week, int day) {
    return 'Week $week Day $day';
  }

  @override
  String completedFormat(int totalReps, int totalSets) {
    return 'Completed: $totalReps reps / $totalSets sets';
  }

  @override
  String totalFormat(int reps, int sets) {
    return 'Total $reps reps ($sets sets)';
  }

  @override
  String get justWait => 'Today is recovery day. But the choice is yours.';

  @override
  String get perfectPushupForm => 'Perfect Pushup Form';

  @override
  String get progressTracking => 'Progress Tracking';

  @override
  String get achievementChallenge7DaysTitle =>
      '7 Days Streak Challenge Complete';

  @override
  String get achievementChallenge7DaysDesc =>
      'Completed 7 consecutive days workout challenge';

  @override
  String get achievementChallenge7DaysMotivation =>
      'Consistency is your greatest weapon!';

  @override
  String get achievementChallenge50SingleTitle =>
      '50 Single Session Challenge Complete';

  @override
  String get achievementChallenge50SingleDesc =>
      'Completed 50 pushups in one session challenge';

  @override
  String get achievementChallenge50SingleMotivation =>
      'You broke through your limits!';

  @override
  String get achievementChallenge100CumulativeTitle =>
      '100 Cumulative Challenge Complete';

  @override
  String get achievementChallenge100CumulativeDesc =>
      'Completed 100 cumulative pushups challenge';

  @override
  String get achievementChallenge100CumulativeMotivation =>
      'Small efforts create great results!';

  @override
  String get achievementChallenge200CumulativeTitle =>
      '200 Cumulative Challenge Complete';

  @override
  String get achievementChallenge200CumulativeDesc =>
      'Completed 200 cumulative pushups challenge';

  @override
  String get achievementChallenge200CumulativeMotivation =>
      'True champion performance!';

  @override
  String get achievementChallenge14DaysTitle =>
      '14 Days Streak Challenge Complete';

  @override
  String get achievementChallenge14DaysDesc =>
      'Completed 14 consecutive days workout challenge';

  @override
  String get achievementChallenge14DaysMotivation =>
      'You showed unbreakable willpower!';

  @override
  String get achievementChallengeMasterTitle => 'Challenge Master';

  @override
  String get achievementChallengeMasterDesc => 'Completed all challenges';

  @override
  String get achievementChallengeMasterMotivation =>
      'You are a true challenge master!';

  @override
  String get achievementNotificationChannelName => 'Achievement Notifications';

  @override
  String get achievementNotificationChannelDescription =>
      'Achievement unlock and progress notifications';

  @override
  String get achievementCompletionRate80Title => 'Excellent Completion Rate';

  @override
  String get achievementCompletionRate80Desc =>
      'Achieved average completion rate of 80% or higher';

  @override
  String get achievementCompletionRate80Motivation =>
      'Your consistent effort is bearing fruit!';

  @override
  String get achievementCompletionRate90Title => 'Perfectionist';

  @override
  String get achievementCompletionRate90Desc =>
      'Achieved average completion rate of 90% or higher';

  @override
  String get achievementCompletionRate90Motivation =>
      'You\'re showing near-perfect performance!';

  @override
  String get achievementCompletionRate95Title => 'Master Performer';

  @override
  String get achievementCompletionRate95Desc =>
      'Achieved average completion rate of 95% or higher';

  @override
  String get achievementCompletionRate95Motivation =>
      'You\'re demonstrating almost perfect performance ability!';

  @override
  String get achievementWorkoutTime60Title => '1 Hour Workout Achievement';

  @override
  String get achievementWorkoutTime60Desc =>
      'Achieved total workout time of 60 minutes';

  @override
  String get achievementWorkoutTime60Motivation =>
      'Your consistent workouts are accumulating!';

  @override
  String get achievementWorkoutTime300Title => '5 Hour Workout Master';

  @override
  String get achievementWorkoutTime300Desc =>
      'Achieved total workout time of 300 minutes (5 hours)';

  @override
  String get achievementWorkoutTime300Motivation =>
      'Your dedication to fitness is amazing!';

  @override
  String get backupCompletedTitle => 'Mission 100 Backup Complete';

  @override
  String backupCompletedBody(String size) {
    return 'Data has been successfully backed up ($size)';
  }

  @override
  String get backupFailedTitle => 'Mission 100 Backup Failed';

  @override
  String get backupFailedBody =>
      'An error occurred during backup. Please try again.';

  @override
  String get backupScheduleSuspendedTitle => 'Mission 100 Backup Suspended';

  @override
  String get backupScheduleSuspendedBody =>
      'Automatic backup has been suspended due to consecutive failures.';

  @override
  String get manualBackupCompletedTitle => 'Mission 100 Manual Backup Complete';

  @override
  String get manualBackupFailedTitle => 'Mission 100 Manual Backup Failed';

  @override
  String get manualBackupCompletedBody => 'Backup created successfully';

  @override
  String get manualBackupFailedBody => 'Error occurred during backup creation';

  @override
  String get autoBackupDisabledStatus => 'Automatic backup disabled';

  @override
  String get backupFailureStoppedStatus => 'Stopped due to backup failures';

  @override
  String get schedulerStoppedStatus => 'Scheduler stopped';

  @override
  String get backupWaitingStatus => 'Waiting for backup';

  @override
  String get workoutReminderDefaultBody =>
      '💪 MISSION 100 WORKOUT TIME! LEGENDARY CHAD MODE ACTIVATED! 💪';

  @override
  String get workoutAutoRenewalTitle => '⏰ Workout Reminder Auto Renewal';

  @override
  String get workoutAutoRenewalBody =>
      'Workout reminders have been automatically renewed. Keep up your healthy exercise habits! 💪';

  @override
  String workoutCompletionMessage(int percentage) {
    return '$percentage% OF TARGET DESTROYED! WALKING THE CHAD PATH! KEEP GRINDING! 🔥💪';
  }

  @override
  String get workoutRemindersChannelDescription => 'Weekly workout reminders';

  @override
  String get systemAutoRenewalChannelDescription =>
      'System auto renewal notifications';

  @override
  String get workoutCompletionChannelDescription =>
      'Workout completion celebration notifications';

  @override
  String get scientificFact3Title => 'mTOR Signaling Activation';

  @override
  String get scientificFact3Content =>
      'Push-ups activate mTOR signaling, the key to muscle growth, by 300%.';

  @override
  String get scientificFact3Impact =>
      '🚀 Muscle growth turbo engine is activated!';

  @override
  String get scientificFact3Explanation =>
      'mTOR is the master regulator of muscle protein synthesis, inducing explosive growth when activated.';

  @override
  String get scientificFact4Title => 'Permanence of Muscle Memory';

  @override
  String get scientificFact4Content =>
      'Once developed muscles maintain nuclear domains even after stopping exercise, enabling rapid recovery even after 10 years.';

  @override
  String get scientificFact4Impact =>
      '🧐 Eternal muscle memory is being carved!';

  @override
  String get scientificFact4Explanation =>
      'When muscle fiber nuclei increase, they become a lifelong template for muscle growth.';

  @override
  String get scientificFact5Title => 'Motor Unit Synchronization';

  @override
  String get scientificFact5Content =>
      'Push-up training improves motor unit synchronization by 70%, enabling explosive power output.';

  @override
  String get scientificFact5Impact =>
      '⚡ Perfect harmony between nerves and muscles!';

  @override
  String get scientificFact5Explanation =>
      'Synchronized motor units generate greater force more efficiently.';

  @override
  String get scientificFact6Title => 'Enhanced Neuroplasticity';

  @override
  String get scientificFact6Content =>
      'Regular push-ups increase motor cortex neuroplasticity by 45%, improving learning abilities.';

  @override
  String get scientificFact6Impact => '🧐 The brain is also evolving!';

  @override
  String get scientificFact6Explanation =>
      'Exercise-induced neuroplasticity increases lead to overall cognitive function improvements.';

  @override
  String get scientificFact7Title => 'Increased BDNF Secretion';

  @override
  String get scientificFact7Content =>
      'High-intensity push-ups increase Brain-Derived Neurotrophic Factor (BDNF) by up to 300%, improving brain health.';

  @override
  String get scientificFact7Impact =>
      '🌟 Brain youth recovery program activated!';

  @override
  String get scientificFact7Explanation =>
      'BDNF is called brain fertilizer and promotes new neural connections.';

  @override
  String get scientificFact8Title => 'Improved Reaction Speed';

  @override
  String get scientificFact8Content =>
      '6 weeks of push-up training improves nerve transmission speed by 15%, shortening reaction time.';

  @override
  String get scientificFact8Impact => '⚡ Lightning-fast reflexes acquired!';

  @override
  String get scientificFact8Explanation =>
      'Faster nerve transmission enables quick and accurate responses in daily life.';

  @override
  String get scientificFact9Title => 'Interneuron Activation';

  @override
  String get scientificFact9Content =>
      'Complex movement push-ups improve spinal interneuron inhibitory function by 25%, enhancing movement precision.';

  @override
  String get scientificFact9Impact =>
      '🎯 Perfect movement control system established!';

  @override
  String get scientificFact9Explanation =>
      'Precise interneuron control enables perfect posture even unconsciously.';

  @override
  String get scientificFact10Title => 'Increased Cardiac Output';

  @override
  String get scientificFact10Content =>
      'Regular push-ups increase cardiac output by 20%, improving systemic circulation.';

  @override
  String get scientificFact10Impact => '❤️ Powerful heart pump upgrade!';

  @override
  String get scientificFact10Explanation =>
      'Increased cardiac output improves not only exercise capacity but also quality of daily activities.';

  @override
  String get scientificFact11Title => 'Enhanced Angiogenesis';

  @override
  String get scientificFact11Content =>
      'Push-ups increase capillary density by 30%, improving oxygen supply to muscles and brain.';

  @override
  String get scientificFact11Impact => '🌊 Life highway expansion project!';

  @override
  String get scientificFact11Explanation =>
      'New blood vessel formation maximizes nutrient and oxygen supply.';

  @override
  String get scientificFact12Title => 'Blood Pressure Normalization';

  @override
  String get scientificFact12Content =>
      '12 weeks of push-up program reduces systolic blood pressure by an average of 8mmHg.';

  @override
  String get scientificFact12Impact =>
      '📉 Natural blood pressure normalization!';

  @override
  String get scientificFact12Explanation =>
      'Improved vascular elasticity and reduced peripheral resistance maintain healthy blood pressure.';

  @override
  String get scientificFact13Title => 'Improved Heart Rate Variability';

  @override
  String get scientificFact13Content =>
      'Regular push-ups improve heart rate variability by 35%, increasing stress resistance.';

  @override
  String get scientificFact13Impact => '💎 Diamond-like heart rhythm!';

  @override
  String get scientificFact13Explanation =>
      'High heart rate variability indicates healthy autonomic nervous system balance.';

  @override
  String get scientificFact14Title => 'Improved Endothelial Function';

  @override
  String get scientificFact14Content =>
      'High-intensity push-ups improve vascular endothelial function by 25%, promoting vascular health.';

  @override
  String get scientificFact14Impact => '✨ Vascular youth recovery!';

  @override
  String get scientificFact14Explanation =>
      'Healthy endothelial cells prevent cardiovascular disease through vasodilation and anti-inflammatory actions.';

  @override
  String get scientificFact15Title => 'Increased Basal Metabolic Rate';

  @override
  String get scientificFact15Content =>
      'Resistance exercise push-ups increase basal metabolic rate by 15%, boosting 24-hour calorie burn.';

  @override
  String get scientificFact15Impact => '🔥 24-hour fat burning system!';

  @override
  String get scientificFact15Explanation =>
      'Increased muscle mass burns more energy even at rest.';

  @override
  String get scientificFact16Title => 'Improved Insulin Sensitivity';

  @override
  String get scientificFact16Content =>
      '8 weeks of push-up training improves insulin sensitivity by 40%, enhancing blood sugar control.';

  @override
  String get scientificFact16Impact => '📊 Perfect blood sugar control system!';

  @override
  String get scientificFact16Explanation =>
      'Increased muscle glucose uptake enables natural blood sugar management.';

  @override
  String get scientificFact17Title => 'Enhanced Fat Oxidation';

  @override
  String get scientificFact17Content =>
      'Push-ups increase fat oxidation enzyme activity by 50%, accelerating body fat reduction.';

  @override
  String get scientificFact17Impact => '🔥 Fat-burning turbo engine!';

  @override
  String get scientificFact17Explanation =>
      'Increased enzyme activity allows fat to be used more efficiently as an energy source.';

  @override
  String get scientificFact18Title => 'Brown Fat Activation';

  @override
  String get scientificFact18Content =>
      'High-intensity exercise activates brown fat to increase calorie burn through heat generation.';

  @override
  String get scientificFact18Impact => '♨️ Internal heating system activated!';

  @override
  String get scientificFact18Explanation =>
      'Brown fat directly converts calories to heat, helping with weight loss.';

  @override
  String get scientificFact19Title => 'Post-Exercise Oxygen Consumption';

  @override
  String get scientificFact19Content =>
      'High-intensity push-ups increase oxygen consumption for up to 24 hours after exercise, burning additional calories.';

  @override
  String get scientificFact19Impact => '🌪️ 24-hour afterburn effect!';

  @override
  String get scientificFact19Explanation =>
      'EPOC effect causes continuous energy expenditure even after exercise ends.';

  @override
  String get scientificFact20Title => 'Growth Hormone Surge';

  @override
  String get scientificFact20Content =>
      'High-intensity push-ups increase growth hormone secretion by up to 500%, promoting muscle growth and recovery.';

  @override
  String get scientificFact20Impact => '🚀 Youth hormone explosion!';

  @override
  String get scientificFact20Explanation =>
      'Growth hormone is the key hormone for muscle growth, fat breakdown, and tissue recovery.';

  @override
  String get scientificFact21Title => 'Motor Unit Synchronization';

  @override
  String get scientificFact21Content =>
      'Push-up training improves motor unit synchronization by 70%, enabling explosive power generation.';

  @override
  String get scientificFact21Impact =>
      '⚡ Perfect harmony between nerves and muscles!';

  @override
  String get scientificFact21Explanation =>
      'Synchronized motor units generate greater force more efficiently.';

  @override
  String get scientificFact22Title => 'Enhanced Neuroplasticity';

  @override
  String get scientificFact22Content =>
      'Regular push-ups increase motor cortex neuroplasticity by 45%, improving learning ability.';

  @override
  String get scientificFact22Impact => '🧠 Your brain is evolving too!';

  @override
  String get scientificFact22Explanation =>
      'Exercise-induced neuroplasticity enhances overall cognitive function.';

  @override
  String get scientificFact23Title => 'Increased BDNF Secretion';

  @override
  String get scientificFact23Content =>
      'High-intensity push-ups increase brain-derived neurotrophic factor (BDNF) by up to 300%, improving brain health.';

  @override
  String get scientificFact23Impact =>
      '🌟 Brain rejuvenation program activated!';

  @override
  String get scientificFact23Explanation =>
      'BDNF is called brain fertilizer and promotes new neural connections.';

  @override
  String get scientificFact24Title => 'Improved Reaction Speed';

  @override
  String get scientificFact24Content =>
      '6 weeks of push-up training improves neural conduction velocity by 15%, shortening reaction time.';

  @override
  String get scientificFact24Impact => '⚡ Lightning-fast reflexes acquired!';

  @override
  String get scientificFact24Explanation =>
      'Increased myelin sheath thickness accelerates neural signal transmission.';

  @override
  String get scientificFact25Title => 'Interneuron Activation';

  @override
  String get scientificFact25Content =>
      'Complex push-up exercises improve spinal interneuron inhibitory function by 25%, enhancing movement precision.';

  @override
  String get scientificFact25Impact =>
      '🎯 Perfect movement control system established!';

  @override
  String get scientificFact25Explanation =>
      'Precise interneuron control enables perfect posture even unconsciously.';

  @override
  String get achievementPerfectionist => 'Perfectionist';

  @override
  String get achievementPerfectionistDesc => 'Achieve 10 perfect sets';

  @override
  String get achievementEarlyBird => 'Early Bird';

  @override
  String get achievementEarlyBirdDesc => 'Worked out 5 times before 7 AM';

  @override
  String get achievementNightOwl => 'Night Owl';

  @override
  String get achievementNightOwlDesc => 'Worked out 5 times after 10 PM';

  @override
  String get achievementOverachiever => 'Overachiever';

  @override
  String get achievementOverachieverDesc => 'Achieved 150% of goal 5 times';

  @override
  String get achievementEndurance => 'Endurance King';

  @override
  String get achievementEnduranceDesc => 'Work out for over 30 minutes';

  @override
  String get achievementVariety => 'Master of Variety';

  @override
  String get achievementVarietyDesc => 'Complete 5 different pushup types';

  @override
  String get achievementDedication => 'Dedication';

  @override
  String get achievementDedicationDesc => 'Work out for 100 consecutive days';

  @override
  String get achievementUltimate => 'Ultimate Chad';

  @override
  String get achievementUltimateDesc => 'Achieve all achievements';

  @override
  String get achievementGodMode => 'God Mode';

  @override
  String get achievementGodModeDesc => 'Achieve over 500 reps in one session';

  @override
  String get achievementRarityCommon => 'Common';

  @override
  String get achievementRarityRare => 'Rare';

  @override
  String get achievementRarityEpic => 'Epic';

  @override
  String get achievementRarityLegendary => 'Legendary';

  @override
  String get achievementRarityMythic => 'Mythic';

  @override
  String get home => 'Home';

  @override
  String get calendar => 'Calendar';

  @override
  String get achievements => 'Achievements';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get chadShorts => 'Chad Shorts 🔥';

  @override
  String get settingsTitle => '⚙️ Chad Settings';

  @override
  String get settingsSubtitle => 'Customize your Chad journey';

  @override
  String get workoutSettings => '💪 Workout Settings';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get appearanceSettings => 'Appearance Settings';

  @override
  String get dataSettings => '💾 Data Management';

  @override
  String get aboutSettings => 'ℹ️ App Info';

  @override
  String get difficultySettings => 'Difficulty Settings';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsDesc => 'Receive all app notifications';

  @override
  String get achievementNotifications => 'Achievement Notifications';

  @override
  String get achievementNotificationsDesc =>
      'Get notified when you unlock new achievements';

  @override
  String get workoutReminders => 'Workout Reminders';

  @override
  String get workoutRemindersDesc => 'Daily reminders at your set time';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get reminderTimeDesc => 'Set the time for workout notifications';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDesc => 'Use dark theme';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get dataBackup => 'Data Backup';

  @override
  String get dataBackupDesc => 'Backup your workout records and achievements';

  @override
  String get dataRestore => 'Data Restore';

  @override
  String get dataRestoreDesc => 'Restore backed up data';

  @override
  String get dataReset => 'Data Reset';

  @override
  String get dataResetDesc => 'Delete all data';

  @override
  String get versionInfo => 'Version Info';

  @override
  String get versionInfoDesc => 'Mission: 100 v1.0.0';

  @override
  String get developerInfo => 'Developer Info';

  @override
  String get developerInfoDesc => 'Join the journey to become Chad';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get sendFeedbackDesc => 'Share your thoughts with us';

  @override
  String unlockedAchievements(int count) {
    return 'Unlocked Achievements ($count)';
  }

  @override
  String lockedAchievements(int count) {
    return 'Locked Achievements ($count)';
  }

  @override
  String get noAchievementsYet => 'No achievements yet';

  @override
  String get startWorkoutForAchievements =>
      'Start working out to unlock your first achievement!';

  @override
  String get allAchievementsUnlocked => 'All achievements unlocked!';

  @override
  String get congratulationsChad => 'Congratulations! You are a true Chad! 🎉';

  @override
  String get achievementsBannerText =>
      'Unlock achievements and become a Chad! 🏆';

  @override
  String get totalExperience => 'Total XP';

  @override
  String get noWorkoutRecords => 'No workout records yet!';

  @override
  String get startFirstWorkout =>
      'Start your first workout and\\ncreate your Chad legend! 🔥';

  @override
  String get loadingStatistics => 'Loading Chad\'s statistics...';

  @override
  String get totalWorkouts => 'Total Workouts';

  @override
  String workoutCount(int count) {
    return '$count times';
  }

  @override
  String get chadDays => 'Chad days!';

  @override
  String get totalPushups => 'Total Pushups';

  @override
  String pushupsCount(int count) {
    return '$count reps';
  }

  @override
  String get realChadPower => 'Real Chad power!';

  @override
  String get averageCompletion => 'Average Completion';

  @override
  String completionPercentage(int percentage) {
    return '$percentage%';
  }

  @override
  String get perfectExecution => 'Perfect execution!';

  @override
  String get thisMonthWorkouts => 'This Month';

  @override
  String get consistentChad => 'Consistent Chad!';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String streakDays(int days) {
    return '$days days';
  }

  @override
  String get recentWorkouts => 'Recent Workouts';

  @override
  String repsAchieved(int reps, int percentage) {
    return '$reps reps • $percentage% achieved';
  }

  @override
  String get checkChadGrowth => 'Check Chad\'s growth! 📊';

  @override
  String workoutRecordForDate(int month, int day) {
    return '$month/$day Workout Record';
  }

  @override
  String get noWorkoutRecordForDate => 'No workout record for this date';

  @override
  String get calendarBannerText => 'Consistency is Chad power! 📅';

  @override
  String workoutHistoryLoadError(String error) {
    return 'Error loading workout history: $error';
  }

  @override
  String get completed => 'Complete!';

  @override
  String get current => 'Current';

  @override
  String get half => 'Half';

  @override
  String get exceed => 'Exceed';

  @override
  String get target => 'Target';

  @override
  String get todaysGoal => 'Today\'s Goal';

  @override
  String get select => 'Select';

  @override
  String get selected => 'Selected';

  @override
  String get next => 'Next';

  @override
  String get complete => 'Complete';

  @override
  String get workoutProcessing => 'Processing workout completion...';

  @override
  String get createBackup => 'Create Backup';

  @override
  String get encryptedBackup => 'Encrypted Backup';

  @override
  String get exportToFile => 'Export to File';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String get autoBackup => 'Auto Backup';

  @override
  String get autoBackupDescription => 'Performs automatic backup regularly';

  @override
  String get backupFrequency => 'Backup Frequency';

  @override
  String get lastBackup => 'Last Backup';

  @override
  String get noBackupRecord => 'No Backup Record';

  @override
  String get noBackupCreated => 'No backup has been created yet';

  @override
  String get selectBackupFrequency => 'Select Backup Frequency';

  @override
  String get loadingChadVideos => 'Loading Chad videos... 🔥';

  @override
  String videoLoadError(String error) {
    return 'Error loading videos: $error';
  }

  @override
  String get tryAgain => 'Try Again';

  @override
  String get like => 'Like';

  @override
  String get share => 'Share';

  @override
  String get save => 'Save';

  @override
  String get workout => 'Workout';

  @override
  String get likeMessage => 'Liked! 💪';

  @override
  String get shareMessage => 'Sharing 📤';

  @override
  String get saveMessage => 'Saved 📌';

  @override
  String get workoutStartMessage => 'Workout started! 🔥';

  @override
  String get swipeUpHint => 'Swipe up for next video';

  @override
  String get pushupHashtag => '#Pushup';

  @override
  String get chadHashtag => '#Chad';

  @override
  String get pushupVariations => 'Pushup Variations 🔥';

  @override
  String get chadSecrets => 'Chad Secrets ⚡';

  @override
  String get pushup100Challenge => '100 Pushup Challenge 🎯';

  @override
  String get homeWorkoutPushups => 'Home Workout Pushups 🏠';

  @override
  String get strengthSecrets => 'Strength Secrets 💯';

  @override
  String get correctPushupFormDesc =>
      'Effective workout with proper pushup form';

  @override
  String get variousPushupStimulation =>
      'Stimulate muscles with various pushup variations';

  @override
  String get trueChadMindset => 'Mindset to become a true Chad';

  @override
  String get challengeSpirit100 => 'Challenge spirit towards 100 pushups';

  @override
  String get perfectHomeWorkout => 'Perfect workout you can do at home';

  @override
  String get consistentStrengthImprovement =>
      'Improve strength through consistent exercise';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get korean => 'Korean';

  @override
  String get english => 'English';

  @override
  String get chest => 'Chest';

  @override
  String get triceps => 'Triceps';

  @override
  String get shoulders => 'Shoulders';

  @override
  String get core => 'Core';

  @override
  String get fullBody => 'Full Body';

  @override
  String get restTimeSettings => 'Rest Time Settings';

  @override
  String get restTimeDesc => 'Set rest time between sets';

  @override
  String get soundSettings => 'Sound Settings';

  @override
  String get soundSettingsDesc => 'Enable workout sound effects';

  @override
  String get vibrationSettings => 'Vibration Settings';

  @override
  String get vibrationSettingsDesc => 'Enable vibration feedback';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get dataManagementDesc => '운동 기록 백업 및 복원';

  @override
  String get appInfo => 'App Information';

  @override
  String get appInfoDesc => '버전 정보 및 개발자 정보';

  @override
  String get seconds => 'seconds';

  @override
  String get minutes => 'minutes';

  @override
  String get motivationMessages => 'Motivation Messages';

  @override
  String get motivationMessagesDesc =>
      'Show motivational messages during workout';

  @override
  String get autoStartNextSet => 'Auto Start Next Set';

  @override
  String get autoStartNextSetDesc => 'Automatically start next set after rest';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDesc =>
      'Check privacy protection and processing policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceDesc => 'Check terms of service for app usage';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get openSourceLicensesDesc => 'View open source licenses';

  @override
  String get resetConfirmTitle => 'Reset All Data';

  @override
  String get resetConfirmMessage =>
      'Are you sure you want to delete all data? This action cannot be undone.';

  @override
  String get dataResetConfirm => 'Data Reset Confirmation';

  @override
  String get dataResetComingSoon => 'Data reset feature is coming soon';

  @override
  String get resetSuccess => 'All data has been reset successfully';

  @override
  String get backupSuccess => 'Data backup completed successfully';

  @override
  String get restoreSuccess => 'Data restore completed successfully';

  @override
  String get selectTime => 'Select Time';

  @override
  String currentDifficulty(String difficulty, String description) {
    return 'Current: $difficulty - $description';
  }

  @override
  String currentLanguage(String language) {
    return 'Current: $language';
  }

  @override
  String get darkModeEnabled => 'Dark mode enabled';

  @override
  String get lightModeEnabled => 'Light mode enabled';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language!';
  }

  @override
  String difficultyChanged(String difficulty) {
    return 'Difficulty changed to $difficulty!';
  }

  @override
  String get dataBackupComingSoon => 'Data backup feature is coming soon';

  @override
  String get dataRestoreComingSoon => 'Data restore feature is coming soon';

  @override
  String get feedbackComingSoon => 'Feedback feature coming soon!';

  @override
  String reminderTimeChanged(String time) {
    return 'Reminder time has been changed to $time';
  }

  @override
  String get notificationPermissionMessage =>
      'Notification permission is required to receive push notifications.';

  @override
  String get notificationPermissionFeatures =>
      '• Workout reminders\n• Achievement notifications\n• Motivational messages';

  @override
  String get notificationPermissionRequest =>
      'Please allow notification permission in settings.';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get comingSoon => '🚀 Coming Soon';

  @override
  String get difficultySettingsTitle => '💪 Difficulty Settings';

  @override
  String get notificationPermissionGranted =>
      '✅ Notification permission granted!';

  @override
  String get settingsBannerText => 'Customize Chad\'s settings! ⚙️';

  @override
  String buildInfo(String buildNumber) {
    return 'Build: $buildNumber';
  }

  @override
  String versionAndBuild(String version, String buildNumber) {
    return 'Version $version+$buildNumber';
  }

  @override
  String get madeWithLove => 'Made with ❤️ for Chad';

  @override
  String get joinChadJourney => 'Join the journey to become Chad';

  @override
  String get supportChadJourney => 'Support your Chad journey! 🔥';

  @override
  String get selectLanguage => 'Please select a language to use';

  @override
  String get progress => 'Progress';

  @override
  String get description => 'Description';

  @override
  String get koreanLanguage => 'Korean';

  @override
  String get englishLanguage => 'English';

  @override
  String get notificationPermissionGrantedMessage =>
      '🎉 Notification permission granted! Start your Chad journey!';

  @override
  String get notificationPermissionDeniedMessage =>
      '⚠️ Notification permission is required. Please allow it in settings.';

  @override
  String get notificationPermissionErrorMessage =>
      'An error occurred while requesting permission.';

  @override
  String get notificationPermissionLaterMessage =>
      'You can allow notifications later in settings.';

  @override
  String get permissionsRequired => '🔐 Permissions Required';

  @override
  String get permissionsDescription =>
      'Mission 100 needs the following permissions\nfor the best experience:';

  @override
  String get notificationPermissionTitle => '🔔 Notification Permission';

  @override
  String get notificationPermissionDesc =>
      'Required for workout reminders and achievement notifications';

  @override
  String get storagePermissionTitle => '📁 Storage Permission';

  @override
  String get storagePermissionDesc =>
      'Required for backing up and restoring workout data';

  @override
  String get allowPermissions => 'Allow Permissions';

  @override
  String get skipPermissions => 'Set Up Later';

  @override
  String get permissionBenefits => 'With these permissions, you can:';

  @override
  String get notificationBenefit1 => '💪 Daily workout reminders';

  @override
  String get notificationBenefit2 => '🏆 Achievement celebration alerts';

  @override
  String get notificationBenefit3 => '🔥 Motivational messages';

  @override
  String get storageBenefit1 => '📁 Secure workout data backup';

  @override
  String get storageBenefit2 => '🔄 Data restoration when changing devices';

  @override
  String get storageBenefit3 => '💾 Prevent data loss';

  @override
  String get permissionAlreadyRequested =>
      'Permissions have already been requested.\nPlease allow them manually in settings.';

  @override
  String get videoCannotOpen =>
      'Cannot open video. Please check your YouTube app.';

  @override
  String get advertisement => 'Advertisement';

  @override
  String get chadLevel => 'Chad Level';

  @override
  String get progressVisualization => 'Progress Visualization';

  @override
  String get weeklyGoal => 'Weekly Goal';

  @override
  String get monthlyGoal => 'Monthly Goal';

  @override
  String get streakProgress => 'Streak Progress';

  @override
  String get workoutChart => 'Workout Chart';

  @override
  String get days => 'days';

  @override
  String get monthlyProgress => 'Monthly Progress';

  @override
  String get thisMonth => 'This Month';

  @override
  String get noWorkoutThisDay => 'No workout records for this day';

  @override
  String get legend => 'Legend';

  @override
  String get perfect => 'Perfect!';

  @override
  String get good => 'Good';

  @override
  String get okay => 'Okay';

  @override
  String get poor => 'Poor';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get times => 'times';

  @override
  String get count => 'count';

  @override
  String get noWorkoutHistory => 'No workout history';

  @override
  String get noChartData => 'No chart data available';

  @override
  String get noPieChartData => 'No pie chart data available';

  @override
  String get month => 'month';

  @override
  String get streakEncouragement => 'Streak Encouragement';

  @override
  String get streakEncouragementSubtitle =>
      'Encouragement message after 3 consecutive workouts';

  @override
  String get notificationSetupFailed => 'Failed to set up notification';

  @override
  String get streakNotificationSet =>
      'Streak encouragement notification has been set!';

  @override
  String dailyNotificationSet(Object time) {
    return 'Daily workout reminder set for $time!';
  }

  @override
  String get dailyReminderSubtitle => 'Daily workout reminder at set time';

  @override
  String get adFallbackMessage => 'Join the journey to become a Chad! 💪';

  @override
  String get testAdMessage => 'Test Ad - Fitness App';

  @override
  String get achievementCelebrationMessage => 'Feel the power of Chad! 💪';

  @override
  String get workoutScreenAdMessage => 'Feel the power of Chad! 💪';

  @override
  String get achievementScreenAdMessage => 'Achieve and become Chad! 🏆';

  @override
  String get tutorialAdviceBasic => 'Basics are the most important, bro!';

  @override
  String get tutorialAdviceStart => 'Starting is half the battle!';

  @override
  String get tutorialAdviceForm => 'Perfect form makes perfect Chad!';

  @override
  String get tutorialAdviceConsistency =>
      'Consistency is the key to Chad power!';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String dateFormatYearMonthDay(int year, int month, int day) {
    return '$month/$day/$year';
  }

  @override
  String get rarityCommon => 'Common';

  @override
  String get rarityRare => 'Rare';

  @override
  String get rarityEpic => 'Epic';

  @override
  String get rarityLegendary => 'Legendary';

  @override
  String get achievementUltimateMotivation => 'You are the ultimate Chad! 🌟';

  @override
  String get achievementFirst50Title => 'First 50 Breakthrough';

  @override
  String get achievementFirst50Desc =>
      'Achieved 50 pushups in a single workout';

  @override
  String get achievementFirst50Motivation =>
      '50 breakthrough! Chad\'s foundation is getting solid! 🎊';

  @override
  String get achievementFirst100SingleTitle => '100 in One Go';

  @override
  String get achievementFirst100SingleDesc =>
      'Achieved 100 pushups in a single workout';

  @override
  String get achievementFirst100SingleMotivation =>
      '100 in one go! True power Chad! 💥';

  @override
  String get achievementStreak3Title => '3-Day Streak Chad';

  @override
  String get achievementStreak3Desc =>
      'Completed workouts for 3 consecutive days';

  @override
  String get achievementStreak3Motivation => 'Consistency makes a Chad! 🔥';

  @override
  String get achievementStreak7Title => 'Weekly Chad';

  @override
  String get achievementStreak7Desc =>
      'Completed workouts for 7 consecutive days';

  @override
  String get achievementStreak7Motivation =>
      'True Chad who conquered the week! 💪';

  @override
  String get achievementStreak14Title => '2-Week Marathon Chad';

  @override
  String get achievementStreak14Desc =>
      'Completed workouts for 14 consecutive days';

  @override
  String get achievementStreak14Motivation =>
      'King of persistence! Chad among Chads! 🏃‍♂️';

  @override
  String get achievementStreak30Title => 'Monthly Ultimate Chad';

  @override
  String get achievementStreak30Desc =>
      'Completed workouts for 30 consecutive days';

  @override
  String get achievementStreak30Motivation =>
      'You are now the King of Chads! 👑';

  @override
  String get achievementStreak60Title => '2-Month Legend Chad';

  @override
  String get achievementStreak60Desc =>
      'Completed workouts for 60 consecutive days';

  @override
  String get achievementStreak60Motivation =>
      '2 months straight! You are a legend! 🏅';

  @override
  String get achievementStreak100Title => '100-Day Mythical Chad';

  @override
  String get achievementStreak100Desc =>
      'Completed workouts for 100 consecutive days';

  @override
  String get achievementStreak100Motivation =>
      '100 days straight! You are a living myth! 🌟';

  @override
  String get achievementTotal50Title => 'First 50 Total';

  @override
  String get achievementTotal50Desc => 'Completed a total of 50 pushups';

  @override
  String get achievementTotal50Motivation =>
      'First 50! Chad\'s sprout is growing! 🌱';

  @override
  String get achievementTotal100Title => 'First 100 Breakthrough';

  @override
  String get achievementTotal100Desc => 'Completed a total of 100 pushups';

  @override
  String get achievementTotal100Motivation =>
      'First 100 breakthrough! Chad\'s foundation complete! 💯';

  @override
  String get achievementTotal250Title => '250 Chad';

  @override
  String get achievementTotal250Desc => 'Completed a total of 250 pushups';

  @override
  String get achievementTotal250Motivation => '250! Result of consistency! 🎯';

  @override
  String get achievementTotal500Title => '500 Chad';

  @override
  String get achievementTotal500Desc => 'Completed a total of 500 pushups';

  @override
  String get achievementTotal500Motivation =>
      '500 breakthrough! Intermediate Chad achieved! 🚀';

  @override
  String get achievementTotal1000Title => '1000 Mega Chad';

  @override
  String get achievementTotal1000Desc => 'Completed a total of 1000 pushups';

  @override
  String get achievementTotal1000Motivation =>
      '1000 breakthrough! Mega Chad achieved! ⚡';

  @override
  String get achievementTotal2500Title => '2500 Super Chad';

  @override
  String get achievementTotal2500Desc => 'Completed a total of 2500 pushups';

  @override
  String get achievementTotal2500Motivation =>
      '2500! Reached the realm of Super Chad! 🔥';

  @override
  String get achievementTotal5000Title => '5000 Ultra Chad';

  @override
  String get achievementTotal5000Desc => 'Completed a total of 5000 pushups';

  @override
  String get achievementTotal5000Motivation =>
      '5000! You are an Ultra Chad! 🌟';

  @override
  String get achievementTotal10000Title => '10000 God Chad';

  @override
  String get achievementTotal10000Desc => 'Completed a total of 10000 pushups';

  @override
  String get achievementTotal10000Motivation =>
      '10000! You are the God of Chads! 👑';

  @override
  String get achievementPerfect3Title => 'Perfect Triple';

  @override
  String get achievementPerfect3Desc => 'Achieved 3 perfect workouts';

  @override
  String get achievementPerfect3Motivation =>
      'Perfect triple! Chad of accuracy! 🎯';

  @override
  String get achievementPerfect5Title => 'Perfectionist Chad';

  @override
  String get achievementPerfect5Desc => 'Achieved 5 perfect workouts';

  @override
  String get achievementPerfect5Motivation =>
      'True Chad who pursues perfection! ⭐';

  @override
  String get achievementPerfect10Title => 'Master Chad';

  @override
  String get achievementPerfect10Desc => 'Achieved 10 perfect workouts';

  @override
  String get achievementPerfect10Motivation =>
      'Master of perfection! Chad among Chads! 🏆';

  @override
  String get achievementPerfect20Title => 'Perfect Legend';

  @override
  String get achievementPerfect20Desc => 'Achieved 20 perfect workouts';

  @override
  String get achievementPerfect20Motivation =>
      '20 perfects! You are the embodiment of perfection! 💎';

  @override
  String get achievementTutorialExplorerTitle => 'Exploring Chad';

  @override
  String get achievementTutorialExplorerDesc =>
      'Checked the first pushup tutorial';

  @override
  String get achievementTutorialExplorerMotivation =>
      'Knowledge is Chad\'s first power! 🔍';

  @override
  String get achievementTutorialStudentTitle => 'Learning Chad';

  @override
  String get achievementTutorialStudentDesc => 'Checked 5 pushup tutorials';

  @override
  String get achievementTutorialStudentMotivation =>
      'True Chad learning various techniques! 📚';

  @override
  String get achievementTutorialMasterTitle => 'Pushup Master';

  @override
  String get achievementTutorialMasterDesc => 'Checked all pushup tutorials';

  @override
  String get achievementTutorialMasterMotivation =>
      'Pushup doctor who mastered all techniques! 🎓';

  @override
  String get achievementEarlyBirdTitle => 'Dawn Chad';

  @override
  String get achievementEarlyBirdMotivation =>
      'Early bird Chad who conquered the dawn! 🌅';

  @override
  String get achievementNightOwlTitle => 'Nocturnal Chad';

  @override
  String get achievementNightOwlMotivation =>
      'Owl Chad who never gives up even at night! 🦉';

  @override
  String get achievementWeekendWarriorTitle => 'Weekend Warrior';

  @override
  String get achievementWeekendWarriorDesc =>
      'Chad who consistently works out on weekends';

  @override
  String get achievementWeekendWarriorMotivation =>
      'Warrior who doesn\'t stop even on weekends! ⚔️';

  @override
  String get achievementLunchBreakTitle => 'Lunch Break Chad';

  @override
  String get achievementLunchBreakDesc =>
      'Worked out 5 times during lunch break (12-2 PM)';

  @override
  String get achievementLunchBreakMotivation =>
      'Efficient Chad who doesn\'t miss lunch break! 🍽️';

  @override
  String get achievementSpeedDemonTitle => 'Speed Demon';

  @override
  String get achievementSpeedDemonMotivation =>
      'Lightning speed! Chad of speed! 💨';

  @override
  String get achievementEnduranceKingTitle => 'King of Endurance';

  @override
  String get achievementEnduranceKingDesc =>
      'Sustained workout for over 30 minutes';

  @override
  String get achievementEnduranceKingMotivation =>
      '30 minutes sustained! King of endurance! ⏰';

  @override
  String get achievementComebackKidTitle => 'Comeback Kid';

  @override
  String get achievementComebackKidDesc =>
      'Restarted workout after resting for 7+ days';

  @override
  String get achievementComebackKidMotivation =>
      'Never-give-up spirit! Comeback Chad! 🔄';

  @override
  String get achievementOverachieverTitle => 'Overachiever';

  @override
  String get achievementOverachieverMotivation =>
      'Overachiever who surpasses goals! 📈';

  @override
  String get achievementDoubleTroubleTitle => 'Double Trouble';

  @override
  String get achievementDoubleTroubleDesc => 'Achieved 200% of goal';

  @override
  String get achievementDoubleTroubleMotivation =>
      'Double the goal! Double Trouble Chad! 🎪';

  @override
  String get achievementConsistencyMasterTitle => 'Master of Consistency';

  @override
  String get achievementConsistencyMasterDesc =>
      'Achieved goal exactly for 10 consecutive days';

  @override
  String get achievementConsistencyMasterMotivation =>
      'Precise goal achievement! Master of consistency! 🎯';

  @override
  String get achievementLevel5Title => 'Level 5 Chad';

  @override
  String get achievementLevel5Desc => 'Reached level 5';

  @override
  String get achievementLevel5Motivation =>
      'Level 5 achieved! Beginning of intermediate Chad! 🌟';

  @override
  String get achievementLevel10Title => 'Level 10 Chad';

  @override
  String get achievementLevel10Desc => 'Reached level 10';

  @override
  String get achievementLevel10Motivation =>
      'Level 10! Realm of advanced Chad! 🏅';

  @override
  String get achievementLevel20Title => 'Level 20 Chad';

  @override
  String get achievementLevel20Desc => 'Reached level 20';

  @override
  String get achievementLevel20Motivation => 'Level 20! King among Chads! 👑';

  @override
  String get achievementMonthlyWarriorTitle => 'Monthly Warrior';

  @override
  String get achievementMonthlyWarriorDesc => 'Worked out 20+ days in a month';

  @override
  String get achievementMonthlyWarriorMotivation =>
      '20 days a month! Monthly warrior Chad! 📅';

  @override
  String get achievementSeasonalChampionTitle => 'Seasonal Champion';

  @override
  String get achievementSeasonalChampionDesc =>
      'Achieved monthly goals for 3 consecutive months';

  @override
  String get achievementSeasonalChampionMotivation =>
      '3 months straight! Seasonal champion! 🏆';

  @override
  String get achievementVarietySeekerTitle => 'Variety Seeker';

  @override
  String get achievementVarietySeekerDesc => 'Tried 5 different pushup types';

  @override
  String get achievementVarietySeekerMotivation =>
      'Creative Chad seeking variety! 🎨';

  @override
  String get achievementAllRounderTitle => 'All-Rounder';

  @override
  String get achievementAllRounderDesc => 'Tried all pushup types';

  @override
  String get achievementAllRounderMotivation =>
      'Master of all types! All-rounder Chad! 🌈';

  @override
  String get achievementIronWillTitle => 'Iron Will';

  @override
  String get achievementIronWillMotivation =>
      '200 in one go! Iron-like will! 🔩';

  @override
  String get achievementUnstoppableForceTitle => 'Unstoppable Force';

  @override
  String get achievementUnstoppableForceDesc =>
      'Achieved 300 pushups in one go';

  @override
  String get achievementUnstoppableForceMotivation =>
      '300! You are an unstoppable force! 🌪️';

  @override
  String get achievementLegendaryBeastTitle => 'Legendary Beast';

  @override
  String get achievementLegendaryBeastDesc => 'Achieved 500 pushups in one go';

  @override
  String get achievementLegendaryBeastMotivation =>
      '500! You are a legendary beast! 🐉';

  @override
  String get achievementMotivatorTitle => 'Motivator';

  @override
  String get achievementMotivatorDesc => 'Used the app for 30+ days';

  @override
  String get achievementMotivatorMotivation =>
      '30 days of use! True motivator! 💡';

  @override
  String get achievementDedicationMasterTitle => 'Master of Dedication';

  @override
  String get achievementDedicationMasterDesc => 'Used the app for 100+ days';

  @override
  String get achievementDedicationMasterMotivation =>
      '100 days of dedication! You are the master of dedication! 🎖️';

  @override
  String get githubRepository => 'GitHub 저장소';

  @override
  String get feedbackEmail => '이메일로 피드백 보내기';

  @override
  String get developerContact => '개발자 연락처';

  @override
  String get openGithub => 'GitHub에서 소스코드 보기';

  @override
  String get emailFeedback => '이메일로 의견을 보내주세요';

  @override
  String get cannotOpenEmail => '이메일 앱을 열 수 없습니다';

  @override
  String get cannotOpenGithub => 'GitHub을 열 수 없습니다';

  @override
  String get builtWithFlutter => 'Flutter로 제작됨';

  @override
  String get challenge7DaysTitle => '7 Consecutive Days';

  @override
  String get challenge7DaysDescription => 'Work out for 7 consecutive days';

  @override
  String get challenge7DaysDetailedDescription =>
      'Complete workouts for 7 consecutive days without missing a single day. You must complete at least 1 set each day.';

  @override
  String get challenge50SingleTitle => '50 in One Go';

  @override
  String get challenge50SingleDescription => '50 pushups in a single workout';

  @override
  String get challenge50SingleDetailedDescription =>
      'Complete 50 pushups in one go without stopping. If you stop in the middle, you must start over from the beginning.';

  @override
  String get challenge100CumulativeTitle => '100 Challenge';

  @override
  String get challenge100CumulativeDescription =>
      'Achieve a total of 100 pushups';

  @override
  String get challenge100CumulativeDetailedDescription =>
      'Complete a total of 100 pushups across multiple sessions.';

  @override
  String get challenge200CumulativeTitle => '200 Challenge';

  @override
  String get challenge200CumulativeDescription =>
      'Achieve a total of 200 pushups';

  @override
  String get challenge200CumulativeDetailedDescription =>
      'Complete a total of 200 pushups across multiple sessions. You can attempt this after completing the 100 challenge.';

  @override
  String get challenge14DaysTitle => '14 Consecutive Days';

  @override
  String get challenge14DaysDescription => 'Work out for 14 consecutive days';

  @override
  String get challenge14DaysDetailedDescription =>
      'Complete workouts for 14 consecutive days without missing a single day. You can attempt this after completing the 7-day consecutive challenge.';

  @override
  String get challengeRewardConsecutiveWarrior => 'Consecutive Warrior Badge';

  @override
  String get challengeRewardPowerLifter => 'Power Lifter Badge';

  @override
  String get challengeRewardCenturyClub => 'Century Club Badge';

  @override
  String get challengeRewardUltimateChampion => 'Ultimate Champion Badge';

  @override
  String get challengeRewardDedicationMaster => 'Dedication Master Badge';

  @override
  String challengeRewardPoints(String points) {
    return '$points Points';
  }

  @override
  String get challengeRewardAdvancedStats => 'Advanced Stats Feature Unlock';

  @override
  String get challengeUnitDays => 'days';

  @override
  String get challengeUnitReps => 'reps';

  @override
  String get challengeStatusAvailable => 'Available';

  @override
  String get challengeStatusActive => 'Active';

  @override
  String get challengeStatusCompleted => 'Completed';

  @override
  String get challengeStatusFailed => 'Failed';

  @override
  String get challengeStatusLocked => 'Locked';

  @override
  String get challengeDifficultyEasy => 'Easy';

  @override
  String get challengeDifficultyMedium => 'Medium';

  @override
  String get challengeDifficultyHard => 'Hard';

  @override
  String get challengeDifficultyExtreme => 'Extreme';

  @override
  String get challengeTypeConsecutiveDays => 'Consecutive Days';

  @override
  String get challengeTypeSingleSession => 'Single Session';

  @override
  String get challengeTypeCumulative => 'Cumulative';

  @override
  String get challengesTitle => 'Challenges';

  @override
  String get challengesAvailable => 'Available';

  @override
  String get challengesActive => 'Active';

  @override
  String get challengesCompleted => 'Completed';

  @override
  String get challengeStartButton => 'Start';

  @override
  String get challengeAbandonButton => 'Abandon';

  @override
  String get challengeRestartButton => 'Restart';

  @override
  String challengeProgress(int progress) {
    return 'Progress: $progress%';
  }

  @override
  String get challengeRewards => 'Rewards';

  @override
  String get challengeFailed => 'Challenge Failed';

  @override
  String get challengeStarted => 'Challenge started! 🔥';

  @override
  String get challengeAbandoned => 'Challenge Abandoned';

  @override
  String get challengePrerequisitesNotMet => 'Prerequisites not met';

  @override
  String get challengeAlreadyActive => 'Challenge already active';

  @override
  String get challengeHintConsecutiveDays =>
      'Work out consistently every day! If you miss even one day, you\'ll have to start over.';

  @override
  String get challengeHintSingleSession =>
      'Achieve the target number in one go! You can\'t rest in the middle.';

  @override
  String get challengeHintCumulative =>
      'Achieve the goal across multiple sessions. Just be consistent!';

  @override
  String get sendFriendChallenge => '💀 Send CHAD Challenge to Friends! 💀';

  @override
  String get refresh => 'Refresh';

  @override
  String get achieved => 'Achieved';

  @override
  String get shareButton => 'Share';

  @override
  String setFormat2(int number, int reps) {
    return 'Set $number: $reps reps';
  }

  @override
  String get sleepyHatChad => 'Sleepy Hat Chad';

  @override
  String get journeyStartingChad =>
      'Chad beginning awakening.\nPotential is stirring.';

  @override
  String get notificationPermissionPerfect =>
      '🔔 Notification Permission Perfect!';

  @override
  String get basicNotificationPermission => 'Basic Notification Permission';

  @override
  String get exactNotificationPermission => 'Exact Notification Permission';

  @override
  String get congratulationsMessage =>
      'Congratulations! All permissions are perfectly set up! 🎉';

  @override
  String get workoutDayNotification => 'Workout Day Notification';

  @override
  String get chadEvolutionCompleteNotification =>
      'Chad Evolution Complete Notification';

  @override
  String get chadEvolutionPreviewNotification =>
      'Chad Evolution Preview Notification';

  @override
  String get chadEvolutionQuarantineNotification =>
      'Chad Evolution Quarantine Notification';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get fontSize => 'Font Size';

  @override
  String get animationEffect => 'Animation Effect';

  @override
  String get highContrastMode => 'High Contrast Mode';

  @override
  String get backupManagement => 'Backup Management';

  @override
  String get backupManagementDesc =>
      'Manage data backup, restore and auto-backup settings';

  @override
  String get levelReset => 'Level Reset';

  @override
  String get levelResetDesc =>
      'Reset all progress and start from the beginning';

  @override
  String get licenseInfo => 'License Information';

  @override
  String get licenseInfoDesc =>
      'Check licenses of open source libraries used in the app';

  @override
  String get todayMissionTitle => 'Today\'s Mission';

  @override
  String get todayGoalTitle => 'Today\'s Goal:';

  @override
  String setRepsFormat(int setIndex, int reps) {
    return 'Set $setIndex: $reps reps';
  }

  @override
  String completedRepsFormat(int completed) {
    return 'Completed: reps (sets)';
  }

  @override
  String totalRepsFormat(int totalReps) {
    return '$totalReps reps';
  }

  @override
  String get notificationPermissionCheckingStatus =>
      'Checking notification permission status';

  @override
  String get notificationPermissionNeeded =>
      '❌ Notification Permission Required';

  @override
  String get exactAlarmPermission => 'Exact Alarm Permission';

  @override
  String get allowNotificationPermission => 'Allow Notification Permission';

  @override
  String get setExactAlarmPermission => 'Set Exact Alarm Permission';

  @override
  String get requiredLabel => 'Required';

  @override
  String get recommendedLabel => 'Recommended';

  @override
  String get activatedStatus => 'Activated';

  @override
  String get themeColorDesc => 'Change the main color of the app';

  @override
  String get fontScale => 'Font Size';

  @override
  String get fontScaleDesc => 'Adjust text size throughout the app';

  @override
  String get animationsEnabled => 'Animations have been enabled';

  @override
  String get animationsEnabledDesc =>
      'Enable or disable app-wide animation effects';

  @override
  String get highContrastModeDesc =>
      'Enable high contrast mode for visual accessibility';

  @override
  String get levelResetConfirm => 'Level Reset Confirmation';

  @override
  String get urlNotAvailableTitle => 'Page Not Available';

  @override
  String urlNotAvailableMessage(String page) {
    return 'The $page page is not available yet. It will be provided in a future update.';
  }

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get ok => 'OK';

  @override
  String get loadingText => 'Loading...';

  @override
  String get refreshButton => 'Refresh';

  @override
  String get errorLoadingData => 'Error occurred while loading data';

  @override
  String get retryButton => 'Retry';

  @override
  String get noUserProfile => 'No user profile found';

  @override
  String get completeInitialTest =>
      'Please complete the initial test to create your profile';

  @override
  String get sleepyChadEvolution => 'Sleepy Chad';

  @override
  String get journeyChadEvolution => 'Chad Starting the Journey';

  @override
  String get setRepsDisplayFormat => 'Sets × Reps';

  @override
  String weeksRemaining(int weeks) {
    return '$weeks weeks left';
  }

  @override
  String thisWeekProgress(int current) {
    return 'This Week (Week $current)';
  }

  @override
  String weeksCompleted(int completed, int total) {
    return '$completed/$total weeks completed';
  }

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get workoutTime => 'Workout Time';

  @override
  String get remainingGoal => 'Remaining Goal';

  @override
  String setRepFormat(int setIndex, int reps) {
    return 'Set $setIndex: $reps reps';
  }

  @override
  String goalFormat(int totalReps, int totalSets) {
    return 'Goal: $totalReps reps / $totalSets sets';
  }

  @override
  String get restDayChampionTitle => 'Rest Day Champion! 💪';

  @override
  String get restDayDescription =>
      'Today is a scheduled rest day but...\nTrue champions never rest! 🔥\n\nWould you like to take on an additional challenge?';

  @override
  String get challengeMode => 'Challenge Mode';

  @override
  String get challengeModeDescription =>
      'Just basic workout? Or true champion mode? 🚀\n\n⚡ Challenge Mode ON gives you:\n• Higher difficulty\n• Bonus points earned 🏆';

  @override
  String get challengeModeOn => 'Challenge Mode ON! 🔥';

  @override
  String get challengeModeActivated =>
      '🔥 Challenge Mode Activated! Let\'s test your mental strength! 💪';

  @override
  String get workoutAlreadyCompleted =>
      'Today\'s workout is already completed! 💪';

  @override
  String get restDayChallenge =>
      'Rest day? That\'s for the weak!\nTrue champions fight every day! 🥊\n\nProve your mental strength with a simple additional challenge!';

  @override
  String get restDayAccept => 'Would you like to accept the rest day?';

  @override
  String get restDayTeasing =>
      'Someone is doing 100 push-ups right now! 💪\n\nAre you really going to rest today?';

  @override
  String get noWorkout => 'No! I\'ll work out!';

  @override
  String get bonusChallenge => '🔥 Bonus Challenge';

  @override
  String get workoutCompleted => 'Completed';

  @override
  String get workoutAchieved => 'Achieved';

  @override
  String get shareWorkout => 'Share';

  @override
  String get shareError => 'An error occurred while sharing.';

  @override
  String get workoutSaveError =>
      'An error occurred while saving workout record. Please try again.';

  @override
  String setCount(int count) {
    return '$count sets';
  }

  @override
  String repsCount(int count) {
    return '$count reps';
  }

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get onboardingNext => 'Next';

  @override
  String get permissionNotificationMessage =>
      'Notification and storage permissions are required. Please allow in settings.';

  @override
  String get permissionStorageMessage =>
      'Storage permission is required. Please allow in settings.';

  @override
  String get challengeCannotStart => 'Cannot start challenge.';

  @override
  String get challengeGiveUpTitle => 'Give Up Challenge';

  @override
  String get challengeGiveUpMessage =>
      'Are you sure you want to give up this challenge?';

  @override
  String get challengeGaveUp => 'Challenge given up.';

  @override
  String get challengeTitle => 'Challenge';

  @override
  String get challengeTabCompleted => 'Completed';

  @override
  String get noChallengesAvailable => 'No challenges available';

  @override
  String get unlockMoreChallenges =>
      'Complete more workouts to unlock new challenges!';

  @override
  String get noActiveChallenges => 'No active challenges';

  @override
  String get startNewChallenge => 'Start a new challenge!';

  @override
  String get noCompletedChallenges => 'No completed challenges';

  @override
  String get completeFirstChallenge => 'Complete your first challenge!';

  @override
  String get pushupTutorialTitle => 'Chad Pushup Dojo';

  @override
  String get pushupTutorialSubtitle =>
      'Real chads start with different form! 💪';

  @override
  String get pushupStandard => 'Standard Pushup';

  @override
  String get pushupKnee => 'Knee Pushup';

  @override
  String get pushupIncline => 'Incline Pushup';

  @override
  String get pushupWideGrip => 'Wide Grip Pushup';

  @override
  String get pushupDiamond => 'Diamond Pushup';

  @override
  String get pushupDecline => 'Decline Pushup';

  @override
  String get pushupArcher => 'Archer Pushup';

  @override
  String get pushupPike => 'Pike Pushup';

  @override
  String get pushupClap => 'Clap Pushup';

  @override
  String get pushupOneArm => 'One-Arm Pushup';

  @override
  String get chadDescription => '💪 Chad Description';

  @override
  String get chadAdvice => '🔥 Chad\'s Advice';

  @override
  String get chadMotivationStandard =>
      'Basics are most important! Build up one by one with perfect form and you\'ll become a real chad!';

  @override
  String get chadMotivationKnee =>
      'Starting is half the battle! Do knee pushups properly and you\'ll quickly advance to regular pushups!';

  @override
  String get chadMotivationIncline =>
      'Step-by-step progression is the chad way! Challenge yourself by gradually lowering the angle!';

  @override
  String get chadMotivationWideGrip =>
      'Spread your chest wide and receive chad energy! A broad chest is the symbol of a real chad!';

  @override
  String get chadMotivationDiamond =>
      'Build your precious triceps like diamonds! Feel your arm muscles explode!';

  @override
  String get chadMotivationDecline =>
      'Challenging higher ground is what chads do! Feel your shoulders and upper body burning!';

  @override
  String get chadMotivationArcher =>
      'Advanced technique requiring balance and focus! Master each side perfectly and you\'re a real chad!';

  @override
  String get chadMotivationPike =>
      'First step to handstands! Enjoy the feeling of your shoulder muscles bursting!';

  @override
  String get chadMotivationClap =>
      'Clap with explosive power! Master this and you\'re a real chad, f**k yeah!';

  @override
  String get chadMotivationOneArm =>
      'One-arm pushup is the ultimate chad form! Do this even once and you\'re recognized as a real giga chad, f**k yeah!';

  @override
  String get chadMotivationDefault =>
      'The chad path is tough but that makes it more valuable! Don\'t give up!';

  @override
  String get customWorkoutDays => 'Workout Days Settings';

  @override
  String get customWorkoutDaysDesc => 'Set your preferred workout days';

  @override
  String get workoutDaySelection => 'Select Workout Days';

  @override
  String get selectWorkoutDays => 'Select workout days (maximum 6 days)';

  @override
  String get restDayMessage =>
      'Today is recovery day. True strength comes from rest.';

  @override
  String get workoutDaysOnlyNotifications => '🔥 Workout Days Only Alerts';

  @override
  String get workoutDaysOnlyNotificationsDesc =>
      'Receive notifications only on workout days (Mon, Wed, Fri). No disturbance on rest days!';

  @override
  String get chadEvolutionNotifications => 'Chad Evolution Complete Alerts';

  @override
  String get chadEvolutionNotificationsDesc =>
      'Get notified when Chad evolves to a new stage';

  @override
  String get chadEvolutionPreviewNotifications =>
      'Chad Evolution Preview Alerts';

  @override
  String get chadEvolutionPreviewNotificationsDesc =>
      'Get advance notice when 1 week remains until next evolution';

  @override
  String get chadEvolutionEncouragementNotifications =>
      'Chad Evolution Encouragement Alerts';

  @override
  String get chadEvolutionEncouragementNotificationsDesc =>
      'Receive encouraging messages when 3 days remain until next evolution';

  @override
  String get workoutReminderDisabled => 'Workout reminders have been disabled';

  @override
  String get workoutDaysModeActivated =>
      '💪 Workout days only mode activated! Notifications will come only on Mon, Wed, Fri!';

  @override
  String get dailyNotificationModeChanged =>
      'Switched to daily notification mode! Getting alerts every day! 📱';

  @override
  String get fontSizeDesc => 'Adjust the app\'s font size';

  @override
  String get animations => 'Animations';

  @override
  String get animationsDesc => 'Enable/disable app animation effects';

  @override
  String get animationsDisabled => 'Animations have been disabled';

  @override
  String get highContrastEnabled => 'High contrast mode has been enabled';

  @override
  String get highContrastDisabled => 'High contrast mode has been disabled';

  @override
  String get themeColorSelection => 'Theme Color Selection';

  @override
  String themeColorChanged(String colorName) {
    return 'Theme color changed to $colorName';
  }

  @override
  String get required => 'Required';

  @override
  String get activated => 'Activated';

  @override
  String get perfectFormChallenge =>
      '🎯 Perfect Form Challenge activated! No slacking! 💪';

  @override
  String get sevenDayStreak =>
      '🔄 7-day streak challenge started! Miss a day, start over! 🚀';

  @override
  String get challengeTestYourLimits => '💪 Ready to test your limits today?';

  @override
  String get restDayBonusChallenge =>
      'Rest Day Bonus Challenge! 💪\n\n• Plank 30s x 3 sets\n• Squats 20 x 2 sets\n• Push-ups 10 (perfect form!)\n\nReady? Only real champions can do this! 🏆';

  @override
  String get startChallenge => 'Start! 🔥';

  @override
  String get stepByStepGuide => 'Step-by-Step\nGuide';

  @override
  String get commonMistakes => 'Common\nMistakes';

  @override
  String get variationExercises => 'Variation\nExercises';

  @override
  String get improvementTips => 'Improvement\nTips';

  @override
  String get correctPushupForm5Steps => 'Correct Pushup Form in 5 Steps';

  @override
  String get chadPerfectPushupForm =>
      'Chad\'s guide to perfect pushup form! 💪';

  @override
  String get listView => 'List View';

  @override
  String get swipeView => 'Swipe View';

  @override
  String get quiz => 'Quiz';

  @override
  String get dontMakeTheseMistakes => 'Don\'t Make These Mistakes!';

  @override
  String get chadMistakesAdvice =>
      'Chad made mistakes at first too. But now he\'s perfect! 🔥';

  @override
  String get pushupVariationsByDifficulty => 'Pushup Variations by Difficulty';

  @override
  String get beginnerToChad =>
      'From beginner to Chad! Challenge yourself step by step! 🚀';

  @override
  String get chadSecretTips => 'Chad\'s Secret Tips';

  @override
  String get becomeTrueChadTips =>
      'With these tips, you can become a true Chad too! 💎';

  @override
  String get startPosition => 'Start Position';

  @override
  String get descendingMotion => 'Descending Motion';

  @override
  String get bottomPosition => 'Bottom Position';

  @override
  String get ascendingMotion => 'Ascending Motion';

  @override
  String get finishPosition => 'Finish Position';

  @override
  String get startPositionDesc =>
      'Start with a plank position and accurately set the position of your hands and feet.';

  @override
  String get descendingMotionDesc =>
      'Bend your elbows and slowly lower your body downward.';

  @override
  String get bottomPositionDesc =>
      'Pause briefly at the lowest point where your chest almost touches the floor.';

  @override
  String get ascendingMotionDesc =>
      'Straighten your arms and return to the starting position.';

  @override
  String get finishPositionDesc =>
      'Completely return to the starting position and prepare for the next repetition.';

  @override
  String get correctPushupQuiz1 =>
      'What is the correct hand position in a proper pushup starting position?';

  @override
  String get pushupMistakeQuiz =>
      'What is the most common mistake during pushups?';

  @override
  String get beginnerPushupQuiz =>
      'What is the most suitable pushup variation for beginners?';

  @override
  String get pushupBreathingQuiz =>
      'What is the correct breathing technique during pushups?';

  @override
  String get elbowAngleQuiz =>
      'What is the correct elbow angle during pushups?';

  @override
  String get wrongPose => 'Wrong Pose';

  @override
  String get correctPose => 'Correct Pose';

  @override
  String get correctionMethod => 'Correction Method:';

  @override
  String get beginnerLevel => 'Beginner';

  @override
  String get intermediateLevel => 'Intermediate';

  @override
  String get advancedLevel => 'Advanced';

  @override
  String get instructions => 'Instructions';

  @override
  String get benefits => 'Benefits';

  @override
  String get breathingTechnique => '💨 BREATH LIKE A BEAST 💨';

  @override
  String get strengthImprovement => '💪 POWER SURGE PROTOCOL 💪';

  @override
  String get recovery => '🛡️ WARRIOR RESTORATION 🛡️';

  @override
  String get motivation => '🔥 SAVAGE FUEL 🔥';

  @override
  String get overallProgress => 'Overall Progress';

  @override
  String get sessions => 'Sessions';

  @override
  String get completedCount => 'Completed Count';

  @override
  String get remainingCount => 'Remaining Count';

  @override
  String get weeklyGrowthChart => 'Weekly Growth Chart';

  @override
  String get weeklyDetails => 'Weekly Details';

  @override
  String get sessionsCompleted => 'Sessions Completed';

  @override
  String get workoutCalendar => 'Workout Calendar';

  @override
  String get chadEvolutionStage => 'Chad Evolution Stage';

  @override
  String get completedSessions => 'Completed Sessions';

  @override
  String get overallStatistics => 'Overall Statistics';

  @override
  String get programProgress => 'Program Progress';

  @override
  String get repsCompleted => 'Reps Completed';

  @override
  String get weekCompleted => 'Week';

  @override
  String get chadEvolutionStages => 'Chad Evolution Stages';

  @override
  String get noWorkoutsToday => 'No workouts on this day';

  @override
  String get inProgress => 'In Progress';

  @override
  String get setRecords => 'Set Records:';

  @override
  String get overallStats => 'Overall Statistics';

  @override
  String get averagePerSession => 'Avg/Session';

  @override
  String get weeklyPerformance => 'Weekly Performance';

  @override
  String get viewAll => 'View All';

  @override
  String get improvementNeeded => 'Needs Improvement';

  @override
  String get personalRecords => 'Personal Records';

  @override
  String get bestWeek => 'Best Week';

  @override
  String get consecutiveDays => 'Consecutive Days';

  @override
  String get averageScore => 'Average Score';

  @override
  String get rookieChad => 'Rookie Chad';

  @override
  String get risingChad => 'Rising Chad';

  @override
  String get alphaChad => 'Alpha Chad';

  @override
  String get sigmaChad => 'Sigma Chad';

  @override
  String get gigaChad => 'Giga Chad';

  @override
  String get ultraChad => 'Ultra Chad';

  @override
  String get legendaryChad => 'Legendary Chad';

  @override
  String get currentChadState => 'Current Chad State';

  @override
  String get nextLevel => 'Until next level';

  @override
  String get nextLevelIn => '30% remaining to next level';

  @override
  String get maxLevelAchieved => 'Maximum level achieved!';

  @override
  String get programStart => 'Program Start';

  @override
  String get week1Completed => 'Week 1 Completed';

  @override
  String get week2Completed => 'Week 2 Completed';

  @override
  String get week3Completed => 'Week 3 Completed';

  @override
  String get week4Completed => 'Week 4 Completed';

  @override
  String get week5Completed => 'Week 5 Completed';

  @override
  String get week6Completed => 'Week 6 Completed';

  @override
  String get firstStep => 'First Step';

  @override
  String get firstWorkoutCompleted => 'First workout completed';

  @override
  String get oneWeekChallenge => 'One Week Challenge';

  @override
  String get sevenDaysExercise => '7 consecutive days';

  @override
  String get hundredPushups => 'Hundred Pushups';

  @override
  String get hundredRepsInOneSession => '100 reps in one session';

  @override
  String get perfectWeek => 'Perfectionist';

  @override
  String get oneWeekCompleted => 'One week 100% completed';

  @override
  String get chadAchievements => 'Chad Achievements';

  @override
  String get chadEvolution => 'Chad Evolution';

  @override
  String get noData => 'No data available';

  @override
  String get weeklyChallenge => 'Weekly Challenge';

  @override
  String get improvement => 'Needs Improvement';

  @override
  String get excellent => 'Good';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get firstStepDesc => 'Complete first workout';

  @override
  String get weeklyChallengeDesc => 'Exercise for 7 consecutive days';

  @override
  String get hundredPushupsDesc => 'Achieve 100 reps in one session';

  @override
  String get perfectionistDesc => 'Complete one week 100%';

  @override
  String get noWorkoutToday => '🤷‍♂️ REST DAY? TOMORROW WE DESTROY! 🔥';

  @override
  String get remaining => 'remaining';

  @override
  String workoutDate(int month, int day) {
    return '$month/$day Workout';
  }

  @override
  String weekX(int week) {
    return 'Week $week';
  }

  @override
  String dayX(int day) {
    return 'Day $day';
  }

  @override
  String sessionsCompletedFormat(int completed, int total, int reps) {
    return '$completed/$total sessions completed • $reps reps';
  }

  @override
  String get cannotOpenPrivacyPolicy => 'Cannot open Privacy Policy';

  @override
  String get cannotOpenTermsOfService => 'Cannot open Terms of Service';

  @override
  String get excellentPerformance => '🚀 EXCELLENT! Perfect execution! 🚀';

  @override
  String get goodPerformance => '💪 GOOD! Keep it up! 💪';

  @override
  String get keepGoing => '🔥 KEEP GOING! Don\'t stop! 🔥';

  @override
  String get skipRest => 'Skip Rest';

  @override
  String get adaptiveTheme => 'Adaptive Theme';

  @override
  String get adaptiveThemeDesc => 'Automatically changes with system settings';

  @override
  String get colorTheme => 'Color Theme';

  @override
  String get mission100Settings => 'Mission 100 Settings';

  @override
  String get customizeAppFeatures => 'Customize app features to your liking';

  @override
  String get receiveGeneralNotifications => 'Receive general notifications';

  @override
  String get workoutReminder => 'Workout Reminder';

  @override
  String dailyReminderAt(String time) {
    return 'Daily notification at $time';
  }

  @override
  String get pushNotificationEnabled => 'Push notifications have been enabled';

  @override
  String get pushNotificationDisabled =>
      'Push notifications have been disabled';

  @override
  String get workoutReminderEnabled => 'Workout reminders have been enabled';

  @override
  String get detailedReminderSettings => 'Detailed Reminder Settings';

  @override
  String get weeklyWorkoutSchedule => 'Set weekly workout schedule';

  @override
  String get receiveAchievementNotifications =>
      'Receive notifications when achievements are unlocked';

  @override
  String get achievementNotificationsAlwaysOn =>
      'Achievement notifications are always enabled';

  @override
  String get useDarkTheme => 'Use dark theme';

  @override
  String get themeChangeAfterRestart =>
      'Theme changes will be applied after app restart';

  @override
  String get languageSettingsComingSoon =>
      'Language settings feature is coming soon';

  @override
  String get beginnerMode => 'Beginner Mode';

  @override
  String get difficultySettingsComingSoon =>
      'Difficulty settings feature is coming soon';

  @override
  String get backupWorkoutRecords => 'Backup workout records';

  @override
  String get restoreBackupData => 'Restore backed up data';

  @override
  String get deleteAllWorkoutRecords => 'Delete all workout records';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get mission100Team => 'Mission 100 Team';

  @override
  String get license => 'License';

  @override
  String get openSourceLicense => 'Open Source License';

  @override
  String get licenseInfoComingSoon => 'License information is coming soon';

  @override
  String get appRating => 'App Rating';

  @override
  String get rateOnPlayStore => 'Rate on Play Store';

  @override
  String get appRatingComingSoon => 'App rating feature is coming soon';

  @override
  String get copyrightMission100 =>
      '© 2024 Mission 100 Team\nAll rights reserved\n\n💪 Until you become a Chad!';

  @override
  String get challengeOptions =>
      'What would you like to do with this challenge?';

  @override
  String get abandon => 'Abandon';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get workoutReminderSettings => 'Workout Reminder Settings';

  @override
  String get chadModeActivate =>
      '💪 Chad Mode Activate! Set your victory schedule! 🔥';

  @override
  String get chadNotificationSettings => '🔔 Chad Notification Settings';

  @override
  String get chadReminder => '💪 Chad Reminder';

  @override
  String chadModeActive(String days, String time) {
    return '🔥 $days $time - Chad Mode Activated!';
  }

  @override
  String get chadModeWaiting => '😴 Chad Mode Standby...';

  @override
  String get chadTimeSettings => '⏰ Chad Time Settings';

  @override
  String get chadAlarmTime => '🔥 Chad Alarm Time';

  @override
  String victoryTime(String time) {
    return '$time - Victory Time!';
  }

  @override
  String get chadModeSelection => '🚀 Chad Mode Selection';

  @override
  String get workerChadMode => '💼 Worker Chad Mode (Mon-Fri)';

  @override
  String get weekendRestWeekdayInvincible =>
      'Weekend rest, weekday invincible! 💪';

  @override
  String get strategicChadMode => '⭐ Strategic Chad Mode (Mon/Wed/Fri)';

  @override
  String get scientificRecovery =>
      'Scientific muscle recovery + sustainable power! 🧠💪';

  @override
  String get balanceChadMode => '❤️ Balance Chad Mode (Tue/Thu/Sat)';

  @override
  String get perfectBalanceOptimized =>
      'Perfect balance! Weekday+weekend optimized pattern! ⚖️🔥';

  @override
  String get victoryDaySelection => '💪 Victory Day Selection';

  @override
  String get precautions => 'Precautions';

  @override
  String get workoutPrecautions =>
      '• At least one rest day is required\n• Cannot workout more than 6 consecutive days\n• Adequate rest is essential for muscle growth';

  @override
  String selectedDaysFormat(String days, int count) {
    return 'Selected: $days ($count/6 days)';
  }

  @override
  String get settingsSaved => 'Settings have been saved';

  @override
  String get settingsSaveFailed => 'Failed to save settings';

  @override
  String get minOneDayRest => 'At least one rest day is required';

  @override
  String get maxSixDaysWorkout =>
      'Maximum 6 days workout allowed (one day must be rest)';

  @override
  String get noConsecutiveSixDays =>
      'Maximum 4 workouts per week allowed. Adequate rest is essential!';

  @override
  String get cannotLoadQuizData => 'Cannot load quiz data';

  @override
  String get errorPleaseTryAgain => 'An error occurred. Please try again';

  @override
  String get dailyWorkoutAlarm =>
      'Daily workout time alarm! Miss it and you\'re WEAK! 💪';

  @override
  String get laterBasicChad => 'Later (BASIC CHAD)';

  @override
  String get status => 'Status';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get backup => 'Backup';

  @override
  String get backupFileName => 'Backup File Name';

  @override
  String get fileNamePlaceholder => 'backup_filename';

  @override
  String get encryption => 'Encryption';

  @override
  String get pleaseCreateProfile => 'Please create your profile';

  @override
  String get userProfileRequired =>
      'User profile is required to start your workout';

  @override
  String get workoutTips => 'Workout Tips';

  @override
  String get workoutTipsContent =>
      '• Stretch sufficiently before and after workouts\\n• Proper form is more important than quantity\\n• Consistency is the most important success factor';

  @override
  String get todayWorkoutNotAvailable => 'Today\'s workout is not available';

  @override
  String get consecutiveWorkoutBlocked => 'STOP! No Consecutive Workouts!';

  @override
  String get consecutiveWorkoutMessage =>
      'YO YO YO! You worked out yesterday! 🔥\\n\\nWhat are you trying to do? Consecutive workouts?\\nReal CHADs rest when they need to rest!\\n\\n💀 Overtraining is for noobs!\\n😎 Chill today, CRUSH tomorrow!\\n🔥 LEGENDARY CHADs master rest too!';

  @override
  String get chadRestModeToday => 'OKAY! CHAD REST MODE TODAY! 💪😎';

  @override
  String get notificationsSettings => 'Notifications';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeChangeRestart => 'Theme change will apply after app restart';

  @override
  String get languageComingSoon => 'Language settings coming soon';

  @override
  String get aboutApp => 'About';

  @override
  String get manageAppSettings => 'Manage your app settings';

  @override
  String get themeLanguageSettings => 'Theme and Language Settings';

  @override
  String get aboutInfo => 'About';

  @override
  String get perfectChadExperience =>
      'Adjust settings for the perfect Chad experience';

  @override
  String get alphaEmperorDomain => '💀 ALPHA EMPEROR DOMAIN 💀';

  @override
  String get journeyToChad => 'Journey to Become Chad';

  @override
  String get dailyConquestRecord => '🔥💀 Daily Conquest Record 💀🔥';

  @override
  String get dayLabel => '📅 Day';

  @override
  String get pushupsLabel => '💪 Push-ups';

  @override
  String repsFormat(int count) {
    return '$count reps';
  }

  @override
  String get levelLabel => '🏆 Level';

  @override
  String levelUpMessage(String emoji) {
    return '$emoji💥 LEVEL UP! Limit Destroyed! 💥$emoji';
  }

  @override
  String get newChadLevel => 'New Chad Level';

  @override
  String daysFormat(int days) {
    return '$days days';
  }

  @override
  String get achievementUnlocked => '🏆 Achievement Unlocked! 🏆';

  @override
  String get weeklyReport => '📊 Weekly Report 📊';

  @override
  String get missionComplete =>
      '🎉👑💀 MISSION COMPLETE! ALPHA EMPEROR Ascension! 💀👑🎉';

  @override
  String get pushup100Streak =>
      '💪💀 100 Push-ups Streak! Human Transcendence! 💀💪';

  @override
  String get durationLabel => 'Duration';

  @override
  String timesFormat(int times) {
    return '$times times';
  }

  @override
  String get completedLabel => 'Completed';

  @override
  String get trueGigaChad =>
      '🔥💀 True Giga Chad Complete! ALPHA EMPEROR! 💀🔥';

  @override
  String get becomeChad => '💀 Want to become Chad too? 💀';

  @override
  String get downloadMission100 =>
      'Download Mission: 100 app! Weaklings run away!';

  @override
  String get backingUpData => 'Backing up data...';

  @override
  String backupCompletedWithPath(String path) {
    return 'Backup completed!\\nSaved to: $path';
  }

  @override
  String get backupFailed => 'Backup failed. Please try again.';

  @override
  String backupErrorOccurred(String error) {
    return 'Backup error occurred: $error';
  }

  @override
  String get dataRestoreTitle => '⚠️ Data Restore';

  @override
  String get dataRestoreWarning =>
      'Restoring data from backup will delete all current data.\\nAre you sure you want to restore?';

  @override
  String get restoringData => 'Restoring data...';

  @override
  String get dataRestoreCompleted =>
      'Data restore completed! Please restart the app.';

  @override
  String get dataRestoreFailed =>
      'Data restore failed. Please check the backup file.';

  @override
  String restoreErrorOccurred(String error) {
    return 'Restore error occurred: $error';
  }

  @override
  String get confirmDataReset => 'Confirm Data Reset';

  @override
  String get resetAllProgressConfirm =>
      'Are you sure you want to reset all progress?';

  @override
  String get followingDataDeleted => 'The following data will be deleted:';

  @override
  String get currentLevelProgress => '• Current level and progress';

  @override
  String get workoutRecordsStats => '• Workout records and statistics';

  @override
  String get chadEvolutionStatus => '• Chad evolution status';

  @override
  String get achievementsBadges => '• Achievements and badges';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone!';

  @override
  String get resetButton => 'Reset';

  @override
  String get resettingData => 'Resetting data...';

  @override
  String get allDataResetSuccessfully => 'All data has been successfully reset';

  @override
  String dataResetErrorOccurred(String error) {
    return 'Data reset error occurred: $error';
  }

  @override
  String get resumeWorkout => '💪 Resume Workout';

  @override
  String get foundWorkout => '🔍 Found Workout';

  @override
  String get workoutTitle => '💪 WAR ZONE 💪';

  @override
  String progressSetReady(int set) {
    return 'Progress: Set $set ready';
  }

  @override
  String completedSetsCount(int count) {
    return 'Completed sets: $count';
  }

  @override
  String totalCompletedReps(int reps) {
    return 'Total completed: $reps reps';
  }

  @override
  String get workoutInterruptionDetected => '⚠️ Workout Interruption Detected';

  @override
  String get continueOrStartNew =>
      'Would you like to continue the previous workout?\\nOr start a new workout?';

  @override
  String get startNewWorkout => 'Start New Workout';

  @override
  String get incompleteWorkoutFound => 'Incomplete workout found!';

  @override
  String workoutDetailsWithStats(String title, int sets, int reps) {
    return 'Workout: $title\\nCompleted sets: $sets\\nTotal reps: $reps';
  }

  @override
  String get resumeButton => '💀 BACK TO WAR 💀';

  @override
  String get progressLabel => '🚀 LEGEND PROGRESS 🚀';

  @override
  String get okButton => '🔥 HELL YEAH, BRO! 🔥';

  @override
  String get cancelButton => '❌ QUIT LIKE A BETA? ❌';

  @override
  String get exitButton => '💀 RUN AWAY 💀';

  @override
  String get expanded => 'Expanded';

  @override
  String get collapsedTapToExpand => 'Collapsed. Tap to expand';

  @override
  String get previousButton => '⬅️ RETREAT LIKE A COWARD ⬅️';

  @override
  String get achievementTypeFirst => '🥇 VIRGIN VOYAGE';

  @override
  String get achievementTypeVolume => '🔥 VOLUME BOMBING';

  @override
  String get achievementTypeStreak => '⚡ STREAK DOMINANCE';

  @override
  String get achievementTypePerfect => '👑 PERFECT EMPEROR';

  @override
  String get achievementTypeSpecial => '💎 SPECIAL LEGEND';

  @override
  String get achievementTypeChallenge => '🚀 CHALLENGE BEAST';

  @override
  String get achievementTypeStatistics => '📊 STATS MASTER';
}
