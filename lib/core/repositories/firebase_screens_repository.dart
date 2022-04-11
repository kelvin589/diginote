import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

/// The repository to deal with retrieving [Screen] information.
class FirebaseScreensRepository {
  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore firestoreInstance;

  /// The [FirebaseAuth] instance.
  final FirebaseAuth authInstance;

  /// The currently logged in user's ID.
  String userID = "";

  /// Creates a [FirebaseScreensRepository] using a [FirebaseFirestore] and
  /// [FirebaseAuth] instance.
  ///
  /// Listens to [FirebaseAuth] user changes to update the [userID].
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

  /// The starting function to pair a new screen for [userID]. This function
  /// finds the screen which should be paired.
  /// 
  /// Calls on [_updateScreen] to insert additional pairing information.
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
        await _updateScreen(screen, value.docs.map((e) => e.id).first);
        onSuccess();
      },
    ).catchError((_) async {
      await onError();
    });
  }

  /// The rest of the pairing function from [addScreen].
  /// 
  /// Updates 'screens', 'users' and 'screenInfo'.
  Future<void> _updateScreen(Screen screen, String screenToken) async {
    // Update screens collection with screenToken.
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
    
    // Update users collection screen's table with the token.
    await firestoreInstance
        .collection('users')
        .doc(userID)
        .set({
          "screens": FieldValue.arrayUnion([screenToken])
        }, SetOptions(merge: true))
        .then((value) => debugPrint("Updated user's screens"))
        .catchError((onError) => debugPrint("Couldn't update the user's screens"));
    
    // Initialises screen info for this screen so it's not empty.
    await _setDefaultScreenInfo(screenToken);
  }

  /// Retreives a stream of paired [Screen] associated with [userID].
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

  /// Deletes all information related to this screen with [screenToken].
  /// 
  /// Note: That includes removing all messages associated with this screen.
  Future<void> deleteScreen(String screenToken) async {
    // Deletes the screen from the screens collection.
    await firestoreInstance
        .collection('screens')
        .doc(screenToken)
        .delete()
        .then((value) => debugPrint("Deleted screen"))
        .catchError((onError) => debugPrint("Failed to delete error: $onError"));
    
    // Currently no method to delete all docs in a collection. 
    // Must iterate through the messages and delete them.
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
    
    // Remove screen from users screens list.
    await firestoreInstance
        .collection('users')
        .doc(userID)
        .set({
          "screens": FieldValue.arrayRemove([screenToken])
        }, SetOptions(merge: true))
        .then((value) => debugPrint("Deleted user's screen"))
        .catchError((onError) => debugPrint("Couldn't delete the user's screen"));
    
    // Initialises screen info for this screen so it's not empty.
    await _setDefaultScreenInfo(screenToken);
  }

  /// Sets the default ScreenInfo for the [screenToken].
  Future<void> _setDefaultScreenInfo(String screenToken) async {
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
