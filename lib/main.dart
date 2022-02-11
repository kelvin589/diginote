import 'package:diginote/core/providers/firebase_login_provider.dart';
import 'package:diginote/core/providers/firebase_register_provider.dart';
import 'package:diginote/core/providers/login_provider.dart';
import 'package:diginote/core/providers/register_provider.dart';
import 'package:diginote/ui/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final LoginProvider loginProvider = FirebaseLoginProvider();
  final RegisterProvider registerProvider = FirebaseRegisterProvider();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => loginProvider),
      ChangeNotifierProvider(create: (context) => registerProvider),
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
        primarySwatch: Colors.yellow,
      ),
      home: const LoginView(),
    );
  }
}
