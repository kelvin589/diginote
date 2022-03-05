import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/providers/firebase_login_provider.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/firebase_register_provider.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/views/home_view.dart';
import 'package:diginote/ui/views/login_view.dart';
import 'package:diginote/ui/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

  final FirebaseLoginProvider loginProvider = FirebaseLoginProvider(authInstance: authInstance);
  final FirebaseRegisterProvider registerProvider = FirebaseRegisterProvider(authInstance: authInstance);
  final FirebaseScreensProvider screensProvider = FirebaseScreensProvider(authInstance: authInstance, firestoreInstance: firestoreInstance);
  final FirebasePreviewProvider previewProvider = FirebasePreviewProvider(firestoreInstance: firestoreInstance);
  loginProvider.listen(authInstance);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => loginProvider),
      ChangeNotifierProvider(create: (context) => registerProvider),
      ChangeNotifierProvider(create: (context) => screensProvider),
      ChangeNotifierProvider(create: (context) => previewProvider),
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
