import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';
import 'package:eung_shop_app/features/cart/application/cart_providers.dart';
import 'package:eung_shop_app/features/cart/domain/cart_item.dart';
import 'package:eung_shop_app/features/order/application/order_providers.dart';
import 'package:eung_shop_app/features/order/domain/order.dart';
import 'package:eung_shop_app/features/product/application/product_providers.dart';
import 'package:eung_shop_app/features/product/domain/product.dart';
import 'package:eung_shop_app/features/product/presentation/product_formatters.dart';

class CheckoutPage extends HookConsumerWidget {
  const CheckoutPage({super.key});

  static const _freeShippingThreshold = 30000;
  static const _deliveryFee = 3000;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final currentUser = ref.watch(authControllerProvider).currentUser;
    final productsById = {
      for (final item in items)
        item.productId: ref.watch(productByIdProvider(item.productId)),
    };
    final subtotal = _subtotal(items, productsById);
    final deliveryFee = subtotal == 0 || subtotal >= _freeShippingThreshold
        ? 0
        : _deliveryFee;
    final totalPrice = subtotal + deliveryFee;

    final recipientController = useTextEditingController();
    final phoneController = useTextEditingController();
    final addressController = useTextEditingController();
    final memoController = useTextEditingController();
    final selectedPaymentMethod = useState(OrderPaymentMethod.card);

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('주문서')),
        body: const Center(child: Text('주문할 상품이 없습니다.')),
      );
    }

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('주문서')),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '로그인이 필요해요',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '주문과 배송 내역을 계정에 안전하게 저장할게요.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.login,
                        queryParameters: {'redirect': RoutePaths.checkout},
                      );
                    },
                    child: const Text('로그인하고 주문하기'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('주문서')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _CheckoutSection(
              title: '주문 상품',
              child: Column(
                children: [
                  for (var index = 0; index < items.length; index += 1) ...[
                    _OrderItemRow(
                      item: items[index],
                      product: productsById[items[index].productId],
                    ),
                    if (index != items.length - 1) const Divider(height: 28),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            _CheckoutSection(
              title: '배송지',
              child: Column(
                children: [
                  _CheckoutTextField(
                    key: const ValueKey('checkoutRecipientField'),
                    controller: recipientController,
                    label: '받는 분',
                    hintText: '이름을 입력해주세요',
                  ),
                  const SizedBox(height: 12),
                  _CheckoutTextField(
                    key: const ValueKey('checkoutPhoneField'),
                    controller: phoneController,
                    label: '연락처',
                    hintText: '010-0000-0000',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _CheckoutTextField(
                    key: const ValueKey('checkoutAddressField'),
                    controller: addressController,
                    label: '주소',
                    hintText: '배송 받을 주소를 입력해주세요',
                  ),
                  const SizedBox(height: 12),
                  _CheckoutTextField(
                    key: const ValueKey('checkoutMemoField'),
                    controller: memoController,
                    label: '배송 요청사항',
                    hintText: '문 앞에 놓아주세요',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _CheckoutSection(
              title: '결제수단',
              child: _PaymentMethodSelector(
                selectedMethod: selectedPaymentMethod.value,
                onSelected: (method) {
                  selectedPaymentMethod.value = method;
                },
              ),
            ),
            const SizedBox(height: 24),
            _CheckoutSection(
              title: '결제 금액',
              child: _PaymentSummary(
                subtotal: subtotal,
                deliveryFee: deliveryFee,
                totalPrice: totalPrice,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: FilledButton(
            onPressed: () async {
              final hasShippingInfo =
                  recipientController.text.trim().isNotEmpty &&
                  phoneController.text.trim().isNotEmpty &&
                  addressController.text.trim().isNotEmpty;

              if (!hasShippingInfo) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('배송 정보를 모두 입력해주세요.')),
                  );
                return;
              }

              if (subtotal == 0) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('주문 가능한 상품이 없습니다.')),
                  );
                return;
              }

              final order = ref
                  .read(orderHistoryProvider.notifier)
                  .createOrder(
                    userId: currentUser.id,
                    cartItems: items,
                    productsById: productsById,
                    shippingAddress: OrderShippingAddress(
                      recipient: recipientController.text.trim(),
                      phone: phoneController.text.trim(),
                      address: addressController.text.trim(),
                      memo: memoController.text.trim(),
                    ),
                    paymentMethod: selectedPaymentMethod.value,
                    subtotal: subtotal,
                    deliveryFee: deliveryFee,
                    totalPrice: totalPrice,
                  );

              ref.read(cartProvider.notifier).clear();
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('주문이 완료되었습니다.'),
                    content: Text(
                      '주문번호 ${order.id}\n'
                      '${formatPrice(totalPrice)}원 결제가 접수되었어요.',
                    ),
                    actions: [
                      FilledButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('확인'),
                      ),
                    ],
                  );
                },
              );

              if (context.mounted) {
                context.go(RoutePaths.home);
              }
            },
            child: Text('${formatPrice(totalPrice)}원 결제하기'),
          ),
        ),
      ),
    );
  }

  static int _subtotal(
    List<CartItem> items,
    Map<String, Product?> productsById,
  ) {
    return items.fold(0, (total, item) {
      final product = productsById[item.productId];
      if (product == null) return total;
      return total + (product.price * item.quantity);
    });
  }
}

class _CheckoutSection extends StatelessWidget {
  const _CheckoutSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ],
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item, required this.product});

  final CartItem item;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    final product = this.product;

    if (product == null) {
      return const ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text('상품을 찾을 수 없습니다.'),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 64,
            height: 84,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.brand,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${item.color} / ${item.size} · ${item.quantity}개',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${formatPrice(product.price * item.quantity)}원',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckoutTextField extends StatelessWidget {
  const _CheckoutTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  const _PaymentMethodSelector({
    required this.selectedMethod,
    required this.onSelected,
  });

  final OrderPaymentMethod selectedMethod;
  final ValueChanged<OrderPaymentMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final method in OrderPaymentMethod.values)
          ChoiceChip(
            label: Text(method.label),
            selected: method == selectedMethod,
            onSelected: (_) => onSelected(method),
          ),
      ],
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({
    required this.subtotal,
    required this.deliveryFee,
    required this.totalPrice,
  });

  final int subtotal;
  final int deliveryFee;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        _PaymentRow(label: '상품 금액', value: '${formatPrice(subtotal)}원'),
        const SizedBox(height: 10),
        _PaymentRow(
          label: '배송비',
          value: deliveryFee == 0 ? '무료' : '${formatPrice(deliveryFee)}원',
        ),
        const SizedBox(height: 16),
        Divider(color: colorScheme.outlineVariant),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                '총 결제금액',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${formatPrice(totalPrice)}원',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
