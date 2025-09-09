import 'package:flutter/material.dart';

class BookActionButtons extends StatelessWidget {
  final VoidCallback onReadPressed;
  final VoidCallback onFavoritePressed;
  final bool isFavorite;

  const BookActionButtons({
    super.key,
    required this.onReadPressed,
    required this.onFavoritePressed,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onReadPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.menu_book, color: Colors.white),
            label: const Text(
              "Pinjam Buku",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onFavoritePressed,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }
}
