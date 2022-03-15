import 'package:diginote/core/models/screen_info_model.dart';
import 'package:diginote/core/providers/firebase_screen_info_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenSettingsPopup extends StatefulWidget {
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
  State<ScreenSettingsPopup> createState() => _ScreenSettingsPopupState();
}

class _ScreenSettingsPopupState extends State<ScreenSettingsPopup> {
  late double lowBatteryNotificationDelay;
  late double lowBatteryThreshold;

  @override
  void initState() {
    super.initState();
    lowBatteryNotificationDelay =
        (widget.screenInfo.lowBatteryNotificationDelay / 60).toDouble();
    lowBatteryThreshold = widget.screenInfo.lowBatteryThreshold.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Settings"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Delay between notifications:"),
            Text("${lowBatteryNotificationDelay.toInt()} minutes"),
            Slider(
              value: lowBatteryNotificationDelay,
              onChanged: (newValue) {
                setState(() {
                  lowBatteryNotificationDelay = newValue;
                });
              },
              min: 10,
              max: 60,
              divisions: 50,
              label: "$lowBatteryNotificationDelay",
            ),
            const Text("Low battery notification threshold:"),
            Text("${lowBatteryThreshold.toInt()}%"),
            Slider(
              value: lowBatteryThreshold,
              onChanged: (newValue) {
                setState(() {
                  lowBatteryThreshold = newValue;
                });
              },
              min: 10,
              max: 70,
              divisions: 60,
              label: "$lowBatteryThreshold",
            ),
            const Text("Delete Screen:"),
            _DeleteScreenButton(
                screenName: widget.screenName, onDelete: widget.onDelete),
          ],
        ),
      ),
      actions: <Widget>[
        DialogueHelper.cancelButton(context),
        DialogueHelper.saveButton(() async {
          DialogueHelper.showConfirmationDialogue(
              context: context,
              title: "Save Settings",
              message: "Are you sure you want to save these settings?",
              confirmationActionText: "Save",
              onConfirm: () async {
                await saveScreenInfo();
                Navigator.pop(context);
              });
        }),
      ],
    );
  }

  Future<void> saveScreenInfo() async {
    widget.screenInfo.lowBatteryNotificationDelay =
        (lowBatteryNotificationDelay * 60).toInt();
    widget.screenInfo.lowBatteryThreshold = lowBatteryThreshold.toInt();
    await Provider.of<FirebaseScreenInfoProvider>(context, listen: false)
        .setScreenInfo(widget.screenToken, widget.screenInfo);
  }
}

class _DeleteScreenButton extends StatelessWidget {
  const _DeleteScreenButton(
      {Key? key, required this.screenName, required this.onDelete})
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
              message:
                  'Are you sure you want to delete the screen named "$screenName"?',
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
