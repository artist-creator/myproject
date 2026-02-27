import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_styles.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> movies = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadTrending();
  }

  void _loadTrending() async {
    setState(() => loading = true);
    final results = await MovieApiService.getTrendingMovies();
    setState(() {
      movies = results;
      loading = false;
    });
  }

  void _search(String query) async {
    if (query.length < 2) return;
    setState(() => loading = true);
    final results = await MovieApiService.searchMovies(query);
    setState(() {
      movies = results;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Movie to Watch",
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            shadows: [
              const Shadow(
                blurRadius: 10.0,
                color: Colors.black12,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                fillColor: const Color(0xFFE8F5E9), // Very light green
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppStyles.inputBorderGreen, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppStyles.primaryBlue, width: 2),
                ),
              ),
            ),
          ),

          if (loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (movies.isEmpty)
            const Expanded(child: Center(child: Text("No movies found.")))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Poster Placeholder/Image
                        Container(
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                          child: movie['poster_path'] != null
                              ? Image.network(
                                  "https://image.tmdb.org/t/p/w200${movie['poster_path']}",
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.movie, size: 40),
                        ),
                        const SizedBox(width: 15),
                        // Movie Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie['title'] ?? "Unknown Title",
                                style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Year: ${movie['release_date']?.toString().split('-')[0] ?? 'N/A'}    IMDB: ${movie['vote_average'] ?? 'N/A'}",
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Category: ${_getCategory(movie)}",
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        // Add Button
                        ElevatedButton(
                          onPressed: () {
                            widget.onAddMovie(movie);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Movie added!")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.successGreen,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            minimumSize: const Size(60, 30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Add", style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _getCategory(Map<String, dynamic> movie) {
    // TMDB uses genre IDs. For now, we'll return a simple placeholder
    // or you can map these IDs to names.
    return "Movie";
  }
}
