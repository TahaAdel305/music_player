import 'dart:async';

import 'package:flutter/material.dart';

import 'home_screen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = "splash";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                size: 65,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Music Player',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Your music, always with you.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
