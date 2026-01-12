import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_generation/features/home/providers/daily_update_provider.dart';
import 'package:lead_generation/features/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'features/updates/providers/video_provider.dart';

import 'features/home/providers/category_provider.dart';

import 'features/profile/providers/user_provider.dart';
import 'features/home/providers/carousel_provider.dart';
import 'features/home/providers/hero_carousel_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");

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
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DailyUpdateProvider()),
        ChangeNotifierProvider(create: (_) => CarouselProvider()),
        ChangeNotifierProvider(create: (_) => HeroCarouselProvider()),
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Lead Generation App',
        theme: AppTheme.lightTheme,
        
        home: const SplashScreen(),
      ),
    );
  }
}

