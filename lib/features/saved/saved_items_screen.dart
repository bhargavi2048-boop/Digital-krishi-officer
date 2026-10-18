import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/saved_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state_view.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'All'},
    {'id': 'ai_advice', 'label': 'AI Advice'},
    {'id': 'crop_recommendation', 'label': 'Crops'},
    {'id': 'disease_report', 'label': 'Disease Reports'},
    {'id': 'scheme', 'label': 'Schemes'},
  ];

  @override
  Widget build(BuildContext context) {
    final savedProv = Provider.of<SavedProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('savedTitle')),
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _categories.length,
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = savedProv.selectedCategory == cat['id'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    onSelected: (_) => savedProv.setCategory(cat['id']!),
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF2E7D32).withOpacity(0.18),
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFF37474F),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Items List
          Expanded(
            child: savedProv.items.isEmpty
                ? EmptyStateView(
                    icon: Icons.bookmark_outline,
                    title: 'No Saved Bookmarks',
                    message: context.tr('noSavedItems'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: savedProv.items.length,
                    itemBuilder: (context, idx) {
                      final item = savedProv.items[idx];

                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                                      item.category.toUpperCase().replaceAll('_', ' '),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1B5E20),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
                                        onPressed: () {
                                          Share.share(
                                            '${item.title}\n\n${item.content}\n\n— Via Digital Krishi Officer',
                                            subject: item.title,
                                          );
                                        },
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.only(right: 8),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                        onPressed: () => savedProv.deleteItem(item.id),
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B381F),
                                ),
                              ),
                              if (item.subtitle.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle,
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                                ),
                              ],
                              const SizedBox(height: 10),
                              Text(
                                item.content,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5, color: Color(0xFF263238), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
