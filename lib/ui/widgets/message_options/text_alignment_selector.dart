import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:flutter/material.dart';

// TODO: Implement text alignemnt selector
class TextAlignmentSelector extends StatelessWidget {
  const TextAlignmentSelector({Key? key, required this.initialTextAlignment, required this.onTextAlignmentChanged}) : super(key: key);

  final buttonPadding = EdgeInsets.zero;
  final TextAlign initialTextAlignment;
  final void Function(TextAlign) onTextAlignmentChanged;

  @override
  Widget build(BuildContext context) {
    final Widget alignment = Row(
      children: [
        Expanded(
          child: IconButton(
            onPressed: () => onTextAlignmentChanged(TextAlign.left),
            icon: IconHelper.leftAlignIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => onTextAlignmentChanged(TextAlign.center),
            icon: IconHelper.centreAlignIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => onTextAlignmentChanged(TextAlign.right),
            icon: IconHelper.rightAlignIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => onTextAlignmentChanged(TextAlign.justify),
            icon: IconHelper.justifyAlignIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
          ),
        ),
      ],
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Text Alignment'),
        alignment,
      ],
    );
  }
}
