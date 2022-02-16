import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'font_picker.dart';

class AddMessagePopup extends StatefulWidget {
  const AddMessagePopup({Key? key, required this.screenToken})
      : super(key: key);

  final String screenToken;

  @override
  _AddMessagePopupState createState() => _AddMessagePopupState();
}

class _AddMessagePopupState extends State<AddMessagePopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String fontFamily = "Roboto";
  double fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    List<Widget> formOptions = [
      TextFormField(
        controller: _headerController,
        decoration: const InputDecoration(hintText: 'Header'),
        validator: isEmptyValidator,
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 10,
        controller: _messageController,
        decoration: const InputDecoration(hintText: 'Message'),
        validator: isEmptyValidator,
        style: GoogleFonts.getFont(fontFamily, fontSize: fontSize),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Typeface'),
          typeface,
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Font'),
          FontPicker(
            onFontFamilyChanged: (fontFamily) {
              setState(() {
                this.fontFamily = fontFamily;
              });
            },
            onFontSizeChanged: (fontSize) {
              setState(() {
                this.fontSize = fontSize;
              });
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Font Colour'),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Background Colour'),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Listing'),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Text Alignment'),
        ],
      ),
    ];

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: AlertDialog(
        title: const Text('Add Message'),
        content: Form(
          key: _formKey,
          child: ListView.separated(
            itemCount: formOptions.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.transparent,
            ),
            itemBuilder: (context, index) => formOptions[index],
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
      ),
    );
  }

  void _cancelPressed() {
    Navigator.pop(context);
  }

  void _okPressed() {
    Message newMessage = Message(
        header: _headerController.text, message: _messageController.text);
    if (_formKey.currentState!.validate()) {
      Provider.of<FirebasePreviewProvider>(context, listen: false)
          .addMessage(widget.screenToken, newMessage);
      Navigator.pop(context);
    }
  }

  Widget typeface = Row(
    children: [
      IconButton(
        onPressed: () => {},
        icon: IconHelper.boldIcon,
        constraints: const BoxConstraints(),
      ),
      IconButton(
        onPressed: () => {},
        icon: IconHelper.italicIcon,
        constraints: const BoxConstraints(),
      ),
      IconButton(
        onPressed: () => {},
        icon: IconHelper.strikethroughIcon,
        constraints: const BoxConstraints(),
      ),
      IconButton(
        onPressed: () => {},
        icon: IconHelper.underlineIcon,
        constraints: const BoxConstraints(),
      ),
    ],
  );
}
