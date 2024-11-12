String convertDateTimeToText(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final difference = date.difference(today).inDays;

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
