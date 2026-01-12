import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'dart:developer';

class UserService {
  final ApiClient _client = ApiClient();

  Future<UserModel?> getUserById(String id) async {
    final response = await _client.get('${ApiConstants.getUserById}$id');
    
    // Response: { "success": true, "data": [ { ... } ] }
    if (response['success'] == true && response['data'] != null && (response['data'] as List).isNotEmpty) {
      final data = response['data'][0];
      return UserModel.fromJson(data);
    } else {
      return null;
    }
  }
}
