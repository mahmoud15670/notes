// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constance/routs.dart';
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
          decoration:
              const InputDecoration(hintText: 'Enter your email'),
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
              await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email, password: password);
              final user = FirebaseAuth.instance.getRedirectResult();
              
              Navigator.of(context).pushNamed(verfiyRout);
              }on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use'){
                  await showErrorDialog(context, 'The email address is already in use by another account.');
                }else if (e.code == 'weak-password'){
                  await showErrorDialog(context, 'The password is weak');
                }else if (e.code == 'invalid-email'){
                  await showErrorDialog(context, 'invalid email');
                }else{
                  await showErrorDialog(context, '${e.message}');
                }
              }catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Register')),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("have account ?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRout, (route) => false,);
                    }, 
                    child: const Text('login !'))
                ],
              )
      ],
    )
  );
  }
}
