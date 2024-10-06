import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser currentUser;
  const AuthStateLoggedIn(this.currentUser);
}


class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exeption;
  const AuthStateLoggedOut(this.exeption);
}

class AuthStateLoggedOutFalier extends AuthState {
  final Exception exeption;

  const AuthStateLoggedOutFalier(this.exeption);
}
