import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'sign out',
    content: 'are you sure to sign out?',
    optionBuilder: () => {
      'cancel': false,
      'sign out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
