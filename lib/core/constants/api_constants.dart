import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://bagwan-commmunity.vercel.app';
  
  static const String getAllVideos = '/videoInfo/getall';
  static const String getAllCategories = '/Category/getall';
  // Replace with dynamic ID handling in service, but base path is needed or full URL construction
  static const String getUserById = '/user/auth/getUserById/'; 
  static const String getDailyUpdates = '/DailyUpdate/getall';
  static const String getCarousel = '/Carousel';
  static const String getHeroCarousel = '/HeroCarousel';
}
