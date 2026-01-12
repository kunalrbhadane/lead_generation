import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/daily_update_model.dart';

class DailyUpdateService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getDailyUpdates({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.get('${ApiConstants.getDailyUpdates}?page=$page&limit=$limit');
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        final List<DailyUpdateModel> updates = data.map((json) => DailyUpdateModel.fromJson(json)).toList();
        
        return {
          'updates': updates,
          'pagination': response['pagination'],
        };
      } else {
        throw Exception('Failed to load daily updates');
      }
    } catch (e) {
      rethrow;
    }
  }
}
