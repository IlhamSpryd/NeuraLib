// import 'package:athena/api/history_api.dart';
// import 'package:athena/views/dashboard/history_page.dart';
// import 'package:athena/views/dashboard/home_page.dart';
// import 'package:athena/views/dashboard/profile_page.dart';
// import 'package:athena/views/dashboard/search_page.dart';
// import 'package:flutter/material.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     const HomePage(),
//     const SearchPage(),
//     const HistoryPage(),
//     const ProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: "Cari"),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
//         ],
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
