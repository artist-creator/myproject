import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApiService {
  static const String apiKey = "cb07a1e0544ab7f2c2d332f39f4b4116";
  static const String baseUrl = "https://api.themoviedb.org/3";

  // Search for movies by title
  static Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse("$baseUrl/search/movie?api_key=$apiKey&query=${Uri.encodeComponent(query)}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data["results"] ?? []);
    }
    return [];
  }

  // Get trending movies for the home/search screen initial state
  static Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    final url = Uri.parse("$baseUrl/trending/movie/day?api_key=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data["results"] ?? []);
    }
    return [];
  }

  // Get full details (including cast) for the Details screen
  static Future<Map<String, dynamic>?> getMovieDetails(int movieId) async {
    final url = Uri.parse("$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }
}
