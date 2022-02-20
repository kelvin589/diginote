import 'package:diginote/core/providers/firebase_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await Provider.of<FirebaseLoginProvider>(context, listen: false).logout();
        },
        child: const Text("Logout"),
      ),
    );
  }
}
