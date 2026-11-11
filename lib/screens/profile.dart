import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'welcome.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, VoidCallback)>[
      (Icons.receipt_long_outlined, 'Mening buyurtmalarim', () => toast(context, "Tez orada")),
      (Icons.location_on_outlined, 'Yetkazib berish manzillari', () => toast(context, "Tez orada")),
      (Icons.favorite_border, 'Sevimli mahsulotlar', () => Navigator.push(context, slideRoute(const FavoritesScreen()))),
      (Icons.credit_card_outlined, "To'lov usullari", () => toast(context, "Tez orada")),
      (Icons.headset_mic_outlined, "Qo'llab-quvvatlash", () => toast(context, "Telegram: @hsell_support")),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), automaticallyImplyLeading: false, actions: [
        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => toast(context, 'Sozlamalar')),
      ]),
      body: ListView(children: [
        Container(
          color: C.bg,
          padding: const EdgeInsets.all(16),
          child: const Row(children: [
            CircleAvatar(radius: 26, backgroundColor: C.primary, child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            SizedBox(width: 12),
            Text('Alisher Karimov', style: T.sub),
          ]),
        ),
        for (final it in items) ...[
          ListTile(
            leading: Icon(it.$1, color: C.primary),
            title: Text(it.$2, style: T.body),
            trailing: const Icon(Icons.chevron_right, color: C.hint),
            onTap: it.$3,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: C.line),
        ],
        ListTile(
          leading: const Icon(Icons.logout, color: C.primary),
          title: const Text('Chiqish', style: T.body),
          onTap: () {
            store.clear();
            store.favorites.clear();
            Navigator.pushAndRemoveUntil(context, slideRoute(const WelcomeScreen()), (_) => false);
          },
        ),
      ]),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sevimli mahsulotlar'),
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
        ),
        body: ListenableBuilder(
          listenable: store,
          builder: (_, __) {
            final items = products.where((p) => store.favorites.contains(p.id)).toList();
            if (items.isEmpty) return const Center(child: Text("Hali sevimli mahsulot yo'q", style: T.caption));
            return SingleChildScrollView(padding: const EdgeInsets.symmetric(vertical: 16), child: ProductGrid(items));
          },
        ),
      );
}
