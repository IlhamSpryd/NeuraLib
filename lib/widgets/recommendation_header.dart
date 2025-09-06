import 'package:flutter/material.dart';

class RecommendationHeader extends StatelessWidget {
  const RecommendationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Rekomendasi untuk Anda",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
            child: const Text(
              "Lihat Semua",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
