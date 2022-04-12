import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/online_status_icon.dart';
import 'package:flutter/material.dart';

/// Displays a screen's basic information and extra information in a tile.
class ScreenItemContent extends StatelessWidget {
  const ScreenItemContent({
    Key? key,
    required this.screenName,
    required this.lastUpdated,
    required this.batteryPercentage,
    required this.isOnline,
    required this.onSettingsTapped,
    required this.onPreviewTapped,
  }) : super(key: key);

  /// The screen's name.
  final String screenName;

  /// The last time some element of this screen was updated.
  ///
  /// For example, when a message was inserted.
  final DateTime lastUpdated;

  /// The 'current' battery percentage of this screen.
  final int batteryPercentage;

  /// The 'current' online status of this screen.
  final bool isOnline;

  /// Called when the settings button is tapped.
  final Function() onSettingsTapped;

  /// Called when the preview button is tapped.
  final Function() onPreviewTapped;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(screenName),
          const Padding(padding: EdgeInsets.only(left: 4)),
          OnlineStatusIcon(isOnline: isOnline),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last Updated: ${lastUpdatedString(lastUpdated)}'),
          _BatteryPercentageText(batteryPercentage: batteryPercentage),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: onSettingsTapped,
            icon: IconHelper.settingsIcon,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: onPreviewTapped,
            icon: IconHelper.previewIcon,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  /// Returns a String formatted version of [lastUpdated].
  String lastUpdatedString(DateTime lastUpdated) {
    String day = lastUpdated.day.toString().padLeft(2, '0');
    String month = lastUpdated.month.toString().padLeft(2, '0');
    int year = lastUpdated.year;
    String hour = lastUpdated.hour.toString().padLeft(2, '0');
    String minute = lastUpdated.minute.toString().padLeft(2, '0');

    return "$day/$month/$year - $hour:$minute";
  }
}

/// Displays the battery percentage.
///
/// The battery percentage text is coloured based on battery percentage.
/// >= 60: green, >= 30: orange, all percentages others are red.
class _BatteryPercentageText extends StatelessWidget {
  const _BatteryPercentageText({
    Key? key,
    required this.batteryPercentage,
  }) : super(key: key);

  /// The current battery percentage.
  final int batteryPercentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Battery Percentage: '),
        Text(
          '$batteryPercentage%',
          style: TextStyle(color: batteryPercentageColour(batteryPercentage)),
        ),
      ],
    );
  }

  /// Returns a [Color] based on the [batteryPercentage], using
  /// a red, orange, green scale.
  Color batteryPercentageColour(int batteryPercentage) {
    if (batteryPercentage >= 60) {
      return Colors.green;
    } else if (batteryPercentage >= 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
