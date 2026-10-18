import 'package:flutter/material.dart';
import '../models/mandi_price.dart';
import '../core/services/mandi_service.dart';

class MandiProvider extends ChangeNotifier {
  final MandiService _service = MandiService();

  List<MandiPrice> _allPrices = [];
  List<MandiPrice> _filteredPrices = [];
  bool _isLoading = false;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String? _district;
  String? _state;

  List<MandiPrice> get prices => _filteredPrices;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  MandiProvider() {
    loadPrices();
  }

  Future<void> loadPrices({String? district, String? state}) async {
    _isLoading = true;
    if (district != null) _district = district;
    if (state != null) _state = state;
    notifyListeners();

    try {
      _allPrices = await _service.fetchMandiPrices(
        district: _district,
        state: _state,
      );
      _applyFilters();
    } catch (e) {
      debugPrint('MandiProvider load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = List<MandiPrice>.from(_allPrices);

    if (_selectedCategory != 'all') {
      result = result.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      result = result.where((p) {
        return p.commodity.toLowerCase().contains(q) ||
            p.marketName.toLowerCase().contains(q) ||
            p.district.toLowerCase().contains(q) ||
            p.variety.toLowerCase().contains(q);
      }).toList();
    }

    _filteredPrices = result;
  }
}
