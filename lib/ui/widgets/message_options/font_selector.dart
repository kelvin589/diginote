import 'package:diginote/ui/widgets/font_picker.dart';
import 'package:flutter/material.dart';

class FontSelector extends StatelessWidget {
  const FontSelector(
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
