import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:diginote/core/repositories/firebase_screens_repository.dart';
import 'package:flutter/material.dart';

class FirebaseScreensProvider extends ChangeNotifier {
  final FirebaseScreensRepository _screensRepository = FirebaseScreensRepository();

  bool addScreen(ScreenPairing screenPairing) {
    return _screensRepository.addScreen(screenPairing);
  }

  Stream<Iterable<ScreenPairing>> getScreens() {
    return _screensRepository.getScreens();
  }
}
