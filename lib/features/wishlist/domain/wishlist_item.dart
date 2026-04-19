class WishlistItem {
  const WishlistItem({
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  final String userId;
  final String productId;
  final DateTime createdAt;

  String get id => '$userId|$productId';
}
