import 'package:flutter/material.dart';
import 'movie_api_service.dart';

class SearchScreen extends StatefulWidget {

  final Function(Map<String, dynamic>) onAddMovie;

  const SearchScreen({
    super.key,
    required this.onAddMovie,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<Map<String, dynamic>> movies = [];
  bool loading = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadTrending();
  }

  Future<void> loadTrending() async {
    try {
      setState(() {
        loading = true;
        errorMessage = "";
      });

      final results = await MovieApiService.getTrendingMovies();

      setState(() {
        movies = results;
        loading = false;
      });

    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Failed to load trending movies";
      });
    }
  }

  Future<void> searchMovies(String query) async {

    if (query.isEmpty) {
      loadTrending();
      return;
    }

    try {
      setState(() {
        loading = true;
        errorMessage = "";
      });

      final results = await MovieApiService.searchMovies(query);

      setState(() {
        movies = results;
        loading = false;
      });

    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Search failed";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Add Movie to Watch")),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search movies...",
                border: OutlineInputBorder(),
              ),
              onChanged: searchMovies,
            ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),

          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          if (!loading)
            Expanded(
              child: movies.isEmpty
                  ? const Center(child: Text("No movies found"))
                  : ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {

                        final movie = movies[index];

                        final posterPath = movie["poster_path"];
                        final posterUrl = posterPath != null
                            ? "https://image.tmdb.org/t/p/w200$posterPath"
                            : null;

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: posterUrl != null
                                ? Image.network(posterUrl, width: 50)
                                : const Icon(Icons.movie),

                            title: Text(movie["title"] ?? "No Title"),

                            subtitle: Text(
                              movie["release_date"] != null
                                  ? movie["release_date"]
                                  : "No Date",
                            ),

                            trailing: ElevatedButton(
                              child: const Text("Add"),
                              onPressed: () {
                                widget.onAddMovie(movie);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}