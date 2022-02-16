import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/messages_model.dart';

class FirebasePreviewRepository {
  void addMessage(String deviceToken) {}

  Stream<Iterable<Message>> getMessages(String deviceToken) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(deviceToken)
        .collection('message')
        .withConverter<Message>(
          fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
          toFirestore: (message, _) => message.toJson(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()));
  }
}
