import 'package:diginote/ui/views/screens_view.dart';
import 'package:diginote/ui/views/settings_view.dart';
import 'package:diginote/ui/views/templates_view.dart';
import 'package:flutter/material.dart';

/// An enum representing the current navigation page.
enum NavigationPage {
  screens,
  templates,
  settings
}

/// An extension on [NavigationPage] to add methods which
/// return the relevant widget, title text and label.
extension NavigationPageExtension on NavigationPage {
  /// Returns the widget represented by the [NavigationPage].
  Widget get widget {
    switch (this) {
      case NavigationPage.screens:
        return const ScreensView();
      case NavigationPage.templates:
        return const TemplatesView();
      case NavigationPage.settings:
        return const SettingsView();
    }
  }

  /// Returns the title text represented by the [NavigationPage].
  String get titleText {
    switch (this) {
      case NavigationPage.screens:
        return "Screens";
      case NavigationPage.templates:
        return "Templates";
      case NavigationPage.settings:
        return "Settings";
    }
  }

  /// Returns the label represented by the [NavigationPage].
  /// 
  /// i.e., the text used in the bottom bar.
  String get label {
    switch (this) {
      case NavigationPage.screens:
        return "Screens";
      case NavigationPage.templates:
        return "Templates";
      case NavigationPage.settings:
        return "Settings";
    }
  }
}
