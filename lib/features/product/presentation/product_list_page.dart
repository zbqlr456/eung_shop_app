import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/presentation/widgets/product_card.dart';

class ProductListPage extends HookConsumerWidget {
  const ProductListPage({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.includeChildren,
  });

  final String categoryId;
  final String categoryTitle;
  final bool includeChildren;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      productListProvider(
        categoryId: categoryId,
        includeChildren: includeChildren,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${products.length}개 상품',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.tune, size: 18),
                      label: const Text('필터'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.swap_vert, size: 18),
                      label: const Text('인기순'),
                    ),
                  ],
                ),
              ),
            ),
            if (products.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    '아직 등록된 상품이 없습니다.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.48,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
