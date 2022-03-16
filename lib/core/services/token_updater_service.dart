import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenUpdaterService {
  TokenUpdaterService(
      {required this.authInstance,
      required this.messagingInstance,
      required this.firestoreInstance});

  final FirebaseAuth authInstance;
  final FirebaseMessaging messagingInstance;
  final FirebaseFirestore firestoreInstance;

  String userID = "";

  Future<void> init() async {
    String? token = await FirebaseMessaging.instance.getToken();

    authInstance.userChanges().listen((User? user) async {
      if (user != null) {
        userID = user.uid;
        if (token != null) {
          await _updateToken(token);
        }
      }
    });

    if (token != null  && userID.isEmpty == false) {
      await _updateToken(token);
    }
    messagingInstance.onTokenRefresh.listen(_updateToken);
  }

  Future<void> _updateToken(String token) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).set(
      {
        'FCMTokens': FieldValue.arrayUnion([token]),
      },
      SetOptions(merge: true),
    );
  }
}
