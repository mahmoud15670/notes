import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/crud/notes_services.dart';

class AddNewNote extends StatefulWidget {
  const AddNewNote({super.key});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}
class _AddNewNoteState extends State<AddNewNote> {
  DataBaseNote? _note;
  late final NotesServices _notesServices;
  late final TextEditingController _textController;

  Future<DataBaseNote> createNote () async{
    final exsitsNote = _note;
    if (_note != null){
      return exsitsNote;
    }
    final userEmail = await AuthServices.firebase().currentUser!.email!;
    final owner = await _notesServices.getUser(email: userEmail);
    return await _notesServices.createNote(owner: owner);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add note'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Text('add note here...'),
    );
  }
}
