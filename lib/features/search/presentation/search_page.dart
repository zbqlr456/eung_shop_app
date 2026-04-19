import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/presentation/widgets/product_card.dart';
import 'package:eung_shop_app/shared/utils/hangul_search.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final query = useState('');
    final results = ref.watch(searchedProductsProvider(query.value));
    final popularProducts = ref.watch(popularProductsProvider);

    useEffect(() {
      Timer? debounce;

      void updateQuery() {
        final value = controller.value.text;
        debounce?.cancel();
        debounce = Timer(const Duration(milliseconds: 80), () {
          query.value = value;
        });
      }

      controller.addListener(updateQuery);
      return () {
        debounce?.cancel();
        controller.removeListener(updateQuery);
      };
    }, [controller]);

    return Scaffold(
      appBar: AppBar(title: const Text('검색')),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SearchField(controller: controller),
                    const SizedBox(height: 18),
                    if (query.value.trim().isEmpty)
                      _PopularQueries(
                        onSelected: (value) {
                          controller.text = value;
                          controller.selection = TextSelection.collapsed(
                            offset: value.length,
                          );
                        },
                      )
                    else
                      Text(
                        '${results.length}개 검색 결과',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                  ],
                ),
              ),
            ),
            if (query.value.trim().isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.list(
                  children: [
                    Text(
                      '많이 찾는 상품',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 330,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: popularProducts.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 156,
                            child: ProductCard(product: popularProducts[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            else if (results.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    '검색 결과가 없습니다.',
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
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: results[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      key: const ValueKey('productSearchField'),
      controller: controller,
      autofocus: true,
      inputFormatters: const [HangulJamoFormatter()],
      textInputAction: TextInputAction.search,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        hintText: '브랜드, 상품, 카테고리 검색',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: controller.clear,
                icon: const Icon(Icons.close),
                tooltip: '검색어 지우기',
              ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

class _PopularQueries extends StatelessWidget {
  const _PopularQueries({required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _queries = ['셔츠', '티셔츠', '신발', '니트', 'ㅅ'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('추천 검색어', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _queries.map((query) {
            return ActionChip(
              label: Text(query),
              onPressed: () => onSelected(query),
            );
          }).toList(),
        ),
      ],
    );
  }
}
