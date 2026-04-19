import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:eung_shop_app/features/auth/domain/app_user.dart';
import 'package:eung_shop_app/features/auth/domain/auth_state.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    return const AuthState(
      accounts: [
        AuthAccount(
          user: AppUser(id: 'user-demo', email: 'test@eung.shop', name: '이응'),
          password: 'password123',
        ),
      ],
    );
  }

  String? login({required String email, required String password}) {
    final normalizedEmail = _normalizeEmail(email);
    final trimmedPassword = password.trim();

    if (!_isValidEmail(normalizedEmail)) {
      return '이메일을 확인해주세요.';
    }

    if (trimmedPassword.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }

    final account = _findAccount(normalizedEmail);
    if (account == null) {
      return '가입된 이메일이 없습니다.';
    }

    if (account.password != trimmedPassword) {
      return '비밀번호가 올바르지 않습니다.';
    }

    state = state.copyWith(currentUser: account.user);
    return null;
  }

  String? signUp({
    required String name,
    required String email,
    required String password,
  }) {
    final trimmedName = name.trim();
    final normalizedEmail = _normalizeEmail(email);
    final trimmedPassword = password.trim();

    if (trimmedName.isEmpty) {
      return '이름을 입력해주세요.';
    }

    if (!_isValidEmail(normalizedEmail)) {
      return '이메일을 확인해주세요.';
    }

    if (trimmedPassword.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다.';
    }

    if (_findAccount(normalizedEmail) != null) {
      return '이미 가입된 이메일입니다.';
    }

    final user = AppUser(
      id: _createUserId(normalizedEmail),
      email: normalizedEmail,
      name: trimmedName,
    );
    final account = AuthAccount(user: user, password: trimmedPassword);

    state = state.copyWith(
      currentUser: user,
      accounts: [...state.accounts, account],
    );
    return null;
  }

  void logout() {
    state = state.copyWith(currentUser: null);
  }

  AuthAccount? _findAccount(String email) {
    for (final account in state.accounts) {
      if (account.user.email == email) {
        return account;
      }
    }
    return null;
  }
}

String _normalizeEmail(String email) {
  return email.trim().toLowerCase();
}

bool _isValidEmail(String email) {
  return email.contains('@') && email.contains('.');
}

String _createUserId(String email) {
  final safeEmail = email.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  return 'user-$safeEmail';
}
