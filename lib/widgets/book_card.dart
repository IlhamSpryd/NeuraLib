import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String coverUrl;

  const BookDetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(coverUrl, height: 300),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('By: $author', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
