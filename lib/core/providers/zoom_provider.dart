import 'package:flutter/material.dart';

class ZoomProvider extends ChangeNotifier {
  double _zoom = 1;

  double get zoom => _zoom;

  void zoomIn() {
    _zoom = (_zoom + 0.2).clamp(1, 3);
    notifyListeners();
  }

  void zoomOut() {
    _zoom = (_zoom - 0.2).clamp(1, 3);
    notifyListeners();
  }
}