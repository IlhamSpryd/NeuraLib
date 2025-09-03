import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: const [
          _CategoryButton("Aktivitas", true),
          _CategoryButton("Buku", false),
          _CategoryButton("Video", false),
          _CategoryButton("Audio", false),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isActive;
  const _CategoryButton(this.label, this.isActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurpleAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurpleAccent),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
