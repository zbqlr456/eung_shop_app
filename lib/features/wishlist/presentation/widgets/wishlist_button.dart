import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/wishlist/application/wishlist_providers.dart';

class WishlistButton extends ConsumerWidget {
  const WishlistButton({
    super.key,
    required this.productId,
    this.redirectPath,
    this.filled = false,
  });

  final String productId;
  final String? redirectPath;
  final bool filled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider).currentUser;
    final wishlistProductIds = ref.watch(currentUserWishlistProductIdsProvider);
    final isWishlisted = wishlistProductIds.contains(productId);
    final icon = Icon(
      isWishlisted ? Icons.favorite : Icons.favorite_border,
      color: isWishlisted ? Theme.of(context).colorScheme.error : null,
    );
    final tooltip = isWishlisted ? '찜 해제' : '찜하기';

    void onPressed() {
      final user = currentUser;
      if (user == null) {
        context.pushNamed(
          RouteNames.login,
          queryParameters: {'redirect': _redirectPath(context)},
        );
        return;
      }

      ref
          .read(wishlistProvider.notifier)
          .toggle(userId: user.id, productId: productId);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(isWishlisted ? '찜한 상품에서 삭제했어요.' : '찜한 상품에 추가했어요.'),
          ),
        );
    }

    if (filled) {
      return IconButton.filledTonal(
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
      );
    }

    return IconButton(onPressed: onPressed, icon: icon, tooltip: tooltip);
  }

  String _redirectPath(BuildContext context) {
    final path = redirectPath;
    if (path != null && path.isNotEmpty) return path;

    return GoRouterState.of(context).uri.toString();
  }
}
