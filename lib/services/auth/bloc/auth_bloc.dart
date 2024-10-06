import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_provider.dart';

@immutable
abstract class AuthBloc {
  final AuthProvider provider;

  const AuthBloc(this.provider);
}
