import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/widgets/screen_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return StreamBuilder<Iterable<ScreenPairing>>(
      stream: Provider.of<FirebaseScreensProvider>(context, listen: false).getScreens(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${(snapshot.error.toString())}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Waiting');
        }

        Iterable<ScreenPairing>? screens = snapshot.data;
        if (screens != null) {
          print(screens.length);
          return Text('${screens.length}');
        } else {
          return const Text('didnt work');
        }
      },
    );

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
