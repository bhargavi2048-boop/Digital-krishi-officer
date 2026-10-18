import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/disease_analysis.dart';
import '../../providers/disease_provider.dart';
import '../../providers/language_provider.dart';
import '../../core/services/tts_service.dart';
import '../../core/services/share_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_image_preview.dart';
import '../../widgets/disclaimer_banner.dart';
import '../settings/expert_escalation_screen.dart';

class DiseaseResultScreen extends StatefulWidget {
  final DiseaseAnalysis analysis;

  const DiseaseResultScreen({super.key, required this.analysis});

  @override
  State<DiseaseResultScreen> createState() => _DiseaseResultScreenState();
}

class _DiseaseResultScreenState extends State<DiseaseResultScreen> {
  final TtsService _tts = TtsService();
  bool _isSpeaking = false;

  void _toggleSpeak(String langCode) {
    if (_isSpeaking) {
      _tts.stop();
      setState(() => _isSpeaking = false);
    } else {
      final text = '''
Crop: ${widget.analysis.cropName}.
Likely Issue: ${widget.analysis.possibleIssue}.
Symptoms: ${widget.analysis.observedSymptoms}.
Recommended Action: ${widget.analysis.recommendedAction}.
Prevention: ${widget.analysis.prevention}.
''';
      _tts.speak(text, langCode: langCode);
      setState(() => _isSpeaking = true);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final diseaseProv = Provider.of<DiseaseProvider>(context, listen: false);
    final a = widget.analysis;
    final isLowConfidence = a.confidenceScore < 70;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: const Text('Disease Analysis Report'),
        actions: [
          IconButton(
            icon: Icon(_isSpeaking ? Icons.volume_off : Icons.volume_up),
            tooltip: 'Listen to Report',
            onPressed: () => _toggleSpeak(lang.currentLanguageCode),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Save to Bookmarks',
            onPressed: () async {
              await diseaseProv.saveResultToSavedItems(a);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.tr('saveSuccess')), duration: const Duration(seconds: 2)),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: context.tr('shareReport'),
            onPressed: () {
              ShareService().shareDiseaseReport(a, lang.currentLanguageCode);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Preview (Image or Video)
            if (a.isVideoAnalysis) ...[
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam_rounded, size: 48, color: Colors.greenAccent),
                    const SizedBox(height: 8),
                    Text(
                      'Video Inspection: ${a.cropName}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'AI Video Frame & Multimodal Analysis Completed',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else if (a.imageBytes != null || (a.imagePath != null && a.imagePath!.isNotEmpty)) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppImagePreview(
                  bytes: a.imageBytes,
                  path: a.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Audio Advice Player Bar
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _isSpeaking ? const Color(0xFFE8F5E9) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isSpeaking ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                  width: _isSpeaking ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _isSpeaking ? const Color(0xFF2E7D32) : const Color(0xFFF1F8E9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isSpeaking ? Icons.stop_rounded : Icons.play_arrow_rounded,
                        color: _isSpeaking ? Colors.white : const Color(0xFF2E7D32),
                        size: 22,
                      ),
                      onPressed: () => _toggleSpeak(lang.currentLanguageCode),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSpeaking ? 'Playing Voice Advice...' : 'Listen to Audio Diagnosis',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: _isSpeaking ? const Color(0xFF1B5E20) : const Color(0xFF263238),
                          ),
                        ),
                        Text(
                          _isSpeaking ? 'Tap stop to pause speech' : 'Voice explanation in your selected language',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Diagnosis Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Crop: ${a.cropName}',
                          style: const TextStyle(
                            color: Color(0xFF1B5E20),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLowConfidence ? Colors.orange.shade100 : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLowConfidence ? Icons.info_outline : Icons.verified_outlined,
                              size: 14,
                              color: isLowConfidence ? Colors.orange.shade900 : Colors.green.shade900,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'AI Confidence: ${a.confidenceScore}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isLowConfidence ? Colors.orange.shade900 : Colors.green.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Text(
                    context.tr('possibleIssue'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    a.possibleIssue,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B381F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Expert Escalation Warning if low confidence or high risk
            if (isLowConfidence)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade400),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.amber.shade900, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'AI Confidence is Low',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('escalationNotice'),
                      style: TextStyle(fontSize: 13, color: Colors.amber.shade900, height: 1.35),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ExpertEscalationScreen()),
                        );
                      },
                      icon: const Icon(Icons.phone_in_talk, size: 16),
                      label: const Text('Contact Agricultural Support Officer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade900,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),

            // Detailed Sections
            _buildDetailSection(
              title: context.tr('observedSymptoms'),
              content: a.observedSymptoms,
              icon: Icons.visibility,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 12),

            _buildDetailSection(
              title: context.tr('possibleCauses'),
              content: a.possibleCauses,
              icon: Icons.coronavirus_outlined,
              color: Colors.orange.shade700,
            ),
            const SizedBox(height: 12),

            _buildDetailSection(
              title: context.tr('recommendedAction'),
              content: a.recommendedAction,
              icon: Icons.healing,
              color: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 12),

            _buildDetailSection(
              title: context.tr('prevention'),
              content: a.prevention,
              icon: Icons.shield,
              color: Colors.teal.shade700,
            ),
            const SizedBox(height: 12),

            _buildDetailSection(
              title: context.tr('whenSeekExpert'),
              content: a.whenToSeekExpert,
              icon: Icons.medical_services_outlined,
              color: Colors.red.shade700,
            ),
            const SizedBox(height: 16),

            // Prescription Sharing Card for WhatsApp & Dealer
            _buildPrescriptionShareCard(context, a, lang.currentLanguageCode),
            const SizedBox(height: 16),

            // Disclaimer Banner
            const DisclaimerBanner(),
            const SizedBox(height: 20),

            // Expert helpline shortcut button
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExpertEscalationScreen()),
                );
              },
              icon: const Icon(Icons.support_agent, color: Color(0xFF2E7D32)),
              label: Text(
                context.tr('expertHelpline'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: Color(0xFF263238),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionShareCard(BuildContext context, DiseaseAnalysis a, String langCode) {
    final shareService = ShareService();
    final prescriptionText = shareService.formatDiseasePrescription(a, langCode);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF1B5E20), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('prescriptionSlip'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ready to share with local agro shop or farmer groups',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Primary WhatsApp Share Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                shareService.shareToWhatsApp(prescriptionText);
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
              label: Text(
                context.tr('shareToWhatsapp'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Copy Prescription Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await shareService.copyToClipboard(prescriptionText);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('prescriptionCopied')),
                      duration: const Duration(seconds: 2),
                      backgroundColor: const Color(0xFF1B5E20),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.copy_rounded, size: 17, color: Color(0xFF1B5E20)),
              label: Text(
                context.tr('copyPrescription'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20)),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                side: BorderSide(color: const Color(0xFF2E7D32).withOpacity(0.35)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
