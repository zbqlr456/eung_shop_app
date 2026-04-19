import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/features/cart/application/cart_providers.dart';
import 'package:eung_shop_app/features/cart/presentation/cart_page.dart';
import 'package:eung_shop_app/features/category/presentation/category_page.dart';
import 'package:eung_shop_app/features/home/presentation/home_page.dart';
import 'package:eung_shop_app/features/profile/presentation/profile_page.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  static const _pages = [HomePage(), CategoryPage(), CartPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final cartQuantity = ref.watch(cartTotalQuantityProvider);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '홈',
          ),
          const NavigationDestination(
            icon: Icon(Icons.checkroom_outlined),
            selectedIcon: Icon(Icons.checkroom),
            label: '카테고리',
          ),
          NavigationDestination(
            icon: _CartNavigationIcon(
              icon: Icons.shopping_bag_outlined,
              count: cartQuantity,
            ),
            selectedIcon: _CartNavigationIcon(
              icon: Icons.shopping_bag,
              count: cartQuantity,
            ),
            label: '장바구니',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '마이',
          ),
        ],
      ),
    );
  }
}

class _CartNavigationIcon extends StatelessWidget {
  const _CartNavigationIcon({required this.icon, required this.count});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      child: Icon(icon),
    );
  }
}
