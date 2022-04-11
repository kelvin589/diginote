import 'package:diginote/core/models/screen_info_model.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/providers/firebase_screen_info_provider.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/core/providers/zoom_provider.dart';
import 'package:diginote/ui/shared/timer_provider.dart';
import 'package:diginote/ui/views/preview_view.dart';
import 'package:diginote/ui/widgets/screen_item_content.dart';
import 'package:diginote/ui/widgets/screen_settings_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a screen's basic information and extra information using [ScreenItemContent].
class ScreenItem extends StatelessWidget {
  const ScreenItem({Key? key, required this.screen}) : super(key: key);

  /// The screen's basic information to display.
  final Screen screen;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<ScreenInfo>>(
      stream: Provider.of<FirebaseScreenInfoProvider>(context, listen: false)
          .getScreenInfo(screen.screenToken),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${(snapshot.error.toString())}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        ScreenInfo? screenInfo = snapshot.data?.first;
        if (screenInfo != null) {
          return ScreenItemContent(
            screenName: screen.name,
            lastUpdated: screen.lastUpdated,
            batteryPercentage: screenInfo.batteryPercentage,
            isOnline: screenInfo.isOnline,
            onPreviewTapped: () => _showPreview(context, screen, screenInfo.isOnline),
            onSettingsTapped: () => _showScreenSettings(
              context: context,
              screenToken: screen.screenToken,
              screenName: screen.name,
              screenInfo: screenInfo,
            ),
          );
        } else {
          return const Text('Error occurred');
        }
      },
    );
  }

  /// Called to display the screen's [PreviewView] as a new page.
  /// 
  /// [TimerProvider] is necessary to progress the countdown of scheduled messages.
  void _showPreview(BuildContext context, Screen screen, bool isOnline) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<TimerProvider>(
              create: (context) =>
                  TimerProvider(duration: const Duration(seconds: 1)),
            ),
            ChangeNotifierProvider<ZoomProvider>(
              create: (context) => ZoomProvider(),
            ),
          ],
          child: PreviewView(
            screenToken: screen.screenToken,
            screenWidth: screen.width,
            screenHeight: screen.height,
            screenName: screen.name,
            isOnline: isOnline,
          ),
        ),
      ),
    );
  }

  /// Called to display a dialogue of the screen's settings.
  void _showScreenSettings(
      {required BuildContext context,
      required String screenToken,
      required String screenName,
      required ScreenInfo screenInfo}) {
    showDialog(
      context: context,
      builder: (context) => ScreenSettingsPopup(
        screenToken: screenToken,
        screenName: screenName,
        screenInfo: screenInfo,
        onDelete: () async {
          await _onDelete(context, screenToken);
        },
      ),
    );
  }

  /// Called when a screen is to be deleted.
  Future<void> _onDelete(BuildContext context, String screenToken) async {
    await Provider.of<FirebaseScreensProvider>(context, listen: false)
        .deleteScreen(screenToken);
  }
}
