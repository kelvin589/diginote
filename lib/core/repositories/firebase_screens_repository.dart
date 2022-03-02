import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class FirebaseScreensRepository {
  final FirebaseFirestore firestoreInstance;
  final FirebaseAuth authInstance;
  String userID = "";
  
  FirebaseScreensRepository({required this.firestoreInstance, required this.authInstance}) {
    print("ALERT: INITIALISED THE REPOSITORY");
    authInstance.userChanges().listen((User? user) {
      if (user == null) {
        print("ALERT: USER LOGGED OUT ${user}");
      } else {
        userID = user.uid;
        print("ALERT: USER LOGGED IN $userID");
      }
    });
  }

  bool addScreen(ScreenPairing screenPairing) {
    firestoreInstance
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
    firestoreInstance
        .collection('users')
        .doc(userID)
        .set({"screens": FieldValue.arrayUnion(toAdd)}, SetOptions(merge: true))
        .then((value) => _updateScreenPaired(screenPairing, screenToken))
        .catchError((onError) => print("Couldn't link the screen"));
  }

  void _updateScreenPaired(ScreenPairing screenPairing, String screenToken) {
    firestoreInstance
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
    print("ALERT: GETTING SCREENS FOR $userID");
    return firestoreInstance
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
    var toRemove = [screenToken];
    firestoreInstance
        .collection('pairingCodes')
        .doc(screenToken)
        .delete()
        .then((value) => print("Deleted screen"))
        .catchError((onError) => print("Failed to delete error: $onError"));
    firestoreInstance
        .collection('users')
        .doc(userID)
        .update({"screens": FieldValue.arrayRemove(toRemove)})
        .then((value) => print("Deleted screen"))
        .catchError((onError) => print("Failed to delete error: $onError"));
  }
}
