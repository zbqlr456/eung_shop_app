import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:eung_shop_app/features/cart/domain/cart_item.dart';

part 'cart_providers.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  List<CartItem> build() => const [];

  void add({
    required String productId,
    required String color,
    required String size,
    int quantity = 1,
  }) {
    final newItem = CartItem(
      productId: productId,
      color: color,
      size: size,
      quantity: quantity,
    );
    final index = state.indexWhere((item) => item.id == newItem.id);

    if (index == -1) {
      state = [...state, newItem];
      return;
    }

    state = [
      for (var i = 0; i < state.length; i += 1)
        if (i == index)
          state[i].copyWith(quantity: state[i].quantity + quantity)
        else
          state[i],
    ];
  }

  void increase(String itemId) {
    state = [
      for (final item in state)
        if (item.id == itemId)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ];
  }

  void decrease(String itemId) {
    state = [
      for (final item in state)
        if (item.id == itemId && item.quantity > 1)
          item.copyWith(quantity: item.quantity - 1)
        else
          item,
    ];
  }

  void remove(String itemId) {
    state = state.where((item) => item.id != itemId).toList(growable: false);
  }

  void clear() {
    state = const [];
  }
}

@riverpod
int cartTotalQuantity(Ref ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (total, item) => total + item.quantity);
}
