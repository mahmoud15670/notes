import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Shareing',
    content: 'you cannot share an empty note!',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
