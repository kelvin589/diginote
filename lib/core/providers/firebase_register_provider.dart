import 'package:diginote/core/repositories/firebase_register_repository.dart';
import 'package:flutter/material.dart';

class FirebaseRegisterProvider extends ChangeNotifier {
  final FirebaseRegisterRepository _registerRepository = FirebaseRegisterRepository();

  Future<void> createUserWithEmailAndPassword(String email, String password, String username) {
    return _registerRepository.createUserWithEmailAndPassword(email, password, username);
  }
}