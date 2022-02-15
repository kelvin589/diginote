import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/views/screens_view.dart';
import 'package:diginote/ui/views/settings_view.dart';
import 'package:diginote/ui/views/templates_view.dart';
import 'package:diginote/ui/widgets/add_screen_popup.dart';
import 'package:flutter/material.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const String route = '/home';

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
        title: Text(_titleText(_selectedIndex)),
        actions: _appbarActions(_selectedIndex),
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

  String _titleText(int index) {
    switch (index) {
      case 0:
        return 'Screens';
      case 1:
        return 'Templates';
      case 2:
        return 'Settings';
      default:
        return 'Unknown Page';
    }
  }

  void _onTapped(BuildContext context, String message) {
    DialogueHelper.showSuccessDialogue(context, 'Tapped', message);
  }

  List<Widget> _appbarActions(int index) {
    switch (index) {
      case 0:
        return [
          IconButton(
            onPressed: () => Provider.of<FirebaseScreensProvider>(context, listen: false).toggleScreensState(),
            icon: IconHelper.editIcon,
          ),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AddScreenPopup(),
            ),
            icon: IconHelper.addIcon,
          ),
        ];
      case 1:
        return [
          IconButton(
            onPressed: () => _onTapped(context, 'Edit templates'),
            icon: IconHelper.editIcon,
          ),
          IconButton(
            onPressed: () => _onTapped(context, 'Add templates'),
            icon: IconHelper.addIcon,
          ),
        ];
      default:
        return [];
    }
  }
}
