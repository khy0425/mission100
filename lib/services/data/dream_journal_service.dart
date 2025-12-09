import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/dream_entry.dart';
import 'database_service.dart';

/// 꿈 일기 관리 서비스
///
/// 꿈 일기의 완전한 CRUD 기능 제공:
/// - 생성 (Create)
/// - 조회 (Read)
/// - 수정 (Update)
/// - 삭제 (Delete)
/// - 검색 & 필터링
/// - 통계 & 분석
class DreamJournalService {
  static final DreamJournalService _instance = DreamJournalService._internal();
  factory DreamJournalService() => _instance;
  DreamJournalService._internal();

  final DatabaseService _dbService = DatabaseService();

  // ==================== CREATE ====================

  /// 새 꿈 일기 저장
  Future<bool> saveDream(DreamEntry dream) async {
    try {
      debugPrint('💾 Saving dream entry: ${dream.id}');
      final db = await _dbService.database;

      await db.insert(
        'dream_entry',
        dream.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('✅ Dream saved successfully: ${dream.id}');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving dream: $e');
      return false;
    }
  }

  /// 여러 꿈 일기 일괄 저장
  Future<int> saveMultipleDreams(List<DreamEntry> dreams) async {
    try {
      final db = await _dbService.database;
      final batch = db.batch();

      for (final dream in dreams) {
        batch.insert(
          'dream_entry',
          dream.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      final results = await batch.commit();
      debugPrint('✅ Saved ${results.length} dreams');
      return results.length;
    } catch (e) {
      debugPrint('❌ Error saving multiple dreams: $e');
      return 0;
    }
  }

  // ==================== READ ====================

  /// ID로 꿈 일기 조회
  Future<DreamEntry?> getDreamById(String id) async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return DreamEntry.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting dream by id: $e');
      return null;
    }
  }

  /// 모든 꿈 일기 조회 (최신순)
  Future<List<DreamEntry>> getAllDreams({
    int? limit,
    int? offset,
  }) async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        orderBy: 'dreamDate DESC, createdAt DESC',
        limit: limit,
        offset: offset,
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error getting all dreams: $e');
      return [];
    }
  }

  /// 사용자별 꿈 일기 조회
  Future<List<DreamEntry>> getDreamsByUserId(
    String userId, {
    int? limit,
  }) async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'dreamDate DESC',
        limit: limit,
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error getting dreams by user: $e');
      return [];
    }
  }

  /// 날짜별 꿈 일기 조회
  Future<List<DreamEntry>> getDreamsByDate(DateTime date) async {
    try {
      final db = await _dbService.database;
      final dateStr = date.toIso8601String().split('T')[0];

      final maps = await db.query(
        'dream_entry',
        where: 'dreamDate LIKE ?',
        whereArgs: ['$dateStr%'],
        orderBy: 'createdAt DESC',
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error getting dreams by date: $e');
      return [];
    }
  }

  /// 날짜 범위로 꿈 일기 조회
  Future<List<DreamEntry>> getDreamsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final db = await _dbService.database;
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      final maps = await db.query(
        'dream_entry',
        where: 'dreamDate >= ? AND dreamDate <= ?',
        whereArgs: [startStr, endStr],
        orderBy: 'dreamDate DESC',
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error getting dreams by date range: $e');
      return [];
    }
  }

  /// 자각몽만 조회
  Future<List<DreamEntry>> getLucidDreams({int? limit}) async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'wasLucid = 1',
        orderBy: 'dreamDate DESC',
        limit: limit,
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error getting lucid dreams: $e');
      return [];
    }
  }

  /// 즐겨찾기 꿈 일기 조회
  Future<List<DreamEntry>> getFavoriteDreams() async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'isFavorite = 1',
        orderBy: 'dreamDate DESC',
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error getting favorite dreams: $e');
      return [];
    }
  }

  /// AI 분석이 있는 꿈 조회
  Future<List<DreamEntry>> getDreamsWithAIAnalysis() async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'hasAiAnalysis = 1',
        orderBy: 'dreamDate DESC',
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error getting dreams with AI analysis: $e');
      return [];
    }
  }

  /// 최근 N개의 꿈 조회
  Future<List<DreamEntry>> getRecentDreams({int limit = 10}) async {
    return await getAllDreams(limit: limit);
  }

  // ==================== UPDATE ====================

  /// 꿈 일기 수정
  Future<bool> updateDream(DreamEntry dream) async {
    try {
      debugPrint('📝 Updating dream: ${dream.id}');
      final db = await _dbService.database;

      final count = await db.update(
        'dream_entry',
        dream.toMap(),
        where: 'id = ?',
        whereArgs: [dream.id],
      );

      if (count > 0) {
        debugPrint('✅ Dream updated successfully');
        return true;
      } else {
        debugPrint('⚠️ No dream found to update');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error updating dream: $e');
      return false;
    }
  }

  /// 즐겨찾기 토글
  Future<bool> toggleFavorite(String dreamId) async {
    try {
      final dream = await getDreamById(dreamId);
      if (dream == null) return false;

      final updated = dream.copyWith(isFavorite: !dream.isFavorite);
      return await updateDream(updated);
    } catch (e) {
      debugPrint('❌ Error toggling favorite: $e');
      return false;
    }
  }

  /// AI 분석 결과 연결
  Future<bool> linkAIAnalysis(String dreamId, String analysisId) async {
    try {
      final dream = await getDreamById(dreamId);
      if (dream == null) return false;

      final updated = dream.copyWith(
        aiAnalysisId: analysisId,
        hasAiAnalysis: true,
      );
      return await updateDream(updated);
    } catch (e) {
      debugPrint('❌ Error linking AI analysis: $e');
      return false;
    }
  }

  // ==================== DELETE ====================

  /// 꿈 일기 삭제
  Future<bool> deleteDream(String dreamId) async {
    try {
      debugPrint('🗑️ Deleting dream: $dreamId');
      final db = await _dbService.database;

      final count = await db.delete(
        'dream_entry',
        where: 'id = ?',
        whereArgs: [dreamId],
      );

      if (count > 0) {
        debugPrint('✅ Dream deleted successfully');
        return true;
      } else {
        debugPrint('⚠️ No dream found to delete');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error deleting dream: $e');
      return false;
    }
  }

  /// 여러 꿈 일기 일괄 삭제
  Future<int> deleteMultipleDreams(List<String> dreamIds) async {
    try {
      final db = await _dbService.database;
      final batch = db.batch();

      for (final id in dreamIds) {
        batch.delete(
          'dream_entry',
          where: 'id = ?',
          whereArgs: [id],
        );
      }

      final results = await batch.commit();
      debugPrint('✅ Deleted ${results.length} dreams');
      return results.length;
    } catch (e) {
      debugPrint('❌ Error deleting multiple dreams: $e');
      return 0;
    }
  }

  /// 모든 꿈 일기 삭제 (위험!)
  Future<int> deleteAllDreams() async {
    try {
      debugPrint('⚠️ Deleting ALL dreams');
      final db = await _dbService.database;
      return await db.delete('dream_entry');
    } catch (e) {
      debugPrint('❌ Error deleting all dreams: $e');
      return 0;
    }
  }

  // ==================== SEARCH & FILTER ====================

  /// 키워드로 꿈 검색 (제목 + 내용)
  Future<List<DreamEntry>> searchDreams(String keyword) async {
    try {
      if (keyword.isEmpty) return [];

      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'title LIKE ? OR content LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
        orderBy: 'dreamDate DESC',
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error searching dreams: $e');
      return [];
    }
  }

  /// 태그로 검색
  Future<List<DreamEntry>> searchByTag(String tag) async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'tags LIKE ?',
        whereArgs: ['%$tag%'],
        orderBy: 'dreamDate DESC',
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error searching by tag: $e');
      return [];
    }
  }

  /// 심볼로 검색
  Future<List<DreamEntry>> searchBySymbol(String symbol) async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'symbols LIKE ?',
        whereArgs: ['%$symbol%'],
        orderBy: 'dreamDate DESC',
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error searching by symbol: $e');
      return [];
    }
  }

  /// 자각도 범위로 필터링
  Future<List<DreamEntry>> filterByLucidityLevel({
    required int minLevel,
    required int maxLevel,
  }) async {
    try {
      final db = await _dbService.database;
      final maps = await db.query(
        'dream_entry',
        where: 'lucidityLevel >= ? AND lucidityLevel <= ?',
        whereArgs: [minLevel, maxLevel],
        orderBy: 'dreamDate DESC',
      );

      return maps.map((map) => DreamEntry.fromMap(map)).toList();
    } catch (e) {
      debugPrint('❌ Error filtering by lucidity level: $e');
      return [];
    }
  }

  // ==================== STATISTICS ====================

  /// 총 꿈 일기 개수
  Future<int> getTotalDreamCount() async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM dream_entry',
      );
      return result.first['count'] as int? ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting total dream count: $e');
      return 0;
    }
  }

  /// 자각몽 개수
  Future<int> getLucidDreamCount() async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM dream_entry WHERE wasLucid = 1',
      );
      return result.first['count'] as int? ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting lucid dream count: $e');
      return 0;
    }
  }

  /// 평균 자각도
  Future<double> getAverageLucidityLevel() async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery(
        'SELECT AVG(lucidityLevel) as avg FROM dream_entry',
      );
      return result.first['avg'] as double? ?? 0.0;
    } catch (e) {
      debugPrint('❌ Error getting average lucidity: $e');
      return 0.0;
    }
  }

  /// 자각몽 성공률 (%)
  Future<double> getLucidDreamSuccessRate() async {
    try {
      final total = await getTotalDreamCount();
      if (total == 0) return 0.0;

      final lucid = await getLucidDreamCount();
      return (lucid / total) * 100;
    } catch (e) {
      debugPrint('❌ Error getting success rate: $e');
      return 0.0;
    }
  }

  /// 가장 많이 나타나는 심볼 Top N
  Future<Map<String, int>> getTopSymbols({int limit = 10}) async {
    try {
      final dreams = await getAllDreams();
      final symbolCounts = <String, int>{};

      for (final dream in dreams) {
        for (final symbol in dream.symbols) {
          symbolCounts[symbol] = (symbolCounts[symbol] ?? 0) + 1;
        }
      }

      // Sort by count descending
      final sortedEntries = symbolCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Map.fromEntries(sortedEntries.take(limit));
    } catch (e) {
      debugPrint('❌ Error getting top symbols: $e');
      return {};
    }
  }

  /// 가장 많이 나타나는 감정 Top N
  Future<Map<String, int>> getTopEmotions({int limit = 10}) async {
    try {
      final dreams = await getAllDreams();
      final emotionCounts = <String, int>{};

      for (final dream in dreams) {
        for (final emotion in dream.emotions) {
          emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
        }
      }

      final sortedEntries = emotionCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Map.fromEntries(sortedEntries.take(limit));
    } catch (e) {
      debugPrint('❌ Error getting top emotions: $e');
      return {};
    }
  }

  /// 월별 꿈 일기 통계
  Future<Map<String, int>> getDreamCountByMonth(int year) async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery('''
        SELECT strftime('%m', dreamDate) as month, COUNT(*) as count
        FROM dream_entry
        WHERE strftime('%Y', dreamDate) = ?
        GROUP BY month
        ORDER BY month
      ''', [year.toString()]);

      return Map.fromEntries(
        result.map((row) => MapEntry(
              row['month'] as String,
              row['count'] as int,
            )),
      );
    } catch (e) {
      debugPrint('❌ Error getting dream count by month: $e');
      return {};
    }
  }

  /// 연속 꿈 일기 작성 일수 (Streak)
  Future<int> getDreamJournalStreak() async {
    try {
      final dreams = await getAllDreams();
      if (dreams.isEmpty) return 0;

      int streak = 0;
      DateTime? lastDate;

      for (final dream in dreams) {
        final dreamDate = DateTime(
          dream.dreamDate.year,
          dream.dreamDate.month,
          dream.dreamDate.day,
        );

        if (lastDate == null) {
          // 첫 번째 꿈
          lastDate = dreamDate;
          streak = 1;
        } else {
          final daysDiff = lastDate.difference(dreamDate).inDays;
          if (daysDiff == 1) {
            // 연속된 날짜
            streak++;
            lastDate = dreamDate;
          } else if (daysDiff == 0) {
            // 같은 날 여러 꿈 (streak 유지)
            continue;
          } else {
            // 연속 끊김
            break;
          }
        }
      }

      return streak;
    } catch (e) {
      debugPrint('❌ Error getting dream journal streak: $e');
      return 0;
    }
  }

  // ==================== UTILITY ====================

  /// 데이터베이스 상태 확인
  Future<Map<String, dynamic>> getDatabaseStatus() async {
    try {
      final totalDreams = await getTotalDreamCount();
      final lucidDreams = await getLucidDreamCount();
      final avgLucidity = await getAverageLucidityLevel();
      final streak = await getDreamJournalStreak();

      return {
        'totalDreams': totalDreams,
        'lucidDreams': lucidDreams,
        'successRate': await getLucidDreamSuccessRate(),
        'averageLucidity': avgLucidity,
        'currentStreak': streak,
        'databaseExists': true,
      };
    } catch (e) {
      debugPrint('❌ Error getting database status: $e');
      return {
        'totalDreams': 0,
        'lucidDreams': 0,
        'successRate': 0.0,
        'averageLucidity': 0.0,
        'currentStreak': 0,
        'databaseExists': false,
        'error': e.toString(),
      };
    }
  }
}
