import 'package:eung_shop_app/app/shell/main_shell.dart';
import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/product/presentation/product_detail_page.dart';
import 'package:eung_shop_app/features/product/presentation/product_list_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: RoutePaths.productList,
      name: RouteNames.productList,
      builder: (context, state) {
        final query = state.uri.queryParameters;
        final categoryId = query['categoryId'] ?? '';
        final categoryTitle = query['title'] ?? '상품';
        final includeChildren = query['includeChildren'] != 'false';

        return ProductListPage(
          categoryId: categoryId,
          categoryTitle: categoryTitle,
          includeChildren: includeChildren,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.productDetail,
      name: RouteNames.productDetail,
      builder: (context, state) {
        final productId = state.pathParameters['productId'] ?? '';
        return ProductDetailPage(productId: productId);
      },
    ),
  ],
);
