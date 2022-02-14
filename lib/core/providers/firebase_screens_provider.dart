import 'package:diginote/core/repositories/firebase_screens_repository.dart';
import 'package:flutter/material.dart';

class FirebaseScreensProvider extends ChangeNotifier {
  final FirebaseScreensRepository _screensRepository = FirebaseScreensRepository();

  bool addScreen(String pairingCode) {
    return _screensRepository.addScreen(pairingCode);
  }
}
