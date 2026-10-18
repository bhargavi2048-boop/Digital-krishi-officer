import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: const Text('Privacy & Security Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: Color(0xFF2E7D32), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your data stays on your phone. No tracking, no external database.',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: '1. Local Device Storage',
              body: 'All your farmer profile details, account credentials, crop portfolio records, diagnostic history, alerts and bookmarks are stored exclusively on your mobile device using local storage. This application operates entirely without a custom backend server, MongoDB, or Firebase.',
            ),
            const SizedBox(height: 16),

            _buildSection(
              title: '2. AI Query & Image Transmission',
              body: 'When you submit a text query, speak into the microphone, or upload a crop photo/video for disease diagnosis, that specific query along with your farm context (crop, soil type, and location) is sent securely over HTTPS to the Google Gemini API to formulate relevant agricultural guidance.',
            ),
            const SizedBox(height: 16),

            _buildSection(
              title: '3. Camera & Microphone Permissions',
              body: '• Camera: Used solely when you take live leaf or plant symptom photos for disease analysis.\n• Microphone: Used solely during voice search to convert spoken speech to text query.\n• Storage / Photos: Used to let you select existing crop pictures or short video clips from your gallery.',
            ),
            const SizedBox(height: 16),

            _buildSection(
              title: '4. Location Permission',
              body: 'Location coordinates or selected district names are queried against the Open-Meteo Weather service solely to retrieve current temperature, rain probability, and weather forecast to formulate agricultural advisories.',
            ),
            const SizedBox(height: 16),

            _buildSection(
              title: '5. API Key Security Disclosure',
              body: 'As per client-only mobile application architecture without a proxy backend, runtime API keys are loaded via .env file. For distributed production commercial releases, we recommend deploying an intermediate gateway service.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String body}) {
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
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B381F)),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(fontSize: 13, height: 1.45, color: Color(0xFF37474F)),
          ),
        ],
      ),
    );
  }
}
