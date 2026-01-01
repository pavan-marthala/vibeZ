// lib/core/database/database_helper.dart
import 'package:music/core/features/shared/models/folder_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music_folders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE folders (
        id $idType,
        path $textType,
        name $textType,
        addedAt $textType
      )
    ''');
  }

  // Create - Insert folder
  Future<FolderModel> insertFolder(FolderModel folder) async {
    final db = await database;
    final id = await db.insert('folders', folder.toMap());
    return folder.copyWith(id: id);
  }

  // Read - Get all folders
  Future<List<FolderModel>> getAllFolders() async {
    final db = await database;
    final result = await db.query('folders', orderBy: 'addedAt DESC');
    return result.map((map) => FolderModel.fromMap(map)).toList();
  }

  // Read - Get folder by id
  Future<FolderModel?> getFolderById(int id) async {
    final db = await database;
    final maps = await db.query('folders', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return FolderModel.fromMap(maps.first);
    }
    return null;
  }

  // Update - Update folder
  Future<int> updateFolder(FolderModel folder) async {
    final db = await database;
    return db.update(
      'folders',
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  // Delete - Delete folder
  Future<int> deleteFolder(int id) async {
    final db = await database;
    return await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all folders
  Future<int> deleteAllFolders() async {
    final db = await database;
    return await db.delete('folders');
  }

  // Check if folder path already exists
  Future<bool> folderExists(String path) async {
    final db = await database;
    final result = await db.query(
      'folders',
      where: 'path = ?',
      whereArgs: [path],
    );
    return result.isNotEmpty;
  }

  // Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}
