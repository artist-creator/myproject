import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> toWatch = [];

  void addMovie(Map<String, dynamic> movie) {
    setState(() {
      toWatch.add(movie);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.movie, color: Colors.black),
            SizedBox(width: 8),
            Text("Movilt",
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Center(
              child: Text(
                "Movies, Maza, Masti",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "To Watch",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: toWatch.length,
                itemBuilder: (context, index) {

                  final movie = toWatch[index];

                  return Card(
                    child: ListTile(
                      title: Text(movie["title"] ?? movie["Title"]),
                      subtitle: Text(
                        movie["release_date"] != null
                            ? movie["release_date"]
                            : "No Date",
                      ),
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
            )
          ],
        ),
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