import 'package:diginote/ui/views/screens_view.dart';
import 'package:diginote/ui/views/settings_view.dart';
import 'package:diginote/ui/views/templates_view.dart';
import 'package:flutter/material.dart';
import 'package:diginote/ui/shared/icon_helper.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeNavigation();
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key? key}) : super(key: key);

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  // Currently selected page index
  int _selectedIndex = 0;
  // A list of pages to display
  static const List<Widget> _pages = <Widget>[
    ScreensView(),
    TemplatesView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: _pages[_selectedIndex],
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
