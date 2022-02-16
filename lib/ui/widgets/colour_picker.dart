//https://pub.dev/packages/flutter_colorpicker
//Using adapted code from example in flutter colorpicker

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColourPicker extends StatefulWidget {
  const ColourPicker({Key? key, required this.onColourChanged})
      : super(key: key);

  final void Function(Color) onColourChanged;

  @override
  State<ColourPicker> createState() => _ColourPickerState();
}

class _ColourPickerState extends State<ColourPicker> {
  Color pickerColour = Colors.black;

  void changeColour(Color color) {
    setState(() => pickerColour = color);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColour,
          onColorChanged: changeColour,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Got it'),
          onPressed: () {
            widget.onColourChanged(pickerColour);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
