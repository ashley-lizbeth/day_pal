import 'package:day_pal/core/utils/get_date_without_time.dart';
import 'package:flutter/material.dart';

String displayDateTimeWithContext(BuildContext context, DateTime date) {
  return "${convertDateTimeToText(date)}, ${TimeOfDay(hour: date.hour, minute: date.minute).format(context)}";
}

String convertDateTimeToText(DateTime date) {
  final difference = date.difference(getToday()).inDays;

  if (difference == -1) return "Yesterday";
  if (difference == 0) return "Today";
  if (difference == 1) return "Tomorrow";

  if (difference > 0 && difference < 7) {
    if (date.weekday == DateTime.monday) return "Monday";
    if (date.weekday == DateTime.tuesday) return "Tuesday";
    if (date.weekday == DateTime.wednesday) return "Wednesday";
    if (date.weekday == DateTime.thursday) return "Thursday";
    if (date.weekday == DateTime.friday) return "Friday";
    if (date.weekday == DateTime.saturday) return "Saturday";
    if (date.weekday == DateTime.sunday) return "Sunday";
  }

  return date.toLocal().toString().split(' ')[0];
}
