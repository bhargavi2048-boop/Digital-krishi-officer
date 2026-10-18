import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/location_data.dart';
import '../../core/services/location_detector_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/weather_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../app/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _customAreaController = TextEditingController();
  final _landSizeController = TextEditingController(text: '2.5');
  final _otherCropsController = TextEditingController();

  String _selectedState = 'Tamil Nadu';
  String _selectedDistrict = 'Chennai';
  String _selectedArea = 'Central Chennai';
  bool _isDetectingLocation = false;
  String _selectedSoilType = 'Alluvial Soil';
  String _selectedWaterSource = 'Canal Irrigation';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _customAreaController.dispose();
    _landSizeController.dispose();
    _otherCropsController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() => _isDetectingLocation = true);
    try {
      final loc = await LocationDetectorService().detectCurrentLocation();
      if (loc != null && mounted) {
        setState(() {
          _selectedState = loc.state;
          final districts = LocationData.getDistrictsForState(loc.state);
          _selectedDistrict = districts.contains(loc.district) ? loc.district : districts.first;
          final areas = LocationData.getAreasForDistrict(_selectedDistrict);
          _selectedArea = areas.contains(loc.city) ? loc.city : areas.first;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location detected: $_selectedArea, $_selectedDistrict, $_selectedState'),
            backgroundColor: const Color(0xFF2E7D32),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not detect location. Please pick from dropdowns.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDetectingLocation = false);
      }
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('errPasswordMismatch')),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    final effectiveArea = _selectedArea == 'Other / Custom Area'
        ? (_customAreaController.text.trim().isNotEmpty ? _customAreaController.text.trim() : _selectedDistrict)
        : _selectedArea;

    final success = await auth.register(
      fullName: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      city: effectiveArea,
      district: _selectedDistrict,
      state: _selectedState,
      preferredLanguage: lang.currentLanguageCode,
      mainCrop: '',
      otherCrops: _otherCropsController.text.trim(),
      landSizeAcres: double.tryParse(_landSizeController.text.trim()) ?? 2.5,
      soilType: _selectedSoilType,
      waterAvailability: _selectedWaterSource,
    );

    if (!mounted) return;

    if (success) {
      // Immediately refresh weather for the newly registered location
      final weather = Provider.of<WeatherProvider>(context, listen: false);
      weather.loadWeather(profile: auth.currentUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('accountCreatedSuccess')),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('register')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.agriculture_rounded, size: 28, color: Color(0xFF1B5E20)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Farmer Registration',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B381F),
                            ),
                          ),
                          Text(
                            context.tr('enterDetails'),
                            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Personal Info Section
                _buildSectionHeader('Personal Credentials'),
                const SizedBox(height: 10),

                CustomTextField(
                  controller: _nameController,
                  label: context.tr('fullName'),
                  hint: 'e.g. Ramesh Kumar',
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.trim().isEmpty) ? context.tr('errNameRequired') : null,
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _mobileController,
                  label: context.tr('mobileNumber'),
                  hint: '10 digit mobile number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_android,
                  validator: (v) => (v == null || v.trim().length != 10) ? context.tr('errInvalidPhone') : null,
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _emailController,
                  label: context.tr('email'),
                  hint: 'farmer@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) => (v == null || !v.contains('@')) ? context.tr('errInvalidEmail') : null,
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _passwordController,
                  label: context.tr('password'),
                  hint: 'Minimum 8 characters',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => (v == null || v.length < 8) ? context.tr('errPasswordLength') : null,
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _confirmPasswordController,
                  label: context.tr('confirmPassword'),
                  hint: 'Re-enter password',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) => (v == null || v.isEmpty) ? context.tr('errPasswordMismatch') : null,
                ),
                const SizedBox(height: 24),

                // Location Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader('Farm Location'),
                    TextButton.icon(
                      onPressed: _isDetectingLocation ? null : _detectLocation,
                      icon: _isDetectingLocation
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E7D32)),
                            )
                          : const Icon(Icons.my_location, size: 16, color: Color(0xFF2E7D32)),
                      label: Text(
                        _isDetectingLocation ? 'Detecting...' : 'Detect Location',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        backgroundColor: const Color(0xFF2E7D32).withOpacity(0.08),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // State Dropdown
                Text(
                  context.tr('state'),
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedState,
                      items: AppConstants.indianStates.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedState = val;
                            final districts = LocationData.getDistrictsForState(val);
                            _selectedDistrict = districts.first;
                            final areas = LocationData.getAreasForDistrict(_selectedDistrict);
                            _selectedArea = areas.first;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // District Dropdown
                Text(
                  context.tr('district'),
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: LocationData.getDistrictsForState(_selectedState).contains(_selectedDistrict)
                          ? _selectedDistrict
                          : LocationData.getDistrictsForState(_selectedState).first,
                      items: LocationData.getDistrictsForState(_selectedState)
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedDistrict = val;
                            final areas = LocationData.getAreasForDistrict(val);
                            _selectedArea = areas.first;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // City / Area Dropdown
                const Text(
                  'City / Area / Taluk',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: LocationData.getAreasForDistrict(_selectedDistrict).contains(_selectedArea)
                          ? _selectedArea
                          : LocationData.getAreasForDistrict(_selectedDistrict).first,
                      items: LocationData.getAreasForDistrict(_selectedDistrict)
                          .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedArea = val);
                        }
                      },
                    ),
                  ),
                ),

                // If user selected 'Other / Custom Area', show custom text input
                if (_selectedArea == 'Other / Custom Area') ...[
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _customAreaController,
                    label: 'Specific Village / Town Name',
                    hint: 'Type your village or area name',
                    prefixIcon: Icons.location_city,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter village or town name' : null,
                  ),
                ],
                const SizedBox(height: 24),

                // Agricultural Profile Section
                _buildSectionHeader('Agricultural Profile'),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _landSizeController,
                        label: context.tr('landSize'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('soilType'),
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedSoilType,
                                items: AppConstants.soilTypes.map((st) => DropdownMenuItem(value: st, child: Text(st, style: const TextStyle(fontSize: 13)))).toList(),
                                onChanged: (val) => setState(() => _selectedSoilType = val ?? _selectedSoilType),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Text(
                  context.tr('waterAvailability'),
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedWaterSource,
                      items: AppConstants.waterSources.map((ws) => DropdownMenuItem(value: ws, child: Text(ws))).toList(),
                      onChanged: (val) => setState(() => _selectedWaterSource = val ?? _selectedWaterSource),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _otherCropsController,
                  label: context.tr('otherCrops'),
                  hint: 'e.g. Groundnut, Tomato, Chilli',
                ),
                const SizedBox(height: 16),

                // Local Device Storage Notice
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 20, color: Colors.blueGrey.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.tr('authNotice'),
                          style: TextStyle(fontSize: 11.5, color: Colors.blueGrey.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Register Button
                CustomButton(
                  text: context.tr('register'),
                  isLoading: auth.isLoading,
                  icon: Icons.check,
                  onPressed: _submitRegistration,
                ),
                const SizedBox(height: 16),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      context.tr('haveAccount'),
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      final auth = Provider.of<AuthProvider>(context, listen: false);
                      final success = await auth.loginAsGuest();
                      if (success && mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                    },
                    icon: const Icon(Icons.person_outline, size: 18, color: Color(0xFF1B5E20)),
                    label: Text(
                      context.tr('continueAsGuest'),
                      style: const TextStyle(
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B381F),
          ),
        ),
      ],
    );
  }
}