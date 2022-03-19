import 'package:diginote/core/providers/firebase_login_provider.dart';
import 'package:diginote/ui/widgets/colour_picker_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isDarkMode = false;
  bool allowNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Allow Notifications"),
            Switch(
              value: allowNotifications,
              onChanged: (newValue) => setState(
                () {
                  allowNotifications = newValue;
                },
              ),
            ),
            const Text("Dark Mode"),
            Switch(
              value: isDarkMode,
              onChanged: (newValue) => setState(
                () {
                  isDarkMode = newValue;
                },
              ),
            ),
            const Text("Background Colour"),
            ColourPickerIcon(onColourChanged: (newColour) => {}),
            const Text("Foreground Colour"),
            ColourPickerIcon(onColourChanged: (newColour) => {}),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<FirebaseLoginProvider>(context, listen: false)
                    .logout();
              },
              child: const Text("Logout"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
