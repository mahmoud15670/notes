// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mynotes/constance/routs.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/utilities/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(
          children: [
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
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthServices.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    await AuthServices.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(verfiyRout);
                  } on EmailAlradyInUseAuthException {
                    await showErrorDialog(
                      context,
                      'The email address is already in use by another account.',
                    );
                  } on WeakPasswordAuthException {
                    await showErrorDialog(context, 'The password is weak');
                  } on InvaidEmailAuthException {
                    await showErrorDialog(context, 'invalid email');
                  } on GenericAuthException {
                    await showErrorDialog(context,
                        'an error happend check network or your certional');
                  }
                },
                child: const Text('Register')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("have account ?"),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRout,
                        (route) => false,
                      );
                    },
                    child: const Text('login !'))
              ],
            )
          ],
        ));
  }
}
