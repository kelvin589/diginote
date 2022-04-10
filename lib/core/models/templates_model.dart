class Template {
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

  final String header;
  final String message;
  final String id;
  final String fontFamily;
  final double fontSize;
  final int backgrondColour;
  final int foregroundColour;
  final double width;
  final double height;
  final String textAlignment;

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