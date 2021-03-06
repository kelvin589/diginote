import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/repositories/firebase_preview_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../message_matcher.dart';

void main() async {
  late FakeFirebaseFirestore firestoreInstance;
  late FirebasePreviewRepository previewRepository;
  const screenToken = "screenToken";

  setUp(() async {
    firestoreInstance = FakeFirebaseFirestore();
    previewRepository =
        FirebasePreviewRepository(firestoreInstance: firestoreInstance);

    // Assuming that screen is already paired
    final screen = Screen(
        pairingCode: "ABC123",
        paired: true,
        name: "",
        userID: "userID",
        lastUpdated: clock.now(),
        screenToken: screenToken,
        width: 100,
        height: 100);
    await firestoreInstance
        .collection('screens')
        .doc(screen.screenToken)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) => Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .set(screen);
  });

  Message messageBodyIDOnly(String message, String id,
      {double x = 0, double y = 0}) {
    return Message(
      header: "header",
      message: message,
      x: x,
      y: y,
      id: id,
      from: clock.now(),
      to: clock.now(),
      scheduled: false,
      fontFamily: "Roboto",
      fontSize: 12,
      backgrondColour: 4294961979,
      foregroundColour: 4278190080,
      width: 100,
      height: 100,
      textAlignment: TextAlign.left.name,
    );
  }

  Future<Message?> getFirstMessage() async {
    final snapshot = await firestoreInstance
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
        .get();

    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  test('Add message', () async {
    Message message = Message(
      header: "header",
      message: "message",
      x: 0,
      y: 0,
      id: "id",
      from: clock.now(),
      to: clock.now(),
      scheduled: false,
      fontFamily: "Roboto",
      fontSize: 12,
      backgrondColour: 4294961979,
      foregroundColour: 4278190080,
      width: 100,
      height: 100,
      textAlignment: TextAlign.left.name,
    );
    await previewRepository.addMessage(screenToken, message);

    final firstMessage = await getFirstMessage();
    expect(firstMessage, isNotNull);
    expect(firstMessage?.header, equals("header"));
  });

  test('Update message', () async {
    Message message = messageBodyIDOnly("Message1", "id");
    await previewRepository.addMessage(screenToken, message);
    final firstMessage = await getFirstMessage();
    expect(firstMessage, isNotNull);

    // The id must be set to the same as the one inserted above
    Message updatedMessage = messageBodyIDOnly("Message1 Updated", firstMessage!.id);
    await previewRepository.updateMessage(screenToken, updatedMessage);

    final secondMessage = await getFirstMessage();
    expect(secondMessage, isNotNull);
    expect(secondMessage?.message, equals("Message1 Updated"));
  });

  test('Get messages', () async {
    final message1 = messageBodyIDOnly("message1", "messageID1");
    final message2 = messageBodyIDOnly("message2", "messageID2");
    final message3 = messageBodyIDOnly("message3", "messageID3");

    await previewRepository.addMessage(screenToken, message1);
    await Future.delayed(Duration.zero);

    expect(
      previewRepository.getMessages(screenToken),
      emitsInOrder([
        [MessageMatcher(message1.toJson())],
        [MessageMatcher(message1.toJson()), MessageMatcher(message2.toJson())],
        [MessageMatcher(message1.toJson()), MessageMatcher(message2.toJson())],
        [
          MessageMatcher(message1.toJson()),
          MessageMatcher(message2.toJson()),
          MessageMatcher(message3.toJson())
        ],
      ]),
    );

    await previewRepository.addMessage(screenToken, message2);
    await Future.delayed(Duration.zero);
    await previewRepository.addMessage(screenToken, message3);
    await Future.delayed(Duration.zero);
  });

  test('Update message coordinates', () async {
    final message1 = messageBodyIDOnly("message1", "messageID1");

    await previewRepository.addMessage(screenToken, message1);
    await Future.delayed(Duration.zero);

    final beforeUpdating = await getFirstMessage();
    expect(beforeUpdating, isNotNull);
    expect(beforeUpdating?.x, equals(0));
    expect(beforeUpdating?.y, equals(0));

    // Doc id auto generated by firebase so it must be accessed from the retrieved message
    final message1WithXY =
        messageBodyIDOnly("message1", beforeUpdating!.id, x: 50, y: 50);

    await previewRepository.updateMessageCoordinates(
        screenToken, message1WithXY);
    await Future.delayed(Duration.zero);

    final afterUpdating = await getFirstMessage();
    expect(afterUpdating, isNotNull);
    expect(afterUpdating?.x, equals(50));
    expect(afterUpdating?.y, equals(50));
  });

  test('Delete message', () async {
    final message1 = messageBodyIDOnly("message1", "messageID1");

    await previewRepository.addMessage(screenToken, message1);
    await Future.delayed(Duration.zero);
    final retrievedMessage = await getFirstMessage();
    expect(retrievedMessage, isNotNull);

    await previewRepository.deleteMessage(screenToken, retrievedMessage!);
    expect(await getFirstMessage(), isNull);
  });

  test('Update message scheduling', () async {
    final message1 = messageBodyIDOnly("message1", "messageID1");

    await previewRepository.addMessage(screenToken, message1);
    await Future.delayed(Duration.zero);

    final beforeUpdating = await getFirstMessage();
    expect(beforeUpdating, isNotNull);

    final scheduledDate = clock.now();

    await previewRepository.updateMessageSchedule(
        screenToken, beforeUpdating!, scheduledDate, scheduledDate, true);
    await Future.delayed(Duration.zero);

    final afterUpdating = await getFirstMessage();
    expect(afterUpdating, isNotNull);
    expect(afterUpdating?.from, equals(scheduledDate));
    expect(afterUpdating?.to, equals(scheduledDate));
    expect(afterUpdating?.scheduled, equals(true));
  });
}
