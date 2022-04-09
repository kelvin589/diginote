import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/core/providers/firebase_templates_provider.dart';
import 'package:diginote/core/providers/theme_provider.dart';
import 'package:diginote/core/services/io_templates_provider.dart';
import 'package:diginote/ui/views/home_view.dart';
import 'package:diginote/ui/views/screens_view.dart';
import 'package:diginote/ui/views/settings_view.dart';
import 'package:diginote/ui/views/templates_view.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() async {
  late FakeFirebaseFirestore firestoreInstance;
  late MockFirebaseAuth firebaseAuth;
  late FirebaseScreensProvider screensProvider;
  late FirebaseTemplatesProvider templatesProvider;
  late ThemeProvider themeProvider;
  MockUser mockUser = MockUser();

  setUp(() {
    firestoreInstance = FakeFirebaseFirestore();
    firebaseAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    screensProvider = FirebaseScreensProvider(
        firestoreInstance: firestoreInstance, authInstance: firebaseAuth);
    templatesProvider = FirebaseTemplatesProvider(firestoreInstance: firestoreInstance, authInstance: firebaseAuth);
    // templatesProvider.init();
    themeProvider = ThemeProvider();
    themeProvider.init();
  });

  Future<void> loadHomeView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<FirebaseScreensProvider>(
              create: (_) => screensProvider,
            ),
            ChangeNotifierProvider<FirebaseTemplatesProvider>(
              create: (_) => templatesProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(create: (context) => themeProvider),
          ],
          child: const HomeView(),
        ),
      ),
    );
  }

  testWidgets('Test widget buttons work correctly',
      (WidgetTester tester) async {
    await loadHomeView(tester);

    await tester.tap(find.text('Templates'));
    await tester.pumpAndSettle();
    expect(find.byType(TemplatesView), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsView), findsOneWidget);

    await tester.tap(find.text('Screens'));
    await tester.pumpAndSettle();
    expect(find.byType(ScreensView), findsOneWidget);
  });
}
