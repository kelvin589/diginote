import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRegisterRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUserWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(username);
      print(userCredential.user?.email);
      print(userCredential.user?.displayName);
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }
}
