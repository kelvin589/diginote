import 'package:clock/clock.dart';
import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/views/home_view.dart';
import 'package:diginote/ui/widgets/screen_item.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() async {
  late FakeFirebaseFirestore firestoreInstance;
  late MockFirebaseAuth authInstance;
  late FirebaseScreensProvider screensProvider;
  late FirebasePreviewProvider previewProvider;
  final user = MockUser();

  setUp(() {
    firestoreInstance = FakeFirebaseFirestore();
    authInstance = MockFirebaseAuth(signedIn: true, mockUser: user);
    screensProvider = FirebaseScreensProvider(
        authInstance: authInstance, firestoreInstance: firestoreInstance);
    previewProvider =
        FirebasePreviewProvider(firestoreInstance: firestoreInstance);
  });

  Future<void> loadScreensView(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<FirebaseScreensProvider>(
              create: (context) => screensProvider),
          ChangeNotifierProvider<FirebasePreviewProvider>(
              create: (context) => previewProvider),
        ],
        child: const MaterialApp(
          home: HomeView(),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.tablet));
    await tester.pumpAndSettle();
  }

  Future<void> addPairedScreen(
      {required String name, required String userID, required String token}) async {
    final toAdd = ScreenPairing(
        pairingCode: "pairingCode",
        paired: true,
        name: name,
        userID: userID,
        lastUpdated: clock.now(),
        screenToken: token,
        width: 100,
        height: 100);
    await firestoreInstance
        .collection('pairingCodes')
        .doc(token)
        .withConverter<ScreenPairing>(
          fromFirestore: (snapshot, _) =>
              ScreenPairing.fromJson(snapshot.data()!),
          toFirestore: (screenPairing, _) => screenPairing.toJson(),
        )
        .set(toAdd);
  }

  testWidgets("Screens view shows only the user's screens", (WidgetTester tester) async {
    await loadScreensView(tester);

    expect(find.byType(ScreenItem), findsNothing);

    await addPairedScreen(name: "Screen1", userID: user.uid, token: "Screen1");
    await tester.idle();
    await tester.pump();

    expect(find.byType(ScreenItem), findsOneWidget);
    expect(find.text("Screen1"), findsOneWidget);

    await addPairedScreen(name: "Screen2", userID: user.uid, token: "Screen2");
    await tester.idle();
    await tester.pump();

    await addPairedScreen(name: "Screen3", userID: "Not_Mine", token: "Screen3");
    await tester.idle();
    await tester.pump();

    expect(find.byType(ScreenItem), findsNWidgets(2));
    expect(find.text("Screen1"), findsOneWidget);
    expect(find.text("Screen2"), findsOneWidget);
  });

  testWidgets("Edit button shows delete button and screen can be deleted", (WidgetTester tester) async {
    await loadScreensView(tester);
    
    await addPairedScreen(name: "Screen1", userID: user.uid, token: "Screen1");
    await tester.idle();
    await tester.pump();

    expect(find.byType(ScreenItem), findsOneWidget);
    await tester.tap(find.byIcon(Icons.mode_edit_outlined));
    await tester.pump();

    expect(find.text("Delete"), findsOneWidget);
    await tester.tap(find.text("Delete"));
    await tester.idle();
    await tester.pump();

    expect(find.byType(ScreenItem), findsNothing);
  });
}
