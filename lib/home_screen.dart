import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'detail_screen.dart';
import 'persistence_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> toWatch = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSavedMovies();
  }

  Future<void> loadSavedMovies() async {
    final savedMovies = await PersistenceService.loadMovies();
    setState(() {
      toWatch = savedMovies;
      loading = false;
    });
  }

  void addMovie(Map<String, dynamic> movie) async {
    setState(() {
      toWatch.add(movie);
    });
    await PersistenceService.saveMovies(toWatch);
  }

  void logout() async {
    await PersistenceService.saveMovies([]);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("MoviIt"),
      ),

      // 🔥 DRAWER (Hamburger Menu)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: const Text(
                "Hello, User!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
            ),

            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notification"),
            ),

            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Password & Security"),
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
            ),

            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help"),
            ),

            const Divider(),

            ListTile(
              title: const Text(
                "Terms & Conditions",
                style: TextStyle(color: Colors.blue),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.red),
              ),
              onTap: logout,
            ),

            ListTile(
              title: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : toWatch.isEmpty
              ? const Center(child: Text("No movies added"))
              : ListView.builder(
                  itemCount: toWatch.length,
                  itemBuilder: (context, index) {
                    final movie = toWatch[index];

                    return Card(
                      child: ListTile(
                        title: Text(movie["Title"] ?? ""),
                        subtitle:
                            Text("Year: ${movie["Year"] ?? ""}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailScreen(movie: movie),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  SearchScreen(onAddMovie: addMovie),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}