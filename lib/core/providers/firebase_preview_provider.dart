import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/repositories/firebase_preview_repository.dart';
import 'package:flutter/material.dart';

class FirebasePreviewProvider extends ChangeNotifier {
  final FirebasePreviewRepository _previewRepository = FirebasePreviewRepository();

  Stream<Iterable<Message>> getMessages(String deviceToken) {
    return _previewRepository.getMessages(deviceToken);
  }
}

// class FirebaseScreensProvider extends ChangeNotifier {
//   final FirebaseScreensRepository _screensRepository = FirebaseScreensRepository();

//   bool _isEditing = false;
//   bool get isEditing => _isEditing;

//   void toggleScreensState() {
//     _isEditing = !_isEditing;
//     notifyListeners();
//   }

//   bool addScreen(ScreenPairing screenPairing) {
//     return _screensRepository.addScreen(screenPairing);
//   }

//   Stream<Iterable<ScreenPairing>> getScreens() {
//     return _screensRepository.getScreens();
//   }

//   void deleteScreen(String screenToken) {
//     return _screensRepository.deleteScreen(screenToken);
//   }
// }