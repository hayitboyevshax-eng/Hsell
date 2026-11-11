import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

class DetailScreen extends StatefulWidget {
  final Product p;
  const DetailScreen(this.p, {super.key});
  @override
  State<DetailScreen> createState() => _DetailState();
}

class _DetailState extends State<DetailScreen> {
  final _pc = PageController();
  int page = 0, colorI = 0, sizeI = 0;
  late final List<Color> tints = [
    widget.p.color,
    HSLColor.fromColor(widget.p.color).withLightness(.3).toColor(),
    HSLColor.fromColor(widget.p.color).withLightness(.65).toColor(),
    HSLColor.fromColor(widget.p.color).withHue((HSLColor.fromColor(widget.p.color).hue + 40) % 360).toColor(),
  ];

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Widget _chips(List<String> list, int sel, ValueChanged<int> on) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(list.length, (i) {
          final s = i == sel;
          return GestureDetector(
            onTap: () => on(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: s ? C.primary : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: s ? C.primary : C.line)),
              child: Text(list[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: s ? Colors.white : C.primary)),
            ),
          );
        }),
      );

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahsulot'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
        actions: [Padding(padding: const EdgeInsets.only(right: 16), child: HeartButton(p.id, size: 24))],
      ),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        // Galereya
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _pc,
            itemCount: tints.length,
            onPageChanged: (v) => setState(() => page = v),
            itemBuilder: (_, i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: ProductImage(p, radius: 20, tint: tints[i])),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            tints.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: page == i ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(color: page == i ? C.primary : C.line, borderRadius: BorderRadius.circular(3)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tints.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => _pc.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: page == i ? C.primary : Colors.transparent, width: 1.5)),
                child: ProductImage(p, size: 48, radius: 10, tint: tints[i]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: T.heading),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(child: Text(som(p.price), style: T.title)),
              const Icon(Icons.star_rounded, color: C.star, size: 20),
              const SizedBox(width: 2),
              Text(p.rating.toString(), style: T.sub),
            ]),
            if (p.colors.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Rang', style: T.sub),
              const SizedBox(height: 8),
              _chips(p.colors, colorI, (i) => setState(() => colorI = i)),
            ],
            if (p.sizes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(p.sizeLabel, style: T.sub),
              const SizedBox(height: 8),
              _chips(p.sizes, sizeI, (i) => setState(() => sizeI = i)),
            ],
            const SizedBox(height: 12),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                initiallyExpanded: true,
                title: const Text('Texnik xususiyatlari', style: T.sub),
                expandedAlignment: Alignment.centerLeft,
                children: [
                  Text(p.spec, style: T.body),
                  const SizedBox(height: 6),
                  Text('Kategoriya: ${p.category}', style: T.caption),
                  Text('Kafolat: 12 oy · Yetkazib berish: 1–3 kun', style: T.caption),
                ],
              ),
            ),
          ]),
        ),
      ]),
      // Sticky bottom bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom * .5),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4))]),
        child: Row(children: [
          Expanded(
            child: AppButton("Savatchaga qo'shish", () {
              store.add(p.id);
              toast(context, "Savatchaga qo'shildi", action: "Ko'rish", onAction: () {
                Navigator.popUntil(context, (r) => r.isFirst);
                tabIndex.value = 2;
              });
            }, filled: false),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton('Xarid qilish', () {
              store.add(p.id);
              Navigator.popUntil(context, (r) => r.isFirst);
              tabIndex.value = 2;
            }),
          ),
        ]),
      ),
    );
  }
}
