// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  // ✅ Railway pe deploy hone ke baad apna URL yahan daalo
  static const _base = 'https://YOUR-APP.up.railway.app/api';

  static Future<List<Deal>> getHotDeals() async {
    try {
      final res = await http.get(Uri.parse('$_base/deals/hot'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['deals'] as List).map((d) => Deal.fromJson(d)).toList();
      }
    } catch (_) {}
    return _mockDeals;
  }

  static Future<List<Product>> searchProducts(String query) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/search?q=${Uri.encodeComponent(query)}'),
      ).timeout(const Duration(seconds: 12));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['results'] as List).map((p) => Product.fromJson(p)).toList();
      }
    } catch (_) {}
    return _mockSearch(query);
  }

  static Future<List<Product>> compareProducts(String query) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/compare?q=${Uri.encodeComponent(query)}'),
      ).timeout(const Duration(seconds: 12));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['stores'] as List).map((p) => Product.fromJson(p)).toList();
      }
    } catch (_) {}
    return _mockCompare(query);
  }

  // ── Mock Data (works without backend) ─────────────────────────
  static final _mockDeals = [
    Deal(id:'1', name:'Samsung Galaxy A55 5G', emoji:'📱', category:'Mobile',
        currentPrice:28999, originalPrice:38999, discount:26, platforms:['amazon','flipkart'], url:''),
    Deal(id:'2', name:'boAt Airdopes 441 TWS', emoji:'🎧', category:'Audio',
        currentPrice:1299, originalPrice:3499, discount:63, platforms:['amazon'], url:''),
    Deal(id:'3', name:'Nike Air Max 270', emoji:'👟', category:'Fashion',
        currentPrice:5499, originalPrice:9995, discount:45, platforms:['flipkart'], url:''),
    Deal(id:'4', name:'Apple Watch SE 2nd Gen', emoji:'⌚', category:'Wearables',
        currentPrice:24900, originalPrice:29900, discount:17, platforms:['amazon','flipkart'], url:''),
    Deal(id:'5', name:'Sony 55" 4K Smart TV', emoji:'📺', category:'TV',
        currentPrice:42990, originalPrice:68990, discount:38, platforms:['amazon'], url:''),
  ];

  static List<Product> _mockSearch(String q) => [
    Product(id:'s1', name:'$q - Top Result', emoji:'📦', price:15999,
        originalPrice:22000, discount:27, platform:'amazon', url:'https://amazon.in'),
    Product(id:'s2', name:'$q - Budget Pick', emoji:'💡', price:12499,
        originalPrice:16999, discount:26, platform:'flipkart', url:'https://flipkart.com'),
    Product(id:'s3', name:'$q - Premium', emoji:'⭐', price:24999,
        originalPrice:32000, discount:22, platform:'meesho', url:'https://meesho.com'),
  ];

  static List<Product> _mockCompare(String q) => [
    Product(id:'c1', name:'$q 128GB', emoji:'📱', price:28999, originalPrice:38999,
        discount:26, platform:'amazon', url:'https://amazon.in',
        delivery:'Free • 2 days', isBest:true, rating:4.3, reviews:12847),
    Product(id:'c2', name:'$q 128GB', emoji:'📱', price:30499, originalPrice:38999,
        discount:22, platform:'flipkart', url:'https://flipkart.com',
        delivery:'Free • 3 days', isBest:false),
    Product(id:'c3', name:'$q 128GB', emoji:'📱', price:31200, originalPrice:38999,
        discount:20, platform:'meesho', url:'https://meesho.com',
        delivery:'₹49 • 5 days', isBest:false),
  ];

  static final mockCoupons = [
    Coupon(id:'c1', platform:'amazon',   name:'Amazon Pay',         code:'AMZPAY10', value:'10%',  emoji:'🟠', expiry:'31 Mar'),
    Coupon(id:'c2', platform:'hdfc',     name:'HDFC Credit Card',   code:'HDFC5OFF', value:'5%',   emoji:'💳', expiry:'30 Apr'),
    Coupon(id:'c3', platform:'flipkart', name:'Flipkart SuperCoins', code:'FLIPSC200',value:'₹200', emoji:'🔵', expiry:'15 Apr'),
    Coupon(id:'c4', platform:'paytm',    name:'Paytm Cashback',     code:'PAY50',    value:'₹50',  emoji:'💙', expiry:'28 Mar'),
  ];
}
