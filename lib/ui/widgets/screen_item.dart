import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:flutter/material.dart';

class ScreenItem extends StatelessWidget {
  const ScreenItem(
      {Key? key,
      required this.screenName,
      required this.lastUpdated,
      required this.batteryPercentage})
      : super(key: key);

  final String screenName;
  final DateTime lastUpdated;
  final int batteryPercentage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(screenName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last Updated: ${lastUpdatedString(lastUpdated)}'),
          Text('Battery Percentage: $batteryPercentage%'),
        ],
      ),
      trailing: const _ActionButtons(),
    );
  }

  String lastUpdatedString(DateTime lastUpdated) {
    String day = lastUpdated.day.toString().padLeft(2,'0');
    String month = lastUpdated.month.toString().padLeft(2,'0');
    int year = lastUpdated.year;
    String hour = lastUpdated.hour.toString().padLeft(2,'0');
    String minute = lastUpdated.minute.toString().padLeft(2,'0');
    return "$day/$month/$year - $hour:$minute";
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        settingsButton(context),
        const SizedBox(width: 10),
        previewButton(context),
      ],
    );
  }

  void _onTapped(BuildContext context, String message) {
    DialogueHelper.showSuccessDialogue(context, 'Tapped', message);
  }

  Widget settingsButton(BuildContext context) {
    return IconButton(
      onPressed: () => _onTapped(context, 'Settings'), 
      icon: IconHelper.settingsIcon,
      constraints: const BoxConstraints(),
    );
  }
  Widget previewButton(BuildContext context) {
    return IconButton(
      onPressed: () => _onTapped(context, 'Preview'), 
      icon: IconHelper.previewIcon,
      constraints: const BoxConstraints(),
    );
  }
}
