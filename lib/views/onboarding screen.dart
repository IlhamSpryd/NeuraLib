// import 'package:athena/views/auth/login_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OnboardingItem {
//   final String image;
//   final String title;
//   final String description;

//   OnboardingItem({
//     required this.image,
//     required this.title,
//     required this.description,
//   });
// }

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   late final PageController _pageController;
//   int _currentPage = 0;

//   final List<OnboardingItem> _onboardingData = [
//     OnboardingItem(
//       image: 'assets/lottie/onboard1.json',
//       title: 'Selamat Datang di NeuraLib',
//       description:
//           'Temukan berbagai koleksi buku terbaru dan terlengkap untuk kebutuhan membaca Anda.',
//     ),
//     OnboardingItem(
//       image: 'assets/lottie/onboard2.json',
//       title: 'Pinjam Buku dengan Mudah',
//       description:
//           'Proses peminjaman buku yang cepat dan praktis hanya dengan beberapa ketukan.',
//     ),
//     OnboardingItem(
//       image: 'assets/lottie/onboard3.json',
//       title: 'Kelola Koleksi Anda',
//       description:
//           'Simpan riwayat peminjaman dan kelola buku favorit Anda dengan mudah.',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final primaryColor = theme.colorScheme.primary;
//     final accentColor = theme.colorScheme.tertiary;

//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: _onboardingData.length,
//                 onPageChanged: (int page) {
//                   setState(() {
//                     _currentPage = page;
//                   });
//                 },
//                 itemBuilder: (_, index) {
//                   return SingleOnboardingPage(item: _onboardingData[index]);
//                 },
//               ),
//             ),
//             _buildIndicator(primaryColor),
//             _buildButtons(context, primaryColor, accentColor),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildIndicator(Color primaryColor) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: _onboardingData.asMap().entries.map((entry) {
//         return Container(
//           width: 8.0,
//           height: 8.0,
//           margin: const EdgeInsets.symmetric(horizontal: 4.0),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: _currentPage == entry.key
//                 ? primaryColor
//                 : Colors.grey.withOpacity(0.4),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildButtons(
//     BuildContext context,
//     Color primaryColor,
//     Color accentColor,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Row(
//         children: [
//           if (_currentPage < _onboardingData.length - 1)
//             TextButton(
//               onPressed: _completeOnboarding,
//               child: Text(
//                 'Lewati',
//                 style: GoogleFonts.inter(color: primaryColor),
//               ),
//             ),
//           const Spacer(),
//           ElevatedButton(
//             onPressed: () {
//               if (_currentPage == _onboardingData.length - 1) {
//                 _completeOnboarding();
//               } else {
//                 _pageController.nextPage(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeIn,
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               child: Text(
//                 _currentPage == _onboardingData.length - 1 ? 'Mulai' : 'Lanjut',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboarding_completed', true);

//     if (mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     }
//   }
// }

// class SingleOnboardingPage extends StatelessWidget {
//   final OnboardingItem item;

//   const SingleOnboardingPage({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final primaryColor = theme.colorScheme.primary;

//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 250,
//             height: 250,
//             decoration: BoxDecoration(
//               color: primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Lottie.asset(item.image, fit: BoxFit.contain),
//             ),
//           ),
//           const SizedBox(height: 40),
//           Text(
//             item.title,
//             style: GoogleFonts.spaceGrotesk(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: primaryColor,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               item.description,
//               style: GoogleFonts.inter(
//                 fontSize: 16,
//                 color: theme.colorScheme.onSurface.withOpacity(0.7),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
