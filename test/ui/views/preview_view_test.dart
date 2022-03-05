import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/views/preview_view.dart';
import 'package:diginote/ui/widgets/preview_item.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() async {
  late FakeFirebaseFirestore firestoreInstance;
  late FirebasePreviewProvider previewProvider;
  const token = "screenToken";
  const width = 500.0;
  const height = 500.0;

  setUp(() {
    firestoreInstance = FakeFirebaseFirestore();
    previewProvider =
        FirebasePreviewProvider(firestoreInstance: firestoreInstance);
  });

  Future<void> loadPreviewView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<FirebasePreviewProvider>(
          create: (_) => previewProvider,
          child: const PreviewView(
              screenToken: token, screenWidth: width, screenHeight: height),
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
        scheduled: false);
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

    await tester.tap(find.byType(MessageItem));
    await tester.pump();

    expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pump();

    expect(find.byType(MessageItem), findsNothing);
  });
}
