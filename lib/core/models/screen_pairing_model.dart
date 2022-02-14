class ScreenPairing {
  ScreenPairing({required this.pairingCode, required this.paired});

  ScreenPairing.fromJson(Map<String, Object?> json)
      : this(
          pairingCode: json['pairingCode']! as String,
          paired: json['paired']! as bool,
        );

  final String pairingCode;
  final bool paired;

  Map<String, Object?> toJson() {
    return {
      'pairingCode': pairingCode,
      'paired': paired,
    };
  }
}
