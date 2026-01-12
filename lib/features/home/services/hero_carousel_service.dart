import 'package:lead_generation/core/api/api_client.dart';
import 'package:lead_generation/core/constants/api_constants.dart';

import '../models/hero_carousel_model.dart';

class HeroCarouselService {
  final ApiClient _apiClient = ApiClient();

  Future<List<HeroCarouselModel>> fetchHeroCarousel() async {
    try {
      final dynamic data = await _apiClient.get(ApiConstants.getHeroCarousel);

      if (data['success'] == true && data['items'] != null) {
        final List<dynamic> items = data['items'];
        return items.map((item) => HeroCarouselModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load hero carousel items: ${data['message']}');
      }
    } catch (e) {
      throw Exception('Error fetching hero carousel: $e');
    }
  }
}
