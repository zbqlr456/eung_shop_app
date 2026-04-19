import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';
import 'package:eung_shop_app/features/product/presentation/product_formatters.dart';

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

    final selectedColor = useState(product.colors.first);
    final selectedSize = useState(product.sizes.first);

    return Scaffold(
      appBar: AppBar(title: const Text('상품 상세')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ProductHeroImage(product: product)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverList.list(
              children: [
                _ProductSummary(product: product),
                const SizedBox(height: 28),
                _OptionSelector(
                  title: '색상',
                  values: product.colors,
                  selectedValue: selectedColor.value,
                  onSelected: (value) => selectedColor.value = value,
                ),
                const SizedBox(height: 24),
                _OptionSelector(
                  title: '사이즈',
                  values: product.sizes,
                  selectedValue: selectedSize.value,
                  onSelected: (value) => selectedSize.value = value,
                ),
                const SizedBox(height: 28),
                _ProductInfo(product: product),
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} 장바구니 담기 예정')),
                    );
                  },
                  child: const Text('장바구니'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} 바로 구매 예정')),
                    );
                  },
                  child: const Text('바로구매'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductHeroImage extends StatelessWidget {
  const _ProductHeroImage({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Image.network(
        product.imageUrl,
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
        Text(
          product.brand,
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
          ),
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
        Text(
          '평점 ${product.rating.toStringAsFixed(1)} · 리뷰 ${product.reviewCount}',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _OptionSelector extends StatelessWidget {
  const _OptionSelector({
    required this.title,
    required this.values,
    required this.selectedValue,
    required this.onSelected,
  });

  final String title;
  final List<String> values;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((value) {
            return ChoiceChip(
              label: Text(value),
              selected: value == selectedValue,
              onSelected: (_) => onSelected(value),
            );
          }).toList(),
        ),
      ],
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
        const SizedBox(height: 16),
        _InfoRow(label: '배송', value: '3만원 이상 무료배송'),
        const SizedBox(height: 10),
        _InfoRow(label: '교환/반품', value: '수령 후 7일 이내 가능'),
      ],
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
