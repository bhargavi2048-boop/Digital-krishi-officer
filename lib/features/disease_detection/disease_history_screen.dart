import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/disease_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state_view.dart';
import 'disease_result_screen.dart';

class DiseaseHistoryScreen extends StatelessWidget {
  const DiseaseHistoryScreen({super.key});

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final diseaseProv = Provider.of<DiseaseProvider>(context);
    final history = diseaseProv.history;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('diseaseHistory')),
      ),
      body: history.isEmpty
          ? const EmptyStateView(
              icon: Icons.biotech_outlined,
              title: 'No Diagnosis History',
              message: 'Your past crop disease analyses and treatment reports will be saved here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, idx) {
                final item = history[idx];
                return Card(
                  elevation: 0.5,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiseaseResultScreen(analysis: item),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.cropName,
                                  style: const TextStyle(
                                    color: Color(0xFF1B5E20),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _formatDate(item.date),
                                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                    onPressed: () {
                                      diseaseProv.deleteHistoryItem(item.id);
                                    },
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.only(left: 8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.possibleIssue,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B381F),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.observedSymptoms,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.3),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'AI Confidence: ${item.confidenceScore}%',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: item.confidenceScore >= 75 ? Colors.green.shade800 : Colors.orange.shade800,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    context.tr('viewDetails'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF2E7D32)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
