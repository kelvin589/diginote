import 'package:clock/clock.dart';
import 'package:diginote/core/models/screen_info_model.dart';
import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/repositories/firebase_screen_info_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../screen_info_matcher.dart';

void main() async {
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestoreInstance;
  late FirebaseScreenInfoRepository screenInfoRepository;

  MockUser mockUser = MockUser(uid: "userID");
  String screenToken = "ScreenToken";

  setUp(() {
    firebaseAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    firestoreInstance = FakeFirebaseFirestore();
    screenInfoRepository = FirebaseScreenInfoRepository(
        firestoreInstance: firestoreInstance, authInstance: firebaseAuth);
  });

  final ScreenInfo mockInfo = ScreenInfo(
      screenToken: screenToken,
      batteryPercentage: 100,
      lowBatteryThreshold: 50,
      lowBatteryNotificationDelay: 60,
      batteryReportingDelay: 30,
      isOnline: false);

  final ScreenInfo mockInfoUpdated = ScreenInfo(
      screenToken: screenToken,
      batteryPercentage: 50,
      lowBatteryThreshold: 30,
      lowBatteryNotificationDelay: 10,
      batteryReportingDelay: 20,
      isOnline: true);

  final mockScreen = Screen(
      pairingCode: "",
      paired: true,
      name: "name",
      userID: "userID",
      lastUpdated: const Clock().now(),
      screenToken: screenToken,
      width: 100,
      height: 100);

  Future<void> addScreen(Screen screen) async {
    await firestoreInstance
        .collection('screens')
        .doc(screenToken)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) => Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .set(screen);
  }

  Future<Screen?> getScreen(String screenToken) async {
    final snapshot = await firestoreInstance
        .collection('screens')
        .where('screenToken', isEqualTo: screenToken)
        .withConverter<Screen>(
          fromFirestore: (snapshot, _) => Screen.fromJson(snapshot.data()!),
          toFirestore: (screen, _) => screen.toJson(),
        )
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  Future<ScreenInfo?> getScreenInfo(String screenToken) async {
    final snapshot = await firestoreInstance
        .collection('screenInfo')
        .where('screenToken', isEqualTo: screenToken)
        .withConverter<ScreenInfo>(
          fromFirestore: (snapshot, _) => ScreenInfo.fromJson(snapshot.data()!),
          toFirestore: (screenInfo, _) => screenInfo.toJson(),
        )
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  test('Add screen info for the screen token', () async {
    await screenInfoRepository.setScreenInfo(screenToken, mockInfo);
    final retrievedInfo = await getScreenInfo(screenToken);

    expect(retrievedInfo, isNotNull);
    expect(retrievedInfo!, ScreenInfoMatcher(mockInfo.toJson()));
  });

  test('Update screen info for the screen token, including the name', () async {
    String updatedName = "newName";
    await addScreen(mockScreen);

    await screenInfoRepository.setScreenInfo(screenToken, mockInfo);
    final retrievedInfo = await getScreenInfo(screenToken);

    expect(retrievedInfo, isNotNull);
    expect(retrievedInfo!, ScreenInfoMatcher(mockInfo.toJson()));

    await screenInfoRepository.setScreenInfo(screenToken, mockInfoUpdated,
        screenName: updatedName);
    final retrievedUpdatedInfo = await getScreenInfo(screenToken);

    expect(retrievedUpdatedInfo, isNotNull);
    expect(retrievedUpdatedInfo!, ScreenInfoMatcher(mockInfoUpdated.toJson()));

    final retrievedUpdatedScreen = await getScreen(screenToken);

    expect(retrievedUpdatedScreen, isNotNull);
    expect(retrievedUpdatedScreen!.name, isNot(mockScreen.name));
    expect(retrievedUpdatedScreen.name, updatedName);
  });

  test('Retrieve stream of screen info for the screen token', () async {
    expect(
      screenInfoRepository.getScreenInfo(screenToken),
      emitsInOrder([
        [],
        [ScreenInfoMatcher(mockInfo.toJson())],
        [ScreenInfoMatcher(mockInfoUpdated.toJson())],
      ]),
    );

    await Future.delayed(Duration.zero);
    await screenInfoRepository.setScreenInfo(screenToken, mockInfo);

    await Future.delayed(Duration.zero);
    await screenInfoRepository.setScreenInfo(screenToken, mockInfoUpdated);
  });
}
