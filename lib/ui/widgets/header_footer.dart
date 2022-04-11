import 'package:flutter/material.dart';

/// The header for the app which contains the logo.
class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('assets/logo-noBackground.png'),
      alignment: Alignment.bottomLeft,
    );
  }
}

/// The footer for the app which is made up of [footerText] and a button
/// with [buttonText].
class Footer extends StatelessWidget {
  const Footer({
    Key? key,
    required this.footerText,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  /// The text to be displayed in the footer.
  final String footerText;

  /// The text to be displayed in the button.
  final String buttonText;

  /// Called when the button is pressed.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(footerText),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
