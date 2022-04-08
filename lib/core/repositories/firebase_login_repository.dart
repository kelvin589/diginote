import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLoginRepository {
  final FirebaseAuth authInstance;

  FirebaseLoginRepository({required this.authInstance});

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password, Function(Exception) onError) async {
    try {
      return await authInstance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      onError(exception);
      return null;
    }
  }

  Future<void> logout() async {
    await authInstance.signOut();
  }
}
