import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> passwordResetDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Reset Password',
    content: 'we have send a reset email',
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
