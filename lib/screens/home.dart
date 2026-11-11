import 'dart:async';
import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final items = q.isEmpty ? products : products.where((p) => p.name.toLowerCase().contains(q.toLowerCase())).toList();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Row(children: [
              const Text('HSELL', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              const Spacer(),
              const CartIcon(),
            ]),
          ),
          SearchBox(onChanged: (v) => setState(() => q = v)),
          const SizedBox(height: 16),
          if (q.isEmpty) ...[
            const BannerCarousel(),
            const SizedBox(height: 24),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Categories', style: T.heading)),
            const SizedBox(height: 12),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => Navigator.push(context, slideRoute(CategoryScreen(initial: categories[i].name, showBack: true))),
                  child: SizedBox(
                    width: 72,
                    child: Column(children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(16)),
                        child: Icon(categories[i].icon, size: 28),
                      ),
                      const SizedBox(height: 6),
                      Text(categories[i].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(q.isEmpty ? 'Tavsiya etilgan' : 'Natijalar: ${items.length}', style: T.heading),
          ),
          if (items.isEmpty)
            const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Hech narsa topilmadi', style: T.caption)))
          else
            ProductGrid(items),
        ]),
      ),
    );
  }
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});
  @override
  State<BannerCarousel> createState() => _BannerState();
}

class _BannerState extends State<BannerCarousel> {
  final _pc = PageController(viewportFraction: .94);
  int _i = 0;
  Timer? _t;

  static const _banners = [
    ('Yozgi chegirmalar\n50% gacha!', Color(0xFF2F80ED), Icons.local_offer_outlined),
    ('Yangi elektronika\nendi omborda', Color(0xFF111111), Icons.devices_other_outlined),
    ('Bepul yetkazib\nberish', Color(0xFF2E9E5B), Icons.local_shipping_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pc.hasClients) return;
      _pc.animateToPage((_i + 1) % _banners.length, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _pc,
            itemCount: _banners.length,
            onPageChanged: (v) => setState(() => _i = v),
            itemBuilder: (_, i) {
              final b = _banners[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: b.$2, borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  Expanded(child: Text(b.$1, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, height: 1.25))),
                  Icon(b.$3, size: 64, color: Colors.white70),
                ]),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _i == i ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(color: _i == i ? C.primary : C.line, borderRadius: BorderRadius.circular(3)),
            ),
          ),
        ),
      ]);
}
