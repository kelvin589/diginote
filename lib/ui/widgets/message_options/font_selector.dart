import 'package:diginote/ui/widgets/font_picker.dart';
import 'package:flutter/material.dart';

/// Displays the [FontPicker] to adjust the font family and font size
/// from a pre-set list of values.
class FontSelector extends StatelessWidget {
  const FontSelector({
    Key? key,
    required this.onFontFamilyChanged,
    required this.onFontSizeChanged,
    this.initialFontFamily,
    this.initialFontSize,
  }) : super(key: key);

  /// Called when a font family is selected in [FontPicker].
  final void Function(String) onFontFamilyChanged;

  /// Called when a font size is selected in [FontPicker].
  final void Function(double) onFontSizeChanged;

  /// The initial font family to be selected in [FontPicker].
  final String? initialFontFamily;

  /// The initial font size to be selected in [FontPicker].
  final double? initialFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Font'),
        FontPicker(
          onFontFamilyChanged: onFontFamilyChanged,
          onFontSizeChanged: onFontSizeChanged,
          initialFontFamily: initialFontFamily,
          initialFontSize: initialFontSize,
        ),
      ],
    );
  }
}
