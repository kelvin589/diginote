import 'package:flutter/material.dart';

abstract class LoginProvider extends ChangeNotifier {
  Future<void> signInWithEmailAndPassword(String email, String password);
}