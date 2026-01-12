import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> verifyOtp({required String contactNo, required String otp}) async {
    final response = await _apiClient.post(
      ApiConstants.verifyUserOtp,
      {
        "ContactNo": contactNo,
        "otp": otp,
      },
    );
    return response;
  }

  Future<dynamic> login({required String contactNo}) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      {
        "ContactNo": contactNo,
      },
    );
    return response;
  }

  Future<dynamic> register({
    required Map<String, String> fields,
    required Map<String, dynamic> files,
  }) async {
    final response = await _apiClient.postMultipart(
      ApiConstants.register,
      fields,
      files,
    );
    return response;
  }
}
