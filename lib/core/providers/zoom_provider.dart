import 'package:flutter/material.dart';

class ZoomProvider extends ChangeNotifier {
  static const double minZoom = 1;
  static const double maxZoom = 3;
  static const double zoomAmount = 0.2;

  double _zoom = 1;

  double get zoom => _zoom;

  void zoomIn() {
    _zoom = (_zoom + zoomAmount).clamp(minZoom, maxZoom);
    notifyListeners();
  }

  void zoomOut() {
    _zoom = (_zoom - zoomAmount).clamp(minZoom, maxZoom);
    notifyListeners();
  }
}
