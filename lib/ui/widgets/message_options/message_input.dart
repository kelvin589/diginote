import 'package:diginote/ui/shared/input_validators.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays an [TextFormField] to enter the message.
class MessageInput extends StatelessWidget {
  const MessageInput({
    Key? key,
    required this.messageController,
    required this.fontFamily,
    required this.fontSize,
    required this.backgroundColour,
    required this.foregroundColour,
    required this.width,
    required this.height,
    required this.textAlign,
  }) : super(key: key);

  /// The [TextEditingController] for the message input.
  final TextEditingController messageController;

  /// The font family of the message.
  final String fontFamily;

  /// The font size of the message.
  final double fontSize;

  /// The background colour of the message.
  final Color backgroundColour;

  /// The foreground colour of the message.
  final Color foregroundColour;

  /// The width of the message container.
  final double width;

  /// The height of the message container.
  final double height;

  /// The text alignment of the message.
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
      ),
      validator: Validator.isEmpty,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.getFont(
        fontFamily,
        fontSize: fontSize,
        color: foregroundColour,
      ),
      textAlign: textAlign,
    );
  }
}
