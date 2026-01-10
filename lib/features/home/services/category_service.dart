import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/category_model.dart';

class CategoryService {
  final ApiClient _client = ApiClient();

  Future<List<CategoryModel>> getAllCategories() async {
    final response = await _client.get(ApiConstants.getAllCategories);
    
    // Based on response format: { "success": true, "count": 4, "data": [...] }
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> data = response['data'];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
