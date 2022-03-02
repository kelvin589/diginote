import 'package:clock/clock.dart';
import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:diginote/core/repositories/firebase_screens_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../screen_pairing_matcher.dart';

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

  ScreenPairing screenPairingIDTokenOnly(String userID, String screenToken) {
    return ScreenPairing(
        pairingCode: "ABC123",
        paired: true,
        name: "",
        userID: userID,
        lastUpdated: clock.now(),
        screenToken: screenToken,
        width: 100,
        height: 100);
  }

  Future<void> addPairedScreen(ScreenPairing screenPairing) async {
    await firestoreInstance
        .collection('pairingCodes')
        .doc(screenPairing.screenToken)
        .withConverter<ScreenPairing>(
          fromFirestore: (snapshot, _) =>
              ScreenPairing.fromJson(snapshot.data()!),
          toFirestore: (screenPairing, _) => screenPairing.toJson(),
        )
        .set(screenPairing);
  }

  Future<ScreenPairing?> getScreenPairing(String screenToken) async {
    final snapshot = await firestoreInstance
        .collection('pairingCodes')
        .where('screenToken', isEqualTo: screenToken)
        .withConverter<ScreenPairing>(
          fromFirestore: (snapshot, _) =>
              ScreenPairing.fromJson(snapshot.data()!),
          toFirestore: (screenPairing, _) => screenPairing.toJson(),
        )
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  test('Add a new screen', () async {
    // Initial screen data for unpaired screen
    const screenToken = "screenToken";
    ScreenPairing screenPairing = ScreenPairing(
        pairingCode: "ABC123",
        paired: false,
        name: "",
        userID: "",
        lastUpdated: clock.now(),
        screenToken: screenToken,
        width: 100,
        height: 100);
    addPairedScreen(screenPairing);

    await screensRepository.addScreen(screenPairing);
    final pairedScreen = await getScreenPairing(screenToken);

    // Screen considered paired if 'paired' is true and 'userID' is this user
    expect(pairedScreen?.paired, true);
    expect(pairedScreen?.name, equals(screenPairing.name));
    expect(pairedScreen?.userID, equals(mockUser.uid));
  });

  test("Get this user's screens", () async {
    final screen1 = screenPairingIDTokenOnly(mockUser.uid, "screen1");
    final screen2 = screenPairingIDTokenOnly(mockUser.uid, "screen2");
    final screen3 = screenPairingIDTokenOnly("notMine", "screen3");

    expect(
      screensRepository.getScreens(),
      emitsInOrder([
        [],
        [ScreenPairingMatcher(screen1.toJson())],
        [
          ScreenPairingMatcher(screen1.toJson()),
          ScreenPairingMatcher(screen2.toJson())
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
    final screen1 = screenPairingIDTokenOnly(mockUser.uid, screenToken);
    await addPairedScreen(screen1);

    final pairedScreen = await getScreenPairing(screenToken);
    expect(screen1 == pairedScreen, true);
    await screensRepository.deleteScreen("screen1");
    expect(await getScreenPairing(screenToken), isNull);
  });
}
