import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_services.dart';

class NotesListView extends StatelessWidget {
  final List<DataBaseNote> notes;
  const NotesListView({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
