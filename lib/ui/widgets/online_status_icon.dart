import 'package:flutter/material.dart';

class OnlineStatusIcon extends StatelessWidget {
  const OnlineStatusIcon({Key? key, required this.isOnline}) : super(key: key);

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
