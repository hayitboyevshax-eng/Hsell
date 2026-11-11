import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'detail.dart';

class CategoryScreen extends StatefulWidget {
  final String initial;
  final bool showBack;
  const CategoryScreen({super.key, required this.initial, this.showBack = false});
  @override
  State<CategoryScreen> createState() => _CategoryState();
}

class _CategoryState extends State<CategoryScreen> {
  late String cat = widget.initial;
  bool popular = false;
  String q = '';

  @override
  Widget build(BuildContext context) {
    var items = products.where((p) => p.category == cat && p.name.toLowerCase().contains(q.toLowerCase())).toList();
    items.sort(popular ? (a, b) => b.rating.compareTo(a.rating) : (a, b) => b.id.compareTo(a.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(cat),
        automaticallyImplyLeading: false,
        leading: widget.showBack ? IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)) : null,
      ),
      body: Column(children: [
        SearchBox(onChanged: (v) => setState(() => q = v)),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final sel = categories[i].name == cat;
              return GestureDetector(
                onTap: () => setState(() => cat = categories[i].name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: sel ? C.primary : C.bg, borderRadius: BorderRadius.circular(10)),
                  child: Text(categories[i].name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: sel ? Colors.white : C.primary)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            _seg('Yangi kelganlar', !popular, () => setState(() => popular = false)),
            _seg('Ommabop', popular, () => setState(() => popular = true)),
          ]),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('Mahsulot topilmadi', style: T.caption))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _row(context, items[i]),
                ),
        ),
      ]),
    );
  }

  Widget _seg(String t, bool sel, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: sel ? C.primary : Colors.transparent, borderRadius: BorderRadius.circular(10)),
            child: Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: sel ? Colors.white : C.grey)),
          ),
        ),
      );

  Widget _row(BuildContext context, Product p) => GestureDetector(
        onTap: () => Navigator.push(context, slideRoute(DetailScreen(p))),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: C.line)),
          child: Row(children: [
            ProductImage(p, size: 96),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.sub)),
                  HeartButton(p.id, size: 20),
                ]),
                const SizedBox(height: 2),
                Text(p.spec, maxLines: 2, overflow: TextOverflow.ellipsis, style: T.caption),
                const SizedBox(height: 6),
                Stars(p.rating),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(child: Text(som(p.price), style: T.price)),
                  SizedBox(width: 104, child: AddToCartButton(p)),
                ]),
              ]),
            ),
          ]),
        ),
      );
}
