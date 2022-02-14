import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class FirebaseScreensRepository {
  String? userID;
  FirebaseScreensRepository() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        print("logged out");
      } else {
        userID = user.uid;
      }
    });
  }

  bool addScreen(ScreenPairing screenPairing) {
    FirebaseFirestore.instance
        .collection('pairingCodes')
        .where('pairingCode', isEqualTo: screenPairing.pairingCode)
        .where('paired', isEqualTo: false)
        .withConverter<ScreenPairing>(
          fromFirestore: (snapshot, _) =>
              ScreenPairing.fromJson(snapshot.data()!),
          toFirestore: (screenPairing, _) => screenPairing.toJson(),
        )
        .get()
        .then((value) =>
            _linkScreen(screenPairing, value.docs.map((e) => e.id).first))
        .catchError((onError) => print("Already paired or code wrong."));

    return false;
  }

  void _linkScreen(ScreenPairing screenPairing, String screenToken) {
    var toAdd = [screenToken];
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .set({"screens": FieldValue.arrayUnion(toAdd)}, SetOptions(merge: true))
        .then((value) => _updateScreenPaired(screenPairing, screenToken))
        .catchError((onError) => print("Couldn't link the screen"));
  }

  void _updateScreenPaired(ScreenPairing screenPairing, String screenToken) {
    FirebaseFirestore.instance
        .collection('pairingCodes')
        .doc(screenToken)
        .update({
          'paired': true,
          'userID': userID,
          'name': screenPairing.name,
          'lastUpdated': screenPairing.lastUpdated,
          'screenToken': screenToken
        })
        .then((value) => print("Updated paired Boolean"))
        .catchError((onError) => print("Couldn't update the paired Boolean"));
  }

  Stream<Iterable<ScreenPairing>> getScreens() {
    return FirebaseFirestore.instance
        .collection('pairingCodes')
        .where('userID', isEqualTo: userID)
        .where('paired', isEqualTo: true)
        .withConverter<ScreenPairing>(
          fromFirestore: (snapshot, _) =>
              ScreenPairing.fromJson(snapshot.data()!),
          toFirestore: (screenPairing, _) => screenPairing.toJson(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()));
  }

  void deleteScreen(String screenToken) {
    FirebaseFirestore.instance
        .collection('pairingCodes')
        .doc(screenToken)
        .delete()
        .then((value) => print("Deleted screen"))
        .catchError((onError) => print("Failed to delete error: $onError"));
  }
}
