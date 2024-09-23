import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constance/routs.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email verfiy'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const Text("we've send a veritation email please check your inbox."),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("if you didn't reseved email "),
              TextButton(
                onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                }, 
                child: const Text('send email vertfiction'),
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(registerRout, (route) => false,);
            }, 
            child: const Text('back'))
        ],
      )
    );
  }
}