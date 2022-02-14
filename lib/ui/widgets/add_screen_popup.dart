import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreenPopup extends StatefulWidget {
  const AddScreenPopup({Key? key}) : super(key: key);

  @override
  _AddScreenPopupState createState() => _AddScreenPopupState();
}

class _AddScreenPopupState extends State<AddScreenPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pairingCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Screen'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter a name for your screen and the pairing code displayed on your screen:'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
              validator: isEmptyValidator,
            ),
            TextFormField(
              controller: _pairingCodeController,
              decoration: const InputDecoration(hintText: 'Pairing Code'),
              validator: isEmptyValidator,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancelPressed,
          child: const Text('Cancel'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        TextButton(
          onPressed: _okPressed,
          child: const Text('OK'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ],
    );
  }

  void _cancelPressed() {
    Navigator.pop(context);
  }

  void _okPressed() {
    ScreenPairing partialScreenPairing = ScreenPairing(pairingCode: _pairingCodeController.text, paired: false, name: _nameController.text, userID: "");
    if (_formKey.currentState!.validate()) {
      Provider.of<FirebaseScreensProvider>(context, listen: false)
          .addScreen(partialScreenPairing);
      Navigator.pop(context);
    }
  }
}
