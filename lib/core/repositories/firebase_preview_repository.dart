import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/messages_model.dart';

class FirebasePreviewRepository {
  final FirebaseFirestore firestoreInstance;

  FirebasePreviewRepository({required this.firestoreInstance});

  Stream<Iterable<Message>> getMessages(String screenToken) {
    return firestoreInstance
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

  Future<void> addMessage(String screenToken, Message message) async {
    await firestoreInstance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .withConverter<Message>(
          fromFirestore: (snapshot, _) {
            Map<String, dynamic> map = snapshot.data()!;
            map['id'] = snapshot.id;
            return Message.fromJson(map);
          },
          toFirestore: (screen, _) => screen.toJson(),
        )
        .add(message)
        .then((value) => print("Added a new message."))
        .catchError((onError) => print("Unable to add message."));
    await updateLastUpdatedToNow(screenToken);
  }

  Future<void> updateMessageCoordinates(
      String screenToken, Message message) async {
    await firestoreInstance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .doc(message.id)
        .update({"x": message.x, "y": message.y})
        .then((value) => print("Updated coordinates of message."))
        .catchError((onError) =>
            print("Unable to update message coordinates. $onError"));
    await updateLastUpdatedToNow(screenToken);
  }

  Future<void> deleteMessage(String screenToken, Message message) async {
    await firestoreInstance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .doc(message.id)
        .delete()
        .then((value) => print("Deleted message"))
        .catchError((onError) => print("Unable to delete message."));
    await updateLastUpdatedToNow(screenToken);
  }

  Future<void> updateMessageSchedule(String screenToken, Message message,
      DateTime from, DateTime to, bool scheduled) async {
    await firestoreInstance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .doc(message.id)
        .update({"from": from, "to": to, "scheduled": scheduled})
        .then((value) => print("Updated message scheduling"))
        .catchError((onError) => print("Unable to update message scheduling."));
    await updateLastUpdatedToNow(screenToken);
  }

  Future<void> updateLastUpdatedToNow(String screenToken) async {
    await firestoreInstance
        .collection('screens')
        .doc(screenToken)
        .update({
          'lastUpdated': clock.now(),
        })
        .then((value) => print("Updated last updated"))
        .catchError((onError) => print("Couldn't update last updated"));
  }
}
