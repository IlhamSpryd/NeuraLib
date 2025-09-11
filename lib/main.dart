// import 'package:athena/authWrapper.dart';
// import 'package:athena/views/auth/login_page.dart';
// import 'package:athena/views/auth/register_page.dart';
// import 'package:athena/views/main/dashboard_page.dart';
// import 'package:athena/views/onboarding%20screen.dart';
// import 'package:athena/views/settings_page.dart';
// import 'package:athena/views/splash_screen.dart';
// import 'package:athena/views/sub%20page/edit_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const NeuraLibApp());
// }

// class NeuraLibApp extends StatefulWidget {
//   const NeuraLibApp({super.key});

//   @override
//   State<NeuraLibApp> createState() => _NeuraLibAppState();
// }

// class _NeuraLibAppState extends State<NeuraLibApp>
//     with TickerProviderStateMixin {
//   final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
//     ThemeMode.system,
//   );

//   late AnimationController _atmosphereController;
//   late Animation<double> _atmosphereAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _atmosphereController = AnimationController(
//       duration: const Duration(seconds: 8),
//       vsync: this,
//     );
//     _atmosphereAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _atmosphereController, curve: Curves.easeInOut),
//     );
//     _atmosphereController.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     // _atmosphereController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, currentTheme, _) {
//         return MaterialApp(
//           title: 'NeuraLib',
//           debugShowCheckedModeBanner: false,
//           themeMode: currentTheme,
//           theme: _buildLightTheme(),
//           darkTheme: _buildDarkTheme(),
//           home: SplashScreen(themeNotifier: themeNotifier),
//           routes: {
//             '/authWrapper': (context) =>
//                 AuthWrapper(themeNotifier: themeNotifier),
//             '/settings': (context) =>
//                 SettingsPage(themeNotifier: themeNotifier),
//             '/onboarding': (context) => const OnboardingScreen(),
//             '/login': (context) => const LoginPage(),
//             '/register': (context) => const RegisterPage(),
//             '/dashboard': (context) => const DashboardPage(),
//             '/edit_profile': (context) => const EditProfilePage(),
//           },
//         );
//       },
//     );
//   }

//   ThemeData _buildLightTheme() {
//     final baseTheme = ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//     );

//     return baseTheme.copyWith(
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: const Color(0xFF6C63FF),
//         primary: const Color(0xFF6C63FF),
//         secondary: const Color(0xFF00D2BE),
//         tertiary: const Color(0xFFFF6B9D),
//         surface: const Color(0xFFFFFFFF),
//         surfaceVariant: const Color(0xFFF5F7FF),
//         background: const Color(0xFFFAFAFA),
//         onSurface: const Color(0xFF1A1B3A),
//         onBackground: const Color(0xFF1A1B3A),
//         brightness: Brightness.light,
//       ),
//       scaffoldBackgroundColor: const Color(0xFFFAFAFA),
//       appBarTheme: AppBarTheme(
//         backgroundColor: const Color(0xFF6C63FF),
//         foregroundColor: Colors.white,
//         elevation: 1,
//         surfaceTintColor: Colors.transparent,
//       ),
//       cardTheme: CardThemeData(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         color: const Color(0x4D1A1B3A),
//         surfaceTintColor: Colors.transparent,
//       ),
//       textTheme: TextTheme(
//         displayLarge: GoogleFonts.orbitron(
//           fontSize: 32,
//           fontWeight: FontWeight.w900,
//           color: const Color(0xFF1A1B3A),
//           letterSpacing: -0.5,
//         ),
//         displayMedium: GoogleFonts.orbitron(
//           fontSize: 28,
//           fontWeight: FontWeight.w800,
//           color: const Color(0xFF1A1B3A),
//         ),
//         headlineLarge: GoogleFonts.poppins(
//           fontSize: 24,
//           fontWeight: FontWeight.w700,
//           color: const Color(0xFF1A1B3A),
//         ),
//         titleLarge: GoogleFonts.poppins(
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF2D2F4F),
//         ),
//         bodyLarge: GoogleFonts.inter(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: const Color(0xFF3D3F5F),
//         ),
//         bodyMedium: GoogleFonts.inter(
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//           color: const Color(0xFF4D4F6F),
//         ),
//         labelLarge: GoogleFonts.inter(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF6C63FF),
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(foregroundColor: const Color(0xFF6C63FF)),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.grey[50],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
//         ),
//       ),
//       dividerTheme: DividerThemeData(
//         color: Colors.grey[200],
//         thickness: 1,
//         space: 1,
//       ),
//     );
//   }

//   ThemeData _buildDarkTheme() {
//     final baseTheme = ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//     );

//     return baseTheme.copyWith(
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: const Color(0xFF6C63FF),
//         primary: const Color(0xFF6C63FF),
//         secondary: const Color(0xFF00D2BE),
//         tertiary: const Color(0xFFFF6B9D),
//         surface: const Color(0xFF1A1C2E),
//         surfaceVariant: const Color(0xFF25273C),
//         background: const Color(0xFF121420),
//         onSurface: const Color(0xFFE6E8FF),
//         onBackground: const Color(0xFFE6E8FF),
//         brightness: Brightness.dark,
//       ),
//       scaffoldBackgroundColor: const Color(0xFF121420),
//       appBarTheme: AppBarTheme(
//         backgroundColor: const Color(0xFF1A1C2E),
//         foregroundColor: const Color(0xFFE6E8FF),
//         elevation: 1,
//         surfaceTintColor: Colors.transparent,
//       ),
//       cardTheme: CardThemeData(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         color: const Color(0x4D1A1B3A),
//         surfaceTintColor: Colors.transparent,
//       ),
//       textTheme: TextTheme(
//         displayLarge: GoogleFonts.orbitron(
//           fontSize: 32,
//           fontWeight: FontWeight.w900,
//           color: const Color(0xFFE6E8FF),
//           letterSpacing: -0.5,
//         ),
//         displayMedium: GoogleFonts.orbitron(
//           fontSize: 28,
//           fontWeight: FontWeight.w800,
//           color: const Color(0xFFE6E8FF),
//         ),
//         headlineLarge: GoogleFonts.poppins(
//           fontSize: 24,
//           fontWeight: FontWeight.w700,
//           color: const Color(0xFFE6E8FF),
//         ),
//         titleLarge: GoogleFonts.poppins(
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFFD6D8F5),
//         ),
//         bodyLarge: GoogleFonts.inter(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: const Color(0xFFBCC0E5),
//         ),
//         bodyMedium: GoogleFonts.inter(
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//           color: const Color(0xFFA8ACD5),
//         ),
//         labelLarge: GoogleFonts.inter(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF121420),
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF6C63FF),
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(foregroundColor: const Color(0xFF6C63FF)),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: const Color(0xFF25273C),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
//         ),
//       ),
//       dividerTheme: const DividerThemeData(
//         color: Color(0xFF2D2F4F),
//         thickness: 1,
//         space: 1,
//       ),
//     );
//   }
// }
