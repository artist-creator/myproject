import 'package:flutter/material.dart';

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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDummyData();
  }

  void loadDummyData() {
    // Simulated API result
    movies = [
      {
        "Title": "Batman Begins",
        "Year": "2005",
        "Poster": "https://m.media-amazon.com/images/I/51k0qa6L9BL._AC_.jpg",
        "imdbID": "tt0372784"
      },
      {
        "Title": "The Dark Knight",
        "Year": "2008",
        "Poster": "https://m.media-amazon.com/images/I/51EbJjlLgFL._AC_.jpg",
        "imdbID": "tt0468569"
      }
    ];

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Add Movie")),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search movie...",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),

          if (!loading)
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {

                  final movie = movies[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Image.network(
                        movie["Poster"],
                        width: 50,
                      ),
                      title: Text(movie["Title"]),
                      subtitle: Text("Year: ${movie["Year"]}"),
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