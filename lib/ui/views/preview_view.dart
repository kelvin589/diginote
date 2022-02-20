import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/add_message_popup.dart';
import 'package:diginote/ui/widgets/preview_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewView extends StatefulWidget {
  const PreviewView({Key? key, required this.screenToken}) : super(key: key);

  final String screenToken;

  @override
  _PreviewViewState createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> actionItems = [
      IconButton(
        onPressed: () => DialogueHelper.showSuccessDialogue(
            context, 'Add Template', 'Show templates here'),
        icon: IconHelper.templatesIcon,
      ),
      IconButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddMessagePopup(
            screenToken: widget.screenToken,
          ),
        ),
        icon: IconHelper.addIcon,
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ScreenName'),
          actions: actionItems,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(MediaQuery.of(context).size);
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<Iterable<Message>>(
          stream: Provider.of<FirebasePreviewProvider>(context, listen: false)
              .getMessages(widget.screenToken),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error ${(snapshot.error.toString())}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Waiting');
            }

            Iterable<Message>? screens = snapshot.data;
            if (screens != null) {
              List<Widget> items = <Widget>[];
              items = _updateScreenItems(context, screens);
              return Stack(
                children: items,
              );
            } else {
              return const Text('Error occurred');
            }
          },
        ),
      ),
    );
  }

  List<Widget> _updateScreenItems(
      BuildContext context, Iterable<Message>? messages) {
    List<Widget> messageItems = [];

    if (messages != null) {
      for (Message message in messages) {
        messageItems.add(PreviewItem(message: message, screenToken: widget.screenToken));
      }
    }

    return messageItems;
  }
}
