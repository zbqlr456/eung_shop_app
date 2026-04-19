import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/cart/application/cart_providers.dart';
import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';
import 'package:eung_shop_app/features/product/presentation/product_formatters.dart';
import 'package:eung_shop_app/features/product/presentation/widgets/product_card.dart';

class ProductDetailPage extends HookConsumerWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productByIdProvider(productId));

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('상품 상세')),
        body: const Center(child: Text('상품을 찾을 수 없습니다.')),
      );
    }

    final currentUser = ref.watch(authControllerProvider).currentUser;
    final relatedProducts = ref.watch(relatedProductsProvider(product.id));
    final selectedImageIndex = useState(0);
    final selectedColor = useState(product.colors.first);
    final selectedSize = useState(product.sizes.first);
    final quantity = useState(1);

    void addSelectedProductToCart() {
      ref
          .read(cartProvider.notifier)
          .add(
            productId: product.id,
            color: selectedColor.value,
            size: selectedSize.value,
            quantity: quantity.value,
          );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('상품 상세')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProductGallery(
              product: product,
              selectedIndex: selectedImageIndex.value,
              onSelected: (index) => selectedImageIndex.value = index,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverList.list(
              children: [
                _ProductSummary(product: product),
                const SizedBox(height: 20),
                _PurchaseBenefits(product: product),
                const SizedBox(height: 28),
                _OptionSelector(
                  title: '색상',
                  values: product.colors,
                  selectedValue: selectedColor.value,
                  enabled: product.isInStock,
                  onSelected: (value) => selectedColor.value = value,
                ),
                const SizedBox(height: 24),
                _OptionSelector(
                  title: '사이즈',
                  values: product.sizes,
                  selectedValue: selectedSize.value,
                  enabled: product.isInStock,
                  onSelected: (value) => selectedSize.value = value,
                ),
                const SizedBox(height: 24),
                _QuantitySelector(
                  quantity: quantity.value,
                  enabled: product.isInStock,
                  onDecrease: () {
                    if (quantity.value > 1) {
                      quantity.value -= 1;
                    }
                  },
                  onIncrease: () => quantity.value += 1,
                ),
                const SizedBox(height: 28),
                _ProductInfo(product: product),
                const SizedBox(height: 28),
                if (relatedProducts.isNotEmpty)
                  _RelatedProducts(products: relatedProducts),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: product.isInStock
                      ? () {
                          addSelectedProductToCart();
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.name} ${quantity.value}개를 장바구니에 담았습니다.',
                                ),
                              ),
                            );
                        }
                      : null,
                  child: const Text('장바구니'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: product.isInStock
                      ? () {
                          addSelectedProductToCart();

                          if (currentUser == null) {
                            context.pushNamed(
                              RouteNames.login,
                              queryParameters: {
                                'redirect': RoutePaths.checkout,
                              },
                            );
                            return;
                          }

                          context.pushNamed(RouteNames.checkout);
                        }
                      : null,
                  child: Text(
                    product.isInStock
                        ? '${formatPrice(product.price * quantity.value)}원 바로구매'
                        : '품절',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGallery extends StatelessWidget {
  const _ProductGallery({
    required this.product,
    required this.selectedIndex,
    required this.onSelected,
  });

  final Product product;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final imageUrls = product.imageGallery;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: GestureDetector(
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return Dialog.fullscreen(
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          minScale: 0.8,
                          maxScale: 4,
                          child: Center(
                            child: Image.network(
                              imageUrls[selectedIndex],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported_outlined,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 48,
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: IconButton.filledTonal(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            tooltip: '닫기',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Image.network(
              imageUrls[selectedIndex],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.onSurfaceVariant,
                    size: 40,
                  ),
                );
              },
            ),
          ),
        ),
        if (imageUrls.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 68,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;

                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onSelected(index),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox.square(
                        dimension: 66,
                        child: Image.network(
                          imageUrls[index],
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
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ProductSummary extends StatelessWidget {
  const _ProductSummary({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final discountRate = product.discountRate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.brand,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _StockBadge(isInStock: product.isInStock),
          ],
        ),
        const SizedBox(height: 8),
        Text(product.name, style: textTheme.headlineSmall),
        const SizedBox(height: 12),
        Row(
          children: [
            if (discountRate != null) ...[
              Text(
                '$discountRate%',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              '${formatPrice(product.price)}원',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        if (product.originalPrice != null) ...[
          const SizedBox(height: 4),
          Text(
            '${formatPrice(product.originalPrice!)}원',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star, size: 18),
            const SizedBox(width: 4),
            Text(
              '${product.rating.toStringAsFixed(1)} · 리뷰 ${product.reviewCount}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.isInStock});

  final bool isInStock;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isInStock
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          isInStock ? '구매 가능' : '품절',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isInStock
                ? colorScheme.onPrimaryContainer
                : colorScheme.onErrorContainer,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PurchaseBenefits extends StatelessWidget {
  const _PurchaseBenefits({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _BenefitRow(
              icon: Icons.local_shipping_outlined,
              label: product.price >= 30000 ? '무료배송' : '3만원 이상 무료배송',
            ),
            const SizedBox(height: 10),
            _BenefitRow(icon: Icons.replay_outlined, label: '수령 후 7일 이내 교환/반품'),
            const SizedBox(height: 10),
            _BenefitRow(
              icon: Icons.verified_outlined,
              label: product.isInStock ? '오늘 주문 가능' : '재입고 알림 준비중',
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
      ],
    );
  }
}

class _OptionSelector extends StatelessWidget {
  const _OptionSelector({
    required this.title,
    required this.values,
    required this.selectedValue,
    required this.enabled,
    required this.onSelected,
  });

  final String title;
  final List<String> values;
  final String selectedValue;
  final bool enabled;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (title == '사이즈')
              TextButton(
                onPressed: () => _showSizeGuide(context),
                child: const Text('사이즈 가이드'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((value) {
            return ChoiceChip(
              label: Text(value),
              selected: value == selectedValue,
              onSelected: enabled ? (_) => onSelected(value) : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.enabled,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final bool enabled;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(child: Text('수량', style: textTheme.titleMedium)),
        _QuantityButton(
          icon: Icons.remove,
          onPressed: enabled && quantity > 1 ? onDecrease : null,
        ),
        SizedBox(
          width: 44,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        _QuantityButton(
          icon: Icons.add,
          onPressed: enabled ? onIncrease : null,
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
      dimension: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('상품 정보', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Text(product.description, style: textTheme.bodyMedium),
        const SizedBox(height: 16),
        Divider(color: colorScheme.outlineVariant),
        _InfoTile(
          title: '상세 설명',
          children: [
            Text(
              '편안한 착용감과 매일 손이 가는 실루엣을 기준으로 골랐어요. 단독으로 입어도 좋고, 아우터 안에 받쳐 입기에도 부담 없습니다.',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
        _InfoTile(
          title: '배송 안내',
          children: const [
            _InfoRow(label: '배송비', value: '3만원 이상 무료배송'),
            SizedBox(height: 10),
            _InfoRow(label: '출고', value: '영업일 기준 1-2일 이내'),
          ],
        ),
        _InfoTile(
          title: '교환/반품',
          children: const [
            _InfoRow(label: '기간', value: '수령 후 7일 이내 가능'),
            SizedBox(height: 10),
            _InfoRow(label: '조건', value: '착용 흔적과 택 제거가 없을 때 가능'),
          ],
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 16),
      title: Text(title),
      children: children,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Text(value, style: textTheme.bodyMedium)),
      ],
    );
  }
}

class _RelatedProducts extends StatelessWidget {
  const _RelatedProducts({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('함께 보면 좋은 상품', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 340,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 150,
                child: ProductCard(product: products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

void _showSizeGuide(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('사이즈 가이드', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              const _SizeGuideRow(size: 'S', description: '90-95 추천'),
              const _SizeGuideRow(size: 'M', description: '95-100 추천'),
              const _SizeGuideRow(size: 'L', description: '100-105 추천'),
              const _SizeGuideRow(size: 'XL', description: '105-110 추천'),
              const SizedBox(height: 12),
              Text(
                '실측은 상품과 측정 방식에 따라 1-2cm 차이가 날 수 있어요.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SizeGuideRow extends StatelessWidget {
  const _SizeGuideRow({required this.size, required this.description});

  final String size;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              size,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }
}
