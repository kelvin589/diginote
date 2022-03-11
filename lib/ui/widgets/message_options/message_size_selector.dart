import 'package:flutter/material.dart';

class MessageSizeSelector extends StatelessWidget {
  const MessageSizeSelector(
      {Key? key,
      required this.onMessageSizeChanged,
      required this.currentWidth,
      required this.currentHeight})
      : super(key: key);

  final Function(double, double) onMessageSizeChanged;
  final double currentWidth;
  final double currentHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Message Size"),
        Row(
          children: [
            TextButton(
              onPressed: () => onMessageSizeChanged(100, 100),
              child: Text(
                "Small",
                style: TextStyle(
                    color: (currentWidth != 100) ? Colors.black : Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => onMessageSizeChanged(150, 150),
              child: Text(
                "Medium",
                style: TextStyle(
                    color: (currentWidth != 150) ? Colors.black : Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => onMessageSizeChanged(200, 200),
              child: Text(
                "Large",
                style: TextStyle(
                    color: (currentWidth != 200) ? Colors.black : Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}