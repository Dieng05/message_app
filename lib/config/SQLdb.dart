import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
  static Database?_database;

  Future<Database?> get database async{
    if(_database==null){
      _database = await initialisation();
      return _database;
    }
    else{
      return _database;
    }
  }

  Future<Database?> initialisation() async {

    String db_path = await getDatabasesPath();

    String path = join(db_path, "message_app.db");

    Database mydb = await openDatabase(path, onCreate: _createDB, version: 1);
    return mydb;
  }

  _createDB(Database db, int version) async {

    await db.execute('''
       CREATE TABLE message(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       idFrom String NOT NULL,
       idTo String NOT NULL,
       timestamp String NOT NULL,
       content Text NOT NULL,
       type INTEGER NOT NULL
       )''');
    print("=======la table message est créer avec succés ?====================");
  }

  Future<int> insertData(String sql) async{
    Database? mydb = await _database;

    int rep = await mydb!.rawInsert(sql);

    print("insertion de la ligne réussi avec succés");
    return rep;
  }

}