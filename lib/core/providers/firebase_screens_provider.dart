import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/repositories/firebase_screens_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A provider using the [FirebaseScreensRepository].
/// 
/// Manages the addition, retrieval and removal of [Screen]s.
class FirebaseScreensProvider extends ChangeNotifier {
  /// The [FirebaseScreensRepository] instance.
  final FirebaseScreensRepository _screensRepository;

  /// Initialises the [FirebaseScreensRepository].
  FirebaseScreensProvider(
      {required FirebaseFirestore firestoreInstance,
      required FirebaseAuth authInstance})
      : _screensRepository = FirebaseScreensRepository(
            firestoreInstance: firestoreInstance, authInstance: authInstance);

  /// Pairs a new [screen] for the currently logged in user of [FirebaseAuth].
  /// 
  /// [onSuccess] is called after successfully pairing the new screen.
  /// [onError] is called if it was not possible to pair the screen.
  Future<void> addScreen({required Screen screen, required void Function() onSuccess, required Future<void> Function() onError}) async {
    await _screensRepository.addScreen(screen, onSuccess, onError);
  }

  /// Retreives a stream of paired [Screen] for the currently logged in user of [FirebaseAuth].
  Stream<Iterable<Screen>> getScreens() {
    return _screensRepository.getScreens();
  }

  /// Deletes all information related to this screen with [screenToken].
  Future<void> deleteScreen(String screenToken) async {
    await _screensRepository.deleteScreen(screenToken);
  }
}
