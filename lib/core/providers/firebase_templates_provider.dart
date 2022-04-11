import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/templates_model.dart';
import 'package:diginote/core/repositories/firebase_templates_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A provider using the [FirebaseTemplatesRepository].
/// 
/// Manages the display, addition, deletetion and edition of templates.
class FirebaseTemplatesProvider extends ChangeNotifier {
  /// The [FirebaseTemplatesRepository] instance.
  final FirebaseTemplatesRepository _templatesRepository;

  /// Initialises the [FirebaseTemplatesRepository].
  FirebaseTemplatesProvider(
      {required FirebaseFirestore firestoreInstance,
      required FirebaseAuth authInstance})
      : _templatesRepository = FirebaseTemplatesRepository(
            firestoreInstance: firestoreInstance, authInstance: authInstance);

  /// Adds a new template or updates an existing template 
  /// for the currently logged in user of [FirebaseAuth].
  Future<void> setTemplate(Template template) async {
    await _templatesRepository.setTemplate(template);
  }

  /// Deletes a template with [id] for the currently logged in user of [FirebaseAuth].
  Future<void> deleteTemplate(String id) async {
    await _templatesRepository.deleteTemplate(id);
  }

  /// Retreive a stream of [Template] for the currently logged in user of [FirebaseAuth].
  Stream<Iterable<Template>> readTemplates() {
    return _templatesRepository.readTemplates();
  }

  /// Delete all templates for the currently logged in user of [FirebaseAuth].
  Future<void> deleteAll() async {
    await _templatesRepository.deleteAll();
  }
}
