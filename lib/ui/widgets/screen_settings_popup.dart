import 'package:diginote/core/models/screen_info_model.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:flutter/material.dart';

class ScreenSettingsPopup extends StatelessWidget {
  const ScreenSettingsPopup(
      {Key? key,
      required this.screenToken,
      required this.screenName,
      required this.onDelete,
      required this.screenInfo})
      : super(key: key);

  final String screenToken;
  final String screenName;
  final ScreenInfo screenInfo;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    Future<void> _okPressed() async {
      Navigator.pop(context);
    }

    return AlertDialog(
      title: const Text("Settings"),
      content: _DeleteScreenButton(screenName: screenName, onDelete: onDelete),
      actions: <Widget>[
        DialogueHelper.okButton(() async {
          await _okPressed();
        }),
      ],
    );
  }
}

class _DeleteScreenButton extends StatelessWidget {
  const _DeleteScreenButton({Key? key, required this.screenName, required this.onDelete})
      : super(key: key);

  final String screenName;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            DialogueHelper.showDestructiveDialogue(
              context: context,
              title: "Delete Screen",
              message: 'Are you sure you want to delete the screen named "$screenName"?',
              onConfirm: () async {
                await onDelete();
                Navigator.pop(context);
              },
            );
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
