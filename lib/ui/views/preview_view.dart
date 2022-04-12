import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/zoom_provider.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/add_message_popup.dart';
import 'package:diginote/ui/widgets/message_item.dart';
import 'package:diginote/ui/widgets/templates_view_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The 'preview' for a screen which displays the messages current and future. 
///
/// From the preview, messages can be added, edited, deleted and scheduled.
/// Messages can be instead created from templates to save time. The preview also
/// facilitates positioning of messages by dragging and adjusting the zoom scale.
class PreviewView extends StatefulWidget {
  /// Creates a [PreviewView] to view a 'preview' of a screen.
  const PreviewView({
    Key? key,
    required this.screenToken,
    required this.screenWidth,
    required this.screenHeight,
    required this.screenName,
    required this.isOnline,
  }) : super(key: key);

  /// The token of the screen to display.
  final String screenToken;

  /// The logical pixel width of the screen.
  final double screenWidth;

  /// The logical pixel height of the screen.
  final double screenHeight;

  /// The screen's name.
  /// 
  /// This is displayed in the title.
  final String screenName;

  /// The online status of the screen.
  /// 
  /// This is used to show a snack bar if the sceen is offline when accessing
  /// the preview. This enforces the message that the screen is offline currently.
  final bool isOnline;

  @override
  _PreviewViewState createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  /// In [initState], a snack bar is shown if the screen is offline to
  /// alert users to this.
  @override
  void initState() {
    super.initState();
    // Let the user know if screen is online when showing the preview.
    if (!widget.isOnline) {
      // Must delay to show the snack bar in initState.
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
    // The parts of the display which are obscured.
    final devicePadding = MediaQuery.of(context).viewPadding;

    // The size of this device.
    final deviceSize = MediaQuery.of(context).size;

    // The width of this device, considering its safe area
    final deviceWidth = MediaQuery.of(context).size.width;

    // The height of this device, considering its safe area
    final deviceHeight = MediaQuery.of(context).size.height -
        devicePadding.top -
        devicePadding.bottom;

    // Scaling x from screen to device
    final scaleFactorX = widget.screenWidth / deviceWidth;

    // Scaling y from screen to device
    final scaleFactorY = widget.screenHeight / deviceHeight;

    // The buttons which are shown in the actions of the app bar.
    //
    // A button to insert a template or add a new message.
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

                    Iterable<Message>? messages = snapshot.data;
                    if (messages != null) {
                      // Builds a stack of MessageItems to display the messages
                      return Stack(
                        children: _updateScreenItems(
                            context, messages, scaleFactorX, scaleFactorY),
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

  /// Builds a list of widgets, which are the MessageItems, to display.
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
