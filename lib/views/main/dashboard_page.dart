import 'dart:ui'; // Add this import for ImageFilter

import 'package:athena/preference/shared_preferences.dart';
import 'package:athena/views/main/add_edit_book_page.dart';
import 'package:athena/views/main/home_page.dart';
import 'package:athena/views/main/profile_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  bool _isLoading = true;

  final List<Widget> _pages = [
    const HomePage(),
    const AddEditBookPage(),
    const ProfileBody(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final token = await SharedPreferencesHelper.getToken();
    if (token == null && mounted) {
      // Add mounted check
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    if (mounted) {
      // Add mounted check
      setState(() => _isLoading = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        height: 70,
        decoration: BoxDecoration(
          // Efek kaca modern (glassmorphism)
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home Tab
                _buildNavItem(
                  index: 0,
                  inactiveIcon: "assets/images/home1.png",
                  activeIcon: "assets/images/home.png",
                ),

                // Add Tab
                _buildNavItem(
                  index: 1,
                  inactiveIcon: "assets/images/add1.png",
                  activeIcon: "assets/images/add.png",
                ),

                // Profile Tab
                _buildNavItem(
                  index: 2,
                  inactiveIcon: "assets/images/user.png",
                  activeIcon: "assets/images/user1.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String inactiveIcon,
    required String activeIcon,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? Colors.white.withOpacity(0.3)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: _currentIndex == index
              ? Border.all(color: Colors.white.withOpacity(0.5), width: 1.5)
              : null,
        ),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: Image.asset(
              _currentIndex == index ? activeIcon : inactiveIcon,
              width: 22,
              height: 22,
              color: _currentIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
