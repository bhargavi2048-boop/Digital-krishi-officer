import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/farmer_profile.dart';
import '../../models/crop.dart';
import '../../models/chat_message.dart';
import '../../models/conversation.dart';
import '../../models/disease_analysis.dart';
import '../../models/saved_item.dart';
import '../../models/farmer_alert.dart';
import '../../models/app_settings.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('LocalStorageService must be initialized before use.');
    }
    return _prefs!;
  }

  // --- KEYS ---
  static const String _keyUser = 'dk_user_profile';
  static const String _keyAllUsers = 'dk_all_registered_users';
  static const String _keyIsLoggedIn = 'dk_is_logged_in';
  static const String _keyRememberMe = 'dk_remember_me';
  static const String _keyOnboardingDone = 'dk_onboarding_completed';
  static const String _keySettings = 'dk_app_settings';
  static const String _keyCrops = 'dk_farmer_crops';
  static const String _keyConversations = 'dk_chat_conversations';
  static const String _keyMessagesPrefix = 'dk_chat_messages_';
  static const String _keyDiseaseHistory = 'dk_disease_history';
  static const String _keySavedItems = 'dk_saved_items';
  static const String _keyAlerts = 'dk_farmer_alerts';

  // --- ONBOARDING ---
  bool isOnboardingCompleted() {
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await prefs.setBool(_keyOnboardingDone, value);
  }

  // --- AUTH & USER PROFILE ---
  bool isLoggedIn() {
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  bool getRememberMe() {
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  Future<void> setRememberMe(bool value) async {
    await prefs.setBool(_keyRememberMe, value);
  }

  FarmerProfile? getUser() {
    final jsonStr = prefs.getString(_keyUser);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      return FarmerProfile.fromJson(jsonStr);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(FarmerProfile user) async {
    await prefs.setString(_keyUser, user.toJson());
    await prefs.setBool(_keyIsLoggedIn, true);

    // Also persist in all registered users directory for local authentication
    final allUsers = getAllUsers();
    final index = allUsers.indexWhere((u) => u.email.toLowerCase() == user.email.toLowerCase());
    if (index >= 0) {
      allUsers[index] = user;
    } else {
      allUsers.add(user);
    }
    await _saveAllUsers(allUsers);
  }

  List<FarmerProfile> getAllUsers() {
    final jsonStr = prefs.getString(_keyAllUsers);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List list = json.decode(jsonStr);
      return list.map((item) => FarmerProfile.fromMap(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAllUsers(List<FarmerProfile> users) async {
    final list = users.map((u) => u.toMap()).toList();
    await prefs.setString(_keyAllUsers, json.encode(list));
  }

  Future<void> logout() async {
    await prefs.setBool(_keyIsLoggedIn, false);
    if (!getRememberMe()) {
      await prefs.remove(_keyUser);
    }
  }

  // --- APP SETTINGS ---
  AppSettings getSettings() {
    final jsonStr = prefs.getString(_keySettings);
    if (jsonStr == null || jsonStr.isEmpty) return AppSettings();
    try {
      return AppSettings.fromJson(jsonStr);
    } catch (_) {
      return AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    await prefs.setString(_keySettings, settings.toJson());
  }

  String getLanguage() {
    return getSettings().languageCode;
  }

  Future<void> setLanguage(String code) async {
    final current = getSettings();
    await saveSettings(current.copyWith(languageCode: code));
  }

  // --- CROPS CRUD ---
  List<Crop> getCrops() {
    final jsonStr = prefs.getString(_keyCrops);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List list = json.decode(jsonStr);
      final crops = list.map((item) => Crop.fromMap(item)).toList();
      // Exclude any legacy dummy seeded crops so only farmer's added crops appear
      return crops.where((c) => c.id != 'crop_paddy_1' && c.id != 'crop_tomato_2').toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCrops(List<Crop> crops) async {
    final list = crops.map((c) => c.toMap()).toList();
    await prefs.setString(_keyCrops, json.encode(list));
  }

  Future<void> addCrop(Crop crop) async {
    final crops = getCrops();
    crops.insert(0, crop);
    await saveCrops(crops);
  }

  Future<void> updateCrop(Crop crop) async {
    final crops = getCrops();
    final index = crops.indexWhere((c) => c.id == crop.id);
    if (index >= 0) {
      crops[index] = crop;
      await saveCrops(crops);
    }
  }

  Future<void> deleteCrop(String cropId) async {
    final crops = getCrops();
    crops.removeWhere((c) => c.id == cropId);
    await saveCrops(crops);
  }

  // --- CHAT CONVERSATIONS & MESSAGES ---
  List<Conversation> getConversations() {
    final jsonStr = prefs.getString(_keyConversations);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List list = json.decode(jsonStr);
      return list.map((item) => Conversation.fromMap(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    final list = conversations.map((c) => c.toMap()).toList();
    await prefs.setString(_keyConversations, json.encode(list));
  }

  Future<void> addOrUpdateConversation(Conversation conversation) async {
    final list = getConversations();
    final index = list.indexWhere((c) => c.id == conversation.id);
    if (index >= 0) {
      list[index] = conversation;
    } else {
      list.insert(0, conversation);
    }
    await saveConversations(list);
  }

  Future<void> deleteConversation(String conversationId) async {
    final list = getConversations();
    list.removeWhere((c) => c.id == conversationId);
    await saveConversations(list);
    await prefs.remove('$_keyMessagesPrefix$conversationId');
  }

  Future<void> clearAllChats() async {
    final conversations = getConversations();
    for (var c in conversations) {
      await prefs.remove('$_keyMessagesPrefix${c.id}');
    }
    await prefs.remove(_keyConversations);
  }

  List<ChatMessage> getMessages(String conversationId) {
    final jsonStr = prefs.getString('$_keyMessagesPrefix$conversationId');
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List list = json.decode(jsonStr);
      return list.map((item) => ChatMessage.fromMap(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMessages(String conversationId, List<ChatMessage> messages) async {
    final list = messages.map((m) => m.toMap()).toList();
    await prefs.setString('$_keyMessagesPrefix$conversationId', json.encode(list));
  }

  // --- DISEASE DIAGNOSIS HISTORY ---
  List<DiseaseAnalysis> getDiseaseHistory() {
    final jsonStr = prefs.getString(_keyDiseaseHistory);
    if (jsonStr == null || jsonStr.isEmpty) return _getDefaultDiseaseHistory();
    try {
      final List list = json.decode(jsonStr);
      return list.map((item) => DiseaseAnalysis.fromMap(item)).toList();
    } catch (_) {
      return _getDefaultDiseaseHistory();
    }
  }

  Future<void> saveDiseaseAnalysis(DiseaseAnalysis analysis) async {
    final history = getDiseaseHistory();
    history.insert(0, analysis);
    final list = history.map((d) => d.toMap()).toList();
    await prefs.setString(_keyDiseaseHistory, json.encode(list));
  }

  Future<void> deleteDiseaseAnalysis(String id) async {
    final history = getDiseaseHistory();
    history.removeWhere((d) => d.id == id);
    final list = history.map((d) => d.toMap()).toList();
    await prefs.setString(_keyDiseaseHistory, json.encode(list));
  }

  List<DiseaseAnalysis> _getDefaultDiseaseHistory() {
    return [
      DiseaseAnalysis(
        id: 'disease_sample_1',
        cropName: 'Tomato',
        possibleIssue: 'Early Blight (Alternaria solani)',
        confidenceScore: 86,
        observedSymptoms: 'Concentric brown rings with yellow halo on lower older leaves, slight stem collar canker.',
        possibleCauses: 'Prolonged leaf wetness, warm humid temperatures (24-29°C), splash dispersal from soil.',
        recommendedAction: 'Prune infected lower foliage immediately to prevent upward transmission. Spray Mancozeb 75% WP (2g/L) or Copper Oxychloride. Ensure drip irrigation instead of overhead watering.',
        prevention: 'Maintain 60cm row spacing for ventilation. Apply organic mulch. Practice 2-year crop rotation without solanaceous crops.',
        whenToSeekExpert: 'If lesions spread to more than 30% of canopy or reach fruit calyx within 48 hours.',
        date: DateTime.now().subtract(const Duration(days: 3)),
      )
    ];
  }

  // --- SAVED ITEMS ---
  List<SavedItem> getSavedItems() {
    final jsonStr = prefs.getString(_keySavedItems);
    if (jsonStr == null || jsonStr.isEmpty) return _getDefaultSavedItems();
    try {
      final List list = json.decode(jsonStr);
      return list.map((item) => SavedItem.fromMap(item)).toList();
    } catch (_) {
      return _getDefaultSavedItems();
    }
  }

  Future<void> saveItem(SavedItem item) async {
    final items = getSavedItems();
    items.insert(0, item);
    final list = items.map((i) => i.toMap()).toList();
    await prefs.setString(_keySavedItems, json.encode(list));
  }

  Future<void> deleteSavedItem(String id) async {
    final items = getSavedItems();
    items.removeWhere((i) => i.id == id);
    final list = items.map((i) => i.toMap()).toList();
    await prefs.setString(_keySavedItems, json.encode(list));
  }

  List<SavedItem> _getDefaultSavedItems() {
    return [
      SavedItem(
        id: 'saved_pm_kisan',
        title: 'PM-KISAN Samman Nidhi',
        subtitle: 'Direct Income Support of ₹6,000 per year',
        category: 'scheme',
        content: 'Provides ₹6,000/year in 3 installments of ₹2,000 directly to bank accounts via DBT for all landholding farmer families.',
      ),
    ];
  }

  // --- ALERTS ---
  List<FarmerAlert> getAlerts() {
    final jsonStr = prefs.getString(_keyAlerts);
    if (jsonStr == null || jsonStr.isEmpty) return _getDefaultAlerts();
    try {
      final List list = json.decode(jsonStr);
      return list.map((item) => FarmerAlert.fromMap(item)).toList();
    } catch (_) {
      return _getDefaultAlerts();
    }
  }

  Future<void> saveAlert(FarmerAlert alert) async {
    final alerts = getAlerts();
    alerts.insert(0, alert);
    final list = alerts.map((a) => a.toMap()).toList();
    await prefs.setString(_keyAlerts, json.encode(list));
  }

  Future<void> markAlertRead(String id) async {
    final alerts = getAlerts();
    final index = alerts.indexWhere((a) => a.id == id);
    if (index >= 0) {
      alerts[index] = alerts[index].copyWith(isRead: true);
      final list = alerts.map((a) => a.toMap()).toList();
      await prefs.setString(_keyAlerts, json.encode(list));
    }
  }

  Future<void> markAllAlertsRead() async {
    final alerts = getAlerts().map((a) => a.copyWith(isRead: true)).toList();
    final list = alerts.map((a) => a.toMap()).toList();
    await prefs.setString(_keyAlerts, json.encode(list));
  }

  Future<void> deleteAlert(String id) async {
    final alerts = getAlerts();
    alerts.removeWhere((a) => a.id == id);
    final list = alerts.map((a) => a.toMap()).toList();
    await prefs.setString(_keyAlerts, json.encode(list));
  }

  Future<void> clearAlerts() async {
    await prefs.remove(_keyAlerts);
  }

  List<FarmerAlert> _getDefaultAlerts() {
    return [
      FarmerAlert(
        id: 'alert_weather_rain_1',
        title: 'Rain Expected Tomorrow',
        description: 'Moderate showers predicted (60% probability). Avoid scheduled irrigation and postpone foliar spray operations.',
        type: 'weather',
        severity: 'warning',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FarmerAlert(
        id: 'alert_crop_humidity_2',
        title: 'Fungal Advisory: High Humidity',
        description: 'Atmospheric humidity reached 78%. Closely inspect your Tomato crop for early signs of blight or mildew.',
        type: 'disease',
        severity: 'critical',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      FarmerAlert(
        id: 'alert_scheme_kcc_3',
        title: 'Kisan Credit Card (KCC) Renewal',
        description: 'Ensure prompt loan repayment to avail 3% interest subvention, effectively reducing borrowing rate to 4%.',
        type: 'scheme',
        severity: 'info',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
