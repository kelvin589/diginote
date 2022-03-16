import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderInput extends StatelessWidget {
  const HeaderInput(
      {Key? key,
      required this.headerController,
      required this.fontFamily,
      required this.fontSize,
      required this.backgroundColour,
      required this.foregroundColour,
      required this.width,
      required this.height,
      required this.textAlign})
      : super(key: key);

  final TextEditingController headerController;
  final String fontFamily;
  final double fontSize;
  final Color backgroundColour;
  final Color foregroundColour;
  final double width;
  final double height;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return AutoSizeTextField(
      maxLines: 1,
      minFontSize: 1,
      controller: headerController,
      decoration: InputDecoration(
        hintText: 'Header',
        fillColor: backgroundColour,
        filled: true,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0,)
      ),
      style: GoogleFonts.getFont(fontFamily,
          fontSize: fontSize, color: foregroundColour, height: 0.1),
      textAlign: textAlign,
    );
  }
}
