import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final List<Map<String, dynamic>> banners = [
    {
      "image": "https://picsum.photos/800/400?1",
      "title": "Buku Terbaru",
      "subtitle": "Diskon hingga 50%",
    },
    {
      "image": "https://picsum.photos/800/400?2",
      "title": "Best Seller",
      "subtitle": "Buku paling populer",
    },
    {
      "image": "https://picsum.photos/800/400?3",
      "title": "Promo Spesial",
      "subtitle": "Hanya untuk member",
    },
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          items: banners.map((banner) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Background Image
                    Image.network(
                      banner["image"],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Content
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner["title"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            banner["subtitle"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentIndex == entry.key ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentIndex == entry.key
                    ? Colors.deepPurple
                    : Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
