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
class AuthStateLoggedInFalier extends AuthState{
  final Exception e;

  const AuthStateLoggedInFalier(this.e);
}
class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}
