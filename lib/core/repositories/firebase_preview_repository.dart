import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/messages_model.dart';

class FirebasePreviewRepository {
  Stream<Iterable<Message>> getMessages(String screenToken) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .withConverter<Message>(
          fromFirestore: (snapshot, _) {
            Map<String, dynamic> map = snapshot.data()!;
            map['id'] = snapshot.id;
            return Message.fromJson(map);
          },
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

  void updateMessageCoordinates(String screenToken, Message message) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .doc(message.id)
        .update({"x": message.x, "y": message.y})
        .then((value) => print("Updated coordinates of message."))
        .catchError((onError) =>
            print("Unable to update message coordinates. $onError"));
  }

  void deleteMessage(String screenToken, Message message) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .doc(message.id)
        .delete()
        .then((value) => print("Deleted message"))
        .catchError((onError) => print("Unable to delete message."));
  }

  void updateMessageSchedule(
      String screenToken, Message message, DateTime from, DateTime to) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .doc(message.id)
        .update({"from": from, "to": to})
        .then((value) => print("Updated message scheduling"))
        .catchError((onError) => print("Unable to update message scheduling."));
  }
}
