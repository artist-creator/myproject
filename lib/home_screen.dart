import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final watchNext = [
      {
        "title": "Interstellar",
        "year": "2014",
        "imdb": "8.4",
        "cast": "Rayn Renolds, Dawn Johnson, Johny Depp, Al Pachino",
        "description": "The way he explores time, space, and love as dimensions beyond our understanding is truly mind-blowing."
      },
      {
        "title": "Lost Ladies",
        "year": "2024",
        "imdb": "8.1",
        "cast": "Actor A, Actor B",
        "description": "A story of courage and resilience."
      },
      {
        "title": "Tragic Moments",
        "year": "2021",
        "imdb": "7.9",
        "cast": "Actor C, Actor D",
        "description": "An emotional rollercoaster."
      }
    ];

    final watched = [
      {
        "title": "Namurad",
        "year": "2025",
        "imdb": "8.4",
        "cast": "Actor X, Actor Y",
        "description": "A gripping drama."
      },
      {
        "title": "Meow Meow",
        "year": "2022",
        "imdb": "9.2",
        "cast": "Actor Cat, Actor Dog",
        "description": "A fun adventure."
      }
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.movie, color: Colors.black),
            SizedBox(width: 8),
            Text("Movilt", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),

      body: SingleChildScrollView(
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

            const Text("Watch Next",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            ...watchNext.map((movie) => movieCard(context, movie)),

            const SizedBox(height: 20),

            const Text("Already Watched",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            ...watched.map((movie) => movieCard(context, movie)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget movieCard(BuildContext context, Map<String, dynamic> movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(movie: movie),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [

              Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title: ${movie['title']}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Year: ${movie['year']}"),
                  Text("IMDB: ${movie['imdb']}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}