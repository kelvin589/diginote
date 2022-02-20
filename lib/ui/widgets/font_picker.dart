import 'package:flutter/material.dart';

class FontPicker extends StatelessWidget {
  const FontPicker(
      {Key? key,
      required this.onFontFamilyChanged,
      required this.onFontSizeChanged})
      : super(key: key);

  final void Function(String) onFontFamilyChanged;
  final void Function(double) onFontSizeChanged;

  static const List<String> fontFamilies = [
    'Roboto',
    'Montserrat',
    'Lato',
    'Poppins',
    'Oswald',
  ];

  static const List<double> fontSizes = [10, 12, 14, 16, 18, 24, 30, 36, 48, 60];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            value: fontFamilies[0],
            items: fontFamilies.map((font) {
              return DropdownMenuItem(
                value: font,
                child: Text(font),
              );
            }).toList(),
            onChanged: (selectedFontFamily) {
              if (selectedFontFamily != null) {
                onFontFamilyChanged(selectedFontFamily);
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<double>(
            value: fontSizes[3],
            items: fontSizes.map((font) {
              return DropdownMenuItem(
                value: font,
                child: Text(font.toInt().toString()),
              );
            }).toList(),
            onChanged: (selectedFontSize) {
              if (selectedFontSize != null) {
                onFontSizeChanged(selectedFontSize);
              }
            },
          ),
        ),
      ],
    );
  }
}
