import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/widgets/date_time_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSchedulePopup extends StatefulWidget {
  const AddSchedulePopup(
      {Key? key, required this.screenToken, required this.message})
      : super(key: key);

  final String screenToken;
  final Message message;

  @override
  State<AddSchedulePopup> createState() => _AddSchedulePopupState();
}

class _AddSchedulePopupState extends State<AddSchedulePopup> {
  DateTime fromDate = clock.now();
  TimeOfDay fromTime = TimeOfDay.now();
  DateTime toDate = clock.now();
  TimeOfDay toTime = TimeOfDay.now();
  bool scheduled = false;
  String? showErrorText = null;

  @override
  void initState() {
    super.initState();
    // Show current scheduling only if it isn't in the past and message is set to be scheduled
    if (widget.message.scheduled && !widget.message.to.isBefore(clock.now())) {
      fromDate = widget.message.from;
      fromTime = TimeOfDay(hour: widget.message.from.hour, minute: widget.message.from.minute);
      toDate = widget.message.to;
      toTime = TimeOfDay(hour: widget.message.to.hour, minute: widget.message.to.minute);
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

  void _setQuickOptions({required int setMinutes}) {
    DateTime dateTimeNow = clock.now();
    TimeOfDay timeOfDayNow = TimeOfDay.now();

    DateTime adjustedDateTimeNow =
        dateTimeNow.add(Duration(minutes: setMinutes));
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

  Future<void> _okPressed() async {
    DateTime from = DateTime(fromDate.year, fromDate.month, fromDate.day,
        fromTime.hour, fromTime.minute, clock.now().second);
    DateTime to = DateTime(toDate.year, toDate.month, toDate.day, toTime.hour,
        toTime.minute, clock.now().second);

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

class _QuickOptions extends StatelessWidget {
  const _QuickOptions({Key? key, required this.onOptionTapped})
      : super(key: key);

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

class _QuickItem extends StatelessWidget {
  const _QuickItem({Key? key, required this.text}) : super(key: key);

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
