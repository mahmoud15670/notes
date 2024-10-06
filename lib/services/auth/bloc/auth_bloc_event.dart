import 'package:flutter/foundation.dart';

@immutable
abstract class AuthBlocEvent {
  const AuthBlocEvent();
}

class AuthEventLoading extends AuthBlocEvent {
  const AuthEventLoading();
}

class AuthEventLogin extends AuthBlocEvent {
  final String email;
  final String password;
  const AuthEventLogin(
    this.email,
    this.password,
  );
}

class AuthEventverfitemail extends AuthBlocEvent {
  const AuthEventverfitemail();
}

class AuthEventLogout extends AuthBlocEvent {
  const AuthEventLogout();
}
