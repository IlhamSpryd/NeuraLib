import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  final String coverUrl;

  const BookCover({super.key, required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          coverUrl,
          width: 200,
          height: 280,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
