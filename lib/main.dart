import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constance/routs.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Notes',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 39, 176, 42)),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRout: (context) => const LoginView(),
      registerRout: (context) => const RegisterView(),
      verfiyRout: (context) => const VerifyEmailView(),
      notesRout: (context) => const NotesView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null){
                if (user.emailVerified){
                  return const NotesView();
                }else {
                  return const VerifyEmailView();
                }
              }else{
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}

enum MenuAction { logout}
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
                devtools.log(shouldsignout.toString());
                if (shouldsignout) {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(loginRout, (route) => false,);
                }
            }
          },
          enableFeedback: true,
          offset: const Offset(50.5, 50.0),
          position: PopupMenuPosition.under,
          itemBuilder: (context) {
            return const [
              PopupMenuItem <MenuAction>(
                value: MenuAction.logout,
                child: Text('logout')
              )
            ];
          },
          )
        ],
      ),
      body: const Text('done')
    );
  }
}

Future<bool> showLogoutDialog (BuildContext context){
  return showDialog<bool>(context: context, builder: (context) {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sour you want to sign out?'),
      icon: const Icon(Icons.logout),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false);
        }, child: const Text('cancel')),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);
        }, child: const Text('signout')),
      ],
    );
  },
  ).then((value) => value ?? false,);
}