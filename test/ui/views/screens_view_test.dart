import 'package:clock/clock.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
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
    await tester.tap(find.byIcon(IconHelper.screensIcon.icon!));
    await tester.pumpAndSettle();
  }

  Future<void> addPairedScreen(
      {required String name, required String userID, required String token}) async {
    final toAdd = Screen(
        pairingCode: "pairingCode",
        paired: true,
        name: name,
        userID: userID,
        lastUpdated: clock.now(),
        screenToken: token,
        width: 100,
        height: 100);
    await firestoreInstance
        .collection('screens')
        .doc(token)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) =>
              Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
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

  testWidgets("Screen can be deleted from its setting menu", (WidgetTester tester) async {
    await loadScreensView(tester);
    
    await addPairedScreen(name: "Screen1", userID: user.uid, token: "Screen1");
    await tester.idle();
    await tester.pump();

    expect(find.byType(ScreenItem), findsOneWidget);
    await tester.tap(find.byIcon(IconHelper.settingsIcon.icon!).first);
    await tester.pump();

    expect(find.text("Delete Screen"), findsOneWidget);
    await tester.tap(find.text("Delete Screen"));
    await tester.idle();
    await tester.pump();

    expect(find.byType(ScreenItem), findsNothing);
  });
}
