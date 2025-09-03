import 'package:athena/views/splash_screen.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: "Montserrat",
      ),
      home: const SplashScreen(),
    );
  }
}
