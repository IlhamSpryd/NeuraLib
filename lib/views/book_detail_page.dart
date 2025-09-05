import 'package:flutter/material.dart';

import 'main/add_edit_book_page.dart';

class BookDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String? coverUrl; // ✅ tambah parameter coverUrl

  const BookDetailPage({
    super.key,
    required this.title,
    required this.author,
    this.coverUrl, // nullable
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Buku"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditBookPage(), // tetap pake Add/Edit page
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover buku
            if (coverUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    coverUrl!,
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 150,
                      height: 200,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.book_rounded,
                        color: Colors.grey[400],
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Penulis: $author", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // Integrasi API delete di sini
                Navigator.pop(context);
              },
              child: const Text("Hapus Buku"),
            ),
          ],
        ),
      ),
    );
  }
}
