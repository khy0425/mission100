import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../../models/checklist_history.dart';
import '../notification/notification_service.dart';
import 'dart:io';

class ChecklistHistoryService {
  static Database? _database;
  static Database? _testDatabase;
  static const String tableName = 'checklist_history';

  // Callback system for UI updates (similar to WorkoutHistoryService)
  static final List<VoidCallback> _onChecklistSavedCallbacks = [];

  // Test database setup
  static void setTestDatabase(Database testDb) {
    _testDatabase = testDb;
  }

  // Add callback for checklist save events
  static void addOnChecklistSavedCallback(VoidCallback callback) {
    if (!_onChecklistSavedCallbacks.contains(callback)) {
      _onChecklistSavedCallbacks.add(callback);
    }
  }

  // Remove callback
  static void removeOnChecklistSavedCallback(VoidCallback callback) {
    _onChecklistSavedCallbacks.remove(callback);
  }

  // Clear all callbacks
  static void clearOnChecklistSavedCallbacks() {
    _onChecklistSavedCallbacks.clear();
  }

  static Future<Database> get database async {
    if (_testDatabase != null) return _testDatabase!;

    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'checklist_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        dayNumber INTEGER NOT NULL,
        completedTasks TEXT NOT NULL,
        totalTasksCompleted INTEGER NOT NULL,
        totalRequiredTasks INTEGER NOT NULL,
        completionRate REAL NOT NULL,
        duration INTEGER NOT NULL,
        isWbtbDay INTEGER NOT NULL DEFAULT 0
      )
    ''');

    debugPrint('✅ Checklist history table created (v$version)');
  }

  static Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    debugPrint('🔧 Checklist database upgrade: v$oldVersion → v$newVersion');
    // Future upgrades can be handled here
  }

  /// Save checklist completion record
  static Future<void> saveChecklistHistory(ChecklistHistory history) async {
    debugPrint('💾 Saving checklist record: ${history.id}');
    debugPrint('📅 Date: ${history.date}');
    debugPrint('📊 Day ${history.dayNumber}: ${history.totalTasksCompleted}/${history.totalRequiredTasks} tasks, ${(history.completionRate * 100).toStringAsFixed(1)}%');

    try {
      final db = await database;

      // Check count before save
      final beforeCount = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableName',
      );
      final countBefore = beforeCount.first['count'] as int;
      debugPrint('🗄️ Records before save: $countBefore');

      await db.insert(
        tableName,
        history.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Check count after save
      final afterCount = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableName',
      );
      final countAfter = afterCount.first['count'] as int;
      debugPrint('🗄️ Records after save: $countAfter (${countAfter - countBefore > 0 ? 'increased' : 'same'})');

      // Verify saved data
      final savedChecklist = await getChecklistByDate(history.date);
      if (savedChecklist != null) {
        debugPrint('✅ Checklist save verified: ${savedChecklist.id} - Day ${savedChecklist.dayNumber}');
      } else {
        debugPrint('❌ Checklist save verification failed: data not found');
      }

      // Trigger UI update callbacks
      debugPrint('📞 Calling UI update callbacks (${_onChecklistSavedCallbacks.length} registered)');

      if (_onChecklistSavedCallbacks.isEmpty) {
        debugPrint('⚠️ No callbacks registered. UI may not be initialized yet.');
      }

      for (int i = 0; i < _onChecklistSavedCallbacks.length; i++) {
        try {
          debugPrint('📞 Calling callback $i...');
          _onChecklistSavedCallbacks[i]();
          debugPrint('✅ Callback $i completed');
        } catch (e) {
          debugPrint('❌ Callback $i failed: $e');
        }
      }
      debugPrint('📞 All callbacks completed');

      // Cancel today's reminder
      await NotificationService.cancelTodayWorkoutReminder();
      debugPrint('🔕 Today\'s reminder cancelled');

      // Show completion celebration
      await NotificationService.showWorkoutCompletionCelebration(
        totalReps: history.totalTasksCompleted,
        completionRate: history.completionRate,
      );
      debugPrint('🎉 Completion celebration notification sent');

      // Check streak and send encouragement
      final streak = await getCurrentStreak();
      debugPrint('🔥 Current streak: $streak days');

      if (streak >= 3 && streak % 3 == 0) {
        await NotificationService.showStreakEncouragement(streak);
        debugPrint('🏆 Streak encouragement sent: $streak days');
      }

      debugPrint('✅ Checklist save complete: ${history.date} - UI callbacks triggered');
    } catch (e, stackTrace) {
      debugPrint('❌ Checklist save error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get checklist record by date
  static Future<ChecklistHistory?> getChecklistByDate(DateTime date) async {
    final db = await database;
    final dateStr = _dateToString(date);

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'date LIKE ?',
      whereArgs: ['$dateStr%'],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ChecklistHistory.fromMap(maps.first);
    }
    return null;
  }

  /// Get all checklist records
  static Future<List<ChecklistHistory>> getAllChecklists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return ChecklistHistory.fromMap(maps[i]);
    });
  }

  /// Get checklist records for a specific month
  static Future<List<ChecklistHistory>> getChecklistsByMonth(
    DateTime month,
  ) async {
    final db = await database;
    final monthStr = _monthToString(month);

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'date LIKE ?',
      whereArgs: ['$monthStr%'],
      orderBy: 'date ASC',
    );

    return List.generate(maps.length, (i) {
      return ChecklistHistory.fromMap(maps[i]);
    });
  }

  /// Delete checklist record
  static Future<void> deleteChecklist(String id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Get statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT
        COUNT(*) as totalChecklists,
        AVG(completionRate) as averageCompletion,
        SUM(totalTasksCompleted) as totalTasks,
        MAX(completionRate) as bestCompletion,
        AVG(duration) as averageDuration
      FROM $tableName
    ''');

    if (result.isNotEmpty) {
      return result.first;
    }
    return {
      'totalChecklists': 0,
      'averageCompletion': 0.0,
      'totalTasks': 0,
      'bestCompletion': 0.0,
      'averageDuration': 0,
    };
  }

  /// Calculate current streak (consecutive days)
  static Future<int> getCurrentStreak() async {
    final checklists = await getAllChecklists();
    if (checklists.isEmpty) return 0;

    // Group by date (remove time component)
    final checklistDates = checklists
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toSet()
        .toList();

    checklistDates.sort((a, b) => b.compareTo(a)); // Most recent first

    int streak = 0;
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    // Start checking from yesterday (today can still be completed)
    DateTime checkDate = todayNormalized.subtract(const Duration(days: 1));

    // If completed today, start from today
    if (checklistDates.contains(todayNormalized)) {
      checkDate = todayNormalized;
    }

    for (int i = 0; i < 100; i++) {
      // Check up to 100 days
      final currentCheckDate = checkDate.subtract(Duration(days: i));

      if (checklistDates.contains(currentCheckDate)) {
        streak++;
      } else {
        break; // Streak broken
      }
    }

    return streak;
  }

  /// Get number of checklist days in a period
  static Future<int> getChecklistDaysInPeriod(int days) async {
    final checklists = await getAllChecklists();
    final cutoffDate = DateTime.now().subtract(Duration(days: days));

    return checklists
        .where((c) => c.date.isAfter(cutoffDate))
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toSet()
        .length;
  }

  /// Get progress for the 30-day program
  /// Returns completed days count (1-30)
  static Future<int> getProgramProgress() async {
    final checklists = await getAllChecklists();

    // Count unique day numbers (1-30)
    final completedDays = checklists
        .where((c) => c.dayNumber >= 1 && c.dayNumber <= 30)
        .map((c) => c.dayNumber)
        .toSet()
        .length;

    return completedDays;
  }

  /// Check if program is complete (all 30 days done)
  static Future<bool> isProgramComplete() async {
    final progress = await getProgramProgress();
    return progress >= 30;
  }

  /// 총 XP 계산 (체크리스트 완료율 기반)
  ///
  /// 각 체크리스트 완료 = (완료율 × 100) XP
  /// 예: 100% 완료 = 100 XP, 50% 완료 = 50 XP
  static Future<int> getTotalXP() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(completionRate * 100) as totalXP
      FROM $tableName
    ''');

    if (result.isNotEmpty && result.first['totalXP'] != null) {
      return (result.first['totalXP'] as num).round();
    }
    return 0;
  }

  // Date to string (YYYY-MM-DD)
  static String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Month to string (YYYY-MM)
  static String _monthToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  /// Clear all records (for data reset)
  static Future<void> clearAllRecords() async {
    final db = await database;
    await db.delete(tableName);
    debugPrint('🗑️ All checklist records cleared');
  }

  /// Reset database (recreate from scratch)
  static Future<void> resetDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), 'checklist_history.db');
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        debugPrint('🗑️ Checklist database file deleted');
      }

      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      debugPrint('✅ Checklist database reset complete');
    } catch (e) {
      debugPrint('❌ Checklist database reset error: $e');
      rethrow;
    }
  }
}
