import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Colors from provided image
  static const Color darkGreen = Color(0xFF13773A);
  static const Color lightGreen = Color(0xFF6BAE3D);
  static const Color lightGreenBg = Color(0xFFE8F5E9); 
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textGrey = Color(0xFF757575);
  static const Color gold = Color(0xFFFBC02D);
  
  // Custom Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [darkGreen, lightGreen], 
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: white, // Main background
      fontFamily: 'Roboto', // Default, but can be changed
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Transparent status bar
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textDark,
        ),
        labelSmall: TextStyle(
          color: textGrey,
          fontSize: 12,
        ),
      ),
    );
  }
}
