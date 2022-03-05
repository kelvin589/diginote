import 'package:diginote/core/repositories/firebase_login_repository.dart';
import 'package:diginote/ui/shared/state_enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseLoginProvider extends ChangeNotifier {
  final FirebaseLoginRepository _loginRespository;

  FirebaseLoginProvider({required FirebaseAuth authInstance })
    : _loginRespository = FirebaseLoginRepository(authInstance: authInstance);

  void listen(FirebaseAuth authInstance) {
    authInstance.userChanges().listen((User? user) {
      if (user == null) {
        _applicationLoginState = ApplicationLoginState.loggedOut;
        notifyListeners();
      } else {
        _applicationLoginState = ApplicationLoginState.loggedIn;
        notifyListeners();
      }
    });
  }

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

  Future<void> logout() async {
    await _loginRespository.logout();
    _applicationLoginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }
}
