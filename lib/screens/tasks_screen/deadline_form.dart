import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:day_pal/core/utils/convert_datetime_to_text.dart';
import 'package:flutter/material.dart';

class DeadlineController extends ChangeNotifier {
  bool enabled = false;
  DateTime date = DateTime.now();

  void toggleEnabled() {
    enabled = !enabled;
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
          children: [
            Row(
              children: [
                Text("Deadline: "),
                Text(enabled ? convertDateTimeToText(date) : "No deadline"),
              ],
            ),
            Spacer(),
            Switch(
                value: enabled,
                onChanged: (_) => widget.controller.toggleEnabled())
          ],
        ),
        Builder(builder: (_) {
          if (enabled) {
            return CalendarDatePicker2(
              config: CalendarDatePicker2Config(),
              value: [date],
              onValueChanged: (dates) => widget.controller.setDate(dates[0]),
            );
          }
          return SizedBox();
        })
      ],
    );
  }
}
