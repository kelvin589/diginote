/// A representation of a template for a message.
///
/// A stripped down message without coordinates and scheduling information.
class Template {
  /// Constructs a [Template] instance with the specified customisations.
  Template({
    required this.header,
    required this.message,
    required this.id,
    required this.fontFamily,
    required this.fontSize,
    required this.backgrondColour,
    required this.foregroundColour,
    required this.width,
    required this.height,
    required this.textAlignment,
  });

  /// Named constructor to create [Template] from a Map.
  Template.fromJson(Map<String, Object?> json)
      : this(
          header: json['header']! as String,
          message: json['message']! as String,
          id: json['id']! as String,
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

  /// The id of this template, retrieved from storage.
  final String id;

  /// The font family of the [header] and [message].
  final String fontFamily;

  /// The font size of the [header] and [message].
  final double fontSize; 

  /// The background colour of the template.
  final int backgrondColour;

  /// The foreground colour of the template i.e., text colour.
  final int foregroundColour;

  /// The width of this template.
  final double width;

  /// The height of this template.
  final double height;

  /// The text alignment.
  /// 
  /// Valid alignments: left, right, center and justify.
  final String textAlignment;

  /// The current instance as a [Map].
  Map<String, Object?> toJson() {
    return {
      'header': header,
      'message': message,
      'id': id,
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
