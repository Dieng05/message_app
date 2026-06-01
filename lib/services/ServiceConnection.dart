import 'package:message_app/models/User.dart';

import '../Config/MessageDatabase.dart';

class ServiceConnection {

  MessageDatabase db = MessageDatabase.instance;

  Future<User?> getUserByEmail(String email) async {
    return await db.getUserByEmail(email);
  }

  Future<void> insertUser(User user) async {
    db.insertUser(user);
  }

  Future<void> updateUser(User user) async{
    db.updateUser(user);
  }

  Future<void> deleteUser(String email) async{
    db.deleteUserByEmail(email);
  }

  Future<bool> verifyUser(String email, String password) async{
    return await db.verifyUser(email, password);
  }

  Future<List<User>> getAllUsers() async{
    return await db.getAllUsers();
  }

}