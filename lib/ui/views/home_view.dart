import 'package:diginote/ui/shared/navigation_page_enum.dart';
import 'package:diginote/ui/widgets/add_screen_popup.dart';
import 'package:diginote/ui/widgets/add_template_popup.dart';
import 'package:flutter/material.dart';
import 'package:diginote/ui/shared/icon_helper.dart';

/// The main view of the application containing the navigation which displays
/// each view when pressed.
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  /// The named route for [HomeView]. 
  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return const HomeNavigation();
  }
}

/// The navigation widget which displays the centred page.
class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key? key}) : super(key: key);

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  /// The currently selected page.
  NavigationPage _selectedPage = NavigationPage.screens;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPage.titleText),
      ),
      body: Center(
        child: _selectedPage.widget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconHelper.screensIcon,
            label: NavigationPage.screens.label,
          ),
          BottomNavigationBarItem(
            icon: IconHelper.templatesIcon,
            label: NavigationPage.templates.label,
          ),
          BottomNavigationBarItem(
            icon: IconHelper.settingsIcon,
            label: NavigationPage.settings.label,
          ),
        ],
        currentIndex: _selectedPage.index,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _getFloatingActionButton(_selectedPage),
    );
  }

  /// Updates [_selectedPage], after an item in the [BottomNavigationBar]
  /// is pressed, to display a new view.
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = NavigationPage.values[index];
    });
  }

  /// Returns the [FloatingActionButton] who's action is dependent on the
  /// [page].
  /// 
  /// The [FloatingActionButton] for [NavigationPage.screens] adds a new screen.
  /// The [FloatingActionButton] for [NavigationPage.templates] adds a new template.
  /// All other [NavigationPage] cases do not show a [FloatingActionButton].
  Widget? _getFloatingActionButton(NavigationPage page) {
    switch (page) {
      case NavigationPage.screens:
        return FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddScreenPopup(),
          ),
          child: const Icon(Icons.add),
        );
      case NavigationPage.templates:
        return FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddTemplatePopup(),
          ),
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }
}
