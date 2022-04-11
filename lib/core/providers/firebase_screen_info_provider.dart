import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_info_model.dart';
import 'package:diginote/core/repositories/firebase_screen_info_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A provider using the [FirebaseScreenInfoRepository].
/// 
///  Retrieves and updates a screen's [ScreenInfo].
class FirebaseScreenInfoProvider extends ChangeNotifier {
  /// The [FirebaseScreenInfoRepository] instance.
  final FirebaseScreenInfoRepository _screenInfoRepository;

  /// Initialises the [FirebaseScreenInfoRepository].
  FirebaseScreenInfoProvider(
      {required FirebaseFirestore firestoreInstance,
      required FirebaseAuth authInstance})
      : _screenInfoRepository = FirebaseScreenInfoRepository(
            firestoreInstance: firestoreInstance, authInstance: authInstance);

  /// Retreives a stream of [ScreenInfo] for this [screenToken].
  Stream<Iterable<ScreenInfo>> getScreenInfo(String screenToken) {
    return _screenInfoRepository.getScreenInfo(screenToken);
  }

  /// Sets the [ScreenInfo] for the [screenToken].
  ///
  /// Optionally, a [screenName] may be set.
  Future<void> setScreenInfo(String screenToken, ScreenInfo newScreenInfo,
      {String? screenName}) async {
    await _screenInfoRepository.setScreenInfo(screenToken, newScreenInfo,
        screenName: screenName);
  }
}
