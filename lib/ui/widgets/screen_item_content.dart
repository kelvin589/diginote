import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/online_status_icon.dart';
import 'package:flutter/material.dart';

class ScreenItemContent extends StatelessWidget {
  const ScreenItemContent(
      {Key? key,
      required this.screenName,
      required this.lastUpdated,
      required this.batteryPercentage,
      required this.isOnline,
      required this.onSettingsTapped,
      required this.onPreviewTapped})
      : super(key: key);

  final String screenName;
  final DateTime lastUpdated;
  final int batteryPercentage;
  final bool isOnline;
  final Function() onSettingsTapped;
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
          Text('Battery Percentage: $batteryPercentage%'),
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

  String lastUpdatedString(DateTime lastUpdated) {
    String day = lastUpdated.day.toString().padLeft(2, '0');
    String month = lastUpdated.month.toString().padLeft(2, '0');
    int year = lastUpdated.year;
    String hour = lastUpdated.hour.toString().padLeft(2, '0');
    String minute = lastUpdated.minute.toString().padLeft(2, '0');
    return "$day/$month/$year - $hour:$minute";
  }
}
