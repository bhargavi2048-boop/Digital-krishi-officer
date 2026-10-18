import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mandi_price.dart';
import '../../providers/mandi_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../core/services/share_service.dart';
import '../../l10n/app_localizations.dart';

class MandiPricesScreen extends StatefulWidget {
  const MandiPricesScreen({super.key});

  @override
  State<MandiPricesScreen> createState() => _MandiPricesScreenState();
}

class _MandiPricesScreenState extends State<MandiPricesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'All Crops', 'icon': '🌾'},
    {'id': 'vegetables', 'label': 'Vegetables', 'icon': '🍅'},
    {'id': 'cereals', 'label': 'Cereals & Grains', 'icon': '🌾'},
    {'id': 'cash_crops', 'label': 'Cash Crops', 'icon': '☁️'},
    {'id': 'oilseeds', 'label': 'Oilseeds', 'icon': '🥜'},
    {'id': 'fruits', 'label': 'Fruits', 'icon': '🍌'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final mandi = Provider.of<MandiProvider>(context, listen: false);
      mandi.loadPrices(
        district: auth.currentUser?.district,
        state: auth.currentUser?.state,
      );
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mandi = Provider.of<MandiProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final farmerDistrict = auth.currentUser?.district ?? 'Tamil Nadu';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(
          context.tr('mandiTitle'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Market Rates',
            onPressed: () => mandi.loadPrices(
              district: auth.currentUser?.district,
              state: auth.currentUser?.state,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => mandi.loadPrices(
          district: auth.currentUser?.district,
          state: auth.currentUser?.state,
        ),
        color: const Color(0xFF2E7D32),
        child: Column(
          children: [
            // Header Location Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFFE8F5E9),
              child: Row(
                children: [
                  const Icon(Icons.storefront_rounded, size: 18, color: Color(0xFF1B5E20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Live APMC Mandi Rates • $farmerDistrict & Regional Markets',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B5E20),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'e-NAM',
                      style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => mandi.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: context.tr('searchMandiHint'),
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF2E7D32)),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            mandi.setSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                  ),
                ),
              ),
            ),

            // Category Filter Chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _categories.length,
                itemBuilder: (ctx, idx) {
                  final cat = _categories[idx];
                  final isSelected = mandi.selectedCategory == cat['id'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    child: ChoiceChip(
                      label: Text('${cat['icon']} ${cat['label']}'),
                      selected: isSelected,
                      onSelected: (_) => mandi.setCategory(cat['id']!),
                      selectedColor: const Color(0xFF2E7D32),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                        ),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 6),

            // Prices List View
            Expanded(
              child: mandi.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                  : mandi.prices.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 10),
                              Text(
                                context.tr('noMandiRecords'),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                          itemCount: mandi.prices.length,
                          itemBuilder: (ctx, idx) {
                            final p = mandi.prices[idx];
                            return _buildPriceCard(context, p);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(BuildContext context, MandiPrice p) {
    Color trendColor;
    IconData trendIcon;
    String trendText;

    switch (p.trend) {
      case PriceTrend.up:
        trendColor = const Color(0xFF2E7D32);
        trendIcon = Icons.trending_up_rounded;
        trendText = '+₹${p.changeAmount.toInt()} today';
        break;
      case PriceTrend.down:
        trendColor = const Color(0xFFC62828);
        trendIcon = Icons.trending_down_rounded;
        trendText = '-₹${p.changeAmount.abs().toInt()} today';
        break;
      case PriceTrend.stable:
        trendColor = Colors.grey.shade600;
        trendIcon = Icons.trending_flat_rounded;
        trendText = 'Stable';
        break;
    }

    return Card(
      elevation: 0.8,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Commodity, Variety, and Trend Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(p.iconEmoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.commodity,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B381F),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        p.variety,
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(trendIcon, size: 14, color: trendColor),
                      const SizedBox(width: 4),
                      Text(
                        trendText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Middle: Prices Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Modal Market Price',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${p.modalPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '/ Qtl',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '≈ ₹${p.pricePerKg.toStringAsFixed(1)} / kg',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Bottom: Range & Mandi Location
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FBF9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 13, color: Colors.grey.shade700),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${p.marketName}, ${p.district}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Range: ₹${p.minPrice.toInt()} - ₹${p.maxPrice.toInt()}',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Share Mandi Price via WhatsApp / Groups
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    final lang = Provider.of<LanguageProvider>(context, listen: false);
                    final shareService = ShareService();
                    final text = shareService.formatMandiPriceShare(p, lang.currentLanguageCode);
                    shareService.shareToWhatsApp(text);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF25D366).withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Color(0xFF1B5E20)),
                        const SizedBox(width: 5),
                        Text(
                          context.tr('shareMandiRate'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
