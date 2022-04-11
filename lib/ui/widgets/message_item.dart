import 'dart:math';

import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/zoom_provider.dart';
import 'package:diginote/ui/widgets/message_item_content.dart';
import 'package:diginote/ui/widgets/message_item_paneled.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This widget adds the drag functionality to position a message. It also makes 
/// use of all the other widgets such as the sticky note, the options panel
/// and the remaining time panel.
class MessageItem extends StatefulWidget {
  const MessageItem({
    Key? key,
    required this.message,
    required this.screenToken,
    required this.scaleFactorX,
    required this.scaleFactorY,
  }) : super(key: key);

  /// The message to display.
  final Message message;

  /// The screen token.
  final String screenToken;

  /// The x scale factor.
  final double scaleFactorX;

  /// The y scale factor.
  final double scaleFactorY;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  /// Whether or not to display the options panel.
  bool displayOptions = false;

  /// The scaling to use for the message.
  late final double messageScaling;

  /// Initialises [messageScaling] by choosing the largest 
  /// scale factor in either x or y.
  @override
  void initState() {
    super.initState();
    messageScaling = max(widget.scaleFactorX, widget.scaleFactorY);
  }

  @override
  Widget build(BuildContext context) {
    // The current zoom.
    double zoom = Provider.of<ZoomProvider>(context).zoom;

    return Positioned(
      left: widget.message.x / widget.scaleFactorX,
      top: widget.message.y / widget.scaleFactorY,
      child: GestureDetector(
        onTap: toggleDisplayOptions,
        child: LongPressDraggable<Message>(
          onDragStarted: () => setDisplayOptions(false),
          feedback: Material(
            child: MessageItemContent(
              selected: true,
              message: widget.message,
              width: widget.message.width / messageScaling * zoom,
              height: widget.message.height / messageScaling * zoom,
            ),
          ),
          childWhenDragging: Container(),
          child: MessageItemPaneled(
            screenToken: widget.screenToken,
            message: widget.message,
            displayOptions: displayOptions,
            onDelete: onDelete,
            width: widget.message.width / messageScaling * zoom,
            height: widget.message.height / messageScaling * zoom,
          ),
          onDragEnd: (details) async {
            // Offset was not correct
            // Code adapted from here.
            // https://stackoverflow.com/questions/64114904/why-is-draggable-widget-not-being-placed-in-correct-position
            RenderBox? renderBox = context.findRenderObject() as RenderBox;
            await onDragEnd(renderBox.globalToLocal(details.offset),
                widget.scaleFactorX, widget.scaleFactorY);
          },
        ),
      ),
    );
  }

  /// Called after the drag gesture ends so that a message can be positioned.
  Future<void> onDragEnd(
      Offset offset, double scaleFactorX, double scaleFactorY) async {
    // Needs to undo the scale factor to original coordinates of the screen.
    setState(() {
      widget.message.x += offset.dx * scaleFactorX;
      widget.message.y += offset.dy * scaleFactorY;
    });
   
    await Provider.of<FirebasePreviewProvider>(context, listen: false)
        .updateMessageCoordinates(widget.screenToken, widget.message);
  }

  /// Called when a message is deleted.
  Future<void> onDelete() async {
    // Need to close the options panel before deleting to prevent UI bugs.
    setDisplayOptions(false);
    await Provider.of<FirebasePreviewProvider>(context, listen: false)
        .deleteMessage(widget.screenToken, widget.message);
  }

  /// Toggles displaying the options panel.
  void toggleDisplayOptions() {
    setState(() {
      displayOptions = !displayOptions;
    });
  }

  /// Sets the [displayOptions], rather than toggling.
  void setDisplayOptions(bool newValue) {
    setState(() {
      displayOptions = newValue;
    });
  }
}
