import '../../models/user_profile.dart';

/// Stub service for backward compatibility
/// This service is deprecated and kept only to prevent compilation errors
/// Use LucidDreamProgramService instead
class WorkoutProgramService {
  /// Returns null - deprecated method
  Future<dynamic> getNextWorkout(UserProfile profile) async {
    return null;
  }

  /// Returns null - deprecated method
  Future<dynamic> getProgress(UserProfile profile) async {
    return null;
  }
}
