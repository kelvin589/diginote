import 'package:diginote/ui/views/home_view.dart';
import 'package:diginote/ui/views/preview_view.dart';
import 'package:diginote/ui/views/screens_view.dart';
import 'package:diginote/ui/views/settings_view.dart';
import 'package:diginote/ui/views/templates_view.dart';
import 'package:flutter/material.dart';

enum NavigationPage {
  screens,
  templates,
  settings
}

extension NavigationPageExtension on NavigationPage {
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