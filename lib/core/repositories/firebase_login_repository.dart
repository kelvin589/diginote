import 'package:diginote/core/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLoginRepository implements LoginRespository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(userCredential.user?.email);
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }
}
