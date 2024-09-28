import 'package:flutter/material.dart';
import 'package:mynotes/constance/routs.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/crud/notes_services.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthServices.firebase().currentUser!.email!;
  late final NotesServices _notesServices;

  @override
  void initState() {
    _notesServices = NotesServices();
    super.initState();
  }

  @override
  void dispose() {
    _notesServices.close();
    super.dispose();
  }

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
                      await AuthServices.firebase().logOut();
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
        body: FutureBuilder(
          future: _notesServices.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                const Text('data');
              default: 
                return const CircularProgressIndicator();
            }
          },
        ));
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
