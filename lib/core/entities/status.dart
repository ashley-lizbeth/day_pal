import 'package:flutter/material.dart';

class Status implements Comparable<Status> {
  static const String doing = "doing",
      blocked = "blocked",
      completed = "completed";

  String key;

  late String name;
  late IconData icon;

  Status(this.key) {
    var statusValues = _getPredeterminedValuesFromKey();
    name = statusValues.$1;
    icon = statusValues.$2;
  }

  int _getKeyValue() {
    if (key == completed) return 3;
    if (key == blocked) return 2;
    return 1;
  }

  (String, IconData) _getPredeterminedValuesFromKey() {
    if (key == completed) {
      return ("Completed", Icons.check_box);
    }

    if (key == blocked) return ("Blocked", Icons.block);

    if (key == doing) {
      return ("In progress", Icons.check_box_outline_blank);
    }

    return ("", Icons.warning);
  }

  @override
  int compareTo(Status other) {
    if (key == other.key) return 0;
    return _getKeyValue() < other._getKeyValue() ? 1 : -1;
  }
}
