import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:diginote/core/repositories/firebase_screens_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseScreensProvider extends ChangeNotifier {
  final FirebaseScreensRepository _screensRepository;

  FirebaseScreensProvider(
      {required FirebaseFirestore firestoreInstance,
      required FirebaseAuth authInstance})
      : _screensRepository = FirebaseScreensRepository(
            firestoreInstance: firestoreInstance, authInstance: authInstance);

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleScreensState() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  Future<void> addScreen(ScreenPairing screenPairing) {
    return _screensRepository.addScreen(screenPairing);
  }

  Stream<Iterable<ScreenPairing>> getScreens() {
    return _screensRepository.getScreens();
  }

  Future<void> deleteScreen(String screenToken) async {
    await _screensRepository.deleteScreen(screenToken);
  }
}
