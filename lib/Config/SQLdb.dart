import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
  static final Sqldb instance = Sqldb._init();
  static Database? _mydatabase;

  Sqldb._init();

  Future<Database> get database async {
    if (_mydatabase != null) {
      return _mydatabase!;
    }
    _mydatabase = await _initDatabase("message_app.db");
    return _mydatabase!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 3, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
       CREATE TABLE message(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       idFrom TEXT NOT NULL,
       idTo TEXT NOT NULL,
       timestamp TEXT NOT NULL,
       content TEXT NOT NULL,
       type INTEGER NOT NULL
       )''');

    await db.execute('''
       CREATE TABLE contact(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT NOT NULL,
       phone TEXT NOT NULL,
       ownerEmail TEXT NOT NULL,
       UNIQUE(phone, ownerEmail)
       )''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE contact ADD COLUMN ownerEmail TEXT NOT NULL DEFAULT ""');
    }
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS message');
      await db.execute('''
         CREATE TABLE message(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         idFrom TEXT NOT NULL,
         idTo TEXT NOT NULL,
         timestamp TEXT NOT NULL,
         content TEXT NOT NULL,
         type INTEGER NOT NULL
         )''');
    }
  }

  Future<int> insertMessage({
    required String idFrom,
    required String idTo,
    required String timestamp,
    required String content,
    required int type,
  }) async {
    final db = await database;
    return await db.rawInsert(
      '''INSERT INTO message (idFrom, idTo, timestamp, content, type) VALUES (?, ?, ?, ?, ?)''',
      [idFrom, idTo, timestamp, content, type],
    );
  }

  Future<int> updateMessage({required int id, required String content}) async {
    final db = await database;
    return await db.rawUpdate(
      '''UPDATE message SET content = ? WHERE id = ?''',
      [content, id],
    );
  }

  Future<int> deleteMessage(int id) async {
    final db = await database;
    return await db.rawDelete(
      '''DELETE FROM message WHERE id = ?''',
      [id],
    );
  }

  Future<List<Map<String, dynamic>>> readMessagesByPeer({
    required String currentUserId,
    required String peerId,
  }) async {
    final db = await database;
    return await db.rawQuery(
      '''SELECT * FROM message
       WHERE (idFrom = ? AND idTo = ?)
          OR (idFrom = ? AND idTo = ?)
       ORDER BY timestamp ASC''',
      [currentUserId, peerId, peerId, currentUserId],
    );
  }

  Future<int> insertContact({
    required String name,
    required String phone,
    required String ownerEmail,
  }) async {
    final db = await database;
    return await db.rawInsert(
      '''INSERT OR IGNORE INTO contact (name, phone, ownerEmail) VALUES (?, ?, ?)''',
      [name, phone, ownerEmail],
    );
  }

  Future<List<Map<String, dynamic>>> readContacts({required String ownerEmail}) async {
    final db = await database;
    return await db.rawQuery(
      '''SELECT * FROM contact WHERE ownerEmail = ? ORDER BY name ASC''',
      [ownerEmail],
    );
  }

  Future<List<Map<String, dynamic>>> readAllMessages({required String currentUserId}) async {
    final db = await database;
    return await db.rawQuery(
      '''SELECT * FROM message WHERE idFrom = ? OR idTo = ? ORDER BY timestamp DESC''',
      [currentUserId, currentUserId],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.rawDelete(
      '''DELETE FROM contact WHERE id = ?''',
      [id],
    );
  }
}