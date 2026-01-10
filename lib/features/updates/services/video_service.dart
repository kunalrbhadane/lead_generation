import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/video_model.dart';

class VideoService {
  final ApiClient _client = ApiClient();

  Future<List<VideoModel>> getAllVideos() async {
    final response = await _client.get(ApiConstants.getAllVideos);
    
    // Based on response format: { "success": true, "count": 3, "data": [...] }
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> data = response['data'];
      return data.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
