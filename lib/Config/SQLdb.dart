import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
static Database?_database;

// cette fonction permet de recuperer la base de données
// uture pour dire que la fonction retournera tot ou tard une reponse donc faut juste attendre
// async dire que la fonctions fait des choses de maniere lente trop lente
// await pour dire que ça prend du temps mais faut attendre initialiation

  Future<Database?> get database async{
    if(_database==null){
    _database = await initialisation();
    return _database;
    }
    else{
    return _database;
    }
}

// la fonction qui fait l'initialisation de la base de donnees
  Future<Database?> initialisation() async {

    String db_path = await getDatabasesPath();

    String path = join(db_path, "message_app.db");

    Database mydb = await openDatabase(path, onCreate: _createDB, version: 1);
    return mydb;
  }
//la fonction pour la création de la base de données
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

    await db.execute('''
       CREATE TABLE contact(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT NOT NULL,
       phone TEXT NOT NULL UNIQUE
       )''');

    print("=== Tables message et contact créées avec succès ===");
  }

  // fonction pour l'inserer des données dans la base de données
  Future<int> insertMessage({
    required String idFrom,
    required String idTo,
    required String timestamp,
    required String content,
    required int type,
  }) async {
    Database? mydb = await database;

    int rep = await mydb!.rawInsert(
      '''INSERT INTO message (idFrom, idTo, timestamp, content, type) 
       VALUES (?, ?, ?, ?, ?)''',
      [idFrom, idTo, timestamp, content, type],
    );

    print("Message inséré avec succès, id: $rep");
    return rep;
  }

  //fonction pour la modification d'un message ça sera
  Future<int> updateMessage({
    required int id,
    required String content,
  }) async {
    Database? mydb = await database;

    int rep = await mydb!.rawUpdate(
      '''UPDATE message SET content = ? WHERE id = ?''',
      [content, id],
    );

    print("Message modifié avec succès");
    return rep;
  }

  //la fonction pour supprimer un message sera dans ce cas
  Future<int> deleteMessage(int id) async {
    Database? mydb = await database;

    int rep = await mydb!.rawDelete(
      '''DELETE FROM message WHERE id = ?''',
      [id],
    );
    print("Message supprimé avec succès");
    return rep;
  }

  // fonction pour lire tous les messages
  Future<List<Map<String, dynamic>>> readMessagesByPeer({
    required String currentUserId,
    required String peerId,
  }) async {
    Database? mydb = await database;

    List<Map<String, dynamic>> rep = await mydb!.rawQuery(
      '''SELECT * FROM message 
       WHERE (idFrom = ? AND idTo = ?) 
          OR (idFrom = ? AND idTo = ?)
       ORDER BY timestamp ASC''',
      [currentUserId, peerId, peerId, currentUserId],
    );
    return rep;
  }

  // ============ CONTACT ============

  // Insérer un contact
  Future<int> insertContact({
    required String name,
    required String phone,
  }) async {
    Database? mydb = await database;
    int rep = await mydb!.rawInsert(
      '''INSERT OR IGNORE INTO contact (name, phone) VALUES (?, ?)''',
      [name, phone],
    );
    print("Contact inséré : $name");
    return rep;
  }

  // Lire tous les contacts
  Future<List<Map<String, dynamic>>> readContacts() async {
    Database? mydb = await database;
    List<Map<String, dynamic>> rep = await mydb!.rawQuery(
      '''SELECT * FROM contact ORDER BY name ASC''',
    );
    print("Contacts récupérés : ${rep.length}");
    return rep;
  }

  // Supprimer un contact
  Future<int> deleteContact(int id) async {
    Database? mydb = await database;
    int rep = await mydb!.rawDelete(
      '''DELETE FROM contact WHERE id = ?''',
      [id],
    );
    print("Contact supprimé");
    return rep;
  }

  }