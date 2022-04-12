import 'package:firebase_auth/firebase_auth.dart';

/// The repository to deal with user registration.
class FirebaseRegisterRepository {
  /// The [FirebaseAuth] instance.
  final FirebaseAuth authInstance;

  /// Creates a [FirebaseRegisterRepository] using a [FirebaseAuth] instance.
  FirebaseRegisterRepository({required this.authInstance});

  /// Creates a username with email and password.
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password, String username, Function(Exception) onError) async {
    try {
      UserCredential userCredential = await authInstance.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(username);
      return userCredential;
    } on FirebaseAuthException catch (exception) {
      onError(exception);
      return null;
    }
  }
}
