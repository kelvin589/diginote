import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_model.dart';
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

  Future<void> addScreen(Screen screen) async {
    await _screensRepository.addScreen(screen);
  }

  Stream<Iterable<Screen>> getScreens() {
    return _screensRepository.getScreens();
  }

  Future<void> deleteScreen(String screenToken) async {
    await _screensRepository.deleteScreen(screenToken);
  }
}
