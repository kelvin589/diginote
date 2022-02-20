import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewItem extends StatefulWidget {
  const PreviewItem(
      {Key? key, required this.message, required this.screenToken})
      : super(key: key);

  final Message message;
  final String screenToken;

  @override
  State<PreviewItem> createState() => _PreviewItemState();
}

class _PreviewItemState extends State<PreviewItem> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.message.x,
      top: widget.message.y,
      child: LongPressDraggable<Message>(
        feedback: Material(child:MessageItem(message: widget.message)),
        childWhenDragging: Container(),
        child: MessageItem(message: widget.message),
        onDragEnd: (details) {
          // Offset was not correct
          // Code adapted from here.
          // https://stackoverflow.com/questions/64114904/why-is-draggable-widget-not-being-placed-in-correct-position
          RenderBox? renderBox = context.findRenderObject() as RenderBox;
          if (renderBox != null) {
            onDragEnd(renderBox.globalToLocal(details.offset));
          }
        },
      ),
    );
  }

  void onDragEnd(Offset offset) {
    setState(() {
      widget.message.x += offset.dx;
      widget.message.y += offset.dy;
    });
    Provider.of<FirebasePreviewProvider>(context, listen: false)
        .updateMessageCoordinates(widget.screenToken, widget.message);
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          message.header!="" ? Text(message.header) : Container(),
          Text(message.message),
        ],
      ),
    );
  }
}
