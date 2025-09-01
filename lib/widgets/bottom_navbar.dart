// import 'package:athena/views/dashboard/home_page.dart';
// import 'package:athena/views/dashboard/profile_page.dart';
// import 'package:athena/views/dashboard/search_page.dart';
// import 'package:flutter/material.dart';

// class BottomNavbar extends StatefulWidget {
//   const BottomNavbar({super.key});

//   @override
//   State<BottomNavbar> createState() => _BottomNavbarState();
// }

// class _BottomNavbarState extends State<BottomNavbar> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = const [HomePage(), SearchPage(), ProfilePage()];

//   void _onTabTapped(int index) {
//     if (_currentIndex != index) {
//       setState(() {
//         _currentIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         items: [
//           BottomNavigationBarItem(
//             icon: Image.asset("assets/images/home.png", width: 24, height: 24),
//             activeIcon: Image.asset(
//               "assets/images/home1.png",
//               width: 24,
//               height: 24,
//             ),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset(
//               "assets/images/search.png",
//               width: 24,
//               height: 24,
//             ),
//             activeIcon: Image.asset(
//               "assets/images/search1.png",
//               width: 24,
//               height: 24,
//             ),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset("assets/images/user.png", width: 24, height: 24),
//             activeIcon: Image.asset(
//               "assets/images/user1.png",
//               width: 24,
//               height: 24,
//             ),
//             label: "",
//           ),
//         ],
//       ),
//     );
//   }
// }
