import 'package:flutter/material.dart';
import '../models/daily_update_model.dart';
import '../services/daily_update_service.dart';

class DailyUpdateProvider extends ChangeNotifier {
  final DailyUpdateService _service = DailyUpdateService();
  
  List<DailyUpdateModel> _dailyUpdates = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  String? _errorMessage;
  
  // Pagination State
  int _currentPage = 1;
  int _totalPages = 1;

  List<DailyUpdateModel> get dailyUpdates => _dailyUpdates;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _currentPage < _totalPages;

  Future<void> fetchDailyUpdates({bool refresh = true}) async {
    if (refresh) {
      _isLoading = true;
      _currentPage = 1;
      _dailyUpdates = [];
    } else {
      if (_isMoreLoading || !hasMore) return;
      _isMoreLoading = true;
    }
    
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.getDailyUpdates(page: _currentPage, limit: 10);
      final List<DailyUpdateModel> newUpdates = result['updates'];
      final pagination = result['pagination'];
      
      _totalPages = pagination['totalPages'] ?? 1;

      if (refresh) {
        _dailyUpdates = newUpdates;
      } else {
        _dailyUpdates.addAll(newUpdates);
      }
      
      if (!refresh) {
        // Increment page only after successful load of current page
        _currentPage++;
      } else if (newUpdates.isNotEmpty) {
         // If we refreshed and got data, next load should be page 2
         // Wait, logic check: if we fetched page 1, next is 2.
         if (_currentPage < _totalPages) _currentPage++;
      }

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    await fetchDailyUpdates(refresh: false);
  }
}
