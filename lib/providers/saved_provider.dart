import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';
import '../models/saved_item.dart';

class SavedProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  List<SavedItem> _items = [];
  String _selectedCategory = 'all';

  List<SavedItem> get items {
    if (_selectedCategory == 'all') return _items;
    return _items.where((i) => i.category == _selectedCategory).toList();
  }

  String get selectedCategory => _selectedCategory;

  SavedProvider() {
    loadSavedItems();
  }

  void loadSavedItems() {
    _items = _storage.getSavedItems();
    notifyListeners();
  }

  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    await _storage.deleteSavedItem(id);
    _items = _storage.getSavedItems();
    notifyListeners();
  }

  Future<void> addItem(SavedItem item) async {
    await _storage.saveItem(item);
    _items = _storage.getSavedItems();
    notifyListeners();
  }
}
