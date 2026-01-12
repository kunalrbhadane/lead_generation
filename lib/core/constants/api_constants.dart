import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL']!;
  
  static const String getAllVideos = '/videoInfo/getall';
  static const String getAllCategories = '/Category/getall';
  static const String verifyUserOtp = '/user/auth/verifyUserOtp';
  static const String login = '/user/auth/login';
  static const String register = '/user/auth/register';
}
