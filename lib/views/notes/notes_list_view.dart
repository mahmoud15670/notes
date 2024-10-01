import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_services.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(DataBaseNote note);

class NotesListView extends StatelessWidget {
  final List<DataBaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTapNote;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTapNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) onDeleteNote(note);
            },
            icon: Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
