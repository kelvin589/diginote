import 'package:diginote/core/providers/zoom_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  late ZoomProvider zoomProvider;

  setUp(() async {
    zoomProvider = ZoomProvider();
  });

  test('Zoom is increased by the correct amount', () async {
    double currentZoom = zoomProvider.zoom;
    zoomProvider.zoomIn();
    expect(zoomProvider.zoom, currentZoom + ZoomProvider.zoomAmount);
  });

  test('Zoom is decreased by the correct amount', () async {
    zoomProvider.zoomIn();
    double currentZoom = zoomProvider.zoom;
    zoomProvider.zoomOut();
    expect(zoomProvider.zoom, currentZoom - ZoomProvider.zoomAmount);
  });

  test('Zoom is locked to its maximum', () async {
    double currentZoom = zoomProvider.zoom;
    // Calculate the number of zooms to reach the maximum
    double numberOfZooms = (ZoomProvider.maxZoom - currentZoom) / ZoomProvider.zoomAmount;

    // Execute the method the required number of times + 1
    for (int zoomCount = 0; zoomCount <= numberOfZooms + 1; zoomCount++) {
      zoomProvider.zoomIn();
    }

    expect(zoomProvider.zoom, ZoomProvider.maxZoom);
  });

  test('Zoom is locked to its minimum', () async {
    double currentZoom = zoomProvider.zoom;
    // Calculate the number of zooms to reach the minimun
    double numberOfZooms = (currentZoom - ZoomProvider.minZoom) / ZoomProvider.zoomAmount;

    // Execute the method the required number of times + 1
    for (int zoomCount = 0; zoomCount <= numberOfZooms + 1; zoomCount++) {
      zoomProvider.zoomOut();
    }

    expect(zoomProvider.zoom, ZoomProvider.minZoom);
  });
}
