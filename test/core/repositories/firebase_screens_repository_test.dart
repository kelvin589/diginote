import 'package:clock/clock.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/repositories/firebase_screens_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../screen_matcher.dart';

void main() async {
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestoreInstance;
  late FirebaseScreensRepository screensRepository;

  MockUser mockUser = MockUser(uid: "userID");

  setUp(() {
    firebaseAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    firestoreInstance = FakeFirebaseFirestore();
    screensRepository = FirebaseScreensRepository(
        firestoreInstance: firestoreInstance, authInstance: firebaseAuth);
  });

  Screen screenIDTokenOnly(String userID, String screenToken) {
    return Screen(
        pairingCode: "ABC123",
        paired: true,
        name: "",
        userID: userID,
        lastUpdated: clock.now(),
        screenToken: screenToken,
        width: 100,
        height: 100);
  }

  Future<void> addPairedScreen(Screen screen) async {
    await firestoreInstance
        .collection('screens')
        .doc(screen.screenToken)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) =>
              Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .set(screen);
  }

  Future<Screen?> getScreen(String screenToken) async {
    final snapshot = await firestoreInstance
        .collection('screens')
        .where('screenToken', isEqualTo: screenToken)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) =>
              Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  test('Add a new screen', () async {
    // Initial screen data for unpaired screen
    const screenToken = "screenToken";
    Screen screen = Screen(
        pairingCode: "ABC123",
        paired: false,
        name: "",
        userID: "",
        lastUpdated: clock.now(),
        screenToken: screenToken,
        width: 100,
        height: 100);
    addPairedScreen(screen);

    await screensRepository.addScreen(screen, () => {}, () async => {});
    final pairedScreen = await getScreen(screenToken);

    // Screen considered paired if 'paired' is true and 'userID' is this user
    expect(pairedScreen?.paired, true);
    expect(pairedScreen?.name, equals(screen.name));
    expect(pairedScreen?.userID, equals(mockUser.uid));
  });

  test("Get this user's screens", () async {
    final screen1 = screenIDTokenOnly(mockUser.uid, "screen1");
    final screen2 = screenIDTokenOnly(mockUser.uid, "screen2");
    final screen3 = screenIDTokenOnly("notMine", "screen3");

    expect(
      screensRepository.getScreens(),
      emitsInOrder([
        [],
        [ScreenMatcher(screen1.toJson())],
        [
          ScreenMatcher(screen1.toJson()),
          ScreenMatcher(screen2.toJson())
        ],
      ]),
    );

    // Shouldn't contain a screen that's not mine
    await Future.delayed(Duration.zero);
    await addPairedScreen(screen3);
    // But should contain my screens
    await Future.delayed(Duration.zero);
    await addPairedScreen(screen1);
    await Future.delayed(Duration.zero);
    await addPairedScreen(screen2);
  });

  test("Delete a screen", () async {
    const screenToken = "screen1";
    final screen1 = screenIDTokenOnly(mockUser.uid, screenToken);
    await addPairedScreen(screen1);

    final pairedScreen = await getScreen(screenToken);
    expect(screen1 == pairedScreen, true);
    await screensRepository.deleteScreen("screen1");
    expect(await getScreen(screenToken), isNull);
  });
}
