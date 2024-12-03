import 'package:flutter/material.dart';

class Priority implements Comparable<Priority> {
  static const int highest = 1, high = 2, neutral = 3, low = 4, lowest = 5;

  static List<Priority> asList() {
    List<Priority> priorities = [];
    for (int i = 1; i <= 5; i++) {
      priorities.add(Priority(i));
    }
    return priorities;
  }

  int importance;

  late String name;
  late Icon icon;

  Priority(this.importance) {
    var values = _getPredeterminedValuesFromImportance();
    name = values.$1;
    icon = values.$2;
  }

  (String, Icon) _getPredeterminedValuesFromImportance() {
    String message = "";
    IconData icon = Icons.warning;
    Color? color = Colors.yellow;

    if (importance == highest) {
      message = "Urgent";
      icon = Icons.keyboard_double_arrow_up;
      color = Colors.red;
    }

    if (importance == high) {
      message = "Important";
      icon = Icons.keyboard_arrow_up;
      color = Colors.orange;
    }

    if (importance == neutral) {
      message = "Neutral";
      icon = Icons.remove;
      color = Colors.grey[800];
    }

    if (importance == low) {
      message = "Low priority";
      icon = Icons.keyboard_arrow_down;
      color = Colors.lightBlue;
    }

    if (importance == lowest) {
      message = "Lowest priority";
      icon = Icons.keyboard_double_arrow_down;
      color = Colors.blue[800];
    }

    return (
      message,
      Icon(
        icon,
        color: color,
        size: 40,
      )
    );
  }

  @override
  int compareTo(Priority other) {
    return importance.compareTo(other.importance);
  }

  @override
  int get hashCode => Object.hash(importance, name);

  @override
  bool operator ==(Object other) {
    return other is Priority && other.hashCode == hashCode;
  }
}
