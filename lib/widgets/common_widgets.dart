// lib/widgets/common_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ── Platform Badge ────────────────────────────────────────────────
class PlatformBadge extends StatelessWidget {
  final String platform;
  const PlatformBadge(this.platform, {super.key});

  @override
  Widget build(BuildContext context) {
    final cfg = {
      'amazon':   {'label': 'AMZ',  'bg': AppColors.amazonBg,   'color': AppColors.amazon},
      'flipkart': {'label': 'FLIP', 'bg': AppColors.flipkartBg, 'color': AppColors.flipkart},
      'meesho':   {'label': 'MEE',  'bg': AppColors.meeshoBg,   'color': AppColors.meesho},
    };
    final c = cfg[platform] ?? {'label': platform.toUpperCase(), 'bg': AppColors.card, 'color': AppColors.textMuted};
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c['bg'] as Color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(c['label'] as String,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: c['color'] as Color)),
    );
  }
}

// ── Deal Card ─────────────────────────────────────────────────────
class DealCard extends StatelessWidget {
  final Deal deal;
  final VoidCallback onTap;
  const DealCard({super.key, required this.deal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(children: [
          // Orange left accent
          Positioned(left:0, top:0, bottom:0,
            child: Container(width:3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              // Emoji
              Container(
                width:52, height:52,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(deal.emoji, style: const TextStyle(fontSize:26))),
              ),
              const SizedBox(width:12),
              // Info
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(deal.name, maxLines:1, overflow:TextOverflow.ellipsis,
                  style: const TextStyle(fontSize:12, fontWeight:FontWeight.w600, color:AppColors.textPrimary)),
                const SizedBox(height:4),
                Row(children: deal.platforms.map((p) => Padding(
                  padding: const EdgeInsets.only(right:4),
                  child: PlatformBadge(p),
                )).toList()),
                const SizedBox(height:4),
                Row(children: [
                  Text('₹${deal.currentPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    style: const TextStyle(fontSize:15, fontWeight:FontWeight.w800, color:AppColors.success)),
                  const SizedBox(width:6),
                  Text('₹${deal.originalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize:10, color:AppColors.textMuted, decoration:TextDecoration.lineThrough)),
                ]),
              ])),
              // Save badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(children: [
                  const Text('Save', style: TextStyle(fontSize:9, color:AppColors.primary, fontWeight:FontWeight.w600)),
                  Text('${deal.discount}%', style: const TextStyle(fontSize:13, color:AppColors.primary, fontWeight:FontWeight.w800)),
                ]),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ── Store Compare Row ─────────────────────────────────────────────
class StoreRow extends StatelessWidget {
  final Product store;
  final VoidCallback onTap;
  const StoreRow({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icons = {'amazon':'🟠', 'flipkart':'🔵', 'meesho':'🟣'};
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom:8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: store.isBest ? AppColors.successGlow : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: store.isBest ? AppColors.success : AppColors.border),
        ),
        child: Stack(children: [
          if (store.isBest)
            Positioned(top:0, right:0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal:8, vertical:3),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.only(topRight:Radius.circular(14), bottomLeft:Radius.circular(10)),
                ),
                child: const Text('BEST', style: TextStyle(fontSize:9, fontWeight:FontWeight.w800, color:Colors.black)),
              ),
            ),
          Row(children: [
            Container(
              width:40, height:40,
              decoration: BoxDecoration(
                color: store.platform == 'amazon' ? AppColors.amazonBg
                    : store.platform == 'flipkart' ? AppColors.flipkartBg : AppColors.meeshoBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(icons[store.platform] ?? '🏪', style: const TextStyle(fontSize:20))),
            ),
            const SizedBox(width:10),
            Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Text(store.platform[0].toUpperCase() + store.platform.substring(1),
                style: const TextStyle(fontSize:12, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
              Text('📦 ${store.delivery}',
                style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
            ])),
            Column(crossAxisAlignment:CrossAxisAlignment.end, children: [
              Text('₹${store.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: TextStyle(fontSize:15, fontWeight:FontWeight.w800,
                    color: store.isBest ? AppColors.success : AppColors.textPrimary)),
              Text(store.isBest ? '↓ ${store.discount}% off' : '₹${(store.price - 28999).abs().toStringAsFixed(0)} more',
                style: TextStyle(fontSize:10, color: store.isBest ? AppColors.success : AppColors.textMuted)),
            ]),
          ]),
        ]),
      ),
    );
  }
}

// ── Alert Item ────────────────────────────────────────────────────
class AlertItemCard extends StatelessWidget {
  final PriceAlert alert;
  final VoidCallback onRemove;
  const AlertItemCard({super.key, required this.alert, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom:8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Container(width:44, height:44,
          decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(10)),
          child: Center(child: Text(alert.emoji, style: const TextStyle(fontSize:22))),
        ),
        const SizedBox(width:10),
        Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
          Text(alert.productName, maxLines:1, overflow:TextOverflow.ellipsis,
            style: const TextStyle(fontSize:12, fontWeight:FontWeight.w600, color:AppColors.textPrimary)),
          const SizedBox(height:2),
          RichText(text: TextSpan(style: const TextStyle(fontSize:11), children: [
            const TextSpan(text:'Target: ', style: TextStyle(color:AppColors.textMuted)),
            TextSpan(text:'₹${alert.targetPrice.toStringAsFixed(0)}',
              style: const TextStyle(color:AppColors.primary, fontWeight:FontWeight.w700)),
            if (alert.dropped)
              TextSpan(text:' · Now ₹${alert.currentPrice.toStringAsFixed(0)} ✅',
                style: const TextStyle(color:AppColors.success))
            else
              TextSpan(text:' · Now ₹${alert.currentPrice.toStringAsFixed(0)}',
                style: const TextStyle(color:AppColors.textMuted)),
          ])),
        ])),
        Container(width:10, height:10,
          decoration: BoxDecoration(
            color: alert.dropped ? AppColors.success : AppColors.info,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: (alert.dropped ? AppColors.success : AppColors.info).withOpacity(0.5), blurRadius:8)],
          ),
        ),
      ]),
    );
  }
}

// ── Cart Item ─────────────────────────────────────────────────────
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onToggle;
  final VoidCallback onRemove;
  const CartItemCard({super.key, required this.item, required this.onToggle, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom:8),
      padding: const EdgeInsets.symmetric(horizontal:12, vertical:10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width:22, height:22,
            decoration: BoxDecoration(
              color: item.checked ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: item.checked ? AppColors.primary : AppColors.border, width:2),
            ),
            child: item.checked ? const Icon(Icons.check, size:13, color:Colors.white) : null,
          ),
        ),
        const SizedBox(width:10),
        Expanded(child: Text(item.name,
          style: TextStyle(fontSize:12, fontWeight:FontWeight.w500,
            color: item.checked ? AppColors.textPrimary : AppColors.textMuted,
            decoration: item.checked ? null : TextDecoration.lineThrough))),
        Text('×${item.qty}', style: const TextStyle(fontSize:11, color:AppColors.textMuted)),
        const SizedBox(width:8),
        Text(item.price > 0 ? '₹${(item.price * item.qty).toStringAsFixed(0)}' : '—',
          style: const TextStyle(fontSize:13, fontWeight:FontWeight.w800, color:AppColors.success)),
      ]),
    );
  }
}

// ── Coupon Card ───────────────────────────────────────────────────
class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback onCopy;
  const CouponCard({super.key, required this.coupon, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom:8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x4DC084FC),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(children: [
        Container(width:44, height:44,
          decoration: BoxDecoration(color:AppColors.purpleGlow, borderRadius:BorderRadius.circular(10)),
          child: Center(child: Text(coupon.emoji, style: const TextStyle(fontSize:22))),
        ),
        const SizedBox(width:10),
        Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
          Text(coupon.name, style: const TextStyle(fontSize:12, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
          const SizedBox(height:3),
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal:8, vertical:3),
              decoration: BoxDecoration(color:AppColors.purpleGlow, borderRadius:BorderRadius.circular(5)),
              child: Row(mainAxisSize:MainAxisSize.min, children: [
                Text(coupon.code, style: const TextStyle(fontSize:11, color:AppColors.purple, fontWeight:FontWeight.w800, letterSpacing:1)),
                const SizedBox(width:4),
                const Icon(Icons.copy, size:11, color:AppColors.purple),
              ]),
            ),
          ),
          const SizedBox(height:2),
          Text('Expires: ${coupon.expiry}', style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
        ])),
        Text(coupon.value, style: const TextStyle(fontSize:18, fontWeight:FontWeight.w800, color:AppColors.purple)),
      ]),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  const EmptyState({super.key, required this.emoji, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(mainAxisAlignment:MainAxisAlignment.center, children: [
        Text(emoji, style: const TextStyle(fontSize:52)),
        const SizedBox(height:16),
        Text(title, style: const TextStyle(fontSize:18, fontWeight:FontWeight.w700, color:AppColors.textPrimary), textAlign:TextAlign.center),
        const SizedBox(height:8),
        Text(subtitle, style: const TextStyle(fontSize:13, color:AppColors.textMuted), textAlign:TextAlign.center),
      ]),
    ));
  }
}

// ── Section Header ────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(fontSize:14, fontWeight:FontWeight.w700, color:AppColors.textPrimary)),
        if (action != null)
          GestureDetector(onTap: onAction,
            child: Text(action!, style: const TextStyle(fontSize:11, color:AppColors.primary, fontWeight:FontWeight.w600))),
      ]),
    );
  }
}
