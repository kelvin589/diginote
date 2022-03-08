import 'package:auto_size_text/auto_size_text.dart';
import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/shared/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_schedule_popup.dart';

class MessageItemContent extends StatelessWidget {
  const MessageItemContent(
      {Key? key,
      required this.screenToken,
      required this.message,
      this.selected = false,
      this.displayOptions = false,
      required this.onDelete,
      this.width = 100,
      this.height = 100,
      this.showTimer = true})
      : super(key: key);

  final String screenToken;
  final Message message;
  final bool selected;
  final bool displayOptions;
  final Future<void> Function() onDelete;
  final double width;
  final double height;
  final bool showTimer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        displayOptions
            ? _OptionsPanel(
                screenToken: screenToken, message: message, onDelete: onDelete)
            : Container(),
        Container(
          constraints: BoxConstraints(
            minHeight: height,
            minWidth: width,
            maxHeight: height,
            maxWidth: width,
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
        showTimer ? _RemainingTimePanel(message: message) : Container(),
      ],
    );
  }
}

class _OptionsPanel extends StatelessWidget {
  const _OptionsPanel(
      {Key? key,
      required this.screenToken,
      required this.message,
      required this.onDelete})
      : super(key: key);

  final String screenToken;
  final Message message;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
              DialogueHelper.showDestructiveDialogue(
              context: context,
              title: "Delete Message",
              message: 'Are you sure you want to delete this message?',
              onConfirm: () async {
                await onDelete();
              },
            );
          },
          icon: IconHelper.deleteIcon,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: () => {},
          icon: IconHelper.editIcon,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddSchedulePopup(
              screenToken: screenToken,
              message: message,
            ),
          ),
          icon: IconHelper.scheduleIcon,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _RemainingTimePanel extends StatelessWidget {
  const _RemainingTimePanel({Key? key, required this.message})
      : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, value, child) {
        return Text(_scheduleText());
      },
    );
  }

  // Three states:
  //	1. From = to < now: no schedule
  // 	2. From = to > now: scheduled in the future for indefinite
  //  3. From > now && to > now: scheduled in the future until set time
  String _scheduleText() {
    DateTime now = clock.now();

    if (!message.scheduled) {
      return "No Schedule";
    }

    // from == to
    if (message.from.isAtSameMomentAs(message.to)) {
      if (message.from.isAfter(now)) {
        return "Scheduled";
      } else {
        return "Indefinite";
      }
    } else if (message.to.isAfter(message.from)) {
      Duration difference = message.to.difference(now);
      if (message.from.isAfter(now)) {
        return "Scheduled";
      }
      if (!difference.isNegative) {
        return _printDuration(difference);
      } else if (difference.isNegative) {
        // scheduled but schedule passed
        return "To Delete";
      }
    }

    return "Undefined";
  }

  // Code taken from here to represent duration as hours:minutes:seconds
  //https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
