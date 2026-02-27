import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // User Authentication
  static Future<void> saveUser(String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  static Future<bool> authenticateUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');
    return (storedEmail == email && storedPassword == password);
  }

  // Movie Lists Persistence
  static Future<void> saveMovieLists(List<Map<String, dynamic>> toWatch, List<Map<String, dynamic>> alreadyWatched) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('toWatch', jsonEncode(toWatch));
    await prefs.setString('alreadyWatched', jsonEncode(alreadyWatched));
  }

  static Future<Map<String, List<Map<String, dynamic>>>> loadMovieLists() async {
    final prefs = await SharedPreferences.getInstance();
    String? toWatchStr = prefs.getString('toWatch');
    String? alreadyWatchedStr = prefs.getString('alreadyWatched');

    List<Map<String, dynamic>> toWatch = [];
    List<Map<String, dynamic>> alreadyWatched = [];

    if (toWatchStr != null) {
      toWatch = List<Map<String, dynamic>>.from(jsonDecode(toWatchStr));
    }
    if (alreadyWatchedStr != null) {
      alreadyWatched = List<Map<String, dynamic>>.from(jsonDecode(alreadyWatchedStr));
    }

    return {
      'toWatch': toWatch,
      'alreadyWatched': alreadyWatched,
    };
  }
}
