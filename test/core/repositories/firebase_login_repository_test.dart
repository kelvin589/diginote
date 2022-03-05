import 'package:diginote/core/repositories/firebase_login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  late FirebaseAuth firebaseAuth;
  late FirebaseLoginRepository loginRepository;
  final user = MockUser(uid: "userID");

  setUp(() async {
    firebaseAuth = MockFirebaseAuth(signedIn: false, mockUser: user);
    loginRepository = FirebaseLoginRepository(authInstance: firebaseAuth);
  });

  test('User can login', () async {
    expect(firebaseAuth.currentUser, isNull);
    loginRepository.signInWithEmailAndPassword("fake@email.com", "fakepassword", (p0) => null);

    expect(firebaseAuth.currentUser, isNotNull);
    expect(firebaseAuth.currentUser!.uid, equals("userID"));
  });

  test('User can logout', () async {
    loginRepository.signInWithEmailAndPassword("fake@email.com", "fakepassword", (p0) => null);
    expect(firebaseAuth.currentUser, isNotNull);

    loginRepository.logout();
    expect(firebaseAuth.currentUser, isNull);
  });
}