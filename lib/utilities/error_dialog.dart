import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context, 
  String text,
  ) {
  return showDialog(
    context: context, 
    builder: (context) {
      return const AlertDialog(
      title: Text('Error'),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
          Navigator.of(context).pop();
        }, 
        child: Text('OK'))
      ],
    );
    },
  );
}