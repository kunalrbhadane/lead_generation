import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_generation/feuture/auth/landing_screen/screens/landing_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // STAGE 1: Formation Animations
  late Animation<double> _bOpacityAnimation;
  late Animation<double> _bScaleAnimation;
  late Animation<double> _leafOpacityAnimation;
  late Animation<Offset> _leafSlideAnimation;
  
  // STAGE 2: Combined Zoom Animation
  late Animation<double> _zoomAnimation;

  // STAGE 3: Combined Shake Animation
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // --- STAGE 1: COMBINE ---
    _bOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)));
    _bScaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.decelerate)));
    _leafOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5)));
    _leafSlideAnimation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic)));

    // --- STAGE 2: ZOOM ---
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.15)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.75, curve: Curves.easeOut)));
    
    // =======================================================
    // ===          THIS IS THE UPDATED SECTION            ===
    // =======================================================
    // --- STAGE 3: SHAKE (Increased Amplitude) ---
    // We've increased the rotation values from 0.02 to 0.04 to make the shake more pronounced.
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.05), weight: 1),    // Increased to 0.04
      TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 2),  // Increased to 0.04
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 1),    // Increased to 0.04
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.50, 1.0, curve: Curves.easeInOut)));
    // =======================================================
    // =======================================================

    _controller.forward();

    Timer(
      const Duration(milliseconds: 3500),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double logoHeight = 110.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Center(
        child: RotationTransition(
          turns: _shakeAnimation,
          child: ScaleTransition(
            scale: _zoomAnimation,
            child: SizedBox(
              width: logoHeight * 1.5,
              height: logoHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Layer 1: The 'B' part
                  Transform.translate(
                    offset: const Offset(15, 0),
                    child: FadeTransition(
                      opacity: _bOpacityAnimation,
                      child: ScaleTransition(
                        scale: _bScaleAnimation,
                        child: Image.asset('assets/images/b_part.png', height: logoHeight),
                      ),
                    ),
                  ),
                  
                  // Layer 2: The 'Leaf' part
                  Transform.translate(
                    offset: const Offset(-25, 0),
                    child: SlideTransition(
                      position: _leafSlideAnimation,
                      child: FadeTransition(
                        opacity: _leafOpacityAnimation,
                        child: Image.asset('assets/images/leaf.png', height: logoHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}