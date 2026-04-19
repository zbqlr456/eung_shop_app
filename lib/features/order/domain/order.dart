class Order {
  const Order({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalPrice,
  });

  final String id;
  final String userId;
  final DateTime createdAt;
  final OrderStatus status;
  final List<OrderLineItem> items;
  final OrderShippingAddress shippingAddress;
  final OrderPaymentMethod paymentMethod;
  final int subtotal;
  final int deliveryFee;
  final int totalPrice;

  int get totalQuantity {
    return items.fold(0, (total, item) => total + item.quantity);
  }
}

class OrderLineItem {
  const OrderLineItem({
    required this.productId,
    required this.brand,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.color,
    required this.size,
    required this.quantity,
  });

  final String productId;
  final String brand;
  final String name;
  final String imageUrl;
  final int unitPrice;
  final String color;
  final String size;
  final int quantity;

  int get totalPrice => unitPrice * quantity;
}

class OrderShippingAddress {
  const OrderShippingAddress({
    required this.recipient,
    required this.phone,
    required this.address,
    required this.memo,
  });

  final String recipient;
  final String phone;
  final String address;
  final String memo;
}

enum OrderPaymentMethod {
  card('신용카드'),
  simplePay('간편결제'),
  bankTransfer('무통장입금');

  const OrderPaymentMethod(this.label);

  final String label;
}

enum OrderStatus {
  paid('결제 완료'),
  preparing('상품 준비중'),
  shipping('배송중'),
  delivered('배송 완료'),
  canceled('주문 취소');

  const OrderStatus(this.label);

  final String label;
}
