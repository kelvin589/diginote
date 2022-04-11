import 'package:diginote/core/repositories/firebase_register_repository.dart';
import 'package:diginote/ui/shared/state_enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A provider using the [FirebaseRegisterRepository].
/// 
/// Manages the register view for account creation.
class FirebaseRegisterProvider extends ChangeNotifier {
  /// The [FirebaseRegisterRepository] instance.
  final FirebaseRegisterRepository _registerRepository;

  /// Initialises the [FirebaseRegisterRepository].
  FirebaseRegisterProvider({required FirebaseAuth authInstance})
      : _registerRepository =
            FirebaseRegisterRepository(authInstance: authInstance);

  /// The current [ApplicationRegisterState] of the application.
  ApplicationRegisterState _applicationRegisterState = ApplicationRegisterState.registering;

  /// Returns the current [_applicationRegisterState].
  ApplicationRegisterState get applicationRegisterState => _applicationRegisterState;

  /// Creates a username with email and password.
  ///
  /// Updates [_applicationRegisterState] to [ApplicationRegisterState.registered] if the
  /// user successfully registers, otherwise [ApplicationRegisterState.registering].
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email,
      String password,
      String username,
      void Function(Exception exception) onError) async {
    UserCredential? userCredential = await _registerRepository
        .createUserWithEmailAndPassword(email, password, username, onError);

    // The userCredential is null if registration was unsuccessful.
    if (userCredential != null) {
      _applicationRegisterState = ApplicationRegisterState.registered;
    } else {
      _applicationRegisterState = ApplicationRegisterState.registering;
    }
    notifyListeners();

    return userCredential;
  }

  /// Resets the state as the user has not registered.
  void resetState() {
    _applicationRegisterState = ApplicationRegisterState.registering;
  }
}
