import 'package:diginote/core/providers/firebase_login_provider.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/main.dart';
import 'package:diginote/ui/views/home_view.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() async {
  late FirebaseLoginProvider loginProvider;
  late FirebaseScreensProvider screensProvider;
  late MockFirebaseAuth authInstance;
  late FakeFirebaseFirestore firestoreInstance;

  setUp(() {
    authInstance = MockFirebaseAuth();
    firestoreInstance = FakeFirebaseFirestore();
    loginProvider = FirebaseLoginProvider(authInstance: authInstance);
    screensProvider = FirebaseScreensProvider(
        firestoreInstance: firestoreInstance, authInstance: authInstance);
  });

  Future<void> loadLoginView(WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => loginProvider),
        ChangeNotifierProvider(create: (context) => screensProvider),
      ],
      child: const MyApp(),
    ));
  }

  testWidgets('User can login and is taken to the home view',
      (WidgetTester tester) async {
    await loadLoginView(tester);
    
    await loginProvider.signInWithEmailAndPassword(
        "email", "password", (exception) {});
    await tester.idle();
    await tester.pump();

    expect(find.byType(HomeView), findsOneWidget);
  });
}
