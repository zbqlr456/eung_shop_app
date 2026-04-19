import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/wishlist/domain/wishlist_item.dart';

part 'wishlist_providers.g.dart';

@Riverpod(keepAlive: true)
class Wishlist extends _$Wishlist {
  @override
  List<WishlistItem> build() => const [];

  bool isWishlisted({required String userId, required String productId}) {
    return state.any(
      (item) => item.userId == userId && item.productId == productId,
    );
  }

  void toggle({required String userId, required String productId}) {
    if (isWishlisted(userId: userId, productId: productId)) {
      remove(userId: userId, productId: productId);
      return;
    }

    add(userId: userId, productId: productId);
  }

  void add({required String userId, required String productId}) {
    if (isWishlisted(userId: userId, productId: productId)) return;

    final item = WishlistItem(
      userId: userId,
      productId: productId,
      createdAt: DateTime.now(),
    );
    state = [item, ...state];
  }

  void remove({required String userId, required String productId}) {
    state = state
        .where((item) => item.userId != userId || item.productId != productId)
        .toList(growable: false);
  }
}

@Riverpod(keepAlive: true)
List<String> currentUserWishlistProductIds(Ref ref) {
  final currentUser = ref.watch(authControllerProvider).currentUser;
  if (currentUser == null) return const [];

  final items = ref.watch(wishlistProvider);
  return [
    for (final item in items)
      if (item.userId == currentUser.id) item.productId,
  ];
}
