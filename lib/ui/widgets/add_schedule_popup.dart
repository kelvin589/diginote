import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
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
                })
              },
              onTimeSelected: (time) => {
                setState(() {
                  fromTime = time;
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
                })
              },
              onTimeSelected: (time) => {
                setState(() {
                  toTime = time;
                })
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancelPressed,
          child: const Text('Cancel'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            await _okPressed();
          },
          child: const Text('OK'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
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
    });
  }

  void _cancelPressed() {
    Navigator.pop(context);
  }

  Future<void> _okPressed() async {
    DateTime from = DateTime(fromDate.year, fromDate.month, fromDate.day,
        fromTime.hour, fromTime.minute, fromDate.second);
    DateTime to = DateTime(
        toDate.year, toDate.month, toDate.day, toTime.hour, toTime.minute, toDate.second);
    
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
