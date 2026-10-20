import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/disease_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../core/utils/image_helper.dart';
import '../../core/utils/camera_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_image_preview.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/disclaimer_banner.dart';
import '../../widgets/loading_overlay.dart';
import 'disease_result_screen.dart';
import 'disease_history_screen.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  final String? initialCropName;
  const DiseaseDetectionScreen({super.key, this.initialCropName});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final TextEditingController _symptomDescController = TextEditingController();

  @override
  void dispose() {
    _symptomDescController.dispose();
    super.dispose();
  }

  Future<void> _runAnalysis() async {
    final diseaseProv = Provider.of<DiseaseProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    final success = await diseaseProv.analyzeCropDisease(
      cropName: (auth.currentUser?.mainCrop.isNotEmpty == true) ? auth.currentUser!.mainCrop : '',
      description: _symptomDescController.text.trim(),
      profile: auth.currentUser,
      langCode: lang.currentLanguageCode,
    );

    if (!mounted) return;

    if (success && diseaseProv.latestResult != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DiseaseResultScreen(analysis: diseaseProv.latestResult!),
        ),
      );
    } else if (diseaseProv.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(diseaseProv.errorMessage!),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final diseaseProv = Provider.of<DiseaseProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('diseaseDetectionTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Diagnosis History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DiseaseHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instruction card
                Card(
                  elevation: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.biotech, color: Color(0xFF2E7D32), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AI Vision Crop Diagnostic',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF1B381F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.tr('selectMediaHint'),
                                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.35),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Media Upload Area
                const Text(
                  'Crop Photo / Video Inspection',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B381F),
                  ),
                ),
                const SizedBox(height: 10),

                if (diseaseProv.selectedMedia != null) ...[
                  // Media Preview Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2E7D32), width: 1.5),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: diseaseProv.isVideo
                                  ? Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: const Color(0xFF1E293B),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.videocam_rounded, size: 48, color: Colors.white),
                                          const SizedBox(height: 8),
                                          Text(
                                            diseaseProv.selectedMediaName ?? 'Crop Video Selected',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          if (diseaseProv.selectedMediaSize != null)
                                            Text(
                                              ImageHelper.formatBytes(diseaseProv.selectedMediaSize!),
                                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                                            ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            'Frames & clip ready for AI analysis',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  : AppImagePreview(
                                      bytes: diseaseProv.selectedMediaBytes,
                                      path: diseaseProv.selectedMedia?.path,
                                      height: 220,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                radius: 18,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: Colors.white),
                                  onPressed: () => diseaseProv.clearSelectedMedia(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (diseaseProv.isVideo) ...[
                          const SizedBox(height: 8),
                          Text(
                            context.tr('frameAnalysisNotice'),
                            style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ],
                    ),
                  ),
                ] else ...[
                  // Media Option Selection Buttons
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildMediaButton(
                                icon: Icons.camera_alt,
                                label: context.tr('takePhoto'),
                                onTap: () async {
                                  final captured = await CameraHelper.captureLivePhoto(context);
                                  if (captured != null) {
                                    diseaseProv.setSelectedCapturedMedia(captured);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMediaButton(
                                icon: Icons.photo_library,
                                label: context.tr('uploadImage'),
                                onTap: () => diseaseProv.pickImage(ImageSource.gallery),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMediaButton(
                                icon: Icons.videocam,
                                label: context.tr('uploadVideo'),
                                onTap: () => diseaseProv.pickVideo(ImageSource.gallery),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 18),

                // Symptoms Description Field
                CustomTextField(
                  controller: _symptomDescController,
                  label: 'Observed Leaf / Plant Symptoms (Optional)',
                  hint: 'e.g. Yellow spots on lower leaves with dark concentric rings...',
                  maxLines: 3,
                  prefixIcon: Icons.description_outlined,
                ),
                const SizedBox(height: 16),

                // Safety Disclaimer
                const DisclaimerBanner(),
                const SizedBox(height: 20),

                // Submit Button
                CustomButton(
                  text: context.tr('analyzeCrop'),
                  icon: Icons.biotech,
                  isLoading: diseaseProv.isAnalyzing,
                  onPressed: _runAnalysis,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Loading Overlay
          if (diseaseProv.isAnalyzing)
            LoadingOverlay(message: context.tr('analyzingCrop')),
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8E9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B5E20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
