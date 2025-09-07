import 'package:flutter/material.dart';
class BookDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String coverUrl;
  final String description;

  const BookDetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.coverUrl,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(coverUrl, height: 300)),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('By: $author', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text(
              "Deskripsi Buku",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description.isNotEmpty
                  ? description
                  : "Tidak ada deskripsi tersedia.",
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
