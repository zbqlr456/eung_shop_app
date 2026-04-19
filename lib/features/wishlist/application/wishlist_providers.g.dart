// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Wishlist)
final wishlistProvider = WishlistProvider._();

final class WishlistProvider
    extends $NotifierProvider<Wishlist, List<WishlistItem>> {
  WishlistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistHash();

  @$internal
  @override
  Wishlist create() => Wishlist();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WishlistItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WishlistItem>>(value),
    );
  }
}

String _$wishlistHash() => r'84479c3d308090c132b32bb77255849333fe05f1';

abstract class _$Wishlist extends $Notifier<List<WishlistItem>> {
  List<WishlistItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<WishlistItem>, List<WishlistItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<WishlistItem>, List<WishlistItem>>,
              List<WishlistItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(currentUserWishlistProductIds)
final currentUserWishlistProductIdsProvider =
    CurrentUserWishlistProductIdsProvider._();

final class CurrentUserWishlistProductIdsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  CurrentUserWishlistProductIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserWishlistProductIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserWishlistProductIdsHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return currentUserWishlistProductIds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$currentUserWishlistProductIdsHash() =>
    r'5e123669f4cb01f90a8ace2fa95ee5b30d074873';
