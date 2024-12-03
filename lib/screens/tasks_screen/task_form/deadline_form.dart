import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:day_pal/core/utils/convert_datetime_to_text.dart';
import 'package:flutter/material.dart';

class DeadlineController extends ChangeNotifier {
  bool enabled = false;
  DateTime date = DateTime.now();

  void setEnabled(bool state) {
    enabled = state;
    notifyListeners();
  }

  void setDate(DateTime date) {
    this.date = date;
    notifyListeners();
  }
}

class DeadlineForm extends StatefulWidget {
  final DeadlineController controller;
  const DeadlineForm({super.key, required this.controller});

  @override
  State<DeadlineForm> createState() => _DeadlineFormState();
}

class _DeadlineFormState extends State<DeadlineForm> {
  late DateTime date;
  late bool enabled;

  @override
  void initState() {
    enabled = widget.controller.enabled;
    date = widget.controller.date;

    widget.controller.addListener(() {
      setState(() {
        enabled = widget.controller.enabled;
        date = widget.controller.date;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Deadline: ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(enabled ? convertDateTimeToText(date) : "No deadline"),
                    if (enabled)
                      Text(TimeOfDay(hour: date.hour, minute: date.minute)
                          .format(context))
                  ],
                )
              ],
            ),
            Wrap(
              spacing: 20,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => CalendarDialog(
                                setDate: (DateTime newDate) {
                                  widget.controller.setDate(DateTime(
                                      newDate.year,
                                      newDate.month,
                                      newDate.day,
                                      date.hour,
                                      date.minute));
                                  widget.controller.setEnabled(true);
                                },
                                originalDate: date),
                          );
                        },
                        icon: widget.controller.enabled
                            ? Icon(Icons.edit)
                            : Icon(Icons.add)),
                    if (widget.controller.enabled)
                      IconButton(
                          onPressed: () async {
                            final TimeOfDay time = (await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: date.hour,
                                        minute: date.minute))) ??
                                TimeOfDay(hour: 23, minute: 59);

                            final DateTime dateWithTime = DateTime(date.year,
                                date.month, date.day, time.hour, time.minute);

                            widget.controller.setDate(dateWithTime);
                          },
                          icon: Icon(Icons.access_time))
                  ],
                ),
                Builder(builder: (_) {
                  if (!widget.controller.enabled) return SizedBox();
                  return IconButton(
                      onPressed: () {
                        widget.controller.setEnabled(false);
                        widget.controller.setDate(DateTime.now());
                      },
                      icon: Icon(Icons.delete));
                }),
              ],
            )
          ],
        )
      ],
    );
  }
}

class CalendarDialog extends StatefulWidget {
  final void Function(DateTime) setDate;
  final DateTime originalDate;
  const CalendarDialog(
      {super.key, required this.setDate, required this.originalDate});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.originalDate;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Dialog(
      child: SizedBox(
        height: height * 0.85 + 16,
        width: width * 0.8,
        child: Column(
          children: [
            SizedBox(
              height: height * 0.15,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Text(
                        "Choose a date",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(convertDateTimeToText(date))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.6,
              width: width * 0.8,
              child: CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                      calendarViewMode: CalendarDatePicker2Mode.scroll),
                  value: [date],
                  onValueChanged: (dates) {
                    setState(() {
                      date = dates[0];
                    });
                  }),
            ),
            Divider(),
            SizedBox(
              height: height * 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Cancel",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          widget.setDate(date);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.blue),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
