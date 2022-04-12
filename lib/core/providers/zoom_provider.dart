import 'package:flutter/material.dart';

/// A provider which manages the zoom scale of messages in the preview.
class ZoomProvider extends ChangeNotifier {
  /// The minimum zoom scale.
  static const double minZoom = 1;

  /// The maximum zoom scale.
  static const double maxZoom = 3;

  /// The amount by which [_zoom] is adjusted when zoomed in or out.
  static const double zoomAmount = 0.2;

  /// The current zoom scale.
  double _zoom = 1;

  /// Returns the current [_zoom].
  double get zoom => _zoom;

  /// Increases the current [_zoom] by [zoomAmount].
  void zoomIn() {
    _zoom = (_zoom + zoomAmount).clamp(minZoom, maxZoom);
    notifyListeners();
  }

  /// Decreases the current [_zoom] by [zoomAmount].
  void zoomOut() {
    _zoom = (_zoom - zoomAmount).clamp(minZoom, maxZoom);
    notifyListeners();
  }
}
