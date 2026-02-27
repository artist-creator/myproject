import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_styles.dart';
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
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    // TMDB uses 'id', OMDb used 'imdbID'
    final id = widget.movie['id'] ?? 0;
    if (id != 0) {
      final details = await MovieApiService.getMovieDetails(id);
      setState(() {
        fullDetails = details;
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = fullDetails ?? widget.movie;
    final String posterPath = movie['poster_path'] ?? '';
    final String title = movie['title'] ?? movie['Title'] ?? 'Unknown';
    final String year = movie['release_date']?.toString().split('-')[0] ?? movie['Year'] ?? 'N/A';
    final String rating = (movie['vote_average'] ?? movie['imdbRating'] ?? 'N/A').toString();
    
    // Extract cast names from credits
    String cast = "N/A";
    if (fullDetails != null && fullDetails!['credits'] != null) {
      final List castList = fullDetails!['credits']['cast'] ?? [];
      cast = castList.take(5).map((actor) => actor['name']).join(', ');
    }

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
          "Details",
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            shadows: [
              const Shadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, 4)),
            ],
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large Poster Placeholder
                  Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      color: AppStyles.cardGrey,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: posterPath.isNotEmpty
                        ? Image.network(
                            "https://image.tmdb.org/t/p/w500$posterPath",
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.movie, size: 100, color: Colors.black26),
                  ),
                  const SizedBox(height: 25),
                  
                  _buildDetailRow("Title:", title),
                  _buildDetailRow("Release Year:", year),
                  _buildDetailRow("IMDB Rating:", rating),
                  _buildDetailRow("Cast:", cast),
                  
                  const SizedBox(height: 15),
                  Text(
                    "Description:",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie['overview'] ?? movie['Plot'] ?? "No description available.",
                    style: GoogleFonts.inter(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            backgroundColor: AppStyles.successGreen,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () {
              // Action: Add movie logic if needed here
            },
            child: const Icon(Icons.add, size: 40, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(color: Colors.black, fontSize: 15),
          children: [
            TextSpan(text: "$label ", style: const TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
