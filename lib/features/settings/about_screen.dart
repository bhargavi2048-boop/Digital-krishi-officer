import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: const Center(child: Text('🌾', style: TextStyle(fontSize: 48))),
            ),
            const SizedBox(height: 16),

            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B381F),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.appTagline,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Version 1.0.0 (Release Build)',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
            ),
            const SizedBox(height: 24),

            _buildInfoCard(
              title: 'Purpose & Mission',
              content: 'Digital Krishi Officer acts as an always-available personalized agricultural assistant for Indian farmers, bridging the gap between advanced artificial intelligence and practical grassroots farming needs. It provides instant disease diagnosis from leaf photos, personalized crop recommendations, local weather advisories, and official government scheme details.',
            ),
            const SizedBox(height: 14),

            _buildInfoCard(
              title: 'Technology Stack',
              content: '• Flutter & Dart (Material 3 Mobile Architecture)\n• Google Gemini API (Multimodal Vision & NLP)\n• Open-Meteo REST API (Meteorological Forecasts)\n• Local Device Storage (Zero-Backend Privacy Architecture)\n• Speech-To-Text & TTS (Multilingual Regional Voice Support)',
            ),
            const SizedBox(height: 14),

            _buildInfoCard(
              title: 'AI Responsibility & Disclaimer',
              content: 'AI-generated agricultural advice is designed for informational and decision-support purposes. It may not always reflect rapid localized pest epidemics. For critical crop disease outbreaks, restricted pesticide dosages, or major commercial financial decisions, always consult a qualified agricultural extension officer or local Krishi Vigyan Kendra.',
            ),
            const SizedBox(height: 28),

            Text(
              'Dedicated to Empowering Indian Farmers 🇮🇳🌾',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1B381F)),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.45, color: Color(0xFF37474F)),
          ),
        ],
      ),
    );
  }
}
