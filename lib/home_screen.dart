import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Watch Next",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            movieCard("Interstellar", "2014", "8.4"),
            movieCard("Lost Ladies", "2024", "8.1"),
            movieCard("Tragic Moments", "2021", "7.9"),

            const SizedBox(height: 20),

            const Text("Already Watched",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            movieCard("Namurad", "2025", "8.4"),
            movieCard("Meow Meow", "2022", "9.2"),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget movieCard(String title, String year, String imdb) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                Text("Title: $title",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),
                Text("Year: $year"),
                Text("IMDB: $imdb"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}