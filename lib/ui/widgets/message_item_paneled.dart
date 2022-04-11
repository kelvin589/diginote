import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/shared/timer_provider.dart';
import 'package:diginote/ui/widgets/add_message_popup.dart';
import 'package:diginote/ui/widgets/message_item_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_schedule_popup.dart';

/// A [MessageItemContent] with an [_OptionsPanel] which is displayed when tapped.
class MessageItemPaneled extends StatelessWidget {
  const MessageItemPaneled({
    Key? key,
    required this.screenToken,
    required this.message,
    this.selected = false,
    this.displayOptions = false,
    required this.onDelete,
    this.width = 100,
    this.height = 100,
    this.showTimer = true,
  }) : super(key: key);

  /// The screen token.
  final String screenToken;

  /// The message to be displayed.
  final Message message;

  /// Whether or not this widget has been selected by the user.
  final bool selected;

  /// Whether or not the [_OptionsPanel] should be displayed.
  final bool displayOptions;

  /// Called when the delete button for the message is pressed.
  final Future<void> Function() onDelete;

  /// The width of the [MessageItemContent].
  final double width;

  /// The height of the [MessageItemContent].
  final double height;

  /// Determines if the [_RemainingTimePanel] should be shown.
  final bool showTimer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        displayOptions
            ? _OptionsPanel(
                screenToken: screenToken, message: message, onDelete: onDelete)
            : Container(),
        MessageItemContent(
          message: message,
          width: width,
          height: height,
          selected: selected,
        ),
        showTimer ? _RemainingTimePanel(message: message) : Container(),
      ],
    );
  }
}

/// Displays the options panel to edit, delete or schedule a message.
class _OptionsPanel extends StatelessWidget {
  const _OptionsPanel({
    Key? key,
    required this.screenToken,
    required this.message,
    required this.onDelete,
  }) : super(key: key);

  /// The screen token.
  final String screenToken;

  /// The message to display.
  final Message message;
  
  /// Called when a meesage is deleted.
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
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddMessagePopup(
              screenToken: screenToken,
              message: message,
            ),
          ),
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

/// A panel displaying the remaining time.
class _RemainingTimePanel extends StatelessWidget {
  /// Creates a [_RemainingTimePanel] for the [message].
  const _RemainingTimePanel({
    Key? key,
    required this.message,
  }) : super(key: key);

  /// The message to be displayed.
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, value, child) {
        return Text(_scheduleText());
      },
    );
  }

  /// Determines whether to display the schedule text and to subsequently
  /// delete the [message].
  ///
  /// Scheduling may be in one of five states:
  ///	  1. From = to <= now: scheduled for now, indefinitely.
  ///   2. From = to > now: scheduled in the future, indefinitely.
  ///   3. From > now && to > now: scheduled in the future, for a set period.
  ///   4. From = now && to > from: scheduled for now, for a set period
  ///   5. From > To: displays indefinitely (invalid but it shouldn't be possible anyway).
  String _scheduleText() {
    DateTime now = clock.now();

    if (!message.scheduled) return "No Schedule";

    // from == to: displayed indefinitely.
    if (message.from.isAtSameMomentAs(message.to)) {
      // from > now: scheduled for the future.
      return message.from.isAfter(now) ? "Scheduled" : "Indefinite";
    // to > from: displayed for a set period.
    } else if (message.to.isAfter(message.from)) {
      // Calculate the difference from now until to.
      Duration difference = message.to.difference(now);

      // from > now: scheduled for the future.
      if (message.from.isAfter(now)) return "Scheduled";

      // We have not reached to.
      if (!difference.isNegative) {
        return _printDuration(difference);
      // Otherwise, the schedule has passed.
      } else if (difference.isNegative) {
        // Scheduled but schedule passed so message should be deleted.
        return "To Delete";
      }
    }

    // Some undefined from and to combination.
    return "Undefined";
  }

  // Code taken from here to represent duration as hours:minutes:seconds
  // https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
