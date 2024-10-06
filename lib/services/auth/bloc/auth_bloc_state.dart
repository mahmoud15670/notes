import 'package:flutter/foundation.dart';

@immutable
abstract class AuthBlocState {
  const AuthBlocState();
}

class AuthStateInitialze extends AuthBlocState {
  const AuthStateInitialze();
}

class AuthStateLoggedIn extends AuthBlocState {
  const AuthStateLoggedIn();
}

class AuthStateLoggedOut extends AuthBlocState {
  const AuthStateLoggedOut();
}
