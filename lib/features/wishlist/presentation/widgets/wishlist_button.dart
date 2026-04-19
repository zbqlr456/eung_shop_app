import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/wishlist/application/wishlist_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WishlistButton extends HookConsumerWidget {
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
    final scaleController = useAnimationController(
      duration: const Duration(milliseconds: 130),
      reverseDuration: const Duration(milliseconds: 110),
    );
    final scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.easeOutBack),
    );
    final currentUser = ref.watch(authControllerProvider).currentUser;
    final wishlistProductIds = ref.watch(currentUserWishlistProductIdsProvider);
    final isWishlisted = wishlistProductIds.contains(productId);
    final colorScheme = Theme.of(context).colorScheme;
    final tooltip = isWishlisted ? '\uCC1C \uD574\uC81C' : '\uCC1C\uD558\uAE30';

    void onPressed() {
      scaleController.forward(from: 0).then((_) => scaleController.reverse());

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
            content: Text(
              isWishlisted
                  ? '\uCC1C\uD55C \uC0C1\uD488\uC5D0\uC11C \uC0AD\uC81C\uD588\uC5B4\uC694.'
                  : '\uCC1C\uD55C \uC0C1\uD488\uC5D0 \uCD94\uAC00\uD588\uC5B4\uC694.',
            ),
          ),
        );
    }

    return IconButton(
      onPressed: onPressed,
      icon: ScaleTransition(
        scale: scaleAnimation,
        child: isWishlisted
            ? Icon(Icons.favorite, color: colorScheme.error)
            : Icon(Icons.favorite_border, color: colorScheme.onPrimary),
      ),
      tooltip: tooltip,
      constraints: const BoxConstraints.tightFor(width: 32, height: 40),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      style:
          IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ).copyWith(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
    );
  }

  String _redirectPath(BuildContext context) {
    final path = redirectPath;
    if (path != null && path.isNotEmpty) return path;

    return GoRouterState.of(context).uri.toString();
  }
}
