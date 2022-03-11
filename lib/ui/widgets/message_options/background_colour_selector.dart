import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/colour_picker.dart';
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
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => ColourPicker(
              onColourChanged: onColourChanged,
              initialColour: initialColour,
            ),
          ),
          icon: IconHelper.colourPickerIcon,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
