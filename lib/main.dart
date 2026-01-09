import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Lead Generation App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
