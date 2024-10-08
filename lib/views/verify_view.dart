import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constance/routs.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

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
            const Text(
                "we've send a veritation email please check your inbox."),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("if you didn't reseved email "),
                TextButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(
                          const AuthEventSendEmailVerficaion(),
                        );
                  },
                  child: const Text('send email vertfiction'),
                ),
              ],
            ),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text('back'))
          ],
        ));
  }
}
