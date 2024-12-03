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
                Text(
                  "Deadline: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(enabled ? convertDateTimeToText(date) : "No deadline"),
              ],
            ),
            Wrap(
              spacing: 20,
              children: [
                IconButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => CalendarDialog(
                            controller: widget.controller, originalDate: date),
                      );
                    },
                    icon: widget.controller.enabled
                        ? Icon(Icons.edit)
                        : Icon(Icons.add)),
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
  final DeadlineController controller;
  final DateTime originalDate;
  const CalendarDialog(
      {super.key, required this.controller, required this.originalDate});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.controller.date;

    widget.controller.addListener(() {
      setState(() {
        date = widget.controller.date;
      });
    });
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
                      widget.controller.setDate(dates[0]);
                    });
                  }),
            ),
            Divider(),
            SizedBox(
              height: height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        widget.controller.setEnabled(true);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        widget.controller.setDate(widget.originalDate);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
