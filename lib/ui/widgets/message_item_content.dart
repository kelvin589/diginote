import 'package:auto_size_text/auto_size_text.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageItemContent extends StatelessWidget {
  const MessageItemContent(
      {Key? key,
      required this.message,
      this.width = 100,
      this.height = 100,
      required this.selected})
      : super(key: key);

  final Message message;
  final double width;
  final double height;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: !selected ? const Border() : Border.all(color: Colors.black),
      ),
      child: StickyNote(
        color: Color(message.backgrondColour),
        width: width,
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              message.header != ""
                  ? SizedBox(
                      height: height * 0.25,
                      width: width,
                      child: AutoSizeText(
                        message.header,
                        minFontSize: 3,
                        style: GoogleFonts.getFont(message.fontFamily,
                            fontSize: message.fontSize,
                            color: Color(message.foregroundColour)),
                      ),
                    )
                  : Container(),
              Expanded(
                child: Center(
                  child: AutoSizeText(
                    message.message,
                    minFontSize: 3,
                    style: GoogleFonts.getFont(message.fontFamily,
                        fontSize: message.fontSize,
                        color: Color(message.foregroundColour)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StickyNote extends StatelessWidget {
  const StickyNote({Key? key, required this.child, required this.color, required this.width, required this.height})
      : super(key: key);

  final Widget child;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _StickyNotePainter(color: color),
        child: Center(
          child: SizedBox(
            width: width * 0.75,
            height: height * 0.75,
            child: child,
          ),
        ),
      ),
    );
  }
}

// Code for the StickyNotePainter has been taken from this github:
// https://github.com/flutter-clutter/flutter-sticky-note/blob/master/lib/sticky_note.dart
class _StickyNotePainter extends CustomPainter {
  _StickyNotePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    _drawShadow(size, canvas);
    Paint gradientPaint = _createGradientPaint(size);
    _drawNote(size, canvas, gradientPaint);
  }

  void _drawNote(Size size, Canvas canvas, Paint gradientPaint) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    double foldAmount = 0.12;
    path.lineTo(size.width * 3 / 4, size.height);

    path.quadraticBezierTo(size.width * foldAmount * 2, size.height,
        size.width * foldAmount, size.height - (size.height * foldAmount));
    path.quadraticBezierTo(
        0, size.height - (size.height * foldAmount * 1.5), 0, size.height / 4);
    path.lineTo(0, 0);

    canvas.drawPath(path, gradientPaint);
  }

  Paint _createGradientPaint(Size size) {
    Paint paint = Paint();

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    RadialGradient gradient = RadialGradient(
        colors: [brighten(color), color],
        radius: 1.0,
        stops: const [0.5, 1.0],
        center: Alignment.bottomLeft);
    paint.shader = gradient.createShader(rect);
    return paint;
  }

  void _drawShadow(Size size, Canvas canvas) {
    Rect rect = Rect.fromLTWH(12, 12, size.width - 24, size.height - 24);
    Path path = Path();
    path.addRect(rect);
    canvas.drawShadow(path, Colors.black.withOpacity(0.7), 12.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  Color brighten(Color c, [int percent = 30]) {
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }
}
