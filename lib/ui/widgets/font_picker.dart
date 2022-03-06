import 'package:flutter/material.dart';

class FontPicker extends StatelessWidget {
  const FontPicker(
      {Key? key,
      required this.onFontFamilyChanged,
      required this.onFontSizeChanged})
      : super(key: key);

  final void Function(String) onFontFamilyChanged;
  final void Function(double) onFontSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _FontFamily(onFontFamilyChanged: onFontFamilyChanged),
        ),
        Expanded(
          flex: 1,
          child: _FontSize(onFontSizeChanged: onFontSizeChanged),
        ),
      ],
    );
  }
}

class _FontFamily extends StatelessWidget {
  const _FontFamily({Key? key, required this.onFontFamilyChanged})
      : super(key: key);

  final void Function(String) onFontFamilyChanged;

  static const int defaultFontIndex = 0;
  static const List<String> fontFamilies = [
    'Roboto',
    'Montserrat',
    'Lato',
    'Poppins',
    'Oswald',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: fontFamilies[defaultFontIndex],
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
    );
  }
}

class _FontSize extends StatelessWidget {
  const _FontSize({Key? key, required this.onFontSizeChanged})
      : super(key: key);

  final void Function(double) onFontSizeChanged;

  static const int defaultSizeIndex = 3;
  static const List<double> fontSizes = [
    10,
    12,
    14,
    16,
    18,
    24,
    30,
    36,
    48,
    60
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<double>(
      value: fontSizes[defaultSizeIndex],
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
    );
  }
}
