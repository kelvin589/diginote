import 'package:flutter/material.dart';

class PreviewListItem extends StatelessWidget {
  const PreviewListItem({Key? key, required this.header, required this.message}) : super(key: key);

  final String header;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(header),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Message: $message'),
        ],
      ),
    );
  }
}
