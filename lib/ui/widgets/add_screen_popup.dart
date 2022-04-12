import 'package:clock/clock.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// An [AlertDialog] which allows the user to insert a new screen
/// with a name and pairing code displayed on the screen.
class AddScreenPopup extends StatefulWidget {
  const AddScreenPopup({Key? key}) : super(key: key);

  @override
  _AddScreenPopupState createState() => _AddScreenPopupState();
}

class _AddScreenPopupState extends State<AddScreenPopup> {
  /// The [GlobalKey] for this form.
  final _formKey = GlobalKey<FormState>();

  /// The [TextEditingController] for the pairing code input.
  final TextEditingController _pairingCodeController = TextEditingController();

  /// The [TextEditingController] for the screen name input.
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: const Text('Add Screen'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Screen Name'),
              validator: Validator.isValidScreenName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            TextFormField(
              controller: _pairingCodeController,
              decoration: const InputDecoration(hintText: 'Pairing Code'),
              validator: Validator.isValidPairingCodeFormat,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
      ),
      actions: [
        DialogueHelper.cancelButton(context),
        DialogueHelper.okButton(() async {
          await _okPressed();
        }),
      ],
    );
  }

  /// Called when 'OK' is pressed to pair a new screen.
  /// 
  /// The pairing code is checked first the pairing code is valid and matches a
  /// screen to be paired, if not an error is displayed.
  Future<void> _okPressed() async {
    Screen partialScreen = Screen(
      pairingCode: _pairingCodeController.text,
      paired: false,
      name: _nameController.text,
      userID: "",
      lastUpdated: clock.now(),
      screenToken: "",
      width: 0,
      height: 0,
    );
    // Ensure the entered pairing code is of the correct format before continuing.
    if (_formKey.currentState!.validate()) {
      await Provider.of<FirebaseScreensProvider>(context, listen: false)
          .addScreen(
        screen: partialScreen,
        onSuccess: () => Navigator.pop(context),
        onError: () => DialogueHelper.showSuccessDialogue(context,
            "Unable to add screen", "Already paired or the code wrong."),
      );
    }
  }
}
