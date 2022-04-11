import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays an [AutoSizeTextField] to enter the header. 
class HeaderInput extends StatelessWidget {
  const HeaderInput({
    Key? key,
    required this.headerController,
    required this.fontFamily,
    required this.fontSize,
    required this.backgroundColour,
    required this.foregroundColour,
    required this.width,
    required this.height,
    required this.textAlign,
  }) : super(key: key);

  /// The [TextEditingController] for the header input.
  final TextEditingController headerController;

  /// The font family of the header.
  final String fontFamily;

  /// The font size of the header.
  final double fontSize;

  /// The background colour of the header.
  final Color backgroundColour;

  /// The foreground colour of the header.
  final Color foregroundColour;

  /// The width of the header container.
  final double width;

  /// The height of the header container.
  final double height;

  /// The text alignment of the header.
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
      style: GoogleFonts.getFont(
        fontFamily,
        fontSize: fontSize,
        color: foregroundColour,
        height: 0.1,
      ),
      textAlign: textAlign,
    );
  }
}
