import 'package:flutter/material.dart';

/// A helper class which contains functions for showing common dialogues
/// and also contains common widgets used in those dialogues.
/// 
/// This allows for a consistency in the dialogues.
class DialogueHelper {
  /// Shows an error dialogue whos body contains information
  /// about an [Exception].
  ///
  /// The only action is to close the dialogue by pressing 'OK'.
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
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a success dialogue containing a positive [title] and [message].
  ///
  /// The only action is to close the dialogue by pressing 'OK'.
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
              foregroundColor: MaterialStateProperty.all(Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a destructive dialogue containing a negative [title] and [message],
  /// for confirming the execution of a destructive action. For example,
  /// deleting a message.
  ///
  /// One action is to 'Cancel' which closes the dialogue, doing nothing.
  /// The other action is 'Delete' which executes the destructive action [onConfirm].
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
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              await onConfirm();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialogue to allow the user to confirm some action.
  /// For example, so save a message or save a screen's settings.
  ///
  /// The [confirmationActionText] is required to customise the text in
  /// the confirmation button.
  ///
  /// One action is to 'Cancel' which closes the dialogue, doing nothing.
  /// The other action is '[confirmationActionText]' which executes the
  /// confirmation action [onConfirm].
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
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              await onConfirm();
              Navigator.pop(context);
            },
            child: Text(confirmationActionText),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  /// A dialogue cancel button which simply closes the popup.
  static Widget cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    );
  }

  /// A dialogue 'OK' button which executes [okPressed] when pressed.
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

  /// A dialogue 'Save' button which executes [savePressed] when pressed.
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
