import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Savatcha'), automaticallyImplyLeading: false),
        body: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            if (store.cart.isEmpty) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.shopping_cart_outlined, size: 96, color: C.line),
                  const SizedBox(height: 12),
                  const Text("Savatchangiz bo'sh", style: T.heading),
                  const SizedBox(height: 4),
                  const Text("Mahsulotlarni qo'shishni boshlang", style: T.caption),
                  const SizedBox(height: 20),
                  SizedBox(width: 200, child: AppButton('Xaridni boshlash', () => tabIndex.value = 0)),
                ]),
              );
            }
            final ids = store.cart.keys.toList();
            return Column(children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: ids.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _item(byId(ids[i]), store.cart[ids[i]]!),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4))]),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    const Text('Jami:', style: T.sub),
                    const Spacer(),
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: store.total.toDouble()),
                      duration: const Duration(milliseconds: 300),
                      builder: (_, v, __) => Text(som(v.round()), style: T.heading),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  AppButton("To'lovga o'tish", () => _checkout(context), height: 52),
                ]),
              ),
            ]);
          },
        ),
      );

  Widget _item(Product p, int qty) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          ProductImage(p, size: 72),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.sub),
              const SizedBox(height: 2),
              Text(som(p.price), style: T.caption),
              const SizedBox(height: 8),
              Row(children: [
                _btn(Icons.remove, false, () {
                  HapticFeedback.selectionClick();
                  store.setQty(p.id, qty - 1);
                }),
                SizedBox(width: 36, child: Center(child: Text('$qty', style: T.sub))),
                _btn(Icons.add, true, () {
                  HapticFeedback.selectionClick();
                  store.setQty(p.id, qty + 1);
                }),
              ]),
            ]),
          ),
          IconButton(icon: const Icon(Icons.delete_outline, color: C.red), onPressed: () => store.remove(p.id)),
        ]),
      );

  Widget _btn(IconData i, bool filled, VoidCallback t) => GestureDetector(
        onTap: t,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: filled ? C.primary : Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: filled ? C.primary : C.line)),
          child: Icon(i, size: 16, color: filled ? Colors.white : C.primary),
        ),
      );

  void _checkout(BuildContext context) {
    String pay = 'Naqd';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 16 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Buyurtmani tasdiqlash', style: T.heading),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Yetkazib berish manzili',
                prefixIcon: const Icon(Icons.location_on_outlined),
                filled: true,
                fillColor: C.bg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            const Text("To'lov usuli", style: T.sub),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              for (final m in ['Naqd', 'Karta', 'Click / Payme'])
                ChoiceChip(
                  label: Text(m),
                  selected: pay == m,
                  onSelected: (_) => set(() => pay = m),
                  selectedColor: C.primary,
                  labelStyle: TextStyle(color: pay == m ? Colors.white : C.primary),
                  showCheckmark: false,
                ),
            ]),
            const SizedBox(height: 16),
            Row(children: [const Text('Jami:', style: T.sub), const Spacer(), Text(som(store.total), style: T.heading)]),
            const SizedBox(height: 16),
            AppButton('Tasdiqlash', () {
              store.clear();
              Navigator.pop(ctx);
              toast(context, 'Buyurtma qabul qilindi ✓');
            }, height: 52),
          ]),
        ),
      ),
    );
  }
}
