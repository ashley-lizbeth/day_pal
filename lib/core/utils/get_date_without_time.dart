DateTime getDateWithoutTime(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime getToday() {
  return getDateWithoutTime(DateTime.now());
}
