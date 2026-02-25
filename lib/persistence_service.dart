import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {

  static const String movieKey = "toWatchMovies";

  /// Save movie list
  static Future<void> saveMovies(
      List<Map<String, dynamic>> movies) async {

    final prefs = await SharedPreferences.getInstance();

    List<String> movieList =
        movies.map((movie) => jsonEncode(movie)).toList();

    await prefs.setStringList(movieKey, movieList);
  }

  /// Load movie list
  static Future<List<Map<String, dynamic>>> loadMovies() async {

    final prefs = await SharedPreferences.getInstance();

    List<String>? movieList =
        prefs.getStringList(movieKey);

    if (movieList != null) {
      return movieList
          .map((movie) =>
              jsonDecode(movie) as Map<String, dynamic>)
          .toList();
    }

    return [];
  }
}