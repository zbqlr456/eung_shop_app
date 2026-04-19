import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/order/application/order_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider).currentUser;
    final orders = ref.watch(currentUserOrdersProvider);
    final orderCount = orders.length;
    final totalOrderQuantity = orders.fold(
      0,
      (total, order) => total + order.totalQuantity,
    );

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('마이페이지')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              Text(
                '로그인이 필요해요',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '주문 내역과 배송 정보를 내 계정으로 관리할 수 있어요.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () => context.pushNamed(RouteNames.login),
                child: const Text('로그인'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.pushNamed(RouteNames.signup),
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Text(
            '${currentUser.name}님, 안녕하세요',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            orderCount == 0
                ? '첫 주문을 기다리고 있어요.'
                : '최근 주문 $orderCount건, 상품 $totalOrderQuantity개가 있어요.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentUser.email,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          _ProfileMenuTile(
            icon: Icons.receipt_long_outlined,
            title: '주문 내역',
            subtitle: orderCount == 0 ? '아직 주문한 상품이 없습니다.' : '$orderCount건의 주문',
            onTap: () => context.pushNamed(RouteNames.orderHistory),
          ),
          const SizedBox(height: 12),
          _ProfileMenuTile(
            icon: Icons.logout,
            title: '로그아웃',
            subtitle: '현재 계정에서 나가기',
            onTap: ref.read(authControllerProvider.notifier).logout,
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
