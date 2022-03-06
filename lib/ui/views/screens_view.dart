import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/shared/timer_provider.dart';
import 'package:diginote/ui/views/preview_view.dart';
import 'package:diginote/ui/widgets/screen_item.dart';
import 'package:diginote/ui/widgets/screen_settings_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreensView extends StatelessWidget {
  const ScreensView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<Screen>>(
      stream: Provider.of<FirebaseScreensProvider>(context, listen: false)
          .getScreens(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${(snapshot.error.toString())}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        Iterable<Screen>? screens = snapshot.data;
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
      BuildContext context, Iterable<Screen>? screens) {
    // TODO: Add battery percentage
    const batteryPercentage = 100;

    if (screens != null) {
      return screens
          .map(
            (screen) => ScreenItem(
              screenName: screen.name,
              lastUpdated: screen.lastUpdated,
              batteryPercentage: batteryPercentage,
              onPreviewTapped: () => _showPreview(context, screen),
              onSettingsTapped: () =>
                  _showScreenSettings(context, screen.screenToken),
            ),
          )
          .toList();
    }
    return [];
  }

  void _showPreview(BuildContext context, Screen screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<TimerProvider>(
          create: (context) => TimerProvider(duration: const Duration(seconds: 1)),
          child: PreviewView(
            screenToken: screen.screenToken,
            screenWidth: screen.width,
            screenHeight: screen.height,
            screenName: screen.name,
          ),
        ),
      ),
    );
  }

  void _showScreenSettings(BuildContext context, String screenToken) {
    showDialog(
      context: context,
      builder: (context) => ScreenSettingsPopup(
        screenToken: screenToken,
        onDelete: () async {
          await _onDelete(context, screenToken);
        },
      ),
    );
  }

  Future<void> _onDelete(BuildContext context, String screenToken) async {
    await Provider.of<FirebaseScreensProvider>(context, listen: false)
        .deleteScreen(screenToken);
  }
}
