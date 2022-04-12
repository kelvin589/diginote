import 'package:auto_size_text/auto_size_text.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A [MessageItemContent] is the widget displaying the [StickyNote] which contains 
/// a [message] within a container of set [width] and [height].
class MessageItemContent extends StatelessWidget {
  /// Creates a [MessageItemContent] displaying the contents of the [message] within
  /// a container of set [width] and [height], which may have an
  /// optional black border if [selected] is true.
  ///
  /// The [width] and [height] are optional. By default, the message is small in size.
  const MessageItemContent({
    Key? key,
    required this.message,
    this.width = 100,
    this.height = 100,
    required this.selected,
  }) : super(key: key);

  /// The [Message] to be displayed.
  final Message message;

  /// The width of the container displaying the [message].
  final double width;

  /// The height of the container displaying the [message].
  final double height;

  /// Whether or not this message is selected.
  ///
  /// If this message is selected, a black border is displayed around the
  /// [MessageItemContent] to indicate that it has been selected.
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
            // The header takes up less room than the message body
            children: [
              message.header != ""
                  ? Expanded(
                      flex: 1,
                      child: AutoSizeText(
                        message.header,
                        minFontSize: 3,
                        style: GoogleFonts.getFont(
                          message.fontFamily,
                          fontSize: message.fontSize,
                          color: Color(message.foregroundColour),
                        ),
                        textAlign:
                            TextAlign.values.byName(message.textAlignment),
                      ),
                    )
                  : Container(),
              Expanded(
                flex: 2,
                child: Center(
                  child: AutoSizeText(
                    message.message,
                    minFontSize: 3,
                    style: GoogleFonts.getFont(
                      message.fontFamily,
                      fontSize: message.fontSize,
                      color: Color(message.foregroundColour),
                    ),
                    textAlign: TextAlign.values.byName(message.textAlignment),
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

/// The decoration for a [MessageItemContent] to make it appear like a post-it note.
class StickyNote extends StatelessWidget {
  /// Creates a [StickyNote] containing the [child] widget with a background [color],
  /// withing a container of fixed [width] and [height].
  const StickyNote({
    Key? key,
    required this.child,
    required this.color,
    required this.width,
    required this.height,
  }) : super(key: key);

  /// The [Widget] to be displayed within the [StickyNote].
  final Widget child;

  /// The background [Color] of the [StickyNote].
  final Color color;

  /// The width of the container displaying the [child].
  final double width;

  /// The height of the container displaying the [child].
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

/// Code for the StickyNotePainter has been taken from this github:
/// https://github.com/flutter-clutter/flutter-sticky-note/blob/master/lib/sticky_note.dart
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
