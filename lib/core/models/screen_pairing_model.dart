class ScreenPairing {
  ScreenPairing({required this.pairingCode, required this.paired, required this.name, required this.userID});

  ScreenPairing.fromJson(Map<String, Object?> json)
      : this(
          pairingCode: json['pairingCode']! as String,
          paired: json['paired']! as bool,
          name: json['name']! as String,
          userID: json['userID']! as String,
        );

  final String pairingCode;
  final bool paired;
  final String name;
  final String userID;

  Map<String, Object?> toJson() {
    return {
      'pairingCode': pairingCode,
      'paired': paired,
      'name': name,
      'userID': userID,
    };
  }
}
