import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColourPickerIcon extends StatefulWidget {
  const ColourPickerIcon(
      {Key? key, required this.onColourChanged, this.initialColour})
      : super(key: key);

  final void Function(Color) onColourChanged;
  final Color? initialColour;

  @override
  State<ColourPickerIcon> createState() => _ColourPickerIconState();
}

class _ColourPickerIconState extends State<ColourPickerIcon> {
  Color pickerColour = Colors.black;

  @override
  void initState() {
    super.initState();
    pickerColour = widget.initialColour ?? Colors.black;
  }

  void changeColour(Color color) {
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
              onColorChanged: changeColour,
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
