import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://bhagvan-comitee.onrender.com';
  
  static const String getAllVideos = '/videoInfo/getall';
  static const String getAllCategories = '/Category/getall';
}
