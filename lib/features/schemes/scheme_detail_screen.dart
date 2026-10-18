import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/government_scheme.dart';
import '../../providers/scheme_provider.dart';
import '../../core/utils/url_launcher_helper.dart';
import '../../l10n/app_localizations.dart';

class SchemeDetailScreen extends StatelessWidget {
  final GovernmentScheme scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final schemeProv = Provider.of<SchemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(scheme.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Save Scheme',
            onPressed: () async {
              await schemeProv.saveScheme(scheme);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.tr('saveSuccess')), duration: const Duration(seconds: 2)),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Scheme',
            onPressed: () {
              Share.share(
                '${scheme.name}\n${scheme.shortDescription}\n\nOfficial Source: ${scheme.officialUrl}\n— Via Digital Krishi Officer',
                subject: scheme.name,
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
            // Header card
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      scheme.category,
                      style: const TextStyle(
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    scheme.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B381F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scheme.detailedDescription,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF37474F),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Benefits Section
            _buildListSection(
              title: context.tr('benefits'),
              items: scheme.benefits,
              icon: Icons.card_giftcard,
              color: Colors.green.shade800,
            ),
            const SizedBox(height: 14),

            // Eligibility Section
            _buildListSection(
              title: context.tr('eligibility'),
              items: scheme.eligibility,
              icon: Icons.check_circle_outline,
              color: Colors.blue.shade800,
            ),
            const SizedBox(height: 14),

            // Required Documents Section
            _buildListSection(
              title: context.tr('requiredDocuments'),
              items: scheme.requiredDocuments,
              icon: Icons.assignment_outlined,
              color: Colors.amber.shade900,
            ),
            const SizedBox(height: 14),

            // Application Process Section
            _buildNumberedSection(
              title: context.tr('applicationProcess'),
              steps: scheme.applicationProcess,
            ),
            const SizedBox(height: 16),

            // Official Source & Portal Link
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
                  Text(
                    context.tr('officialSource'),
                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scheme.officialSource,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1B381F)),
                  ),
                  const SizedBox(height: 10),
                  // Clickable Portal URL Box
                  InkWell(
                    onTap: () => UrlLauncherHelper.launchExternalUrl(context, scheme.officialUrl),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.language, color: Color(0xFF2E7D32), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              scheme.officialUrl,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1B5E20),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Icon(Icons.open_in_new, color: Color(0xFF2E7D32), size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => UrlLauncherHelper.launchExternalUrl(context, scheme.officialUrl),
                      icon: const Icon(Icons.launch, size: 16),
                      label: const Text(
                        'Open Official Government Portal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Verified: ${scheme.lastUpdated}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection({
    required String title,
    required List<String> items,
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
            (it) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      it,
                      style: const TextStyle(fontSize: 13, height: 1.35, color: Color(0xFF263238)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedSection({
    required String title,
    required List<String> steps,
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
          const Row(
            children: [
              Icon(Icons.format_list_numbered, color: Color(0xFF2E7D32), size: 20),
              SizedBox(width: 8),
              Text(
                'Application Procedure',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                step,
                style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF263238)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
