import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/zoom_provider.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/add_message_popup.dart';
import 'package:diginote/ui/widgets/message_item.dart';
import 'package:diginote/ui/widgets/templates_view_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewView extends StatefulWidget {
  const PreviewView(
      {Key? key,
      required this.screenToken,
      required this.screenWidth,
      required this.screenHeight,
      required this.screenName,
      required this.isOnline})
      : super(key: key);

  final String screenToken;
  final double screenWidth;
  final double screenHeight;
  final String screenName;
  final bool isOnline;

  @override
  _PreviewViewState createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  @override
  void initState() {
    super.initState();
    // Let user know if screen is online when showing preview
    if (!widget.isOnline) {
      // Must delay to show snackbar in init
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "This screen '${widget.screenName}' is offline. Messages will be updated when this screen is back online."),
            action: SnackBarAction(
              label: 'Return',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Width and height of this device cosidering safe area
    final devicePadding = MediaQuery.of(context).viewPadding;
    final deviceSize = MediaQuery.of(context).size;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height -
        devicePadding.top -
        devicePadding.bottom;
    // Scaling from screen to device
    final scaleFactorX = widget.screenWidth / deviceWidth;
    final scaleFactorY = widget.screenHeight / deviceHeight;

    List<Widget> actionItems = [
      IconButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => TemplatesViewPopup(
            screenToken: widget.screenToken,
          ),
        ),
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
          title: Text(widget.screenName),
          actions: actionItems,
        ),
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(
              child: Container(
                width: deviceSize.width,
                height: deviceSize.height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: StreamBuilder<Iterable<Message>>(
                  stream: Provider.of<FirebasePreviewProvider>(context,
                          listen: false)
                      .getMessages(widget.screenToken),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error ${(snapshot.error.toString())}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    Iterable<Message>? screens = snapshot.data;
                    if (screens != null) {
                      return Stack(
                        children: _updateScreenItems(
                            context, screens, scaleFactorX, scaleFactorY),
                      );
                    } else {
                      return const Text('Error occurred');
                    }
                  },
                ),
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () =>
                      Provider.of<ZoomProvider>(context, listen: false)
                          .zoomIn(),
                  icon: IconHelper.zoomIn,
                ),
                IconButton(
                  onPressed: () =>
                      Provider.of<ZoomProvider>(context, listen: false)
                          .zoomOut(),
                  icon: IconHelper.zoomOut,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _updateScreenItems(BuildContext context,
      Iterable<Message>? messages, double scaleFactorX, double scaleFactorY) {
    if (messages != null) {
      return messages
          .map((message) => MessageItem(
              message: message,
              screenToken: widget.screenToken,
              scaleFactorX: scaleFactorX,
              scaleFactorY: scaleFactorY))
          .toList();
    }
    return [];
  }
}
