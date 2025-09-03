import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final List<String> images = [
    "https://picsum.photos/800/300?1",
    "https://picsum.photos/800/300?2",
    "https://picsum.photos/800/300?3",
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 220,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          items: images
              .map(
                (item) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              )
              .toList(),
        ),
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: _currentIndex == entry.key ? 18 : 6,
                decoration: BoxDecoration(
                  color: _currentIndex == entry.key
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
