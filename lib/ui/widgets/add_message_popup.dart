import 'package:diginote/ui/shared/input_validators.dart';
import 'package:flutter/material.dart';

class AddMessagePopup extends StatefulWidget {
  const AddMessagePopup({Key? key, required this.screenToken}) : super(key: key);

  final String screenToken;
  
  @override
  _AddMessagePopupState createState() => _AddMessagePopupState();
}

class _AddMessagePopupState extends State<AddMessagePopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Message'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter the message to display:'),
            TextFormField(
              controller: _headerController,
              decoration: const InputDecoration(hintText: 'Header'),
              validator: isEmptyValidator,
            ),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(hintText: 'Message'),
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
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }
}
