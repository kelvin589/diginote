import 'package:auto_size_text/auto_size_text.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageItemContent extends StatelessWidget {
  const MessageItemContent(
      {Key? key,
      required this.message,
      this.width = 100,
      this.height = 100,
      required this.selected})
      : super(key: key);

  final Message message;
  final double width;
  final double height;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: height,
        minWidth: width,
        maxHeight: height,
        maxWidth: width,
      ),
      decoration: BoxDecoration(
        color: Color(message.backgrondColour),
        border: !selected ? const Border() : Border.all(color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 7,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            message.header != ""
                ? SizedBox(
                    height: height * 0.25,
                    width: width,
                    child: AutoSizeText(
                      message.header,
                      minFontSize: 3,
                      style: GoogleFonts.getFont(message.fontFamily,
                          fontSize: message.fontSize,
                          color: Color(message.foregroundColour)),
                    ),
                  )
                : Container(),
            Expanded(
              child: Center(
                child: AutoSizeText(
                  message.message,
                  minFontSize: 3,
                  style: GoogleFonts.getFont(message.fontFamily,
                      fontSize: message.fontSize,
                      color: Color(message.foregroundColour)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
