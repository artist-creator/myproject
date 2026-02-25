import 'package:flutter/material.dart';
import 'search_screen.dart';

class DetailScreen extends StatelessWidget {

  final Map<String, dynamic> movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    final posterPath = movie["poster_path"];
    final posterUrl = posterPath != null
        ? "https://image.tmdb.org/t/p/w300$posterPath"
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie["title"] ?? movie["Title"] ?? "Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (posterUrl != null)
              Center(
                child: Image.network(posterUrl, height: 250),
              ),

            const SizedBox(height: 20),

            Text(
              movie["overview"] ?? "No description available.",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchScreen(
                onAddMovie: (movie) {
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}