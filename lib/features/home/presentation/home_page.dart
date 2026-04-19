import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';
import 'package:eung_shop_app/features/product/presentation/widgets/product_card.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newProducts = ref.watch(newProductsProvider);
    final popularProducts = ref.watch(popularProductsProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HomeHeader(),
                    const SizedBox(height: 18),
                    const _HomeSearchBox(),
                    const SizedBox(height: 20),
                    const _PromoBanner(),
                    const SizedBox(height: 24),
                    const _CategoryShortcutGrid(),
                    const SizedBox(height: 28),
                    _ProductRail(title: '새로 들어왔어요', products: newProducts),
                    const SizedBox(height: 28),
                    _ProductRail(title: '많이 찾는 상품', products: popularProducts),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Eung Shop',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '오늘 입기 좋은 옷부터 찾아볼까요',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
          tooltip: '알림',
        ),
      ],
    );
  }
}

class _HomeSearchBox extends StatelessWidget {
  const _HomeSearchBox();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        context.pushNamed(RouteNames.search);
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 10),
            Text(
              '브랜드, 상품, 카테고리 검색',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        _pushProductList(
          context,
          categoryId: 'shirts',
          title: '셔츠',
          includeChildren: false,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '셔츠 기획전',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onInverseSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '가볍게 입는 새 시즌 셔츠',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onInverseSurface,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed: () {
                _pushProductList(
                  context,
                  categoryId: 'shirts',
                  title: '셔츠',
                  includeChildren: false,
                );
              },
              child: const Text('둘러보기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryShortcutGrid extends StatelessWidget {
  const _CategoryShortcutGrid();

  static const _shortcuts = [
    _CategoryShortcut('상의', 'tops', Icons.checkroom_outlined),
    _CategoryShortcut('아우터', 'outerwear', Icons.dry_cleaning_outlined),
    _CategoryShortcut('신발', 'shoes', Icons.directions_walk_outlined),
    _CategoryShortcut('가방', 'bags', Icons.shopping_bag_outlined),
    _CategoryShortcut('포멀', 'formalwear', Icons.business_center_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('빠른 카테고리', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _shortcuts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final shortcut = _shortcuts[index];
              return _CategoryShortcutButton(shortcut: shortcut);
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryShortcutButton extends StatelessWidget {
  const _CategoryShortcutButton({required this.shortcut});

  final _CategoryShortcut shortcut;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 78,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          _pushProductList(
            context,
            categoryId: shortcut.categoryId,
            title: shortcut.label,
            includeChildren: true,
          );
        },
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(shortcut.icon, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(shortcut.label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ProductRail extends StatelessWidget {
  const _ProductRail({required this.title, required this.products});

  final String title;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 330,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 156,
                child: ProductCard(product: products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryShortcut {
  const _CategoryShortcut(this.label, this.categoryId, this.icon);

  final String label;
  final String categoryId;
  final IconData icon;
}

void _pushProductList(
  BuildContext context, {
  required String categoryId,
  required String title,
  required bool includeChildren,
}) {
  context.pushNamed(
    RouteNames.productList,
    queryParameters: {
      'categoryId': categoryId,
      'title': title,
      'includeChildren': '$includeChildren',
    },
  );
}
