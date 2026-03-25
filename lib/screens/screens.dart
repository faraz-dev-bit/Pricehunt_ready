// lib/screens/screens.dart
// All 5 screens: Home, Compare, Alerts, Cart, Cashback, Battle

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';

// ══════════════════════════════════════════════════════════════════
// HOME SCREEN
// ══════════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  String _activeCategory = 'all';
  List<Deal> _deals = [];
  bool _loading = true;

  final _categories = [
    {'id': 'all',      'label': '🔥 Hot Deals'},
    {'id': 'mobile',   'label': '📱 Mobile'},
    {'id': 'audio',    'label': '🎧 Audio'},
    {'id': 'fashion',  'label': '👟 Fashion'},
    {'id': 'laptop',   'label': '💻 Laptop'},
    {'id': 'wearables','label': '⌚ Watches'},
    {'id': 'tv',       'label': '📺 TV'},
  ];

  @override
  void initState() {
    super.initState();
    _loadDeals();
  }

  Future<void> _loadDeals() async {
    final deals = await ApiService.getHotDeals();
    if (mounted) setState(() { _deals = deals; _loading = false; });
  }

  void _search() {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => CompareScreen(query: q)));
    _searchCtrl.clear();
  }

  List<Deal> get _filtered => _activeCategory == 'all'
      ? _deals
      : _deals.where((d) => d.category.toLowerCase() == _activeCategory).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: RefreshIndicator(
        onRefresh: _loadDeals,
        color: AppColors.primary,
        child: CustomScrollView(slivers: [
          // Header
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16,12,16,16),
            child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                const Text('Good morning 👋', style: TextStyle(fontSize:12, color:AppColors.textMuted)),
                const SizedBox(height:4),
                RichText(text: const TextSpan(style: TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:AppColors.textPrimary), children: [
                  TextSpan(text:'Find the '),
                  TextSpan(text:'cheapest\n', style: TextStyle(color:AppColors.primary)),
                  TextSpan(text:'price today'),
                ])),
              ]),
              Container(
                width:40, height:40,
                decoration: BoxDecoration(color:AppColors.card, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.border)),
                child: const Icon(Icons.notifications_outlined, color:AppColors.textSecondary, size:20),
              ),
            ]),
          )),

          // Search Bar
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16,0,16,12),
            child: Container(
              decoration: BoxDecoration(color:AppColors.card, borderRadius:BorderRadius.circular(16), border:Border.all(color:AppColors.border)),
              child: Row(children: [
                const Padding(padding:EdgeInsets.all(12), child:Icon(Icons.search, color:AppColors.textMuted, size:20)),
                Expanded(child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(fontSize:14, color:AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Search any product...',
                    hintStyle: TextStyle(color:AppColors.textMuted),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical:12),
                  ),
                  onSubmitted: (_) => _search(),
                  textInputAction: TextInputAction.search,
                )),
                GestureDetector(
                  onTap: _search,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width:32, height:32,
                    decoration: BoxDecoration(color:AppColors.primaryGlow, borderRadius:BorderRadius.circular(20)),
                    child: const Icon(Icons.arrow_forward, color:AppColors.primary, size:16),
                  ),
                ),
              ]),
            ),
          )),

          // Stats Row
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16,0,16,12),
            child: Row(children: [
              _statCard('3', 'Platforms'),
              const SizedBox(width:8),
              _statCard('₹2.8K', 'Avg Saving'),
              const SizedBox(width:8),
              _statCard('10K+', 'Products'),
            ]),
          )),

          // Category Chips
          SliverToBoxAdapter(child: SizedBox(
            height:40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal:16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width:8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final active = _activeCategory == cat['id'];
                return GestureDetector(
                  onTap: () => setState(() => _activeCategory = cat['id']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal:14, vertical:8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(cat['label']!, style: TextStyle(fontSize:11, fontWeight:FontWeight.w600,
                        color: active ? Colors.white : AppColors.textSecondary)),
                  ),
                );
              },
            ),
          )),
          const SliverToBoxAdapter(child: SizedBox(height:16)),

          // Section Header
          const SliverToBoxAdapter(child: SectionHeader(title: "Today's Best Deals", action: "See all")),

          // Deals
          _loading
            ? const SliverToBoxAdapter(child: Center(child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: AppColors.primary),
              )))
            : _filtered.isEmpty
              ? const SliverToBoxAdapter(child: EmptyState(emoji:'😕', title:'No deals', subtitle:'Try another category'))
              : SliverList(delegate: SliverChildBuilderDelegate(
                  (_, i) => DealCard(deal:_filtered[i], onTap:() =>
                    Navigator.push(context, MaterialPageRoute(builder:(_) => CompareScreen(query:_filtered[i].name)))),
                  childCount: _filtered.length,
                )),
          const SliverToBoxAdapter(child: SizedBox(height:20)),
        ]),
      )),
    );
  }

  Widget _statCard(String val, String label) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical:10),
    decoration: BoxDecoration(color:AppColors.card, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.border)),
    child: Column(children: [
      Text(val, style: const TextStyle(fontSize:16, fontWeight:FontWeight.w800, color:AppColors.primary)),
      Text(label, style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
    ]),
  ));
}

// ══════════════════════════════════════════════════════════════════
// COMPARE SCREEN
// ══════════════════════════════════════════════════════════════════
class CompareScreen extends StatefulWidget {
  final String query;
  const CompareScreen({super.key, required this.query});
  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  List<Product> _stores = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await ApiService.compareProducts(widget.query);
    if (mounted) setState(() { _stores = results; _loading = false; });
  }

  double get _bestPrice => _stores.isEmpty ? 0 : _stores.map((s) => s.price).reduce((a,b) => a < b ? a : b);
  String get _bestPlatform => _stores.isEmpty ? '' : _stores.firstWhere((s) => s.price == _bestPrice, orElse: () => _stores.first).platform;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: Column(children: [
        // Header
        Padding(padding: const EdgeInsets.fromLTRB(16,12,16,0),
          child: Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context),
              child: Container(width:36, height:36,
                decoration: BoxDecoration(color:AppColors.card, borderRadius:BorderRadius.circular(10), border:Border.all(color:AppColors.border)),
                child: const Icon(Icons.arrow_back, color:AppColors.textPrimary, size:18))),
            const SizedBox(width:10),
            const Expanded(child: Text('Price Compare', textAlign:TextAlign.center,
              style: TextStyle(fontSize:16, fontWeight:FontWeight.w700, color:AppColors.textPrimary))),
            const SizedBox(width:36),
          ]),
        ),

        Expanded(child: _loading
          ? const Center(child: Column(mainAxisAlignment:MainAxisAlignment.center, children: [
              CircularProgressIndicator(color:AppColors.primary),
              SizedBox(height:12),
              Text('Comparing prices...', style:TextStyle(color:AppColors.textMuted)),
            ]))
          : ListView(padding: const EdgeInsets.all(16), children: [
              // Product Hero
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.infoGlow),
                ),
                child: Row(children: [
                  Container(width:84, height:84,
                    decoration: BoxDecoration(color:Colors.white.withOpacity(0.05), borderRadius:BorderRadius.circular(16)),
                    child: const Center(child: Text('📱', style: TextStyle(fontSize:44)))),
                  const SizedBox(width:14),
                  Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                    Text(widget.query, maxLines:2, overflow:TextOverflow.ellipsis,
                      style: const TextStyle(fontSize:13, fontWeight:FontWeight.w600, color:AppColors.textPrimary)),
                    const SizedBox(height:4),
                    const Text('⭐ 4.3 · 12,847 reviews', style: TextStyle(fontSize:11, color:Color(0xFFFFB347))),
                    const SizedBox(height:4),
                    const Text('Best Price', style: TextStyle(fontSize:11, color:AppColors.textMuted)),
                    Text('₹${_bestPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: const TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:AppColors.success)),
                  ])),
                ]),
              ),
              const SizedBox(height:16),

              // Alert CTA
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                    Text('💡 Wait for a better price?', style: TextStyle(fontSize:13, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
                    Text('Set an alert — get notified when price drops', style: TextStyle(fontSize:11, color:AppColors.textMuted)),
                  ])),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Alert set! We\'ll notify you when price drops.'), backgroundColor: AppColors.primary)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal:12, vertical:8),
                      decoration: BoxDecoration(color:AppColors.primary, borderRadius:BorderRadius.circular(10)),
                      child: const Row(children: [
                        Icon(Icons.notifications_outlined, color:Colors.white, size:14),
                        SizedBox(width:4),
                        Text('Alert Me', style: TextStyle(fontSize:11, fontWeight:FontWeight.w700, color:Colors.white)),
                      ]),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height:16),

              const Text('3 Stores', style: TextStyle(fontSize:14, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
              const SizedBox(height:10),
              ..._stores.map((s) => StoreRow(store:s, onTap:() async {
                if (s.url.isNotEmpty) await launchUrl(Uri.parse(s.url));
              })),
            ]),
        ),

        // Buy Button
        if (!_loading && _stores.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color:AppColors.surface, border:Border(top:BorderSide(color:AppColors.border))),
            child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                Text('₹${_bestPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize:20, fontWeight:FontWeight.w800, color:AppColors.success)),
                Text('Best on $_bestPlatform', style: const TextStyle(fontSize:11, color:AppColors.textMuted)),
              ]),
              GestureDetector(
                onTap: () async {
                  final best = _stores.firstWhere((s) => s.price == _bestPrice);
                  if (best.url.isNotEmpty) await launchUrl(Uri.parse(best.url));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal:24, vertical:14),
                  decoration: BoxDecoration(color:AppColors.primary, borderRadius:BorderRadius.circular(14)),
                  child: const Text('Buy Now →', style: TextStyle(fontSize:14, fontWeight:FontWeight.w800, color:Colors.white)),
                ),
              ),
            ]),
          ),
      ])),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// ALERTS SCREEN
// ══════════════════════════════════════════════════════════════════
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _alerts = [
    PriceAlert(id:'1', productName:'MacBook Air M2', emoji:'💻', currentPrice:83990, targetPrice:85000, dropped:true),
    PriceAlert(id:'2', productName:'Sony 55" 4K TV', emoji:'📺', currentPrice:52999, targetPrice:45000, dropped:false),
    PriceAlert(id:'3', productName:'PS5 Controller', emoji:'🎮', currentPrice:4299, targetPrice:4500, dropped:true),
    PriceAlert(id:'4', productName:'Apple Watch SE', emoji:'⌚', currentPrice:28900, targetPrice:25000, dropped:false),
  ];

  @override
  Widget build(BuildContext context) {
    final dropped  = _alerts.where((a) => a.dropped).toList();
    final watching = _alerts.where((a) => !a.dropped).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
        const SizedBox(height:8),
        const Text('Deal Alerts 🔔', style: TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:AppColors.textPrimary)),
        const Text('Get notified when prices drop', style: TextStyle(fontSize:13, color:AppColors.textMuted)),
        const SizedBox(height:16),

        if (dropped.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGlow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              const Text('📉', style: TextStyle(fontSize:28)),
              const SizedBox(height:6),
              Text('${dropped.length} Price${dropped.length > 1 ? 's' : ''} Dropped!',
                style: const TextStyle(fontSize:18, fontWeight:FontWeight.w800, color:AppColors.textPrimary)),
              const Text('Check them out — prices may go back up!',
                style: TextStyle(fontSize:12, color:AppColors.textMuted)),
            ]),
          ),
          const SizedBox(height:16),
          const SectionHeader(title: 'Price Dropped ✅'),
          ...dropped.map((a) => AlertItemCard(alert:a, onRemove:(){})),
          const SizedBox(height:8),
        ],

        const SectionHeader(title: 'Watching 👀'),
        ...watching.map((a) => AlertItemCard(alert:a, onRemove:(){})),

        const SizedBox(height:20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: const Column(children: [
            Text('🔔 How to set an alert?', style: TextStyle(fontSize:13, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
            SizedBox(height:4),
            Text('Search any product → Tap "Alert Me" button → Done!\nWe\'ll notify you the moment price drops.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize:12, color:AppColors.textMuted, height:1.6)),
          ]),
        ),
      ])),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// CART SCREEN
// ══════════════════════════════════════════════════════════════════
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _addCtrl = TextEditingController();
  String _selectedStore = 'amazon';
  final _items = [
    CartItem(id:'1', name:'Amul Butter 500g',    qty:2, price:59,  checked:true),
    CartItem(id:'2', name:'Tata Salt 1kg',         qty:3, price:21,  checked:true),
    CartItem(id:'3', name:'Basmati Rice 5kg',      qty:1, price:449, checked:false),
    CartItem(id:'4', name:'Surf Excel 2kg',        qty:1, price:289, checked:true),
    CartItem(id:'5', name:'Aashirvaad Atta 10kg',  qty:1, price:398, checked:false),
  ];

  final _stores = [
    {'id':'amazon',   'label':'Amazon',   'emoji':'🟠'},
    {'id':'flipkart', 'label':'Flipkart', 'emoji':'🔵'},
    {'id':'blinkit',  'label':'Blinkit',  'emoji':'🟡'},
  ];

  double get _subtotal => _items.where((i) => i.checked).fold(0, (sum, i) => sum + i.price * i.qty);
  double get _aiSaving => 234;
  double get _total    => _subtotal - _aiSaving;

  void _addItem() {
    final name = _addCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _items.add(CartItem(id: DateTime.now().toString(), name: name)));
    _addCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16,12,16,8), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
          const Text('Smart Cart 🛒', style: TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:AppColors.textPrimary)),
          const Text('AI finds cheapest store for your list', style: TextStyle(fontSize:13, color:AppColors.textMuted)),
          const SizedBox(height:12),
          // Store tabs
          Row(children: _stores.map((s) {
            final active = _selectedStore == s['id'];
            return Expanded(child: GestureDetector(
              onTap: () => setState(() => _selectedStore = s['id']!),
              child: Container(
                margin: EdgeInsets.only(right: s['id'] == 'blinkit' ? 0 : 8),
                padding: const EdgeInsets.symmetric(vertical:8),
                decoration: BoxDecoration(
                  color: active ? AppColors.primaryGlow : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: active ? AppColors.primary : AppColors.border),
                ),
                child: Column(children: [
                  Text(s['emoji']!, style: const TextStyle(fontSize:18)),
                  const SizedBox(height:2),
                  Text(s['label']!, style: TextStyle(fontSize:10, fontWeight:FontWeight.w600,
                      color: active ? AppColors.primary : AppColors.textMuted)),
                ]),
              ),
            ));
          }).toList()),
        ])),

        // Add Item
        Padding(padding: const EdgeInsets.fromLTRB(16,0,16,8),
          child: Row(children: [
            Expanded(child: Container(
              decoration: BoxDecoration(color:AppColors.card, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.border)),
              child: TextField(controller:_addCtrl,
                style: const TextStyle(fontSize:13, color:AppColors.textPrimary),
                decoration: const InputDecoration(hintText:'Add item...', hintStyle:TextStyle(color:AppColors.textMuted),
                  border:InputBorder.none, contentPadding:EdgeInsets.symmetric(horizontal:12, vertical:10)),
                onSubmitted: (_) => _addItem()),
            )),
            const SizedBox(width:8),
            GestureDetector(onTap: _addItem,
              child: Container(width:44, height:44,
                decoration: BoxDecoration(color:AppColors.primary, borderRadius:BorderRadius.circular(12)),
                child: const Icon(Icons.add, color:Colors.white))),
          ])),

        Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal:16), children: [
          Text('Items (${_items.length})', style: const TextStyle(fontSize:13, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
          const SizedBox(height:8),
          ..._items.map((item) => CartItemCard(item:item,
            onToggle: () => setState(() => item.checked = !item.checked),
            onRemove: () => setState(() => _items.remove(item)))),

          if (_items.any((i) => i.checked)) ...[
            const SizedBox(height:8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryGlow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.25)),
              ),
              child: Column(children: [
                _summaryRow('Subtotal', '₹${_subtotal.toStringAsFixed(0)}'),
                _summaryRow('Delivery', 'FREE', green:true),
                _summaryRow('🤖 AI Saving', '-₹${_aiSaving.toStringAsFixed(0)}', green:true),
                const Divider(color:AppColors.border, height:16),
                _summaryRow('Total', '₹${_total.toStringAsFixed(0)}', bold:true, green:true),
              ]),
            ),
          ],
          const SizedBox(height:20),
        ])),
      ])),
    );
  }

  Widget _summaryRow(String label, String val, {bool green=false, bool bold=false}) =>
    Padding(padding: const EdgeInsets.only(bottom:4),
      child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: bold?14:12, fontWeight: bold?FontWeight.w800:FontWeight.w400, color:AppColors.textSecondary)),
        Text(val,   style: TextStyle(fontSize: bold?14:12, fontWeight: bold?FontWeight.w800:FontWeight.w600,
            color: green ? AppColors.success : AppColors.textPrimary)),
      ]));
}

// ══════════════════════════════════════════════════════════════════
// CASHBACK SCREEN
// ══════════════════════════════════════════════════════════════════
class CashbackScreen extends StatefulWidget {
  const CashbackScreen({super.key});
  @override
  State<CashbackScreen> createState() => _CashbackScreenState();
}

class _CashbackScreenState extends State<CashbackScreen> {
  final _coupons = ApiService.mockCoupons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
        const SizedBox(height:8),
        const Text('Cashback Radar 💰', style: TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:AppColors.textPrimary)),
        const Text('Best coupons auto-detected', style: TextStyle(fontSize:13, color:AppColors.textMuted)),
        const SizedBox(height:16),

        // Earnings Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0A2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.purple.withOpacity(0.3)),
          ),
          child: Column(children: [
            const Text('₹2,847', style: TextStyle(fontSize:40, fontWeight:FontWeight.w800, color:AppColors.purple)),
            const Text('Total cashback earned this month', style: TextStyle(fontSize:11, color:AppColors.textMuted)),
            const SizedBox(height:14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.68,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: const AlwaysStoppedAnimation(AppColors.purple),
                minHeight: 8,
              ),
            ),
            const SizedBox(height:6),
            const Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
              Text('₹0', style: TextStyle(fontSize:10, color:AppColors.textMuted)),
              Text('₹4,200 target', style: TextStyle(fontSize:10, color:AppColors.textMuted)),
            ]),
          ]),
        ),
        const SizedBox(height:16),

        // Stats
        Row(children: [
          _statBox('12', 'Coupons Used'),
          const SizedBox(width:8),
          _statBox('₹450', 'Best Save'),
          const SizedBox(width:8),
          _statBox('${_coupons.length}', 'Active'),
        ]),
        const SizedBox(height:16),

        const SectionHeader(title: 'Active Coupons'),
        ..._coupons.map((c) => CouponCard(coupon:c, onCopy:() {
          Clipboard.setData(ClipboardData(text: c.code));
          setState(() => c.copied = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ ${c.code} copied!'), backgroundColor: AppColors.primary));
        })),
        const SizedBox(height:12),

        // Tip
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.infoGlow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.info.withOpacity(0.3)),
          ),
          child: const Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Text('💡 Pro Tip', style: TextStyle(fontSize:13, fontWeight:FontWeight.w700, color:AppColors.info)),
            SizedBox(height:4),
            Text('Stack Amazon Pay + HDFC Credit Card coupon for up to 15% off on a single order!',
              style: TextStyle(fontSize:12, color:AppColors.textSecondary, height:1.6)),
          ]),
        ),
      ])),
    );
  }

  Widget _statBox(String val, String label) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical:12),
    decoration: BoxDecoration(color:AppColors.card, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.border)),
    child: Column(children: [
      Text(val, style: const TextStyle(fontSize:16, fontWeight:FontWeight.w800, color:AppColors.purple)),
      const SizedBox(height:2),
      Text(label, style: const TextStyle(fontSize:9, color:AppColors.textMuted), textAlign:TextAlign.center),
    ]),
  ));
}

// ══════════════════════════════════════════════════════════════════
// BRAND BATTLE SCREEN
// ══════════════════════════════════════════════════════════════════
class BrandBattleScreen extends StatelessWidget {
  const BrandBattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prodA = {'name':'iPhone 15 128GB', 'emoji':'📱', 'price':69999.0, 'rating':4.4, 'camera':80, 'battery':45, 'wins':true};
    final prodB = {'name':'Samsung S24 128GB','emoji':'📱', 'price':74999.0, 'rating':4.2, 'camera':85, 'battery':60, 'wins':false};

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
        const SizedBox(height:8),
        const Center(child: Text('⚔️ Brand Battle', style: TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:AppColors.textPrimary))),
        const Center(child: Text('Full side-by-side comparison', style: TextStyle(fontSize:13, color:AppColors.textMuted))),
        const SizedBox(height:20),

        // VS Row
        Row(crossAxisAlignment:CrossAxisAlignment.center, children: [
          _prodCard(prodA),
          Padding(padding: const EdgeInsets.symmetric(horizontal:8),
            child: Container(
              width:36, height:36,
              decoration: BoxDecoration(color:AppColors.primaryGlow, shape:BoxShape.circle),
              child: const Center(child: Text('VS', style: TextStyle(fontSize:12, fontWeight:FontWeight.w800, color:AppColors.primary))),
            )),
          _prodCard(prodB),
        ]),
        const SizedBox(height:16),

        // Verdict
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.successGlow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Row(children: [
            const Text('✅', style: TextStyle(fontSize:20)),
            const SizedBox(width:10),
            Expanded(child: RichText(text: TextSpan(style: const TextStyle(fontSize:12, color:AppColors.textSecondary, height:1.5), children: [
              const TextSpan(text:'iPhone 15', style: TextStyle(color:AppColors.success, fontWeight:FontWeight.w800)),
              const TextSpan(text:' is ₹5,000 cheaper and has better overall value'),
            ]))),
          ]),
        ),
        const SizedBox(height:16),

        const Text('📊 Spec Battle', style: TextStyle(fontSize:14, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
        const SizedBox(height:10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color:AppColors.card, borderRadius:BorderRadius.circular(16), border:Border.all(color:AppColors.border)),
          child: Column(children: [
            _specBar('Camera',  80, 85, '48MP', '50MP'),
            const SizedBox(height:12),
            _specBar('Battery', 45, 60, '3877mAh', '4000mAh'),
            const SizedBox(height:12),
            _specBar('Price',   75, 60, '₹69,999', '₹74,999'),
            const SizedBox(height:12),
            _specBar('Rating',  88, 84, '4.4⭐', '4.2⭐'),
          ]),
        ),
        const SizedBox(height:16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color:AppColors.card, borderRadius:BorderRadius.circular(16), border:Border.all(color:AppColors.border)),
          child: Column(children: [
            const Text('🔄 Compare Other Products', style: TextStyle(fontSize:14, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
            const SizedBox(height:4),
            const Text('Search any 2 products to battle them out', style: TextStyle(fontSize:12, color:AppColors.textMuted)),
            const SizedBox(height:12),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon! 🚀'), backgroundColor: AppColors.primary)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal:24, vertical:12),
                decoration: BoxDecoration(color:AppColors.primary, borderRadius:BorderRadius.circular(12)),
                child: const Row(mainAxisSize:MainAxisSize.min, children: [
                  Icon(Icons.search, color:Colors.white, size:16),
                  SizedBox(width:6),
                  Text('Start New Battle', style: TextStyle(fontSize:13, fontWeight:FontWeight.w700, color:Colors.white)),
                ]),
              ),
            ),
          ]),
        ),
      ])),
    );
  }

  Widget _prodCard(Map<String, dynamic> p) => Expanded(child: Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: (p['wins'] as bool) ? AppColors.successGlow : AppColors.card,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: (p['wins'] as bool) ? AppColors.success : AppColors.border),
    ),
    child: Column(children: [
      if (p['wins'] as bool) const Text('👑', style: TextStyle(fontSize:16)),
      Text(p['emoji'] as String, style: const TextStyle(fontSize:36)),
      const SizedBox(height:6),
      Text(p['name'] as String, textAlign:TextAlign.center, maxLines:2,
        style: const TextStyle(fontSize:11, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
      const SizedBox(height:4),
      Text('₹${(p['price'] as double).toStringAsFixed(0)}',
        style: TextStyle(fontSize:14, fontWeight:FontWeight.w800,
            color: (p['wins'] as bool) ? AppColors.success : AppColors.primary)),
      Text('⭐ ${p['rating']}', style: const TextStyle(fontSize:11, color:Color(0xFFFFB347))),
    ]),
  ));

  Widget _specBar(String label, int a, int b, String labelA, String labelB) {
    final total = a + b;
    final widthA = a / total;
    final aWins  = a >= b;
    return Row(children: [
      SizedBox(width:65, child: Text(label, textAlign:TextAlign.center,
        style: const TextStyle(fontSize:10, color:AppColors.textMuted))),
      Expanded(child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Row(children: [
            Flexible(flex:(widthA * 100).round(), child: Container(height:6, color:AppColors.success)),
            Flexible(flex:((1-widthA) * 100).round(), child: Container(height:6, color:AppColors.primary.withOpacity(0.5))),
          ]),
        ),
        const SizedBox(height:3),
        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
          Text(labelA, style: TextStyle(fontSize:9, color: aWins ? AppColors.success : AppColors.textMuted, fontWeight: aWins ? FontWeight.w700 : FontWeight.w400)),
          Text(labelB, style: TextStyle(fontSize:9, color:!aWins ? AppColors.success : AppColors.textMuted, fontWeight:!aWins ? FontWeight.w700 : FontWeight.w400)),
        ]),
      ])),
    ]);
  }
}
