import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a font picker to adjust the font family and font size
/// from a pre-set list of values.
///
/// Made up of [_FontFamily] and [_FontSize].
class FontPicker extends StatelessWidget {
  const FontPicker({
    Key? key,
    required this.onFontFamilyChanged,
    required this.onFontSizeChanged,
    this.initialFontFamily,
    this.initialFontSize,
  }) : super(key: key);

  /// Called when a font family is selected.
  final void Function(String) onFontFamilyChanged;

  /// Called when a font size is selected.
  final void Function(double) onFontSizeChanged;

  /// The initial font family selected.
  final String? initialFontFamily;

  /// The initial font size selected.
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

/// Picks the font family from a pre-set list of font families.
class _FontFamily extends StatelessWidget {
  const _FontFamily({
    Key? key,
    required this.onFontFamilyChanged,
    this.initialFontFamily,
  }) : super(key: key);

  /// Called when a font family is selected.
  final void Function(String) onFontFamilyChanged;

  /// The initial font family selected.
  final String? initialFontFamily;

  /// The default if no initial font family is selected.
  static const int defaultFontIndex = 0;

  /// The list of font families.
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
    'Parisienne',
    'Ceviche One',
    'Merienda',
    'Gochi Hand',
    'Just Me Again Down Here',
    'La Belle Aurore',
    'Walter Turncoat',
    'Cedarville Cursive'
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
        items: fontFamilies.map(
          (font) {
            return DropdownMenuItem(
              value: font,
              child: Text(
                font,
                style: GoogleFonts.getFont(font),
              ),
            );
          },
        ).toList(),
        onChanged: (selectedFontFamily) {
          if (selectedFontFamily != null) {
            onFontFamilyChanged(selectedFontFamily);
          }
        },
      ),
    );
  }
}

/// Picks the font size from a pre-set list of font sizes.
class _FontSize extends StatelessWidget {
  const _FontSize(
      {Key? key, required this.onFontSizeChanged, this.initialFontSize})
      : super(key: key);

  /// Called when a font size is selected.
  final void Function(double) onFontSizeChanged;

  /// The initial font size selected.
  final double? initialFontSize;

  /// The default if no initial font size is selected.
  static const int defaultSizeIndex = 3;

  /// The list of font sizes.
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
