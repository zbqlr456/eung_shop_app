import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/cart/application/cart_providers.dart';
import 'package:eung_shop_app/features/cart/domain/cart_item.dart';
import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';
import 'package:eung_shop_app/features/product/presentation/product_formatters.dart';

class CartPage extends HookConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final currentUser = ref.watch(authControllerProvider).currentUser;
    final productsById = {
      for (final item in items)
        item.productId: ref.watch(productByIdProvider(item.productId)),
    };
    final totalPrice = items.fold(0, (total, item) {
      final product = productsById[item.productId];
      if (product == null) return total;
      return total + (product.price * item.quantity);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: ref.read(cartProvider.notifier).clear,
              child: const Text('비우기'),
            ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('담긴 상품이 없습니다.'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                final product = productsById[item.productId];

                if (product == null) {
                  return _MissingCartItem(item: item);
                }

                return _CartItemTile(item: item, product: product);
              },
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: FilledButton(
                  onPressed: () {
                    if (currentUser == null) {
                      context.pushNamed(
                        RouteNames.login,
                        queryParameters: {'redirect': RoutePaths.checkout},
                      );
                      return;
                    }

                    context.pushNamed(RouteNames.checkout);
                  },
                  child: Text('${formatPrice(totalPrice)}원 주문하기'),
                ),
              ),
            ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item, required this.product});

  final CartItem item;
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cart = ref.read(cartProvider.notifier);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 92,
            height: 122,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => cart.remove(item.id),
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: '삭제',
                  ),
                ],
              ),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Text(
                '${item.color} / ${item.size}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _QuantityButton(
                    icon: Icons.remove,
                    onPressed: item.quantity == 1
                        ? null
                        : () => cart.decrease(item.id),
                  ),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _QuantityButton(
                    icon: Icons.add,
                    onPressed: () => cart.increase(item.id),
                  ),
                  const Spacer(),
                  Text(
                    '${formatPrice(product.price * item.quantity)}원',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _MissingCartItem extends ConsumerWidget {
  const _MissingCartItem({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('상품을 찾을 수 없습니다.'),
      subtitle: Text('${item.color} / ${item.size}'),
      trailing: IconButton(
        onPressed: () => ref.read(cartProvider.notifier).remove(item.id),
        icon: const Icon(Icons.close),
      ),
    );
  }
}
