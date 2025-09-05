import 'package:athena/views/main/add_edit_book_page.dart';
import 'package:athena/views/main/profile_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage(key: Key('home_page'));
      case 1:
        return AddEditBookPage(
          // ✅ HAPUS const, biarkan tanpa parameter
          key: const Key('add_book_page'),
        );
      case 2:
        return const ProfileBody(key: Key('profile_page'));
      default:
        return const HomePage(key: Key('home_page_default'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          print('Navigating to index: $index');
          setState(() => _currentIndex = index);
        },
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
