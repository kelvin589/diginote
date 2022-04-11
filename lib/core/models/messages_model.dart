import 'package:cloud_firestore/cloud_firestore.dart';

/// A representation of a sticky note.
class Message {

  /// Constructs a [Message] instance with the specified customisations.
  Message({
    required this.header,
    required this.message,
    required this.x,
    required this.y,
    required this.id,
    required this.from,
    required this.to,
    required this.scheduled,
    required this.fontFamily,
    required this.fontSize,
    required this.backgrondColour,
    required this.foregroundColour,
    required this.width,
    required this.height,
    required this.textAlignment,
  });

  /// Named constructor to create [Message] from a Map.
  Message.fromJson(Map<String, Object?> json)
      : this(
          header: json['header']! as String,
          message: json['message']! as String,
          x: (json['x']! as num).toDouble(),
          y: (json['y']! as num).toDouble(),
          id: json['id']! as String,
          from: DateTime.parse((json['from']! as Timestamp).toDate().toString()),
          to: DateTime.parse((json['to']! as Timestamp).toDate().toString()),
          scheduled: (json['scheduled'])! as bool,
          fontFamily: json['fontFamily']! as String,
          fontSize: (json['fontSize']! as num).toDouble(),
          backgrondColour: json['backgrondColour']! as int,
          foregroundColour: json['foregroundColour']! as int,
          width: (json['width']! as num).toDouble(),
          height: (json['height']! as num).toDouble(),
          textAlignment: json['textAlignment']! as String, 
        );

  /// The content in header.
  final String header;

  /// The content in the main body.
  final String message;

  /// The x position on the screen device.
  double x;

  /// The y position on the screen device.
  double y;

  /// The id retrieved of this message, retrieved from storage.
  final String id;

  /// The [DateTime] from which this message is displayed.
  final DateTime from;

  /// The [DateTime] until which this message is displayed.
  final DateTime to;

  /// The scheduling status.
  /// 
  /// True if the message has a schedule, otherwise false.
  final bool scheduled;

  /// The font family of the [header] and [message].
  final String fontFamily;

  /// The font size of the [header] and [message].
  final double fontSize; 

  /// The background colour of the message.
  final int backgrondColour;

  /// The foreground colour of the message i.e., text colour.
  final int foregroundColour;

  /// The width of this message.
  final double width;

  /// The height of this message.
  final double height;

  /// The text alignment.
  /// 
  /// Valid alignments: left, right, center and justify.
  final String textAlignment;

  /// The current instance as a [Map].
  Map<String, Object?> toJson() {
    // The id is not added to the map as it is not necessary.
    return {
      'header': header,
      'message': message,
      'x': x,
      'y': y,
      'from': Timestamp.fromDate(from),
      'to': Timestamp.fromDate(to),
      'scheduled': scheduled,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'backgrondColour': backgrondColour,
      'foregroundColour': foregroundColour,
      'width': width,
      'height': height,
      'textAlignment': textAlignment,
    };
  }
}
