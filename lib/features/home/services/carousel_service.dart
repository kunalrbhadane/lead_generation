import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/api/api_client.dart';
import '../models/carousel_model.dart';

class CarouselService {
  final ApiClient _apiClient = ApiClient();

  Future<List<CarouselModel>> fetchCarouselItems() async {
    try {
      // ApiClient handles baseUrl and JSON decoding
      final dynamic data = await _apiClient.get(ApiConstants.getCarousel);

      if (data['success'] == true && data['items'] != null) {
        final List<dynamic> items = data['items'];
        return items.map((item) => CarouselModel.fromJson(item)).toList();
      } else {
         throw Exception('Failed to load carousel items: ${data['message']}');
      }
    } catch (e) {
      throw Exception('Error fetching carousel items: $e');
    }
  }
}
