import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';
import '../models/farmer_profile.dart';
import '../core/services/backend_api_service.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  FarmerProfile? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  FarmerProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isGuest => _currentUser?.id == 'guest_farmer';

  AuthProvider() {
    _loadUserSession();
  }

  void _loadUserSession() {
    _isLoggedIn = _storage.isLoggedIn();
    _currentUser = _storage.getUser();
    notifyListeners();
  }

  // --- LOCAL REGISTRATION ---
  Future<bool> register({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String password,
    required String city,
    required String district,
    required String state,
    required String preferredLanguage,
    String mainCrop = 'Paddy (Rice)',
    String otherCrops = '',
    double landSizeAcres = 2.5,
    String soilType = 'Alluvial Soil',
    String waterAvailability = 'Canal Irrigation',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate inputs
      if (fullName.trim().isEmpty) {
        _errorMessage = 'Please enter your name.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      if (mobileNumber.trim().length != 10) {
        _errorMessage = 'Please enter a valid 10-digit mobile number.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      if (!email.contains('@') || !email.contains('.')) {
        _errorMessage = 'Please enter a valid email address.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      if (password.length < 8) {
        _errorMessage = 'Password must contain at least 8 characters.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if email already registered locally
      final allUsers = _storage.getAllUsers();
      if (allUsers.any((u) => u.email.toLowerCase() == email.trim().toLowerCase())) {
        _errorMessage = 'An account with this email already exists on this device.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final profile = FarmerProfile(
        id: 'farmer_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName.trim(),
        mobileNumber: mobileNumber.trim(),
        email: email.trim().toLowerCase(),
        passwordHash: password, // Stored locally on device
        city: city.trim(),
        district: district.trim(),
        state: state.trim(),
        preferredLanguage: preferredLanguage,
        mainCrop: mainCrop,
        otherCrops: otherCrops,
        landSizeAcres: landSizeAcres,
        soilType: soilType,
        waterAvailability: waterAvailability,
      );

      await _storage.saveUser(profile);
      await _storage.setLanguage(preferredLanguage);

      // Asynchronously synchronize with Java Spring Boot backend
      BackendApiService().syncFarmer(profile).catchError((_) {});

      _currentUser = profile;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- LOCAL LOGIN ---
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cleanEmail = email.trim().toLowerCase();
      final allUsers = _storage.getAllUsers();
      final user = allUsers.firstWhere(
        (u) => u.email.toLowerCase() == cleanEmail && u.passwordHash == password,
        orElse: () => FarmerProfile(
          id: '',
          fullName: '',
          mobileNumber: '',
          email: '',
          passwordHash: '',
          city: '',
          district: '',
          state: '',
        ),
      );

      if (user.id.isEmpty) {
        // If first run and user inputs any valid email/password, facilitate seamless login
        if (allUsers.isEmpty && cleanEmail.isNotEmpty && password.length >= 6) {
          final defaultUser = FarmerProfile(
            id: 'farmer_default',
            fullName: 'Ravi Kumar',
            mobileNumber: '9876543210',
            email: cleanEmail,
            passwordHash: password,
            city: 'Chennai',
            district: 'Chennai',
            state: 'Tamil Nadu',
            mainCrop: 'Paddy (Rice)',
            landSizeAcres: 3.5,
            soilType: 'Clay Soil',
            waterAvailability: 'Canal Irrigation',
          );
          await _storage.saveUser(defaultUser);
          await _storage.setRememberMe(rememberMe);
          _currentUser = defaultUser;
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
          return true;
        }

        _errorMessage = 'Invalid email or password. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _storage.saveUser(user);
      await _storage.setRememberMe(rememberMe);
      _currentUser = user;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- GUEST LOGIN ---
  Future<bool> loginAsGuest() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final lang = _storage.getLanguage();
      final guestUser = FarmerProfile(
        id: 'guest_farmer',
        fullName: lang == 'ta' ? 'விருந்தினர் உழவர்' : 'Guest Farmer',
        mobileNumber: '9999999999',
        email: 'guest@krishiofficer.org',
        passwordHash: '',
        city: 'Chennai',
        district: 'Chennai',
        state: 'Tamil Nadu',
        preferredLanguage: lang,
        mainCrop: 'Paddy (Rice)',
        landSizeAcres: 2.0,
        soilType: 'Alluvial Soil',
        waterAvailability: 'Canal Irrigation',
      );

      await _storage.saveUser(guestUser);
      await _storage.setRememberMe(true);
      _currentUser = guestUser;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Guest login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- UPDATE PROFILE ---
  Future<void> updateProfile(FarmerProfile updated) async {
    _currentUser = updated;
    await _storage.saveUser(updated);
    notifyListeners();

    // Asynchronously synchronize with Java Spring Boot backend
    BackendApiService().syncFarmer(updated).catchError((_) {});
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    await _storage.logout();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
