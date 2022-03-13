import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/providers/firebase_login_provider.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/firebase_register_provider.dart';
import 'package:diginote/core/providers/firebase_screen_info_provider.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/core/providers/io_templates_provider.dart';
import 'package:diginote/ui/views/home_view.dart';
import 'package:diginote/ui/views/login_view.dart';
import 'package:diginote/ui/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth authInstance = FirebaseAuth.instance;
  FirebaseMessaging messagingInstance = FirebaseMessaging.instance;

  final FirebaseLoginProvider loginProvider = FirebaseLoginProvider(authInstance: authInstance);
  loginProvider.listen(authInstance);

  final FirebaseRegisterProvider registerProvider = FirebaseRegisterProvider(authInstance: authInstance);
  final FirebaseScreensProvider screensProvider = FirebaseScreensProvider(authInstance: authInstance, firestoreInstance: firestoreInstance);
  final FirebasePreviewProvider previewProvider = FirebasePreviewProvider(firestoreInstance: firestoreInstance);
  final FirebaseScreenInfoProvider screenInfoProvider = FirebaseScreenInfoProvider(firestoreInstance: firestoreInstance, authInstance: authInstance);
  
  final TemplatesProvider templatesProvider = TemplatesProvider();
  await templatesProvider.init();
  
  final TokenUpdater tokenUpdater = TokenUpdater(authInstance: authInstance, messagingInstance: messagingInstance, firestoreInstance: firestoreInstance);
  await tokenUpdater.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => loginProvider),
      ChangeNotifierProvider(create: (context) => registerProvider),
      ChangeNotifierProvider(create: (context) => screensProvider),
      ChangeNotifierProvider(create: (context) => previewProvider),
      ChangeNotifierProvider(create: (context) => templatesProvider),
      ChangeNotifierProvider(create: (context) => screenInfoProvider),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: LoginView.route,
      //initialRoute: HomeView.route,
      routes: {
        HomeView.route: (context) => const HomeView(),
        LoginView.route: (_) => Consumer<FirebaseLoginProvider>(
              builder: (context, loginProvider, child) => LoginView(
                  applicationLoginState: loginProvider.applicationLoginState),
            ),
        RegisterView.route: (_) => RegisterView(
            applicationRegisterState:
                Provider.of<FirebaseRegisterProvider>(context)
                    .applicationRegisterState),
      },
    );
  }
}

class TokenUpdater {
  TokenUpdater(
      {required this.authInstance,
      required this.messagingInstance,
      required this.firestoreInstance});

  final FirebaseAuth authInstance;
  final FirebaseMessaging messagingInstance;
  final FirebaseFirestore firestoreInstance;

  String userID = "";

  Future<void> init() async {
    print("INIT");
    authInstance.userChanges().listen((User? user) {
      if (user != null) {
        userID = user.uid;
      }
    });

    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _updateToken(token);
    }
    messagingInstance.onTokenRefresh.listen(_updateToken);
  }

  Future<void> _updateToken(String token) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).set({
      'FCMTokens': FieldValue.arrayUnion([token]),
    }, SetOptions(merge: true),);
  }
}
