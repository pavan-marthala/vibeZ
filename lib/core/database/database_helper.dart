import 'package:music/core/features/shared/models/folder_model.dart';
import 'package:music/core/features/shared/models/listening_stats.dart';
import 'package:music/core/features/shared/models/play_history.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vibeZ.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3, // Changed from 2 to 3
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    /// Folders table
    await db.execute('''
      CREATE TABLE folders (
        id $idType,
        path $textType,
        name $textType,
        addedAt $textType
      )
    ''');

    /// Play history table with albumArtPath from the start
    await db.execute('''
      CREATE TABLE play_history (
        id $idType,
        trackId $textType,
        trackTitle $textType,
        artist $textType,
        album $textType,
        playedAt $textType,
        playDuration $intType,
        completed $intType,
        albumArtPath TEXT
      )
    ''');

    /// Create indexes for better query performance
    await db.execute('CREATE INDEX idx_track_id ON play_history(trackId)');
    await db.execute('CREATE INDEX idx_artist ON play_history(artist)');
    await db.execute('CREATE INDEX idx_played_at ON play_history(playedAt)');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT NOT NULL';
      const intType = 'INTEGER NOT NULL';

      await db.execute('''
        CREATE TABLE play_history (
          id $idType,
          trackId $textType,
          trackTitle $textType,
          artist $textType,
          album $textType,
          playedAt $textType,
          playDuration $intType,
          completed $intType
        )
      ''');

      await db.execute('CREATE INDEX idx_track_id ON play_history(trackId)');
      await db.execute('CREATE INDEX idx_artist ON play_history(artist)');
      await db.execute('CREATE INDEX idx_played_at ON play_history(playedAt)');
    }

    if (oldVersion < 3) {
      // Add albumArtPath column
      try {
        await db.execute('''
          ALTER TABLE play_history ADD COLUMN albumArtPath TEXT
        ''');
      } catch (e) {
        print('Column albumArtPath might already exist: $e');
      }
    }
  }

  /// ==================== Folder Methods ====================

  Future<FolderModel> insertFolder(FolderModel folder) async {
    final db = await database;
    final id = await db.insert('folders', folder.toMap());
    return folder.copyWith(id: id);
  }

  Future<List<FolderModel>> getAllFolders() async {
    final db = await database;
    final result = await db.query('folders', orderBy: 'addedAt DESC');
    return result.map((map) => FolderModel.fromMap(map)).toList();
  }

  Future<FolderModel?> getFolderById(int id) async {
    final db = await database;
    final maps = await db.query('folders', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return FolderModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateFolder(FolderModel folder) async {
    final db = await database;
    return db.update(
      'folders',
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  Future<int> deleteFolder(int id) async {
    final db = await database;
    return await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllFolders() async {
    final db = await database;
    return await db.delete('folders');
  }

  Future<bool> folderExists(String path) async {
    final db = await database;
    final result = await db.query(
      'folders',
      where: 'path = ?',
      whereArgs: [path],
    );
    return result.isNotEmpty;
  }

  /// ==================== Play History Methods ====================

  Future<PlayHistory> insertPlayHistory(PlayHistory history) async {
    final db = await database;
    final id = await db.insert('play_history', history.toMap());
    return PlayHistory(
      id: id,
      trackId: history.trackId,
      trackTitle: history.trackTitle,
      artist: history.artist,
      album: history.album,
      playedAt: history.playedAt,
      playDuration: history.playDuration,
      completed: history.completed,
      albumArtPath: history.albumArtPath,
    );
  }

  Future<List<PlayHistory>> getRecentHistory({int limit = 20}) async {
    final db = await database;
    final result = await db.query(
      'play_history',
      orderBy: 'playedAt DESC',
      limit: limit,
    );
    return result.map((map) => PlayHistory.fromMap(map)).toList();
  }

  Future<List<TrackStats>> getTopTracks({int limit = 10}) async {
    final db = await database;

    // First check if albumArtPath column exists
    final tableInfo = await db.rawQuery('PRAGMA table_info(play_history)');
    final hasAlbumArtPath = tableInfo.any(
      (col) => col['name'] == 'albumArtPath',
    );

    final result = await db.rawQuery(
      '''
      SELECT 
        trackId,
        trackTitle as title,
        artist,
        album,
        COUNT(*) as playCount,
        SUM(playDuration) as totalPlayTime
      FROM play_history
      GROUP BY trackId
      ORDER BY playCount DESC, totalPlayTime DESC
      LIMIT ?
    ''',
      [limit],
    );

    final topTracks = <TrackStats>[];

    for (final map in result) {
      final trackId = map['trackId'] as String;
      String? albumArtPath;

      // Only query albumArtPath if column exists
      if (hasAlbumArtPath) {
        try {
          final artResult = await db.rawQuery(
            '''
            SELECT albumArtPath FROM play_history 
            WHERE trackId = ? AND albumArtPath IS NOT NULL 
            LIMIT 1
          ''',
            [trackId],
          );

          if (artResult.isNotEmpty && artResult.first['albumArtPath'] != null) {
            albumArtPath = artResult.first['albumArtPath'] as String;
          }
        } catch (e) {
          print('Error fetching album art: $e');
        }
      }

      topTracks.add(
        TrackStats(
          trackId: trackId,
          title: map['title'] as String,
          artist: map['artist'] as String,
          playCount: map['playCount'] as int,
          totalPlayTime: map['totalPlayTime'] as int,
          albumArtPath: albumArtPath,
        ),
      );
    }

    return topTracks;
  }

  Future<List<ArtistStats>> getTopArtists({int limit = 10}) async {
    final db = await database;

    // Get all play history
    final result = await db.query('play_history');

    // Process artists manually to handle comma-separated values
    final Map<String, ArtistData> artistMap = {};

    for (final row in result) {
      final artistString = row['artist'] as String;
      final trackId = row['trackId'] as String;
      final playDuration = row['playDuration'] as int;

      // Split by common separators
      final artists = artistString
          .split(RegExp(r'[,;&/]'))
          .map((a) => a.trim())
          .where((a) => a.isNotEmpty)
          .toList();

      for (final artist in artists) {
        if (!artistMap.containsKey(artist)) {
          artistMap[artist] = ArtistData(
            artist: artist,
            trackIds: {},
            playCount: 0,
            totalPlayTime: 0,
          );
        }

        artistMap[artist]!.trackIds.add(trackId);
        artistMap[artist]!.playCount++;
        artistMap[artist]!.totalPlayTime += playDuration;
      }
    }

    // Convert to list and sort
    final artistStats =
        artistMap.values
            .map(
              (data) => ArtistStats(
                artist: data.artist,
                playCount: data.playCount,
                totalPlayTime: data.totalPlayTime,
                trackCount: data.trackIds.length,
              ),
            )
            .toList()
          ..sort((a, b) {
            final countCompare = b.playCount.compareTo(a.playCount);
            if (countCompare != 0) return countCompare;
            return b.totalPlayTime.compareTo(a.totalPlayTime);
          });

    return artistStats.take(limit).toList();
  }

  Future<ListeningStats> getListeningStats() async {
    final db = await database;

    /// Get overall stats
    final overallStats = await db.rawQuery('''
      SELECT 
        COUNT(*) as totalPlays,
        SUM(playDuration) as totalListeningTime,
        COUNT(DISTINCT trackId) as uniqueTracks,
        COUNT(DISTINCT artist) as uniqueArtists
      FROM play_history
    ''');

    final stats = overallStats.first;

    /// Get most played track
    final mostPlayedTrackResult = await db.rawQuery('''
      SELECT trackTitle
      FROM play_history
      GROUP BY trackId
      ORDER BY COUNT(*) DESC
      LIMIT 1
    ''');

    final mostPlayedTrack = mostPlayedTrackResult.isNotEmpty
        ? mostPlayedTrackResult.first['trackTitle'] as String
        : 'No data';

    /// Get top artist
    final topArtistResult = await db.rawQuery('''
      SELECT artist
      FROM play_history
      GROUP BY artist
      ORDER BY COUNT(*) DESC
      LIMIT 1
    ''');

    final topArtist = topArtistResult.isNotEmpty
        ? topArtistResult.first['artist'] as String
        : 'No data';

    /// Get top tracks and artists
    final topTracks = await getTopTracks(limit: 5);
    final topArtists = await getTopArtists(limit: 5);
    final recentHistory = await getRecentHistory(limit: 10);

    return ListeningStats(
      totalPlays: stats['totalPlays'] as int? ?? 0,
      totalListeningTime: stats['totalListeningTime'] as int? ?? 0,
      uniqueTracks: stats['uniqueTracks'] as int? ?? 0,
      uniqueArtists: stats['uniqueArtists'] as int? ?? 0,
      mostPlayedTrack: mostPlayedTrack,
      topArtist: topArtist,
      topTracks: topTracks,
      topArtists: topArtists,
      recentHistory: recentHistory,
    );
  }

  Future<int> deleteOldHistory({int daysToKeep = 90}) async {
    final db = await database;
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    return await db.delete(
      'play_history',
      where: 'playedAt < ?',
      whereArgs: [cutoffDate.toIso8601String()],
    );
  }

  Future<int> clearAllHistory() async {
    final db = await database;
    return await db.delete('play_history');
  }

  /// Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}

/// Helper class for processing artists
class ArtistData {
  final String artist;
  final Set<String> trackIds;
  int playCount;
  int totalPlayTime;

  ArtistData({
    required this.artist,
    required this.trackIds,
    required this.playCount,
    required this.totalPlayTime,
  });
}
