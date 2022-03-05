import 'package:flutter/material.dart';

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

class Footer extends StatelessWidget {
  const Footer(
      {Key? key,
      required this.footerText,
      required this.buttonText,
      required this.onPressed})
      : super(key: key);

  final String footerText;
  final String buttonText;
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
