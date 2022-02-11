import 'package:diginote/core/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential>? signInWithEmailAndPassword(String email, String password) {
    try {
      return _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }
}
