import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:eung_shop_app/features/auth/application/auth_providers.dart';

class SignupPage extends HookConsumerWidget {
  const SignupPage({super.key, this.redirectPath});

  final String? redirectPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordConfirmController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Text(
              'Eung Shop 시작하기',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '주문 내역과 배송 정보를 내 계정으로 관리해요.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              key: const ValueKey('signupNameField'),
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '김은철',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('signupEmailField'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: 'you@example.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('signupPasswordField'),
              controller: passwordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                hintText: '6자 이상',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('signupPasswordConfirmField'),
              controller: passwordConfirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(
                context,
                ref,
                nameController,
                emailController,
                passwordController,
                passwordConfirmController,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _submit(
                context,
                ref,
                nameController,
                emailController,
                passwordController,
                passwordConfirmController,
              ),
              child: const Text('가입하기'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                final queryParameters = redirectPath == null
                    ? const <String, String>{}
                    : {'redirect': redirectPath!};

                context.pushNamed(
                  RouteNames.login,
                  queryParameters: queryParameters,
                );
              },
              child: const Text('이미 계정이 있어요'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(
    BuildContext context,
    WidgetRef ref,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController passwordConfirmController,
  ) {
    if (passwordController.text.trim() !=
        passwordConfirmController.text.trim()) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('비밀번호가 서로 다릅니다.')));
      return;
    }

    final errorMessage = ref
        .read(authControllerProvider.notifier)
        .signUp(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
        );

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

  context.go(RoutePaths.home);
}
