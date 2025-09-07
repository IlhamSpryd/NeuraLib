import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"icon": Icons.book_rounded, "label": "Semua", "active": true},
      {"icon": Icons.local_offer_rounded, "label": "Promo", "active": false},
      {"icon": Icons.star_rounded, "label": "Best Seller", "active": false},
      {"icon": Icons.new_releases_rounded, "label": "Baru", "active": false},
      {"icon": Icons.category_rounded, "label": "Kategori", "active": false},
    ];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: categories.map((category) {
          return _CategoryButton(
            icon: category["icon"],
            label: category["label"],
            isActive: category["active"],
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _CategoryButton({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [Color(0xFF673AB7), Color(0xFF7C4DFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isActive ? null : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.grey[300]!,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isActive ? Colors.white : const Color(0xFF673AB7),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF673AB7),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
