import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays a [_DateItem] and [_TimeItem] to select the date and time.
class DateTimeSelector extends StatelessWidget {
  const DateTimeSelector({
    Key? key,
    required this.date,
    required this.time,
    required this.onDateSelected,
    required this.onTimeSelected,
  }) : super(key: key);

  /// The initial date selected.
  final DateTime date;

  /// The initial time selected.
  final TimeOfDay time;

  /// Called when the date is selected.
  final void Function(DateTime) onDateSelected;

  /// Called when the time is selected.
  final void Function(TimeOfDay) onTimeSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showDateSelector(
            context: context,
            initialDate: date,
            onSelected: onDateSelected,
          ),
          child: _DateItem(date: date),
        ),
        GestureDetector(
          onTap: () => _showTimeSelector(
            context: context,
            initialTime: time,
            onSelected: onTimeSelected,
          ),
          child: _TimeItem(time: time),
        ),
      ],
    );
  }

  /// Shows the date picker.
  void _showDateSelector(
      {required BuildContext context,
      required DateTime initialDate,
      required Function(DateTime) onSelected}) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: clock.now(),
      // Limit scheduling to a year from now
      lastDate: initialDate.add(const Duration(days: 365)), 
    );
    if (date != null && date != initialDate) {
      onSelected(date);
    }
  }

  /// Shows the time picker.
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
}

/// A widget which displays the [date].
class _DateItem extends StatelessWidget {
  const _DateItem({Key? key, required this.date}) : super(key: key);

  /// The format to display the date in.
  static DateFormat dateFormat = DateFormat("d MMM y");

  /// The date to display.
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

/// A widget which displays the [time].
class _TimeItem extends StatelessWidget {
  const _TimeItem({Key? key, required this.time}) : super(key: key);

  /// The time to display.
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
