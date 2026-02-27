import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_styles.dart';
import 'search_screen.dart';
import 'detail_screen.dart';
import 'local_storage_service.dart';
import 'personal_info_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> toWatch = [];
  List<Map<String, dynamic>> alreadyWatched = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await LocalStorageService.loadMovieLists();
    setState(() {
      toWatch = List<Map<String, dynamic>>.from(data['toWatch'] ?? []);
      alreadyWatched = List<Map<String, dynamic>>.from(data['alreadyWatched'] ?? []);
      loading = false;
    });
  }

  Future<void> _saveData() async {
    await LocalStorageService.saveMovieLists(toWatch, alreadyWatched);
  }

  void _addMovie(Map<String, dynamic> movie) {
    setState(() {
      toWatch.add(movie);
    });
    _saveData();
  }

  void _moveToWatched(int index) {
    setState(() {
      final movie = toWatch.removeAt(index);
      alreadyWatched.add(movie);
    });
    _saveData();
  }

  void _moveToWatchNext(int index) {
    setState(() {
      final movie = alreadyWatched.removeAt(index);
      toWatch.add(movie);
    });
    _saveData();
  }

  void _handleLogout() async {
    await LocalStorageService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // The menu icon will automatically appear when a Drawer is added
        titleSpacing: 0,
        title: Row(
          children: [
            const MoviItLogo(size: 25),
            const SizedBox(width: 8),
            Text(
              "Movies, Maza, Masti",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppStyles.textGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppStyles.primaryBlue),
              child: const Center(child: MoviItLogo(size: 60)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile Settings"),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalInfoScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: _handleLogout,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Watch Next", style: AppStyles.bodyBold),
                    const SizedBox(height: 10),
                    _buildMovieList(toWatch, true),
                    const SizedBox(height: 30),
                    Text("Already Watched", style: AppStyles.bodyBold),
                    const SizedBox(height: 10),
                    _buildMovieList(alreadyWatched, false),
                    const SizedBox(height: 80),
                  ],
                ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(onAddMovie: _addMovie),
                ),
              );
            },
            child: const Icon(Icons.add, size: 40, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieList(List<Map<String, dynamic>> movies, bool isWatchNext) {
    if (movies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          "No movies here",
          style: GoogleFonts.inter(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Dismissible(
          key: Key(movie['id']?.toString() ?? index.toString()),
          direction: isWatchNext ? DismissDirection.startToEnd : DismissDirection.endToStart,
          background: Container(
            alignment: isWatchNext ? Alignment.centerLeft : Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: AppStyles.successGreen.withOpacity(0.3),
            child: Icon(
              isWatchNext ? Icons.check : Icons.replay,
              color: Colors.black,
            ),
          ),
          onDismissed: (direction) {
            if (isWatchNext) {
              _moveToWatched(index);
            } else {
              _moveToWatchNext(index);
            }
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(movie: movie),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppStyles.cardGrey,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      border: Border.all(color: Colors.black),
                    ),
                    child: movie['poster_path'] != null
                        ? Image.network(
                            "https://image.tmdb.org/t/p/w200${movie['poster_path']}",
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.movie, color: Colors.black54),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Title: ${movie['title'] ?? movie['Title'] ?? 'Unknown'}",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        Text(
                          "Year: ${movie['release_date']?.toString().split('-')[0] ?? movie['Year'] ?? 'N/A'}",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        Text(
                          "IMDB: ${movie['vote_average'] ?? movie['imdbRating'] ?? 'N/A'}",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
