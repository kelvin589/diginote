import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter/material.dart';

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
        .then((value) => debugPrint("Added a new message."))
        .catchError((onError) => debugPrint("Unable to add message."));
    await updateLastUpdatedToNow(screenToken);
  }

    Future<void> updateMessage(String screenToken, Message message) async {
    await firestoreInstance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .doc(message.id)
        .withConverter<Message>(
          fromFirestore: (snapshot, _) {
            Map<String, dynamic> map = snapshot.data()!;
            map['id'] = snapshot.id;
            return Message.fromJson(map);
          },
          toFirestore: (screen, _) => screen.toJson(),
        )
        .set(message, SetOptions(merge: true))
        .then((value) => debugPrint("Updated the new message."))
        .catchError((onError) => debugPrint("Unable to update the message."));
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
        .then((value) => debugPrint("Updated coordinates of message."))
        .catchError((onError) =>
            debugPrint("Unable to update message coordinates. $onError"));
    await updateLastUpdatedToNow(screenToken);
  }

  Future<void> deleteMessage(String screenToken, Message message) async {
    await firestoreInstance
        .collection('messages')
        .doc(screenToken)
        .collection('message')
        .doc(message.id)
        .delete()
        .then((value) => debugPrint("Deleted message"))
        .catchError((onError) => debugPrint("Unable to delete message."));
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
        .then((value) => debugPrint("Updated message scheduling"))
        .catchError((onError) => debugPrint("Unable to update message scheduling."));
    await updateLastUpdatedToNow(screenToken);
  }

  Future<void> updateLastUpdatedToNow(String screenToken) async {
    await firestoreInstance
        .collection('screens')
        .doc(screenToken)
        .update({
          'lastUpdated': clock.now(),
        })
        .then((value) => debugPrint("Updated last updated"))
        .catchError((onError) => debugPrint("Couldn't update last updated"));
  }
}
