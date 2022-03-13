class ScreenInfo {
  ScreenInfo({required this.screenToken, required this.batteryPercentage});

  ScreenInfo.fromJson(Map<String, Object?> json)
      : this(
          screenToken: json['screenToken']! as String,
          batteryPercentage: json['batteryPercentage']! as int,
        );

  final String screenToken;
  final int batteryPercentage;

  Map<String, Object?> toJson() {
    return {
      'screenToken': screenToken,
      'batteryPercentage': batteryPercentage,
    };
  }
}
