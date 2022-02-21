import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSchedulePopup extends StatefulWidget {
  const AddSchedulePopup({Key? key, required this.screenToken, required this.message})
      : super(key: key);

  final String screenToken;
  final Message message;

  @override
  State<AddSchedulePopup> createState() => _AddSchedulePopupState();
}

class _AddSchedulePopupState extends State<AddSchedulePopup> {
  DateTime fromDate = DateTime.now();
  TimeOfDay fromTime = TimeOfDay.now();
  DateTime toDate = DateTime.now();
  TimeOfDay toTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Schedule'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("From"),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _showDateSelector(
                    context: context,
                    initialDate: fromDate,
                    onSelected: (date) => {
                      setState(() {
                        fromDate = date;
                      })
                    },
                  ),
                  child: _DateItem(date: fromDate),
                ),
                GestureDetector(
                  onTap: () => _showTimeSelector(
                    context: context,
                    initialTime: fromTime,
                    onSelected: (time) => {
                      setState(() {
                        fromTime = time;
                      })
                    },
                  ),
                  child: _TimeItem(time: fromTime),
                ),
              ],
            ),
            const Text("To"),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _showDateSelector(
                    context: context,
                    initialDate: toDate,
                    onSelected: (date) => {
                      setState(() {
                        toDate = date;
                      })
                    },
                  ),
                  child: _DateItem(date: toDate),
                ),
                GestureDetector(
                  onTap: () => _showTimeSelector(
                    context: context,
                    initialTime: toTime,
                    onSelected: (time) => {
                      setState(() {
                        toTime = time;
                      })
                    },
                  ),
                  child: _TimeItem(time: toTime),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _okPressed,
          child: const Text('Cancel'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        TextButton(
          onPressed: _cancelPressed,
          child: const Text('OK'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ],
    );
  }

  void _showDateSelector(
      {required BuildContext context,
      required DateTime initialDate,
      required Function(DateTime) onSelected}) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: initialDate.add(const Duration(days: 365)),
    );
    if (date != null && date != initialDate) {
      onSelected(date);
    }
  }

  void _showTimeSelector(
      {required BuildContext context,
      required TimeOfDay initialTime,
      required Function(TimeOfDay) onSelected}) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (time != null && time != initialTime) {
      onSelected(time);
    }
  }

  void _cancelPressed() {
    Navigator.pop(context);
  }

  void _okPressed() {
    Navigator.pop(context);
  }
}

class _DateItem extends StatelessWidget {
  const _DateItem({Key? key, required this.date}) : super(key: key);

  static DateFormat dateFormat = DateFormat("d MMM y");
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          dateFormat.format(date),
        ),
      ),
    );
  }
}

class _TimeItem extends StatelessWidget {
  const _TimeItem({Key? key, required this.time}) : super(key: key);

  final TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          time.format(context),
        ),
      ),
    );
  }
}
