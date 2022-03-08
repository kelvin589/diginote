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
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black)),
          ),
        ],
      ),
    );
  }

  static Future<void> showSuccessDialogue(
      BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.green)),
          ),
        ],
      ),
    );
  }

  static void showDestructiveDialogue(
      {required BuildContext context,
      required String title,
      required String message,
      required Future<void> Function() onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black)),
          ),
          TextButton(
            onPressed: () async {
              await onConfirm();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.red)),
          ),
        ],
      ),
    );
  }

  static void showConfirmationDialogue(
      {required BuildContext context,
      required String title,
      required String message,
      required String confirmationActionText,
      required Future<void> Function() onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black)),
          ),
          TextButton(
            onPressed: () async {
              await onConfirm();
              Navigator.pop(context);
            },
            child: Text(confirmationActionText),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.green)),
          ),
        ],
      ),
    );
  }

  static Widget cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    );
  }

  static Widget okButton(Future<void> Function()? okPressed) {
    return TextButton(
      onPressed: okPressed == null
          ? null
          : () async {
              await okPressed();
            },
      child: const Text('OK'),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    );
  }

  static Widget saveButton(Future<void> Function()? savePressed) {
    return TextButton(
      onPressed: savePressed == null
          ? null
          : () async {
              await savePressed();
            },
      child: const Text('Save'),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    );
  }
}
