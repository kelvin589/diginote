import 'package:flutter/material.dart';

class DialogueHelper {
  static void showErrorDialogue(
      BuildContext context, String title, Exception exception) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text((exception as dynamic).message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
          ),
        ],
      ),
    );
  }
}
