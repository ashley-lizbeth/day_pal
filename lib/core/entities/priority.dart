import 'package:flutter/material.dart';

class Priority implements Comparable<Priority> {
  static const int highest = 1, high = 2, neutral = 3, low = 4, lowest = 5;

  int importance;

  late String name;
  late IconData icon;

  Priority(this.importance) {
    var values = _getPredeterminedValuesFromImportance();
    name = values.$1;
    icon = values.$2;
  }

  (String, IconData) _getPredeterminedValuesFromImportance() {
    if (importance == highest) {
      return ("Urgent", Icons.keyboard_double_arrow_up);
    }
    if (importance == high) return ("Important", Icons.keyboard_arrow_up);
    if (importance == neutral) return ("Neutral", Icons.minimize);
    if (importance == low) return ("Low priority", Icons.keyboard_arrow_down);
    if (importance == lowest) {
      return ("Lowest priority", Icons.keyboard_double_arrow_down);
    }

    return ("", Icons.warning);
  }

  @override
  int compareTo(Priority other) {
    if (other.importance == importance) return 0;
    return importance < other.importance ? 1 : -1;
  }
}
