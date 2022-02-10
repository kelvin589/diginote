import 'package:diginote/core/repositories/firebase_login_repository.dart';
import 'package:diginote/core/repositories/login_repository.dart';
import 'package:flutter/material.dart';

import 'login_provider.dart';

class FirebaseLoginProvider extends ChangeNotifier implements LoginProvider {
  final LoginRespository _loginRespository = FirebaseLoginRepository();

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _loginRespository.signInWithEmailAndPassword(email, password);
  } 
}