import 'package:diginote/core/repositories/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRegisterRepository implements RegisterRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user?.email);
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }
}
