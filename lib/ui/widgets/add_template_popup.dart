import 'package:flutter/material.dart';

class AddTemplatePopup extends StatefulWidget {
  const AddTemplatePopup({Key? key}) : super(key: key);

  @override
  State<AddTemplatePopup> createState() => _AddTemplatePopupState();
}

class _AddTemplatePopupState extends State<AddTemplatePopup> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: const AlertDialog(
        title: Text("Add Template"),
        content: Text("Add Template Options")
      ),
    );
  }
}
