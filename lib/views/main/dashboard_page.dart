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
    if (token == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    setState(() => _isLoading = false);
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
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
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home Tab
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Colors.white : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: Image.asset(
                      _currentIndex == 0
                          ? "assets/images/home.png"
                          : "assets/images/home1.png",
                      width: 22,
                      height: 22,
                      color: _currentIndex == 0
                          ? const Color(0xFF2D2D2D)
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),

            // Add Tab
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _currentIndex == 1 ? Colors.white : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 22,
                    child: Image.asset(
                      _currentIndex == 1
                          ? "assets/images/add.png"
                          : "assets/images/add1.png",
                      width: 24,
                      height: 22,
                      color: _currentIndex == 1
                          ? const Color(0xFF2D2D2D)
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),

            // Profile Tab
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? Colors.white : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: Image.asset(
                      _currentIndex == 2
                          ? "assets/images/user1.png"
                          : "assets/images/user.png",
                      width: 22,
                      height: 22,
                      color: _currentIndex == 2
                          ? const Color(0xFF2D2D2D)
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
