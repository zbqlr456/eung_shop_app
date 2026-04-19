// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedCategoryAudience)
final selectedCategoryAudienceProvider = SelectedCategoryAudienceProvider._();

final class SelectedCategoryAudienceProvider
    extends $NotifierProvider<SelectedCategoryAudience, CategoryAudience> {
  SelectedCategoryAudienceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryAudienceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryAudienceHash();

  @$internal
  @override
  SelectedCategoryAudience create() => SelectedCategoryAudience();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryAudience value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryAudience>(value),
    );
  }
}

String _$selectedCategoryAudienceHash() =>
    r'04328b5e620d67537b875f7378dd77023c4c9ba3';

abstract class _$SelectedCategoryAudience extends $Notifier<CategoryAudience> {
  CategoryAudience build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CategoryAudience, CategoryAudience>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CategoryAudience, CategoryAudience>,
              CategoryAudience,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(categorySections)
final categorySectionsProvider = CategorySectionsProvider._();

final class CategorySectionsProvider
    extends
        $FunctionalProvider<
          List<CategorySection>,
          List<CategorySection>,
          List<CategorySection>
        >
    with $Provider<List<CategorySection>> {
  CategorySectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categorySectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categorySectionsHash();

  @$internal
  @override
  $ProviderElement<List<CategorySection>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<CategorySection> create(Ref ref) {
    return categorySections(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CategorySection> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CategorySection>>(value),
    );
  }
}

String _$categorySectionsHash() => r'0257e843f5710526b79e09d57537f8f53e7c2e9f';
