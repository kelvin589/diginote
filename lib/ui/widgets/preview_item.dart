import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewItem extends StatefulWidget {
  const PreviewItem(
      {Key? key, required this.message, required this.screenToken, required this.scaleFactorX, required this.scaleFactorY})
      : super(key: key);

  final Message message;
  final String screenToken;
  final double scaleFactorX;
  final double scaleFactorY;

  @override
  State<PreviewItem> createState() => _PreviewItemState();
}

class _PreviewItemState extends State<PreviewItem> {
  // Since positiioning message from top left, need to account for the size
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.message.x / widget.scaleFactorX,
      top: widget.message.y / widget.scaleFactorY,
      child: LongPressDraggable<Message>(
        feedback: Material(
            child: MessageItem(selected: true, message: widget.message)),
        childWhenDragging: Container(),
        child: MessageItem(message: widget.message),
        onDragEnd: (details) {
          // Offset was not correct
          // Code adapted from here.
          // https://stackoverflow.com/questions/64114904/why-is-draggable-widget-not-being-placed-in-correct-position
          RenderBox? renderBox = context.findRenderObject() as RenderBox;
          if (renderBox != null) {
            onDragEnd(renderBox.globalToLocal(details.offset), widget.scaleFactorX, widget.scaleFactorY);
          }
        },
      ),
    );
  }

  void onDragEnd(Offset offset, double scaleFactorX, double scaleFactorY) {
    setState(() {
      widget.message.x += offset.dx * scaleFactorX;
      widget.message.y += offset.dy * scaleFactorY;
    });
    Provider.of<FirebasePreviewProvider>(context, listen: false)
        .updateMessageCoordinates(widget.screenToken, widget.message);
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({Key? key, required this.message, this.selected = false})
      : super(key: key);

  final Message message;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        border: !selected ? const Border() : Border.all(color: Colors.black),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            message.header != ""
                ? Padding(
                    child: Text(message.header),
                    padding: const EdgeInsets.only(bottom: 16.0),
                  )
                : Container(),
            Flexible(child: Text(message.message)),
          ],
        ),
      ),
    );
  }
}
