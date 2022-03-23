import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:flutter/material.dart';

class TypefaceSelector extends StatelessWidget {
  const TypefaceSelector({Key? key}) : super(key: key);

  final buttonPadding = EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    final Widget typeface = Row(
      children: [
        Expanded(
          child: IconButton(
            onPressed: () => {},
            icon: IconHelper.boldIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => {},
            icon: IconHelper.italicIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => {},
            icon: IconHelper.strikethroughIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => {},
            icon: IconHelper.underlineIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Typeface'),
        typeface,
      ],
    );
  }
}
