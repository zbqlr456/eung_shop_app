import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/domain/product_filter.dart';
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
    final filterProvider = productFilterControllerProvider(
      categoryId: categoryId,
      includeChildren: includeChildren,
    );
    final filter = ref.watch(filterProvider);
    final filterOptions = ref.watch(
      productFilterOptionsProvider(
        categoryId: categoryId,
        includeChildren: includeChildren,
      ),
    );
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
                      onPressed: () {
                        _showFilterSheet(
                          context,
                          initialFilter: filter,
                          options: filterOptions,
                          onApply: ref.read(filterProvider.notifier).apply,
                        );
                      },
                      icon: const Icon(Icons.tune, size: 18),
                      label: Text(
                        filter.activeFilterCount == 0
                            ? '필터'
                            : '필터 ${filter.activeFilterCount}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SortButton(
                      selectedSort: filter.sort,
                      onSelected: ref.read(filterProvider.notifier).setSort,
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

class _SortButton extends StatelessWidget {
  const _SortButton({required this.selectedSort, required this.onSelected});

  final ProductSort selectedSort;
  final ValueChanged<ProductSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final selected = await showModalBottomSheet<ProductSort>(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Text('정렬', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final sort in ProductSort.values)
                    ListTile(
                      title: Text(sort.label),
                      trailing: sort == selectedSort
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        Navigator.of(context).pop(sort);
                      },
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );

        if (selected != null) {
          onSelected(selected);
        }
      },
      icon: const Icon(Icons.swap_vert, size: 18),
      label: Text(selectedSort.label),
    );
  }
}

Future<void> _showFilterSheet(
  BuildContext context, {
  required ProductFilter initialFilter,
  required ProductFilterOptions options,
  required ValueChanged<ProductFilter> onApply,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return _ProductFilterSheet(
        initialFilter: initialFilter,
        options: options,
        onApply: onApply,
      );
    },
  );
}

class _ProductFilterSheet extends HookWidget {
  const _ProductFilterSheet({
    required this.initialFilter,
    required this.options,
    required this.onApply,
  });

  final ProductFilter initialFilter;
  final ProductFilterOptions options;
  final ValueChanged<ProductFilter> onApply;

  @override
  Widget build(BuildContext context) {
    final draft = useState(initialFilter);

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '필터',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        draft.value = ProductFilter(
                          categoryId: initialFilter.categoryId,
                          sort: initialFilter.sort,
                        );
                      },
                      child: const Text('초기화'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  children: [
                    _PriceRangeSelector(
                      filter: draft.value,
                      onChanged: (minPrice, maxPrice) {
                        draft.value = draft.value.copyWith(
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _ToggleSection(
                      title: '조건',
                      filter: draft.value,
                      onDiscountChanged: (value) {
                        draft.value = draft.value.copyWith(discountOnly: value);
                      },
                      onInStockChanged: (value) {
                        draft.value = draft.value.copyWith(inStockOnly: value);
                      },
                    ),
                    const SizedBox(height: 24),
                    _ChipFilterSection(
                      title: '브랜드',
                      values: options.brands,
                      selectedValues: draft.value.brands,
                      onToggle: (brand) {
                        final brands = {...draft.value.brands};
                        brands.contains(brand)
                            ? brands.remove(brand)
                            : brands.add(brand);
                        draft.value = draft.value.copyWith(brands: brands);
                      },
                    ),
                    const SizedBox(height: 24),
                    _ChipFilterSection(
                      title: '색상',
                      values: options.colors,
                      selectedValues: draft.value.colors,
                      onToggle: (color) {
                        final colors = {...draft.value.colors};
                        colors.contains(color)
                            ? colors.remove(color)
                            : colors.add(color);
                        draft.value = draft.value.copyWith(colors: colors);
                      },
                    ),
                    const SizedBox(height: 24),
                    _ChipFilterSection(
                      title: '사이즈',
                      values: options.sizes,
                      selectedValues: draft.value.sizes,
                      onToggle: (size) {
                        final sizes = {...draft.value.sizes};
                        sizes.contains(size)
                            ? sizes.remove(size)
                            : sizes.add(size);
                        draft.value = draft.value.copyWith(sizes: sizes);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: FilledButton(
                  onPressed: () {
                    onApply(draft.value);
                    Navigator.of(context).pop();
                  },
                  child: const Text('적용하기'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PriceRangeSelector extends StatelessWidget {
  const _PriceRangeSelector({required this.filter, required this.onChanged});

  final ProductFilter filter;
  final void Function(int? minPrice, int? maxPrice) onChanged;

  @override
  Widget build(BuildContext context) {
    final presets = [
      _PricePreset('전체', null, null),
      _PricePreset('5만원 이하', null, 50000),
      _PricePreset('5-10만원', 50000, 100000),
      _PricePreset('10만원 이상', 100000, null),
    ];

    return _FilterSection(
      title: '가격',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: presets.map((preset) {
          final selected =
              filter.minPrice == preset.minPrice &&
              filter.maxPrice == preset.maxPrice;

          return ChoiceChip(
            label: Text(preset.label),
            selected: selected,
            onSelected: (_) => onChanged(preset.minPrice, preset.maxPrice),
          );
        }).toList(),
      ),
    );
  }
}

class _ToggleSection extends StatelessWidget {
  const _ToggleSection({
    required this.title,
    required this.filter,
    required this.onDiscountChanged,
    required this.onInStockChanged,
  });

  final String title;
  final ProductFilter filter;
  final ValueChanged<bool> onDiscountChanged;
  final ValueChanged<bool> onInStockChanged;

  @override
  Widget build(BuildContext context) {
    return _FilterSection(
      title: title,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('할인 상품만'),
            value: filter.discountOnly,
            onChanged: onDiscountChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('재고 있는 상품만'),
            value: filter.inStockOnly,
            onChanged: onInStockChanged,
          ),
        ],
      ),
    );
  }
}

class _ChipFilterSection extends StatelessWidget {
  const _ChipFilterSection({
    required this.title,
    required this.values,
    required this.selectedValues,
    required this.onToggle,
  });

  final String title;
  final List<String> values;
  final Set<String> selectedValues;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const SizedBox.shrink();
    }

    return _FilterSection(
      title: title,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values.map((value) {
          return FilterChip(
            label: Text(value),
            selected: selectedValues.contains(value),
            onSelected: (_) => onToggle(value),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _PricePreset {
  const _PricePreset(this.label, this.minPrice, this.maxPrice);

  final String label;
  final int? minPrice;
  final int? maxPrice;
}
