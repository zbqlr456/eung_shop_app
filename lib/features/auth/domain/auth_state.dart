import 'package:eung_shop_app/features/auth/domain/app_user.dart';

const _unset = Object();

class AuthState {
  const AuthState({this.currentUser, this.accounts = const []});

  final AppUser? currentUser;
  final List<AuthAccount> accounts;

  bool get isLoggedIn => currentUser != null;

  AuthState copyWith({
    Object? currentUser = _unset,
    List<AuthAccount>? accounts,
  }) {
    return AuthState(
      currentUser: identical(currentUser, _unset)
          ? this.currentUser
          : currentUser as AppUser?,
      accounts: accounts ?? this.accounts,
    );
  }
}

class AuthAccount {
  const AuthAccount({required this.user, required this.password});

  final AppUser user;
  final String password;
}
