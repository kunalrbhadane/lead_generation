import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_generation/features/auth/landing_screen/screens/landing_screen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Timer(
      const Duration(milliseconds: 3000), // Adjusted to 3 seconds for GIF duration + buffer
      () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LandingScreen(),
              transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Standard white background for GIF
      body: Center(
        child: Image.asset(
          'assets/gif/Lead Application.gif',
          fit: BoxFit.scaleDown, // Prevents blurry upscaling if the GIF is smaller than the screen
          filterQuality: FilterQuality.high, // Ensures better resampling transparency
          width: double.infinity, // Allows it to take width if needed, but scaleDown constraints it
        ),
      ),
    );
  }
}