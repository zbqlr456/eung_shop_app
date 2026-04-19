import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/cart/domain/cart_item.dart';
import 'package:eung_shop_app/features/order/domain/order.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';

part 'order_providers.g.dart';

@Riverpod(keepAlive: true)
class OrderHistory extends _$OrderHistory {
  @override
  List<Order> build() => const [];

  Order createOrder({
    required String userId,
    required List<CartItem> cartItems,
    required Map<String, Product?> productsById,
    required OrderShippingAddress shippingAddress,
    required OrderPaymentMethod paymentMethod,
    required int subtotal,
    required int deliveryFee,
    required int totalPrice,
  }) {
    final now = DateTime.now();
    final items = [
      for (final cartItem in cartItems)
        if (productsById[cartItem.productId] case final product?)
          OrderLineItem(
            productId: product.id,
            brand: product.brand,
            name: product.name,
            imageUrl: product.imageUrl,
            unitPrice: product.price,
            color: cartItem.color,
            size: cartItem.size,
            quantity: cartItem.quantity,
          ),
    ];

    final order = Order(
      id: _createOrderId(now),
      userId: userId,
      createdAt: now,
      status: OrderStatus.paid,
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      totalPrice: totalPrice,
    );

    state = [order, ...state];
    return order;
  }
}

@Riverpod(keepAlive: true)
List<Order> currentUserOrders(Ref ref) {
  final currentUser = ref.watch(authControllerProvider).currentUser;
  if (currentUser == null) {
    return const [];
  }

  final orders = ref.watch(orderHistoryProvider);
  return orders
      .where((order) => order.userId == currentUser.id)
      .toList(growable: false);
}

String _createOrderId(DateTime dateTime) {
  return 'ORD-${dateTime.millisecondsSinceEpoch}';
}
