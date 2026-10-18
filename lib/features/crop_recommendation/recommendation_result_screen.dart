import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/crop_recommendation.dart';
import '../../providers/crop_provider.dart';
import '../../l10n/app_localizations.dart';

class RecommendationResultScreen extends StatelessWidget {
  final List<CropRecommendation> recommendations;
  final String season;
  final String soilType;

  const RecommendationResultScreen({
    super.key,
    required this.recommendations,
    required this.season,
    required this.soilType,
  });

  @override
  Widget build(BuildContext context) {
    final cropProv = Provider.of<CropProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('recCropsTitle')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header summary chip
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI selected ${recommendations.length} high-potential crops for $soilType in $season.',
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF1B5E20), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recommendations List
            ...recommendations.map((rec) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rec.cropName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B381F),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  rec.variety,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.bookmark_outline, size: 20, color: Color(0xFF2E7D32)),
                                tooltip: 'Save',
                                onPressed: () async {
                                  await cropProv.saveRecommendation(rec);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(context.tr('saveSuccess')),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                                tooltip: 'Share',
                                onPressed: () {
                                  Share.share(
                                    'Recommended Crop: ${rec.cropName} (${rec.variety})\nDuration: ${rec.expectedDuration}\nTips: ${rec.basicCultivationTips}\n\n— Via Digital Krishi Officer',
                                    subject: 'Crop Recommendation',
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      _buildInfoRow(
                        Icons.thumb_up_alt_outlined,
                        context.tr('whyRecommended'),
                        rec.whyRecommended,
                        Colors.green.shade800,
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoRow(
                              Icons.schedule,
                              context.tr('expectedDuration'),
                              rec.expectedDuration,
                              Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInfoRow(
                              Icons.water_drop_outlined,
                              context.tr('waterRequirement'),
                              rec.waterRequirement,
                              Colors.teal.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      _buildInfoRow(
                        Icons.psychology_outlined,
                        context.tr('cultivationTips'),
                        rec.basicCultivationTips,
                        Colors.brown.shade800,
                      ),
                      const SizedBox(height: 10),

                      _buildInfoRow(
                        Icons.trending_up,
                        context.tr('economicProspects'),
                        rec.economicProspects,
                        Colors.amber.shade900,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 21),
          child: Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.35, color: Color(0xFF263238)),
          ),
        ),
      ],
    );
  }
}
