import 'package:eung_shop_app/features/home/presentation/home_page.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
