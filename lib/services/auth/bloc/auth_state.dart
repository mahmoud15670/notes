import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState{
  const AuthStateUninitialized();
}

class AuthStateRegistring extends AuthState{
  final Exception? exeption;
  const AuthStateRegistring(this.exeption);
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
