import 'package:flutter/foundation.dart';

@immutable
abstract class AuthBlocState {
  const AuthBlocState();
}

class AuthBlocInitialze extends AuthBlocState {
  const AuthBlocInitialze();
}

class AuthBlocLoggedIn extends AuthBlocState {
  const AuthBlocLoggedIn();
}

class AuthBlocLoggedOut extends AuthBlocState {
  const AuthBlocLoggedOut();
}
