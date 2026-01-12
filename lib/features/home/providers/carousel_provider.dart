import 'package:flutter/material.dart';
import '../models/carousel_model.dart';
import '../services/carousel_service.dart';

class CarouselProvider with ChangeNotifier {
  final CarouselService _carouselService = CarouselService();
  
  List<CarouselModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CarouselModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCarouselItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _carouselService.fetchCarouselItems();
      // Sort by order
      _items.sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      _errorMessage = e.toString();
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
