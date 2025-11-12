// Temporarily disabled stub for testing
import '../../models/user_subscription.dart';

class CloudSyncService {
  static final CloudSyncService _instance = CloudSyncService._internal();
  factory CloudSyncService() => _instance;
  CloudSyncService._internal();

  Future<void> initialize() async {
    print('CloudSyncService: Disabled for testing');
  }

  Future<UserSubscription?> loadSubscription(String userId) async => null;
  Future<UserSubscription?> loadSubscriptionLocally() async => null;
  Future<void> saveSubscription(UserSubscription subscription) async {}
  Future<void> saveSubscriptionLocally(UserSubscription subscription) async {}
  Future<void> syncUserData() async {}
  Future<void> preloadAllUserData(String userId) async {}
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String displayName,
    required String provider,
    String? photoURL,
  }) async {}
  Future<void> syncWorkoutRecord(dynamic history) async {}
  void queueChange(String type, Map<String, dynamic> data) {}
}

class SyncStatus {
  final bool isSyncing;
  SyncStatus({this.isSyncing = false});
}
