// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderHistory)
final orderHistoryProvider = OrderHistoryProvider._();

final class OrderHistoryProvider
    extends $NotifierProvider<OrderHistory, List<Order>> {
  OrderHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderHistoryHash();

  @$internal
  @override
  OrderHistory create() => OrderHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Order> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Order>>(value),
    );
  }
}

String _$orderHistoryHash() => r'f568e7874a180eb5989e8e006acd845d7f38caa2';

abstract class _$OrderHistory extends $Notifier<List<Order>> {
  List<Order> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Order>, List<Order>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Order>, List<Order>>,
              List<Order>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(currentUserOrders)
final currentUserOrdersProvider = CurrentUserOrdersProvider._();

final class CurrentUserOrdersProvider
    extends $FunctionalProvider<List<Order>, List<Order>, List<Order>>
    with $Provider<List<Order>> {
  CurrentUserOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserOrdersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserOrdersHash();

  @$internal
  @override
  $ProviderElement<List<Order>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Order> create(Ref ref) {
    return currentUserOrders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Order> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Order>>(value),
    );
  }
}

String _$currentUserOrdersHash() => r'ec0602f2c86346208cd2b6bc369741ef0e9cdf29';
