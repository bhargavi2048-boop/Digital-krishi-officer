enum PriceTrend { up, down, stable }

class MandiPrice {
  final String id;
  final String commodity;
  final String variety;
  final String marketName;
  final String district;
  final String state;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final String priceDate;
  final PriceTrend trend;
  final double changeAmount;
  final String category; // 'vegetables', 'cereals', 'cash_crops', 'oilseeds', 'fruits'
  final String iconEmoji;

  const MandiPrice({
    required this.id,
    required this.commodity,
    required this.variety,
    required this.marketName,
    required this.district,
    required this.state,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.priceDate,
    required this.trend,
    required this.changeAmount,
    required this.category,
    required this.iconEmoji,
  });

  double get pricePerKg => modalPrice / 100.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commodity': commodity,
      'variety': variety,
      'marketName': marketName,
      'district': district,
      'state': state,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'modalPrice': modalPrice,
      'priceDate': priceDate,
      'trend': trend.name,
      'changeAmount': changeAmount,
      'category': category,
      'iconEmoji': iconEmoji,
    };
  }

  factory MandiPrice.fromJson(Map<String, dynamic> json) {
    return MandiPrice(
      id: json['id'] as String? ?? '',
      commodity: json['commodity'] as String? ?? '',
      variety: json['variety'] as String? ?? '',
      marketName: json['marketName'] as String? ?? '',
      district: json['district'] as String? ?? '',
      state: json['state'] as String? ?? '',
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 0.0,
      modalPrice: (json['modalPrice'] as num?)?.toDouble() ?? 0.0,
      priceDate: json['priceDate'] as String? ?? '',
      trend: PriceTrend.values.firstWhere(
        (e) => e.name == json['trend'],
        orElse: () => PriceTrend.stable,
      ),
      changeAmount: (json['changeAmount'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? 'vegetables',
      iconEmoji: json['iconEmoji'] as String? ?? '🌾',
    );
  }
}
