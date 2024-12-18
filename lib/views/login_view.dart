// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exeption is InvalidCredentialAuthException) {
            await showErrorDialog(context, 'email or password is incorrect');
          } else if (state.exeption is InvaidEmailAuthException) {
            await showErrorDialog(context, 'invalid email');
          } else if (state.exeption is GenericAuthException) {
            await showErrorDialog(
                context, 'An Error happend check networ our you cerdetial');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Welcome 👋, \nplese enter your email and passwor to login!'),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Enter your email'),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration:
                      const InputDecoration(hintText: 'Enter your password'),
                ),
                TextButton(
                    onPressed: () {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(AuthEventLogin(
                            email,
                            password,
                          ));
                    },
                    child: const Text('Login')),
                TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventForgotPassword());
                  },
                  child: const Text('forgot your password!'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("don't have account ?"),
                    TextButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventShouldRegister());
                        },
                        child: const Text('signup !'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
