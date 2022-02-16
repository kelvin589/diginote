class Message {
  Message({required this.header, required this.message,});

  Message.fromJson(Map<String, Object?> json)
      : this(
          header: json['header']! as String,
          message: json['message']! as String,
        );

  final String header;
  final String message;

  Map<String, Object?> toJson() {
    return {
      'header': header,
      'message': message,
    };
  }
}