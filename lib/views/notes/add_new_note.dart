import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_services.dart';

class AddNewNote extends StatefulWidget {
  const AddNewNote({super.key});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}
class _AddNewNoteState extends State<AddNewNote> {
  DataBaseNote? _note;

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
