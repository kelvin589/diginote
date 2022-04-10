import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

class FirebaseScreensRepository {
  final FirebaseFirestore firestoreInstance;
  final FirebaseAuth authInstance;
  String userID = "";

  FirebaseScreensRepository(
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

  Future<void> addScreen(Screen screen, void Function() onSuccess,
      Future<void> Function() onError) async {
    await firestoreInstance
        .collection('screens')
        .where('pairingCode', isEqualTo: screen.pairingCode)
        .where('paired', isEqualTo: false)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) => Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .get()
        .then(
      (value) async {
        await _updatescreen(screen, value.docs.map((e) => e.id).first);
        onSuccess();
      },
    ).catchError((_) async {
      await onError();
    });
  }

  Future<void> _updatescreen(Screen screen, String screenToken) async {
    // Update screens collection with screenToken
    await firestoreInstance
        .collection('screens')
        .doc(screenToken)
        .update({
          'paired': true,
          'userID': userID,
          'name': screen.name,
          'lastUpdated': screen.lastUpdated,
          'screenToken': screenToken,
          'pairingCode': ""
        })
        .then((value) => debugPrint("Updated paired Boolean"))
        .catchError((onError) => debugPrint("Couldn't update the paired Boolean"));
    // Update users collection screen's table with the token
    await firestoreInstance
        .collection('users')
        .doc(userID)
        .set({
          "screens": FieldValue.arrayUnion([screenToken])
        }, SetOptions(merge: true))
        .then((value) => debugPrint("Updated user's screens"))
        .catchError((onError) => debugPrint("Couldn't update the user's screens"));
    await _setDefaultScreenInfo(screenToken);
  }

  Stream<Iterable<Screen>> getScreens() {
    debugPrint("ALERT: GETTING SCREENS FOR $userID");
    return firestoreInstance
        .collection('screens')
        .where('userID', isEqualTo: userID)
        .where('paired', isEqualTo: true)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) => Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()));
  }

  Future<void> deleteScreen(String screenToken) async {
    // Delete screen from screens collection
    await firestoreInstance
        .collection('screens')
        .doc(screenToken)
        .delete()
        .then((value) => debugPrint("Deleted screen"))
        .catchError((onError) => debugPrint("Failed to delete error: $onError"));
    // Currently no method to delete all docs in a collection
    await firestoreInstance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .get()
        .then(
      (snapshots) {
        for (DocumentSnapshot snapshot in snapshots.docs) {
          snapshot.reference.delete();
        }
      },
    ).catchError((onError) async {
      debugPrint("Failed to delete error: $onError");
    });
    // Remove screen from users screens list
    await firestoreInstance
        .collection('users')
        .doc(userID)
        .set({
          "screens": FieldValue.arrayRemove([screenToken])
        }, SetOptions(merge: true))
        .then((value) => debugPrint("Deleted user's screen"))
        .catchError((onError) => debugPrint("Couldn't delete the user's screen"));
    await _setDefaultScreenInfo(screenToken);
  }

  Future<void> _setDefaultScreenInfo(String screenToken) async {
    // Set default values in screen's screenInfo
    await firestoreInstance
        .collection('screenInfo')
        .doc(screenToken)
        .set({
          "batteryPercentage": 0,
          "lowBatteryThreshold": 30,
          "lowBatteryNotificationDelay": 600,
          "batteryReportingDelay": 600,
          "screenToken": screenToken,
          "isOnline": true,
        }, SetOptions(merge: true))
        .then((value) => debugPrint("Updated screen info"))
        .catchError((onError) => debugPrint("Couldn't update screen info"));
  }
}
