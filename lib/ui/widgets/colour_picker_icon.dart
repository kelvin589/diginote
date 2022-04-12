import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Displays a [ColorPicker] in an [AlertDialog] to pick a colour.
class ColourPickerIcon extends StatefulWidget {
  const ColourPickerIcon({
    Key? key,
    required this.onColourChanged,
    this.initialColour,
  }) : super(key: key);

  /// Called when a colour is selected.
  final void Function(Color) onColourChanged;

  /// The initial colour to be displayed.
  final Color? initialColour;

  @override
  State<ColourPickerIcon> createState() => _ColourPickerIconState();
}

class _ColourPickerIconState extends State<ColourPickerIcon> {
  /// The picker colour
  Color pickerColour = Colors.black;

  /// In [initState] set the initial colour from the [ColourPickerIcon], if set.
  @override
  void initState() {
    super.initState();
    pickerColour = widget.initialColour ?? Colors.black;
  }

  /// Called when the colour is changed
  void onColourChanged(Color color) {
    setState(() => pickerColour = color);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Pick a colour!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColour,
              onColorChanged: onColourChanged,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                widget.onColourChanged(pickerColour);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      icon: IconHelper.colourPickerIcon,
      constraints: const BoxConstraints(),
    );
  }
}
