import 'package:flutter/material.dart';
import 'package:mynotes/constance/routs.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userId => AuthServices.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesServices;

  @override
  void initState() {
    _notesServices = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRout);
            },
            icon: Icon(Icons.add),
          ),
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
      body: StreamBuilder(
        stream: _notesServices.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesServices.deleteNote(documentId: note.documentId);
                  },
                  onTapNote: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRout,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
