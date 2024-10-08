import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistring extends AuthState {
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

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exeption;
  final bool? isLoading;
  const AuthStateLoggedOut({
    required this.exeption,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exeption, isLoading];
}
