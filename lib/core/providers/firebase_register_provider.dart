import 'package:diginote/core/repositories/firebase_register_repository.dart';
import 'package:diginote/ui/shared/state_enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseRegisterProvider extends ChangeNotifier {
  final FirebaseRegisterRepository _registerRepository = FirebaseRegisterRepository();

  ApplicationRegisterState _applicationRegisterState = ApplicationRegisterState.registering;
  ApplicationRegisterState get applicationRegisterState => _applicationRegisterState;

  Future<void> createUserWithEmailAndPassword(String email, String password, String username, void Function(Exception exception) onError) async {
    UserCredential? userCredential =
        await _registerRepository.createUserWithEmailAndPassword(email, password, username, onError);
    if (userCredential != null) {
      _applicationRegisterState = ApplicationRegisterState.registered;
    } else {
      _applicationRegisterState = ApplicationRegisterState.registering;
    }
    notifyListeners();
  }
}