import 'package:flutter/material.dart';

class Priority implements Comparable<Priority> {
  static const int highest = 1, high = 2, neutral = 3, low = 4, lowest = 5;

  int importance;

  late String name;
  late Icon icon;

  Priority(this.importance) {
    var values = _getPredeterminedValuesFromImportance();
    name = values.$1;
    icon = values.$2;
  }

  (String, Icon) _getPredeterminedValuesFromImportance() {
    if (importance == highest) {
      return (
        "Urgent",
        Icon(
          Icons.keyboard_double_arrow_up,
          color: Colors.red,
        )
      );
    }
    if (importance == high) {
      return (
        "Important",
        Icon(
          Icons.keyboard_arrow_up,
          color: Colors.orange,
        )
      );
    }
    if (importance == neutral) {
      return (
        "Neutral",
        Icon(
          Icons.remove,
          color: Colors.grey[800],
        )
      );
    }
    if (importance == low) {
      return (
        "Low priority",
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.lightBlue,
        )
      );
    }
    if (importance == lowest) {
      return (
        "Lowest priority",
        Icon(
          Icons.keyboard_double_arrow_down,
          color: Colors.blue[800],
        )
      );
    }

    return (
      "",
      Icon(
        Icons.warning,
        color: Colors.yellow,
      )
    );
  }

  @override
  int compareTo(Priority other) {
    if (other.importance == importance) return 0;
    return importance < other.importance ? -1 : 1;
  }
}
