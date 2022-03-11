import 'package:flutter/material.dart';

// TODO: Implement text alignemnt selector
class TextAlignmentSelector extends StatelessWidget {
  const TextAlignmentSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Text Alignment'),
      ],
    );
  }
}
