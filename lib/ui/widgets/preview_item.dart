import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter/material.dart';

class PreviewItem extends StatelessWidget {
  const PreviewItem({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: message.x,
      top: message.y,
      child: Container(
        color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.header),
            Text(message.message),
          ],
        ),
      ),
    );
  }
}
