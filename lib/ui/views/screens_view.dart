import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/widgets/screen_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreensView extends StatelessWidget {
  const ScreensView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<ScreenPairing>>(
      stream: Provider.of<FirebaseScreensProvider>(context, listen: false)
          .getScreens(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${(snapshot.error.toString())}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Waiting');
        }

        Iterable<ScreenPairing>? screens = snapshot.data;
        if (screens != null) {
          List<Widget> items = <Widget>[];
          items = _updateScreenItems(screens);
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  items[index],
                  Provider.of<FirebaseScreensProvider>(context).isEditing ? _deleteScreenButton(context) : Container(),
                  const Divider(),
                ],
              );
            },
          );
        } else {
          return const Text('Error occurred');
        }
      },
    );
  }

  List<Widget> _updateScreenItems(Iterable<ScreenPairing>? screens) {
    const batteryPercentage = 100;
    List<Widget> screenItems = [];

    if (screens != null) {
      for (ScreenPairing screen in screens) {
        screenItems.add(ScreenItem(
            screenName: screen.name,
            lastUpdated: screen.lastUpdated,
            batteryPercentage: batteryPercentage));
      }
    }

    return screenItems;
  }

  Widget _deleteScreenButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Provider.of<FirebaseScreensProvider>(context, listen: false).deleteScreen(), 
          child: const Text("Delete"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ),
    );
  }
}
