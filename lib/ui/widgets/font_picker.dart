import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPicker extends StatelessWidget {
  const FontPicker(
      {Key? key,
      required this.onFontFamilyChanged,
      required this.onFontSizeChanged,
      this.initialFontFamily,
      this.initialFontSize})
      : super(key: key);

  final void Function(String) onFontFamilyChanged;
  final void Function(double) onFontSizeChanged;
  final String? initialFontFamily;
  final double? initialFontSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        _FontFamily(
          onFontFamilyChanged: onFontFamilyChanged,
          initialFontFamily: initialFontFamily,
        ),
        _FontSize(
          onFontSizeChanged: onFontSizeChanged,
          initialFontSize: initialFontSize,
        ),
      ],
    );
  }
}

class _FontFamily extends StatelessWidget {
  const _FontFamily(
      {Key? key, required this.onFontFamilyChanged, this.initialFontFamily})
      : super(key: key);

  final void Function(String) onFontFamilyChanged;
  final String? initialFontFamily;

  static const int defaultFontIndex = 0;
  static const List<String> fontFamilies = [
    'Roboto',
    'Montserrat',
    'Lato',
    'Poppins',
    'Oswald',
    'Sansita Swashed',
    'Shadows Into Light',
    'Indie Flower',
    'Caveat',
    'Amatic SC',
    'Tajawal',
    'Parisienne'
  ];

  @override
  Widget build(BuildContext context) {
    int fontFamilyIndex = defaultFontIndex;
    if (initialFontFamily != null) {
      fontFamilyIndex = fontFamilies.indexOf(initialFontFamily!);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 140),
      child: DropdownButtonFormField<String>(
        value: fontFamilies[fontFamilyIndex],
        isExpanded: true,
        items: fontFamilies.map((font) {
          return DropdownMenuItem(
            value: font,
            child: Text(
              font,
              style: GoogleFonts.getFont(font),
            ),
          );
        }).toList(),
        onChanged: (selectedFontFamily) {
          if (selectedFontFamily != null) {
            onFontFamilyChanged(selectedFontFamily);
          }
        },
      ),
    );
  }
}

class _FontSize extends StatelessWidget {
  const _FontSize(
      {Key? key, required this.onFontSizeChanged, this.initialFontSize})
      : super(key: key);

  final void Function(double) onFontSizeChanged;
  final double? initialFontSize;

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
    int fontSizeIndex = defaultSizeIndex;
    if (initialFontSize != null) {
      fontSizeIndex = fontSizes.indexOf(initialFontSize!);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 45),
      child: DropdownButtonFormField<double>(
        value: fontSizes[fontSizeIndex],
        isExpanded: true,
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
    );
  }
}
