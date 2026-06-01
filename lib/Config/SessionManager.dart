import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserEmail = 'connected_user_email';

  // Sauvegarder l'email de l'utilisateur connecté (appeler après verifyUser)
  static Future<void> setCurrentUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  // Récupérer l'email de l'utilisateur connecté
  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  // Déconnexion
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserEmail);
  }

  // Vérifier si un user est connecté
  static Future<bool> isLoggedIn() async {
    final email = await getCurrentUserEmail();
    return email != null && email.isNotEmpty;
  }
}