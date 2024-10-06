import 'package:flutter/foundation.dart';

@immutable
abstract class AuthBlocEvent {
  const AuthBlocEvent();
}

class AuthEventLoading extends AuthBlocEvent {
  const AuthEventLoading();
}

class AuthEventLogin extends AuthBlocEvent {
  const AuthEventLogin();
}

class AuthEventverfitemail extends AuthBlocEvent {
  const AuthEventverfitemail();
}

class AuthEventLogout extends AuthBlocEvent {
  const AuthEventLogout();
}
