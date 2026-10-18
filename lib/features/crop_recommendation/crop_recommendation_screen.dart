import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/crop_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/language_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';
import 'recommendation_result_screen.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() => _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _districtController = TextEditingController(text: 'Thanjavur');
  final _landSizeController = TextEditingController(text: '3.0');
  final _previousCropController = TextEditingController(text: 'Paddy');

  String _selectedState = 'Tamil Nadu';
  String _selectedSeason = 'Kharif (Monsoon: Jun - Oct)';
  String _selectedSoilType = 'Alluvial Soil';
  String _selectedWaterSource = 'Canal Irrigation';

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.currentUser != null) {
      final user = auth.currentUser!;
      if (user.district.isNotEmpty) _districtController.text = user.district;
      if (user.state.isNotEmpty) _selectedState = user.state;
      if (user.soilType.isNotEmpty) _selectedSoilType = user.soilType;
      if (user.waterAvailability.isNotEmpty) _selectedWaterSource = user.waterAvailability;
      _landSizeController.text = user.landSizeAcres.toString();
    }
  }

  @override
  void dispose() {
    _districtController.dispose();
    _landSizeController.dispose();
    _previousCropController.dispose();
    super.dispose();
  }

  Future<void> _submitRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    final cropProv = Provider.of<CropProvider>(context, listen: false);
    final weatherProv = Provider.of<WeatherProvider>(context, listen: false);
    final langProv = Provider.of<LanguageProvider>(context, listen: false);

    final success = await cropProv.generateCropRecommendations(
      state: _selectedState,
      district: _districtController.text.trim(),
      season: _selectedSeason,
      soilType: _selectedSoilType,
      landSizeAcres: double.tryParse(_landSizeController.text.trim()) ?? 2.5,
      waterAvailability: _selectedWaterSource,
      previousCrop: _previousCropController.text.trim(),
      currentTemperature: weatherProv.weatherData != null ? '${weatherProv.weatherData!.temperature}°C' : '31°C',
      rainfallForecast: weatherProv.weatherData != null ? '${weatherProv.weatherData!.rainProbability}% rain chance' : 'Moderate',
      langCode: langProv.currentLanguageCode,
    );

    if (!mounted) return;

    if (success && cropProv.recommendations.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecommendationResultScreen(
            recommendations: cropProv.recommendations,
            season: _selectedSeason,
            soilType: _selectedSoilType,
          ),
        ),
      );
    } else if (cropProv.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cropProv.errorMessage!),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropProv = Provider.of<CropProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('cropRecTitle')),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32).withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('🌱', style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Smart Crop Recommendation',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B381F)),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Tailored suggestions based on your agro-climatic zone, water resources, and soil conditions.',
                                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // State and District
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
                        onChanged: (val) => setState(() => _selectedState = val ?? _selectedState),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  CustomTextField(
                    controller: _districtController,
                    label: context.tr('district'),
                    hint: 'e.g. Thanjavur, Guntur, Nashik',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // Season Selection
                  const Text(
                    'Target Sowing Season',
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
                        value: _selectedSeason,
                        items: AppConstants.seasons.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                        onChanged: (val) => setState(() => _selectedSeason = val ?? _selectedSeason),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Soil Type
                  Text(
                    context.tr('soilType'),
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
                        value: _selectedSoilType,
                        items: AppConstants.soilTypes.map((st) => DropdownMenuItem(value: st, child: Text(st))).toList(),
                        onChanged: (val) => setState(() => _selectedSoilType = val ?? _selectedSoilType),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Water Source
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
                        child: CustomTextField(
                          controller: _previousCropController,
                          label: 'Previous Crop (Optional)',
                          hint: 'e.g. Paddy, Cotton',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    text: context.tr('getRecButton'),
                    icon: Icons.auto_awesome,
                    isLoading: cropProv.isGeneratingRecommendations,
                    onPressed: _submitRecommendation,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          if (cropProv.isGeneratingRecommendations)
            LoadingOverlay(message: context.tr('generatingRec')),
        ],
      ),
    );
  }
}
