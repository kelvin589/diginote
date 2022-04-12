import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:flutter/material.dart';

/// Displays buttons which adjust the text alignment of message and header
/// based alignments found in [TextAlign].
class TextAlignmentSelector extends StatelessWidget {
  const TextAlignmentSelector({
    Key? key,
    required this.initialTextAlignment,
    required this.onTextAlignmentChanged,
  }) : super(key: key);

  /// The padding between the text alignment buttons.
  final buttonPadding = EdgeInsets.zero;

  /// The initial text alignment.
  final TextAlign initialTextAlignment;

  /// Called with the new text alignemnt when it is adjusted.
  final void Function(TextAlign) onTextAlignmentChanged;

  @override
  Widget build(BuildContext context) {
    // The row of widgets containing the possible alignment options.
    final Widget alignmentOptions = Row(
      children: [
        Expanded(
          child: IconButton(
            onPressed: () => onTextAlignmentChanged(TextAlign.left),
            icon: IconHelper.leftAlignIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
            color: initialTextAlignment != TextAlign.left
                ? Colors.black
                : Colors.red,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => onTextAlignmentChanged(TextAlign.center),
            icon: IconHelper.centreAlignIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
            color: initialTextAlignment != TextAlign.center
                ? Colors.black
                : Colors.red,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => onTextAlignmentChanged(TextAlign.right),
            icon: IconHelper.rightAlignIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
            color: initialTextAlignment != TextAlign.right
                ? Colors.black
                : Colors.red,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => onTextAlignmentChanged(TextAlign.justify),
            icon: IconHelper.justifyAlignIcon,
            constraints: const BoxConstraints(),
            padding: buttonPadding,
            color: initialTextAlignment != TextAlign.justify
                ? Colors.black
                : Colors.red,
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Text Alignment'),
        alignmentOptions,
      ],
    );
  }
}
