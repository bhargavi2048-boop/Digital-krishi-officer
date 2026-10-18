import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';
import '../models/farmer_alert.dart';

class AlertProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  List<FarmerAlert> _alerts = [];

  List<FarmerAlert> get alerts => _alerts;
  int get unreadCount => _alerts.where((a) => !a.isRead).length;

  AlertProvider() {
    loadAlerts();
  }

  void loadAlerts() {
    _alerts = _storage.getAlerts();
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    await _storage.markAlertRead(id);
    _alerts = _storage.getAlerts();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    await _storage.markAllAlertsRead();
    _alerts = _storage.getAlerts();
    notifyListeners();
  }

  Future<void> deleteAlert(String id) async {
    await _storage.deleteAlert(id);
    _alerts = _storage.getAlerts();
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _storage.clearAlerts();
    _alerts = [];
    notifyListeners();
  }
}
