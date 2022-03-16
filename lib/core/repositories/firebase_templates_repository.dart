import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/templates_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTemplatesRepository {
  final FirebaseFirestore firestoreInstance;
  final FirebaseAuth authInstance;
  String userID = "";

  FirebaseTemplatesRepository(
      {required this.firestoreInstance, required this.authInstance}) {
    authInstance.userChanges().listen((User? user) {
      if (user != null) {
        userID = user.uid;
      }
    });
  }

  Future<void> addTemplate(Template template) async {
    await firestoreInstance
        .collection('templates')
        .doc(userID)
        .collection('template')
        .doc(template.id)
        .withConverter<Template>(
          fromFirestore: (snapshot, _) => Template.fromJson(snapshot.data()!),
          toFirestore: (template, _) => template.toJson(),
        )
        .set(template, SetOptions(merge: true));
  }

  Future<void> deleteTemplate(String id) async {
    await firestoreInstance
        .collection('templates')
        .doc(userID)
        .collection('template')
        .doc(id)
        .delete();
  }

  Stream<Iterable<Template>> readTemplates() {
    return firestoreInstance
        .collection('templates')
        .doc(userID)
        .collection('template')
        .withConverter<Template>(
          fromFirestore: (snapshot, _) => Template.fromJson(snapshot.data()!),
          toFirestore: (template, _) => template.toJson(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()));
  }

  Future<void> deleteAll() async {
    await firestoreInstance
        .collection('templates')
        .doc(userID)
        .collection('template')
        .get()
        .then(
      (snapshots) {
        for (DocumentSnapshot snapshot in snapshots.docs) {
          snapshot.reference.delete();
        }
      },
    );
  }
}
