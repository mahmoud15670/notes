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

  @override
  void initState() {
    _notesServices = NotesServices();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DataBaseNote> createNewNote() async {
    final exsitsNote = _note;
    if (exsitsNote != null) {
      return exsitsNote;
    }
    final userEmail = AuthServices.firebase().currentUser!.email!;
    final owner = await _notesServices.getUser(email: userEmail.toLowerCase());
    final note = await _notesServices.createNote(owner: owner);
    return note;
  }

  void _saveNoteIfTextIsEMpty() async {
    final note = _note;
    if (_textController.text.isNotEmpty && note != null) {
      await _notesServices.updateNote(
        note: note,
        text: _textController.text,
      );
    }
  }

  void _deleteNoteIfTextEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesServices.deleteNote(id: note.id);
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesServices.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _saveNoteIfTextIsEMpty();
    _deleteNoteIfTextEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add note'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            
            case ConnectionState.done:
              _note = snapshot.data as DataBaseNote;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(hintText: 'type your note...'),
                maxLines: null,
              );
            default :
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
