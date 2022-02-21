import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/add_message_popup.dart';
import 'package:diginote/ui/widgets/preview_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewListView extends StatefulWidget {
  const PreviewListView({Key? key, required this.screenToken}) : super(key: key);

  final String screenToken;

  @override
  _PreviewListViewState createState() => _PreviewListViewState();
}

class _PreviewListViewState extends State<PreviewListView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> actionItems = [
      IconButton(
        onPressed: () => DialogueHelper.showSuccessDialogue(context, 'Add Template', 'Show templates here'),
        icon: IconHelper.templatesIcon,
      ),
      IconButton(
        onPressed: () => showDialog(
              context: context,
              builder: (context) => AddMessagePopup(screenToken: widget.screenToken,),
            ),
        icon: IconHelper.addIcon,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: actionItems,
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
      ),
    );
  }

  List<Widget> _updateScreenItems(
      BuildContext context, Iterable<Message>? messages) {
    List<Widget> messageItems = [];

    if (messages != null) {
      for (Message message in messages) {
        messageItems.add(
            PreviewListItem(header: message.header, message: message.message));
      }
    }

    return messageItems;
  }
}
