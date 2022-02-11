import 'package:diginote/core/repositories/firebase_login_repository.dart';
import 'package:diginote/ui/shared/state_enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseLoginProvider extends ChangeNotifier {
  final FirebaseLoginRepository _loginRespository = FirebaseLoginRepository();

  ApplicationLoginState _applicationLoginState =
      ApplicationLoginState.loggedOut;
  ApplicationLoginState get applicationLoginState => _applicationLoginState;

  Future<void> signInWithEmailAndPassword(String email, String password, void Function(Exception exception) onError) async {
    UserCredential? userCredential =
        await _loginRespository.signInWithEmailAndPassword(email, password, onError);
    if (userCredential != null) {
      _applicationLoginState = ApplicationLoginState.loggedIn;
    } else {
      _applicationLoginState = ApplicationLoginState.loggedOut;
    }
    notifyListeners();
  }
}
