// import 'package:athena/api/authentication_api.dart';
// import 'package:athena/views/main/dashboard_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   // Animation controllers
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late AnimationController _scaleController;
//   late AnimationController _lottieController;
//   late AnimationController _welcomeBounceController;

//   // Animations
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _welcomeBounceAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//   }

//   void _initializeAnimations() {
//     // Initialize animation controllers
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 2200),
//       vsync: this,
//     );

//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _lottieController = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );

//     _welcomeBounceController = AnimationController(
//       duration: const Duration(milliseconds: 3000),
//       vsync: this,
//     );

//     // Initialize animations
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
//           CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
//         );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
//     );

//     // Animasi bounce untuk Welcome Back
//     _welcomeBounceAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _welcomeBounceController,
//         curve: Curves.elasticOut,
//       ),
//     );

//     // Start animations dengan delay bertahap
//     _fadeController.forward();
//     _slideController.forward();
//     _scaleController.forward();
//     _lottieController.forward();

//     // Start welcome bounce animation dengan delay
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _welcomeBounceController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _scaleController.dispose();
//     _lottieController.dispose();
//     _welcomeBounceController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final result = await AuthApi.login(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (!mounted) return;

//       if (result != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "Welcome ${result.data.user.name}",
//               style: GoogleFonts.inter(color: Colors.white),
//             ),
//             backgroundColor: const Color.fromRGBO(32, 99, 155, 1),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//           ),
//         );

//         await _scaleController.reverse();
//         await _scaleController.forward();

//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) =>
//                 const DashboardPage(),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//                   return FadeTransition(opacity: animation, child: child);
//                 },
//             transitionDuration: const Duration(milliseconds: 600),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "Login gagal. Periksa email & password.",
//               style: GoogleFonts.inter(color: Colors.white),
//             ),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "Terjadi kesalahan: ${e.toString()}",
//             style: GoogleFonts.inter(color: Colors.white),
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//       _passwordController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final primaryColor = theme.colorScheme.primary;
//     final accentColor = theme.colorScheme.secondary;

//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: ScaleTransition(
//                     scale: _scaleAnimation,
//                     child: Container(
//                       width: 220,
//                       height: 220,
//                       decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Lottie.asset(
//                         'assets/lottie/splashscreen.json',
//                         controller: _lottieController,
//                         onLoaded: (composition) {
//                           _lottieController
//                             ..duration = composition.duration
//                             ..forward();
//                         },
//                         width: 120,
//                         height: 120,
//                         fit: BoxFit.contain,
//                         repeat: true,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5),

//               // Animasi Welcome Back
//               AnimatedBuilder(
//                 animation: _welcomeBounceController,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, _welcomeBounceAnimation.value * 100),
//                     child: Opacity(
//                       opacity: _welcomeBounceController.value,
//                       child: Text(
//                         "Welcome Back",
//                         style: GoogleFonts.spaceGrotesk(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: primaryColor,
//                           shadows: [
//                             Shadow(
//                               color: primaryColor.withOpacity(0.3),
//                               blurRadius: 10,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 8),
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Text(
//                     "Silahkan login untuk melanjutkan",
//                     style: GoogleFonts.inter(
//                       fontSize: 16,
//                       color: theme.colorScheme.onSurface.withOpacity(0.7),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 40),
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: ScaleTransition(
//                     scale: _scaleAnimation,
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: _emailController,
//                             decoration: InputDecoration(
//                               hintText: "Email",
//                               hintStyle: GoogleFonts.inter(),
//                               prefixIcon: Icon(
//                                 Icons.email_outlined,
//                                 color: primaryColor,
//                               ),
//                               filled: true,
//                               fillColor: theme.colorScheme.surface,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 18,
//                                 horizontal: 20,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (v) {
//                               if (v == null || v.isEmpty) {
//                                 return "Email wajib diisi";
//                               }
//                               if (!RegExp(
//                                 r"^[^\s@]+@[^\s@]+\.[^\s@]+$",
//                               ).hasMatch(v)) {
//                                 return "Format email tidak valid";
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),

//                           TextFormField(
//                             controller: _passwordController,
//                             obscureText: _obscurePassword,
//                             decoration: InputDecoration(
//                               hintText: "Password",
//                               hintStyle: GoogleFonts.inter(),
//                               prefixIcon: Icon(
//                                 Icons.lock_outline,
//                                 color: primaryColor,
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                   color: primaryColor,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                               ),
//                               filled: true,
//                               fillColor: theme.colorScheme.surface,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 18,
//                                 horizontal: 20,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                             validator: (v) => v == null || v.isEmpty
//                                 ? "Password wajib diisi"
//                                 : null,
//                           ),
//                           const SizedBox(height: 24),

//                           // Login Button
//                           _isLoading
//                               ? const CircularProgressIndicator()
//                               : SizedBox(
//                                   width: double.infinity,
//                                   height: 55,
//                                   child: ElevatedButton(
//                                     onPressed: _login,
//                                     style: ElevatedButton.styleFrom(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                       ),
//                                       padding: EdgeInsets.zero,
//                                       elevation: 5,
//                                       backgroundColor: Colors.transparent,
//                                     ),
//                                     child: Ink(
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [primaryColor, accentColor],
//                                         ),
//                                         borderRadius: BorderRadius.circular(30),
//                                       ),
//                                       child: Container(
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           "Login",
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                           const SizedBox(height: 16),

//                           FadeTransition(
//                             opacity: _fadeAnimation,
//                             child: TextButton(
//                               onPressed: () =>
//                                   Navigator.pushNamed(context, "/register"),
//                               style: TextButton.styleFrom(
//                                 foregroundColor: accentColor,
//                               ),
//                               child: Text(
//                                 "Belum punya akun? Daftar Sekarang",
//                                 style: GoogleFonts.inter(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
