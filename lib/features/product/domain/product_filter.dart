enum ProductSort { newest, priceLowToHigh, priceHighToLow, popularity, rating }

extension ProductSortLabel on ProductSort {
  String get label {
    return switch (this) {
      ProductSort.newest => '최신순',
      ProductSort.priceLowToHigh => '낮은 가격순',
      ProductSort.priceHighToLow => '높은 가격순',
      ProductSort.popularity => '인기순',
      ProductSort.rating => '평점순',
    };
  }
}

class ProductFilter {
  ProductFilter({
    this.categoryId,
    Iterable<String> sizes = const [],
    Iterable<String> colors = const [],
    Iterable<String> brands = const [],
    this.minPrice,
    this.maxPrice,
    this.sort = ProductSort.newest,
    this.inStockOnly = false,
    this.discountOnly = false,
    String? keyword,
  }) : sizes = _normalizeSet(sizes),
       colors = _normalizeSet(colors),
       brands = _normalizeSet(brands),
       keyword = _normalizeKeyword(keyword);

  final String? categoryId;
  final Set<String> sizes;
  final Set<String> colors;
  final Set<String> brands;
  final int? minPrice;
  final int? maxPrice;
  final ProductSort sort;
  final bool inStockOnly;
  final bool discountOnly;
  final String? keyword;

  static final ProductFilter empty = ProductFilter();

  bool get hasPriceRange => minPrice != null || maxPrice != null;

  int get activeFilterCount {
    var count = sizes.length + colors.length + brands.length;
    if (hasPriceRange) count += 1;
    if (inStockOnly) count += 1;
    if (discountOnly) count += 1;
    if (keyword != null) count += 1;
    return count;
  }

  bool get isEmpty =>
      categoryId == null &&
      sizes.isEmpty &&
      colors.isEmpty &&
      brands.isEmpty &&
      minPrice == null &&
      maxPrice == null &&
      sort == ProductSort.newest &&
      !inStockOnly &&
      !discountOnly &&
      keyword == null;

  ProductFilter copyWith({
    Object? categoryId = _sentinel,
    Iterable<String>? sizes,
    Iterable<String>? colors,
    Iterable<String>? brands,
    Object? minPrice = _sentinel,
    Object? maxPrice = _sentinel,
    ProductSort? sort,
    bool? inStockOnly,
    bool? discountOnly,
    Object? keyword = _sentinel,
  }) {
    return ProductFilter(
      categoryId: categoryId == _sentinel
          ? this.categoryId
          : categoryId as String?,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      brands: brands ?? this.brands,
      minPrice: minPrice == _sentinel ? this.minPrice : minPrice as int?,
      maxPrice: maxPrice == _sentinel ? this.maxPrice : maxPrice as int?,
      sort: sort ?? this.sort,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      discountOnly: discountOnly ?? this.discountOnly,
      keyword: keyword == _sentinel ? this.keyword : keyword as String?,
    );
  }

  ProductFilter clearAll() => ProductFilter();

  Map<String, String> toQueryParameters() {
    final query = <String, String>{};

    if (categoryId != null) query['categoryId'] = categoryId!;
    if (sizes.isNotEmpty) query['sizes'] = _stableCsv(sizes);
    if (colors.isNotEmpty) query['colors'] = _stableCsv(colors);
    if (brands.isNotEmpty) query['brands'] = _stableCsv(brands);
    if (minPrice != null) query['minPrice'] = '$minPrice';
    if (maxPrice != null) query['maxPrice'] = '$maxPrice';
    if (sort != ProductSort.newest) query['sort'] = sort.name;
    if (inStockOnly) query['inStockOnly'] = 'true';
    if (discountOnly) query['discountOnly'] = 'true';
    if (keyword != null) query['q'] = keyword!;

    return query;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProductFilter &&
            other.categoryId == categoryId &&
            _setEquals(other.sizes, sizes) &&
            _setEquals(other.colors, colors) &&
            _setEquals(other.brands, brands) &&
            other.minPrice == minPrice &&
            other.maxPrice == maxPrice &&
            other.sort == sort &&
            other.inStockOnly == inStockOnly &&
            other.discountOnly == discountOnly &&
            other.keyword == keyword;
  }

  @override
  int get hashCode {
    return Object.hash(
      categoryId,
      Object.hashAll(sizes.toList()..sort()),
      Object.hashAll(colors.toList()..sort()),
      Object.hashAll(brands.toList()..sort()),
      minPrice,
      maxPrice,
      sort,
      inStockOnly,
      discountOnly,
      keyword,
    );
  }

  static Set<String> _normalizeSet(Iterable<String> values) {
    final normalized = values
        .map((v) => v.trim())
        .where((v) => v.isNotEmpty)
        .toSet();
    return Set.unmodifiable(normalized);
  }

  static String? _normalizeKeyword(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _stableCsv(Set<String> values) {
    final sorted = values.toList()..sort();
    return sorted.join(',');
  }

  static bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    for (final item in a) {
      if (!b.contains(item)) return false;
    }
    return true;
  }
}

const _sentinel = Object();

class ProductFilterOptions {
  const ProductFilterOptions({
    required this.sizes,
    required this.colors,
    required this.brands,
    required this.minPrice,
    required this.maxPrice,
  });

  final List<String> sizes;
  final List<String> colors;
  final List<String> brands;
  final int minPrice;
  final int maxPrice;
}
