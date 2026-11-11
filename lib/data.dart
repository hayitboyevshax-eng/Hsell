import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name, category, spec;
  final int price;
  final double rating;
  final IconData icon;
  final Color color;
  final List<String> colors;
  final List<String> sizes;
  final String sizeLabel;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.spec,
    required this.price,
    required this.rating,
    required this.icon,
    required this.color,
    this.colors = const [],
    this.sizes = const [],
    this.sizeLabel = 'Xotira',
  });
}

class Cat {
  final String name;
  final IconData icon;
  const Cat(this.name, this.icon);
}

const categories = [
  Cat('Elektronika', Icons.devices_other_outlined),
  Cat('Kiyim-kechak', Icons.checkroom_outlined),
  Cat('Poyabzal', Icons.directions_run_outlined),
  Cat("Uy-ro'zg'or", Icons.blender_outlined),
];

final products = <Product>[
  const Product(id: 1, name: 'Samsung Galaxy A55', category: 'Elektronika', spec: '8/256 GB · 120 Hz · 5000 mAh', price: 3450000, rating: 4.6, icon: Icons.smartphone, color: Color(0xFF5B7CFA), colors: ["Ko'k", 'Qora', 'Oq'], sizes: ['128 GB', '256 GB']),
  const Product(id: 2, name: 'iPhone 15', category: 'Elektronika', spec: '6/128 GB · 60 Hz · A16 Bionic', price: 11500000, rating: 4.8, icon: Icons.phone_iphone, color: Color(0xFF4FB3D9), colors: ["Ko'k", 'Qora', 'Pushti'], sizes: ['128 GB', '256 GB', '512 GB']),
  const Product(id: 3, name: 'HP Laptop 15', category: 'Elektronika', spec: 'Core i5 · 16 GB · 512 GB SSD', price: 7800000, rating: 4.4, icon: Icons.laptop_mac, color: Color(0xFF6C7A89), colors: ['Kulrang', 'Kumush'], sizes: ['8 GB', '16 GB']),
  const Product(id: 4, name: 'Xiaomi Redmi Note 13', category: 'Elektronika', spec: '8/256 GB · AMOLED 120 Hz', price: 3490000, rating: 4.5, icon: Icons.smartphone, color: Color(0xFF1F9E8F), colors: ['Yashil', 'Qora'], sizes: ['128 GB', '256 GB']),
  const Product(id: 5, name: 'Samsung Galaxy S24 Ultra', category: 'Elektronika', spec: '12/256 GB · 200 MP · S Pen', price: 14200000, rating: 4.8, icon: Icons.phone_android, color: Color(0xFF8D8A95), colors: ['Kulrang', 'Binafsha', 'Xotira'], sizes: ['256 GB', '512 GB', '1 TB']),
  const Product(id: 6, name: 'Erkaklar krossovkasi', category: 'Poyabzal', spec: "Yengil, nafas oluvchi to'r", price: 450000, rating: 4.3, icon: Icons.directions_run, color: Color(0xFF222222), colors: ['Qora', 'Oq'], sizes: ['40', '41', '42', '43', '44'], sizeLabel: "O'lcham"),
  const Product(id: 7, name: 'Ayollar krossovkasi', category: 'Poyabzal', spec: 'Yumshoq taglik, kundalik', price: 420000, rating: 4.5, icon: Icons.directions_walk, color: Color(0xFFE88BA8), colors: ['Pushti', 'Oq'], sizes: ['36', '37', '38', '39', '40'], sizeLabel: "O'lcham"),
  const Product(id: 8, name: 'Erkaklar kurtkasi', category: 'Kiyim-kechak', spec: "Suv o'tkazmaydigan, qish-bahor", price: 520000, rating: 4.2, icon: Icons.checkroom, color: Color(0xFF1F3A5F), colors: ["To'q ko'k", 'Qora'], sizes: ['S', 'M', 'L', 'XL'], sizeLabel: "O'lcham"),
  const Product(id: 9, name: 'Paxta futbolka', category: 'Kiyim-kechak', spec: '100% paxta, oversize', price: 120000, rating: 4.1, icon: Icons.dry_cleaning_outlined, color: Color(0xFFB08968), colors: ['Oq', 'Qora', 'Bej'], sizes: ['S', 'M', 'L', 'XL'], sizeLabel: "O'lcham"),
  const Product(id: 10, name: 'Multivarka 5L', category: "Uy-ro'zg'or", spec: '45 dastur · 900 W', price: 890000, rating: 4.7, icon: Icons.soup_kitchen_outlined, color: Color(0xFFC0613B), colors: ['Qora', 'Kumush']),
  const Product(id: 11, name: 'Blender 1000W', category: "Uy-ro'zg'or", spec: "Zanglamaydigan pichoq, 1.5 L", price: 350000, rating: 4.4, icon: Icons.blender_outlined, color: Color(0xFF3F8F6B), colors: ['Oq', 'Qora']),
  const Product(id: 12, name: 'Elektr choynak', category: "Uy-ro'zg'or", spec: '1.7 L · 2200 W · avto-o\'chirish', price: 210000, rating: 4.6, icon: Icons.coffee_maker_outlined, color: Color(0xFF7B6CF6), colors: ['Kulrang', 'Qora']),
];

Product byId(int id) => products.firstWhere((p) => p.id == id);

String som(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(' ');
    b.write(s[i]);
  }
  return "$b so'm";
}

/// Ilova holati (sevimlilar, savat, til)
class Store extends ChangeNotifier {
  final Set<int> favorites = {};
  final Map<int, int> cart = {};
  String lang = "O'zbekcha";

  void toggleFav(int id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    notifyListeners();
  }

  void add(int id) {
    cart[id] = (cart[id] ?? 0) + 1;
    notifyListeners();
  }

  void setQty(int id, int q) {
    q <= 0 ? cart.remove(id) : cart[id] = q;
    notifyListeners();
  }

  void remove(int id) {
    cart.remove(id);
    notifyListeners();
  }

  void clear() {
    cart.clear();
    notifyListeners();
  }

  void setLang(String l) {
    lang = l;
    notifyListeners();
  }

  int get count => cart.values.fold(0, (a, b) => a + b);
  int get total => cart.entries.fold(0, (s, e) => s + byId(e.key).price * e.value);
}

final store = Store();

/// Bottom navigation tabi (boshqa ekrandan almashtirish uchun)
final tabIndex = ValueNotifier<int>(0);
