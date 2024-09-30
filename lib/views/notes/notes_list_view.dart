import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_services.dart';

typedef DeleteNoteCallback = void Function(DataBaseNote note);

class NotesListView extends StatelessWidget {
  final List<DataBaseNote> notes;
  final DeleteNoteCallback onDeleteNote;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
