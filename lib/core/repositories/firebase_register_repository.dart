import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRegisterRepository {
  final FirebaseAuth authInstance;

  FirebaseRegisterRepository({required this.authInstance});

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
