import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athena/views/auth/login_page.dart';
import 'package:athena/views/main/dashboard_page.dart';
import 'package:athena/views/onboarding screen.dart';

class AuthWrapper extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const AuthWrapper({super.key, required this.themeNotifier});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _onboardingCompleted = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // cek status onboarding
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    // cek login (anggap ada token/auth_key)
    final token = prefs.getString('auth_token');

    // Tambahkan delay kecil untuk memastikan splash screen terlihat dengan baik
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _onboardingCompleted = onboardingCompleted;
      _isLoggedIn = token != null && token.isNotEmpty;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Kembalikan empty container atau widget transparan
      // karena splash screen sudah menangani tampilan loading
      return const Scaffold(body: SizedBox.shrink());
    }

    // 🚀 alur utama
    if (!_onboardingCompleted) {
      return const OnboardingScreen();
    }

    if (_isLoggedIn) {
      return const DashboardPage();
    }

    return const LoginPage();
  }
}
