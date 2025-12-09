import '../../models/workout_history.dart';

/// Stub service for backward compatibility
/// This service is deprecated and kept only to prevent compilation errors
/// Use ChecklistHistoryService instead
class WorkoutHistoryService {
  /// Returns null - deprecated static method
  static Future<WorkoutHistory?> getTodayCompletedWorkout(String dateString) async {
    return null;
  }
}
