import 'package:diginote/ui/widgets/colour_picker_icon.dart';
import 'package:flutter/material.dart';

class BackgroundColourSelector extends StatelessWidget {
  const BackgroundColourSelector(
      {Key? key, required this.onColourChanged, this.initialColour})
      : super(key: key);

  final void Function(Color) onColourChanged;
  final Color? initialColour;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Background Colour'),
        ColourPickerIcon(initialColour: initialColour, onColourChanged: onColourChanged),
      ],
    );
  }
}
