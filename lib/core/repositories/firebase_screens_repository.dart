import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_model.dart';
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

  Future<void> addScreen(Screen screen) async {
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
            (value) => _updatescreen(screen, value.docs.map((e) => e.id).first))
        .catchError((onError) => print("Already paired or code wrong."));
  }

  Future<void> _updatescreen(Screen screen, String screenToken) async {
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
        .then((value) => print("Updated paired Boolean"))
        .catchError((onError) => print("Couldn't update the paired Boolean"));
  }

  Stream<Iterable<Screen>> getScreens() {
    print("ALERT: GETTING SCREENS FOR $userID");
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
    await firestoreInstance
        .collection('screens')
        .doc(screenToken)
        .delete()
        .then((value) => print("Deleted screen"))
        .catchError((onError) => print("Failed to delete error: $onError"));
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
    ).catchError((onError) => print("Failed to delete error: $onError"));
  }
}
