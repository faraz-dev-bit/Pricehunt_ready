// lib/models/models.dart

class Product {
  final String id;
  final String name;
  final String emoji;
  final double price;
  final double? originalPrice;
  final int discount;
  final double? rating;
  final int reviews;
  final String platform;
  final String url;
  final String? imgUrl;
  final String delivery;
  final bool inStock;
  final bool isBest;

  Product({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.originalPrice,
    this.discount = 0,
    this.rating,
    this.reviews = 0,
    required this.platform,
    required this.url,
    this.imgUrl,
    this.delivery = 'Free delivery',
    this.inStock = true,
    this.isBest = false,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id:            j['asin'] ?? j['id'] ?? '',
    name:          j['title'] ?? j['name'] ?? '',
    emoji:         j['emoji'] ?? '📦',
    price:         (j['price'] ?? 0).toDouble(),
    originalPrice: j['original_price'] != null ? (j['original_price']).toDouble() : null,
    discount:      j['discount'] ?? 0,
    rating:        j['rating'] != null ? (j['rating']).toDouble() : null,
    reviews:       j['reviews'] ?? 0,
    platform:      j['platform'] ?? 'amazon',
    url:           j['url'] ?? '',
    imgUrl:        j['img_url'],
    delivery:      j['delivery'] ?? 'Free delivery',
    inStock:       j['in_stock'] ?? true,
    isBest:        j['is_best'] ?? false,
  );
}

class Deal {
  final String id;
  final String name;
  final String emoji;
  final String category;
  final double currentPrice;
  final double originalPrice;
  final int discount;
  final List<String> platforms;
  final String url;

  Deal({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
    required this.platforms,
    required this.url,
  });

  double get savings => originalPrice - currentPrice;

  factory Deal.fromJson(Map<String, dynamic> j) => Deal(
    id:           j['id'] ?? '',
    name:         j['name'] ?? '',
    emoji:        j['emoji'] ?? '📦',
    category:     j['category'] ?? '',
    currentPrice: (j['current_price'] ?? j['currentPrice'] ?? 0).toDouble(),
    originalPrice:(j['original_price'] ?? j['originalPrice'] ?? 0).toDouble(),
    discount:     j['discount'] ?? 0,
    platforms:    List<String>.from(j['platforms'] ?? ['amazon']),
    url:          j['url'] ?? '',
  );
}

class PriceAlert {
  final String id;
  final String productName;
  final String emoji;
  final double currentPrice;
  final double targetPrice;
  final bool dropped;

  PriceAlert({
    required this.id,
    required this.productName,
    required this.emoji,
    required this.currentPrice,
    required this.targetPrice,
    this.dropped = false,
  });
}

class CartItem {
  final String id;
  String name;
  int qty;
  double price;
  bool checked;

  CartItem({
    required this.id,
    required this.name,
    this.qty = 1,
    this.price = 0,
    this.checked = true,
  });
}

class Coupon {
  final String id;
  final String platform;
  final String name;
  final String code;
  final String value;
  final String emoji;
  final String expiry;
  bool copied;

  Coupon({
    required this.id,
    required this.platform,
    required this.name,
    required this.code,
    required this.value,
    required this.emoji,
    required this.expiry,
    this.copied = false,
  });
}
