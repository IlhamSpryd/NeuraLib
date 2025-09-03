import 'package:flutter/material.dart';

class BookActionButtons extends StatelessWidget {
  const BookActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // aksi baca
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.menu_book, color: Colors.white),
            label: const Text(
              "Baca Sekarang",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            // aksi favorit
          },
          icon: const Icon(Icons.favorite_border, color: Colors.white),
        ),
      ],
    );
  }
}
