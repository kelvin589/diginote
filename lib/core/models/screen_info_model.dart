class ScreenInfo {
  ScreenInfo({required this.screenToken, required this.batteryPercentage, required this.lowBatteryThreshold, required this.lowBatteryNotificationDelay, required this.batteryReportingDelay});

  ScreenInfo.fromJson(Map<String, Object?> json)
      : this(
          screenToken: json['screenToken']! as String,
          batteryPercentage: json['batteryPercentage']! as int,
          lowBatteryThreshold: json['lowBatteryThreshold']! as int,
          lowBatteryNotificationDelay: json['lowBatteryNotificationDelay']! as int,
          batteryReportingDelay: json['batteryReportingDelay']! as int,
        );

  final String screenToken;
  final int batteryPercentage;
  int lowBatteryThreshold;
  int lowBatteryNotificationDelay;
  int batteryReportingDelay;

  Map<String, Object?> toJson() {
    return {
      'screenToken': screenToken,
      'batteryPercentage': batteryPercentage,
      'lowBatteryThreshold': lowBatteryThreshold,
      'lowBatteryNotificationDelay': lowBatteryNotificationDelay,
      'batteryReportingDelay': batteryReportingDelay,
    };
  }
}
