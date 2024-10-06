import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}
