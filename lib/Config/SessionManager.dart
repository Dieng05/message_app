import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserEmail = 'connected_user_email';

  static Future<void> setCurrentUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserEmail);
  }

  static Future<bool> isLoggedIn() async {
    final email = await getCurrentUserEmail();
    return email != null && email.isNotEmpty;
  }
}