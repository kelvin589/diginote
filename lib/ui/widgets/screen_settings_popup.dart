import 'package:flutter/material.dart';

class ScreenSettingsPopup extends StatelessWidget {
  const ScreenSettingsPopup(
      {Key? key, required this.screenToken, required this.onDelete})
      : super(key: key);

  final String screenToken;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Settings"),
      content: _DeleteScreenButton(onDelete: onDelete),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.green)),
        ),
      ],
    );
  }
}

class _DeleteScreenButton extends StatelessWidget {
  const _DeleteScreenButton({Key? key, required this.onDelete})
      : super(key: key);

  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await onDelete();
            Navigator.pop(context);
          },
          child: const Text("Delete Screen"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ),
    );
  }
}
