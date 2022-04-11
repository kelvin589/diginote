import 'package:diginote/ui/widgets/colour_picker_icon.dart';
import 'package:flutter/material.dart';

/// Displays a [ColourPickerIcon] to select the background colour.
class BackgroundColourSelector extends StatelessWidget {
  const BackgroundColourSelector({
    Key? key,
    required this.onColourChanged,
    this.initialColour,
  }) : super(key: key);

  /// Called when a colour is selected in [ColourPickerIcon].
  final void Function(Color) onColourChanged;

  /// The initial colour to be displayed in [ColourPickerIcon].
  final Color? initialColour;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Background Colour'),
        ColourPickerIcon(
            initialColour: initialColour, onColourChanged: onColourChanged),
      ],
    );
  }
}
