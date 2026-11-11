import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';
import 'theme.dart';
import 'screens/detail.dart';

/// Sahifa o'tish animatsiyasi: o'ngdan siljish, 300ms
Route<T> slideRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: a, curve: Curves.easeInOut)),
        child: child,
      ),
    );

void toast(BuildContext context, String msg, {String? action, VoidCallback? onAction}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
    action: action == null ? null : SnackBarAction(label: action, textColor: Colors.white, onPressed: onAction ?? () {}),
  ));
}

class ProductImage extends StatelessWidget {
  final Product p;
  final double? size;
  final double radius;
  final Color? tint;
  const ProductImage(this.p, {super.key, this.size, this.radius = 12, this.tint});

  @override
  Widget build(BuildContext context) {
    final c = tint ?? p.color;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: c.withAlpha(40), borderRadius: BorderRadius.circular(radius)),
      child: Center(child: Icon(p.icon, size: size == null ? 64 : size! * .5, color: c)),
    );
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool filled;
  final double height;
  const AppButton(this.text, this.onTap, {super.key, this.filled = true, this.height = 48});

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    final label = Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
    return SizedBox(
      width: double.infinity,
      height: height,
      child: filled
          ? FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(backgroundColor: C.primary, foregroundColor: Colors.white, shape: shape),
              child: label)
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(foregroundColor: C.primary, side: const BorderSide(color: C.primary), shape: shape),
              child: label),
    );
  }
}

/// Yurakcha: bosilganda 1 -> 1.3 -> 1 (250ms) + haptic
class HeartButton extends StatefulWidget {
  final int id;
  final double size;
  const HeartButton(this.id, {super.key, this.size = 22});
  @override
  State<HeartButton> createState() => _HeartState();
}

class _HeartState extends State<HeartButton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
  late final Animation<double> _a = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
  ]).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (_, __) {
          final fav = store.favorites.contains(widget.id);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              store.toggleFav(widget.id);
              _c.forward(from: 0);
              HapticFeedback.lightImpact();
            },
            child: ScaleTransition(
              scale: _a,
              child: Icon(fav ? Icons.favorite : Icons.favorite_border, size: widget.size, color: fav ? C.red : C.grey),
            ),
          );
        },
      );
}

/// "Savatchaga" tugmasi: bosilganda "✓ Qo'shildi" holati (1.2s)
class AddToCartButton extends StatefulWidget {
  final Product p;
  const AddToCartButton(this.p, {super.key});
  @override
  State<AddToCartButton> createState() => _AddState();
}

class _AddState extends State<AddToCartButton> {
  bool added = false;
  Timer? _t;

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _tap() {
    store.add(widget.p.id);
    HapticFeedback.selectionClick();
    setState(() => added = true);
    _t?.cancel();
    _t = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => added = false);
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 36,
        child: FilledButton(
          onPressed: _tap,
          style: FilledButton.styleFrom(
            backgroundColor: added ? C.green : C.primary,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(added ? "✓ Qo'shildi" : 'Savatchaga',
                key: ValueKey(added), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      );
}

class Stars extends StatelessWidget {
  final double rating;
  const Stars(this.rating, {super.key});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.star_rounded, size: 14, color: C.star),
        const SizedBox(width: 2),
        Text(rating.toString(), style: T.caption),
      ]);
}

class CartIcon extends StatelessWidget {
  final VoidCallback? onTap;
  const CartIcon({super.key, this.onTap});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (_, __) => IconButton(
          onPressed: onTap ?? () => tabIndex.value = 2,
          icon: Badge(
            label: Text('${store.count}'),
            isLabelVisible: store.count > 0,
            child: const Icon(Icons.shopping_cart_outlined, size: 24),
          ),
        ),
      );
}

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const SearchBox({super.key, required this.onChanged});
  @override
  Widget build(BuildContext context) => Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Icon(Icons.search, size: 20, color: C.hint),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: T.body,
              decoration: const InputDecoration(
                  border: InputBorder.none, isDense: true, hintText: 'Mahsulot qidirish...', hintStyle: TextStyle(color: C.hint, fontSize: 14)),
            ),
          ),
          const Icon(Icons.qr_code_scanner, size: 20, color: C.grey),
        ]),
      );
}

class ProductCard extends StatelessWidget {
  final Product p;
  const ProductCard(this.p, {super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(context, slideRoute(DetailScreen(p))),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(children: [
                Positioned.fill(child: ProductImage(p)),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: HeartButton(p.id, size: 18)),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            SizedBox(height: 36, child: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: T.name)),
            Stars(p.rating),
            const SizedBox(height: 4),
            Text(som(p.price), style: T.price),
            const SizedBox(height: 8),
            AddToCartButton(p),
          ]),
        ),
      );
}

class ProductGrid extends StatelessWidget {
  final List<Product> items;
  const ProductGrid(this.items, {super.key});
  @override
  Widget build(BuildContext context) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 290),
        itemBuilder: (_, i) => ProductCard(items[i]),
      );
}
