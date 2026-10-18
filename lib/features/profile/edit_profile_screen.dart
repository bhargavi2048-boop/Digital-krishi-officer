import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/location_data.dart';
import '../../core/services/location_detector_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/weather_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _customAreaController;
  late TextEditingController _landSizeController;
  late TextEditingController _otherCropsController;

  late String _selectedState;
  late String _selectedDistrict;
  late String _selectedArea;
  bool _isDetectingLocation = false;
  late String _selectedMainCrop;
  late String _selectedSoilType;
  late String _selectedWaterSource;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    _nameController = TextEditingController(text: user?.fullName ?? '');
    _mobileController = TextEditingController(text: user?.mobileNumber ?? '');
    _landSizeController = TextEditingController(text: user?.landSizeAcres.toString() ?? '2.5');
    _otherCropsController = TextEditingController(text: user?.otherCrops ?? '');

    _selectedState = (user != null && user.state.isNotEmpty) ? user.state : 'Tamil Nadu';
    final availableDistricts = LocationData.getDistrictsForState(_selectedState);
    _selectedDistrict = (user != null && availableDistricts.contains(user.district))
        ? user.district
        : availableDistricts.first;

    final availableAreas = LocationData.getAreasForDistrict(_selectedDistrict);
    if (user != null && availableAreas.contains(user.city)) {
      _selectedArea = user.city;
      _customAreaController = TextEditingController();
    } else if (user != null && user.city.isNotEmpty) {
      _selectedArea = 'Other / Custom Area';
      _customAreaController = TextEditingController(text: user.city);
    } else {
      _selectedArea = availableAreas.first;
      _customAreaController = TextEditingController();
    }

    _selectedMainCrop = user?.mainCrop.isNotEmpty == true ? user!.mainCrop : 'Paddy (Rice)';
    _selectedSoilType = user?.soilType.isNotEmpty == true ? user!.soilType : 'Alluvial Soil';
    _selectedWaterSource = user?.waterAvailability.isNotEmpty == true ? user!.waterAvailability : 'Canal Irrigation';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
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
          const SnackBar(content: Text('Could not detect location. Please select from dropdowns.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDetectingLocation = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.currentUser != null) {
      final effectiveArea = _selectedArea == 'Other / Custom Area'
          ? (_customAreaController.text.trim().isNotEmpty ? _customAreaController.text.trim() : _selectedDistrict)
          : _selectedArea;

      final updated = auth.currentUser!.copyWith(
        fullName: _nameController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        city: effectiveArea,
        district: _selectedDistrict,
        state: _selectedState,
        mainCrop: _selectedMainCrop,
        otherCrops: _otherCropsController.text.trim(),
        landSizeAcres: double.tryParse(_landSizeController.text.trim()) ?? 2.5,
        soilType: _selectedSoilType,
        waterAvailability: _selectedWaterSource,
      );

      await auth.updateProfile(updated);

      if (!mounted) return;

      // Update weather immediately for new profile location
      final weather = Provider.of<WeatherProvider>(context, listen: false);
      weather.loadWeather(profile: updated);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile and Farm Location updated successfully!'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('editProfile')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                label: context.tr('fullName'),
                prefixIcon: Icons.person_outline,
                validator: (v) => (v == null || v.trim().isEmpty) ? context.tr('errNameRequired') : null,
              ),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _mobileController,
                label: context.tr('mobileNumber'),
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_android,
                validator: (v) => (v == null || v.trim().length != 10) ? context.tr('errInvalidPhone') : null,
              ),
              const SizedBox(height: 14),

              const SizedBox(height: 10),

              // Location Header with Detect Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Farm Location',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B381F)),
                  ),
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
              const SizedBox(height: 14),

              Text(
                context.tr('mainCrop'),
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
                    value: _selectedMainCrop,
                    items: AppConstants.commonCrops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => _selectedMainCrop = val ?? _selectedMainCrop),
                  ),
                ),
              ),
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
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: context.tr('save'),
                icon: Icons.check,
                onPressed: _saveProfile,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}