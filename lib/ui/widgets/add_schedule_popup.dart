import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/widgets/date_time_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays an [AlertDialog] which allows a user to schedule a message.
///
/// Various quick options are provided to set a time in the near future. Or
/// the date and time picker can be used to select longer ranges.
class AddSchedulePopup extends StatefulWidget {
  const AddSchedulePopup({
    Key? key,
    required this.screenToken,
    required this.message,
  }) : super(key: key);

  /// The screen token.
  final String screenToken;

  /// The message to schedule.
  final Message message;

  @override
  State<AddSchedulePopup> createState() => _AddSchedulePopupState();
}

class _AddSchedulePopupState extends State<AddSchedulePopup> {
  /// The date to start from.
  DateTime fromDate = clock.now();

  /// The time to start from.
  TimeOfDay fromTime = TimeOfDay.now();

  /// The date to schedule a message until.
  DateTime toDate = clock.now();

  /// The time to schedule a message until.
  TimeOfDay toTime = TimeOfDay.now();

  /// Whether or not the message should be scheduled.
  /// 
  /// A message may be displayed immediately and not schduled.
  bool scheduled = false;

  /// Whether or not the error text should be displayed, informing the
  /// user to an error.
  /// 
  /// For example, an error may involve invalid from and to ranges.
  /// An error is displayed if [showErrorText] is not null.
  String? showErrorText;

  @override
  void initState() {
    super.initState();
    // Show current scheduling only if it isn't in the past and message is set to be scheduled
    if (widget.message.scheduled && !widget.message.to.isBefore(clock.now())) {
      fromDate = widget.message.from;
      fromTime = TimeOfDay(
          hour: widget.message.from.hour, minute: widget.message.from.minute);
      toDate = widget.message.to;
      toTime = TimeOfDay(
          hour: widget.message.to.hour, minute: widget.message.to.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: const Text('Set Schedule'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Quick Options"),
            _QuickOptions(onOptionTapped: _setQuickOptions),
            const Text("From"),
            DateTimeSelector(
              date: fromDate,
              time: fromTime,
              onDateSelected: (date) => {
                setState(() {
                  fromDate = date;
                  showErrorText = null;
                })
              },
              onTimeSelected: (time) => {
                setState(() {
                  fromTime = time;
                  showErrorText = null;
                })
              },
            ),
            const Text("To"),
            DateTimeSelector(
              date: toDate,
              time: toTime,
              onDateSelected: (date) => {
                setState(() {
                  toDate = date;
                  showErrorText = null;
                })
              },
              onTimeSelected: (time) => {
                setState(() {
                  toTime = time;
                  showErrorText = null;
                })
              },
            ),
            showErrorText != null
                ? Text(showErrorText!,
                    style: TextStyle(color: Colors.red.shade300))
                : Container(),
          ],
        ),
      ),
      actions: [
        DialogueHelper.cancelButton(context),
        DialogueHelper.okButton(() async {
          await _okPressed();
        }),
      ],
    );
  }

  /// Called when a [_QuickItem] is pressed to adjust the schedule time.
  void _setQuickOptions({required int setMinutes}) {
    DateTime dateTimeNow = clock.now();
    TimeOfDay timeOfDayNow = TimeOfDay.now();

    // Increases the time now by setMinutes.
    DateTime adjustedDateTimeNow =
        dateTimeNow.add(Duration(minutes: setMinutes));
    // Convert from DateTime to TimeOfDay to fit the field's type.
    TimeOfDay adjustedTimeOfDayNow =
        TimeOfDay.fromDateTime(adjustedDateTimeNow);

    setState(() {
      fromDate = dateTimeNow;
      fromTime = timeOfDayNow;
      toDate = dateTimeNow;
      toTime = adjustedTimeOfDayNow;
      scheduled = true;
      showErrorText = null;
    });
  }

  /// Called when 'OK' is pressed to schedule the message.
  Future<void> _okPressed() async {
    // Build from and to based on the date and time.
    DateTime from = DateTime(fromDate.year, fromDate.month, fromDate.day,
        fromTime.hour, fromTime.minute, clock.now().second);
    DateTime to = DateTime(toDate.year, toDate.month, toDate.day, toTime.hour,
        toTime.minute, clock.now().second);

    // Ensure the date and times are valid.
    if (!from.isBefore(to) && !from.isAtSameMomentAs(to)) {
      setState(() {
        showErrorText = "From must be before TO";
      });
      return;
    }

    scheduled = !(from.isAtSameMomentAs(to) && from.isBefore(clock.now()));

    await Provider.of<FirebasePreviewProvider>(context, listen: false)
        .updateMessageSchedule(
            widget.screenToken, widget.message, from, to, scheduled);

    Navigator.pop(context);
  }
}

/// Select from multiple [_QuickItem]s to quickly choose a time setting
/// when scheduling a message.
class _QuickOptions extends StatelessWidget {
  const _QuickOptions({
    Key? key,
    required this.onOptionTapped,
  }) : super(key: key);

  /// Called when a [_QuickItem] is tapped.
  final void Function({required int setMinutes}) onOptionTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onOptionTapped(setMinutes: 0),
          child: const _QuickItem(text: "None"),
        ),
        GestureDetector(
          onTap: () => onOptionTapped(setMinutes: 5),
          child: const _QuickItem(text: "5 Min"),
        ),
        GestureDetector(
          onTap: () => onOptionTapped(setMinutes: 10),
          child: const _QuickItem(text: "10 Min"),
        ),
        GestureDetector(
          onTap: () => onOptionTapped(setMinutes: 15),
          child: const _QuickItem(text: "15 Min"),
        ),
      ],
    );
  }
}

/// An option which is displayed in [_QuickOptions].
class _QuickItem extends StatelessWidget {
  const _QuickItem({Key? key, required this.text}) : super(key: key);

  /// The text for this option.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Text(text),
      ),
    );
  }
}
