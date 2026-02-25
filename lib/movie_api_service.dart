import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApiService {

  static const String apiKey = "1769584f";

  static String buildProxyUrl(String url) {
    return "https://api.allorigins.win/raw?url=${Uri.encodeComponent(url)}";
  }

  static Future<List<Map<String, dynamic>>> searchMovies(String query) async {

    final originalUrl =
        "https://www.omdbapi.com/?apikey=$apiKey&s=$query";

    final proxyUrl = buildProxyUrl(originalUrl);

    final response = await http.get(Uri.parse(proxyUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["Response"] == "True") {
        return List<Map<String, dynamic>>.from(data["Search"]);
      }
    }

    return [];
  }

  static Future<Map<String, dynamic>?> getMovieDetails(String imdbID) async {

    final originalUrl =
        "https://www.omdbapi.com/?apikey=$apiKey&i=$imdbID";

    final proxyUrl = buildProxyUrl(originalUrl);

    final response = await http.get(Uri.parse(proxyUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["Response"] == "True") {
        return data;
      }
    }

    return null;
  }

  static Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    return searchMovies("Batman");
  }
}