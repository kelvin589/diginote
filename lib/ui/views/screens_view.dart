import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:flutter/material.dart';

class ScreensView extends StatefulWidget {
  const ScreensView({Key? key}) : super(key: key);

  @override
  _ScreensViewState createState() => _ScreensViewState();
}

class _ScreensViewState extends State<ScreensView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screens'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconHelper.screensIcon,
            label: 'Screens',
          ),
          BottomNavigationBarItem(
            icon: IconHelper.templatesIcon,
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: IconHelper.settingsIcon,
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
