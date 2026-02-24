import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {

  static Future<void> saveUser(
      String username,
      String email,
      String password) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  static Future<bool> authenticateUser(
      String email,
      String password) async {

    final prefs = await SharedPreferences.getInstance();

    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (storedEmail == email && storedPassword == password) {
      return true;
    }
    return false;
  }
}