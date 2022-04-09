import 'package:clock/clock.dart';
import 'package:diginote/core/models/screen_info_model.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/firebase_screen_info_provider.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/views/home_view.dart';
import 'package:diginote/ui/widgets/add_screen_popup.dart';
import 'package:diginote/ui/widgets/screen_item.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _Descriptions {
  static final emptyText = find.textContaining("Field cannot be empty");
  static final invalidScreenName =
      find.textContaining("Not a valid screen name");
  static final invalidPairingCode =
      find.textContaining("The format is incorrect");
  static final nonExistentPairingCode =
      find.textContaining("Already paired or the code wrong.");
}

void main() async {
  late FakeFirebaseFirestore firestoreInstance;
  late MockFirebaseAuth authInstance;
  late FirebaseScreensProvider screensProvider;
  late FirebasePreviewProvider previewProvider;
  late FirebaseScreenInfoProvider screenInfoProvider;
  final user = MockUser();

  setUp(() {
    firestoreInstance = FakeFirebaseFirestore();
    authInstance = MockFirebaseAuth(signedIn: true, mockUser: user);
    screensProvider = FirebaseScreensProvider(
        authInstance: authInstance, firestoreInstance: firestoreInstance);
    previewProvider =
        FirebasePreviewProvider(firestoreInstance: firestoreInstance);
    screenInfoProvider = FirebaseScreenInfoProvider(
        firestoreInstance: firestoreInstance, authInstance: authInstance);
  });

  Future<void> loadScreensView(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<FirebaseScreensProvider>(
              create: (context) => screensProvider),
          ChangeNotifierProvider<FirebasePreviewProvider>(
              create: (context) => previewProvider),
          ChangeNotifierProvider<FirebaseScreenInfoProvider>(
              create: (context) => screenInfoProvider),
        ],
        child: const MaterialApp(
          home: HomeView(),
        ),
      ),
    );
    await tester.tap(find.byIcon(IconHelper.screensIcon.icon!));
    await tester.pumpAndSettle();
  }

  Future<void> addScreen(
      {required String name,
      required String userID,
      required String token,
      bool paired = true,
      String pairingCode = "pairingCode"}) async {
    final toAddScreen = Screen(
        pairingCode: pairingCode,
        paired: paired,
        name: name,
        userID: userID,
        lastUpdated: clock.now(),
        screenToken: token,
        width: 100,
        height: 100);
    final toAddScreenInfo = ScreenInfo(
        screenToken: token,
        batteryPercentage: 100,
        lowBatteryThreshold: 50,
        lowBatteryNotificationDelay: 60,
        batteryReportingDelay: 60,
        isOnline: true);
    await firestoreInstance
        .collection('screens')
        .doc(token)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) => Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .set(toAddScreen);
    await firestoreInstance
        .collection('screenInfo')
        .doc(token)
        .withConverter<ScreenInfo>(
          fromFirestore: (snapshot, _) => ScreenInfo.fromJson(snapshot.data()!),
          toFirestore: (screenInfo, _) => screenInfo.toJson(),
        )
        .set(toAddScreenInfo);
  }

  testWidgets("Screens view shows only the user's screens",
      (WidgetTester tester) async {
    await loadScreensView(tester);

    expect(find.byType(ScreenItem), findsNothing);

    await addScreen(name: "Screen1", userID: user.uid, token: "Screen1");
    await tester.idle();
    await tester.pump(); // One pump to load Screen
    await tester.pump(); // Another pump to load ScreenInfo

    expect(find.byType(ScreenItem), findsOneWidget);
    expect(find.text("Screen1"), findsOneWidget);

    await addScreen(name: "Screen2", userID: user.uid, token: "Screen2");
    await tester.idle();
    await tester.pump();
    await tester.pump();

    await addScreen(name: "Screen3", userID: "Not_Mine", token: "Screen3");
    await tester.idle();
    await tester.pump();
    await tester.pump();

    expect(find.byType(ScreenItem), findsNWidgets(2));
    expect(find.text("Screen1"), findsOneWidget);
    expect(find.text("Screen2"), findsOneWidget);
  });

  testWidgets("Screen can be deleted from its setting menu",
      (WidgetTester tester) async {
    await loadScreensView(tester);

    await addScreen(name: "Screen1", userID: user.uid, token: "Screen1");
    await tester.idle();
    await tester.pump();
    await tester.pump();

    expect(find.byType(ScreenItem), findsOneWidget);
    await tester.tap(find.byIcon(IconHelper.settingsIcon.icon!).first);
    await tester.pump();

    expect(find.text("Delete Screen"), findsOneWidget);
    await tester.tap(find.text("Delete Screen"));
    await tester.idle();
    await tester.pump();

    expect(find.text("Delete"), findsOneWidget);
    await tester.tap(find.text("Delete"));
    await tester.pump();

    expect(find.byType(ScreenItem), findsNothing);
  });

  // Fields in the add screen popup are ordered as follows: screen name, pairing code
  TextFormField findScreenNameField(WidgetTester tester) {
    final fieldFinder = find.byType(TextFormField);
    List<TextFormField> fields =
        fieldFinder.evaluate().map((e) => e.widget as TextFormField).toList();
    return fields[0];
  }

  TextFormField findPairingCodeField(WidgetTester tester) {
    final fieldFinder = find.byType(TextFormField);
    List<TextFormField> fields =
        fieldFinder.evaluate().map((e) => e.widget as TextFormField).toList();
    return fields[1];
  }

  Future<void> tapAddScreen(WidgetTester tester) async {
    final buttonFinder = find.byType(FloatingActionButton);
    await tester.tap(buttonFinder.first);
    await tester.idle();
    await tester.pump();
  }

  Future<void> tapOK(WidgetTester tester) async {
    final textFinder = find.text("OK");
    await tester.tap(textFinder.first);
    await tester.idle();
    await tester.pump();
  }

  testWidgets(
      'A null screen name and pairing code i.e. input field has not been pressed',
      (WidgetTester tester) async {
    await loadScreensView(tester);
    await tapAddScreen(tester);
    await tapOK(tester);

    expect(_Descriptions.emptyText, findsNWidgets(2));
  });

  group('Test pairing code validation when pairing a new screen', () {
    testWidgets("An empty pairing code", (WidgetTester tester) async {
      await loadScreensView(tester);
      await tapAddScreen(tester);

      final TextFormField pairingCodeField = findPairingCodeField(tester);
      await tester.enterText(find.byWidget(pairingCodeField), ' ');
      await tapOK(tester);

      expect(_Descriptions.invalidPairingCode, findsOneWidget);
    });

    testWidgets("A pairing code in the wrong format",
        (WidgetTester tester) async {
      await loadScreensView(tester);
      await tapAddScreen(tester);

      final TextFormField pairingCodeField = findPairingCodeField(tester);
      await tester.enterText(find.byWidget(pairingCodeField), 'ab45gd');
      await tapOK(tester);

      expect(_Descriptions.invalidPairingCode, findsOneWidget);
    });

    testWidgets("A pairing code which does not exist",
        (WidgetTester tester) async {
      await loadScreensView(tester);
      await tapAddScreen(tester);

      await addScreen(
          name: "Screen1", userID: user.uid, token: "AC45GD", paired: false);

      final TextFormField screenNameField = findScreenNameField(tester);
      await tester.enterText(find.byWidget(screenNameField), 'Screen1');
      final TextFormField pairingCodeField = findPairingCodeField(tester);
      await tester.enterText(find.byWidget(pairingCodeField), 'AB45GD');

      await tapOK(tester);

      expect(_Descriptions.nonExistentPairingCode, findsOneWidget);
    });

    testWidgets("A valid pairing code for an unpaired screen",
        (WidgetTester tester) async {
      await loadScreensView(tester);
      await tapAddScreen(tester);

      await addScreen(
          name: "Screen1",
          userID: user.uid,
          token: "Screen1",
          paired: false,
          pairingCode: "AB45GD");

      final TextFormField screenNameField = findScreenNameField(tester);
      await tester.enterText(find.byWidget(screenNameField), 'Screen1');
      final TextFormField pairingCodeField = findPairingCodeField(tester);
      await tester.enterText(find.byWidget(pairingCodeField), 'AB45GD');

      await tapOK(tester);

      // Successfully paired screen closes the poup
      expect(find.byType(AddScreenPopup), findsNothing);
    });
  });

  group('Test screen name validation when pairing a new screen', () {
    testWidgets("An empty screen name", (WidgetTester tester) async {
      await loadScreensView(tester);
      await tapAddScreen(tester);

      final TextFormField screenNameField = findScreenNameField(tester);
      await tester.enterText(find.byWidget(screenNameField), ' ');
      await tapOK(tester);

      expect(_Descriptions.invalidScreenName, findsOneWidget);
    });

    testWidgets(
        "A screen name that meets other requirements but is one too short",
        (WidgetTester tester) async {
      await loadScreensView(tester);
      await tapAddScreen(tester);

      final TextFormField screenNameField = findScreenNameField(tester);
      await tester.enterText(find.byWidget(screenNameField), 'ab');
      await tapOK(tester);

      expect(_Descriptions.invalidScreenName, findsOneWidget);
    });

    testWidgets("A screen name with length exactly as the minimum",
        (WidgetTester tester) async {
      await loadScreensView(tester);
      await tapAddScreen(tester);

      final TextFormField screenNameField = findScreenNameField(tester);
      await tester.enterText(find.byWidget(screenNameField), 'abc');
      await tapOK(tester);

      expect(_Descriptions.invalidScreenName, findsNothing);
    });
  });
}
