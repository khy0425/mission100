class NotificationSettings {
  final bool pushEnabled;
  final bool workoutReminders;
  final bool achievementAlerts;
  final bool weeklyReports;
  final String reminderTime; // HH:mm 형식
  final List<int> reminderDays; // 0=일요일, 1=월요일, ...

  const NotificationSettings({
    required this.pushEnabled,
    required this.workoutReminders,
    required this.achievementAlerts,
    required this.weeklyReports,
    required this.reminderTime,
    required this.reminderDays,
  });

  static NotificationSettings get defaultSettings => const NotificationSettings(
    pushEnabled: true,
    workoutReminders: true,
    achievementAlerts: true,
    weeklyReports: false,
    reminderTime: '18:00',
    reminderDays: [1, 3, 5], // 월, 수, 금
  );

  Map<String, dynamic> toJson() {
    return {
      'pushEnabled': pushEnabled,
      'workoutReminders': workoutReminders,
      'achievementAlerts': achievementAlerts,
      'weeklyReports': weeklyReports,
      'reminderTime': reminderTime,
      'reminderDays': reminderDays,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushEnabled: json['pushEnabled'] as bool,
      workoutReminders: json['workoutReminders'] as bool,
      achievementAlerts: json['achievementAlerts'] as bool,
      weeklyReports: json['weeklyReports'] as bool,
      reminderTime: json['reminderTime'] as String,
      reminderDays: List<int>.from(json['reminderDays'] as List),
    );
  }

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? workoutReminders,
    bool? achievementAlerts,
    bool? weeklyReports,
    String? reminderTime,
    List<int>? reminderDays,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      workoutReminders: workoutReminders ?? this.workoutReminders,
      achievementAlerts: achievementAlerts ?? this.achievementAlerts,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }
}

enum ChadIntensity {
  mild,   // 순한 Chad
  normal, // 일반 Chad
  intense, // 강렬한 Chad
}

class AppearanceSettings {
  final bool darkMode;
  final String language; // 'ko', 'en'
  final ChadIntensity chadIntensity;

  const AppearanceSettings({
    required this.darkMode,
    required this.language,
    required this.chadIntensity,
  });

  static AppearanceSettings get defaultSettings => const AppearanceSettings(
    darkMode: false,
    language: 'ko',
    chadIntensity: ChadIntensity.normal,
  );

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'language': language,
      'chadIntensity': chadIntensity.name,
    };
  }

  factory AppearanceSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceSettings(
      darkMode: json['darkMode'] as bool,
      language: json['language'] as String,
      chadIntensity: ChadIntensity.values.firstWhere(
        (e) => e.name == json['chadIntensity'],
        orElse: () => ChadIntensity.normal,
      ),
    );
  }

  AppearanceSettings copyWith({
    bool? darkMode,
    String? language,
    ChadIntensity? chadIntensity,
  }) {
    return AppearanceSettings(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      chadIntensity: chadIntensity ?? this.chadIntensity,
    );
  }
}

class PrivacySettings {
  final bool shareProgress;
  final bool analytics;
  final bool crashReporting;

  const PrivacySettings({
    required this.shareProgress,
    required this.analytics,
    required this.crashReporting,
  });

  static PrivacySettings get defaultSettings => const PrivacySettings(
    shareProgress: false,
    analytics: true,
    crashReporting: true,
  );

  Map<String, dynamic> toJson() {
    return {
      'shareProgress': shareProgress,
      'analytics': analytics,
      'crashReporting': crashReporting,
    };
  }

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      shareProgress: json['shareProgress'] as bool,
      analytics: json['analytics'] as bool,
      crashReporting: json['crashReporting'] as bool,
    );
  }

  PrivacySettings copyWith({
    bool? shareProgress,
    bool? analytics,
    bool? crashReporting,
  }) {
    return PrivacySettings(
      shareProgress: shareProgress ?? this.shareProgress,
      analytics: analytics ?? this.analytics,
      crashReporting: crashReporting ?? this.crashReporting,
    );
  }
}

enum BackupFrequency {
  daily,
  weekly,
  monthly,
}

class BackupSettings {
  final bool autoBackup;
  final BackupFrequency backupFrequency;
  final DateTime? lastBackupAt;

  const BackupSettings({
    required this.autoBackup,
    required this.backupFrequency,
    this.lastBackupAt,
  });

  static BackupSettings get defaultSettings => const BackupSettings(
    autoBackup: true,
    backupFrequency: BackupFrequency.daily,
  );

  Map<String, dynamic> toJson() {
    return {
      'autoBackup': autoBackup,
      'backupFrequency': backupFrequency.name,
      'lastBackupAt': lastBackupAt?.toIso8601String(),
    };
  }

  factory BackupSettings.fromJson(Map<String, dynamic> json) {
    return BackupSettings(
      autoBackup: json['autoBackup'] as bool,
      backupFrequency: BackupFrequency.values.firstWhere(
        (e) => e.name == json['backupFrequency'],
        orElse: () => BackupFrequency.daily,
      ),
      lastBackupAt: json['lastBackupAt'] != null
          ? DateTime.parse(json['lastBackupAt'] as String)
          : null,
    );
  }

  BackupSettings copyWith({
    bool? autoBackup,
    BackupFrequency? backupFrequency,
    DateTime? lastBackupAt,
  }) {
    return BackupSettings(
      autoBackup: autoBackup ?? this.autoBackup,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    );
  }
}

class UserSettings {
  final String userId;
  final NotificationSettings notifications;
  final AppearanceSettings appearance;
  final PrivacySettings privacy;
  final BackupSettings backup;
  final DateTime updatedAt;

  const UserSettings({
    required this.userId,
    required this.notifications,
    required this.appearance,
    required this.privacy,
    required this.backup,
    required this.updatedAt,
  });

  // 기본 설정 생성
  static UserSettings createDefault(String userId) {
    return UserSettings(
      userId: userId,
      notifications: NotificationSettings.defaultSettings,
      appearance: AppearanceSettings.defaultSettings,
      privacy: PrivacySettings.defaultSettings,
      backup: BackupSettings.defaultSettings,
      updatedAt: DateTime.now(),
    );
  }

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'notifications': notifications.toJson(),
      'appearance': appearance.toJson(),
      'privacy': privacy.toJson(),
      'backup': backup.toJson(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['userId'] as String,
      notifications: NotificationSettings.fromJson(
        json['notifications'] as Map<String, dynamic>,
      ),
      appearance: AppearanceSettings.fromJson(
        json['appearance'] as Map<String, dynamic>,
      ),
      privacy: PrivacySettings.fromJson(
        json['privacy'] as Map<String, dynamic>,
      ),
      backup: BackupSettings.fromJson(
        json['backup'] as Map<String, dynamic>,
      ),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  UserSettings copyWith({
    String? userId,
    NotificationSettings? notifications,
    AppearanceSettings? appearance,
    PrivacySettings? privacy,
    BackupSettings? backup,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      notifications: notifications ?? this.notifications,
      appearance: appearance ?? this.appearance,
      privacy: privacy ?? this.privacy,
      backup: backup ?? this.backup,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserSettings(userId: $userId, darkMode: ${appearance.darkMode}, language: ${appearance.language})';
  }
}