import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/views/preview_view.dart';
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
          return const CircularProgressIndicator();
        }

        Iterable<ScreenPairing>? screens = snapshot.data;
        if (screens != null) {
          List<Widget> items = <Widget>[];
          items = _updateScreenItems(context, screens);
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
        } else {
          return const Text('Error occurred');
        }
      },
    );
  }

  List<Widget> _updateScreenItems(
      BuildContext context, Iterable<ScreenPairing>? screens) {
    const batteryPercentage = 100;
    List<Widget> screenItems = [];

    if (screens != null) {
      for (ScreenPairing screen in screens) {
        screenItems.add(ScreenItem(
          screenName: screen.name,
          lastUpdated: screen.lastUpdated,
          batteryPercentage: batteryPercentage,
          onPreviewTapped: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PreviewView(
                        screenToken: screen.screenToken,
                        screenWidth: screen.width,
                        screenHeight: screen.height,
                        screenName: screen.name),
              ),
            ),
          },
          onSettingsTapped: () => _showScreenSettingsPopup(context, screen.screenToken),
        ));
      }
    }

    return screenItems;
  }

  void _showScreenSettingsPopup(BuildContext context, String screenToken) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Settings"),
        content: _deleteScreenButton(context, screenToken),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _deleteScreenButton(BuildContext context, String screenToken) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await Provider.of<FirebaseScreensProvider>(context, listen: false)
                .deleteScreen(screenToken);
          },
          child: const Text("Delete Screen"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ),
    );
  }
}
