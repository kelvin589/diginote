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
            Expanded(
              child: TextButton(
                onPressed: () => onMessageSizeChanged(100, 100),
                child: Text(
                  "S",
                  style: TextStyle(
                      color: (currentWidth != 100) ? Colors.black : Colors.red),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => onMessageSizeChanged(150, 150),
                child: Text(
                  "M",
                  style: TextStyle(
                      color: (currentWidth != 150) ? Colors.black : Colors.red),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => onMessageSizeChanged(200, 200),
                child: Text(
                  "L",
                  style: TextStyle(
                      color: (currentWidth != 200) ? Colors.black : Colors.red),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}