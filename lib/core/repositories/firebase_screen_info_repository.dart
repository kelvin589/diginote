import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_info_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// The repository to deal with retrieving [ScreenInfo].
class FirebaseScreenInfoRepository {
  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore firestoreInstance;

  /// The [FirebaseAuth] instance.
  final FirebaseAuth authInstance;

  /// The currently logged in user's ID.
  String userID = "";

  /// Creates a [FirebaseScreenInfoRepository] using a [FirebaseFirestore] and
  /// [FirebaseAuth] instance.
  ///
  /// Listens to [FirebaseAuth] user changes to update the [userID].
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

  /// Retreives a stream of [ScreenInfo] for this [screenToken].
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

  /// Sets the [ScreenInfo] for the [screenToken].
  /// 
  /// Optionally, a [screenName] may be set.
  Future<void> setScreenInfo(String screenToken, ScreenInfo newScreenInfo,
      {String? screenName}) async {
    await firestoreInstance
        .collection('screenInfo')
        .doc(screenToken)
        .withConverter<ScreenInfo>(
          fromFirestore: (snapshot, _) => ScreenInfo.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .set(newScreenInfo);

    // If screenName is not null, we should update it.
    if (screenName != null) {
      await firestoreInstance
          .collection('screens')
          .doc(screenToken)
          .set({"name": screenName}, SetOptions(merge: true));
    }
  }
}
