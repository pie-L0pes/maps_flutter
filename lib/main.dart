import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const FlutterMapsApp());
}

class FlutterMapsApp extends StatelessWidget {
  const FlutterMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 195, 0, 255),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}