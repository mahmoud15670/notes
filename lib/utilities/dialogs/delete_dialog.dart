import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete ',
    content: 'are you sure to delete item?',
    optionBuilder: () => {
      'cancel': false,
      'yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
