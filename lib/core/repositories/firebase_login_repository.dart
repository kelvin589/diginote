import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password, Function(Exception) onError) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      onError(exception);
    }
  }
}
