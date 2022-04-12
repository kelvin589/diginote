/// A screen's extra information.
class ScreenInfo {
  /// Constructs a [ScreenInfo] instance with a screen's extra information.
  ScreenInfo({
    required this.screenToken,
    required this.batteryPercentage,
    required this.lowBatteryThreshold,
    required this.lowBatteryNotificationDelay,
    required this.batteryReportingDelay,
    required this.isOnline,
  });

  /// Named constructor to create [ScreenInfo] from a Map.
  ScreenInfo.fromJson(Map<String, Object?> json)
      : this(
          screenToken: json['screenToken']! as String,
          batteryPercentage: json['batteryPercentage']! as int,
          lowBatteryThreshold: json['lowBatteryThreshold']! as int,
          lowBatteryNotificationDelay:
              json['lowBatteryNotificationDelay']! as int,
          batteryReportingDelay: json['batteryReportingDelay']! as int,
          isOnline: json['isOnline']! as bool,
        );

  /// The unique identifier of this screen.
  final String screenToken;

  /// The current battery level of this screen.
  final int batteryPercentage;

  /// The threshold at which a 'low battery' notification is sent.
  int lowBatteryThreshold;

  /// The delay between notifications to 'low battery'.
  int lowBatteryNotificationDelay;

  /// The delay between updating the battery level of this screen.
  int batteryReportingDelay;

  /// The status to the presence of this screen.
  /// 
  /// True if the screen is online, otherwise false.
  final bool isOnline;

  /// The current instance as a [Map].
  Map<String, Object?> toJson() {
    return {
      'screenToken': screenToken,
      'batteryPercentage': batteryPercentage,
      'lowBatteryThreshold': lowBatteryThreshold,
      'lowBatteryNotificationDelay': lowBatteryNotificationDelay,
      'batteryReportingDelay': batteryReportingDelay,
      'isOnline': isOnline,
    };
  }
}
