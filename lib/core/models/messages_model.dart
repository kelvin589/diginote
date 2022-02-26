import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.header,
    required this.message,
    required this.x,
    required this.y,
    required this.id,
    required this.from,
    required this.to,
    required this.scheduled,
  });

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
        );

  final String header;
  final String message;
  double x;
  double y;
  String id;
  DateTime from;
  DateTime to;
  bool scheduled;

  // Don't add id as field in firebase doc
  Map<String, Object?> toJson() {
    return {
      'header': header,
      'message': message,
      'x': x,
      'y': y,
      'from': Timestamp.fromDate(from),
      'to': Timestamp.fromDate(to),
      'scheduled': scheduled,
    };
  }
}
