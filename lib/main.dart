import 'package:athena/authWrapper.dart';
import 'package:athena/views/add_book_page.dart';
import 'package:athena/views/auth/login_page.dart';
import 'package:athena/views/auth/register_page.dart';
import 'package:athena/views/main/dashboard_page.dart';
import 'package:athena/views/main/profile_page.dart';
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
            '/addBooks': (context) => const AddBookPage(),
            '/profile': (context) => const ProfilePage(),
          },
        );
      },
    );
  }

  // ---------- LIGHT THEME ----------
  ThemeData _buildLightTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    return baseTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4285F4), 
        primary: const Color(0xFF4285F4), 
        secondary: const Color(0xFFEA4335), 
        tertiary: const Color(0xFFFBBC05), 
        surface: const Color(0xFFFFFFFF),
        background: const Color(0xFFF9FAFB),
        onSurface: const Color(0xFF202124),
        onBackground: const Color(0xFF202124),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF202124),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF202124),
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF202124),
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF3C4043),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5F6368),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF70757A),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4285F4),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF34A853),
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: const Color(0xFFEA4335)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4285F4), width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey[200],
        thickness: 1,
        space: 1,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );

    return baseTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF34A853),
        primary: const Color(0xFF34A853),
        secondary: const Color(0xFFEA4335),
        tertiary: const Color(0xFFFBBC05),
        surface: const Color(0xFF1E1E2E),
        background: const Color(0xFF121212),
        onSurface: const Color(0xFFE8EAED),
        onBackground: const Color(0xFFE8EAED),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E2E),
        foregroundColor: Color(0xFFE8EAED),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: const Color(0x4D1A1B3A),
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFE8EAED),
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE8EAED),
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFDADCE0),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFBDC1C6),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFA8ACB0),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF121212),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4285F4),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFBBC05),
        foregroundColor: Colors.black,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: const Color(0xFFEA4335)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF34A853), width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2D2F4F),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
