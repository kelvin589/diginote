import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/templates_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// The repository to deal with adding, deleting and retrieving [Template]s
/// associated with [userID].
class FirebaseTemplatesRepository {
  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore firestoreInstance;

  /// The [FirebaseAuth] instance.
  final FirebaseAuth authInstance;

  /// The currently logged in user's ID.
  String userID = "";

  /// Creates a [FirebaseTemplatesRepository] using a [FirebaseFirestore] and
  /// [FirebaseAuth] instance.
  ///
  /// Listens to [FirebaseAuth] user changes to update the [userID].
  FirebaseTemplatesRepository(
      {required this.firestoreInstance, required this.authInstance}) {
    authInstance.userChanges().listen((User? user) {
      if (user != null) {
        userID = user.uid;
      }
    });
  }

  /// Adds a new template or updates an existing template for [userID].
  Future<void> setTemplate(Template template) async {
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

  /// Deletes a [userID]'s template with [id].
  Future<void> deleteTemplate(String id) async {
    await firestoreInstance
        .collection('templates')
        .doc(userID)
        .collection('template')
        .doc(id)
        .delete();
  }

  /// Retreive a stream of [Template] for this [userID],
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

  /// Delete all templates associated with this [userID].
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
