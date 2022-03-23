import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/shared/timer_provider.dart';
import 'package:diginote/ui/views/preview_view.dart';
import 'package:diginote/ui/widgets/message_item_paneled.dart';
import 'package:diginote/ui/widgets/message_item.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() async {
  late FakeFirebaseFirestore firestoreInstance;
  late FirebasePreviewProvider previewProvider;
  late TimerProvider timer;
  const token = "screenToken";
  const width = 500.0;
  const height = 500.0;

  setUp(() {
    firestoreInstance = FakeFirebaseFirestore();
    timer = TimerProvider(duration: const Duration(seconds: 1));
    previewProvider =
        FirebasePreviewProvider(firestoreInstance: firestoreInstance);
  });

  Future<void> loadPreviewView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<FirebasePreviewProvider>(
                create: (context) => previewProvider),
            ChangeNotifierProvider<TimerProvider>(create: (context) => timer),
          ],
          child: const PreviewView(
            screenToken: token,
            screenWidth: width,
            screenHeight: height,
            screenName: "Test",
            isOnline: false,
          ),
        ),
      ),
    );
  }

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

  testWidgets("Preview shows the screen's messages",
      (WidgetTester tester) async {
    await loadPreviewView(tester);
    await tester.idle();
    await tester.pump();

    expect(find.text("message1"), findsNothing);
    expect(find.text("message2"), findsNothing);
    expect(find.text("message3"), findsNothing);

    // Populate with messages
    await previewProvider.addMessage(
        token, messageBodyIDOnly("message1", "messageID1"));
    await previewProvider.addMessage(
        token, messageBodyIDOnly("message2", "messageID2"));
    await previewProvider.addMessage(
        token, messageBodyIDOnly("message3", "messageID3"));

    await tester.idle();
    await tester.pump();

    expect(find.text("message1"), findsOneWidget);
    expect(find.text("message2"), findsOneWidget);
    expect(find.text("message3"), findsOneWidget);
  });

  testWidgets('Message can be deleted', (WidgetTester tester) async {
    await loadPreviewView(tester);
    await previewProvider.addMessage(
        token, messageBodyIDOnly("message1", "messageID1"));
    await tester.idle();
    await tester.pump();

    await tester.tap(find.byType(MessageItemPaneled));
    await tester.pump();

    expect(find.byIcon(IconHelper.deleteIcon.icon!), findsOneWidget);
    await tester.tap(find.byIcon(IconHelper.deleteIcon.icon!));
    await tester.pump();

    expect(find.text("Delete"), findsOneWidget);
    await tester.tap(find.text("Delete"));
    await tester.pump();

    expect(find.byType(MessageItemPaneled), findsNothing);
  });

  testWidgets(
      'Message can be dragged to a new location and is updated in firestore',
      (WidgetTester tester) async {
    await loadPreviewView(tester);
    await previewProvider.addMessage(
        token, messageBodyIDOnly("message1", "messageID1", x: 0, y: 0));

    await tester.idle();
    await tester.pump();

    final Offset initialLocation = tester.getCenter(find.byType(MessageItem));
    final TestGesture gesture = await tester.startGesture(initialLocation);
    await tester.pump();

    await tester.pump(const Duration(seconds: 20));

    const finalLocation = Offset(50, 50);
    await gesture.moveBy(finalLocation);
    await tester.pump();

    await gesture.up();
    await tester.pump();

    final snapshot = await firestoreInstance
        .collection('messages')
        .doc(token)
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
    expect(snapshot.docs.isEmpty, false);
    final message = snapshot.docs.first.data();

    expect(message.x, isNot(0));
    expect(message.y, isNot(0));
  });
}
