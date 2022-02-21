class Message {
  Message({
    required this.header,
    required this.message,
    required this.x,
    required this.y,
    required this.id,
  });

  Message.fromJson(Map<String, Object?> json)
      : this(
          header: json['header']! as String,
          message: json['message']! as String,
          x: (json['x']! as num).toDouble(),
          y: (json['y']! as num).toDouble(),
          id: json['id']! as String,
        );

  final String header;
  final String message;
  double x;
  double y;
  String id;

  // Don't add id as field in firebase doc
  Map<String, Object?> toJson() {
    return {
      'header': header,
      'message': message,
      'x': x,
      'y': y,
    };
  }
}
