import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/advisory_card.dart';

import '../../core/services/location_detector_service.dart';

class WeatherDetailScreen extends StatefulWidget {
  const WeatherDetailScreen({super.key});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyLocationChange(String loc) {
    final clean = loc.trim();
    if (clean.isEmpty) return;
    
    final weatherProv = Provider.of<WeatherProvider>(context, listen: false);
    weatherProv.changeLocation(clean);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Weather location updated to $clean'),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showChangeLocationDialog() {
    _searchController.text = Provider.of<WeatherProvider>(context, listen: false).currentLocationName;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF2E7D32)),
            SizedBox(width: 8),
            Text('Change Weather Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter District or City (e.g. Madurai)',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onSubmitted: (val) {
                  Navigator.pop(ctx);
                  _applyLocationChange(val);
                },
              ),
              const SizedBox(height: 12),
              const Text('Quick Select:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ['Chennai', 'Thanjavur', 'Coimbatore', 'Madurai', 'Trichy', 'Salem', 'Tirunelveli', 'Erode'].map((loc) {
                  return ActionChip(
                    label: Text(loc, style: const TextStyle(fontSize: 11.5)),
                    backgroundColor: const Color(0xFFE8F5E9),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _applyLocationChange(loc);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Detecting your GPS location...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  final loc = await LocationDetectorService().detectCurrentLocation();
                  if (loc != null && mounted) {
                    final weather = Provider.of<WeatherProvider>(context, listen: false);
                    final name = '${loc.district}, ${loc.state}';
                    if (loc.latitude != null && loc.longitude != null) {
                      weather.updateCurrentCoordinates(loc.latitude!, loc.longitude!, name);
                    } else {
                      weather.changeLocation(name);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location detected: $name'),
                        backgroundColor: const Color(0xFF2E7D32),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.my_location, size: 16, color: Color(0xFF2E7D32)),
                label: const Text('Detect Current GPS Location', style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32))),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final loc = _searchController.text.trim();
              Navigator.pop(ctx);
              _applyLocationChange(loc);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  String _formatDay(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }

  IconData _getWeatherIcon(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('rain') || c.contains('shower')) return Icons.water_drop;
    if (c.contains('thunder')) return Icons.flash_on;
    if (c.contains('cloud') || c.contains('overcast')) return Icons.cloud;
    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    final weatherProv = Provider.of<WeatherProvider>(context);
    final w = weatherProv.weatherData;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('weatherTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_location_alt_outlined),
            tooltip: 'Change Farm Location',
            onPressed: _showChangeLocationDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Weather',
            onPressed: () => weatherProv.loadWeather(),
          ),
        ],
      ),
      body: w == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Live Weather Card (Tapping location or card opens Change Location)
                  WeatherCard(
                    weather: w,
                    onTap: _showChangeLocationDialog,
                    onChangeLocation: _showChangeLocationDialog,
                  ),
                  const SizedBox(height: 16),

                  // Today's Agricultural Advisory Banner
                  AdvisoryCard(advisoryText: w.agriculturalAdvisory),
                  const SizedBox(height: 20),

                  // 7-Day Forecast Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('forecast7Day'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B381F),
                        ),
                      ),
                      Text(
                        '${w.forecast.length} Days',
                        style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: w.forecast.length,
                      separatorBuilder: (ctx, i) => const Divider(height: 1),
                      itemBuilder: (ctx, idx) {
                        final f = w.forecast[idx];
                        final isToday = idx == 0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  isToday ? 'Today' : '${_formatDay(f.date)}, ${f.date.day}/${f.date.month}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                                    color: isToday ? const Color(0xFF2E7D32) : const Color(0xFF263238),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(_getWeatherIcon(f.condition), size: 18, color: const Color(0xFF2E7D32)),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${f.rainProbability}% rain',
                                    style: TextStyle(fontSize: 11.5, color: Colors.blueGrey.shade600),
                                  ),
                                ],
                              ),
                              Text(
                                '${f.maxTemp.toInt()}° / ${f.minTemp.toInt()}°C',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B381F),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Weather Impact on Farming Operations Card
                  Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Farm Operations Guidance',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B381F),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildOperationStatus(
                            title: 'Pesticide & Foliar Spraying',
                            status: w.rainProbability >= 50 ? 'Not Recommended (Rain Washout Risk)' : 'Favorable',
                            isGood: w.rainProbability < 50,
                          ),
                          const SizedBox(height: 10),
                          _buildOperationStatus(
                            title: 'Field Irrigation Schedule',
                            status: w.rainProbability >= 60 ? 'Postpone Irrigation' : 'Normal Irrigation Schedule',
                            isGood: w.rainProbability < 60,
                          ),
                          const SizedBox(height: 10),
                          _buildOperationStatus(
                            title: 'Harvesting & Threshing',
                            status: w.rainProbability >= 50 ? 'Protect harvested sheaves under tarpaulin' : 'Good Drying Conditions',
                            isGood: w.rainProbability < 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildOperationStatus({required String title, required String status, required bool isGood}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isGood ? Icons.check_circle : Icons.warning_amber_rounded,
          size: 18,
          color: isGood ? const Color(0xFF2E7D32) : Colors.orange.shade800,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF263238)),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: isGood ? Colors.green.shade800 : Colors.orange.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
