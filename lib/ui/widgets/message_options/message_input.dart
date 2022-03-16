import 'package:diginote/ui/shared/input_validators.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageInput extends StatelessWidget {
  const MessageInput(
      {Key? key,
      required this.messageController,
      required this.fontFamily,
      required this.fontSize,
      required this.backgroundColour,
      required this.foregroundColour,
      required this.width,
      required this.height,
      required this.textAlign})
      : super(key: key);

  final TextEditingController messageController;
  final String fontFamily;
  final double fontSize;
  final Color backgroundColour;
  final Color foregroundColour;
  final double width;
  final double height;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      controller: messageController,
      maxLines: null,
      expands: true,
      decoration: InputDecoration(
        hintText: 'Message*',
        fillColor: backgroundColour,
        filled: true,
        border: InputBorder.none,
        errorMaxLines: 2,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)
      ),
      validator: Validator.isEmpty,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.getFont(fontFamily,
          fontSize: fontSize, color: foregroundColour),
      textAlign: textAlign,
    );
  }
}
