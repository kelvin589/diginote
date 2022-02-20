import 'package:cloud_firestore/cloud_firestore.dart';

class ScreenPairing {
  ScreenPairing({required this.pairingCode, required this.paired, required this.name, required this.userID, required this.lastUpdated, required this.screenToken, required this.width, required this.height});

  ScreenPairing.fromJson(Map<String, Object?> json)
      : this(
          pairingCode: json['pairingCode']! as String,
          paired: json['paired']! as bool,
          name: json['name']! as String,
          userID: json['userID']! as String,
          lastUpdated: DateTime.parse((json['lastUpdated']! as Timestamp).toDate().toString()),
          screenToken: json['screenToken']! as String,
          width: (json['width']! as num).toDouble(),
          height: (json['height']! as num).toDouble(),
        );

  final String pairingCode;
  final bool paired;
  final String name;
  final String userID;
  final DateTime lastUpdated;
  final String screenToken;
  final double width;
  final double height;

  Map<String, Object?> toJson() {
    return {
      'pairingCode': pairingCode,
      'paired': paired,
      'name': name,
      'userID': userID,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'screenToken': screenToken,
      'width': width,
      'height': height,
    };
  }
}
