import 'package:diginote/core/providers/firebase_register_provider.dart';
import 'package:diginote/ui/views/register_view.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _Descriptions {
  static final emptyText = find.textContaining("Field cannot be empty");

  static final invalidEmail = find.textContaining("Not a valid email");

  static final oneUppercase =
      find.textContaining("Must contain one uppercase letter");
  static final oneLowercase =
      find.textContaining("Must contain one lowercase letter");
  static final oneDigit = find.textContaining("Must contain one numeric digit");
  static final oneSpecial =
      find.textContaining("Must contain one special character, without spaces");
  static final minLength = find.textContaining("Must be at least 6 characters");

  static final invalidUsername = find.textContaining("Not a valid username");
}

void main() async {
  late FirebaseRegisterProvider registerProvider;
  late MockFirebaseAuth authInstance;

  setUp(() {
    authInstance = MockFirebaseAuth();
    registerProvider = FirebaseRegisterProvider(authInstance: authInstance);
  });

  Future<void> loadRegisterView(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => registerProvider),
        ],
        child: Consumer<FirebaseRegisterProvider>(
          builder: (context, registerProvider, child) => RegisterView(
            applicationRegisterState: registerProvider.applicationRegisterState,
          ),
        ),
      ),
    ));
    await tester.idle();
    await tester.pump();
  }

  // Fields in the form are ordered as follows: username, email password
  TextFormField findUsernameField(WidgetTester tester) {
    final fieldFinder = find.byType(TextFormField);
    List<TextFormField> fields =
        fieldFinder.evaluate().map((e) => e.widget as TextFormField).toList();
    return fields[0];
  }

  TextFormField findEmailField(WidgetTester tester) {
    final fieldFinder = find.byType(TextFormField);
    List<TextFormField> fields =
        fieldFinder.evaluate().map((e) => e.widget as TextFormField).toList();
    return fields[1];
  }

  TextFormField findPasswordField(WidgetTester tester) {
    final fieldFinder = find.byType(TextFormField);
    List<TextFormField> fields =
        fieldFinder.evaluate().map((e) => e.widget as TextFormField).toList();
    return fields[2];
  }

  Future<void> tapRegister(WidgetTester tester) async {
    final buttonFinder = find.byType(ElevatedButton);
    await tester.tap(buttonFinder.first);
    await tester.idle();
    await tester.pump();
  }

  testWidgets('A null username, email and password',
      (WidgetTester tester) async {
    await loadRegisterView(tester);
    await tapRegister(tester);

    // Finds three as we also have three empty fields
    expect(_Descriptions.emptyText, findsNWidgets(3));
  });

  group('Test password validation and its associated descriptions', () {
    testWidgets('An empty password', (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), ' ');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsOneWidget);
      expect(_Descriptions.oneLowercase, findsOneWidget);
      expect(_Descriptions.oneDigit, findsOneWidget);
      expect(_Descriptions.oneSpecial, findsOneWidget);
      expect(_Descriptions.minLength, findsOneWidget);
    });

    testWidgets('A password not meeting the one uppercase requirement',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), 'pa\$word1');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsOneWidget);
      expect(_Descriptions.oneLowercase, findsNothing);
      expect(_Descriptions.oneDigit, findsNothing);
      expect(_Descriptions.oneSpecial, findsNothing);
      expect(_Descriptions.minLength, findsNothing);
    });

    testWidgets('A password not meeting the one lowercase requirement',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), 'PA\$WORD1');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsNothing);
      expect(_Descriptions.oneLowercase, findsOneWidget);
      expect(_Descriptions.oneDigit, findsNothing);
      expect(_Descriptions.oneSpecial, findsNothing);
      expect(_Descriptions.minLength, findsNothing);
    });

    testWidgets('A password not meeting the one digit requirement',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), 'pa\$worD');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsNothing);
      expect(_Descriptions.oneLowercase, findsNothing);
      expect(_Descriptions.oneDigit, findsOneWidget);
      expect(_Descriptions.oneSpecial, findsNothing);
      expect(_Descriptions.minLength, findsNothing);
    });

    testWidgets('A password not meeting the one special character requirement',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), 'pasworD1');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsNothing);
      expect(_Descriptions.oneLowercase, findsNothing);
      expect(_Descriptions.oneDigit, findsNothing);
      expect(_Descriptions.oneSpecial, findsOneWidget);
      expect(_Descriptions.minLength, findsNothing);
    });

    testWidgets('A password that meets other requirements but is one too short',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), 'pA\$1d');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsNothing);
      expect(_Descriptions.oneLowercase, findsNothing);
      expect(_Descriptions.oneDigit, findsNothing);
      expect(_Descriptions.oneSpecial, findsNothing);
      expect(_Descriptions.minLength, findsOneWidget);
    });

    testWidgets('A valid password with length exactly as the minimum',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), 'pA\$1dW');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsNothing);
      expect(_Descriptions.oneLowercase, findsNothing);
      expect(_Descriptions.oneDigit, findsNothing);
      expect(_Descriptions.oneSpecial, findsNothing);
      expect(_Descriptions.minLength, findsNothing);
    });

    testWidgets('A valid password which contains spaces',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), 'pa\$ worD1 ');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsNothing);
      expect(_Descriptions.oneLowercase, findsNothing);
      expect(_Descriptions.oneDigit, findsNothing);
      expect(_Descriptions.oneSpecial, findsOneWidget);
      expect(_Descriptions.minLength, findsNothing);
    });

    testWidgets('A valid password', (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField passwordField = findPasswordField(tester);
      await tester.enterText(find.byWidget(passwordField), 'pa\$worD1');
      await tapRegister(tester);

      expect(_Descriptions.oneUppercase, findsNothing);
      expect(_Descriptions.oneLowercase, findsNothing);
      expect(_Descriptions.oneDigit, findsNothing);
      expect(_Descriptions.oneSpecial, findsNothing);
      expect(_Descriptions.minLength, findsNothing);
    });
  });

  group('Test username validation and its associated descriptions', () {
    testWidgets('An empty username', (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField usernameField = findUsernameField(tester);
      await tester.enterText(find.byWidget(usernameField), ' ');
      await tapRegister(tester);

      expect(_Descriptions.invalidUsername, findsOneWidget);
    });

    testWidgets('A valid username', (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField usernameField = findUsernameField(tester);
      await tester.enterText(find.byWidget(usernameField), 'ValidUsername1');
      await tapRegister(tester);

      expect(_Descriptions.invalidUsername, findsNothing);
    });

    testWidgets('A valid username which contains spaces',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField usernameField = findUsernameField(tester);
      await tester.enterText(find.byWidget(usernameField), 'Inv alid');
      await tapRegister(tester);

      expect(_Descriptions.invalidUsername, findsOneWidget);
    });

    testWidgets('A valid username which contains symbols',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField usernameField = findUsernameField(tester);
      await tester.enterText(find.byWidget(usernameField), 'Inv@l!d');
      await tapRegister(tester);

      expect(_Descriptions.invalidUsername, findsOneWidget);
    });

    testWidgets('A username that meets other requirements but is one too short',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField usernameField = findUsernameField(tester);
      await tester.enterText(find.byWidget(usernameField), 'va');
      await tapRegister(tester);

      expect(_Descriptions.invalidUsername, findsOneWidget);
    });

    testWidgets('A valid username with length exactly as the minimum',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField usernameField = findUsernameField(tester);
      await tester.enterText(find.byWidget(usernameField), 'val');
      await tapRegister(tester);

      expect(_Descriptions.invalidUsername, findsNothing);
    });
  });

  group('Test email validation and its associated descriptions', () {
    testWidgets('An empty email', (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField emailField = findEmailField(tester);
      await tester.enterText(find.byWidget(emailField), ' ');
      await tapRegister(tester);

      expect(_Descriptions.invalidEmail, findsOneWidget);
    });

    testWidgets('A valid email', (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField emailField = findEmailField(tester);
      await tester.enterText(find.byWidget(emailField), 'email@domain.com');
      await tapRegister(tester);

      expect(_Descriptions.invalidEmail, findsNothing);
    });

    testWidgets('A valid email containing valid symbols',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField emailField = findEmailField(tester);
      await tester.enterText(
          find.byWidget(emailField), '_em-ail+123@domain.com');
      await tapRegister(tester);

      expect(_Descriptions.invalidEmail, findsNothing);
    });

    testWidgets('A valid email with a subdomain', (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField emailField = findEmailField(tester);
      await tester.enterText(find.byWidget(emailField), 'email@sub.domain.com');
      await tapRegister(tester);

      expect(_Descriptions.invalidEmail, findsNothing);
    });

    testWidgets('An email missing the @ and domain',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField emailField = findEmailField(tester);
      await tester.enterText(find.byWidget(emailField), 'email domain com');
      await tapRegister(tester);

      expect(_Descriptions.invalidEmail, findsOneWidget);
    });

    testWidgets('An email missing its top-level domain',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField emailField = findEmailField(tester);
      await tester.enterText(find.byWidget(emailField), 'email@domain');
      await tapRegister(tester);

      expect(_Descriptions.invalidEmail, findsOneWidget);
    });

    testWidgets('An email with multiple full stops',
        (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField emailField = findEmailField(tester);
      await tester.enterText(find.byWidget(emailField), 'email@domain..com');
      await tapRegister(tester);

      expect(_Descriptions.invalidEmail, findsOneWidget);
    });

    testWidgets('An email missing its username', (WidgetTester tester) async {
      await loadRegisterView(tester);

      final TextFormField emailField = findEmailField(tester);
      await tester.enterText(find.byWidget(emailField), '@domain.com');
      await tapRegister(tester);

      expect(_Descriptions.invalidEmail, findsOneWidget);
    });
  });
}
