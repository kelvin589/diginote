class Message {
  Message({
    required this.header,
    required this.message,
    required this.x,
    required this.y,
  });

  Message.fromJson(Map<String, Object?> json)
      : this(
          header: json['header']! as String,
          message: json['message']! as String,
          x: (json['x']! as num).toDouble(),
          y: (json['y']! as num).toDouble(),
        );

  final String header;
  final String message;
  final double x;
  final double y;

  Map<String, Object?> toJson() {
    return {
      'header': header,
      'message': message,
      'x': x,
      'y': y,
    };
  }
}
