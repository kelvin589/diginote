import 'package:diginote/core/providers/firebase_login_provider.dart';
import 'package:diginote/core/providers/theme_provider.dart';
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
  Color backgroundColour = Colors.transparent;

  @override
  void initState() {
    super.initState();
    isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    backgroundColour =
        Provider.of<ThemeProvider>(context, listen: false).backgroundColour;
  }

  @override
  Widget build(BuildContext context) {
    // Hide background/foreground selector if dark mode
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // _AllowNotificationsToggle(
          //   value: allowNotifications,
          //   onChanged: (newValue) => setState(
          //     () {
          //       allowNotifications = newValue;
          //     },
          //   ),
          // ),
          _DarkModeToggle(
            value: isDarkMode,
            onChanged: (newValue) => setState(
              () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleIsDarkMode();
                isDarkMode = newValue;
              },
            ),
          ),
          _HighlightColourPicker(
            initialColour: backgroundColour,
            onColourChanged: (newColour) => setState(
              () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setBackgroundColour(newColour);
                backgroundColour = newColour;
              },
            ),
          ),
          Spacer(),
          _LogoutButton(
            onPressed: () async {
              await Provider.of<FirebaseLoginProvider>(context, listen: false)
                  .logout();
            },
          ),
        ],
      ),
    );
  }
}

class _AllowNotificationsToggle extends StatelessWidget {
  const _AllowNotificationsToggle(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Allow Notifications"),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _DarkModeToggle extends StatelessWidget {
  const _DarkModeToggle(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Dark Mode"),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _HighlightColourPicker extends StatelessWidget {
  const _HighlightColourPicker(
      {Key? key, required this.initialColour, required this.onColourChanged})
      : super(key: key);

  final Color initialColour;
  final void Function(Color) onColourChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Highlight Colour"),
        ColourPickerIcon(
          initialColour: initialColour,
          onColourChanged: onColourChanged,
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text("Logout"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
    );
  }
}
