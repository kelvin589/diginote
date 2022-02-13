import 'package:diginote/ui/widgets/screen_item.dart';
import 'package:flutter/material.dart';

class ScreensView extends StatelessWidget {
  const ScreensView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastUpdated = DateTime.now();
    const batteryPercentage = 100;
    
    final items = <Widget>[
      ScreenItem(screenName: 'First', lastUpdated: lastUpdated, batteryPercentage: batteryPercentage,),
      ScreenItem(screenName: 'Second', lastUpdated: lastUpdated, batteryPercentage: batteryPercentage,),
      ScreenItem(screenName: 'Third', lastUpdated: lastUpdated, batteryPercentage: batteryPercentage,),
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            items[index],
            const Divider(),
          ],
        );
      },
    );
  }
}
