import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key, this.redirectPath});

  final String? redirectPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Text(
              '다시 만나 반가워요',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '주문과 배송 내역을 이어서 확인할 수 있어요.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              key: const ValueKey('loginEmailField'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: 'test@eung.shop',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('loginPasswordField'),
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                hintText: 'password123',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) =>
                  _submit(context, ref, emailController, passwordController),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () =>
                  _submit(context, ref, emailController, passwordController),
              child: const Text('로그인'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                final queryParameters = redirectPath == null
                    ? const <String, String>{}
                    : {'redirect': redirectPath!};

                context.pushNamed(
                  RouteNames.signup,
                  queryParameters: queryParameters,
                );
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(
    BuildContext context,
    WidgetRef ref,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    final errorMessage = ref
        .read(authControllerProvider.notifier)
        .login(email: emailController.text, password: passwordController.text);

    if (errorMessage != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    _goAfterAuth(context, redirectPath);
  }
}

void _goAfterAuth(BuildContext context, String? redirectPath) {
  if (redirectPath != null && redirectPath.isNotEmpty) {
    context.go(redirectPath);
    return;
  }

  if (context.canPop()) {
    context.pop();
    return;
  }

  context.go(RoutePaths.home);
}
