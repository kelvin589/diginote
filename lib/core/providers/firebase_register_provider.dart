import 'package:diginote/core/providers/register_provider.dart';
import 'package:diginote/core/repositories/firebase_register_repository.dart';
import 'package:diginote/core/repositories/register_repository.dart';
import 'package:flutter/material.dart';

class FirebaseRegisterProvider extends ChangeNotifier implements RegisterProvider {
  final RegisterRepository _registerRepository = FirebaseRegisterRepository();

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password, String username) {
    return _registerRepository.createUserWithEmailAndPassword(email, password, username);
  }
}