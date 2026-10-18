import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/crop_provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/advisory_card.dart';
import 'add_edit_crop_screen.dart';
import '../disease_detection/disease_detection_screen.dart';
import '../../app/routes.dart';

class CropDetailScreen extends StatelessWidget {
  final String cropId;

  const CropDetailScreen({super.key, required this.cropId});

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  @override
  Widget build(BuildContext context) {
    final cropProv = Provider.of<CropProvider>(context);
    final weatherProv = Provider.of<WeatherProvider>(context);
    final chatProv = Provider.of<ChatProvider>(context, listen: false);
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final langProv = Provider.of<LanguageProvider>(context, listen: false);

    final crop = cropProv.getCropById(cropId);

    if (crop == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Crop Details')),
        body: const Center(child: Text('Crop record not found.')),
      );
    }

    final totalDays = crop.expectedHarvestDate.difference(crop.plantingDate).inDays;
    final elapsedDays = DateTime.now().difference(crop.plantingDate).inDays;
    final progress = totalDays > 0 ? (elapsedDays / totalDays).clamp(0.0, 1.0) : 0.5;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(crop.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Crop',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditCropScreen(cropToEdit: crop),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Delete Crop',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Crop'),
                  content: Text(context.tr('deleteCropConfirm')),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.tr('cancel'))),
                    ElevatedButton(
                      onPressed: () {
                        cropProv.deleteCrop(crop.id);
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(context.tr('delete')),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Lifecycle Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B381F)),
                          ),
                          if (crop.variety.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              crop.variety,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                          ],
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          crop.stage,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress to harvest
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${crop.daysRemaining} days left until harvest',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
                      ),
                      Text(
                        '${(progress * 100).toInt()}% progress',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Action: Ask AI About This Crop
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  chatProv.sendMessage(
                    text: 'Give me customized agricultural guidance, irrigation schedule and pest control steps for my ${crop.name} (${crop.variety}) currently in the ${crop.stage} stage.',
                    profile: authProv.currentUser,
                    langCode: langProv.currentLanguageCode,
                  );
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                icon: const Icon(Icons.auto_awesome, color: Colors.white),
                label: Text(
                  context.tr('askAiAboutCrop'),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Crop Information Details Grid
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crop Cultivation Specifications',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B381F)),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Planting Date', _formatDate(crop.plantingDate), Icons.event),
                  const Divider(height: 16),
                  _buildDetailRow('Expected Harvest', _formatDate(crop.expectedHarvestDate), Icons.event_available),
                  const Divider(height: 16),
                  _buildDetailRow('Land Area', '${crop.landAreaAcres} ${context.tr('acres')}', Icons.landscape),
                  const Divider(height: 16),
                  _buildDetailRow('Soil Type', crop.soilType, Icons.compost),
                  const Divider(height: 16),
                  _buildDetailRow('Water Source', crop.waterSource, Icons.water_drop),
                  if (crop.notes.isNotEmpty) ...[
                    const Divider(height: 16),
                    _buildDetailRow('Farmer Notes', crop.notes, Icons.notes),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Weather Advisory for this crop
            AdvisoryCard(
              advisoryText: weatherProv.weatherData?.agriculturalAdvisory ?? '',
            ),
            const SizedBox(height: 16),

            // Quick Disease Check for this crop
            Card(
              elevation: 0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiseaseDetectionScreen(initialCropName: crop.name),
                    ),
                  );
                },
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.red),
                ),
                title: Text(
                  'Run Disease Check for ${crop.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                subtitle: const Text('Capture leaves to inspect for blight or pest attacks', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF263238)),
          ),
        ),
      ],
    );
  }
}
