import 'package:flutter/material.dart';
import 'movie_api_service.dart';

class DetailScreen extends StatefulWidget {

  final Map<String, dynamic> movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Map<String, dynamic>? fullDetails;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final details =
        await MovieApiService.getMovieDetails(widget.movie["imdbID"]);

    setState(() {
      fullDetails = details;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(widget.movie["Title"])),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [

                  if (fullDetails?["Poster"] != "N/A")
                    Image.network(fullDetails?["Poster"]),

                  const SizedBox(height: 20),

                  Text("Genre: ${fullDetails?["Genre"]}"),
                  Text("IMDB Rating: ${fullDetails?["imdbRating"]}"),
                  Text("Actors: ${fullDetails?["Actors"]}"),

                  const SizedBox(height: 10),

                  Text(fullDetails?["Plot"] ?? ""),
                ],
              ),
            ),
    );
  }
}