import 'package:flutter/material.dart';

abstract class RegisterProvider extends ChangeNotifier {
  Future<void> createUserWithEmailAndPassword(String email, String password, String username);
}