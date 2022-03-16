import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_info_model.dart';
import 'package:diginote/core/repositories/firebase_screen_info_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseScreenInfoProvider extends ChangeNotifier {
  final FirebaseScreenInfoRepository _screenInfoRepository;

  FirebaseScreenInfoProvider(
      {required FirebaseFirestore firestoreInstance,
      required FirebaseAuth authInstance})
      : _screenInfoRepository = FirebaseScreenInfoRepository(
            firestoreInstance: firestoreInstance, authInstance: authInstance);

  Stream<Iterable<ScreenInfo>> getScreenInfo(String screenToken) {
    return _screenInfoRepository.getScreenInfo(screenToken);
  }

  Future<void> setScreenInfo(String screenToken, ScreenInfo newScreenInfo) async {
    await _screenInfoRepository.setScreenInfo(screenToken, newScreenInfo);
  }
}
