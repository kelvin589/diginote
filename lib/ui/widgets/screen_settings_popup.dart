import 'package:diginote/core/models/screen_info_model.dart';
import 'package:diginote/core/providers/firebase_screen_info_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// An [AlertDialog] which displays the settings for the screen.
class ScreenSettingsPopup extends StatefulWidget {
  const ScreenSettingsPopup({
    Key? key,
    required this.screenToken,
    required this.screenName,
    required this.onDelete,
    required this.screenInfo,
  }) : super(key: key);

  /// The screen token.
  final String screenToken;

  /// The name of the screen.
  final String screenName;

  /// The screen's extra information.
  final ScreenInfo screenInfo;

  /// Called when the screen is deleted.
  final Future<void> Function() onDelete;

  @override
  State<ScreenSettingsPopup> createState() => _ScreenSettingsPopupState();
}

class _ScreenSettingsPopupState extends State<ScreenSettingsPopup> {
  /// The delay between notifications to 'low battery'.
  late double lowBatteryNotificationDelay;

  /// The threshold at which a 'low battery' notification is sent.
  late double lowBatteryThreshold;

  /// The delay between updating the battery level of this screen.
  late double batteryReportingDelay;

  /// The [TextEditingController] for the screen name input.
  final screenNameController = TextEditingController();

  /// Initialises the fields using values in the screenInfo.
  ///
  /// Values are divided by 60 to bring them to minutes, which are a
  /// more suitable range for the sliders.
  @override
  void initState() {
    super.initState();
    lowBatteryNotificationDelay =
        (widget.screenInfo.lowBatteryNotificationDelay / 60).toDouble();
    lowBatteryThreshold = widget.screenInfo.lowBatteryThreshold.toDouble();
    batteryReportingDelay =
        (widget.screenInfo.batteryReportingDelay / 60).toDouble();
    screenNameController.text = widget.screenName;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Settings"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Screen name"),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: screenNameController,
              ),
            ),
            const Text("Delay between low battery notifications:"),
            Text("${lowBatteryNotificationDelay.toInt()} minutes"),
            Slider(
              value: lowBatteryNotificationDelay,
              onChanged: (newValue) {
                setState(() {
                  lowBatteryNotificationDelay = newValue;
                });
              },
              min: 1,
              max: 60,
              divisions: 59,
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
            const Text("Delay between battery reporting:"),
            Text("${batteryReportingDelay.toInt()} minutes"),
            Slider(
              value: batteryReportingDelay,
              onChanged: (newValue) {
                setState(() {
                  batteryReportingDelay = newValue;
                });
              },
              min: 1,
              max: 60,
              divisions: 59,
              label: "$batteryReportingDelay",
            ),
            const Text("Delete Screen:"),
            _DeleteScreenButton(
              screenName: widget.screenName,
              onDelete: widget.onDelete,
            ),
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

  /// Saves the scrren info if the 'Save' button is pressed.
  Future<void> saveScreenInfo() async {
    // Must convet back to seconds.
    widget.screenInfo.lowBatteryNotificationDelay =
        (lowBatteryNotificationDelay * 60).toInt();
    widget.screenInfo.lowBatteryThreshold = lowBatteryThreshold.toInt();
    widget.screenInfo.batteryReportingDelay =
        (batteryReportingDelay * 60).toInt();
    
    // Updates the screenName only if it is different.
    final String? screenName = widget.screenName == screenNameController.text
        ? null
        : screenNameController.text;
    await Provider.of<FirebaseScreenInfoProvider>(context, listen: false)
        .setScreenInfo(widget.screenToken, widget.screenInfo,
            screenName: screenName);
  }
}

/// A button to delete the screen.
class _DeleteScreenButton extends StatelessWidget {
  const _DeleteScreenButton({
    Key? key,
    required this.screenName,
    required this.onDelete,
  }) : super(key: key);

  /// The screen name.
  final String screenName;

  /// Called when the button is pressed.
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
