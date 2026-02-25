import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApiService {

  static const String apiKey = "cb07a1e0544ab7f2c2d332f39f4b4116";
  static const String baseUrl = "https://api.themoviedb.org/3";

  static Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    try {
      final url = Uri.parse(
          "$baseUrl/search/movie?api_key=$apiKey&query=$query");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data["results"]);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    try {
      final url = Uri.parse(
          "$baseUrl/trending/movie/day?api_key=$apiKey");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data["results"]);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}