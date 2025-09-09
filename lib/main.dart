import 'dart:ui';
import 'package:athena/authWrapper.dart';
import 'package:athena/views/auth/login_page.dart';
import 'package:athena/views/auth/register_page.dart';
import 'package:athena/views/main/dashboard_page.dart';
import 'package:athena/views/onboarding%20screen.dart';
import 'package:athena/views/settings_page.dart';
import 'package:athena/views/splash_screen.dart';
import 'package:athena/views/sub%20page/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NeuraLibApp());
}

class NeuraLibApp extends StatefulWidget {
  const NeuraLibApp({super.key});

  @override
  State<NeuraLibApp> createState() => _NeuraLibAppState();
}

class _NeuraLibAppState extends State<NeuraLibApp>
    with TickerProviderStateMixin {
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  late AnimationController _atmosphereController;
  late Animation<double> _atmosphereAnimation;

  @override
  void initState() {
    super.initState();
    _atmosphereController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _atmosphereAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _atmosphereController, curve: Curves.easeInOut),
    );
    _atmosphereController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _atmosphereController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          title: 'NeuraLib',
          debugShowCheckedModeBanner: false,
          themeMode: currentTheme,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          home: SplashScreen(themeNotifier: themeNotifier),
          routes: {
            '/authWrapper': (context) =>
                AuthWrapper(themeNotifier: themeNotifier),
            '/settings': (context) =>
                SettingsPage(themeNotifier: themeNotifier),
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/dashboard': (context) => const DashboardPage(),
            '/edit_profile': (context) => const EditProfilePage(),
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    return baseTheme.copyWith(
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            primary: const Color(0xFF6C63FF),
            secondary: const Color(0xFF00D2BE),
            tertiary: const Color(0xFFFF6B9D),
            surface: const Color(0xFFFAFAFF),
            background: const Color(0xFFF5F7FF),
            brightness: Brightness.light,
          ).copyWith(
            surfaceContainerHighest: const Color(0xFFE8ECFF),
            outline: const Color(0xFFD0D5FF),
          ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF1A1B3A),
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1A1B3A),
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1B3A),
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D2F4F),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF3D3F5F),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF4D4F6F),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: const Color(0x4D1A1B3A),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );

    return baseTheme.copyWith(
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            primary: const Color(0xFF8B7EFF),
            secondary: const Color(0xFF00F5D4),
            tertiary: const Color(0xFFFF85B3),
            surface: const Color(0xFF0A0B1E),
            background: const Color(0xFF060714),
            brightness: Brightness.dark,
          ).copyWith(
            surfaceContainerHighest: const Color(0xFF1A1B3A),
            outline: const Color(0xFF2D2F4F),
          ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFE6E8FF),
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFE6E8FF),
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE6E8FF),
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFD6D8F5),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFBCC0E5),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFA8ACD5),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF060714),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: const Color(0x4D1A1B3A),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
