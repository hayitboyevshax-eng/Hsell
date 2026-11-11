import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import 'home.dart';
import 'category.dart';
import 'cart.dart';
import 'profile.dart';

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: tabIndex,
        builder: (_, i, __) => Scaffold(
          body: IndexedStack(index: i, children: const [
            HomeScreen(),
            CategoryScreen(initial: 'Elektronika'),
            CartScreen(),
            ProfileScreen(),
          ]),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.line))),
            child: ListenableBuilder(
              listenable: store,
              builder: (_, __) => BottomNavigationBar(
                currentIndex: i,
                onTap: (v) => tabIndex.value = v,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0,
                selectedItemColor: C.primary,
                unselectedItemColor: C.hint,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                items: [
                  const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Uy'),
                  const BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view_rounded), label: 'Kategoriya'),
                  BottomNavigationBarItem(
                    icon: Badge(label: Text('${store.count}'), isLabelVisible: store.count > 0, child: const Icon(Icons.shopping_cart_outlined)),
                    activeIcon: Badge(label: Text('${store.count}'), isLabelVisible: store.count > 0, child: const Icon(Icons.shopping_cart)),
                    label: 'Savatcha',
                  ),
                  const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
                ],
              ),
            ),
          ),
        ),
      );
}
