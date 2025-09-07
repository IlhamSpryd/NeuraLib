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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[50],
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 25,
              height: 24,
              child: Image.asset("assets/images/home1.png"),
            ),
            activeIcon: SizedBox(
              width: 25,
              height: 24,
              child: Image.asset("assets/images/home.png"),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 24,
              child: Image.asset("assets/images/add1.png"),
            ),
            activeIcon: SizedBox(
              width: 30,
              height: 24,
              child: Image.asset("assets/images/add.png"),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 25,
              height: 24,
              child: Image.asset("assets/images/user.png"),
            ),
            activeIcon: SizedBox(
              width: 25,
              height: 24,
              child: Image.asset("assets/images/user1.png"),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
