import 'package:diginote/core/models/screen_model.dart';
import 'package:diginote/core/providers/firebase_screens_provider.dart';
import 'package:diginote/ui/widgets/screen_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreensView extends StatelessWidget {
  const ScreensView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<Screen>>(
      stream: Provider.of<FirebaseScreensProvider>(context, listen: false)
          .getScreens(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${(snapshot.error.toString())}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        Iterable<Screen>? screens = snapshot.data;
        if (screens != null) {
          List<Widget> items = screens
              .map(
                (screen) => ScreenItem(
                  screen: screen,
                ),
              )
              .toList();
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  items[index],
                  const Divider(),
                ],
              );
            },
          );
        } else {
          return const Text('Error occurred');
        }
      },
    );
  }
}
