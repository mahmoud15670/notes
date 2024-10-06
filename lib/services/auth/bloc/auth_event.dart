import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventLoading extends AuthEvent {
  const AuthEventLoading();
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin(
    this.email,
    this.password,
  );
}

class AuthEventverfitemail extends AuthEvent {
  const AuthEventverfitemail();
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}
