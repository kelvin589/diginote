import 'package:diginote/core/models/templates_model.dart';
import 'package:diginote/core/repositories/firebase_templates_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../template_matcher.dart';

void main() async {
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestoreInstance;
  late FirebaseTemplatesRepository templatesRepository;

  MockUser mockUser = MockUser(uid: "userID");

  setUp(() {
    firebaseAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    firestoreInstance = FakeFirebaseFirestore();
    templatesRepository = FirebaseTemplatesRepository(
        firestoreInstance: firestoreInstance, authInstance: firebaseAuth);
  });

  final mockTemplate = Template(
      header: "header",
      message: "message",
      id: "id",
      fontFamily: "fontFamily",
      fontSize: 12,
      backgrondColour: Colors.black.value,
      foregroundColour: Colors.black.value,
      width: 100,
      height: 100,
      textAlignment: "textAlignment");

  final mockTemplate2 = Template(
      header: "header2",
      message: "message2",
      id: "id2",
      fontFamily: "fontFamily2",
      fontSize: 15,
      backgrondColour: Colors.red.value,
      foregroundColour: Colors.red.value,
      width: 200,
      height: 200,
      textAlignment: "textAlignment2");

  Future<Template?> getTemplate(String userID, String templateID) async {
    final snapshot = await firestoreInstance
        .collection('templates')
        .doc(userID)
        .collection('template')
        .where('id', isEqualTo: templateID)
        .withConverter<Template>(
          fromFirestore: (snapshot, _) => Template.fromJson(snapshot.data()!),
          toFirestore: (template, _) => template.toJson(),
        )
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  test('A new template can be added', () async {
    await templatesRepository.addTemplate(mockTemplate);

    final retrievedTemplate = await getTemplate(mockUser.uid, mockTemplate.id);
    expect(retrievedTemplate, isNotNull);
    expect(retrievedTemplate, TemplateMatcher(mockTemplate.toJson()));
  });

  test('A template can be removed', () async {
    await templatesRepository.addTemplate(mockTemplate);
    await templatesRepository.deleteTemplate(mockTemplate.id);

    final retrievedTemplate = await getTemplate(mockUser.uid, mockTemplate.id);
    expect(retrievedTemplate, isNull);
  });

  test('A stream of templates can be read', () async {
    expect(
      templatesRepository.readTemplates(),
      emitsInOrder([
        [],
        [TemplateMatcher(mockTemplate.toJson())],
        [
          TemplateMatcher(mockTemplate.toJson()),
          TemplateMatcher(mockTemplate2.toJson())
        ],
      ]),
    );

    await Future.delayed(Duration.zero);
    await templatesRepository.addTemplate(mockTemplate);

    await Future.delayed(Duration.zero);
    await templatesRepository.addTemplate(mockTemplate2);
  });

  test('All templates can be deleted', () async {
    await templatesRepository.addTemplate(mockTemplate);
    await templatesRepository.addTemplate(mockTemplate2);

    await templatesRepository.deleteAll();
    final retrievedTemplate = await getTemplate(mockUser.uid, mockTemplate.id);
    final retrievedTemplate2 = await getTemplate(mockUser.uid, mockTemplate2.id);

    expect(retrievedTemplate, isNull);
    expect(retrievedTemplate2, isNull);
  });
}
