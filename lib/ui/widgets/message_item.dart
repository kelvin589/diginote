import 'dart:math';

import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/widgets/message_item_content.dart';
import 'package:diginote/ui/widgets/message_item_paneled.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageItem extends StatefulWidget {
  const MessageItem(
      {Key? key,
      required this.message,
      required this.screenToken,
      required this.scaleFactorX,
      required this.scaleFactorY})
      : super(key: key);

  final Message message;
  final String screenToken;
  final double scaleFactorX;
  final double scaleFactorY;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool displayOptions = false;
  late final messageScaling;

  @override
  void initState() {
    super.initState();
    messageScaling = min(widget.scaleFactorX, widget.scaleFactorY);
  }

  // Since positiioning message from top left, need to account for the size
  @override
  Widget build(BuildContext context) {
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
              width: widget.message.width * messageScaling,
              height: widget.message.height * messageScaling,
            ),
          ),
          childWhenDragging: Container(),
          child: MessageItemPaneled(
            screenToken: widget.screenToken,
            message: widget.message,
            displayOptions: displayOptions,
            onDelete: onDelete,
            width: widget.message.width * messageScaling,
            height: widget.message.height * messageScaling,
          ),
          onDragEnd: (details) async {
            // Offset was not correct
            // Code adapted from here.
            // https://stackoverflow.com/questions/64114904/why-is-draggable-widget-not-being-placed-in-correct-position
            RenderBox? renderBox = context.findRenderObject() as RenderBox;
            if (renderBox != null) {
              await onDragEnd(renderBox.globalToLocal(details.offset),
                  widget.scaleFactorX, widget.scaleFactorY);
            }
          },
        ),
      ),
    );
  }

  Future<void> onDragEnd(
      Offset offset, double scaleFactorX, double scaleFactorY) async {
    setState(() {
      widget.message.x += offset.dx * scaleFactorX;
      widget.message.y += offset.dy * scaleFactorY;
    });
    await Provider.of<FirebasePreviewProvider>(context, listen: false)
        .updateMessageCoordinates(widget.screenToken, widget.message);
  }

  Future<void> onDelete() async {
    setDisplayOptions(false);
    await Provider.of<FirebasePreviewProvider>(context, listen: false)
        .deleteMessage(widget.screenToken, widget.message);
  }

  void toggleDisplayOptions() {
    setState(() {
      displayOptions = !displayOptions;
    });
  }

  void setDisplayOptions(bool newValue) {
    setState(() {
      displayOptions = newValue;
    });
  }
}
