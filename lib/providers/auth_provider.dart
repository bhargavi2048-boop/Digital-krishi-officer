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
    final user = _storage.getUser();
    if (user != null && user.id == 'guest_farmer') {
      _storage.logout();
      _isLoggedIn = false;
      _currentUser = null;
    } else {
      _isLoggedIn = _storage.isLoggedIn();
      _currentUser = user;
    }
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

      FarmerProfile effectiveProfile = profile;
      try {
        final backendUser = await BackendApiService().registerFarmerBackend(profile, password);
        if (backendUser != null) {
          effectiveProfile = backendUser;
        }
      } catch (_) {}

      await _storage.saveUser(effectiveProfile);
      await _storage.setLanguage(preferredLanguage);

      _currentUser = effectiveProfile;
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

  // --- LOGIN (SPRING BOOT POSTGRESQL + LOCAL OFFLINE FALLBACK) ---
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cleanInput = email.trim().toLowerCase();
      final cleanPhone = email.replaceAll(RegExp(r'\D'), '');
      final cleanPass = password.trim();

      // 1. Try Java Spring Boot + PostgreSQL Cloud Database
      try {
        final backendUser = await BackendApiService().loginFarmerBackend(cleanInput, cleanPass);
        if (backendUser != null) {
          await _storage.saveUser(backendUser);
          await _storage.setRememberMe(rememberMe);
          _currentUser = backendUser;
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } catch (_) {}

      // 2. Offline / Local device authentication fallback
      final allUsers = _storage.getAllUsers();
      
      // Look for a matching user by Email OR Mobile Number
      final user = allUsers.firstWhere(
        (u) {
          final uEmail = u.email.trim().toLowerCase();
          final uPhone = u.mobileNumber.replaceAll(RegExp(r'\D'), '');
          final emailMatches = uEmail.isNotEmpty && uEmail == cleanInput;
          final phoneMatches = cleanPhone.length == 10 && uPhone == cleanPhone;
          final passMatches = u.passwordHash.trim() == cleanPass;
          return (emailMatches || phoneMatches) && passMatches;
        },
        orElse: () => FarmerProfile.empty(),
      );

      if (user.id.isEmpty) {
        // Check if an account with this email/phone exists
        final accountExists = allUsers.any((u) {
          final uEmail = u.email.trim().toLowerCase();
          final uPhone = u.mobileNumber.replaceAll(RegExp(r'\D'), '');
          final emailMatches = uEmail.isNotEmpty && uEmail == cleanInput;
          final phoneMatches = cleanPhone.length == 10 && uPhone == cleanPhone;
          return emailMatches || phoneMatches;
        });

        if (accountExists) {
          _errorMessage = 'Incorrect password. Please verify your password or tap "Forgot Password".';
        } else {
          // If no users exist at all and clean credentials given, assist with seamless account creation
          if (allUsers.isEmpty && cleanInput.isNotEmpty && cleanPass.length >= 6) {
            final isEmail = cleanInput.contains('@');
            final defaultUser = FarmerProfile(
              id: 'farmer_${DateTime.now().millisecondsSinceEpoch}',
              fullName: 'Farmer',
              mobileNumber: isEmail ? '9876543210' : cleanPhone,
              email: isEmail ? cleanInput : 'farmer@krishi.org',
              passwordHash: cleanPass,
              city: 'Chennai',
              district: 'Chennai',
              state: 'Tamil Nadu',
              mainCrop: 'Paddy (Rice)',
              landSizeAcres: 3.0,
              soilType: 'Alluvial Soil',
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

          _errorMessage = 'No account found for this email or mobile number. Tap "New Farmer? Create Account" below to register.';
        }
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
      await _storage.setRememberMe(false);
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

  // --- RESET PASSWORD ---
  Future<bool> resetPassword({required String emailOrMobile, required String newPassword}) async {
    final cleanInput = emailOrMobile.trim().toLowerCase();
    final cleanPhone = emailOrMobile.replaceAll(RegExp(r'\D'), '');
    final allUsers = _storage.getAllUsers();

    final index = allUsers.indexWhere((u) {
      final uEmail = u.email.trim().toLowerCase();
      final uPhone = u.mobileNumber.replaceAll(RegExp(r'\D'), '');
      return (uEmail.isNotEmpty && uEmail == cleanInput) || (cleanPhone.length == 10 && uPhone == cleanPhone);
    });

    // Sync with cloud backend
    try {
      await BackendApiService().resetPasswordBackend(cleanInput, newPassword.trim());
    } catch (_) {}

    if (index >= 0) {
      final updated = allUsers[index].copyWith(passwordHash: newPassword.trim());
      await _storage.saveUser(updated);
      notifyListeners();
      return true;
    }
    return false;
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
