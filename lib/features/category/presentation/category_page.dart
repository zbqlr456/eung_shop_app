import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/category/application/category_providers.dart';
import 'package:eung_shop_app/features/category/domain/category.dart';
import 'package:eung_shop_app/shared/utils/hangul_search.dart';

class CategoryPage extends HookConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final selectedAudience = ref.watch(selectedCategoryAudienceProvider);
    final sections = ref.watch(categorySectionsProvider);
    final filteredSections = _filterSections(sections, searchQuery.value);

    useEffect(() {
      Timer? debounce;

      void updateQuery() {
        final value = searchController.value;

        debounce?.cancel();
        debounce = Timer(const Duration(milliseconds: 80), () {
          searchQuery.value = value.text;
        });
      }

      searchController.addListener(updateQuery);
      return () {
        debounce?.cancel();
        searchController.removeListener(updateQuery);
      };
    }, [searchController]);

    return Scaffold(
      appBar: AppBar(title: const Text('카테고리')),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CategorySearchField(controller: searchController),
                    const SizedBox(height: 18),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: CategoryAudience.values.map((audience) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(audience.label),
                              selected: selectedAudience == audience,
                              onSelected: (_) {
                                ref
                                    .read(
                                      selectedCategoryAudienceProvider.notifier,
                                    )
                                    .select(audience);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (filteredSections.isEmpty)
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
                sliver: SliverList.separated(
                  itemCount: filteredSections.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final section = filteredSections[index];
                    return _CategorySectionView(section: section);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<CategorySection> _filterSections(
    List<CategorySection> sections,
    String query,
  ) {
    final keyword = query.trim().toLowerCase();
    if (keyword.isEmpty) return sections;

    return sections
        .map((section) {
          final items = section.items
              .where((item) => _matchesCategoryKeyword(item.name, keyword))
              .toList();

          return CategorySection(
            id: section.id,
            title: section.title,
            items: items,
          );
        })
        .where((section) => section.items.isNotEmpty)
        .toList();
  }
}

class _CategorySearchField extends StatelessWidget {
  const _CategorySearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      key: const ValueKey('categorySearchField'),
      controller: controller,
      inputFormatters: const [HangulJamoFormatter()],
      textInputAction: TextInputAction.search,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        hintText: '찾고 싶은 카테고리를 검색해보세요',
        prefixIcon: const Icon(Icons.search),
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

class _CategorySectionView extends StatelessWidget {
  const _CategorySectionView({required this.section});

  final CategorySection section;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(section.title, style: textTheme.titleMedium)),
            TextButton(
              onPressed: () {
                _pushProductList(
                  context,
                  categoryId: section.id,
                  title: section.title,
                  includeChildren: true,
                );
              },
              child: const Text('전체보기'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: section.items.map((item) {
            return _CategoryItemChip(item: item);
          }).toList(),
        ),
      ],
    );
  }
}

class _CategoryItemChip extends StatelessWidget {
  const _CategoryItemChip({required this.item});

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(item.name),
      avatar: const Icon(Icons.arrow_forward_ios, size: 14),
      onPressed: () {
        _pushProductList(
          context,
          categoryId: item.id,
          title: item.name,
          includeChildren: false,
        );
      },
    );
  }
}

bool _matchesCategoryKeyword(String name, String keyword) {
  return matchesHangulKeyword(name, keyword);
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
