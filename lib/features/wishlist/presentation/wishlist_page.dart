import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';
import 'package:eung_shop_app/features/product/presentation/widgets/product_card.dart';
import 'package:eung_shop_app/features/wishlist/application/wishlist_providers.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider).currentUser;
    final productIds = ref.watch(currentUserWishlistProductIdsProvider);
    final products = [
      for (final productId in productIds)
        if (ref.watch(productByIdProvider(productId))
            case final Product product)
          product,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('찜한 상품')),
      body: currentUser == null
          ? _WishlistLoginPrompt(
              onLogin: () => context.pushNamed(RouteNames.login),
            )
          : products.isEmpty
          ? const Center(child: Text('아직 찜한 상품이 없습니다.'))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                    child: Text(
                      '${products.length}개 상품',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

class _WishlistLoginPrompt extends StatelessWidget {
  const _WishlistLoginPrompt({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '로그인이 필요해요',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '마음에 드는 상품을 내 계정에 저장할 수 있어요.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(onPressed: onLogin, child: const Text('로그인')),
            ],
          ),
        ),
      ),
    );
  }
}
