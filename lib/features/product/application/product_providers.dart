import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:eung_shop_app/features/category/data/category_catalog.dart';
import 'package:eung_shop_app/features/product/data/mock_products.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';

part 'product_providers.g.dart';

@riverpod
List<Product> productList(
  Ref ref, {
  required String categoryId,
  required bool includeChildren,
}) {
  final categoryIds = categoryIdsForSelection(
    categoryId,
    includeChildren: includeChildren,
  );

  return mockProducts
      .where((product) => categoryIds.contains(product.categoryId))
      .toList(growable: false);
}

@riverpod
Product? productById(Ref ref, String productId) {
  for (final product in mockProducts) {
    if (product.id == productId) return product;
  }

  return null;
}
