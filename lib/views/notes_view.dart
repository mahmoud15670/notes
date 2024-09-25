import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constance/routs.dart';
import 'package:mynotes/enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            PopupMenuButton<MenuAction>(
              icon: const Icon(Icons.menu),
              iconSize: 45.0,
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldsignout = await showLogoutDialog(context);
                    if (shouldsignout) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRout,
                        (route) => false,
                      );
                    }
                }
              },
              enableFeedback: true,
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('logout'))
                ];
              },
            )
          ],
        ),
        body: const Text('done'));
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sour you want to sign out?'),
        icon: const Icon(Icons.logout),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('signout')),
        ],
      );
    },
  ).then(
    (value) => value ?? false,
  );
}
