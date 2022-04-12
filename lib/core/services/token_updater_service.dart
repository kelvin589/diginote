import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// A service which listens to user changes in [FirebaseAuth] to update
/// the user's list of FCMTokens.
/// 
/// These tokens could be used, for example, to message every device linked to
/// this user. 
/// The [init] method must be called to initialise [TokenUpdaterService].
class TokenUpdaterService {
  TokenUpdaterService({
    required this.authInstance,
    required this.messagingInstance,
    required this.firestoreInstance,
  });

  /// The [FirebaseAuth] instance.
  final FirebaseAuth authInstance;

  /// The [FirebaseMessaging] instance.
  final FirebaseMessaging messagingInstance;

  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore firestoreInstance;

  /// The currently logged in user's ID.
  String userID = "";

  /// Initialises [TokenUpdaterService] by listening to user changes in [FirebaseAuth]
  /// so that the user's list of FCM tokens can be updated in Firestore.
  Future<void> init() async {
    String? token = await FirebaseMessaging.instance.getToken();

    // Listen to changes and update the token list.
    authInstance.userChanges().listen((User? user) async {
      if (user != null) {
        userID = user.uid;
        if (token != null) {
          await _updateToken(token);
        }
      }
    });

    if (token != null) {
      await _updateToken(token);
    }

    // Also update the token when the token refreshes.
    messagingInstance.onTokenRefresh.listen(_updateToken);
  }

  /// Updates the [userID]'s list of FCM tokens as a union of the existing tokens
  /// with [token].
  Future<void> _updateToken(String token) async {
    if (userID.isEmpty) return;

    await FirebaseFirestore.instance.collection('users').doc(userID).set(
      {
        'FCMTokens': FieldValue.arrayUnion([token]),
      },
      SetOptions(merge: true),
    );
  }
}
