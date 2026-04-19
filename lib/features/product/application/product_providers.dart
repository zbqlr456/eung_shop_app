import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:eung_shop_app/features/category/data/category_catalog.dart';
import 'package:eung_shop_app/features/product/data/mock_products.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';
import 'package:eung_shop_app/features/product/domain/product_filter.dart';
import 'package:eung_shop_app/shared/utils/hangul_search.dart';

part 'product_providers.g.dart';

@riverpod
class ProductFilterController extends _$ProductFilterController {
  @override
  ProductFilter build({
    required String categoryId,
    required bool includeChildren,
  }) {
    return ProductFilter(categoryId: categoryId);
  }

  void setSort(ProductSort sort) {
    state = state.copyWith(sort: sort);
  }

  void toggleSize(String size) {
    final sizes = {...state.sizes};
    sizes.contains(size) ? sizes.remove(size) : sizes.add(size);
    state = state.copyWith(sizes: sizes);
  }

  void toggleColor(String color) {
    final colors = {...state.colors};
    colors.contains(color) ? colors.remove(color) : colors.add(color);
    state = state.copyWith(colors: colors);
  }

  void toggleBrand(String brand) {
    final brands = {...state.brands};
    brands.contains(brand) ? brands.remove(brand) : brands.add(brand);
    state = state.copyWith(brands: brands);
  }

  void setPriceRange({int? minPrice, int? maxPrice}) {
    state = state.copyWith(minPrice: minPrice, maxPrice: maxPrice);
  }

  void setDiscountOnly(bool value) {
    state = state.copyWith(discountOnly: value);
  }

  void setInStockOnly(bool value) {
    state = state.copyWith(inStockOnly: value);
  }

  void apply(ProductFilter filter) {
    state = filter;
  }

  void clearFilters() {
    state = ProductFilter(categoryId: state.categoryId, sort: state.sort);
  }
}

@riverpod
List<Product> productList(
  Ref ref, {
  required String categoryId,
  required bool includeChildren,
}) {
  final filter = ref.watch(
    productFilterControllerProvider(
      categoryId: categoryId,
      includeChildren: includeChildren,
    ),
  );
  final categoryIds = categoryIdsForSelection(
    categoryId,
    includeChildren: includeChildren,
  );

  final products = mockProducts
      .where((product) => categoryIds.contains(product.categoryId))
      .where((product) => _matchesFilter(product, filter))
      .toList();

  _sortProducts(products, filter.sort);
  return products;
}

@riverpod
ProductFilterOptions productFilterOptions(
  Ref ref, {
  required String categoryId,
  required bool includeChildren,
}) {
  final categoryIds = categoryIdsForSelection(
    categoryId,
    includeChildren: includeChildren,
  );
  final products = mockProducts
      .where((product) => categoryIds.contains(product.categoryId))
      .toList();

  final sizes = products.expand((product) => product.sizes).toSet().toList()
    ..sort();
  final colors = products.expand((product) => product.colors).toSet().toList()
    ..sort();
  final brands = products.map((product) => product.brand).toSet().toList()
    ..sort();
  final prices = products.map((product) => product.price).toList();

  return ProductFilterOptions(
    sizes: sizes,
    colors: colors,
    brands: brands,
    minPrice: prices.isEmpty ? 0 : prices.reduce((a, b) => a < b ? a : b),
    maxPrice: prices.isEmpty ? 0 : prices.reduce((a, b) => a > b ? a : b),
  );
}

@riverpod
Product? productById(Ref ref, String productId) {
  for (final product in mockProducts) {
    if (product.id == productId) return product;
  }

  return null;
}

@riverpod
List<Product> relatedProducts(Ref ref, String productId) {
  final currentProduct = ref.watch(productByIdProvider(productId));
  if (currentProduct == null) return const [];

  final sameCategoryProducts =
      mockProducts
          .where(
            (product) =>
                product.id != currentProduct.id &&
                product.categoryId == currentProduct.categoryId,
          )
          .toList()
        ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));

  if (sameCategoryProducts.length >= 4) {
    return sameCategoryProducts.take(4).toList(growable: false);
  }

  final fallbackProducts =
      mockProducts
          .where(
            (product) =>
                product.id != currentProduct.id &&
                product.categoryId != currentProduct.categoryId,
          )
          .toList()
        ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));

  return [
    ...sameCategoryProducts,
    ...fallbackProducts,
  ].take(4).toList(growable: false);
}

@riverpod
List<Product> newProducts(Ref ref) {
  final products = [...mockProducts]
    ..sort((a, b) {
      final newCompare = (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0);
      if (newCompare != 0) return newCompare;
      return b.id.compareTo(a.id);
    });

  return products.take(6).toList(growable: false);
}

@riverpod
List<Product> popularProducts(Ref ref) {
  final products = [...mockProducts]
    ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));

  return products.take(6).toList(growable: false);
}

@riverpod
List<Product> searchedProducts(Ref ref, String query) {
  final keyword = query.trim();
  if (keyword.isEmpty) return const [];

  final products = mockProducts.where((product) {
    final searchText = [
      product.brand,
      product.name,
      categorySearchTextForId(product.categoryId),
    ].join(' ');

    return matchesHangulKeyword(searchText, keyword);
  }).toList();

  _sortProducts(products, ProductSort.popularity);
  return products;
}

bool _matchesFilter(Product product, ProductFilter filter) {
  if (filter.sizes.isNotEmpty &&
      !product.sizes.any((size) => filter.sizes.contains(size))) {
    return false;
  }

  if (filter.colors.isNotEmpty &&
      !product.colors.any((color) => filter.colors.contains(color))) {
    return false;
  }

  if (filter.brands.isNotEmpty && !filter.brands.contains(product.brand)) {
    return false;
  }

  if (filter.minPrice != null && product.price < filter.minPrice!) {
    return false;
  }

  if (filter.maxPrice != null && product.price > filter.maxPrice!) {
    return false;
  }

  if (filter.discountOnly && product.discountRate == null) {
    return false;
  }

  if (filter.inStockOnly && !product.isInStock) {
    return false;
  }

  final keyword = filter.keyword;
  if (keyword != null) {
    final normalizedKeyword = keyword.toLowerCase();
    final target = '${product.brand} ${product.name}'.toLowerCase();
    if (!target.contains(normalizedKeyword)) return false;
  }

  return true;
}

void _sortProducts(List<Product> products, ProductSort sort) {
  switch (sort) {
    case ProductSort.newest:
      products.sort((a, b) {
        final newCompare = (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0);
        if (newCompare != 0) return newCompare;
        return b.id.compareTo(a.id);
      });
    case ProductSort.priceLowToHigh:
      products.sort((a, b) => a.price.compareTo(b.price));
    case ProductSort.priceHighToLow:
      products.sort((a, b) => b.price.compareTo(a.price));
    case ProductSort.popularity:
      products.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    case ProductSort.rating:
      products.sort((a, b) => b.rating.compareTo(a.rating));
  }
}
