import 'package:flutter/material.dart';

typedef PriorityData = (String, IconData);

class Priority implements Comparable<Priority> {
  int importance;

  late String name;
  late IconData icon;

  Priority(this.importance) {
    var values = _getPredeterminedValuesFromImportance();
    name = values.$1;
    icon = values.$2;
  }

  (String, IconData) _getPredeterminedValuesFromImportance() {
    if (importance == 1) return ("Urgent", Icons.keyboard_double_arrow_up);
    if (importance == 2) return ("Important", Icons.keyboard_arrow_up);
    if (importance == 3) return ("Neutral", Icons.minimize);
    if (importance == 4) return ("Low priority", Icons.keyboard_arrow_down);
    if (importance == 5) {
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
