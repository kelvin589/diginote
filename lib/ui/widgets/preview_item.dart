import 'package:auto_size_text/auto_size_text.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewItem extends StatefulWidget {
  const PreviewItem(
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
  State<PreviewItem> createState() => _PreviewItemState();
}

class _PreviewItemState extends State<PreviewItem> {
  bool displayOptions = false;

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
              child: MessageItem(
                  screenToken: widget.screenToken,
                  selected: true,
                  message: widget.message)),
          childWhenDragging: Container(),
          child: MessageItem(
            screenToken: widget.screenToken,
            message: widget.message,
            displayOptions: displayOptions,
          ),
          onDragEnd: (details) {
            // Offset was not correct
            // Code adapted from here.
            // https://stackoverflow.com/questions/64114904/why-is-draggable-widget-not-being-placed-in-correct-position
            RenderBox? renderBox = context.findRenderObject() as RenderBox;
            if (renderBox != null) {
              onDragEnd(renderBox.globalToLocal(details.offset),
                  widget.scaleFactorX, widget.scaleFactorY);
            }
          },
        ),
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

class MessageItem extends StatelessWidget {
  const MessageItem(
      {Key? key,
      required this.screenToken,
      required this.message,
      this.selected = false,
      this.displayOptions = false})
      : super(key: key);

  final String screenToken;
  final Message message;
  final bool selected;
  final bool displayOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        displayOptions
            ? _OptionsPanel(screenToken: screenToken, message: message)
            : Container(),
        Container(
          constraints: const BoxConstraints(
            minHeight: 100,
            minWidth: 100,
            maxHeight: 100,
            maxWidth: 100,
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            border:
                !selected ? const Border() : Border.all(color: Colors.black),
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
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      message.message,
                      minFontSize: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionsPanel extends StatelessWidget {
  const _OptionsPanel(
      {Key? key, required this.screenToken, required this.message})
      : super(key: key);

  final String screenToken;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () =>
              Provider.of<FirebasePreviewProvider>(context, listen: false)
                  .deleteMessage(screenToken, message),
          icon: IconHelper.deleteIcon,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: () => {},
          icon: IconHelper.editIcon,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: () => {},
          icon: IconHelper.scheduleIcon,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
