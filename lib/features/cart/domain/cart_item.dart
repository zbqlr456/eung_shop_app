class CartItem {
  const CartItem({
    required this.productId,
    required this.color,
    required this.size,
    this.quantity = 1,
  });

  final String productId;
  final String color;
  final String size;
  final int quantity;

  String get id => '$productId|$color|$size';

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      color: color,
      size: size,
      quantity: quantity ?? this.quantity,
    );
  }
}
