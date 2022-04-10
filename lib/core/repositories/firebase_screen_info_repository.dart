import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_info_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseScreenInfoRepository {
  final FirebaseFirestore firestoreInstance;
  final FirebaseAuth authInstance;
  String userID = "";

  FirebaseScreenInfoRepository(
      {required this.firestoreInstance, required this.authInstance}) {
    debugPrint("ALERT: INITIALISED THE REPOSITORY");
    authInstance.userChanges().listen((User? user) {
      if (user == null) {
        debugPrint("ALERT: USER LOGGED OUT $user");
      } else {
        userID = user.uid;
        debugPrint("ALERT: USER LOGGED IN $userID");
      }
    });
  }

  Stream<Iterable<ScreenInfo>> getScreenInfo(String screenToken) {
    debugPrint("ALERT: GETTING SCREEN INFO FOR $userID");
    return firestoreInstance
        .collection('screenInfo')
        .where('screenToken', isEqualTo: screenToken)
        .withConverter<ScreenInfo>(
          fromFirestore: (snapshot, _) => ScreenInfo.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()));
  }

  Future<void> setScreenInfo(String screenToken, ScreenInfo newScreenInfo, {String? screenName}) async {
    await firestoreInstance
        .collection('screenInfo')
        .doc(screenToken)
        .withConverter<ScreenInfo>(
          fromFirestore: (snapshot, _) => ScreenInfo.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .set(newScreenInfo);
    if (screenName != null) {
    await firestoreInstance
        .collection('screens')
        .doc(screenToken)
        .set({"name" : screenName}, SetOptions(merge: true));
    }
  }
}
