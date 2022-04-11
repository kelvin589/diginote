import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/templates_model.dart';
import 'package:diginote/core/repositories/firebase_templates_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseTemplatesProvider extends ChangeNotifier {
  final FirebaseTemplatesRepository _templatesRepository;

  FirebaseTemplatesProvider(
      {required FirebaseFirestore firestoreInstance,
      required FirebaseAuth authInstance})
      : _templatesRepository = FirebaseTemplatesRepository(
            firestoreInstance: firestoreInstance, authInstance: authInstance);

  Future<void> setTemplate(Template template) async {
    await _templatesRepository.setTemplate(template);
  }

  Future<void> deleteTemplate(String id) async {
    await _templatesRepository.deleteTemplate(id);
  }

  Stream<Iterable<Template>> readTemplates() {
    return _templatesRepository.readTemplates();
  }

  Future<void> deleteAll() async {
    await _templatesRepository.deleteAll();
  }
}
