import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter/material.dart';

class PreviewItem extends StatefulWidget {
  const PreviewItem({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  State<PreviewItem> createState() => _PreviewItemState();
}

class _PreviewItemState extends State<PreviewItem> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.message.x,
      top: widget.message.y,
      child: Container(
        color: Colors.red,
        child: Draggable<Message>(
          feedback: const Icon(Icons.note),
          childWhenDragging: Container(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.message.header),
              Text(widget.message.message),
            ],
          ),
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
      ),
    );
  }

  void onDragEnd(Offset offset) {
    setState(() {
      widget.message.x += offset.dx;
      widget.message.y += offset.dy;
    });
  }
}
