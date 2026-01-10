import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';
import 'package:lead_generation/core/constants/app_colors.dart';
import 'package:lead_generation/features/splash_screen/splash_screen.dart';


void main() {
  // Ensure we can access services before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lead Generation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),  
      home: const SplashScreen(),
    );
  }
}

