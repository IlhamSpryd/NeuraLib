import 'package:athena/views/auth/login_page.dart';
import 'package:athena/views/auth/register_page.dart';
import 'package:athena/views/main/dashboard_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AthenaApp());
}

class AthenaApp extends StatelessWidget {
  const AthenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Athena Library',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Montserrat"),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
      },

      home: const DashboardPage(),
    );
  }
}
