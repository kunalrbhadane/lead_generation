import 'package:flutter/material.dart';
import '../models/hero_carousel_model.dart';
import '../services/hero_carousel_service.dart';

class HeroCarouselProvider extends ChangeNotifier {
  final HeroCarouselService _service = HeroCarouselService();
  
  List<HeroCarouselModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HeroCarouselModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHeroCarousel() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _service.fetchHeroCarousel();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
