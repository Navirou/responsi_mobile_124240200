import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUsername = 'logged_username';

  static const String expectedNIM = '124240200';
  static const String expectedPassword = '123';

  static Future<bool> login(String username, String password) async {
    final trimmedUser = username.trim();
    final trimmedPass = password.trim();

    if ((trimmedUser == expectedNIM || (trimmedUser.isNotEmpty && int.tryParse(trimmedUser) != null)) &&
        trimmedPass == expectedPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyIsLoggedIn, true);
      await prefs.setString(keyUsername, trimmedUser);
      return true;
    }
    return false;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername) ?? expectedNIM;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyIsLoggedIn);
    await prefs.remove(keyUsername);
  }
}
