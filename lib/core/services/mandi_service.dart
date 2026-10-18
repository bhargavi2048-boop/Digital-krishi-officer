import 'package:intl/intl.dart';
import '../../models/mandi_price.dart';

class MandiService {
  static final MandiService _instance = MandiService._internal();
  factory MandiService() => _instance;
  MandiService._internal();

  String get _todayDate {
    return DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  List<MandiPrice> _getBaseMandiData() {
    final date = _todayDate;

    return [
      // Tamil Nadu Mandis
      MandiPrice(
        id: 'mp_1',
        commodity: 'Tomato (தக்காளி)',
        variety: 'Hybrid / Local Red',
        marketName: 'Koyambedu Wholesale Market',
        district: 'Chennai',
        state: 'Tamil Nadu',
        minPrice: 2200,
        maxPrice: 2800,
        modalPrice: 2500,
        priceDate: date,
        trend: PriceTrend.up,
        changeAmount: 150,
        category: 'vegetables',
        iconEmoji: '🍅',
      ),
      MandiPrice(
        id: 'mp_2',
        commodity: 'Paddy / Rice (நெல்)',
        variety: 'BPT 5204 (Samba Mahsuri)',
        marketName: 'Thanjavur Regulated Market',
        district: 'Thanjavur',
        state: 'Tamil Nadu',
        minPrice: 2183,
        maxPrice: 2450,
        modalPrice: 2320,
        priceDate: date,
        trend: PriceTrend.stable,
        changeAmount: 0,
        category: 'cereals',
        iconEmoji: '🌾',
      ),
      MandiPrice(
        id: 'mp_3',
        commodity: 'Onion (வெங்காயம்)',
        variety: 'Small Shallot / Bellary',
        marketName: 'Dindigul Central Market',
        district: 'Dindigul',
        state: 'Tamil Nadu',
        minPrice: 3200,
        maxPrice: 4100,
        modalPrice: 3700,
        priceDate: date,
        trend: PriceTrend.up,
        changeAmount: 200,
        category: 'vegetables',
        iconEmoji: '🧅',
      ),
      MandiPrice(
        id: 'mp_4',
        commodity: 'Cotton (பருத்தி)',
        variety: 'BT Medium Staple',
        marketName: 'Rajapalayam Cotton Market',
        district: 'Virudhunagar',
        state: 'Tamil Nadu',
        minPrice: 6800,
        maxPrice: 7500,
        modalPrice: 7120,
        priceDate: date,
        trend: PriceTrend.up,
        changeAmount: 180,
        category: 'cash_crops',
        iconEmoji: '☁️',
      ),
      MandiPrice(
        id: 'mp_5',
        commodity: 'Green Chilli (பச்சை மிளகாய்)',
        variety: 'G4 Hot Green',
        marketName: 'Madurai Mattuthavani Market',
        district: 'Madurai',
        state: 'Tamil Nadu',
        minPrice: 3800,
        maxPrice: 4600,
        modalPrice: 4200,
        priceDate: date,
        trend: PriceTrend.down,
        changeAmount: -120,
        category: 'vegetables',
        iconEmoji: '🌶️',
      ),
      MandiPrice(
        id: 'mp_6',
        commodity: 'Groundnut (நிலக்கடலை)',
        variety: 'TMV Pods with Shell',
        marketName: 'Tindivanam Regulated Market',
        district: 'Viluppuram',
        state: 'Tamil Nadu',
        minPrice: 5900,
        maxPrice: 6600,
        modalPrice: 6300,
        priceDate: date,
        trend: PriceTrend.up,
        changeAmount: 90,
        category: 'oilseeds',
        iconEmoji: '🥜',
      ),
      MandiPrice(
        id: 'mp_7',
        commodity: 'Banana (வாழைப்பழம்)',
        variety: 'Grand Naine / Poovan',
        marketName: 'Trichy Gandhi Market',
        district: 'Tiruchirappalli',
        state: 'Tamil Nadu',
        minPrice: 1600,
        maxPrice: 2200,
        modalPrice: 1900,
        priceDate: date,
        trend: PriceTrend.stable,
        changeAmount: 0,
        category: 'fruits',
        iconEmoji: '🍌',
      ),
      MandiPrice(
        id: 'mp_8',
        commodity: 'Turmeric (மஞ்சள்)',
        variety: 'Erode Finger Polished',
        marketName: 'Erode Turmeric Market',
        district: 'Erode',
        state: 'Tamil Nadu',
        minPrice: 12500,
        maxPrice: 14800,
        modalPrice: 13600,
        priceDate: date,
        trend: PriceTrend.up,
        changeAmount: 350,
        category: 'cash_crops',
        iconEmoji: '🌿',
      ),
      MandiPrice(
        id: 'mp_9',
        commodity: 'Potato (உருளைக்கிழங்கு)',
        variety: 'Jyoti / Kufri Special',
        marketName: 'Mettupalayam Agro Market',
        district: 'Coimbatore',
        state: 'Tamil Nadu',
        minPrice: 2100,
        maxPrice: 2700,
        modalPrice: 2400,
        priceDate: date,
        trend: PriceTrend.down,
        changeAmount: -60,
        category: 'vegetables',
        iconEmoji: '🥔',
      ),

      // Other Major National Mandis
      MandiPrice(
        id: 'mp_10',
        commodity: 'Wheat (गेहूं)',
        variety: 'Sharbati / Lokwan',
        marketName: 'Khanna Grain Market',
        district: 'Ludhiana',
        state: 'Punjab',
        minPrice: 2275,
        maxPrice: 2550,
        modalPrice: 2420,
        priceDate: date,
        trend: PriceTrend.stable,
        changeAmount: 0,
        category: 'cereals',
        iconEmoji: '🌾',
      ),
      MandiPrice(
        id: 'mp_11',
        commodity: 'Onion (लाल प्याज)',
        variety: 'Nashik Red Grade A',
        marketName: 'Lasalgaon APMC',
        district: 'Nashik',
        state: 'Maharashtra',
        minPrice: 2800,
        maxPrice: 3600,
        modalPrice: 3250,
        priceDate: date,
        trend: PriceTrend.down,
        changeAmount: -100,
        category: 'vegetables',
        iconEmoji: '🧅',
      ),
      MandiPrice(
        id: 'mp_12',
        commodity: 'Maize / Corn (मक्का)',
        variety: 'Yellow Feed Grain',
        marketName: 'Davangere APMC',
        district: 'Davangere',
        state: 'Karnataka',
        minPrice: 1950,
        maxPrice: 2300,
        modalPrice: 2140,
        priceDate: date,
        trend: PriceTrend.up,
        changeAmount: 50,
        category: 'cereals',
        iconEmoji: '🌽',
      ),
      MandiPrice(
        id: 'mp_13',
        commodity: 'Chilli (గుంటూరు మిర్చి)',
        variety: 'Teja S17 Stemless',
        marketName: 'Guntur Mirchi Yard',
        district: 'Guntur',
        state: 'Andhra Pradesh',
        minPrice: 16500,
        maxPrice: 19500,
        modalPrice: 18200,
        priceDate: date,
        trend: PriceTrend.up,
        changeAmount: 400,
        category: 'cash_crops',
        iconEmoji: '🌶️',
      ),
    ];
  }

  Future<List<MandiPrice>> fetchMandiPrices({
    String? district,
    String? state,
    String? category,
    String? query,
  }) async {
    // Simulate brief network latency for natural live refresh
    await Future.delayed(const Duration(milliseconds: 200));

    var list = _getBaseMandiData();

    // Prioritize farmer's district / state by sorting them first
    if (district != null && district.trim().isNotEmpty) {
      final cleanDistrict = district.trim().toLowerCase();
      list.sort((a, b) {
        final aMatch = a.district.toLowerCase() == cleanDistrict;
        final bMatch = b.district.toLowerCase() == cleanDistrict;
        if (aMatch && !bMatch) return -1;
        if (!aMatch && bMatch) return 1;
        return 0;
      });
    }

    // Filter by Category
    if (category != null && category.isNotEmpty && category != 'all') {
      list = list.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    // Filter by Search Query
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list.where((p) {
        return p.commodity.toLowerCase().contains(q) ||
            p.marketName.toLowerCase().contains(q) ||
            p.district.toLowerCase().contains(q) ||
            p.state.toLowerCase().contains(q) ||
            p.variety.toLowerCase().contains(q);
      }).toList();
    }

    return list;
  }
}
