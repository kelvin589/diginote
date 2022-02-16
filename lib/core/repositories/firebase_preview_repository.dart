import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/messages_model.dart';

class FirebasePreviewRepository {
  Stream<Iterable<Message>> getMessages(String screenToken) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .withConverter<Message>(
          fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
          toFirestore: (message, _) => message.toJson(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()));
  }

  void addMessage(String screenToken, Message message) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .withConverter<Message>(
          fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
          toFirestore: (screenPairing, _) => screenPairing.toJson(),
        )
        .add(message)
        .then((value) => print("Added a new message."))
        .catchError((onError) => print("Unable to add message."));
  }
}
