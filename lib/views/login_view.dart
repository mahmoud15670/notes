import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
    return Scaffold(
      appBar: AppBar(
        title: const Text('login'),
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
                  final useris = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  print(useris);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-credential'){
                    print('email or password is incorrect');
                  }else if (e.code == 'invalid-email') {
                    print('invalid email');
      
                  }
                }
              },
              child: const Text('Login')),
              const Row(
                children: [
                  Text("don't have account ?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil('/register/', (route) => false,);
                    }, 
                    child: Text('signup !'))
                ],
              )
        ],
      ),
    );
  }

}
