import 'package:flutter/material.dart';

/// Displays a circle which is green (to indicate an online screen) or
/// red (to indicate an offline screen).
class OnlineStatusIcon extends StatelessWidget {
  /// [isOnline] determines the colour of the circle.
  /// 
  /// Green if true, or red if false.
  const OnlineStatusIcon({Key? key, required this.isOnline}) : super(key: key);

  /// The online status.
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
