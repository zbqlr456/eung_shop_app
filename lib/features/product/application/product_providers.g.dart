// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductFilterController)
final productFilterControllerProvider = ProductFilterControllerFamily._();

final class ProductFilterControllerProvider
    extends $NotifierProvider<ProductFilterController, ProductFilter> {
  ProductFilterControllerProvider._({
    required ProductFilterControllerFamily super.from,
    required ({String categoryId, bool includeChildren}) super.argument,
  }) : super(
         retry: null,
         name: r'productFilterControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productFilterControllerHash();

  @override
  String toString() {
    return r'productFilterControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ProductFilterController create() => ProductFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductFilter>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductFilterControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productFilterControllerHash() =>
    r'354cd664c7580ee460e35809d96e218d27c131b0';

final class ProductFilterControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductFilterController,
          ProductFilter,
          ProductFilter,
          ProductFilter,
          ({String categoryId, bool includeChildren})
        > {
  ProductFilterControllerFamily._()
    : super(
        retry: null,
        name: r'productFilterControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductFilterControllerProvider call({
    required String categoryId,
    required bool includeChildren,
  }) => ProductFilterControllerProvider._(
    argument: (categoryId: categoryId, includeChildren: includeChildren),
    from: this,
  );

  @override
  String toString() => r'productFilterControllerProvider';
}

abstract class _$ProductFilterController extends $Notifier<ProductFilter> {
  late final _$args = ref.$arg as ({String categoryId, bool includeChildren});
  String get categoryId => _$args.categoryId;
  bool get includeChildren => _$args.includeChildren;

  ProductFilter build({
    required String categoryId,
    required bool includeChildren,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProductFilter, ProductFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProductFilter, ProductFilter>,
              ProductFilter,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        categoryId: _$args.categoryId,
        includeChildren: _$args.includeChildren,
      ),
    );
  }
}

@ProviderFor(productList)
final productListProvider = ProductListFamily._();

final class ProductListProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  ProductListProvider._({
    required ProductListFamily super.from,
    required ({String categoryId, bool includeChildren}) super.argument,
  }) : super(
         retry: null,
         name: r'productListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productListHash();

  @override
  String toString() {
    return r'productListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    final argument =
        this.argument as ({String categoryId, bool includeChildren});
    return productList(
      ref,
      categoryId: argument.categoryId,
      includeChildren: argument.includeChildren,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productListHash() => r'1f2a3bdbf4fc30a89ff584ca464781f6d429b680';

final class ProductListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          List<Product>,
          ({String categoryId, bool includeChildren})
        > {
  ProductListFamily._()
    : super(
        retry: null,
        name: r'productListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductListProvider call({
    required String categoryId,
    required bool includeChildren,
  }) => ProductListProvider._(
    argument: (categoryId: categoryId, includeChildren: includeChildren),
    from: this,
  );

  @override
  String toString() => r'productListProvider';
}

@ProviderFor(productFilterOptions)
final productFilterOptionsProvider = ProductFilterOptionsFamily._();

final class ProductFilterOptionsProvider
    extends
        $FunctionalProvider<
          ProductFilterOptions,
          ProductFilterOptions,
          ProductFilterOptions
        >
    with $Provider<ProductFilterOptions> {
  ProductFilterOptionsProvider._({
    required ProductFilterOptionsFamily super.from,
    required ({String categoryId, bool includeChildren}) super.argument,
  }) : super(
         retry: null,
         name: r'productFilterOptionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productFilterOptionsHash();

  @override
  String toString() {
    return r'productFilterOptionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<ProductFilterOptions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductFilterOptions create(Ref ref) {
    final argument =
        this.argument as ({String categoryId, bool includeChildren});
    return productFilterOptions(
      ref,
      categoryId: argument.categoryId,
      includeChildren: argument.includeChildren,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductFilterOptions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductFilterOptions>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductFilterOptionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productFilterOptionsHash() =>
    r'757613f1cbdbd1f394daf03d16674ff36eab0831';

final class ProductFilterOptionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          ProductFilterOptions,
          ({String categoryId, bool includeChildren})
        > {
  ProductFilterOptionsFamily._()
    : super(
        retry: null,
        name: r'productFilterOptionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductFilterOptionsProvider call({
    required String categoryId,
    required bool includeChildren,
  }) => ProductFilterOptionsProvider._(
    argument: (categoryId: categoryId, includeChildren: includeChildren),
    from: this,
  );

  @override
  String toString() => r'productFilterOptionsProvider';
}

@ProviderFor(productById)
final productByIdProvider = ProductByIdFamily._();

final class ProductByIdProvider
    extends $FunctionalProvider<Product?, Product?, Product?>
    with $Provider<Product?> {
  ProductByIdProvider._({
    required ProductByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productByIdHash();

  @override
  String toString() {
    return r'productByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Product?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Product? create(Ref ref) {
    final argument = this.argument as String;
    return productById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Product? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Product?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productByIdHash() => r'ef064d627c92f15e62dbecf6360529e5290f4efd';

final class ProductByIdFamily extends $Family
    with $FunctionalFamilyOverride<Product?, String> {
  ProductByIdFamily._()
    : super(
        retry: null,
        name: r'productByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductByIdProvider call(String productId) =>
      ProductByIdProvider._(argument: productId, from: this);

  @override
  String toString() => r'productByIdProvider';
}
