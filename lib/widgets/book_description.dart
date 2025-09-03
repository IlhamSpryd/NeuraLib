import 'package:flutter/material.dart';

class BookDescription extends StatelessWidget {
  final String title;
  final String author;

  const BookDescription({super.key, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Oleh $author",
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        const SizedBox(height: 20),
        const Text(
          "Deskripsi Buku",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Buku ini membahas topik mendalam mengenai subjek yang relevan. "
          "Kontennya disusun agar mudah dipahami baik oleh pemula maupun pembaca berpengalaman. "
          "Dengan penjelasan yang detail, contoh nyata, dan pendekatan interaktif, "
          "pembaca akan mendapatkan wawasan yang lebih luas.",
          style: TextStyle(color: Colors.grey[300], fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}
