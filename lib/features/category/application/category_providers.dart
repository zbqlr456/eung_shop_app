import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:eung_shop_app/features/category/data/category_catalog.dart';
import 'package:eung_shop_app/features/category/domain/category.dart';

part 'category_providers.g.dart';

@riverpod
class SelectedCategoryAudience extends _$SelectedCategoryAudience {
  @override
  CategoryAudience build() => CategoryAudience.all;

  void select(CategoryAudience audience) {
    state = audience;
  }
}

@riverpod
List<CategorySection> categorySections(Ref ref) {
  final audience = ref.watch(selectedCategoryAudienceProvider);
  return categorySectionsForAudience(audience);
}
