import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/User.dart';

class MessageDatabase {
  static final MessageDatabase instance = MessageDatabase._init();
  static Database? _mydatabase;

  Future<Database> get database async {
    if (_mydatabase != null) {
      return _mydatabase!;
    }
    return await _initDatabase("message.db");
  }

  MessageDatabase._init();

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDBUser);
  }

  Future<void> _createDBUser(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, 
      firstName TEXT NOT NULL, 
      lastName TEXT NOT NULL, 
      email TEXT UNIQUE NOT NULL)''',
    );
  }

  Future<void> insertUser(User user) async {
    final db = await instance.database;
    await db.insert("users", user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User(
        firstName: maps.first['firstName'].toString(),
        lastName: maps.first['lastName'].toString(),
        email: maps.first['email'].toString(),
        uid: maps.first['uid'].toString(),
      );
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await instance.database;
    await db.update(
      "users",
      user.toMap(),
      where: "email = ?",
      whereArgs: [user.email],
    );
  }

  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    final maps = await db.query("users");
    return List.generate(maps.length, (i) {
      return User(
        firstName: maps[i]['firstName'].toString(),
        lastName: maps[i]['lastName'].toString(),
        email: maps[i]['email'].toString(),
        uid: maps[i]['uid'].toString(),

      );
    });
  }

  Future<bool> verifyUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
    if (maps.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
  Future<void> deleteUserByEmail(String email) async {
    final db = await instance.database;
    await db.delete("users", where: "email = ?", whereArgs: [email]);
  }
}
