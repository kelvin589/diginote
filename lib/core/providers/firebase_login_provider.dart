import 'package:diginote/core/repositories/firebase_login_repository.dart';
import 'package:diginote/ui/shared/state_enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A provider using the [FirebaseLoginRepository].
/// 
/// Listens to [FirebaseAuth] user changes to determine [_applicationLoginState].
/// The [init] method must be called to initialise [FirebaseLoginProvider].
class FirebaseLoginProvider extends ChangeNotifier {
  /// The [FirebaseAuth] instance.
  final FirebaseAuth authInstance;

  /// The [FirebaseLoginRepository] instance.
  final FirebaseLoginRepository _loginRespository;

  /// Initialises the [FirebaseLoginRepository].
  FirebaseLoginProvider({required this.authInstance})
    : _loginRespository = FirebaseLoginRepository(authInstance: authInstance);

  /// Listens to [FirebaseAuth] user changes to determine [_applicationLoginState].
  void init() {
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

  /// The current [ApplicationLoginState] of the application.
  ApplicationLoginState _applicationLoginState = ApplicationLoginState.loggedOut;

  /// Returns the current [_applicationLoginState].
  ApplicationLoginState get applicationLoginState => _applicationLoginState;

  /// Signs in a user using their email and password
  /// 
  /// Updates [_applicationLoginState] to [ApplicationLoginState.loggedIn] if the
  /// user successfully logs in, otherwise [ApplicationLoginState.loggedOut].
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

  /// Logs out the user if one is logged in.
  Future<void> logout() async {
    await _loginRespository.logout();
    _applicationLoginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }
}
