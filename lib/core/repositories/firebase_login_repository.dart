import 'package:firebase_auth/firebase_auth.dart';

/// The repository to deal with user login.
class FirebaseLoginRepository {
  /// The [FirebaseAuth] instance.
  final FirebaseAuth authInstance;

  /// Creates a [FirebaseLoginRepository] using a [FirebaseAuth] instance.
  FirebaseLoginRepository({required this.authInstance});

  /// Signs in a user using their email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password, Function(Exception) onError) async {
    try {
      return await authInstance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      onError(exception);
      return null;
    }
  }

  /// Logs out the user if one is logged in.
  Future<void> logout() async {
    await authInstance.signOut();
  }
}
