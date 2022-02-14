import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  bool addScreen(String pairingCode) {
    FirebaseFirestore.instance
        .collection('pairingCodes')
        .where('pairingCode', isEqualTo: pairingCode)
        .where('paired', isEqualTo: false)
        .withConverter<ScreenPairing>(
          fromFirestore: (snapshot, _) =>
              ScreenPairing.fromJson(snapshot.data()!),
          toFirestore: (screenPairing, _) => screenPairing.toJson(),
        )
        .get()
        .then((value) => _linkScreen(value.docs.map((e) => e.id).first))
        .catchError((onError) => print("Already paired or code wrong."));

    return false;
  }

  void _linkScreen(String screenToken) {
    var toAdd = [screenToken];
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .set({"screens": FieldValue.arrayUnion(toAdd)}, SetOptions(merge: true))
        .then((value) => _updateScreenPaired(screenToken))
        .catchError((onError) => print("Couldn't link the screen"));
  }

  void _updateScreenPaired(String screenToken) {
    FirebaseFirestore.instance
      .collection('pairingCodes')
      .doc(screenToken)
      .update({'paired': true})
      .then((value) => print("Updated paired Boolean"))
      .catchError((onError) => print("Couldn't update the paired Boolean"));
  }
}
